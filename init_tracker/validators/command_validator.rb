# frozen_string_literal: true

module InitTracker
  module Validators
    class CommandValidator

      def self.validate(command)

        if command.is_a?(InitTracker::Models::ReactionCommand)
          InitTrackerLogger.log.debug {"CommandValidator: creating reaction validator for command"}
          validator = ReactionValidator.new(command)
        elsif command.help_command?
          return {valid: true, error_message: nil}
        else
          InitTrackerLogger.log.debug {"CommandValidator: instruction size: #{command.instructions.size}"}
          if command.instructions.size < 1
            return {valid: false, error_message: "Unknown command"}
          end

          InitTrackerLogger.log.debug {"CommandValidator: creating validator for command: #{command.base_instruction.downcase.strip}"}
          case command.base_instruction.downcase.strip
          when "start"
            validator = StartValidator.new(command)
          when "remove"
            validator = RemoveValidator.new(command)
          when "stop"
            validator = StopValidator.new(command)
          when "next"
            validator = NextValidator.new(command)
          when "reroll"
            validator = RerollValidator.new(command)
          when "reset"
            validator = ResetValidator.new(command)
          when "add"
            validator = AddValidator.new(command)
          when "display"
            validator = DisplayValidator.new(command)
          when "stats"
            validator = StatsValidator.new(command)
          when "move"
            validator = MoveValidator.new(command)
          when "update"
            validator = UpdateValidator.new(command)
          else
            return {valid: false, error_message: "Unknown command"}
          end
        end

        return validator.validate
      end

    end

    private

    class BaseValidator

      attr_accessor :command

      def initialize(command)
        self.command = command
      end

      def validate
        return {valid: true, error_message: ""}
      end

    end

    class AddValidator < BaseValidator

      def validate

        if command.instructions.size != 3
          return {valid: false, error_message: "To add a character to initiative: add 'character name' 2d6"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class RemoveValidator < BaseValidator

      def validate

        if command.instructions.size != 2
          return {valid: false,
            error_message: "To remove a character from initative: remove # or remove 'character name'"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class StopValidator < BaseValidator

      def validate
        if command.instructions.size != 1
          return {valid: false,
            error_message: "To stop initative: stop"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class StartValidator < BaseValidator

      def validate
        InitTrackerLogger.log.debug("instructions.size: #{command.instructions.size}")
        if command.instructions.size != 1
          return {valid: false,
            error_message: "To start initative: start"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class StatsValidator < BaseValidator

      def validate
        InitTrackerLogger.log.debug("instructions.size: #{command.instructions.size}")

        if !command.bot_owner?
          return {valid: false, error_message: "Command not available"}
        end
        return {valid: true, error_message: ""}
      end
    end

    class NextValidator < BaseValidator

      def validate

        if command.instructions.size < 1 || command.instructions.size > 2
          return {valid: false, error_message: "To move to the next character in order: next or next [position number]"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class RerollValidator < BaseValidator

      def validate

        if command.instructions.size < 1 || command.instructions.size > 2
          return {valid: false, error_message: "To suffle initiative order: reroll or reroll [position number] or reroll '[character name]'"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class DisplayValidator < BaseValidator

      def validate

        if command.instructions.size != 1
          return {valid: false, error_message: "To display initiative: display"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class ResetValidator < BaseValidator

      def validate

        if command.instructions.size != 1
          return {valid: false, error_message: "To reset initiative: reset"}
        end

        return {valid: true, error_message: ""}
      end
    end

    class ReactionValidator < BaseValidator

      def validate

        # Make sure it is for an embeds
        return {valid: false, error_message: "not for an embeds"} if command.event.message.embeds.empty?

        # Make sure it is for an inittracker embed
        return {valid: false, error_message: "not an initative tracker embed"} if !command.event.message.embeds.first.title.eql?(InitTracker::CommandProcessors::BaseCommandProcessor::INITIATIVE_DISPLAY_HEADER)

        # Make sure it is for one of the used emojis
        return {valid: false, error_message: "not one of the initiatve tracker emojis"} if !command.control_emoji?

        # All good, return valid
        return {valid: true, error_message: ""}
      end

    end

    class MoveValidator < BaseValidator
      def validate
        if command.instructions.size != 3
          return {valid: false,
            error_message: "To move a character up or down: move 'character name' up or move "}
        end
        if !command.down? && !command.up?
          return {valid: false,
            error_message: "Direction must be either 'up' or 'down'."}
        end

        return {valid: true, error_message: ""}
      end

    end

    class UpdateValidator < BaseValidator
      def validate
        if command.instructions.size != 3
          return {valid: false, error_message: "To update a character: update 'character name' 2d6"}
        end

        return {valid: true, error_message: ""}
      end
    end

  end
end
