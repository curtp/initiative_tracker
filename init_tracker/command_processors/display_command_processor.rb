# frozen_string_literal: true

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
