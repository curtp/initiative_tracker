require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class DisplayCommandProcessor < BaseCommandProcessor

      def child_process
        result = build_success_result
        print_init(init)
        InitTrackerLogger.log.debug {"DisplayCommandProcessor.process: returning result: #{result}"}
        return result
      end
    end
  end
end
