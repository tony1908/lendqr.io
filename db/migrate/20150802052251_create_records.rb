class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :user_id
      t.integer :company_id
      t.float :cantidad
      t.float :latitude
      t.float :longitude
      t.string :name

      t.timestamps null: false
    end
  end
end
