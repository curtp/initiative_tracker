# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class RerollCommandProcessor < BaseCommandProcessor

      def child_process(result)

        if !command.position_number.present? && !command.character_name.present?
          init.reroll!
        elsif !command.num_provided?
          InitTrackerLogger.log.debug {"Reroll Command: Name provided: #{command.character_name}, #{command.position_number}"}
          char = init.find_character_by_name(command.character_name)
          position_number = init.postion_number_for_character(char)
          if position_number.present?
            position_number = position_number + 1
            init.reroll!(position_number)
          end
        else
          init.reroll!(command.position_number)
        end
        InitTrackerLogger.log.debug {"RerollCommandProcessor.process: result: #{result}"}
      end

    end
  end
end
