module InitTracker
  module Models
    class AddCommand < BaseCommand
      include InitTracker::Models::Concerns::DiceConcern

      # The name of the character to add to initiative
      def character_name
        instructions[instructions.size - 2]
      end
    end
  end
end
