# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class StatsCommandProcessor < BaseCommandProcessor

      def child_process(result)
        server_count = InitTracker::Models::Server.count
        last_server = InitTracker::Models::Server.order("created_at desc").first
        init_count = InitTracker::Models::Init.count
        last_init = InitTracker::Models::Init.order("created_at desc").first
        updated_init = InitTracker::Models::Init.order("updated_at desc").first
        datetime_format = "%Y/%m/%d at %I:%M:%S %p"
        command.event << "Servers:"
        command.event << "  **# Servers:** #{server_count}"
        command.event << "  **Last Added:** #{last_server.created_at.in_time_zone(ENV["BOT_OWNER_TIME_ZONE"]).strftime(datetime_format)}"
        command.event << "  **# Active:** #{InitTracker::Models::Server.where("removed_on is null").count}"
        command.event << "  **# Removed:** #{InitTracker::Models::Server.where("removed_on is not null").count}"
        command.event << " "
        command.event << "Inits:"
        command.event << "  **# Inits:** #{init_count}"
        command.event << "  **Last Added:** #{last_init.created_at.in_time_zone(ENV["BOT_OWNER_TIME_ZONE"]).strftime(datetime_format)}"
        command.event << "  **Last Updated:** #{last_init.updated_at.in_time_zone(ENV["BOT_OWNER_TIME_ZONE"]).strftime(datetime_format)}"
      end
    end
  end
end
