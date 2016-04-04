# == Schema Information
#
# Table name: streaming_products
#
#  id                           :integer          not null, primary key
#  imdb_id                      :integer
#  filename                     :string(255)
#  available_from               :date
#  expire_at                    :date
#  available_backcatalogue_from :date
#  expire_backcatalogue_at      :date
#  available                    :boolean
#  language_id                  :integer
#  subtitle_id                  :integer
#  created_at                   :datetime
#  updated_at                   :datetime
#  studio_id                    :integer
#  status                       :string(18)       default("ripped")
#  quality                      :string(5)        default("SD")
#  source                       :string(13)       default("SOFTLAYER")
#  vod_support_id               :integer          default(1), not null
#  is_ppv                       :boolean
#  ppv_price                    :float
#  country                      :string(2)        default("BE")
#  package_id                   :integer
#  drm                          :boolean          default(FALSE), not null
#  tvod_price                   :float
#  season_id                    :integer          default(0), not null
#  episode_id                   :integer          default(0), not null
#  videoland                    :boolean          default(FALSE)
#  videoland_reference          :string(45)
#  akamai_folder                :string(45)
#  tvod_credits                 :integer          default(1), not null
#

class StreamingProduct < ActiveRecord::Base

  has_many :subtitle, :foreign_key => :undertitles_id, :primary_key => :subtitle_id
  has_many :language, :foreign_key => :languages_id, :primary_key => :language_id
  has_many :tokens, :primary_key => :imdb_id, :foreign_key => :imdb_id
  has_many :products, :primary_key => :imdb_id, :foreign_key => :imdb_id, :limit => 1
  has_many :subtitles, :primary_key => :subtitle_id, :foreign_key => :undertitles_id
  has_many :languages, :foreign_key => :languages_id, :primary_key => :language_id
  has_many :svod_dates, :primary_key => :imdb_id, :foreign_key => :imdb_id
  belongs_to :studio, :foreign_key => :studio_id
  scope :by_filename, lambda { |filename| where(:filename => filename) }
  scope :by_version, lambda { |language_id, subtitle_id| where(:language_id => language_id, :subtitle_id => subtitle_id) }
  scope :by_language, lambda { |language_id| where(:language_id => language_id) }
  default_scope where("status !='deleted'")
  scope :available, where('available = ? and ((available_from <= ? and streaming_products.expire_at >= ?) or (available_backcatalogue_from <= ? and streaming_products.expire_backcatalogue_at >= ?)) and status = "online_test_ok"', 1, Date.today.to_s(:db), Date.today.to_s(:db), Date.today.to_s(:db), Date.today.to_s(:db))
  scope :available_token, where('available = ? and ((available_from <= ? and streaming_products.expire_at >= ?) or (available_backcatalogue_from <= ? and streaming_products.expire_backcatalogue_at >= ?)) and status = "online_test_ok"', 1, Date.today.to_s(:db), 3.days.ago.strftime('%Y-%m-%d'), Date.today.to_s(:db), Date.today.to_s(:db))
  scope :not_yet_available, where('available = ? and ((available_from > ? ) or ((expire_at < ? or expire_at is null) and available_backcatalogue_from > ?)) and status = "online_test_ok"', 1, Date.today.to_s(:db), Date.today.to_s(:db), Date.today.to_s(:db))
  scope :available_beta, where('available = ? and status != "deleted"', 1)
  scope :prefered_audio, lambda { |language_id| where(:language_id => language_id) }
  scope :prefered_subtitle, lambda { |subtitle_id| where('subtitle_id = ? and language_id <> ?', subtitle_id, subtitle_id) }
  scope :not_prefered, lambda { |language_id| where("language_id != :language_id and (subtitle_id != :language_id or subtitle_id is null)", {:language_id => language_id}) }
  scope :alpha, where(:source => ['ALPHANETWORKS', 'VIDEOLAND'])
  scope :country, lambda { |country| where(:country => country) }
  scope :hd, where(:quality => ['720p', '1080p'])
  scope :by_primary, lambda { |imdb_id, season_id, episode_id| where(:imdb_id => imdb_id, :season_id => season_id, :episode_id => episode_id) }
  scope :group_by_version, :group => 'language_id, subtitle_id'
  scope :group_by_language, :group => 'language_id'
  scope :ordered, :order => 'quality asc'

  def smart_available
    Rails.env == 'production' ? available : available_beta
  end

  def available?
    status == 'online_test_ok' && ((available_from && available_from <= Date.today && expire_at >= Date.today) || (available_backcatalogue_from && available_backcatalogue_from <= Date.today && expire_backcatalogue_at >= Date.today))
  end

  def hd?
    quality == '720p' || quality == '1080p'
  end

  def self.source
    source = OrderedHash.new
    source.push(:softlayer, 'SOFTLAYER')
    source.push(:alphanetworks, 'ALPHANETWORKS')
    source.push(:videoland, 'VIDEOLAND')
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

  def prepaid?
    svod_dates.svod.prepaid_svod.first || svod_dates.svod.prepaid_all.first
  end

  def prepaid_all?
    svod_dates.svod.prepaid_all.first
  end

  def tvod?
    svod_dates.svod.empty?
  end

  def self.date_available(imdb_id, country_name)
    stream = StreamingProduct.country(country_name).not_yet_available.find_all_by_imdb_id(imdb_id).first
    date = stream.available_from && stream.available_from > Date.today ? stream.available_from.strftime('%d/%m/%Y') : stream.available_backcatalogue_from.strftime('%d/%m/%Y')
  end
end
