class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :rememberable, :trackable, :omniauthable, :omniauth_providers => [:discord]

  has_many :guild_permissions
  has_many :guilds, through: :guild_permissions
  has_many :raids, through: :guilds

  def credentials(credentials)
    self.token = credentials['token']
    self.refresh_token = credentials['refresh_token']
    save
  end

  def self.from_omniauth(auth_hash)
    user = User.find_or_create_by(uid: auth_hash['uid']) do |user|
      user.username = auth_hash['info']['username']
      user.discriminator = auth_hash['info']['discriminator']
      user.avatar = auth_hash['info']['avatar']
      user.verified = auth_hash['info']['verified']
    end

    user.credentials(auth_hash['credentials'])
    user
  end
end
