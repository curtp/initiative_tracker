# frozen_string_literal: true
require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class NextCommandProcessor < BaseCommandProcessor

      def child_process
        result = build_success_result
        
        init.next!(command.position_number)
        print_init(init)

        InitTrackerLogger.log.debug {"NextCommandProcessor.process: returning result: #{result}"}
        return result
      end
    end
  end
end
