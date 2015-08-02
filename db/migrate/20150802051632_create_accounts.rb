class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.float :cantidad
      t.integer :user_id
      t.string :code

      t.timestamps null: false
    end
  end
end
