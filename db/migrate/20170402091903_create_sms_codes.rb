class CreateSmsCodes < ActiveRecord::Migration
  def change
    create_table :sms_codes do |t|
      t.string :code

      t.timestamps
    end
  end
end
