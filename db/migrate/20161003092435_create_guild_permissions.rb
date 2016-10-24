class CreateGuildPermissions < ActiveRecord::Migration
  def change
    create_table :guild_permissions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :guild, index: true

      t.integer :permissions
      t.boolean :owner

      t.timestamps null: false
    end
  end
end
