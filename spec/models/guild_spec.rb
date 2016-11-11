require 'rails_helper'

RSpec.describe Guild, type: :model do
  let(:guild) { Fabricate(:guild) }
  let(:user) { Fabricate(:user) }
  let(:guild_permission) { Fabricate(:guild_permission, user: user, guild: guild, owner: true, permissions: 666) }

  let(:uid) { 'UID' }
  let(:guild_hash) do
    {
      id: uid,
      name: 'NAME',
      icon: 'ICON',
      permissions: 911,
      owner: false
    }.with_indifferent_access
  end

  describe '#owner?' do
    it do
      guild_permission # lazily instantiated
      expect(guild.owner?(user)).to be_truthy
    end
  end

  describe '#permissions' do
    it do
      guild_permission
      expect(guild.permissions(user)).to be 666
    end
  end

  describe '#from_hash' do
    it 'creates a guild from discord hash' do
      new_guild = Guild.from_hash(guild_hash, user)
      expect(new_guild.uid).to eq 'UID'
      expect(new_guild.name).to eq 'NAME'
      expect(new_guild.icon).to eq 'ICON'

      new_guild_permissions = GuildPermission.where(user: user, guild: new_guild)
      expect(new_guild_permissions.count).to be 1

      new_guild_permission = new_guild_permissions.first
      expect(new_guild_permission.permissions).to be 911
      expect(new_guild_permission.owner).to be_falsey
    end

    context 'guild is already present in DB' do
      let(:uid) { guild.uid }

      it 'returns old guild if already created' do
        guild_permission
        expect(GuildPermission.count).to be 1

        expect(Guild.from_hash(guild_hash, user)).to eq guild
        expect(GuildPermission.count).to be 1
      end
    end
  end
end
