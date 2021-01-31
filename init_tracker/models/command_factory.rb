require_relative "./add_command"
require_relative "./remove_command"
require_relative "./start_command"
require_relative "./stop_command"
require_relative "./next_command"
require_relative "./help_command"
require_relative "./reroll_command"
require_relative "./display_command"

module InitTracker
  module Models
    class CommandFactory

      def self.create_command_for_event(event)

        InitTrackerLogger.log.debug {"CommandFactory: Creating command object for command: #{event.message.content.downcase.strip.split(" ")[1]}"}
        case event.message.content.downcase.strip.split(" ")[1]
        when "add".freeze
          return AddCommand.new(event)
        when "remove".freeze
          return RemoveCommand.new(event)
        when "next".freeze, "list".freeze
          return NextCommand.new(event)
        when "start".freeze
          return StartCommand.new(event)
        when "stop".freeze
          return StopCommand.new(event)
        when "reroll".freeze
          return ReorderCommand.new(event)
        when "display".freeze
          return DisplayCommand.new(event)
        else
          return HelpCommand.new(event)
        end
      end

    end
  end
end
