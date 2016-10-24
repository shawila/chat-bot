class AddAccouncementChannelToGuilds < ActiveRecord::Migration
  def change
    add_column :guilds, :announcement_channel, :text
  end
end
