# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class RemoveCommandProcessor < BaseCommandProcessor

      def child_process(result)
        if command.character_name_provided?
          InitTrackerLogger.log.debug {"Remove Command: Name provided: #{command.character_name}, #{command.position_number}"}
          position_number = position_number_for_character(command.character_name)
          if position_number.present?
            InitTrackerLogger.log.debug {"Removing from position: #{position_number}"}
            init.remove_character!(position_number)
          end
        else
          init.remove_character!(command.position_number)
        end
        InitTrackerLogger.log.debug {"RemoveCommandProcessor.process: result: #{result}"}
      end

    end
  end
end
