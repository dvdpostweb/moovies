require "uri"
require 'net/https'

class Token < ActiveRecord::Base
  belongs_to :customer, :primary_key => :customers_id
  has_many :streaming_products, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :streaming_products_free, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :token_ips
  has_many :products, :foreign_key => :imdb_id, :primary_key => :imdb_id

  after_create :generate_token

  validates_presence_of :imdb_id

  scope :available, lambda {|from, to| where(:updated_at => from..to)}
  scope :expired, lambda {|to| where("updated_at < ?", to)}
  
  scope :recent, lambda {|from, to| where(:updated_at => from..to)}
  scope :by_imdb_id, lambda {|imdb_id| where(:imdb_id => imdb_id)}
  
  scope :ordered, :order => 'tokens.updated_at asc'
  scope :ordered_old, :order => 'tokens.updated_at desc'

  def self.regen
    Token.recent(2.days.ago.localtime, Time.now).each do |token|
      filename = token.streaming_products.alpha.first.filename
      puts filename
      token_string = Moovies.generate_token_from_alpha(filename, :normal)
      puts token_string
      token.update_attribute(:token, token_string)
    end
  end
  
  def self.create_token(imdb_id, product, current_ip, streaming_product_id, kind, customer = nil, source = 7, code = nil)
    file = StreamingProduct.find(streaming_product_id)
    if code
      StreamingCode.by_name(code).first.update_attribute(:used_at, Time.now.localtime) if StreamingCode.by_name(code).first.used_at.nil?
      token = Token.find(16703)
      return {:token => token, :error => nil}
    else
      begin
        token_string = Moovies.generate_token_from_alpha(file.filename, kind, false)
      rescue => e
        token_string = false
      end

      if token_string
        params = {:imdb_id => imdb_id, :token => token_string, :source_id => source, :country => file.country}
        params = params.merge(:ppv_price => file.ppv_price, :kind => 'PPV', :is_ppv => true) if !file.svod?
        Rails.logger.debug { "@@@#{file.prepaid?}" }
        params = params.merge(:kind => 'PREPAID') if file.prepaid?
        
        params = params.merge(:customer_id => customer.id) if customer
        params = params.merge(:code => code) if code
          
        token = Token.create(params)
        if token.id.blank?
          self.notify_error_token((customer ? customer.id : 0), Token.error[:query_rollback])
          return {:token => nil, :error => Token.error[:query_rollback]}
        else
          return {:token => token, :error => nil}
        end
      else
        self.notify_error_token((customer ? customer.id : 0), Token.error[:generation_token_failed])
        return {:token => nil, :error => Token.error[:generation_token_failed]}
      end
    end
  end
  
  def self.validate(token_param, filename, ip)
    
    token = self.available(2.days.ago.localtime..Time.now).find_by_token(token_param)
    if token
      filename = "mp4:#{filename}"
      filename_select = StreamingProduct.by_filename(filename).all(:include => :tokens, :conditions => ['tokens.id = ?', token.id])
      token_ips = token.token_ips
      select = token_ips.find_by_ip(ip)
    end
    if token && select && !filename_select.blank?
      1
    else
      0
    end
  end

  def self.dvdpost_ip?(client_ip)
    if client_ip == Moovies.dvdpost_ip[:internal]
      return true
    else
      Moovies.dvdpost_ip[:external].each do |external|
        if client_ip == external
          return true
        end
      end
      return false
    end
  end
  
  def self.error
    error = OrderedHash.new
    error.push(:bad_package, 1)
    error.push(:no_credit_card, 2)
    error.push(:query_rollback, 3)
    error.push(:user_suspended, 4)
    error.push(:generation_token_failed, 5)
    error.push(:customer_not_activated, 6)
    error.push(:code_expired, 7)
    
    error
  end

  def self.status
    status = OrderedHash.new
    status.push(:ok, 1)
    status.push(:ip_valid, 2)
    status.push(:ip_invalid, 3)
    status.push(:expired, 4)

    status
  end

  def expired?
    updated_at < 48.hours.ago.localtime
  end

  def current_status(current_ip)
    
    return Token.status[:expired] if expired?
    return Token.status[:ok] if streaming_products.alpha.count > 0
    return Token.status[:ip_valid] if current_ips.count < count_ip 
    return Token.status[:ip_invalid]
  end
  
  def validate?(current_ip)
    token_status = current_status(current_ip)
    return token_status == Token.status[:ok] || token_status == Token.status[:ip_valid]
  end

  
  def self.notify_error_token(customer_id, error)
    begin
      Rails.logger.debug { "@@@errror #{customer_id} #{error}" }
      Airbrake.notify(:error_message => "customer #{customer_id}  #{error}", :backtrace => $@, :environment_name => ENV['RAILS_ENV'])
    rescue => e
      logger.error("customer: #{to_param} #{error}")
      logger.error(e.backtrace)
    end
  end
  private
  def generate_token
    if token.nil?
      update_attribute(:token, Digest::SHA1.hexdigest((created_at.to_s) + (97 * created_at.to_i).to_s))
    end
  end
end