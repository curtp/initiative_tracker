require_relative "../validators/command_validator"
require_relative "./add_command_processor"
require_relative "./remove_command_processor"
require_relative "./start_command_processor"
require_relative "./stop_command_processor"
require_relative "./help_command_processor"
require_relative "./next_command_processor"
require_relative "./reroll_command_processor"
require_relative "./display_command_processor"
require_relative "./reset_command_processor"
require_relative "./reaction_command_processor"

module InitTracker
  module CommandProcessors
    class InitTrackerCommandProcessor

      def self.execute(command)

        begin
          InitTrackerLogger.log.info("InitTrackerCommandProcessor: Server: #{command.event.server.id}, User: #{command.event.user.name} issued command: #{command.event.message.content}")

          init_required = true

          if command.help_command?
            processor = HelpCommandProcessor.new(command)
            init_required = false
          elsif command.is_a?(InitTracker::Models::ReactionCommand)
            processor = ReactionCommandProcessor.new(command)
          else
            case command.base_instruction
            when "add".freeze
              processor = AddCommandProcessor.new(command)
            when "remove".freeze
              processor = RemoveCommandProcessor.new(command)
            when "start".freeze
              processor = StartCommandProcessor.new(command)
              init_required = false
            when "stop".freeze
              processor = StopCommandProcessor.new(command)
            when "next".freeze
              processor = NextCommandProcessor.new(command)
            when "reroll".freeze
              processor = RerollCommandProcessor.new(command)
            when "display".freeze
              processor = DisplayCommandProcessor.new(command)
            when "reset".freeze
              processor = ResetCommandProcessor.new(command)
            else
              processor = HelpCommandProcessor.new(command)
            end
          end

          result = processor.process(init_required: init_required)

          if !result[:success] && command.display_error?
            command.event.send_message("Sorry! #{result[:error_message]}\n\nSee !init help for usage information")
          end
        rescue Exception => e
          InitTrackerLogger.log.error("InitTrackerCommandProcessor: Issue processing request: #{e}")
          InitTrackerLogger.log.error(e.backtrace.join("\n"))
        end
      end
    end
  end
end
