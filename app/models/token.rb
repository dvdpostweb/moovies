# == Schema Information
#
# Table name: tokens
#
#  id           :integer          not null, primary key
#  token        :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  customer_id  :integer
#  code         :string(255)
#  imdb_id      :integer
#  count_ip     :integer          default(2)
#  is_ppv       :boolean          default(FALSE)
#  ppv_price    :float            default(0.0), not null
#  compensed    :integer          default(0)
#  source_id    :integer
#  country      :string(3)
#  kind         :string(10)       default("NORMAL")
#  season_id    :integer          default(0), not null
#  episode_id   :integer          default(0), not null
#  payment_kind :string(12)
#  videoland    :boolean          default(FALSE)
#

require "uri"
require 'net/https'

class Token < ActiveRecord::Base
  belongs_to :customer, :primary_key => :customers_id
  has_many :streaming_products, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :streaming_products_free, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :token_ips
  has_many :products, :primary_key => [:imdb_id, :season_id, :episode_id], :foreign_key => [:imdb_id, :season_id, :episode_id]
  belongs_to :product, :primary_key => [:imdb_id, :season_id, :episode_id], :foreign_key => [:imdb_id, :season_id, :episode_id]

  after_create :generate_token

  validates_presence_of :imdb_id

  scope :available, lambda { |from, to| where(:created_at => from..to) }
  scope :expired, lambda { |to| where("created_at < ?", to) }

  scope :recent, lambda { |from, to| where(:created_at => from..to) }
  scope :by_primary, lambda { |imdb_id, season_id, episode_id| where(:imdb_id => imdb_id, :season_id => season_id, :episode_id => episode_id) }

  scope :ordered, :order => 'tokens.created_at asc'
  scope :ordered_old, :order => 'tokens.created_at desc'

  scope :created_in_the_last_two_days, where("created_at > ?", Time.now - 2.days)

  def self.regen
    Token.recent(2.days.ago.localtime, Time.now).each do |token|
      filename = token.streaming_products.alpha.first.filename
      puts filename
      token_string = Moovies.generate_token_from_alpha(filename, :normal)
      puts token_string
      token.update_attribute(:token, token_string)
    end
  end

  def create_token_code(imdb_id, kind)
    file = StreamingProduct.where(:imdb_id => imdb_id).first
    begin
      token_string = "#{file.hd? ? '4' : '3'}/i/" + imdb_id.to_s
    rescue => e
      token_string = false
    end
    if token_string
      update_attribute(:token, token_string)
      return true
    else
      return false
    end
  end

  def self.create_token(imdb_id, product, current_ip, streaming_product_id, season_id, episode_id, kind, customer = nil, source = 7, code = nil)
    file = StreamingProduct.find(streaming_product_id)
    if code
      streaming_code = StreamingCode.by_name(code).first
      StreamingCode.by_name(code).first.update_attribute(:used_at, Time.now.localtime) if streaming_code.used_at.nil?
      token = Token.find(19959)
      return {:token => token, :error => nil}
    else
      begin
        #token_string = Moovies.generate_token_from_alpha(file.filename, kind, false)
        token_string = "#{file.hd? ? '4' : '3'}/i/" + file.imdb_id.to_s
      rescue => e
        token_string = false
      end

      if token_string
        params = {:imdb_id => imdb_id, :token => token_string, :source_id => source, :country => file.country, :payment_kind => 'NONE', :season_id => season_id, :episode_id => episode_id, :videoland => file.videoland}
        params = params.merge(:ppv_price => file.ppv_price, :kind => 'PPV', :is_ppv => true, :payment_kind => 'POSTPAID') if !file.svod?
        logger.debug("@@@#{customer.tvod_free} #{file.tvod_credits} #{!file.svod?}")
        if file.prepaid?
          params = params.merge(:kind => 'PREPAID')
        elsif customer.tvod_free >= file.tvod_credits && !file.svod?
          logger.debug 'here'
          customer.update_column(:tvod_free, customer.tvod_free - file.tvod_credits)
          params = params.merge(:kind => 'FREE', :payment_kind => 'NONE')
        end
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
    created_at < 48.hours.ago.localtime
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
