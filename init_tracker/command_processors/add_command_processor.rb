# frozen_string_literal: true
require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class AddCommandProcessor < BaseCommandProcessor

      def child_process(result)
        init.add_character!(command.character_name, command.dice, command.event.user)

        InitTrackerLogger.log.debug {"AddCommandProcessor.process: result: #{result}"}
      end

    end
  end
end
