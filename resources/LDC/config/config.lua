Config = {
    ServerName = "LDC", -- server name
    DefaultPayment = {"~g~Liquide~s~", "~b~Banque~s~"}, -- default payement
    WaitForStatus = 2*60000, -- status
    PlayersMax = 255,
    DefaultPos = {x = -66.55, y = -801.91, z = 44.22}, -- spawn pos

    PoundPos = {
        {
            position = vector3(372.2686, -1613.487, 29.29193), 
            heading = 328.71176, 
            price = 80,
            pointSpawn = {377.4869, -1630.391, 28.19953},
            pointHeadingSpawn = 320.0332,
            driveToCoords = {396.9699, -1623.488, 29.29196}
        }
    },
    LocationPos = {
        {pos = vector3(-45.46, -791.15, 45.30)},
    },
    CardealerPos = {
        {pos = vector3(-42.65, -1092.38, 27.5)},
    },
    GaragePos = {
        {pos = vector3(213.71, -809.31, 31.01), ExitPos = {230.09, -797.58, 30.58, 161.94}},
        {pos = vector3(275.59, -344.81, 45.17), ExitPos = {289.97, -337.85, 44.96, 162.35}},
    },
    GarageEnterPos = {
        {pos = vector3(215.40, -790.8, 31.55)},
        {pos = vector3(274.25, -329.57, 44.92)},
    },
    MakeupPos = {
        {label = "Institut de Beauté", pos = vector3(-1281.94, -1117.27, 6.99)}
    },
    SurgeryPos = {
        {label = "Chirurgie", pos = vector3(408.11, -365.53, 46.83)}
    },
    CarWashPos = {
        {label = "CarWash", pos = vector3(-699.76, -933.99, 19.01)},
        {label = "CarWash", pos = vector3(5.281792, -1391.82, 29.29866)},
        {label = "CarWash", pos = vector3(167.96, -1715.66, 28.68)},
    },
    Weight = 50
}