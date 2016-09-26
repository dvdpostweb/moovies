ThinkingSphinx::Index.define :category, :with => :active_record do
  indexes descriptions('categories_name'), :as => :name, :sortage => true, :type => :string, :multi => true
  has "if(active = 'YES', 1,0)", :as => :active, :type => :integer
  has parent_id
  has "CRC32(categories_type)", :as => :type, :type => :integer
  has "(select count(*) from products_to_categories join products p on p.products_id = products_to_categories.products_id join streaming_products on streaming_products.imdb_id = p.imdb_id and available = 1 and status='online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and country='be' where products_to_categories.categories_id = `categories`.`categories_id` and p.package_id in(1,4) and products_status !=-1  )", :as => :count_svod_be, :type => :integer
  has "(select count(*) from products_to_categories join products p on p.products_id = products_to_categories.products_id join streaming_products on streaming_products.imdb_id = p.imdb_id and available = 1 and status='online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and country='nl' where products_to_categories.categories_id = `categories`.`categories_id` and p.package_id in(1,4) and products_status !=-1  )", :as => :count_svod_nl, :type => :integer
  has "(select count(*) from products_to_categories join products p on p.products_id = products_to_categories.products_id join streaming_products on streaming_products.imdb_id = p.imdb_id and available = 1 and status='online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and country='lu' where products_to_categories.categories_id = `categories`.`categories_id` and p.package_id in(1,4) and products_status !=-1  )", :as => :count_svod_lu, :type => :integer
  has "(select count(*) from products_to_categories join products p on p.products_id = products_to_categories.products_id join streaming_products on streaming_products.imdb_id = p.imdb_id and available = 1 and status='online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and country='be' where products_to_categories.categories_id = `categories`.`categories_id` and p.package_id in(2,5) and products_status !=-1  )", :as => :count_tvod_be, :type => :integer
  has "(select count(*) from products_to_categories join products p on p.products_id = products_to_categories.products_id join streaming_products on streaming_products.imdb_id = p.imdb_id and available = 1 and status='online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and country='nl' where products_to_categories.categories_id = `categories`.`categories_id` and p.package_id in(2,5) and products_status !=-1  )", :as => :count_tvod_nl, :type => :integer
  has "(select count(*) from products_to_categories join products p on p.products_id = products_to_categories.products_id join streaming_products on streaming_products.imdb_id = p.imdb_id and available = 1 and status='online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and country='lu' where products_to_categories.categories_id = `categories`.`categories_id` and p.package_id in(2,5) and products_status !=-1  )", :as => :count_tvod_lu, :type => :integer
  has '(select CRC32(if(substring(categories_name,1,1) REGEXP "^[0-9]", 0,substring(categories_name,1,1)))  from `categories_description` cd where cd.categories_id= `categories`.`categories_id` and cd.language_id = 1 limit 1)', :as => :first_fr_int, :type => :integer
  has '(select CRC32(if(substring(categories_name,1,1) REGEXP "^[0-9]", 0,substring(categories_name,1,1)))  from `categories_description` cd where cd.categories_id= `categories`.`categories_id` and cd.language_id = 2 limit 1)', :as => :first_nl_int, :type => :integer
  has '(select CRC32(if(substring(categories_name,1,1) REGEXP "^[0-9]", 0,substring(categories_name,1,1)))  from `categories_description` cd where cd.categories_id= `categories`.`categories_id` and cd.language_id = 3 limit 1)', :as => :first_en_int, :type => :integer
  has '(select categories_name  from `categories_description` cd where cd.categories_id= `categories`.`categories_id` and cd.language_id = 1 limit 1)', :as => :name_fr, :type => :string
  has '(select categories_name  from `categories_description` cd where cd.categories_id= `categories`.`categories_id` and cd.language_id = 2 limit 1)', :as => :name_nl, :type => :string
  has '(select categories_name  from `categories_description` cd where cd.categories_id= `categories`.`categories_id` and cd.language_id = 2 limit 1)', :as => :name_en, :type => :string

  set_property :enable_star => true
  set_property :min_prefix_len => 2
  set_property :charset_type => 'utf-8'
  set_property :ignore_chars => "U+AD"
  set_property :field_weights => {:actors_name => 5}
end