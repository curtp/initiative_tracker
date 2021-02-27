module InitTracker
	module Models
		module Concerns
			module CharacterConcern

				# The name of the character to update
				def character_name
					# If the character name is actually a name, return it. If it is a number, return nil
					num = number_or_nil(instructions[1])
					num.present? ? nil : instructions[1]
				end

				# Returns the postion number for the command if the number was provided,
				# otherwise returns nil
				def position_number
					num = number_or_nil(instructions[1])
					num.present? ? instructions[1].to_i : nil
				end

				def position_number_provided?
					position_number.present?
				end

				def character_name_provided?
					character_name.present?
				end
	
			end
		end
	end
end
