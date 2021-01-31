require_relative "../validators/command_validator"
require_relative "./add_command_processor"
require_relative "./remove_command_processor"
require_relative "./start_command_processor"
require_relative "./stop_command_processor"
require_relative "./help_command_processor"
require_relative "./next_command_processor"
require_relative "./reroll_command_processor"
require_relative "./display_command_processor"

module InitTracker
  module CommandProcessors
    class InitTrackerCommandProcessor

      def self.execute(command)

        begin
          InitTrackerLogger.log.info("InitTrackerCommandProcessor: Server: #{command.event.server.id}, User: #{command.event.user.name} issued command: #{command.event.message.content}")

          if command.help_command?
            processor = HelpCommandProcessor.new(command)
          else
            case command.base_instruction
            when "add".freeze
              processor = AddCommandProcessor.new(command)
            when "remove".freeze
              processor = RemoveCommandProcessor.new(command)
            when "start".freeze
              processor = StartCommandProcessor.new(command)
            when "stop".freeze
              processor = StopCommandProcessor.new(command)
            when "next".freeze
              processor = NextCommandProcessor.new(command)
            when "reroll".freeze
              processor = RerollCommandProcessor.new(command)
            when "display".freeze
              processor = DisplayCommandProcessor.new(command)
            else
              processor = HelpCommandProcessor.new(command)
            end
          end

          result = processor.process

          if !result[:success]
            command.event << "Sorry! #{result[:error_message]}"
            command.event << ""
            command.event << "See !init help for usage information"
          end
        rescue Exception => e
          InitTrackerLogger.log.error("InitTrackerCommandProcessor: Issue processing request: #{e}")
          InitTrackerLogger.log.error(e.backtrace.join("\n"))
        end
      end
    end
  end
end