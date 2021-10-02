local Config, Zones, PlayerData = {}, {}, {}

Config.Debug = false

Config.CircleZones = {
    ["Circletest"] = {
        name = 'CircleTest1',
        coords = vector3(-258.17, -978.03, 31.22),
        radius = 1.5,
        debugPoly = true,
        useZ = true,
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
    ["qb-cityhall"] = {
        name = 'qb-cityhall',
        coords = vector3(-265.0, -963.6, 31.2),
        radius = 1.5,
        debugPoly = false,
        useZ = true,
        menuoptions = {
            buttons = {
                {
                    type = 'header',
                    title = 'City Hall',
                    description = ''
                },
                {
                    type = "client", -- client/server/command/qbcommand
                    event = "qb-cityhall:client:OpenMenu",
                    options = {
                    },
                    title = 'City Services',
                    description = 'City Services'
                }
            },
            job = "jobname",
        }
    },
    ["qb-newsjob"] = {
        name = 'qb-newsjob:TakeVehicle',
        coords = vector3(-538.83, -889.06, 25.02),
        radius = 1.5,
        debugPoly = false,
        useZ = true,
        menuoptions = {
            buttons = {
                {
                    type = 'header',
                    title = 'Weazel News Garage',
                    description = ''
                },
                {
                    type = "client", -- client/server/command/qbcommand
                    event = "qb-newsjob:client:TakeOutVehicle",
                    options = {
                        vehicle = "rumpo",
                    },
                    title = 'Rumpo',
                    description = 'Weazel News Rumpo',
                },
                
            },
            job = {
                ["reporter"]=2,
            },
        },
    }
}

Config.BoxZones = {
    ["test"] = {
        name = 'Test1',
        coords = vector3(-258.17, -978.03, 31.22),
        heading = 184.0,
        length = 4.0,
        width = 4.0,
        debugPoly = true,
        minZ = 31.0,
        maxZ = 32.0,
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
            job = {
                ["reporter"]=2,
                ["taxi"]= 0,
            },
        }
    },
}

Config.PolyZones = {

}

return Config, Zones, PlayerData