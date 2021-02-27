module InitTracker
  module Models
    class ReorderCommand < BaseCommand
      include InitTracker::Models::Concerns::CharacterConcern
    end
  end
end
