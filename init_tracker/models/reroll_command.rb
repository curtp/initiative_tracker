module InitTracker
  module Models
    class ReorderCommand < BaseCommand
      # Position to reroll (optional)
      def position_number
        return nil if instructions.size == 1
        # If the last instruction is a number, then return it
        num = number_or_nil(instructions.last)
        num.present? ? instructions.last.to_i : nil
      end

      def character_name
        InitTrackerLogger.log.debug {"instructions: #{instructions}"}
        return nil if instructions.size == 1
        return nil if num_provided?
        return instructions.last
      end

      def num_provided?
        position_number.present?
      end

    end
  end
end
