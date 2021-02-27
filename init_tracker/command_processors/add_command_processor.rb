# frozen_string_literal: true
# require_relative "./base_command_processor"

module InitTracker
	module CommandProcessors
		class AddCommandProcessor < BaseCommandProcessor

			def child_process(result)
				if command.dice_formatted_properly?
					init.add_character!(command.character_name, command.dice, nil, command.event.user)
				else
					init.add_character!(command.character_name, nil, command.number, command.event.user)
				end

				InitTrackerLogger.log.debug {"AddCommandProcessor.process: result: #{result}"}
			end

		end
	end
end
