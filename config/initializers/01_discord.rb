OMEGA_DISCORD_APP_ID = ENV['OMEGA_DISCORD_APP_ID']
OMEGA_DISCORD_SECRET = ENV['OMEGA_DISCORD_SECRET']
OMEGA_DISCORD_BOT_TOKEN = ENV['OMEGA_DISCORD_BOT_TOKEN']

OmegaDiscordBot.run! unless defined?(::Rake) || Rails.env.test?
