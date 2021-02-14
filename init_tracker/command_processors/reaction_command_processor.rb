# frozen_string_literal: true
require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class ReactionCommandProcessor < BaseCommandProcessor

      def child_process
        result = build_success_result

        print_init = true
        case command.event.emoji.to_s
        when InitTracker::Models::ReactionCommand::NEXT_EMOJI
          init.next!
        when InitTracker::Models::ReactionCommand::REROLL_EMOJI
          init.reroll!
          init.reset!
        when InitTracker::Models::ReactionCommand::RESET_EMOJI
          init.reset!
        when InitTracker::Models::ReactionCommand::STOP_EMOJI
          init.destroy
          command.event.send_message(end_of_initiative_message)
          print_init = false
        end

        print_init(init) if print_init

        InitTrackerLogger.log.debug {"ReactionCommandProcessor.process: returning result: #{result}"}
        return result
      end
    end
  end
end
