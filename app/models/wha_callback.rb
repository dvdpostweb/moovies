# == Schema Information
#
# Table name: wha_callbacks
#
#  id          :integer          not null, primary key
#  created_at  :datetime         not null
#  callbackurl :string(445)      not null
#

class WhaCallback < ActiveRecord::Base

end
