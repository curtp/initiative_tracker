require_relative "./base_command_processor"

module InitTracker
  module CommandProcessors
    class HelpCommandProcessor < BaseCommandProcessor

      def process
        HelpCommandProcessor.build_help_message(command.event)
        result = {success: true, error_message: ""}
        return result
      end

      def self.build_help_message(event)
        event << "**Welcome to The Initiative Tracker**"
        event << " "
        event << "Track initiative by starting it, then adding characters, then progressing through the list until initiative is no longer needed. Initiative is run at the channel level, so it is possible to have multiple initatives active across multiple channels."
        event << " "
        event << "The overall process is simple:"
        event << "1) Start inititive for the channel"
        event << "2) Add characters (PC & NPC) to the initiative"
        event << "3) Use the next command to advance initiative"
        event << "4) When done, stop initiative"
        event << " "
        event << "**-- Start Initiative --**"
        event << "!init start - Starts initiative in the channel"
        event << " "
        event << "**-- Add Characters --**"
        event << "!init add '[character name]' - Adds the character to initiative: !init add 'By Tor'"
        event << " "
        event << "**-- Remove Characters --**"
        event << "!init remove [position] - Removes the character from the position: !init remove 2"
        event << " "
        event << "**-- Who's Up? --**"
        event << "!init next - Moves to the next character in the list"
        event << "!init next [position number] - Set the next character to be up: !init next 3"
        event << " "
        event << "**-- Stop Initative --**"
        event << "!init stop - Stops initiative for the channel"
        event << " "
        event << "**-- Display Initiative --**"
        event << "!init display - Show the current initiative status"
        event << " "
        event << "**-- Re-roll Initiative --**"
        event << "!init reroll - Re-rolls initiative for the current characters"
        event << " "
        event << "!init help - Display this help message <https://github.com/curtp/initiative_tracker>"
      end

    end
  end
end
