Config = {}

-- Set this to true if you want to enable debug mode (for developers and support)
Config.debugMode = true

-- Framework settings
Config.Framework = {
    -- If you use ESX, you can set this to 'ESX' and it will automatically detect it otherwise set it to 'QBCore'
    FrameworkName = 'ESX',
    -- Set to true if you use the old ESX (not ESX Legacy)
    OldESX = true,
    -- If you use the old ESX, define the event name here to get the ESX object (by default it's 'esx:getSharedObject')
    ESXEvent = 'esx:getSharedObject',
    -- The name of the ESX resource, this is only used if you use ESX
    ESXFileName = 'es_extended',
    -- The name of the SQL wrapper you use (You can set : mysql-async, oxmysql, ghmattimysql). You need to have the resource installed and running before this script.
    SQLWrapper = 'mysql-async'
}

-- If you use qb-target, set this to true to add support for it
Config.UseQbTarget = false

-- If you use ox-target, set this to true to add support for it
Config.UseOxTarget = false

-- If you want discord logging in a channel, fill in the webhook URL here
Config.DiscordWebhook = 'https://discord.com/api/webhooks/1184133785244139641/pn63FhKJS0LPNWVfLMvJJxYxYp3xC0tjDBI6V2Er6PzUfaBARTlS2swoi--ecTLDnECK'

-- Default values to advertise a product (minimum and maximum hours and the price per minute)
Config.Advertisement = { Min = 1, Max = 24, Price = 1 } -- Price = price per minute

-- Default values to auction a product (minimum and maximum hours)
Config.Auction = { Min = 1, Max = 24 }

-- List of blacklisted items for the marketplaces
Config.BlackListItems = {
    -- The water_bottle is just an example, you can remove it if you want
    ['water_bottle'] = true,
}

-- List of blacklisted items for the black markets
Config.BlackMarketBlacklistItems = {
    -- The water_bottle is just an example, you can remove it if you want
    ['water_bottle'] = true,
}

-- List of blacklisted vehicles for both marketplaces and black markets
Config.BlacklistVehicles = { }

-- Set to true if you want to use dirty money for the black market
Config.BlackMarketUseDirtyMoney = false

-- List of the marketplaces
Config.Marketplaces = {
    {
        -- Name of the marketplace
        Name = 'AU Global Market',
        -- Define to 'normal' or 'blackmarket'
        Type = 'blackmarket',
        -- You can whitelist the market for specific jobs
        -- Set it to a table to add jobs to the whitelist, set it to false to disable it
        -- Here is an example of a whitelist with 2 jobs: JobCheck = { ['police'] = true, ['ambulance'] = true }
        -- Here is an example of a whitelist with 1 job: JobCheck = 'police'
        JobCheck = false,
        -- You can whitelist the possibility to sell products for specific jobs
        -- Set it to a table to add jobs to the whitelist, set it to false to disable it
        -- Here is an example of a whitelist with 2 jobs: SellerCheck = { ['police'] = true, ['ambulance'] = true }
        SellerCheck = false,
        -- The location of the marketplace (X, Y, Z)
        Location = vector3(28.96, -1018.68, 29.6),
        -- Blip settings
        Blip = {
            Sprite = 52,
            Color = 2,
            Scale = 1.0,
            Label = 'The Black Market'
        },
        Marker = {
            Type = 2,
            Rotation = { 0.0, 180.0, 0.0 },
            Scale = 0.4,
            Color = { R = 222, G = 186, B = 77, A = 255 },
            BobUpAndDown = true,
            FaceCamera = true,
            MarkerDistance = 5.0,
            TextDistance = 2.0 
        }
    }
}

Config.ListProducts = {
    ['red_phone'] = {min=1000,max=2000}
}