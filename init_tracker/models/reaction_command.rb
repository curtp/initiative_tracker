module InitTracker
  module Models
    class ReactionCommand < BaseCommand
      NEXT_EMOJI = '▶️'.to_s
      REROLL_EMOJI = '🔀'.to_s
      RESET_EMOJI = '🔁'.to_s
      STOP_EMOJI = '🗑'.to_s
      EMOJIS = [NEXT_EMOJI, RESET_EMOJI, REROLL_EMOJI, STOP_EMOJI]

      def control_emoji?
        InitTracker::Models::ReactionCommand::EMOJIS.include?(emoji)
      end
  
      def display_error?
        InitTrackerLogger.log.debug {"checking control emoji"}
        # Only display if it is for a control emoji
        return false if !control_emoji?
        # Only for an embed
        InitTrackerLogger.log.debug {"checking for embed"}
        return false if !event.message.embeds.first.present?
        # Only for an init tracker embed
        InitTrackerLogger.log.debug {"checking to see if it is an init embed"}
        return false if !event.message.embeds.first.title.start_with?(InitTracker::CommandProcessors::BaseCommandProcessor::INITIATIVE_DISPLAY_HEADER)
        # Everything aligns, so display an error
        InitTrackerLogger.log.debug {"returning true"}
        return true
      end     
      
      def emoji
        event.try(:emoji).to_s
      end

#      def edit_init?
#        return false if emoji.eql?(STOP_EMOJI)
#        return true
#      end

      def display_init?
        return false if emoji.eql?(STOP_EMOJI)
        return false if edit_init?
        return true
      end
    end
  end
end
