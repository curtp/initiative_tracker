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
            when "stats".freeze
              processor = StatsCommandProcessor.new(command)
            else
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
