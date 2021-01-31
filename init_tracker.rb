require 'discordrb'
require 'dotenv/load'
require "active_record"
require "yaml"
require_relative './init_tracker/lib/init_tracker_logger'
require_relative './init_tracker/lib/string'
require_relative './init_tracker/command_processors/init_tracker_command_processor'
require_relative "./init_tracker/models/command_factory"
require_relative "./init_tracker/models/server"
require_relative "./init_tracker/database/migration"
require_relative "./init_tracker/lib/config"

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

# This runs when the bot is added to a server.
bot.server_create do |event|
  InitTracker::Models::Server.bot_joined_server(event)
end

# This runs when the bot is removed from a server.
bot.server_delete do |event|
  InitTracker::Models::Server.bot_left_server(event)
end

# Startup the bot
bot.run
