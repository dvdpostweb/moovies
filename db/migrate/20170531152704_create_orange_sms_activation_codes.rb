class CreateOrangeSmsActivationCodes < ActiveRecord::Migration
  def change
    create_table :orange_sms_activation_codes do |t|
      t.references :customer
      t.string :phone_number

      t.timestamps
    end
    add_index :orange_sms_activation_codes, :customers_id
  end
end
