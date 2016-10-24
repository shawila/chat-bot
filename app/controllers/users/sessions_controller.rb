class Users::SessionsController < Devise::SessionsController
  skip_before_action :authenticate_user!

  def new
    super do |resource|
      puts resource
    end
  end
end
