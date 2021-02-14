require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class ResetCommandProcessor < BaseCommandProcessor

      def child_process
        result = build_success_result
        init.reset!
        print_init(init)
        InitTrackerLogger.log.debug {"ResetCommandProcessor.process: returning result: #{result}"}
        return result
      end

    end
  end
end
