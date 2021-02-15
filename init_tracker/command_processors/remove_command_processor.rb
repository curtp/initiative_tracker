# frozen_string_literal: true
require_relative "./base_command_processor"
require_relative "../models/init"

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
