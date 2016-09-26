ThinkingSphinx::Index.define :actor, :with => :active_record do
  indexes actors_name, :as => :actors_name, :sortable => true
  has actors_type, :as => :kind, :type => :string
  has "if(actors_type='dvd_adult',0,1)", :type => :integer, :as => :kind_int
  has image_active, :type => :integer
  set_property :enable_star => true
  set_property :min_prefix_len => 2
  set_property :charset_type => 'utf-8'
  #set_property :charset_table => "0..9, A..Z->a..z, a..z, U+C0->a, U+C1->a, U+C2->a, U+C3->a, U+C4->a, U+C5->a, U+C6->a, U+C7->c, U+E7->c, U+C8->e, U+C9->e, U+CA->e, U+CB->e, U+CC->i, U+CD->i, U+CE->i, U+CF->i, U+D0->d, U+D1->n, U+D2->o, U+D3->o, U+D4->o, U+D5->o, U+D6->o, U+D8->o, U+D9->u, U+DA->u, U+DB->u, U+DC->u, U+DD->y, U+DE->t, U+DF->s, U+E0->a, U+E1->a, U+E2->a, U+E3->a, U+E4->a, U+E5->a, U+E6->a, U+E7->c, U+E7->c, U+E8->e, U+E9->e, U+EA->e, U+EB->e, U+EC->i, U+ED->i, U+EE->i, U+EF->i, U+F0->d, U+F1->n, U+F2->o, U+F3->o, U+F4->o, U+F5->o, U+F6->o, U+F8->o, U+F9->u, U+FA->u, U+FB->u, U+FC->u, U+FD->y, U+FE->t, U+FF->s"
  set_property :ignore_chars => "U+AD"
  set_property :field_weights => {:actors_name => 5}
end