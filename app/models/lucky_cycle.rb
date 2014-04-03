class LuckyCycle < ActiveRecord::Base
  attr_accessible :canplay, :computed_hash, :customer_id, :email, :firstname, :lastname, :message, :poke_counter, :token_id
end
