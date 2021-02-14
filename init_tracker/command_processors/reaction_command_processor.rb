require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class ReactionCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command

        if !validation_result[:valid]
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
          InitTrackerLogger.log.debug {"ReactionCommandProcessor.process: returning result: #{result}"}
          return result
        end

        init = find_init
        if !init.present?
          result[:success] = false
          result[:error_message] = initiative_not_started_message
          InitTrackerLogger.log.debug {"ReactionCommandProcessor.process: returning result: #{result}"}
          return result
        end
        
        case command.event.emoji.to_s
        when InitTracker::Models::ReactionCommand::NEXT_EMOJI
          init.next!
        when InitTracker::Models::ReactionCommand::REROLL_EMOJI
          init.reroll!
          init.reset!
        when InitTracker::Models::ReactionCommand::RESET_EMOJI
          init.reset!
        end

        remove_command
        
        print_init(init)

        InitTrackerLogger.log.debug {"ReactionCommandProcessor.process: returning result: #{result}"}
        return result
      end
    end
  end
end
