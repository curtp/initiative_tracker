# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class DisplayCommandProcessor < BaseCommandProcessor

      def child_process(result)
        # Remove the message id from the init so it will be replaced with a new one
        init.message_id = nil
        # Do nothing because the base class will display the init if the command is configured to do so
        InitTrackerLogger.log.debug {"DisplayCommandProcessor.process: result: #{result}"}
      end
    end
  end
end
