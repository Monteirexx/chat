um = {}

um.debug = false -- If you want to use debug mode set this to true

um.logs = { 
    joinLeave = false,
    commandChat = false,
    generalChat = false,
}

um.dot = false -- If you want to use dot system set this to true

um.chat = {
    channel = { -- ![Next Update] 
        status = false, -- If you want to use channel system set this to true or only ALL
        category = {'all','me','do','ooc','pm'}
    },
    commandChat = {
        globalTag = {
            name = 'DIAMOND RP',
            background = '#4ade80'
        },
        windowShowTime = 7000, -- ms
        onlyCommand = true, -- If you make it false, you can type ``/`` in the left chat and send other things except the command
        lastCommandShow = true, -- If you want to show the command history you typed, set this to true
        login = {
            join = false, -- If you want to use join message for all set this to true
            leave = false, -- If you want to use leave message for all set this to true
        },
        -- If you do ``not have`` your own commands such as me, do, ooc, or if you are not using anything special, 
        -- make the commands in um-chat true
        emote = {
            me = false,
            doo = false,
            ooc = false,
            pm = false,
        },
        buttons = {
            emoji = true, -- If you want to use emoji set this to true
            games = true, -- If you want to use games set this to true
            chat = false, -- If you want to use general chat set this to true
        }
    },
    generalChat = {
        settings = {
            maxMessageLimit = 250, -- This is the limit of how many characters to type
            waitForMessage = 3000, -- You can think of it as a slow mode to prevent message spam
            deleteOldMessage = 30 * 60 * 1000 -- 30 minute | Messages exceeding 30 minutes are deleted
        },
        buttons = {
            emoji = true,
            gif = true,
        },
    }
}
