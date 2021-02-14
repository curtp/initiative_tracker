# frozen_string_literal: true
require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class StartCommandProcessor < BaseCommandProcessor

      def child_process
        result = build_success_result
        if initiative_started?
          result[:success] = false
          result[:error_message] = "Initiative has already been started in this channel."
        else
          InitTracker::Models::Init.create(server_id: command.event.server.id, channel_id: command.event.channel.id)
          command.event << "Everyone roll initiative!"
        end
        InitTrackerLogger.log.debug {"StartCommandProcessor.process: returning result: #{result}"}
        return result
      end
    end
  end
end
