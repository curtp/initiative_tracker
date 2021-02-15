# frozen_string_literal: true
require 'discordrb'
require 'dotenv/load'
require "active_record"
require "yaml"

# Load non-Discordrb modules
Dir["#{File.dirname(__FILE__)}/init_tracker/**/*.rb"].each { |f| load(f) }

# Setup the logger
InitTrackerLogger.log_level = Logger::DEBUG
InitTrackerLogger.log_destination = InitTracker.config[:log_file]

# Connect to the database and run any pending migrations
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: InitTracker.config[:database_file])
ActiveRecord::Base.logger = InitTrackerLogger.log
InitTracker::Database::Migration.migrate(:up)

# Establish the bot and connect
bot = Discordrb::Commands::CommandBot.new(token: ENV["BOT_TOKEN"], prefix: "!")
# Create the command for the bot and process the events
bot.command(:init, aliases: [:i], description: "Master command for communicating with the Init Tracker") do |event|
  InitTracker::CommandProcessors::InitTrackerCommandProcessor.execute(InitTracker::Models::CommandFactory.create_command_for_event(event))
end

bot.reaction_add do |event|
  InitTracker::CommandProcessors::InitTrackerCommandProcessor.execute(InitTracker::Models::CommandFactory.create_command_for_event(event))
end

# This runs when the bot is added to a server.
bot.server_create do |event|
  InitTracker::Models::Server.bot_joined_server(event)
end

# This runs when the bot is removed from a server.
bot.server_delete do |event|
  InitTracker::Models::Server.bot_left_server(event)
end

# When the bot is ready, set the status so people know how to interact with it
bot.ready do |event|
  InitTrackerLogger.log.debug("Ready event")
  bot.update_status("online", "!init", nil, since = 0, afk = false, activity_type = 2)
end

# Startup the bot
bot.run