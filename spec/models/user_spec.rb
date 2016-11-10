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

  describe '#from_omniauth' do
    it 'creates user from omniauth hash' do
      new_user = User.from_omniauth(auth_hash)
      expect(new_user.uid).to eq 'UID'
      expect(new_user.username).to eq 'USERNAME'
      expect(new_user.discriminator).to eq 'DISC'
      expect(new_user.avatar).to eq 'AVATAR'
      expect(new_user.verified).to be_truthy
      expect(new_user.token).to eq 'TOKEN'
      expect(new_user.refresh_token).to eq 'REFRESH_TOKEN'
    end

    context 'user with same uid already exists' do
      let(:user) { Fabricate(:user, uid: 'UID', username: 'TARO') }

      it 'returns the old user and updates the credentials' do
        expect(user.token).to be_nil

        new_user = User.from_omniauth(auth_hash)
        expect(new_user.uid).to eq 'UID'
        expect(new_user.username).to eq 'TARO'
        expect(new_user.token).to eq 'TOKEN'
        expect(new_user.refresh_token).to eq 'REFRESH_TOKEN'
      end
    end
  end
end
