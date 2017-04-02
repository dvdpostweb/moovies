class AddTemporaryEmailToSmsCodes < ActiveRecord::Migration
  def change
    add_column :sms_codes, :temporary_email, :string
  end
end
