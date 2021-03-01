# frozen_string_literal: true

module InitTracker
  module CommandProcessors
    class HelpCommandProcessor < BaseCommandProcessor

      def child_process(result)
        InitTrackerLogger.log.debug {"building the help message"}
        if has_embed_permission?
          command.event.channel.send_embed do |embed|
            embed.title = "Initative Tracker Help"
            embed.colour = 3447003
            embed.description = "The overall process is simple:\n"
            embed.description += "1) Start inititive for the channel\n"
            embed.description += "2) Add characters (PC & NPC) to the initiative\n"
            embed.description += "3) Use the next command to advance initiative\n"
            embed.description += "4) When done, stop initiative\n\n"
            start_stop_commands = "> Start initiative in a channel\n"
            start_stop_commands += "> `!init start`\n"
            start_stop_commands += "> \n> Stop and remove initiative from a channel\n"
            start_stop_commands += "> `!init stop`"
            embed.add_field(name: "Start/Stop Initiative", value: start_stop_commands, inline: false)
            add_remove_commands = "> Add a character to initiative with a dice command\n"
            add_remove_commands += "> `!init add '[character name]' [dice]`\n"
            add_remove_commands += "> \n> Add a character to initaitive with a fixed number\n"
            add_remove_commands += "> `!init add '[character name]' [number]`\n"
            add_remove_commands += "> \n> Remove a character from initiative\n"
            add_remove_commands += "> `!init remove '[character name]'`\n"
            add_remove_commands += "> `!init remove [position number]`\n"
            embed.add_field(name: "Add/Remove Characters", value: add_remove_commands, inline: false)
            update_commands = "> `!init update '[character name]' [dice]`\n"
            update_commands += "> `!init update [position number] [dice]`\n"
            update_commands += "> `!init update '[character name]' [number]`\n"
            update_commands += "> `!init update [position number] [number]`\n"
            embed.add_field(name: "Update Characters Dice or Number", value: update_commands, inline: false)
            up_commands = "> Move to the next character in order\n"
            up_commands += "> `!init next`\n"
            up_commands += "> \n> Set the next character to be up\n"
            up_commands += "> `!init next '[character name]'`\n"
            up_commands += "> `!init next [position number]`"
            embed.add_field(name: "Who's Up?", value: up_commands, inline: false)
            display_commands = "> `!init display`"
            embed.add_field(name: "Display Initiative Order", value: display_commands, inline: false)
            reroll_commands = "> Re-rolls initiative for all characters\n"
            reroll_commands += "> `!init reroll`\n"
            reroll_commands += "> \n> Re-roll initiative for a specific character\n"
            reroll_commands += "> `!init reroll '[character name]'`\n"
            reroll_commands += "> `!init reroll [position number]`\n"
            embed.add_field(name: "Re-roll Initiative", value: reroll_commands, inline: false)
            tie_commands = "> Move a character to the top of their number\n"
            tie_commands += "> `!init move '[character name]' up`\n"
            tie_commands += "> `!init move [position number] up`\n"
            embed.add_field(name: "Break Ties", value: tie_commands, inline: false)
            reset_commands = "> Clears all done indicators\n"
            reset_commands += "> `!init reset`"
            embed.add_field(name: "Reset Initiative", value: reset_commands, inline: false)
            embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "Version: #{InitTracker::Version::VERSION}")
          end
        else
          event << "**Welcome to The Initiative Tracker**"
          event << " "
          event << "The overall process is simple:"
          event << "1) Start inititive for the channel"
          event << "2) Add characters (PC & NPC) to the initiative"
          event << "3) Use the next command to advance initiative"
          event << "4) When done, stop initiative"
          event << " "
          event << "For detailed instructions see: <https://github.com/curtp/initiative_tracker>"
          event << " "
          event << "**-- Start/Stop Initiative --**"
          event << "!init start - Starts initiative in the channel"
          event << "!init stop - Stops initiative for the channel"
          event << " "
          event << "**-- Add/Remove Characters --**"
          event << "!init add '[character name]' [dice] - Adds the character to initiative"
          event << "!init add '[character name]' [number] - Adds the character to initiative with a specific number"
          event << "!init remove '[character name]' - Removes the character from the position"
          event << " "
          event << "**-- Update Characters Dice or Number --**"
          event << "!init update '[character name]' [dice] - Updates the dice command for the named character"
          event << "!init update '[character name]' [number] - Updates the number for the named character"
          event << " "
          event << "**-- Who's Up? --**"
          event << "!init next - Moves to the next character in the list"
          event << "!init next '[character name]' - Set the next character to be up"
          event << " "
          event << "**-- Display Initiative --**"
          event << "!init display - Show the current initiative status"
          event << " "
          event << "**-- Re-roll Initiative --**"
          event << "!init reroll - Re-rolls initiative for the current characters"
          event << "!init reroll '[character name]' - Re-rolls initiative for the specific position"
          event << " "
          event << "**-- Break Ties --**"
          event << "!init move '[character name]' up - Moves the character at a specific position up"
          event << " "
          event << "**-- Reset Initiative --**"
          event << "!init reset - Clears the done indicators and sets the first character as up"
        end
      end

    end
  end
end
