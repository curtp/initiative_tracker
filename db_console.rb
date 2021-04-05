# frozen_string_literal: true
require 'irb'
require 'discordrb'
require 'dotenv/load'
require "active_record"
require "yaml"

# Load up classes which have early dependencies first
require_relative './init_tracker/command_processors/base_command_processor'
require_relative './init_tracker/models/base_command'
require_relative './init_tracker/models/concerns/character_concern'
require_relative './init_tracker/models/concerns/dice_concern'

# Load non-Discordrb modules
Dir["#{File.dirname(__FILE__)}/init_tracker/**/*.rb"].each { |f| load(f) }

# Setup the logger
InitTrackerLogger.log_level = Logger::DEBUG
InitTrackerLogger.log_destination = InitTracker.config[:log_file]

# Connect to the database and run any pending migrations
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: InitTracker.config[:database_file])
ActiveRecord::Base.logger = InitTrackerLogger.log
InitTracker::Database::Migration.migrate(:up)

IRB.start