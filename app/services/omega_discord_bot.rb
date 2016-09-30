require 'discordrb'

class OmegaDiscordBot
  CHANNEL = 'raid_schedule'
  SERVER = 'Legendary Omega'

  @@next_raid_time = nil
  @@chat_bot = nil

  def self.run!(discord_bot_token, discord_app_id)
    @@chat_bot = Discordrb::Bot.new token: discord_bot_token, application_id: discord_app_id
    command_bot = Discordrb::Commands::CommandBot.new token: discord_bot_token, application_id: discord_app_id, prefix: '!'

    @@chat_bot.message(in: "##{CHANNEL}", containing: 'Omega Raid Schedule (Tier 7)') do |event|
      message = event.message.content
      set_next_raid(message)
    end

    @@chat_bot.message_edit(in: "##{CHANNEL}", containing: 'Omega Raid Schedule (Tier 7)') do |event|
      @@next_raid_time = nil
    end

    command_bot.command(:raid, description: 'Shows time until raid/zerg in hours/minutes') do
      next_raid(@@next_raid_time)
    end

    @@chat_bot.run :async
    command_bot.run :async

    at_exit do
      @@chat_bot.stop
      command_bot.stop
    end
  end

  def self.set_next_raid(message = nil)
    # if (message.nil?)
    #   message = @@chat_bot.find_channel(CHANNEL, SERVER).first.history(10).map(&:content).select do |message|
    #     message.include?('Omega Raid Schedule (Tier 7)')
    #   end.first
    # end
    #
    # date_string = message.match(/Date: +(.*)/)[1]
    # time_string = message.match(/([0-9:]*) UTC/)[1]
    # next_day = message.scan(/UTC \(/).count == 2
    #
    # @@next_raid_time = Time.parse("#{date_string} #{time_string} UTC")
    # @@next_raid_time = @@next_raid_time + 1.day if next_day
    @@next_raid_time = Time.parse('September 29 2016 23:00 UTC')
  end

  def self.next_raid(raid_time)
    raid_time = set_next_raid if raid_time.nil?

    zerg_time = raid_time + 36.hours
    now = Time.zone.now

    hours = ((raid_time - now) / 1.hour).to_i
    minutes = ((raid_time - now - hours.hours) / 1.minute).round

    if (now < raid_time)
      "Next raid starts in **#{hours} hours and #{minutes} minutes**!"
    elsif (now < zerg_time)
      "Raid started **#{- hours} hours and #{- minutes} minutes** ago!\nZerg starts in **#{36 + hours} hours and #{60 + minutes} minutes**!"
    else
      "Raid started **#{- hours} hours and #{- minutes} minutes** ago!\nZerg started **#{- hours - 9} hours and #{- minutes} minutes** ago!"
    end
  end
end

