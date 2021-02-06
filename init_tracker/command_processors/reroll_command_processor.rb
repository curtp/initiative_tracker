require_relative "./base_command_processor"

module InitTracker
  module CommandProcessors
    class RerollCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        InitTrackerLogger.log.debug { "RerollCommandProcessor.process: validation result: #{validation_result}" }
        if validation_result[:valid]
          init = find_init
          if init.present?
            if init.present?
              init.reroll!
              init.reset!
              print_init(init)
            end
          else
            result[:success] = false
            result[:error_message] = initiative_not_started_message
          end
        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        InitTrackerLogger.log.debug {"RerollCommandProcessor.process: returning result: #{result}"}
        return result
      end

    end
  end
end
