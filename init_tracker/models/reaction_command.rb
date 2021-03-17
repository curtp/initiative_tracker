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
        # Only display if it is for a control emoji
        return false if !control_emoji?
        # Only for an embed
        return false if !event.message.embeds.first.present?
        # Only for an init tracker embed
        return false if !event.message.embeds.first.title.eql?(InitTracker::CommandProcessors::BaseCommandProcessor::INITIATIVE_DISPLAY_HEADER)
        # Everything aligns, so display an error
        return true
      end     
      
      def emoji
        event.try(:emoji).to_s
      end

      def display_init?
        return false if emoji.eql?(STOP_EMOJI)
        return true
      end
    end
  end
end
