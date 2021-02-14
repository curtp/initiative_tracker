require_relative "./base_command"
module InitTracker
  module Models
    class ReactionCommand < BaseCommand
        NEXT_EMOJI = '▶️'.to_s
        REROLL_EMOJI = '🔀'.to_s
        RESET_EMOJI = '🔁'.to_s
        EMOJIS = [NEXT_EMOJI, RESET_EMOJI, REROLL_EMOJI]
    end
  end
end
