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
          self.init = find_init(command.try(:init_number))
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
        if result[:success] && command.display_init?
          print_init(init)
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

      # Prints the init based on what permissions the bot has
      def print_init(init)
        has_embed_permission? ? print_embed_init(init) : print_code_init(init)
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
      # it exists. Pass in the ID of a specific init. This only works for the bot owner. This was
      # added for debugging purposes only.
      def find_init(id = nil)
#        if id.present? && command.bot_owner?
 #         return InitTracker::Models::Init.where(id: id).first
 #       else
          return InitTracker::Models::Init.where(server_id: command.event.server.id, channel_id: command.event.channel.id).first
 #       end
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

      # Prints the intiative order as an embed
      def print_embed_init(init)
        InitTrackerLogger.log.debug("embed init")
        message = command.event.channel.send_embed do |embed|
          embed.title = INITIATIVE_DISPLAY_HEADER
          embed.colour = 3447003  # Green = 513848
          msg = ""
          init.characters.each_with_index do |character, ndx|
            bold_char = character[:up] ? "**" : nil
            box = ":green_square:".freeze
            if character[:up]
              box = ":eight_spoked_asterisk:".freeze
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

      # Prints the intiative order as a code block
      def print_code_init(init)
        header = INITIATIVE_DISPLAY_HEADER
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
