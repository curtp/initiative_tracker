module InitTracker
  module Models
    class RemoveCommand < BaseCommand
      # The name of the character to remove from initiative
      def character_name
        # If the character name is actually a name, return it. If it is a number, return nil
        num = number_or_nil(instructions.last)
        num.present? ? nil : instructions.last
      end

      # Returns the postion number for the command if the number was provided,
      # otherwise returns nil
      def position_number
        num = number_or_nil(instructions.last)
        num.present? ? instructions.last.to_i : nil
      end

      def num_provided?
        position_number.present?
      end

    end
  end
end
