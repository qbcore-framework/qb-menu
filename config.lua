local Config, Zones, PlayerData = {}, {}, {}

Config.Debug = false

Config.CircleZones = {
    ["Circletest"] = {
        name = 'CircleTest1',
        coords = vector3(-258.17, -978.03, 31.22),
        radius = 1.5,
        debugPoly = false,
        useZ = false,
        menuoptions = {
            buttons = {
                {
                    type = 'header',
                    title = 'Titles',
                    description = 'Alt Title'
                },
                {
                    type = "client", -- client/server/command/qbcommand
                    event = "eventname",
                    options = {
                        data = "chips", -- Send values. args.
                    },
                    title = 'Fist Title',
                    description = 'Title'
                }
            }
        }
    },
}

Config.BoxZones = {
    ["test"] = {
        name = 'Test1',
        coords = vector3(-618.737, 29.33632, 43.236),
        heading = 184.0,
        length = 4.0,
        width = 4.0,
        debugPoly = true,
        minZ = 42.0,
        maxZ = 45.0,
        menuoptions = {
            buttons = {
                {
                    type = 'header',
                    title = 'Test 1',
                    description = 'Testie'
                },
                {
                    type = "client", -- client/server/command/qbcommand
                    event = "eventname",
                    options = {
                        data = "chips",
                        data1 = "chips1",-- Send values. args. bla bla.
                    },
                    title = 'Test 1',
                    description = 'Testie'
                }
            }
        }
    }
}

Config.PolyZones = {

}

return Config, Zones, PlayerData
