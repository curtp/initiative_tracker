require_relative "./base_command"
module InitTracker
  module Models
    class AddCommand < BaseCommand
      # The name of the character to add to initiative
      def character_name
        instructions[instructions.size - 2]
      end

      def dice
        instructions.last
      end
    end
  end
end
