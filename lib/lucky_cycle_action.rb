module LuckyCycleAction
  class << self
    def poke(file, locale, customer, token)
      uri = URI.parse("https://www.luckycycle.com")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new("/api/v1/operations/a3de1746b670d196a7cc62106231b923/poke")
      request['X-LuckyApiKey'] = 'd687d6571160b3b062dda5ca43b8f6b72a38809d'
      params = {'random_data' => '0', 'item_currency' => 'EUR', 'item_value' => file.ppv_price, 'segment' => 'A', 'locale' => 'fr_FR', 'language' => locale, 'user_uid' => customer.id, 'item_uid' => token.id, 'firstname' => customer.first_name, 'lastname' => customer.last_name, 'email' => customer.email}
      request.body = params.to_query
      response = http.request(request)
      body = ActiveSupport::JSON.decode( response.body)
      return lucky = LuckyCycle.create(canplay: body['can_play'], message: body['message'], token_id: body['item_uid'], customer_id: body['user_uid'], computed_hash: body['computed_hash'], poke_counter: body['poke_counter'], firstname: body['firstname'], lastname: body['lastname'], email: body['email'])
    end
  end
end