module InitTracker
  module Models
    class DisplayCommand < BaseCommand
      # Initiative to display - only works for bot owners
      def init_number
        return nil if !bot_owner?
        instructions.last.to_i
      end
    end
  end
end
