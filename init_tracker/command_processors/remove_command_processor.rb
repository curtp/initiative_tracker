# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class RemoveCommandProcessor < BaseCommandProcessor

      def child_process(result)
        init.remove_character!(command.position_number)
        InitTrackerLogger.log.debug {"RemoveCommandProcessor.process: result: #{result}"}
      end

      private

    end
  end
end
