class Guild < ActiveRecord::Base
  has_many :guild_permissions
  has_many :users, through: :guild_permissions
  has_many :raids

  default_scope { includes(:guild_permissions) }

  def owner?(user)
    guild_permissions.user_permissions(user.id).pluck(:owner).first
  end

  def permissions(user)
    guild_permissions.user_permissions(user.id).pluck(:permissions).first
  end

  # Create Hash from discord API response
  # ++guild_hash++ guild object returned by API
  #   example:  {
  #               id: "81384788765712384",
  #               name: "Discord API",
  #               icon: "2aab26934e72b4ec300c5aa6cf67c7b3",
  #               permissions: 104188929,
  #               owner: false
  #             }
  # ++user++ current_user that will be added to this guild
  def self.from_hash(guild_hash, user)
    guild = Guild.find_or_create_by(uid: guild_hash['id']) do |guild|
      guild.name = guild_hash['name']
      guild.icon = guild_hash['icon']
    end

    GuildPermission.find_or_create_by(user: user, guild: guild) do |guild_permission|
      guild_permission.user = user
      guild_permission.guild = guild
      guild_permission.owner = guild_hash['owner']
      guild_permission.permissions = guild_hash['permissions']
    end

    guild
  end
end
