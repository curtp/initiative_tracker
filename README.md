# Initiative Tracker
Discord bot for tracking initiative for RPG games

This is a work in progress however, it is ready for general use. [Invite Link](https://discord.com/api/oauth2/authorize?client_id=805509626107396166&permissions=18432&scope=bot)

<img src="https://github.com/curtp/initiative_tracker/blob/main/docs/init_tracker_screenshot.png?raw=true" width='50%'>
The reactions under the display act as shortcuts for simple interaction. See descriptions of actions below. In the screenshot above, Gandalf is finished, Frodo is up, and Samwise hasn't gone yet.

### Required Permissions
**Send Messages** - Allows the bot to send messages to the channel.  
**Embed Links** - Allows the bot to display initiative in the channel.

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
!init add '[character name]' [dice] - Adds the character to initiative: !init add 'By Tor' 2d6+1
```

**Remove Characters**
```
!init remove [position number] - Removes the character at the position given
!init remove '[character name]' - Removes the character by their name
```

**Who's Up?**
```
!init next - Moves to the next character in the list
!init next [position number] - Set the next character to be up: !init next 3
```

You can also click the right arrow (far left) under the display to move to the next character (see screenshot above)

**Stop Initative**
```
!init stop - Stops initiative for the channel
```
You can also click the stop button (far right) under the display to stop initiative (see screenshot above)

**Display Initiative**
```
!init display - Show the current initiative status
```

**Re-roll Initiative**
```
!init reroll - Re-rolls initiative for the current characters
```
You can also click the crossing arrows (2nd from right) under the display to re-roll initiative (see screenshot above)

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
```
For Example:  BOT_TOKEN="AbCdefG1928371"

6. Run docker-compose up
