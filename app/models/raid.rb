class Raid < ActiveRecord::Base
  belongs_to :guild
  has_many :phases

  accepts_nested_attributes_for :phases, allow_destroy: true

  enum raid_type: [:pit, :tank]

  default_scope { includes(:phases) }

  after_create :announce

  def display
    display = I18n.t("raid.raid_type.#{raid_type}")
    display += " (#{name})" unless name.empty?
    display
  end

  # Returns last phase if it is in the past
  def passed?(time = Time.zone.now)
    last = phases.order('phases.start ASC').last
    return if last.start > time
    last
  end

  def self.last_raid(raid_type)
    where(raid_type: raid_type).last
  end

  # Returns first raid of the passed types (or of each type if none are passed)
  def self.raid_info(guild_uid, types, return_all = false, time = Time.zone.now)
    guild = Guild.where(uid: guild_uid).first
    raids = joins(:phases).order('phases.start ASC')
              .where('phases.start > ?', time - 9.hours)
              .where(raid_type: types)
              .where(guild_id: guild.id)
    return raids.all if return_all

    types.map do |type|
      result = raids.select { |raid| raid.raid_type == Raid.raid_types.keys[type] }
      next if result.blank?
      if result.size > 1 && result.first.passed?
        result.take(2)
      else
        result.take(1)
      end
    end.flatten.compact
  end

  private

  def announce
    return if guild.announcement_channel.nil?

    Bot::Discord::Omega.announce(guild.name, guild.announcement_channel, display, phases)
  end
end
