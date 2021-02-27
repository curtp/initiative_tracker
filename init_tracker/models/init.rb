# frozen_string_literal: true
require "securerandom"

module InitTracker
  module Models
    class Init < ActiveRecord::Base
      belongs_to :server

      ORDER_MULTIPLIER = 100

      serialize :characters, Array

      after_initialize :add_missing_attributes

      # Rerolls the dice for all characters
      def reroll!(position_number = nil)
        InitTrackerLogger.log.debug {"Rerolling position #{position_number}"}
        # Nothing to do if there are no characters
        return if !has_characters?

        # Get out if the position number isn't valid
        return if position_number.present? && !position_number_valid?(position_number)

        if position_number.present?
          InitTrackerLogger.log.debug {"Setting character order for a position"}
          set_character_init_number(characters[position_number - 1])
          set_character_init_order(characters[position_number - 1])
        else
          InitTrackerLogger.log.debug {"Setting character order for all characters"}
          characters.each do |char|
            set_character_init_number(char)
            set_character_init_order(char)
          end
        end
        sort_characters
        reset!
        save
      end

      # Resets the went and up status for all characters
      def reset!
        reset_went
        reset_up
        save
      end

      def move!(position_number, up)
        # Nothing to do if there are no characters
        return if !has_characters?

        # Ignore the position number if it is out of range
        return if position_number.present? && !position_number_valid?(position_number)

        position_number = position_number - 1
        InitTrackerLogger.log.debug {"Moving #{position_number} up: #{up}"}
        direction = up ? 1 : -1
        characters[position_number][:order] = characters[position_number][:order] + direction
        sort_characters
        save
      end

      def update!(position_number, dice, number)
        # Nothing to do if there are no characters
        return if !has_characters?

        # Ignore the position number if it is out of range
        return if position_number.present? && !position_number_valid?(position_number)

        position_number = position_number - 1

        InitTrackerLogger.log.debug("update: position: #{position_number}, #{dice}, #{number}")
				characters[position_number][:dice] = dice.present? ? dice : nil
				characters[position_number][:number] = number.present? ? number.to_i : 0
        InitTrackerLogger.log.debug("update: character: #{characters[position_number]}")

        if dice.present?
          reroll!(position_number + 1)
        else
          set_character_init_order(characters[position_number])
          sort_characters
          save
        end
      end

      def next!(position_number = nil)
        # Nothing to do if there are no characters
        return if !has_characters?

        # Ignore the position number if it is out of range
        return if position_number.present? && !position_number_valid?(position_number)

        # Find the current character who is up
        index_of_current_up_character = characters.find_index {|char| char[:up]}
        if index_of_current_up_character.present?
          characters[index_of_current_up_character][:up] = false
          characters[index_of_current_up_character][:went] = true
        else
          index_of_current_up_character = characters.size - 1
        end

        if all_went?
          reset_went
        end

        InitTrackerLogger.log.debug {"currently up: #{index_of_current_up_character}"}
        InitTrackerLogger.log.debug {"position_number: #{position_number}"}

        # If a valid position number was provided, use it
        if position_number.present?
          InitTrackerLogger.log.debug {"Position Number: character at position: #{position_number} is up"}
          characters[position_number - 1][:up] = true
        else
          # Move through the list of characters to the next character. Circle
          # back to the top of the list when the last character is currently up
          if index_of_current_up_character == characters.size - 1
            InitTrackerLogger.log.debug {"Starting At Top: character at position: 1 is up"}
            characters[0][:up] = true
          else
            InitTrackerLogger.log.debug {"Moving Forward: character at position: #{index_of_current_up_character + 1} is up"}
            characters[index_of_current_up_character + 1][:up] = true
          end
        end
        save
      end

      def add_character!(character_name, dice, number, added_by_user)
        InitTrackerLogger.log.debug {"chaacter_name: #{character_name}, dice: #{dice}, number: #{number}"}
        character = {}
        character[:name] = character_name
        character[:dice] = dice if dice.present?
        character[:added_by_user] = added_by_user.id
        character[:key] = SecureRandom.alphanumeric
        character[:up] = false
        character[:went] = false
        set_character_init_number(character) if number.blank?
        character[:number] = number.to_i if number.present?
        set_character_init_order(character)

        InitTrackerLogger.log.debug {"adding character: #{character.inspect}"}
        if characters.nil?
          self.characters = []
        end
        characters.push(character)
        sort_characters
        save
      end

      # Removes the character at the position provided
      def remove_character!(position_number)
        return if !has_characters?
        return if !position_number_valid?(position_number)
        if characters[position_number - 1][:up]
          next!
        end
        characters.delete_at(position_number - 1)
        save
      end

      # Locates the character by their name and returns them if found
      def find_character_by_name(name)
        InitTrackerLogger.log.debug {"Find by name: #{name}"}
        characters.select{|char| char[:name].strip.downcase.eql?(name.strip.downcase)}.first
      end

      # Returns the position number for the character passed in
      def postion_number_for_character(character)
        return if character.blank?
        characters.find_index {|char| char[:key].eql?(character[:key])} + 1
      end

      # When the channel is removed, it will wipe out any init associated to it
      def self.channel_removed(event)
        InitTrackerLogger.log.info {"Channel: channel removed: '#{event.server.name}' (ID: #{event.id})"}
        # Find any inits for this channel and blow them away.
        Init.where(server_id: event.server.id, channel_id: event.id).delete_all
      end

      private

      # Returns true if all characters have gone
      def all_went?
        yet_to_go = characters.detect {|character| character[:went] == false}
        return !yet_to_go.present?
      end

      # Resets the went status for all characters
      def reset_went
        characters.each do |character|
          character[:went] = false
        end
      end

      # Sets the order for all characters based on the number assigned to them
      def set_order
        characters.each do |character|
          character[:order] = character[:number] * ORDER_MULTIPLIER
        end
      end

      # Resets the up status for all characters
      def reset_up
        characters.each do |character|
          character[:up] = false
        end
      end

      # Sorts the characters
      def sort_characters
        characters.sort_by! {|character| character[:order]}.reverse!
      end

      def set_character_init_number(character)
        number = 0
        # Only roll dice for init if there is a dice command for the character. This
        # is to allow people to manually provide an init number if they like.
        if character[:dice].present?
          count = 0
          # Max number of times to try and find a unique number for the character
          max_tries = characters.size + 1
          loop do
            amount, sides, mod = character[:dice].tr("^0-9", " ").split
            number = roll(amount, sides) + mod.to_i
            char = characters.find {|character| character[:number] == number }
            # No character with the same number, use it
            break if char.blank?
            # If the max number of tries is met, get out and just use the last number tried
            break if count == max_tries
            # Increment the counter and try again
            count = count + 1
          end
        end
        character[:number] = number
      end

      # Sets the characters init order based on the dice. Re-rolls the dice and sets the order
      def set_character_init_order(character)
        character[:order] = character[:number] * ORDER_MULTIPLIER
      end

      # Rolls the dice
      def roll(amount = 0, sides = 0)
        amount.to_i.times.sum { |t| SecureRandom.random_number(1..sides.to_i) }
      end

      # Returns true if the position number is valid for the character list
      def position_number_valid?(position_number)
        return false if position_number < 1 || position_number > characters.size
        return true
      end

      # Returns true if there are characters
      def has_characters?
        characters.size > 0
      end

      # When the init loads, look for any missing character attributes and add them
      def add_missing_attributes
        return if characters.empty?
        return if characters.first.has_key?(:order)
        set_order
      end

    end
  end
end
