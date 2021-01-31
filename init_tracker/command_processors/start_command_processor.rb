require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class StartCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        InitTrackerLogger.log.debug {"StartCommandProcessor.process: validation result: #{validation_result}"}
        if validation_result[:valid]
          # First, check to see if there is already an init for this server/channel combo
          # If there is, then throw an error
          # If there isn't, then start it up
          if initiative_started?
            result[:success] = false
            result[:error_message] = "Initiative has already been started in this channel."
          else
            InitTracker::Models::Init.create(server_id: command.event.server.id, channel_id: command.event.channel.id)
            command.event << "Everyone roll initiative!"
          end
        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        InitTrackerLogger.log.debug {"StartCommandProcessor.process: returning result: #{result}"}
        return result
      end
    end
  end
end
