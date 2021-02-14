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
          InitTracker::Models::ReactionCommand::EMOJIS.include?(event.emoji.to_s)
        end
    
        def display_error?
          control_emoji? ? true : false
        end      
    end
  end
end
