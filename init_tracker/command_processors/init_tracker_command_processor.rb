# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class InitTrackerCommandProcessor

      def self.execute(command)

        begin

          if command.is_a?(InitTracker::Models::ReactionCommand)
            InitTrackerLogger.log.info("InitTrackerCommandProcessor: Server: #{command.event.server.id}, User: #{command.event.user.name} reacted: #{command.emoji}")
            processor = ReactionCommandProcessor.new(command)
          else
            InitTrackerLogger.log.info("InitTrackerCommandProcessor: Server: #{command.event.server.id}, User: #{command.event.user.name} issued command: #{command.event.message.content}")            
            
            case command.base_instruction
            when "add"
              processor = AddCommandProcessor.new(command)
            when "remove"
              processor = RemoveCommandProcessor.new(command)
            when "start"
              processor = StartCommandProcessor.new(command)
            when "stop"
              processor = StopCommandProcessor.new(command)
            when "next"
              processor = NextCommandProcessor.new(command)
            when "reroll"
              processor = RerollCommandProcessor.new(command)
            when "display"
              processor = DisplayCommandProcessor.new(command)
            when "reset"
              processor = ResetCommandProcessor.new(command)
            when "stats"
              processor = StatsCommandProcessor.new(command)
            when "move"
              processor = MoveCommandProcessor.new(command)
            when "update"
              processor = UpdateCommandProcessor.new(command)
            else
              InitTrackerLogger.log.debug {"Creating the help command processor"}
              processor = HelpCommandProcessor.new(command)
            end
          end

          result = processor.process

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
