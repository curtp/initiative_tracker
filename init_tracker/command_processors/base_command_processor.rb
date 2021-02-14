require_relative "../validators/command_validator"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class BaseCommandProcessor

      attr_accessor :command
      attr_accessor :init

      def initialize(command)
        self.command = command
      end

      def process
        result = build_success_result
        validation_result = validate_command

        if !validation_result[:valid]
          result[:success] = false
          result[:error_message] = validation_result[:error_message]
          InitTrackerLogger.log.debug {"BaseCommandProcessor.process: validation failed returning result: #{result}"}
          return result
        end

        if command.init_required?
          self.init = find_init
          if !init.present?
            result[:success] = false
            result[:error_message] = initiative_not_started_message
            InitTrackerLogger.log.debug {"BaseCommandProcessor.process: init not started returning result: #{result}"}
            return result
          end
        end

        # Execute the command specific logic in the child class
        child_process
      end

      protected

      def child_process
      end

      def build_success_result
        result = {success: true, error_message: ""}
      end

      def print_init(init)
        has_embed_permission? ? print_embed_init(init) : print_code_init(init)
      end

      def initiative_started?
        find_init.present?
      end

      def validate_init_started
        if !initiatve_started
          command.event << initiative_not_started_message
          return false
        end
        return true
      end

      def initiative_not_started_message
        "Initiative not started. To start tracking initiative, run the start command.".freeze
      end

      def end_of_initiative_message
        "End of initiative.".freeze
      end

      def validate_command
        InitTracker::Validators::CommandValidator.validate(command)
      end

      def find_init
        InitTracker::Models::Init.where(server_id: command.event.server.id, channel_id: command.event.channel.id).first
      end

      # Removes the command issued to the bot
      def remove_command
        return if !has_manage_messages_permission?
        command.event.message.delete
      end

      # Returns true if the bot has permission to manage messages
      def has_manage_messages_permission?
        return get_bot_profile.permission?(:manage_messages, command.event.channel)
      end

      # Returns true if the bot has permission to send an embed
      def has_embed_permission?
        return get_bot_profile.permission?(:embed_links, command.event.channel)
      end

      private

      # Returns the bot profile
      def get_bot_profile
        bot_profile = command.event.bot.profile.on(command.event.server)
      end

      def print_embed_init(init)
        InitTrackerLogger.log.debug("embed init")
        message = command.event.channel.send_embed do |embed|
          embed.title = "Initiative Order"
          embed.colour = 3447003  # Green = 513848
          msg = ""
          init.characters.each_with_index do |character, ndx|
            bold_char = character[:up] ? "**" : nil
            box = ":green_square:"
            if character[:up]
              box = ":eight_spoked_asterisk:"
            elsif character[:went]
              box = ":white_check_mark:"
            end
            msg = msg << "#{box}︲#{bold_char}#{ndx+1} - #{character[:name]} (#{character[:dice]} : #{character[:number]})#{bold_char}\n"
          end
          embed.description = msg
        end

        # Add the reaction emojis
        InitTracker::Models::ReactionCommand::EMOJIS.each do |emoji|
          message.create_reaction(emoji)
        end
      end

      def print_code_init(init)
        header = "Initiative Order"
        length = header.size
        command.event << "```"
        command.event << header
        command.event << "=" * length
        init.characters.each_with_index do |character, ndx|
          msg = "#{ndx+1} - #{character[:name]} (#{character[:dice]} : #{character[:number]})"
          if character[:went]
            msg = msg << " (done)"
          end
          if character[:up]
            msg = msg << " <= You're Up!"
          end
          command.event << msg
        end
        command.event << "```"
      end
    end
  end
end
