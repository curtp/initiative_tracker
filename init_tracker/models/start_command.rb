require_relative "./base_command"
module InitTracker
  module Models
    class StartCommand < BaseCommand
      def init_required?
        return false
      end
      
      def display_init?
        return false
      end
    end
  end
end
