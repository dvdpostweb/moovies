# == Schema Information
#
# Table name: customers
#
#  customers_id                              :integer          not null, primary key
#  group_id                                  :integer          default(1), not null
#  customers_gender                          :string(1)        default("m"), not null
#  customers_firstname                       :string(32)       default(""), not null
#  customers_lastname                        :string(32)       default(""), not null
#  customers_dob                             :datetime
#  email                                     :string(96)       default(""), not null
#  encrypted_password                        :string(255)      default(""), not null
#  customers_default_address_id              :integer          default(1), not null
#  customers_telephone                       :string(32)       default(""), not null
#  customers_newsletter                      :integer          default(0)
#  customers_newsletterpartner               :integer          default(0)
#  customers_abo                             :integer          default(0), not null
#  customers_abo_suspended                   :integer          default(0), not null
#  customers_abo_type                        :integer          default(0), not null
#  customers_next_abo_type                   :integer          default(0), not null
#  customers_abo_validityto                  :datetime
#  customers_abo_discount_recurring_to_date  :date
#  customers_abo_payment_method              :integer          default(0), not null
#  adult_pwd                                 :string(50)
#  ogone_card_type                           :string(50)
#  ogone_card_no                             :string(50)
#  ogone_exp_date                            :string(50)
#  ogone_owner                               :string(255)
#  ogone_cc_expiration_status                :integer          default(0), not null
#  activation_discount_code_id               :integer          default(0)
#  activation_discount_code_type             :string(2)
#  customers_next_discount_code              :integer          default(0)
#  customers_registration_step               :integer          default(31), not null
#  customers_abo_auto_stop_next_reconduction :integer          default(0), not null
#  customers_language                        :integer          default(3), not null
#  is_email_valid                            :integer          default(1)
#  sleep                                     :boolean          default(FALSE), not null
#  filter_id                                 :integer
#  nickname                                  :string(255)
#  reset_password_token                      :string(255)
#  reset_password_sent_at                    :datetime
#  remember_created_at                       :datetime
#  sign_in_count                             :integer          default(0)
#  current_sign_in_at                        :date
#  last_sign_in_at                           :date
#  current_sign_in_ip                        :string(255)
#  last_sign_in_ip                           :string(255)
#  created_at                                :datetime
#  updated_at                                :datetime
#  confirmation_token                        :string(255)
#  confirmed_at                              :datetime
#  confirmation_sent_at                      :datetime
#  unconfirmed_email                         :string(255)
#  sexuality                                 :integer          default(0)
#  mail_copy                                 :integer          default(1)
#  customers_locked__for_reconduction        :integer          default(0), not null
#  welcomecall_hour                          :integer
#  welcomecall_done                          :integer          default(0)
#  welcomecall_day                           :date
#  tvod_free                                 :integer          default(0)
#  credits_already_recieved                  :integer          default(0)
#  social_network_tag                        :string(45)
#  facebook_activation                       :integer
#  preselected_registration_moovie_id        :integer
#  paypal_agreement_id                       :string(50)
#   wister                                   :integer
#

