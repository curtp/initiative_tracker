module InitTracker
  module Models
    class StatsCommand < BaseCommand
      def init_required?
        return false
      end
      
      def display_init?
        return false
      end
    end
  end
end
