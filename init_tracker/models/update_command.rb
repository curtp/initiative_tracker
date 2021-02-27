module InitTracker
	module Models
		class UpdateCommand < BaseCommand
			include InitTracker::Models::Concerns::CharacterConcern
			include InitTracker::Models::Concerns::DiceConcern
		end
	end
end
  