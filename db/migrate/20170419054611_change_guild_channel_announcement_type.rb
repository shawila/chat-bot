class ChangeGuildChannelAnnouncementType < ActiveRecord::Migration
  def change
    change_column :guilds, :announcement_channel, :string
  end
end
