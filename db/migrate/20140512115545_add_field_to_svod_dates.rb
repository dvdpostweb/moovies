class AddFieldToSvodDates < ActiveRecord::Migration
  def change
    add_column :svod_dates, :kind, 'enum("NORMAL", "PREPAID_ALL", "PREPAID_SVOD")' ,:default => 'NORMAL'
    add_column :svod_dates, :prepaid_start_on, :date
    add_column :svod_dates, :prepaid_end_on, :date
    
  end
end
