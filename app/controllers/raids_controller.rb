class RaidsController < ApplicationController
  def index
    @guild = current_guild
    @raids = @guild.raids
  end

  def show
    @guild = current_guild
    @raid = current_raid
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
    @raid = current_raid
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
    @raid = current_raid
    if @raid.update(raid_params(true))
      redirect_to [@guild, @raid]
    else
      render :edit
    end
  end

  private

  def current_guild
    Guild.find(params[:guild_id])
  end

  def current_raid
    Raid.find(params[:id])
  end

  def raid_params(update = false)
    phases_attributes = [:name, :start, :_destroy]
    phases_attributes << :id if update
    params.require(:raid).permit(:name, :raid_type, phases_attributes: phases_attributes)
  end
end
