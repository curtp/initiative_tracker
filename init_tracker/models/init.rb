require_relative "./base_model"
require "securerandom"

module InitTracker
  module Models
    class Init < ActiveRecord::Base
      belongs_to :server

      serialize :characters, Array

      def reroll!
        characters.each do |char|
          set_character_init_order(char)
        end
        sort_characters
        next!(1)
        save
      end

      def next!(position_number = nil)
        # Nothing to do if there are no characters
        return if characters.size == 0
        # Ignore the position number if it is out of range
        if position_number.present? && (position_number < 1 || position_number > characters.size)
          position_number = nil
        end

        # Find the current character who is up
        index_of_current_up_character = characters.find_index {|char| char[:up]}
        if index_of_current_up_character.present?
          characters[index_of_current_up_character][:up] = false
        else
          index_of_current_up_character = characters.size - 1
        end

        InitTrackerLogger.log.debug("currently up: #{index_of_current_up_character}")
        InitTrackerLogger.log.debug("position_number: #{position_number}")

        # If a valid position number was provided, use it
        if position_number.present?
          InitTrackerLogger.log.debug("Position Number: character at position: #{position_number} is up")
          characters[position_number - 1][:up] = true
        else
          # Move through the list of characters to the next character. Circle
          # back to the top of the list when the last character is currently up
          if index_of_current_up_character == characters.size - 1
            InitTrackerLogger.log.debug("Starting At Top: character at position: 1 is up")
            characters[0][:up] = true
          else
            InitTrackerLogger.log.debug("Moving Forward: character at position: #{index_of_current_up_character + 1} is up")
            characters[index_of_current_up_character + 1][:up] = true
          end
        end
        save
      end

      def add_character!(character_name, dice, added_by_user)
        InitTrackerLogger.log.debug("chaacter_name: #{character_name}, dice: #{dice}")
        character = {}
        character[:name] = character_name
        character[:dice] = dice
        character[:added_by_user] = added_by_user.id
        character[:key] = SecureRandom.alphanumeric
        character[:up] = false
        set_character_init_order(character)

        InitTrackerLogger.log.debug("adding character: #{character.inspect}")
        if characters.nil?
          self.characters = []
        end
        characters.push(character)
        sort_characters
        save
      end

      def remove_character!(position_number)
        return if position_number < 1 || position_number > characters.size
        if characters[position_number - 1][:up]
          next!
        end
        characters.delete_at(position_number - 1)
        save
      end

      private

      def sort_characters
        characters.sort_by! {|character| character[:number]}.reverse!
      end

      def set_character_init_order(character)
        number = nil
        loop do
          amount, sides, mod = character[:dice].tr("^0-9", " ").split
          number = roll(amount, sides) + mod.to_i
          char = characters.find {|character| character[:number] == number }
          break if char.blank?
        end
        character[:number] = number
      end

      def roll(amount = 0, sides = 0)
        amount.to_i.times.sum { |t| SecureRandom.random_number(1..sides.to_i) }
      end

    end
  end
end