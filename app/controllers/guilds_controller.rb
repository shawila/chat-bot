class GuildsController < ApplicationController
  before_action :check_permissions, only: [:edit, :update]

  def index
    @guilds ||= Bot::Discord::Omega.guilds(current_user).map do |guild_hash|
      Guild.from_hash(guild_hash, current_user)
    end
  end

  def edit
    @guild = current_guild
  end

  def update
    @guild = current_guild
    if @guild.update(guild_params)
      redirect_to guilds_path
    else
      render :edit
    end
  end

  private

  def check_permissions
    unless current_guild.has_access?(current_user)
      flash[:danger] = I18n.t('errors.guild.no_permission')
      redirect_to guilds_path
    end
  end

  def current_guild
    @guild = Guild.find(params[:id])
  end

  def guild_params
    params.require(:guild).permit(:announcement_channel)
  end
end
