# frozen_string_literal: true
require_relative "./base_command_processor"
require_relative "../models/init"

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
