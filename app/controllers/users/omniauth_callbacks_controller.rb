class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def discord
    @user = User.from_omniauth(auth_hash)

    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => 'Discord') if is_navigational_format?
    else
      redirect_to '/'
    end
  end

  def failure
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
