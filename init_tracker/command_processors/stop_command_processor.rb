# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class StopCommandProcessor < BaseCommandProcessor

      def child_process(result)
        init.destroy
        command.event.send_message(end_of_initiative_message)
        InitTrackerLogger.log.debug {"StopCommandProcessor.process: result: #{result}"}
      end
    end
  end
end
