# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class RemoveCommandProcessor < BaseCommandProcessor

      def child_process(result)
        if !command.num_provided?
          InitTrackerLogger.log.debug {"Remove Command: Name provided: #{command.character_name}, #{command.position_number}"}
          char = init.find_character_by_name(command.character_name)
          position_number = init.postion_number_for_character(char)
          if position_number.present?
            position_number = position_number + 1
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
