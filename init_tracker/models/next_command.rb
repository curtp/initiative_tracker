module InitTracker
  module Models
    class NextCommand < BaseCommand
      include InitTracker::Models::Concerns::CharacterConcern
    end
  end
end
