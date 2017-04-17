class RaidsController < ApplicationController
  before_action :check_permissions

  def index
    @guild = current_guild
    @raids = @guild.raids
  end

  def show
    @guild = current_guild
    @raid = current_raid(@guild)
  end

  def new
    @type = I18n.t("raid.raid_type.#{params[:type]}") # TODO: this could be done better maybe
    @guild = current_guild
    last_raid = @guild.raids.send(params[:type]).last
    @raid = @guild.raids.new
    @raid.raid_type = params[:type]
    @raid.phases = last_raid.phases.map(&:clone) unless last_raid.nil?
  end

  def edit
    @guild = current_guild
    @raid = current_raid(@guild)
  end

  def create
    @guild = current_guild
    @raid = @guild.raids.create(raid_params)
    if @raid.save
      redirect_to [@guild, @raid]
    else
      render :new
    end
  end

  def update
    @guild = current_guild
    @raid = current_raid(@guild)
    if @raid.update(raid_params(true))
      redirect_to [@guild, @raid]
    else
      render :edit
    end
  end

  def destroy
    @guild = current_guild
    @raid = current_raid(@guild)
    if @raid.delete
      redirect_to [@guild, @raid]
    end
  end

  private

  def check_permissions
    unless current_guild.has_access?(current_user)
      flash[:error] = "You do not have access to edit this guild's raids. Contact a guild admin for more info."
      redirect_to guilds_path
    end
  end

  def current_guild
    Guild.find(params[:guild_id])
  end

  def current_raid(guild = nil)
    if guild
      guild.raids.find(params[:id])
    else
      Raid.find(params[:id])
    end
  end

  def raid_params(update = false)
    phases_attributes = [:name, :start, :_destroy]
    phases_attributes << :id if update
    params.require(:raid).permit(:name, :raid_type, phases_attributes: phases_attributes)
  end
end
