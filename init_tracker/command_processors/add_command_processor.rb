require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class AddCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        InitTrackerLogger.log.debug { "AddCommandProcessor.process: validation result: #{validation_result}" }

        if validation_result[:valid]
          if initiative_started?
            init = find_init

            init.add_character!(command.character_name, command.dice, command.event.user)

            print_init(init)
          else
            result[:success] = false
            result[:error_message] = initiative_not_started_message
          end
        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        InitTrackerLogger.log.debug {"AddCommandProcessor.process: returning result: #{result}"}
        return result
      end

    end
  end
end
