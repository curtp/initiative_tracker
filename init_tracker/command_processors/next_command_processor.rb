# frozen_string_literal: true
require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class NextCommandProcessor < BaseCommandProcessor

      def child_process(result)
        init.next!(command.position_number)

        InitTrackerLogger.log.debug {"NextCommandProcessor.process: result: #{result}"}
      end
    end
  end
end
