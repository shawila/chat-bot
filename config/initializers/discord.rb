require 'discordrb'

DISCORD_BOT_TOKEN = ENV['DISCORD_BOT_TOKEN']
DISCORD_APP_ID = ENV['DISCORD_APP_ID']

unless defined?(::Rake)
  chat_bot = Discordrb::Bot.new token: DISCORD_BOT_TOKEN, application_id: DISCORD_APP_ID
  command_bot = Discordrb::Commands::CommandBot.new token: DISCORD_BOT_TOKEN, application_id: DISCORD_APP_ID, prefix: '!'

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

