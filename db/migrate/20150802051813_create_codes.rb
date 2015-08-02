class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.integer :user_id
      t.string :code
      t.float :cantidad

      t.timestamps null: false
    end
  end
end
