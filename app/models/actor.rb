# == Schema Information
#
# Table name: actors
#
#  actors_id          :integer          not null, primary key
#  actors_name        :string(50)       default(""), not null
#  actors_dateofbirth :string(10)
#  birth_place        :string(255)
#  death_at           :date
#  death_place        :string(255)
#  actors_type        :string(10)       default(""), not null
#  slug               :string(255)
#  image_active       :boolean          default(FALSE), not null
#  focus              :boolean          default(FALSE), not null
#  sexuality          :string(6)        default("hetero"), not null
#

class Actor < ActiveRecord::Base
  self.primary_key = :actors_id
  extend FriendlyId
  include ThinkingSphinx::Scopes
  alias_attribute :name, :actors_name
  alias_attribute :top, :top_actors
  alias_attribute :birth_at, :actors_dateofbirth   
  scope :by_kind, lambda {|kind| where(:actors_type => Moovies.actor_kinds[kind])}
  scope :by_sexuality, lambda {|sexuality| {:conditions => {:sexuality => sexuality.to_s}}}
  scope :by_letter, lambda {|letter| where("actors_name like ?", "#{letter}%")}
  scope :top, where('top_actors > 0')
  scope :with_image, where(:image_active => true)
  scope :ordered, :order => 'actors_name asc'
  scope :top_ordered, :order => 'top_actors desc'
  
  friendly_id :name, use: :slugged
  has_and_belongs_to_many :products, :join_table => :products_to_actors, :foreign_key => :actors_id, :association_foreign_key => :products_id

  # There are a lot of commented lines of code in here which are just used for development
  # Once all scopes are transformed to Thinking Sphinx scopes, it will be cleaned up.
  sphinx_scope(:by_kind_int)        {|kind|             {:with => {:kind_int => Moovies.actor_kinds_int[kind]}}}
  sphinx_scope(:order)              {|order, sort_mode| {:order => order, :sort_mode => sort_mode}}
  sphinx_scope(:group)              {|group,sort|       {:group_by => group, :group_function => :attr, :group_clause   => sort}}
  sphinx_scope(:limit)              {|limit|            {:limit => limit}}
  def top_actors
    0
  end

  def image(number = 1)
    if number > 0
      if image_active
        File.join(Moovies.imagesx_path, "actors", "#{id}_#{number}.jpg")
      else
        '/assets/no_picture.jpg'
      end
    else
      if image_active
        File.join(Moovies.images_path, "actors", "#{id}.jpg")
      else
        '/assets/no_picture.jpg'
      end
    end
  end

  def adult?
    actors_type == 'DVD_ADULT'
  end

  def top?
    top && top > 0
  end
  
  def self.search_clean(query_string, kind, page = 0 ,count = false)
    qs = []
    if query_string
     query_string = query_string.gsub(/[_-]/, ' ').gsub(/["\(\)]/, ' ').gsub(/[@$!^\/\\|]/, '')
      qs = query_string.split.collect do |word|
        "*#{replace_specials(word)}*"
      end
    end
    page = page || 1
    query_string = qs.join(' ')
    self.search.by_kind_int(kind).search(query_string, :per_page => 1000, :page => page, :max_matches => 1000, :order => :actors_name, :match_mode => :extended)
  end
  
  def self.replace_specials(str)
    str #= String_class.removeaccents(str) #str.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n, '').to_s
  end
  
end
