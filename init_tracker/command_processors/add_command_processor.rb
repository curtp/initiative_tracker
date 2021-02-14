require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class AddCommandProcessor < BaseCommandProcessor

      def child_process
        result = build_success_result

        init.add_character!(command.character_name, command.dice, command.event.user)

        print_init(init)

        InitTrackerLogger.log.debug {"AddCommandProcessor.process: returning result: #{result}"}
        return result
      end

    end
  end
end
