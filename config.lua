Config = {}
Config.Locale = 'en'

-- Variables
local second = 1000
local minute = 60 * second
local hour = 60 * minute

-- Whitelisted jobs
Config.Whitelist = true
Config.WhitelistedJobs = {
    'police',
    'ambulance'
}

-- Required cops
Config.RequiredCops = 0

-- Configure locations below (x, y, z)
Config.StartLocation = vector3(-182.60, 6389.56, 31.49)

Config.MoneyWashLocations = {
    vector3(1289.85, 3630.59, 33.19),
    vector3(-663.3, -709.01, 26.77)
}

-- Configure the cut you get back (0.50 = 50%)
Config.PercentageCut = 0.50

-- Configure time to wash money (30 * minute = 30 minutes, 30 * second = 30 seconds, 30 * hour = 30 hours)
Config.EnableTimer = true
Config.MoneyWashTime = 5 * second

-- How much money the user pays in black money (they get back this amount take away the percent specified above)
Config.AmountPerDelivery = 5000

-- Discord Webhooks
Config.Discord = false
Config.DiscordWebhook = ''

-- Debug mode, for developers
Config.DebugMode = false
