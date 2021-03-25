# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class ReactionCommandProcessor < BaseCommandProcessor

      def child_process(result)

        # If the init has a pointer to the message for initiative, then make sure the event is for
        # the same initiative message
        if init.message_id.present? && !command.event.message.id.to_s.eql?(init.message_id)
          result[:success] = false
          result[:error_message] = "reaction on something other than the init embed."
          return result
        end

        case command.emoji
        when InitTracker::Models::ReactionCommand::NEXT_EMOJI
          init.next!
        when InitTracker::Models::ReactionCommand::REROLL_EMOJI
          init.reroll!
        when InitTracker::Models::ReactionCommand::RESET_EMOJI
          init.reset!
        when InitTracker::Models::ReactionCommand::STOP_EMOJI
          init.destroy
          command.event.send_message(end_of_initiative_message)
        end

        InitTrackerLogger.log.debug {"ReactionCommandProcessor.process: result: #{result}"}
      end
    end
  end
end
