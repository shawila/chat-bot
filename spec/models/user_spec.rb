require 'rails_helper'

RSpec.describe User, type: :model do
  let(:auth_hash) do
    {
      uid: 'UID',
      info: {
        username: 'USERNAME',
        discriminator: 'DISC',
        avatar: 'AVATAR',
        verified: true
      },
      credentials: {
        token: 'TOKEN',
        refresh_token: 'REFRESH_TOKEN'
      }
    }.with_indifferent_access
  end

  let(:user) { Fabricate(:user) }

  describe '#credentials?' do
    it 'sets user credentials' do
      expect(user.token).to be_nil
      expect(user.refresh_token).to be_nil

      user.credentials(auth_hash[:credentials])

      expect(user.token).to eq 'TOKEN'
      expect(user.refresh_token).to eq 'REFRESH_TOKEN'
    end
  end
end
