require_relative "./base_command"
module InitTracker
  module Models
    class RemoveCommand < BaseCommand
      # The name of the character to remove from initiative
      def character_name
        instructions.last
      end

      # Position to remove from initiative
      def position_number
        instructions.last.to_i
      end
    end
  end
end
