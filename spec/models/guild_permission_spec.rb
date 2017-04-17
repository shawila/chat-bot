require 'rails_helper'
require 'bitfields/rspec'

RSpec.describe GuildPermission, type: :model do
  let(:guild) { Fabricate(:guild) }
  let(:user) { Fabricate(:user) }
  let(:permissions) { 8 }
  let(:guild_permission) do
    Fabricate(:guild_permission, user: user, guild: guild, owner: true, permissions: permissions)
  end

  it do
    expect(have_a_bitfield :permissions).to be_truthy
  end
end
