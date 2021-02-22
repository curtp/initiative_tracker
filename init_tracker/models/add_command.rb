require_relative "./base_command"
module InitTracker
  module Models
    class AddCommand < BaseCommand
      # The name of the character to add to initiative
      def character_name
        instructions[instructions.size - 2]
      end

      # Returs true if a dice command was provided when adding the character
      def dice_provided?
        return dice_formatted_properly?
      end

      # Returns true if a number was provided instead of dice when adding a character
      def number_provided?
        return !dice_formatted_properly?
      end

      # Returns the dice command if it was provided
      def dice
        return nil if !dice_provided?
        instructions.last
      end

      # Returns the number if it was provided
      def number
        return nil if !number_provided?
        instructions.last
      end

      # Returns true if the dice command was formatted properly, if it was provided
      def dice_formatted_properly?
        instructions.last.match?(/(\d*)(D\d*)((?:[+*-](?:\d+|\([A-Z]*\)))*)/i)
      end

    end
  end
end
