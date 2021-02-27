# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class RerollCommandProcessor < BaseCommandProcessor

      def child_process(result)

        if !command.position_number_provided? && !command.character_name_provided?
          init.reroll!
        elsif command.character_name_provided?
          InitTrackerLogger.log.debug {"Reroll Command: Name provided: #{command.character_name}, #{command.position_number}"}
          position_number = position_number_for_character(command.character_name)
          if position_number.present?
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
