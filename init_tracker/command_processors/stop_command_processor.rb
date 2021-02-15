# frozen_string_literal: true
require_relative "./base_command_processor"
require_relative "../models/init"

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
