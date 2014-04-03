class StreamingProduct < ActiveRecord::Base

  has_many :subtitle, :foreign_key => :undertitles_id, :primary_key => :subtitle_id
  has_many :language, :foreign_key => :languages_id, :primary_key => :language_id
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :products, :primary_key => :imdb_id, :foreign_key => :imdb_id, :limit => 1
  has_many :subtitles, :primary_key => :subtitle_id, :foreign_key => :undertitles_id
  has_many :languages, :foreign_key => :languages_id, :primary_key => :language_id
  has_many :svod_dates, :primary_key => :imdb_id, :foreign_key => :imdb_id
  belongs_to :studio, :foreign_key => :studio_id
  scope :by_filename, lambda {|filename| where(:filename => filename)}
  scope :by_version, lambda {|language_id, subtitle_id| where(:language_id => language_id, :subtitle_id => subtitle_id)}
  scope :by_language, lambda {|language_id| where(:language_id => language_id)}
  
  scope :available, where('available = ? and ((available_from <= ? and streaming_products.expire_at >= ?) or (available_backcatalogue_from <= ? and streaming_products.expire_backcatalogue_at >= ?)) and status = "online_test_ok"', 1, Date.today.to_s(:db), Date.today.to_s(:db), Date.today.to_s(:db), Date.today.to_s(:db))
  scope :available_token, where('available = ? and ((available_from <= ? and streaming_products.expire_at >= ?) or (available_backcatalogue_from <= ? and streaming_products.expire_backcatalogue_at >= ?)) and status = "online_test_ok"', 1, Date.today.to_s(:db), 3.days.ago.strftime('%Y-%m-%d'), Date.today.to_s(:db), Date.today.to_s(:db))
  scope :not_yet_available, where('available = ? and ((available_from > ? ) or ((expire_at < ? or expire_at is null) and available_backcatalogue_from > ?)) and status = "online_test_ok"', 1, Date.today.to_s(:db), Date.today.to_s(:db), Date.today.to_s(:db))
  scope :available_beta, where('available = ? and status != "deleted"', 1)
  scope :prefered_audio, lambda {|language_id| where(:language_id => language_id) }
  scope :prefered_subtitle, lambda {|subtitle_id| where('subtitle_id = ? and language_id <> ?', subtitle_id, subtitle_id)}
  scope :not_prefered, lambda {|language_id| where("language_id != :language_id and (subtitle_id != :language_id or subtitle_id is null)",{:language_id => language_id})}
  scope :alpha, where(:source => 'ALPHANETWORKS')
  scope :country, lambda {|country| where(:country => country)}
  scope :hd, where(:quality => ['720p', '1080p'])
  
  scope :group_by_version, :group => 'language_id, subtitle_id'
  scope :group_by_language, :group => 'language_id'
  scope :ordered, :order => 'quality asc'

  def available?
    status == 'online_test_ok' && ((available_from && available_from <= Date.today && expire_at >= Date.today) || (available_backcatalogue_from <= Date.today && expire_backcatalogue_at >= Date.today))
  end
  def self.get_prefered_streaming_by_imdb_id(imdb_id, local)
    if Rails.env == "production"
      streaming = available.prefered_audio(Mooives.customer_languages[local]).find_all_by_imdb_id(imdb_id)
      streaming += available.prefered_subtitle(Mooives.customer_languages[local]).find_all_by_imdb_id(imdb_id)
    else
      streaming = available_beta.prefered_audio(Mooives.customer_languages[local]).find_all_by_imdb_id(imdb_id)
      streaming += available_beta.prefered_subtitle(Mooives.customer_languages[local]).find_all_by_imdb_id(imdb_id)
    end
    streaming
  end

  def hd?
    quality == '720p' || quality == '1080p'
  end

  def self.get_not_prefered_streaming_by_imdb_id(imdb_id, local)
    if Rails.env == "production"
      streaming = available.not_prefered(Mooives.customer_languages[local]).find_all_by_imdb_id(imdb_id)
    else
      streaming = available_beta.not_prefered(Mooives.customer_languages[local]).find_all_by_imdb_id(imdb_id)
    end
    streaming
  end

  def self.source
    source = OrderedHash.new
    source.push(:softlayer, 'SOFTLAYER')
    source.push(:alphanetworks, 'ALPHANETWORKS')
    source
  end

  def generate_code(code, uniq)
    if code == Digest::MD5.hexdigest("#{uniq}_#{filename}_#{imdb_id}_supernova")
      return StreamingCode.create(:name => code, :white_label => 1, :activation_group_id => 183, :expiration_at => 3.days.from_now)
    else
      nil
    end
  end

  def svod?
    !svod_dates.svod.empty?
  end
  
  def tvod?
    svod_dates.svod.empty?
  end

  def self.date_available(imdb_id, country_name)
    stream = StreamingProduct.country(country_name).not_yet_available.find_all_by_imdb_id(imdb_id).first
    date = stream.available_from && stream.available_from > Date.today ? stream.available_from.strftime('%d/%m/%Y') : stream.available_backcatalogue_from.strftime('%d/%m/%Y')
  end
end