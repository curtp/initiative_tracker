require_relative "../validators/command_validator"
require_relative "../models/init"

module InitTracker
  module CommandProcessors
    class BaseCommandProcessor

      attr_accessor :command

      def initialize(command)
        self.command = command
      end

      protected

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

      # TODO: DRY up these print methods. Should be a way to share the loop and the 
      # general format
      def print_embed_init(init)
        InitTrackerLogger.log.debug("embed init")
        command.event.channel.send_embed do |embed|
          embed.title = "Initiative Order"
          embed.colour = 513848
          msg = ""
          init.characters.each_with_index do |character, ndx|
            msg = msg << "#{ndx+1} - #{character[:name]} (#{character[:dice]} : #{character[:number]})"
            if character[:went]
              msg = msg << " (done)"
            end
            if character[:up]
              msg = msg << " **<= You're Up!**"
            end
            msg = msg << "\n"
          end
          embed.description = msg
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
