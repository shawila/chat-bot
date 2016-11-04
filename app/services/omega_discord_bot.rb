require 'discordrb'

class OmegaDiscordBot
  def self.chat_bot
    @chat_bot ||= Discordrb::Bot.new token: OMEGA_DISCORD_BOT_TOKEN, application_id: OMEGA_DISCORD_APP_ID
  end

  def self.run!
    command_bot = Discordrb::Commands::CommandBot.new token: OMEGA_DISCORD_BOT_TOKEN, application_id: OMEGA_DISCORD_APP_ID, prefix: '!'

    chat_bot.message(in: '#living_room', containing: 'Grandepatron') do |event|
      event.respond 'All hail the bearded warrior!'
    end

    command_bot.command(:raid, description: 'Shows time until next raid (including all phases) in hours/minutes') do |event|
      next_raid(event.server.id)
    end

    chat_bot.run :async
    command_bot.run :async

    at_exit do
      chat_bot.stop
      command_bot.stop
    end
  end

  def self.next_raid(guild_uid)
    message = ''
    Raid.raid_info(guild_uid).each do |raid|
      message += "\n~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n" unless message.empty?
      message += "**Raid: #{raid.display}**"

      if phase = raid.passed?
        message += "\n#{message(phase, 'Last phase')}"
        next
      end
      raid.phases.each do |phase|
        message += "\n#{message(phase)}"
      end
    end
    message
  end

  def self.announce(guild_name, channel_name, raid_name, phases)
    message = "**Next raid schedule: #{raid_name}**\n"
    phases.each do |phase|
      message += "#{phase.name}:\t#{phase.start.strftime('%d %b %Y ~ %H:%M (%Z)')}\n"
    end
    message += "\n"

    # TODO: consider case of multiple hits
    channel_id = chat_bot.find_channel(channel_name, guild_name).first
    raise 'Wrong announcement channel name' if channel_id.blank?
    channel_id = channel_id.id
    chat_bot.send_message(channel_id, message)
  end

  def self.message(phase, name = nil)
    time = phase.start
    now = Time.zone.now
    hours = ((time - now) / 1.hour).to_i
    minutes = ((time - now - hours.hours) / 1.minute).round

    name ||= phase.name
    if hours < 0 || minutes < 0
      "#{name}:\tstarted **#{- hours} hours and #{- minutes} minutes** ago"
    else
      "#{name}:\tstarts in **#{hours} hours and #{minutes} minutes**."
    end
  end

  ############
  # API calls
  ############

  def self.guilds(user)
    JSON.parse(Discordrb::API.servers(token(user)).body)
  end

  def self.channels(guild, user)
    JSON.parse(Discordrb::API.server(token(user), guild.uid).body)
  end

  def self.token(user)
    "Bearer #{user.token}"
  end
end
