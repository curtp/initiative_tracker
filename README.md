# Initiative Tracker
Discord bot for tracking initiative for RPG games

This is a work in progress and not ready for general use. Message me if you'd like to try it out. There is a very limited number of servers allowed at this time.

### Required Permissions
**Send Messages** - Allows the bot to send messages to the channel.

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

**Who's Up?**
```
!init next - Moves to the next character in the list
!init next [position number] - Set the next character to be up: !init next 3
```

**Stop Initative**
```
!init stop - Stops initiative for the channel
```

**Display Initiative**
```
!init display - Show the current initiative status
```

**Re-roll Initiative**
```
!init reroll - Re-rolls initiative for the current characters
```
**Help**
```
!init help - Display a help message
```

# Development
1. Clone the repository
2. Make the data and logs directories
3. Create a bot in Discord and copy the token
4. Make the .env file
5. Add the following to the .env file:
```
BOT_TOKEN="[Paste Discord Bot Token Here]"
```
6. Run docker-compose up
