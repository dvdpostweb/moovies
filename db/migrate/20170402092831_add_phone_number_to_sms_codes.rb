class AddPhoneNumberToSmsCodes < ActiveRecord::Migration
  def change
    add_column :sms_codes, :phone_number, :string
  end
end
