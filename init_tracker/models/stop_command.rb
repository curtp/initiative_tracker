require_relative "./base_command"
module InitTracker
  module Models
    class StopCommand < BaseCommand
      def display_init?
        return false
      end
    end
  end
end
