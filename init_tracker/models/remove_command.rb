module InitTracker
  module Models
    class RemoveCommand < BaseCommand
      include InitTracker::Models::Concerns::CharacterConcern
    end
  end
end
