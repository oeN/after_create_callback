class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :token

      t.timestamps null: false
    end
    add_index :users, :token, unique: true
  end
end
