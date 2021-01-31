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
Here is an example of a list for asking how likely it is for something to happen:

```
even odds
---------
No
Yes
```

Here are the oracle commands to create this list:
```
!oracle add No to "even odds"
!oracle add Yes to "even odds"
```
Once the list is created, it will be assigned a number which can be used to referr to the list, saving typing.

## Asking Questions
Here are the two commands to ask questions of the list and sample answers:
```
!oracle ask "even odds"
@user, the answer is: "Yes"

!oracle ask "even odds" "Will it snow today?"
@user asked: "Will it snow today?". The answer is: "Yes".

!o ask 1 "Will it snow today?"
```

## List Maintenance
To display all lists for the server:
```
!oracle display

!oracle list

!o list
```

To display all entries in a list:
```
!oracle display "[list name]"
e.g. !oracle display "even odds"

!oracle list "[list name]"
e.g. !oracle list "even odds"

!o list 1
```

To rename a list:
```
!oracle rename "[list name]" to "[new list name]"
e.g. !oracle rename "even odds" to "Odds - Even"

!o rename 1 to "Odds - Even"
```

To remove an answer from a list:
```
!oracle remove "[answer]" from "[list name]"
e.g. !oracle remove Yes from "even odds"

!o remove Yes from 1
```

To remove a list from the server:
```
!oracle remove "[list name]"
e.g. !oracle remove "even odds"

!o remove 1
```

To renumber the lists:
```
!oracle renumber
!o renumber
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
