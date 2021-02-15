# frozen_string_literal: true
require_relative "./base_command_processor"

module InitTracker
  module CommandProcessors
    class RerollCommandProcessor < BaseCommandProcessor

      def child_process(result)
        init.reroll!
        InitTrackerLogger.log.debug {"RerollCommandProcessor.process: result: #{result}"}
      end

    end
  end
end
