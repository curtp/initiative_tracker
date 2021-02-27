# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class HelpCommandProcessor < BaseCommandProcessor

      def child_process(result)
        InitTrackerLogger.log.debug {"building the help message"}
        HelpCommandProcessor.build_help_message(command.event)
      end

      def self.build_help_message(event)
        event << "**Welcome to The Initiative Tracker**"
        event << " "
        event << "The overall process is simple:"
        event << "1) Start inititive for the channel"
        event << "2) Add characters (PC & NPC) to the initiative"
        event << "3) Use the next command to advance initiative"
        event << "4) When done, stop initiative"
        event << " "
        event << "For detailed instructions see: <https://github.com/curtp/initiative_tracker>"
        event << " "
        event << "**-- Start/Stop Initiative --**"
        event << "!init start - Starts initiative in the channel"
        event << "!init stop - Stops initiative for the channel"
        event << " "
        event << "**-- Add/Remove Characters --**"
        event << "!init add '[character name]' [dice] - Adds the character to initiative"
        event << "!init add '[character name]' [number] - Adds the character to initiative with a specific number"
        event << "!init remove '[character name]' - Removes the character from the position"
        event << " "
        event << "**-- Update Characters Dice or Number --**"
        event << "!init update '[character name]' [dice] - Updates the dice command for the named character"
        event << "!init update '[character name]' [number] - Updates the number for the named character"
        event << " "
        event << "**-- Who's Up? --**"
        event << "!init next - Moves to the next character in the list"
        event << "!init next '[character name]' - Set the next character to be up"
        event << " "
        event << "**-- Display Initiative --**"
        event << "!init display - Show the current initiative status"
        event << " "
        event << "**-- Re-roll Initiative --**"
        event << "!init reroll - Re-rolls initiative for the current characters"
        event << "!init reroll '[character name]' - Re-rolls initiative for the specific position"
        event << " "
        event << "**-- Break Ties --**"
        event << "!init move '[character name]' up - Moves the character at a specific position up"
        event << " "
        event << "**-- Reset Initiative --**"
        event << "!init reset - Clears the done indicators and sets the first character as up"
      end

    end
  end
end
