# frozen_string_literal: true
module InitTracker
  module Models
    class Server < ActiveRecord::Base
      has_many :inits, primary_key: :server_id

      serialize :settings, Hash

      after_initialize :add_missing_attributes

      def self.bot_joined_server(event)
        InitTrackerLogger.log.info("Server: bot just joined server: '#{event.server.name}' (ID: #{event.server.id}), owned by '#{event.server.owner.distinct}' the server count is now #{event.bot.servers.count}")
        # Look for an existing server with the ID of the server in the event.
        # If not there, create a new server record. If it is there, simply
        # wipe out the removed_on and removed_by_user columns so they aren't
        # populated anymore
        server = Server.where(server_id: event.server.id).first
        if server.present?
          server.update(removed_on: nil)
        else
          server = Server.create(server_id: event.server.id, server_name: event.server.name,
            added_by_user: event.server.owner.distinct)
        end
        InitTrackerLogger.log.debug {"Server: server: #{server.inspect}"}
      end

      def self.bot_left_server(event)
        InitTrackerLogger.log.info("Server: bot just left server: #{event.server}, the server count is now #{event.bot.servers.count}")
        server = Server.where(server_id: event.server).first
        if server.present?
          server.update(removed_on: Time.now.utc)
        end
        InitTrackerLogger.log.debug {"Server: server: #{server.inspect}"}
      end

      private

      # When the server loads, look for any missing attributes and add them
      def add_missing_attributes
        return if settings.has_key?(:in_place_edit)
        settings[:in_place_edit] = true
      end

    end
  end
end
