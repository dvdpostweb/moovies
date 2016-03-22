# == Schema Information
#
# Table name: directors
#
#  directors_id          :integer          not null, primary key
#  directors_name        :string(50)       default(""), not null
#  image_active          :boolean          default(FALSE)
#  directors_dateofbirth :string(10)
#  birth_place           :string(255)
#  death_at              :date
#  death_place           :string(255)
#  slug                  :string(255)
#

class Director < ActiveRecord::Base
  self.primary_key = :directors_id
  extend FriendlyId
  include ThinkingSphinx::Scopes
  alias_attribute :name, :directors_name
  alias_attribute :birth_at, :directors_dateofbirth

  #has_friendly_id :name, :use_slug => true, :approximate_ascii => true, :cache_column => 'cached_slug' 
  friendly_id :name, use: :slugged

  has_many :products, :foreign_key => :products_directors_id
  
  
  def image(number = 1)
    if image_active
      File.join(Moovies.images_path, "directors", "#{id}.jpg")
    else
      '/assets/no_picture.jpg'
    end
  end
  
  ## There are a lot of commented lines of code in here which are just used for development
  ## Once all scopes are transformed to Thinking Sphinx scopes, it will be cleaned up.
  sphinx_scope(:order)              {|order, sort_mode| {:order => order, :sort_mode => sort_mode}}
  sphinx_scope(:group)              {|group,sort|       {:group_by => group, :group_function => :attr, :group_clause   => sort}}
  sphinx_scope(:limit)              {|limit|            {:limit => limit}}

  def self.search_clean(query_string, page = 0, count = false)
    qs = []
    if query_string
      query_string = query_string.gsub(/[_-]/, ' ').gsub(/["\(\)]/, ' ').gsub(/[@$!^\/\\|]/, '')
      qs = query_string.split.collect do |word|
        "*#{replace_specials(word)}*"
      end
    end
    query_string = qs.join(' ')
    page = page || 1
    self.search.search(query_string, :max_matches => 1000, :per_page => 1000, :page => page, :order => :directors_name, :match_mode => :extended)
  end
  
  def self.replace_specials(str)
    str #= String_class.removeaccents(str) #str.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
  end
end
