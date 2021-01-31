require_relative "./base_command"
module InitTracker
  module Models
    class NextCommand < BaseCommand
      # Position to set as next up for initiative
      def position_number
        instructions.last.to_i
      end
    end
  end
end
