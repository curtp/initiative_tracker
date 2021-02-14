# frozen_string_literal: true
require_relative "./base_command_processor"

module InitTracker
  module CommandProcessors
    class RerollCommandProcessor < BaseCommandProcessor

      def child_process
        result = build_success_result
        init.reroll!
        init.reset!
        print_init(init)
        InitTrackerLogger.log.debug {"RerollCommandProcessor.process: returning result: #{result}"}
        return result
      end

    end
  end
end
