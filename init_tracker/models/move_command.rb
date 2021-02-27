module InitTracker
  module Models
    class MoveCommand < BaseCommand
      include InitTracker::Models::Concerns::CharacterConcern

      def direction
        instructions.last.strip.downcase
      end

      def up?
        direction.eql?("up")
      end

      def down?
        direction.eql?("down")
      end

    end
  end
end