class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable
  # :lockable, :timeoutable and :omniauthable

  self.primary_key = :customers_id
  after_save :set_samsung
  before_save :get_code_from_samsung
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  alias_attribute :abo_active, :customers_abo
  alias_attribute :last_name, :customers_lastname
  alias_attribute :first_name, :customers_firstname
  alias_attribute :language, :customers_language
  alias_attribute :suspension_status, :customers_abo_suspended
  alias_attribute :address_id, :customers_default_address_id
  alias_attribute :subscription_expiration_date, :customers_abo_validityto
  alias_attribute :newsletter, :customers_newsletter
  alias_attribute :newsletter_parnter, :customers_newsletterpartner
  alias_attribute :phone, :customers_telephone
  alias_attribute :birthday, :customers_dob
  alias_attribute :gender, :customers_gender
  alias_attribute :payment_method, :customers_abo_payment_method
  alias_attribute :abo_type_id, :customers_abo_type
  alias_attribute :auto_stop, :customers_abo_auto_stop_next_reconduction
  alias_attribute :next_abo_type_id, :customers_next_abo_type
  alias_attribute :promo_type, :activation_discount_code_type
  alias_attribute :next_promo_id, :customers_next_discount_code
  alias_attribute :promo_id, :activation_discount_code_id
  alias_attribute :recurring_until, :customers_abo_discount_recurring_to_date

  alias_attribute :step, :customers_registration_step
  alias_attribute :locked, :customers_locked__for_reconduction
  alias_attribute :preselected_moovie, :preselected_registration_moovie_id
  validates_length_of :first_name, :minimum => 2, :on => :publish, :if => :svod?
  validates_length_of :last_name, :minimum => 2, :on => :publish, :if => :svod?
  validates_format_of :phone, :with => /^(\+)?[0-9 \-\/.]+$/, :on => :publish, :if => :svod?
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :update
  validates :birthday, :date => {:after => 100.years.ago, :before => 18.years.ago}, :on => :publish, :if => :svod?
  validates :email, :uniqueness => {:message => :taken2, :case_sensitive => false}, :on => :update


  validates_presence_of :email, :on => :create
  validate :email_tvod_only, :on => :create
  validate :email_step, :on => :create
  validate :email_abo, :on => :create
  validate :email_all_cust, :on => :create
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  validates_presence_of :password, :if => :password_required?
  validates_confirmation_of :password, :if => :password_required?
  validates_length_of :password, :within => 8..128, :allow_blank => true, :on => :create
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :newsletter, :newsletter_parnter, :last_name, :first_name, :language, :address_id, :phone, :birthday, :gender, :abo_type_id, :customers_abo_type, :auto_stop, :customers_abo_auto_stop_next_reconduction, :next_abo_type_id, :customers_next_abo_type, :promo_type, :activation_discount_code_type, :promo_id, :nickname, :code, :customers_dob, :address_attributes, :step, :ogone_owner, :ogone_exp_date, :ogone_card_no, :ogone_card_type, :customers_abo_payment_method, :customers_abo, :customers_registration_step, :subscription_expiration_date, :auto_stop, :customers_abo_discount_recurring_to_date, :filter_id, :samsung, :new_email, :customers_locked__for_reconduction
  attr_accessor :code
  attr_accessor :samsung
  attr_accessor :new_email

  belongs_to :subscription_type, :foreign_key => :customers_abo_type
  belongs_to :next_subscription_type, :class_name => 'SubscriptionType', :foreign_key => :customers_next_abo_type
  belongs_to :address, :foreign_key => [:customers_id, :customers_default_address_id]
  belongs_to :subscription_payment_method, :foreign_key => :customers_abo_payment_method
  belongs_to :discount, :foreign_key => :activation_discount_code_id
  belongs_to :activation, :foreign_key => :activation_discount_code_id

  belongs_to :product_abo, :foreign_key => :customers_abo_type
  belongs_to :product, :foreign_key => :customers_abo_type
  belongs_to :product_next_abo, :class_name => 'ProductAbo', :foreign_key => :customers_next_abo_type
  belongs_to :product_next, :class_name => 'Product', :foreign_key => :customers_next_abo_type

  has_one :subscription, :foreign_key => :customerid, :conditions => {:action => [1, 6, 8]}, :order => 'date DESC'
  has_many :ratings, :foreign_key => :customers_id
  has_many :rated_products, :through => :ratings, :source => :product, :uniq => true
  has_many :reviews, :foreign_key => :customers_id
  has_many :uninteresteds, :foreign_key => :customers_id
  has_many :uninterested_products, :through => :uninteresteds, :source => :product, :uniq => true
  has_many :messages, :foreign_key => :customers_id
  has_many :tickets
  has_many :addresses, :foreign_key => :customers_id
  has_many :payment, :foreign_key => :customers_id
  has_many :subscriptions, :foreign_key => :customerid, :conditions => {:action => [1, 6, 8]}, :order => 'date DESC', :limit => 1
  has_many :actions, :foreign_key => :customerid, :class_name => 'Subscription'
  has_many :tokens
  has_many :suspensions
  has_many :samsung_codes
  has_many :discount_use, :foreign_key => :customers_id

  has_many :vod_wishlists
  has_many :vod_wishlists_histories

  accepts_nested_attributes_for :address, :allow_destroy => true

  has_and_belongs_to_many :seen_products, :class_name => 'Product', :join_table => :products_seen, :uniq => true
  has_many :products, :through => :vod_wishlists

  has_many :authentications, :dependent => :delete_all
  has_one :mobistar

  has_many :orange_sms_activation_codes

  #after_save :setup_abt_6_null

  def unlimted_subscriber?
    (customers_abo_type == 1 || customers_abo_type == 2 || customers_abo_type == 3 || customers_abo_type == 4 || customers_abo_type == 5)
  end

  def plush_la_carte_subscriber?
    (customers_abo_type == 7 || customers_abo_type == 8 || customers_abo_type == 9 || customers_abo_type == 10 || customers_abo_type == 11)
  end

  def abo_subscriber?
    (customers_abo_type == 6 && activation_discount_code_type == "D")
  end

  def mobistar_subscriber?
    (customers_abo_type == 6 && activation_discount_code_type == "A")
  end

  def bnppf_subscriber?
    (customers_abo_type == 6 && activation_discount_code_type == "A" && Activation.where(:activation_id => self.activation_discount_code_id).where(:activation_group => 22))
  end

  def have_freetrial_codes?
    (activation_discount_code_id == 263 || activation_discount_code_id == 264 || activation_discount_code_id == 265)
  end

  def orange_or_wister?
    (customers_abo_payment_method == 5 || customers_abo_payment_method == 6 || customers_abo_payment_method == 7 || wister == 1)
  end

  def orange_customer?
    (customers_abo_payment_method == 5 || customers_abo_payment_method == 6 || customers_abo_payment_method == 7)
  end

  def dont_have_credits?
    tvod_free == 0
  end

  def have_credits?
    tvod_free > 0
  end

  #def can_change_subscription?
  #  (self.next_subscription_change_posibile_at > self.subscription_changed_at)
  #end

  #after_create :setup_step

  def apply_omniauth(auth)
    self.email = auth['extra']['raw_info']['email'] if  auth['extra']['raw_info']['email'].present?
    self.customers_firstname = auth['extra']['raw_info']['first_name'] if auth['extra']['raw_info']['first_name'].present?
    self.customers_lastname = auth['extra']['raw_info']['last_name'] if auth['extra']['raw_info']['last_name'].present?
    self.customers_gender = auth['extra']['raw_info']['gender'] if auth['extra']['raw_info']['gender'].present?
    self.social_network_tag = auth['provider']
    #authentications.build(:provider => auth['provider'], :uid => auth['uid'], :token => auth['credentials']['token'], :email => auth['extra']['raw_info']['email'])
  end

  def get_code_from_samsung
    if self.samsung
      samsung_code = SamsungCode.available.find_by_code(self.samsung)
      if samsung_code
        self.code = samsung_code.promotion
      else
        self.code = Discount.find(Moovies.discount["svod_#{I18n.locale}"]).name
      end
    end
  end

  def set_samsung
    if self.samsung
      samsung_code = SamsungCode.available.find_by_code(self.samsung)
      if samsung_code
        samsung_code.update_attributes(:customer_id => self.id, :used_at => Time.now())
        self.code = samsung_code.promotion
      else
        self.code = Discount.find(Moovies.discount["svod_#{I18n.locale}"]).name
      end
    end
  end

  def code
    @code
  end

  def code=(code)
    @code = code
    @discount = Discount.by_name(code).available.first
    @activation = Activation.by_name(code).available.first
    if @discount.nil? && @activation.nil?
      @discount = Discount.find(Moovies.discount["svod_#{I18n.locale}"])
    end
    if @discount
      self.promo_type = 'D'
      self.promo_id = @discount.id
      self.abo_type_id = @discount.abo_type_id
      self.next_abo_type_id = @discount.next_abo_type_id
      self.group_id = @discount.group_id
    elsif @activation
      self.promo_type = 'A'
      self.promo_id = @activation.id
      self.abo_type_id = @activation.abo_type_id
      self.next_abo_type_id = @activation.next_abo_type_id
      self.group_id = @activation.group_id
      self.next_promo_id = @activation.next_discount_id
    end
  end

  def registration_code=(code)
    @code = code
    @discount = Discount.by_name(code).available.first
    @activation = Activation.by_name(code).available.first
    if @discount
      self.promo_type = 'D'
      self.promo_id = @discount.id
      self.abo_type_id = @discount.abo_type_id
      self.next_abo_type_id = @discount.next_abo_type_id
      self.group_id = @discount.group_id
      self.step = @discount.goto_step
      self.tvod_free = @discount.tvod_free
      self.customers_abo = 1
    elsif @activation
      self.promo_type = 'A'
      self.promo_id = @activation.id
      self.abo_type_id = @activation.abo_type_id
      self.next_abo_type_id = @activation.next_abo_type_id
      self.group_id = @activation.group_id
      self.next_promo_id = @activation.next_discount_id
      self.step = 100
      self.tvod_free = @activation.tvod_free
      self.customers_abo = 1
    end
  end

  def registration_code_freetrialR=(code)
    @code = code
    @discount = Discount.by_name(code).available.first
    if @discount
      self.promo_type = 'D'
      self.promo_id = @discount.id
      self.abo_type_id = @discount.abo_type_id
      self.next_abo_type_id = @discount.next_abo_type_id
      self.group_id = @discount.group_id
      self.step = @discount.goto_step
      self.tvod_free = @discount.tvod_free
      self.customers_abo = 1
      self.step = 33
      self.customers_abo_validityto = Time.now + 1.month
    end
  end

  def registration_code_freetrialL=(code)
    @code = code
    @discount = Discount.by_name(code).available.first
    if @discount
      self.promo_type = 'D'
      self.promo_id = @discount.id
      self.abo_type_id = @discount.abo_type_id
      self.next_abo_type_id = @discount.next_abo_type_id
      self.group_id = @discount.group_id
      self.step = @discount.goto_step
      self.customers_abo = 1
      self.customers_abo_validityto = Time.now + 1.month
      if self.payable?
        self.step = 100
      else
        self.step = 33
      end
    end
  end

  def email_change
    if self.email != self.new_email
      self.is_email_valid = 1
    end
  end

  def not_rated_products(kind)
    if kind == :adult
      seen = seen_products.adult_available
      list = tokens.collect(&:imdb_id).join(',')
      vod_seen = !list.empty? ? Product.group_by_imdb.adult_available.by_imdb_ids([list]) : nil
    else
      seen = seen_products.normal_available
      list = tokens.collect(&:imdb_id).join(',')
      vod_seen = !list.empty? ? Product.group_by_imdb.normal_available.by_imdb_ids([list]) : nil
    end
    rated = rated_products
    p = vod_seen ? vod_seen + seen - rated : seen - rated
  end

  def has_rated?(product)
    if product.imdb_id > 0
      rated_products.exists?(:imdb_id => product.imdb_id)
    else
      rated_products.exists?(product)
    end
  end

  def active?
    (abo_active? && suspension_status == 0)
  end

  def payment_suspended?
    suspension_status == 2
  end

  def holidays_suspended?
    suspension_status == 1
  end

  def tvod_only?
    abo_type_id == 6
  end

  def tvod_credits?
    subscription_type.tvod_credits > 0
  end

  def next_tvod_credits?
    next_subscription_type.tvod_credits > 0
  end

  def svod?
    abo_type_id != 6
  end
  def abo_svod?
    subscription_type.packages_ids.split(',').include?([1,4])
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_without_accent
    name.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
  end

  def subscription_description
    subscription_type.description
  end

  def next_subscription_description
    next_subscription_type.description
  end

  def recondutction_ealier?
    !actions.reconduction_ealier.recent.blank?
  end

  def reconduction_now
    update_attribute(:auto_stop, 0)
    update_attribute(:subscription_expiration_date, Time.now().localtime.to_s(:db))
    #update_attribute(:credits_already_recieved, 1)
    abo_history(Subscription.action[:reconduction_ealier])

    manage_credits(next_subscription_type, 15)
  end

  def manage_credits(subscription, action)
    update_attribute(:tvod_free, subscription.tvod_credits) if subscription.tvod_credits > 0
  end

  #def recommendations(filter, options)
  #  begin
  #    # external service call can't be allowed to crash the app
  #    #recommendation_ids = DVDPost.home_page_recommendations_new(self.to_param, options[:kind])
  #    data = DVDPost.home_page_recommendations(self.to_param, I18n.locale)
  #    recommendation_ids = data[:dvd_id]
  #    response_id = data[:response_id]
  #    url = data[:url]
  #    results = if recommendation_ids
  #      hidden_ids = (rated_products + seen_products + wishlist_products + uninterested_products).uniq.collect(&:id)
  #      result_ids = recommendation_ids - hidden_ids
  #      #result_ids = recommendation_ids
  #      filter.update_attributes(:recommended_ids => result_ids)
  #      options.merge!(:subtitles => [2]) if I18n.locale == :nl
  #      options.merge!(:audio => [1]) if I18n.locale == :fr
  #      {:recommendation => Product.filter(filter, options.merge(:view_mode => :recommended)), :response_id => response_id}
  #    else
  #      []
  #    end
  #  rescue => e
  #    logger.error("Failed to retrieve recommendations: #{e.message}")
  #    {:recommendation => false, :response_id => false}
  #  end
  #end

  def self.send_evidence(type, product_id, customer, request, params = nil, args = nil)
    begin
      ip = request.remote_ip
      product_id = product_id.to_s.gsub(/-.*/, '')
      if params[:response_id]
        params[:responseid] = params[:response_id]
        params.delete :response_id
      end
      url = DVDPost.send_evidence_recommendations(type, product_id, customer, ip, params, args)
      unless @bot
        message = ""
        message += " user #{customer.id}" if customer
        message += " url #{url}"
        message += " date #{Time.now.strftime("%Y-%m-%d %H:%M") }"
        message += " params #{params.inspect}"
        message += " request #{request.host}#{request.fullpath}"
        message += " referer #{request.referer}" if request.referer
        message += " user agent #{request.env['HTTP_USER_AGENT']}\n\r" if request.env['HTTP_USER_AGENT']
        target = "log/check_thefilter.log"
        File.open(target, "a+") do |f|
          f.write(message)
        end
      end
    rescue => e
      logger.error("Failed to send evidence: #{e.message}")
    end
  end

  def popular(filter, options={})
    options.merge!(:subtitles => [2]) if I18n.locale == :nl
    options.merge!(:audio => [1]) if I18n.locale == :fr
    popular = Product.filter(filter, options.merge(:view_mode => :popular))
    hidden_products = (rated_products + seen_products + wishlist_products + uninterested_products)
    pop = popular - hidden_products
  end

  def streaming(filter, options={})
    popular_vod = Product.filter(filter, options.merge(:view_mode => :streaming, :sort => 'token', :not_soon => 1))
    hidden_products = (rated_products + seen_products + wishlist_products + uninterested_products)
    pop = popular_vod - hidden_products
  end

  def newsletter!(type, value)
    if type == 'newsletter_parnter'
      update_attribute(:newsletter_parnter, value)
    else
      update_attribute(:newsletter, value)
    end
  end

  def suspended?
    suspension_status != 0
  end

  def locale
    loc = Moovies.customer_languages.invert[language]
    loc.to_sym if loc
  end

  def locale=(new_locale)
    language_id = Moovies.customer_languages[new_locale] || Moovies.customer_languages[:fr]
    update_attribute(:customers_language, language_id)
  end

  def update_locale(new_locale)
    new_locale ||= locale
    update_attribute(:customers_language, (Moovies.customer_languages[new_locale] || :fr))
    locale = new_locale.blank? ? :fr : new_locale
  end

  def get_credits()
    credit_histories.last
  end

  def get_token(imdb_id, season_id, episode_id)
    tokens.recent(2.week.ago.localtime, Time.now).by_primary(imdb_id, season_id, episode_id).last
  end


  def get_all_tokens(kind = nil, type = nil, page = 1)
    if type == :old
      tokens.expired(48.hours.ago.localtime).select('distinct tokens.*, count(distinct tokens.id) count_tokens').group('tokens.id').ordered_old.joins(:products).where(:products => {:products_type => Moovies.product_kinds[kind]}).paginate(:per_page => 20, :page => page)
    else
      if !kind.nil?
        tokens.available(48.hours.ago.localtime, Time.now).select('distinct tokens.*').ordered.joins(:streaming_products, :products).where(:streaming_products => {:available => 1}, :products => {:products_type => Moovies.product_kinds[kind]})
      else
        tokens.available(48.hours.ago.localtime, Time.now).select('distinct tokens.*').ordered.joins(:streaming_products, :products).where(:streaming_products => {:available => 1})
      end
    end
  end

  def remove_product_from_wishlist(imdb_id, season_id, episode_id, current_ip)
    if vod_wishlists && vod_wishlists.by_primary(imdb_id, season_id, episode_id).count > 0
      vod = vod_wishlists.by_primary(imdb_id, season_id, episode_id).first
      vod_wishlists_histories.create(:imdb_id => vod.imdb_id, :source_id => vod.source_id, :added_at => vod.created_at)
      vod.destroy()
    end
  end

  def abo_history(action, new_abo_type = 0, activation_code_id = 0)
    if activation_code_id.to_i > 0
      code_id = activation_code_id
    elsif action == 6 || action == 8 || action == 35
      code_id = self.promo_id
    else
      code_id = nil
    end
    Subscription.create(:customer_id => self.to_param, :Action => action, :Date => Time.now().to_s(:db), :product_id => (new_abo_type.to_i > 0 ? new_abo_type : self.abo_type_id), :site => 1, :payment_method => subscription_payment_method.name, :code_id => code_id)
  end

  def is_freetest?
    if abo_active == 1 && actions.reconduction.length > 0 && actions.reconduction.last.action == 7
      false
    else
      true
    end
  end

  def nederlands?
    address.country_id == 150
  end

  def actived?
    abo_active == 1
  end

  def display_vod(status)
    update_attribute(:display_vod, status)
  end


  def price_per_month
    if subscription_type
      subscription_type.product.price
    else
      notify_hoptoad()
      '0'
    end
  end

  def next_price_per_month
    if next_subscription_type
      next_subscription_type.product.price
    else
      notify_hoptoad()
      '0'
    end
  end

  def get_list_abo(force_group = nil)
    if force_group
      group = force_group
    else
      if self.new_price?
        group = 6
      else
        group = 1
      end
    end
    ProductAbo.get_list(group)
  end

  def get_next_list_abo
    if self.next_new_price?
      group = 6
    else
      group = 1
    end
    ProductAbo.get_list(group)
  end

  def super_user?
    Moovies.super_user.each do |super_id|
      if to_param.to_i == super_id.to_i
        return true
      end
    end
    return false
  end

  def image(type = :accepted)
    if type == :accepted
      File.join('avatars', 'accepted', "#{to_param}.jpg")
    else
      File.join('avatars', 'waiting', "#{to_param}.jpg")
    end
  end

  def promo_price(promo = {}, abo_next = false)
    abo_price = ProductAbo.find(abo_type_id).product.price.to_f
    type = promo[:type] ? promo[:type] : activation_discount_code_type
    if type == 'A'
      price = 0
    elsif type == 'D'
      disc = promo[:discount_id] && promo[:discount_id] > 0 ? Discount.find(promo[:discount_id]) : discount

      case disc.type
        #total = price - X%
        when 1
          price = (abo_price - (disc.value / 100 * abo_price)).round(2)
        # tot = X €
        when 2
          price = disc.value
        # tot = price - X€
        when 3
          price = abo_price - disc.value
      end
    else
      price = abo_price
    end
    price.to_f
  end

  def promo_date
    type = activation_discount_code_type
    if type == 'A'
      activation.duration
    elsif type == 'D'
      discount.duration
    end
  end

  def token_available?(product)
    tokens_products.exists?(product.imdb_id)
  end

  def payable?
    payment_method > 0
  end

  def discount_reuse?(months)
    if discount_use.use(months).size > 0
      false
    else
      true
    end
  end

  def no_adult?
    abo_type_id != 3 && abo_type_id != 4 && abo_type_id != 5
  end

  private

  def email_tvod_only
    errors.add(:email, I18n.t("errors.messages.taken_tvod_only", :code => self.code, :email => self.email)) if Customer.where(:email => self.email, :customers_abo_type => 6).exists? && (@activation && !@activation.all_cust? || @activation.nil?)
  end

  def email_step
    errors.add(:email, I18n.t("errors.messages.taken_step", :code => self.code, :email => self.email)) if Customer.where(:email => self.email, :customers_abo => 0).exists?
  end

  def email_abo
    errors.add(:email, I18n.t("errors.messages.taken")) if Customer.where(:email => self.email, :customers_abo => 1).where('customers_abo_type != ?', '6').exists? && (@activation && !@activation.all_cust? || @activation.nil?)
  end

  def email_all_cust
    errors.add(:email, I18n.t("errors.messages.taken_all_cust", :code => self.code, :email => self.email)) if Customer.where(:email => self.email, :customers_abo => 1).exists? && (@activation && @activation.all_cust?)
  end

  def convert_created_at
    begin
      self.created_at = Date.civil(self.year.to_i, self.month.to_i, self.day.to_i)
    rescue ArgumentError
      false
    end
  end

  def validate_created_at
    errors.add("Created at date", "is invalid.") unless convert_created_at
  end

  def notify_hoptoad()
    begin
      Airbrake.notify(:error_message => "customer dont abo abo_type : #{to_param}", :backtrace => $@, :environment_name => ENV['RAILS_ENV'])
    rescue => e
      logger.error("customer dont abo abo_type : #{to_param}")
      logger.error(e.backtrace)
    end
  end

  def notify_credit_hoptoad(action, action_type, quantity)
    begin
      Airbrake.notify(:error_message => "customer have a problem with credit customer_id : #{to_param} action: #{action} action type: #{action_type} quantity: #{quantity}", :backtrace => $@, :environment_name => ENV['RAILS_ENV'])
    rescue => e
      logger.error("customer have a problem with credit customer_id : #{to_param} action: #{action} action type: #{action_type} quantity: #{quantity}")
      logger.error(e.backtrace)
    end
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def setup_abt_6_null
    self.update_attribute(:customers_abo_validityto, nil) if self.customers_abo_type  == 6
  end

end
