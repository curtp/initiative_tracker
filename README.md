# Initiative Tracker
Discord bot for tracking initiative for RPG games

This is a work in progress however, it is ready for general use. [Invite Link](https://discord.com/api/oauth2/authorize?client_id=805509626107396166&permissions=26688&scope=bot)

<img src="https://github.com/curtp/initiative_tracker/blob/main/docs/init_tracker_screenshot.png?raw=true" width='50%'>
The reactions under the display act as shortcuts for simple interaction. See descriptions of actions below. In the screenshot above, Frodo is finished, Gandalf is up, and Samwise hasn't gone yet.

### Required Permissions
**Send Messages** - Allows the bot to send messages to the channel.  
**Embed Links** - Allows the bot to display initiative in the channel.  
**Manage Messages** - Allows the bot to edit the displayed init.  
**Add Reactions** - Allows using reactions to interact with the init.  

## How It Works
Track initiative by starting it, then adding characters, then progressing through the list until initiative is no longer needed. Initiative is run at the channel level, so it is possible to have multiple initatives active across multiple channels.

The overall process is simple:
1) Start inititive for the channel
2) Add characters (PC & NPC) to the initiative
3) Use the next command to advance initiative
4) When done, stop initiative

**Start Initiative**
```
!init start - Starts initiative in the channel
```

**Add Characters**
```
!init add '[character name]' [dice] - Adds the character to initiative"
!init add '[character name]' [number] - Adds the character to initiative with a specific number
```

**Remove Characters**
```
!init remove [position number] - Removes the character from the position
!init remove '[character name]' - Removes the character by their name
```

**Update Characters Dice or Number**
```
!init update '[character name]' [dice] - Updates the dice command for the named character
!init update '[character name]' [number] - Updates the number for the named character
!init update [position number] [dice] - Updates the dice command for the character at the position
!init update [position number] [number] - Updates the number for the character at the position
```

**Who's Up?**
```
!init next - Moves to the next character in the list
!init next [position number] - Set the next character to be up
!init next '[character name]' - Set the next character to be up
```

You can also click the right arrow (far left) under the display to move to the next character (see screenshot above)

**Stop Initative**
```
!init stop - Stops initiative for the channel
```
You can also click the trash can (far right) under the display to stop initiative (see screenshot above)

**Display Initiative**
```
!init display - Show the current initiative status
```

**Re-roll Initiative**
```
!init reroll - Re-rolls initiative for the current characters
!init reroll [position number] - Re-rolls initiative for the specific position
!init reroll '[character name]' - Re-rolls initiative for the specific character
```
You can also click the crossing arrows (2nd from right) under the display to re-roll initiative (see screenshot above)

**Break Ties**  
Sometimes there are ties. Use these commands to move a character up or down one position.
```
!init move [position number] up - Moves the character at a specific position up
!init move '[character name]' up - Moves the named character up
```

**Reset Initiative**
```
!init reset - Clears the done indicators and sets the first character as up
```
You can also click the circle arrows (2nd from left) under the display to reset initiative (see screenshot above)

**Help**
```
!init help - Display a help message
```

# Development
1. Clone the repository
2. Make the data and logs directories
3. Create a bot in Discord and copy the token
4. Make the .env file (Windows users, make sure the file doesn't have a .txt extension)
5. Add the following to the .env file:
```
BOT_TOKEN="[Paste Discord Bot Token Here]"
BOT_OWNER_ID="87654321"
BOT_OWNER_TIME_ZONE="Central Time (US & Canada)"
```
For Example:  BOT_TOKEN="AbCdefG1928371"

6. Run docker-compose up
