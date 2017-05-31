class AddSmsAuthentificationCodeToOrangeSmsActivationCodes < ActiveRecord::Migration
  def change
    add_column :orange_sms_activation_codes, :sms_authentification_code, :string
  end
end
