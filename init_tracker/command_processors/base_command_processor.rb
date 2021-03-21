module InitTracker
  module CommandProcessors
    class BaseCommandProcessor

      INITIATIVE_DISPLAY_HEADER = "Initiative Order"

      attr_accessor :command
      attr_accessor :init

      def initialize(command)
        self.command = command
      end

      def process
        result = build_success_result

        if permissions_valid?

          # Make sure the command is valid before continuing
          validation_result = validate_command
          if !validation_result[:valid]
            result[:success] = false
            result[:error_message] = validation_result[:error_message]
            InitTrackerLogger.log.debug {"BaseCommandProcessor.process: validation failed returning result: #{result}"}
            return result
          end

          # If the command requires the init object, then look for it
          if command.init_required?
            # Retrieve the init. If the command allows providing an initiative number, look for a
            # specific number to retrieve.
            self.init = find_init
            if !init.present?
              result[:success] = false
              result[:error_message] = initiative_not_started_message
              InitTrackerLogger.log.debug {"BaseCommandProcessor.process: init not started returning result: #{result}"}
              return result
            end
          end

          # Execute the command specific logic in the child class
          child_process(result)

          # If everything worked and the command should display initiative, display it
          if result[:success] && init.present?
            edit_or_display_init(init)
          end
        else
          # When there are permission issues, do not display an error since the response will
          # inform the user or server owner about the issue
        end
        return result
      end

      protected

      # This will be implemented by all the commands which inherit from this one. This is where
      # the command specific logic will be executed
      def child_process(result)
      end

      # Simple method for building the success result returned from the command objects
      def build_success_result
        result = {success: true, error_message: ""}
      end

      # Returns true if initiative has been started for the channel
      def initiative_started?
        find_init.present?
      end

      # Message displayed when the initiative has not been started
      def initiative_not_started_message
        "Initiative not started. To start tracking initiative, run the start command.".freeze
      end

      # Message displayed when initiative has ended
      def end_of_initiative_message
        "End of initiative.".freeze
      end

      # Validates the command 
      def validate_command
        InitTracker::Validators::CommandValidator.validate(command)
      end

      # Locates the initiative model object for the server/channel combination and returns it if
      # it exists.
      def find_init(id = nil)
        return InitTracker::Models::Init.where(server_id: command.event.server.id, channel_id: command.event.channel.id).first
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

      def has_add_reactions_permission?
        return get_bot_profile.permission?(:add_reactions, command.event.channel)
      end

      def has_send_messages_permission?
        return get_bot_profile.permission?(:send_messages, command.event.channel)
      end

      # Returns the position number for the named character. Returns nil if the character doesn't exist
      def position_number_for_character(character_name)
        char = init.find_character_by_name(command.character_name)
        return nil if char.blank?
        return init.postion_number_for_character(char)
      end

      private

      # Returns the bot profile
      def get_bot_profile
        bot_profile = command.event.bot.profile.on(command.event.server)
      end

      def edit_or_display_init(init)
        if command.display_init?
          if init.message_id.present?
            message = command.event.channel.load_message(init.message_id)
            if message.present?
              InitTrackerLogger.log.debug {"Calling edit embed"}
              edit_embed_init(init, message)
            else
              print_init(init)
            end
          else
            InitTrackerLogger.log.debug {"Printing init"}
            print_init(init)
          end
        end
      end

      # Prints the intiative order as an embed
      def print_init(init)
        InitTrackerLogger.log.debug("embed init")
        new_embed = build_embed
        message = command.event.channel.send_embed do |embed|
          embed.title = new_embed[:title]
          embed.colour = new_embed[:color]
          embed.description = new_embed[:description]
        end

        # Add the reaction emojis
        InitTracker::Models::ReactionCommand::EMOJIS.each do |emoji|
          message.create_reaction(emoji)
        end

        # Stamp the message id on the init so it can be referenced later
        init.update_attribute(:message_id, message.id)
      end

      def edit_embed_init(init, message)
        InitTrackerLogger.log.debug("embed init")
        embed = build_embed
        message.edit(nil, embed)
        if command.reaction_command?
          # Remove the reaction which caused this to happen
          message.delete_reaction(command.event.user, command.emoji)
        end
      end

      def build_embed
        embed = {}
        embed[:title] = "#{INITIATIVE_DISPLAY_HEADER} - Round: #{init.round}"
        embed[:color] = 3447003
        msg = ""
        init.characters.each_with_index do |character, ndx|
          bold_char = character[:up] ? "**" : nil
          box = ":green_square:".freeze
          if character[:up]
            box = ":eight_spoked_asterisk:".freeze
          elsif character[:went]
            box = ":white_check_mark:"
          end

          msg = msg << "#{box}︲#{bold_char}#{ndx+1} - #{character[:name]} (#{character[:dice].present? ? character[:dice] : ' - '} : #{character[:number]})#{bold_char}\n"
        end
        embed[:description] = msg

        return embed
      end

      def permissions_valid?
        valid = true
        message = "Please assign the following permissions to the Initiative Tracker bot for it to work properly:\n"
        if !has_manage_messages_permission?
          message << "\n * Manage Messages"
          valid = false
        end

        if !has_embed_permission?
          message << "\n * Embed Links"
          valid = false
        end

        if !has_add_reactions_permission?
          message << "\n * Add Reactions"
          valid = false
        end

        if !has_send_messages_permission?
          message << "\n * Send Messages"
          valid = false
        end

        InitTrackerLogger.log.debug("valid: #{valid}")
        if !valid
          if has_send_messages_permission?
            command.event.send_message(message)
          else
            command.event.server.owner.pm(message)
          end
        end

        return valid
      end

    end
  end
end
