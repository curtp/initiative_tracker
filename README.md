# Init Tracker
Discord bot for tracking initiative in RPG games

This is a work in progress and not ready for general use. Message me if you'd like to try it out. There is a very limited number of servers allowed at this time.

### Required Permissions
**Send Messages** - Allows the bot to send messages to the channel.

### Optional Permissions
**Embed Links** - Allows the bot to reply to ask commands with a nicer formatted answer.\
**Manage Messages** - Allows the bot to remove the original ask question when replying with an answer, reducing clutter.

## How It Works
Initiative is tracked in an individual channel. To start tracking initiative, start initiative:

!init start

Then, add characters to initiative. As characters are added, their order will be randomized.

!init add <character name>

Once all characters have been added, the character at the top of the list will be the first. To move to the next
character, run the next command.

!init next

Continue calling next until combat is over. To stop initiative, just run the stop command.

!init stop

## Some Things to Know
1) Initiative can be tracked in multiple channels on a single server.

## Using The Initiative Tracker

```
!init
```

## Starting Initiative Tracking


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
