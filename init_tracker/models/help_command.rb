require_relative "./base_command"
module InitTracker
  module Models
    class HelpCommand < BaseCommand
      def help_command?
        return true
      end

      def init_required?
        return false
      end
    end
  end
end
