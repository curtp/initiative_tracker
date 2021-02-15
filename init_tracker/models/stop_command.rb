module InitTracker
  module Models
    class StopCommand < BaseCommand
      def display_init?
        return false
      end
    end
  end
end
