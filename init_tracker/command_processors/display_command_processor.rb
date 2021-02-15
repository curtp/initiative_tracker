# frozen_string_literal: true
require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class DisplayCommandProcessor < BaseCommandProcessor

      def child_process(result)
        # Do nothing because the base class will display the init if the command is configured to do so
        InitTrackerLogger.log.debug {"DisplayCommandProcessor.process: result: #{result}"}
      end
    end
  end
end
