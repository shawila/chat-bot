class GuildsController < ApplicationController
  def index
    @guilds ||= OmegaDiscordBot.guilds(current_user).map do |guild_hash|
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

  def current_guild
    @guild = Guild.find(params[:id])
  end

  def guild_params
    params.require(:guild).permit(:announcement_channel)
  end
end
