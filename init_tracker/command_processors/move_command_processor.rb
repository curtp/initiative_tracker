# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class MoveCommandProcessor < BaseCommandProcessor

      def child_process(result)
        if !command.num_provided?
          InitTrackerLogger.log.debug {"Move Command: Name provided: #{command.character_name}, #{command.position_number}"}
          char = init.find_character_by_name(command.character_name)
          position_number = init.postion_number_for_character(char)
          if position_number.present?
            position_number = position_number + 1
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
