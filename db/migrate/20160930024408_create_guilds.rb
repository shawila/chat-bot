class CreateGuilds < ActiveRecord::Migration
  def change
    create_table :guilds do |t|
      t.string :name
      t.string :uid
      t.string :icon

      t.timestamps null: false
    end

    add_index :guilds, :uid, unique: true
  end
end
