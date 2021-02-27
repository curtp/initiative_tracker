# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class MoveCommandProcessor < BaseCommandProcessor

      def child_process(result)
        if command.character_name_provided?
          InitTrackerLogger.log.debug {"Move Command: Name provided: #{command.character_name}, #{command.position_number}"}
          position_number = position_number_for_character(command.character_name)
          if position_number.present?
            InitTrackerLogger.log.debug {"Removing from position: #{position_number}"}
            init.move!(position_number, command.up?)
          end
        else
          init.move!(command.position_number, command.up?)
        end
        InitTrackerLogger.log.debug {"MoveCommandProcessor.process: result: #{result}"}
      end

    end
  end
end
