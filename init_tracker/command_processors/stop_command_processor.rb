require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class StopCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        InitTrackerLogger.log.debug {"StopCommandProcessor.process: validation result: #{validation_result}"}
        if validation_result[:valid]
          init = find_init
          if init.present?
            init.destroy
            command.event << "End of initiative."
          else
            result[:success] = false
            result[:error_message] = initiative_not_started_message
          end
        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        InitTrackerLogger.log.debug {"StopCommandProcessor.process: returning result: #{result}"}
        return result
      end
    end
  end
end
