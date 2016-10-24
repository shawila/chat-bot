class Raid < ActiveRecord::Base
  belongs_to :guild
  has_many :phases

  accepts_nested_attributes_for :phases, allow_destroy: true

  enum raid_type: [:pit, :tank]

  default_scope { includes(:phases) }

  after_create :announce

  def display
    display = "#{I18n.t("raid.raid_type.#{raid_type}")}"
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
  def self.raid_info(types = Raid.raid_types.keys, time = Time.zone.now)
    raids = joins(:phases).order('phases.start ASC').where('phases.start > ?', time - 9.hours).where(raid_type: types)
    types.map do |type|
      result = raids.select { |raid| raid.raid_type = type }
      if result.first.passed?
        result.take(2)
      else
        result.take(1)
      end
    end.flatten
  end

  private

  def announce
    return if guild.announcement_channel.nil?

    OmegaDiscordBot.announce(guild.name, guild.announcement_channel, display, phases)
  end
end
