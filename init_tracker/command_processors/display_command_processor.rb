require_relative "./base_command_processor"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class DisplayCommandProcessor < BaseCommandProcessor

      def process
        result = {success: true, error_message: ""}
        validation_result = validate_command
        InitTrackerLogger.log.debug {"DisplayCommandProcessor.process: validation result: #{validation_result}"}
        if validation_result[:valid]
          init = find_init
          if init.present?
            print_init(init)
          else
            result[:success] = false
            result[:error_message] = initiative_not_started_message
          end
        else
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
        end
        InitTrackerLogger.log.debug {"DisplayCommandProcessor.process: returning result: #{result}"}
        return result
      end

      private

      def remove_question
        return if !has_manage_messages_permission?
        command.event.message.delete
      end

      def has_manage_messages_permission?
        return get_bot_profile.permission?(:manage_messages, command.event.channel)
      end

      def get_bot_profile
        bot_profile = command.event.bot.profile.on(command.event.server)
      end
    end
  end
end
