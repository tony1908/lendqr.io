class CreateMoney < ActiveRecord::Migration
  def change
    create_table :money do |t|
      t.integer :company_id
      t.float :cantidad

      t.timestamps null: false
    end
  end
end
