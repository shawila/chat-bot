module Bot
  module Discord
    module Omega
      def self.run
        @omega_bot = OmegaBot.new OMEGA_DISCORD_BOT_TOKEN, OMEGA_DISCORD_APP_ID
      end

      def self.announce(guild_name, channel_name, raid_name, phases)
        unless @omega_bot
          @omega_bot = OmegaBot.new OMEGA_DISCORD_BOT_TOKEN, OMEGA_DISCORD_APP_ID
        end
        @omega_bot.announce(guild_name, channel_name, raid_name, phases)
      end

      ############
      # API calls
      ############

      def self.guilds(user)
        require 'discordrb'
        JSON.parse(Discordrb::API::User.servers(token(user)).body)
      end

      def self.token(user)
        "Bearer #{user.token}"
      end
    end
  end
end
