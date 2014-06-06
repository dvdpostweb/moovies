class Landing < ActiveRecord::Base
  has_one :product, :primary_key => :reference_id, :foreign_key => :products_id

  scope :order, :order => "ordered asc, id desc"
  scope :order_admin, :order =>"id desc" 
  scope :order_rand, :order =>"rand()"
  scope :order_id, :order => 'id desc'
  
  scope :not_expirated, where('expirated_date > now() or expirated_date is null')
  scope :private, where(:login => ['private', 'both' ])
  scope :public,  where(:login => ['public', 'both' ])
  scope :hit,  where(:login => 'hit')
  scope :public_test,  where(:login => ['public_test' ])
  scope :adult,  where(:login => ['adult', 'both_adult'])
  scope :adult_public,  where(:login => ['adult_public', 'both_adult'])
  
  scope :by_language, lambda {|language| where((language == :nl ? :actif_dutch : (language == :en ? :actif_english : :actif_french)) => "YES")}
  scope :by_language_beta, lambda {|language| where((language == :nl ? :actif_dutch : (language == :en ? :actif_english : :actif_french)) => ["BETA","YES"])}

  def title(locale)
    eval("title_#{locale}")
  end

  def description(locale)
    eval("description_#{locale}")
  end

  def link(locale)
    eval("link_#{locale}")
  end
  def image
    File.join(Moovies.images_carousel_path, id.to_s+'.jpg')
  end

  def image_public
    File.join(Moovies.images_carousel_path, id.to_s+'.jpg')
  end

  def image_adult
    File.join(Moovies.images_carousel_adult_path, id.to_s+'.jpg')
  end
  
end
