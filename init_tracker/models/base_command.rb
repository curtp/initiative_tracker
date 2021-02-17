module InitTracker
  module Models
    class BaseCommand
      attr_accessor :event

      def initialize(event)
        self.event = event
      end

      def content
        event.message.content
      end

      def instructions
        content.tokenize.drop(1)
      end

      def base_instruction
        instructions[0]
      end

      def help_command?
        return false
      end

      def display_error?
        return true
      end

      def init_required?
        return true
      end
      
      def display_init?
        return true
      end

      # Returns true if the user executing the command is the bot owner
      def bot_owner?
        return self.event.user.id.to_s.eql?(ENV["BOT_OWNER_ID"].to_s)
      end
      
    end
  end
end
