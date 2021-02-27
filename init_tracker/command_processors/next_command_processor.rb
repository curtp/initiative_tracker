# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class NextCommandProcessor < BaseCommandProcessor

      def child_process(result)
        if !command.position_number_provided? && !command.character_name_provided?
          init.next!(nil)
        elsif command.character_name_provided?
          InitTrackerLogger.log.debug {"Move Command: Name provided: #{command.character_name}, #{command.position_number}"}
          position_number = position_number_for_character(command.character_name)
          if position_number.present?
            InitTrackerLogger.log.debug {"Removing from position: #{position_number}"}
            init.next!(position_number)
          end
        else
          init.next!(command.position_number)
        end

        InitTrackerLogger.log.debug {"NextCommandProcessor.process: result: #{result}"}
      end
    end
  end
end
