# frozen_string_literal: true

module InitTracker
	module CommandProcessors
		class UpdateCommandProcessor < BaseCommandProcessor

			def child_process(result)

				# If the character name was provided, use it to locate the character to update
				if command.character_name_provided?
					InitTrackerLogger.log.debug {"Update Command: Name provided: #{command.character_name}, #{command.position_number}"}
					position_number = position_number_for_character(command.character_name)
				else
					position_number = command.position_number
				end

				init.update!(position_number, command.dice, command.number)

				InitTrackerLogger.log.debug {"Update Command result: #{result}"}
			end

		end
	end
end
  