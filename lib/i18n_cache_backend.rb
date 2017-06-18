module I18n::Backend::Cache

  def store_translations(locale, data, options = {})
    flatten_keys(data, true) do |key, value|
      c_key = cache_key(locale, key.to_s, options)
      I18n.cache_store.delete c_key
    end
    super
  end
end