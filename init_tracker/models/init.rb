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
      def reroll!
        characters.each do |char|
          set_character_init_order(char)
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
          characters[index_of_current_up_character][:went] = true
        else
          index_of_current_up_character = characters.size - 1
        end

        if all_went?
          InitTrackerLogger.log.debug {"all_went: resetting - #{characters}"}
          reset_went
          InitTrackerLogger.log.debug {"after reset: - #{characters}"}
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

      def add_character!(character_name, dice, added_by_user)
        InitTrackerLogger.log.debug {"chaacter_name: #{character_name}, dice: #{dice}"}
        character = {}
        character[:name] = character_name
        character[:dice] = dice
        character[:added_by_user] = added_by_user.id
        character[:key] = SecureRandom.alphanumeric
        character[:up] = false
        character[:went] = false
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
        return if position_number < 1 || position_number > characters.size
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

      # Returns the index for the character passed in
      def postion_number_for_character(character)
        characters.find_index {|char| char[:key].eql?(character[:key])}
      end

      # When the channel is removed, it will wipe out any init associated to it
      def self.channel_removed(event)
        InitTrackerLogger.log.debug {"Channel: channel removed: '#{event.server.name}' (ID: #{event.id})"}
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

      # Sets the characters init order based on the dice. Re-rolls the dice and sets the order
      def set_character_init_order(character)
        number = nil
        count = 1
        loop do
          amount, sides, mod = character[:dice].tr("^0-9", " ").split
          number = roll(amount, sides) + mod.to_i
          char = characters.find {|character| character[:number] == number }
          break if char.blank?
          break if characters.size == count
          count = count + 1
        end
        character[:number] = number
        character[:order] = number * ORDER_MULTIPLIER
      end

      # Rolls the dice
      def roll(amount = 0, sides = 0)
        amount.to_i.times.sum { |t| SecureRandom.random_number(1..sides.to_i) }
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
