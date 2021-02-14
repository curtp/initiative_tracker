require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class RemoveCommandProcessor < BaseCommandProcessor

      def child_process
        result = build_success_result
        init.remove_character!(command.position_number)
        print_init(init)
        InitTrackerLogger.log.debug {"RemoveCommandProcessor.process: returning result: #{result}"}
        return result
      end

      private

    end
  end
end
