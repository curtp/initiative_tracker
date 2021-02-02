module InitTracker
  module Validators
    class CommandValidator

      def self.validate(command)
        InitTrackerLogger.log.debug {"CommandValidator: instruction size: #{command.instructions.size}"}
        if command.instructions.size < 1
          return {valid: false, error_message: "Unknown command"}
        end

        InitTrackerLogger.log.debug {"CommandValidator: creating validator for command: #{command.base_instruction.downcase.strip}"}
        case command.base_instruction.downcase.strip
        when "start".freeze
          validator = StartValidator.new(command)
        when "remove".freeze
          validator = RemoveValidator.new(command)
        when "stop".freeze
          validator = StopValidator.new(command)
        when "next".freeze
          validator = NextValidator.new(command)
        when "reroll".freeze
          validator = RerollValidator.new(command)
        when "reset".freeze
          validator = ResetValidator.new(command)
        when "add".freeze
          validator = AddValidator.new(command)
        when "display".freeze
          validator = DisplayValidator.new(command)
        else
          return {valid: false, error_message: "Unknown command"}
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
            error_message: "To remove a character from initative: remove 'character name'"}
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

        if command.instructions.size != 1
          return {valid: false, error_message: "To suffle initiative order: reroll"}
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

  end
end
