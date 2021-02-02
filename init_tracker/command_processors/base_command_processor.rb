require_relative "../validators/command_validator"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class BaseCommandProcessor

      attr_accessor :command

      def initialize(command)
        self.command = command
      end

      protected

      def print_init(init)
        header = "Initiative Order"
        length = header.size
        command.event << "```"
        command.event << header
        command.event << "=" * length
        init.characters.each_with_index do |character, ndx|
          msg = "#{ndx+1} - #{character[:name]} (#{character[:dice]} : #{character[:number]})"
          if character[:went]
            msg = msg << " (done)"
          end
          if character[:up]
            msg = msg << " <= You're Up!"
          end
          command.event << msg
        end
        command.event << "```"
      end

      def initiative_started?
        find_init.present?
      end

      def validate_init_started
        if !initiatve_started
          command.event << initiative_not_started_message
          return false
        end
        return true
      end

      def initiative_not_started_message
        "Initiative not started. To start tracking initiative, run the start command.".freeze
      end

      def validate_command
        InitTracker::Validators::CommandValidator.validate(command)
      end

      def find_init
        InitTracker::Models::Init.where(server_id: command.event.server.id, channel_id: command.event.channel.id).first
      end

    end
  end
end
