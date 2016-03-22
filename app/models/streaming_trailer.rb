# == Schema Information
#
# Table name: streaming_trailers
#
#  id             :integer          not null, primary key
#  imdb_id        :integer
#  filename       :string(255)
#  available_from :date
#  expire_at      :date
#  available      :boolean
#  language_id    :integer
#  subtitle_id    :integer
#  created_at     :datetime
#  updated_at     :datetime
#  status         :string(18)       default("ripped")
#  videoland      :boolean          default(FALSE)
#  akamai_folder  :string(255)
#

class StreamingTrailer < ActiveRecord::Base
  has_many :subtitles, :foreign_key => :undertitles_id, :primary_key => :subtitle_id
  has_many :languages, :foreign_key => :languages_id, :primary_key => :language_id
  has_one :tokens_trailer, :foreign_key => :filename, :primary_key => :filename
  scope :available, lambda { where('streaming_trailers.available = ? and streaming_trailers.status = "online_test_ok"', 1)}
  scope :available_beta, lambda {where('streaming_trailers.status != "deleted"', 1)}
  scope :prefered_audio, lambda {|language_id| where(:language_id => language_id)}
  scope :sub_nil, where(:subtitle_id => nil)
  
  scope :prefered_subtitle, lambda {|subtitle_id| where('subtitle_id = ? and language_id <> ?', subtitle_id, subtitle_id)}
  scope :not_prefered, lambda {|language_id| where("language_id != :language_id and (subtitle_id != :language_id or subtitle_id is null)", {:language_id => language_id})}
  
  def self.get_best_version(imdb_id, local)
    if Rails.env == "production"
      streaming = available.prefered_audio(Moovies.languages[local]).sub_nil.find_by_imdb_id(imdb_id)
      if streaming.nil?
        streaming = available.prefered_audio(Moovies.languages[local]).find_by_imdb_id(imdb_id)
      end
      if streaming.nil?
        streaming = available.prefered_subtitle(Moovies.languages[local]).find_by_imdb_id(imdb_id)
      end
      if streaming.nil?
        streaming = available.prefered_audio(Moovies.languages[:en]).find_by_imdb_id(imdb_id)
      end
      if streaming.nil?
        streaming = available.find_by_imdb_id(imdb_id)
      end
    else
      streaming = available_beta.find_by_imdb_id(imdb_id)
    end
    streaming
  end

  def is_new?
    true
  end

  def url
    false
  end
end
