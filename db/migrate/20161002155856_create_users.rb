class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :uid
      t.string :discriminator
      t.string :avatar
      t.boolean :verified

      t.timestamps null: false
    end

    add_index :users, :uid, unique: true
  end
end
