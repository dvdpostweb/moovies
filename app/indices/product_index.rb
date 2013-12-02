ThinkingSphinx::Index.define :product, :with => :active_record, :name => 'product_be' do
  indexes descriptions('DISTINCT products_description.`products_name`'), :as => :descriptions_title, :sortage => true, :type => :string, :multi => true
  
  has "CRC32(products_type)", :as => :kind, :type => :integer
  has products_countries_id,      :as => :country_id
  has products_date_available,    :as => :available_at
  has products_date_added,        :as => :created_at
  has products_id,                :as => :product_id
  has "CAST(vod_next AS SIGNED)", :type => :integer, :as => :vod_next
  has "CAST(vod_next_lux AS SIGNED)", :type => :integer, :as => :vod_next_lux
  has "CAST(vod_next_nl AS SIGNED)", :type => :integer, :as => :vod_next_nl
  
  has products_public,            :as => :audience
  has products_year,              :as => :year
  has products_rating,            :as => :dvdpost_rating
  has imdb_id
  has package_id
  has actors('DISTINCT actors.`actors_id`'),         :as => :actors_id, :type => :integer, :multi => true
  has categories('DISTINCT categories.categories_id'), :as => :category_id, :type => :integer, :multi => true
  has director(:directors_id),    :as => :director_id
  has studio(:studio_id),         :as => :studio_id
  
  has 'cast((cast((rating_users/rating_count)*2 AS SIGNED)/2) as decimal(2,1))', :type => :float, :as => :rating
  has streaming_products_be('DISTINCT streaming_products.`imdb_id`'), :as => :streaming_imdb_id, :type => :integer, :multi => true
  has streaming_products_be('DISTINCT streaming_products.`language_id`'), :as => :language_ids, :type => :integer, :multi => true
  has streaming_products_be('DISTINCT streaming_products.`subtitle_id`'), :as => :subtitle_ids, :type => :integer, :multi => true
  has "ifnull(concat('2',replace(if(min(vod_online_bes_products.expire_at) > date(now()),min(vod_online_bes_products.available_from),null),'-','')),ifnull(concat('2',replace(min(vod_online_bes_products.available_backcatalogue_from), '-','')), ifnull(concat('1',replace(if(min(streaming_products.expire_at) > date(now()),min(streaming_products.available_from),null), '-','')),concat('1',replace(min(streaming_products.available_backcatalogue_from), '-','')))))", :type => :integer, :as => :streaming_available_at_order
  has "ifnull(if(min(vod_online_bes_products.expire_at) > date(now()),min(vod_online_bes_products.available_from),null),ifnull(min(vod_online_bes_products.available_backcatalogue_from), ifnull(if(min(streaming_products.expire_at) > date(now()),min(streaming_products.available_from),null),min(streaming_products.available_backcatalogue_from))))", :type => :timestamp, :as => :streaming_available_at
  has "if(vod_online_bes_products.expire_at < now(), vod_online_bes_products.expire_at, vod_online_bes_products.expire_backcatalogue_at)", :type => :timestamp, :as => :streaming_expire_at
  has vod_online_be('DISTINCT vod_online_bes_products.`imdb_id`'), :as => :imdb_id_online, :type => :integer, :multi => true
  has vod_online_be('DISTINCT vod_online_bes_products.`language_id`'), :as => :online_language_ids, :type => :integer, :multi => true
  has vod_online_be('DISTINCT vod_online_bes_products.`subtitle_id`'), :as => :online_subtitle_ids, :type => :integer, :multi => true
  
  has "(select count(*) c from tokens where tokens.imdb_id = products.imdb_id and (datediff(now(),created_at) < 8))", :type => :integer, :as => :count_tokens
  has "(select start_on svod_start from products p left join svod_dates sd on sd.imdb_id = p.imdb_id and (start_on >= date(now()) or end_on >= date(now())) where p.imdb_id = products.imdb_id order by sd.start_on limit 1)", :as => :svod_start, :type => :timestamp
  has "(select end_on svod_end from products p left join svod_dates sd on sd.imdb_id = p.imdb_id and (start_on >= date(now()) or end_on >= date(now()))  where p.imdb_id =products.imdb_id order by sd.start_on limit 1)", :as => :svod_end, :type => :timestamp
  has "(select ifnull(end_on,ifnull((select end_on from svod_dates where imdb_id=products.imdb_id and svod_dates.start_on < date(now()) order by start_on desc limit 1),if(expire_at >= date(now()) and available_from <=date(now()),min(available_from),min(available_backcatalogue_from)))) svod_start from products p join `streaming_products` sp on p.imdb_id = sp.imdb_id and available =1 and status  in ('uploaded','soon','online_test_ok') and country ='BE' left join svod_dates sd on sd.imdb_id = p.imdb_id and ( start_on <= date(now()) and end_on>= date(now())) where p.imdb_id = products.imdb_id order by sd.start_on limit 1)", :as => :tvod_start, :type => :timestamp
  has "(select if(end_on,null,ifnull((select start_on from svod_dates where imdb_id= products.imdb_id and svod_dates.start_on > date(now()) order by start_on desc limit 1),if(expire_at >= date(now()) and available_from <=date(now()) and DATEDIFF(available_backcatalogue_from,expire_at) > 6 ,min(expire_at),min(expire_backcatalogue_at)))) svod_end from products p join `streaming_products` sp on p.imdb_id = sp.imdb_id and available =1 and status  in ('uploaded','soon','online_test_ok') and country ='BE' left join svod_dates sd on sd.imdb_id = p.imdb_id and ( start_on <= date(now()) and end_on>= date(now())) where p.imdb_id = products.imdb_id order by sd.start_on limit 1)", :as => :tvod_end, :type => :timestamp
  #has descriptions_fr.products_name,         :as => :descriptions_title_fr, :sortage => true
  #has descriptions_nl.products_name,         :as => :descriptions_title_nl, :sortage => true
  #has descriptions_en.products_name,         :as => :descriptions_title_en, :sortage => true
  #has "min(streaming_products.id)", :type => :integer, :as => :streaming_id
  has "concat(GROUP_CONCAT(DISTINCT IFNULL(`vod_online_bes_products`.`language_id`, '0') SEPARATOR ','),',', GROUP_CONCAT(DISTINCT IFNULL(`vod_online_bes_products`.`subtitle_id`, '0') SEPARATOR ','))", :type => :integer, :multi => true, :as => :audio_sub
  #has "(select (ifnull(replace(available_from,'-',''),replace(available_backcatalogue_from, '-',''))) date_order from streaming_products where imdb_id = products.imdb_id and status = 'online_test_ok' and available = 1 and ((date(now())  >= date(available_backcatalogue_from) and date(now()) <= date(date_add(available_backcatalogue_from, interval 3 month)))or(date(now())  >= date(available_from) and date(now()) <= date(date_add(available_from, interval 3 month)))) limit 1)", :type => :integer, :as => :available_order
  has "(select studio_id from streaming_products where imdb_id = products.imdb_id and status = 'online_test_ok' and available = 1 order by expire_backcatalogue_at asc limit 1)", :type => :integer, :as => :streaming_studio_id
  has "(select if(count(*)>0,1,0) from streaming_products where quality in ('1080p', '720p') and imdb_id = products.imdb_id and status in ('uploaded','soon','online_test_ok') and country ='BE' and available = 1)", :type => :integer, :as => :hd
  #has 'cast((SELECT count(*) FROM `wishlist_assigned` wa WHERE wa.products_id = products.products_id and date_assigned > date_sub(now(), INTERVAL 1 MONTH) group by wa.products_id) AS SIGNED)', :type => :integer, :as => :most_viewed
  #has 'cast((SELECT count(*) FROM `wishlist_assigned` wa WHERE wa.products_id = products.products_id and date_assigned > date_sub(now(), INTERVAL 1 YEAR) group by wa.products_id) AS SIGNED)', :type => :integer, :as => :most_viewed_last_year
  #
  has "(select products_name AS products_name_ord from products_description pd where  language_id = 1 and pd.products_id = products.products_id)", :type => :string, :as => :descriptions_title_fr, :sortable => true
  has "(select products_name AS products_name_ord from products_description pd where  language_id = 2 and pd.products_id = products.products_id)", :type => :string, :as => :descriptions_title_nl, :sortable => true
  has "(select products_name AS products_name_ord from products_description pd where  language_id = 3 and pd.products_id = products.products_id)", :type => :string, :as => :descriptions_title_en, :sortable => true
  #
  #has "(select case 
  #        when (products_media = 'DVD' and streaming_products.imdb_id is not null) or (products_media = 'DVD' and vod_next = 1) then 2
  #        when (products_media = 'VOD' and streaming_products.imdb_id is not null) or (products_media = 'VOD' and vod_next = 1) then 5
  #        when products_media = 'DVD' then 1 
  #        when (products_media = 'blueray' and streaming_products.imdb_id is not null) or (products_media = 'blueray' and vod_next = 1) then 4 
  #        when products_media = 'blueray' then 3
  #        when products_media = 'bluray3d' then 6
  #        when products_media = 'bluray3d2d' then 7
  #        else 8 end from products p 
  #        left join streaming_products on streaming_products.imdb_id = p.imdb_id and country ='BE' and ( streaming_products.status = 'online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and available = 1)
  #        where  p.products_id =  products.products_id limit 1)", :type  => :integer, :as => :special_media_be
  #has "(select case 
  #        when (products_media = 'DVD' and streaming_products.imdb_id is not null ) or (products_media = 'DVD' and vod_next_lux = 1) then 2
  #        when (products_media = 'VOD' and streaming_products.imdb_id is not null ) or (products_media = 'VOD' and vod_next_lux = 1) then 5
  #        when products_media = 'DVD' then 1 
  #        when (products_media = 'blueray' and streaming_products.imdb_id is not null ) or (products_media = 'blueray' and vod_next_lux = 1) then 4 
  #        when products_media = 'blueray' then 3
  #        when products_media = 'bluray3d' then 6
  #        when products_media = 'bluray3d2d' then 7
  #        else 8 end 
  #        from products p
  #        left join streaming_products on streaming_products.imdb_id = p.imdb_id and country ='LU' and ( streaming_products.status = 'online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and available = 1)
  #        where p.products_id =  products.products_id limit 1)", :type  => :integer, :as => :special_media_lu
  #has "(select case 
  #        when (products_media = 'DVD' and streaming_products.imdb_id is not null ) or (products_media = 'DVD' and vod_next_nl = 1) then 2
  #        when (products_media = 'VOD' and streaming_products.imdb_id is not null ) or (products_media = 'VOD' and vod_next_nl = 1) then 5
  #        when products_media = 'DVD' then 1 
  #        when (products_media = 'blueray' and streaming_products.imdb_id is not null ) or (products_media = 'blueray' and vod_next_nl = 1) then 4 
  #        when products_media = 'blueray' then 3
  #        when products_media = 'bluray3d' then 6
  #        when products_media = 'bluray3d2d' then 7
  #        else 8 end 
  #        from products p
  #        left join streaming_products on streaming_products.imdb_id = p.imdb_id and country ='NL' and ( streaming_products.status = 'online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and available = 1)
  #        where p.products_id =  products.products_id limit 1)", :type  => :integer, :as => :special_media_nl
  #
  #indexes "(select group_concat(distinct country) from streaming_products where imdb_id = products.imdb_id and streaming_products.status = 'online_test_ok' and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and available = 1 limit 1)", :type => :multi, :as => :streaming_available
  #has "(select count(*) c from tokens where tokens.imdb_id = products.imdb_id and (datediff(now(),created_at) < 8))", :type => :integer, :as => :count_tokens
  #has "(select count(*) c from tokens where tokens.imdb_id = products.imdb_id and (datediff(now(),created_at) < 31))", :type => :integer, :as => :count_tokens_month
  #has "case
  #when products_date_available > DATE_SUB(now(), INTERVAL 8 MONTH) and products_date_available < DATE_SUB(now(), INTERVAL 3 MONTH) and products_series_id = 0 and cast((cast((rating_users/rating_count)*2 AS SIGNED)/2) as decimal(2,1)) >= 3 and products_quantity > 0 then 1
  #when products_date_available < DATE_SUB(now(), INTERVAL 8 MONTH) and products_series_id = 0 and cast((cast((rating_users/rating_count)*2 AS SIGNED)/2) as decimal(2,1)) >= 4 and products_quantity > 2 then 1
  #else 0 end", :type => :integer, :as => :popular
  #has 'concat(if(products_quantity>0 or products_media = "vod" or (  select count(*) > 0 from products p
  #      join streaming_products on streaming_products.imdb_id = p.imdb_id
  #      where  ((country="BE" and streaming_products.status = "online_test_ok" and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and available = 1) or p.vod_next=1 or streaming_products.imdb_id is null)  and p.products_id =  products.products_id),1,0),date_format(products_date_available,"%Y%m%d"))', :type => :integer, :as => :default_order_be
  #has 'concat(if(products_quantity>0  or (  select count(*) > 0 from products p
  #      join streaming_products on streaming_products.imdb_id = p.imdb_id
  #      where  ((country="LU" and streaming_products.status = "online_test_ok" and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and available = 1) or p.vod_next_lux=1 or streaming_products.imdb_id is null)  and p.products_id =  products.products_id),1,0),date_format(products_date_available,"%Y%m%d"))', :type => :integer, :as => :default_order_lu
  #
  #has 'concat(if(products_quantity>0 or (  select count(*) > 0 from products p
  #      join streaming_products on streaming_products.imdb_id = p.imdb_id
  #      where  ((country="NL" and streaming_products.status = "online_test_ok" and ((streaming_products.available_from <= date(now()) and streaming_products.expire_at >= date(now())) or (streaming_products.available_backcatalogue_from <= date(now()) and streaming_products.expire_backcatalogue_at >= date(now()))) and available = 1) or p.vod_next_nl=1 or streaming_products.imdb_id is null)  and p.products_id =  products.products_id),1,0),date_format(products_date_available,"%Y%m%d"))', :type => :integer, :as => :default_order_nl
  
  set_property :enable_star => true
  set_property :min_prefix_len => 3
  set_property :charset_type => 'utf-8'
  #set_property :charset_table => "0..9, A..Z->a..z, a..z, U+C0->a, U+C1->a, U+C2->a, U+C3->a, U+C4->a, U+C5->a, U+C6->a, U+C7->c, U+E7->c, U+C8->e, U+C9->e, U+CA->e, U+CB->e, U+CC->i, U+CD->i, U+CE->i, U+CF->i, U+D0->d, U+D1->n, U+D2->o, U+D3->o, U+D4->o, U+D5->o, U+D6->o, U+D8->o, U+D9->u, U+DA->u, U+DB->u, U+DC->u, U+DD->y, U+DE->t, U+DF->s, U+E0->a, U+E1->a, U+E2->a, U+E3->a, U+E4->a, U+E5->a, U+E6->a, U+E7->c, U+E7->c, U+E8->e, U+E9->e, U+EA->e, U+EB->e, U+EC->i, U+ED->i, U+EE->i, U+EF->i, U+F0->d, U+F1->n, U+F2->o, U+F3->o, U+F4->o, U+F5->o, U+F6->o, U+F8->o, U+F9->u, U+FA->u, U+FB->u, U+FC->u, U+FD->y, U+FE->t, U+FF->s,"
  set_property :ignore_chars => "U+AD"
  set_property :field_weights => {:descriptions_title => 10}
end