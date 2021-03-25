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
        InitTrackerLogger.log.debug {"command.display_error? - checking control emoji"}
        # Only display if it is for a control emoji
        return false if !control_emoji?
        # Only for an init tracker embed
        InitTrackerLogger.log.debug {"command.display_error? - checking to see if it is an init embed"}
        return false if !for_initiative_embed?
        # Everything aligns, so display an error
        InitTrackerLogger.log.debug {"command.display_error? - returning true to display error"}
        return true
      end     
      
      def emoji
        event.try(:emoji).to_s
      end

      def for_embed?
        begin
          return !event.message.embeds.empty?
        rescue Exception => e
          InitTrackerLogger.log.debug("Error checking to see if embeds are empty: #{e}")
          return false
        end
      end

      def for_initiative_embed?
        @_for_initiative_embed ||= is_reaction_for_initiative_embed?
      end

      def reaction_command?
        return true
      end

      def display_init?
        return false if emoji.eql?(STOP_EMOJI)
        return true
      end

      private

      def is_reaction_for_initiative_embed?
        begin
          return false if !for_embed?
          # Look for an init record. If found, then the reaction is for an embed
          return true if InitTracker::Models::Init.where(message_id: event.message.id).exists?
          # No message found, so have to look at the message title
          return event.message.embeds.first.title.start_with?(InitTracker::CommandProcessors::BaseCommandProcessor::INITIATIVE_DISPLAY_HEADER)
        rescue Exception => e
          return false
        end
      end
    end
  end
end
