require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class NextCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command

        if !validation_result[:valid]
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
          InitTrackerLogger.log.debug {"NextCommandProcessor.process: returning result: #{result}"}
          return result
        end

        init = find_init
        if !init.present?
          result[:success] = false
          result[:error_message] = initiative_not_started_message
          InitTrackerLogger.log.debug {"NextCommandProcessor.process: returning result: #{result}"}
          return result
        end

        init.next!(command.position_number)
        print_init(init)

        InitTrackerLogger.log.debug {"NextCommandProcessor.process: returning result: #{result}"}
        return result
      end
    end
  end
end
