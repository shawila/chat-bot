class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def new_session_path(_scope)
    new_user_session_path
  end
end
