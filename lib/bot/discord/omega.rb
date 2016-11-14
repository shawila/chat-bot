module Bot
  module Discord
    module Omega
      def self.run
        @omega_bot = OmegaBot.new OMEGA_DISCORD_BOT_TOKEN, OMEGA_DISCORD_APP_ID
      end

      def self.announce(guild_name, channel_name, raid_name, phases)
        @omega_bot.announce(guild_name, channel_name, raid_name, phases)
      end

      ############
      # API calls
      ############

      def self.guilds(user)
        require 'discordrb'
        JSON.parse(Discordrb::API.servers(token(user)).body)
      end

      def self.channels(guild, user)
        require 'discordrb'
        # TODO: fix permissions for this
        JSON.parse(Discordrb::API.server(token(user), guild.uid).body)
      end

      def self.token(user)
        "Bearer #{user.token}"
      end
    end
  end
end
