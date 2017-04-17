class GuildPermission < ActiveRecord::Base
  include Bitfields
  bitfield :permissions, 8 => :administrator, 16 => :manage_channels, 32 => :manage_server, 268_435_456 => :manage_roles

  belongs_to :user
  belongs_to :guild

  scope :user_permissions, -> (user_id) { where(user_id: user_id) }

  def has_access?
    administrator? || manage_channels? || manage_server? || manage_roles?
  end
end
