class GuildPermission < ActiveRecord::Base
  belongs_to :user
  belongs_to :guild

  scope :user_permissions, -> (user_id) { where(user_id: user_id) }
end
