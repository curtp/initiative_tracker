require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class NextCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        InitTrackerLogger.log.debug { "NextCommandProcessor.process: validation result: #{validation_result}" }

        if validation_result[:valid]
          init = find_init
          if init.present?
            init.next!(command.position_number)
            print_init(init)
          else
            result[:success] = false
            result[:error_message] = initiative_not_started_message
          end
        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end

        InitTrackerLogger.log.debug {"NextCommandProcessor.process: returning result: #{result}"}
        return result
      end

    end
  end
end
