-- config.lua
return {
    JobLocations = {
        ['docks'] = {
            Trucks = {
                { startCost = 300, model = 'hauler' },
                { startCost = 500, model = 'phantom' }
            },
            Trailers = {
                { model = 'trailers' },
                { model = 'trailers2' }
            },
            BossPed = {
                model = 's_m_m_dockwork_01',
                position = vec4(152.945, -3212.007, 5.902, 68.881)
            },
            TrailerSpawnPosition = vec4(180.326, -3208.302, 5.628, 358.337),
            {
                { model = 'trailers',  labelName = 'Trailer' },
                { model = 'trailers2', labelName = 'Trailer 2' },
            },

            Jobs = {
                ["oil_01"] = { name = "Oil delivery", reward = 1000, position = vec4(2588.521, 414.855, 108.457, 181.234), trailerType = "tanker2" },
                ["wood_01"] = { name = "Wood delivery", reward = 1500, position = vec4(-65.248, 1905.083, 196.002, 188.290), trailerType = "trailerlogs" },
                ["metal_01"] = { name = "Metal delivery", reward = 3000, position = vec4(2675.063, 1431.447, 24.501, 268.169), trailerType = "trailers2" },
                ["goods_01"] = { name = "Goods delivery", reward = 4500, position = vec4(720.875, -984.858, 24.156, 274.363), trailerType = "trailers3" },
                ["goods_02"] = { name = "Goods delivery 2", reward = 4500, position = vec4(-2310.149, 265.014, 169.602, 22.005), trailerType = "trailers3" },
                ["goods_03"] = { name = "Goods delivery 3", reward = 5000, position = vec4(-2310.149, 265.014, 169.602, 22.005), trailerType = "trailers3" }
            },
            VehicleParkingSpots = {
                vec4(144.677, -3210.092, 6.090, 270.0),
                vec4(132.568, -3209.907, 6.095, 270.0),
                vec4(144.616, -3204.009, 6.093, 270.0),
                vec4(132.764, -3203.816, 6.092, 270.0),
                vec4(144.480, -3196.842, 6.091, 270.0),
                vec4(132.946, -3196.983, 6.092, 270.0),
                vec4(164.094, -3222.438, 6.158, 270.0),
                vec4(163.093, -3227.679, 6.174, 270.0),
                vec4(163.147, -3236.446, 6.172, 270.0)
            }
        },
    },
    Colors = {
        ['inBoundColor'] = { r = 100, g = 255, b = 100 },
        ['outOfBoundsColor'] = { r = 255, g = 100, b = 100 }
    },
}
