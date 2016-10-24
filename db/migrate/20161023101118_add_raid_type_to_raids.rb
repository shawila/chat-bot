class AddRaidTypeToRaids < ActiveRecord::Migration
  def change
    add_column :raids, :raid_type, :integer
  end
end
