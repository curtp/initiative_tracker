# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class ResetCommandProcessor < BaseCommandProcessor

      def child_process(result)
        init.reset!
        InitTrackerLogger.log.debug {"ResetCommandProcessor.process: result: #{result}"}
      end

    end
  end
end
