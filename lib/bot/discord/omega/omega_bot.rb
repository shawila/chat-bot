module Bot::Discord::Omega
  class OmegaBot
    def initialize(token, application_id)
      require 'discordrb'

      @bot = Discordrb::Bot.new token: token, client_id: application_id
      command_bot = Discordrb::Commands::CommandBot.new token: token, application_id: application_id, prefix: '!'

      @bot.message(in: '#living_room', containing: 'Grandepatron') do |event|
        event.respond 'All hail the bearded warrior!'
      end

      command_bot.command(:raid, description: raid_command_description) do |event, type|
        return unless Rails.env.production? || event.server.name == 'Test'
        raid_info(event.server.id, type ? [Raid.raid_types[type]] : Raid.raid_types.values)
      end

      command_bot.command(:raids, description: raid_command_description) do |event, type|
        return unless Rails.env.production? || event.server.name == 'Test'
        raid_info(event.server.id, type ? [Raid.raid_types[type]] : Raid.raid_types.values, return_all = true)
      end

      @bot.run :async
      command_bot.run :async

      at_exit do
        @bot.stop
        command_bot.stop
      end
    end

    def announce(guild_name, channel_name, raid_name, phases)
      message = "**Next raid schedule: #{raid_name}**\n"
      phases.each do |phase|
        message += "#{phase.name}:\t#{phase.start.strftime('%d %b %Y ~ %H:%M (%Z)')}\n"
      end
      message += "\n"

      # TODO: consider case of multiple hits
      channel_id = @bot.find_channel(channel_name, guild_name).first
      return if channel_id.blank?
      channel_id = channel_id.id
      @bot.send_message(channel_id, message)
    end

    private

    def raid_info(guild_uid, types, return_all = false)
      message = ''
      Raid.raid_info(guild_uid, types, return_all).each do |raid|
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

    def message(phase, name = nil)
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

    def raid_command_description
      'Shows time until next raid (including all phases) in hours/minutes\nPass type to get specific raid (ex. !raid pit, !raid tank)'
    end

    def raids_command_description
      'Shows time for all current/future raids (including all phases) in hours/minutes\nPass type to get specific raids (ex. !raids pit, !raids tank)'
    end
  end
end
