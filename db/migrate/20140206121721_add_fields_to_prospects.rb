class AddFieldsToProspects < ActiveRecord::Migration
  def change
    add_column :prospects, :birth_at, :date
    add_column :prospects, :zip, :integer
  end
end
