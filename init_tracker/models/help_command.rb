module InitTracker
  module Models
    class HelpCommand < BaseCommand
      def help_command?
        return true
      end

      def init_required?
        return false
      end

      def display_init?
        return false
      end

    end
  end
end
