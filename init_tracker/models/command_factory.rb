# frozen_string_literal: true

module InitTracker
  module Models
    class CommandFactory

      def self.create_command_for_event(event)

        InitTrackerLogger.log.debug {"CommandFactory: event.emoji: #{event.try(:emoji)}"}

        # Reaction commands are different than bot commands.
        if event.try(:emoji).try(:present?)
          InitTrackerLogger.log.debug {"CommandFactory: Creating a reaction command object for the event: #{event.emoji}"}
          
          return ReactionCommand.new(event)
        end

        InitTrackerLogger.log.debug {"CommandFactory: Creating command object for command: #{event.message.content.downcase.strip.split(" ")[1]}"}
        case event.message.content.downcase.strip.split(" ")[1]
        when "add"
          return AddCommand.new(event)
        when "remove"
          return RemoveCommand.new(event)
        when "next"
          return NextCommand.new(event)
        when "start"
          return StartCommand.new(event)
        when "stop"
          return StopCommand.new(event)
        when "reroll"
          return ReorderCommand.new(event)
        when "display"
          return DisplayCommand.new(event)
        when "reset"
          return ResetCommand.new(event)
        else
          return HelpCommand.new(event)
        end
      end

    end
  end
end
