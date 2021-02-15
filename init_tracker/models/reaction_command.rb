require_relative "./base_command"
module InitTracker
  module Models
    class ReactionCommand < BaseCommand
      NEXT_EMOJI = '▶️'.to_s
      REROLL_EMOJI = '🔀'.to_s
      RESET_EMOJI = '🔁'.to_s
      STOP_EMOJI = '⏹'.to_s
      EMOJIS = [NEXT_EMOJI, RESET_EMOJI, REROLL_EMOJI, STOP_EMOJI]

      def control_emoji?
        InitTracker::Models::ReactionCommand::EMOJIS.include?(emoji)
      end
  
      def display_error?
        control_emoji? ? true : false
      end     
      
      def emoji
        event.emoji.to_s
      end

      def display_init?
        return false if emoji.eql?(STOP_EMOJI)
        return true
      end
    end
  end
end
