require 'discordrb'

class ShababDiscordBot
  def self.run!(discord_bot_token, discord_app_id)
    chat_bot = Discordrb::Bot.new token: discord_bot_token, application_id: discord_app_id
    command_bot = Discordrb::Commands::CommandBot.new token: discord_bot_token, application_id: discord_app_id, prefix: '!'

    chat_bot.message(with_text: "Hey Bot!") do |event|
      event.respond "Hi, #{event.user.name}!"
    end

    command_bot.command :dice do |event, max|
      max = 6 if max.nil? or max.to_i < 2
      rand(1 .. max.to_i)
    end

    chat_bot.run :async
    command_bot.run :async
  end
end

