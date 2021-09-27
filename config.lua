local Config, Zones, PlayerData = {}, {}, {}

Config.Debug = false

Config.CircleZones = {

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