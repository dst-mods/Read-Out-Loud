-- modinfo.lua - Mod metadata and configuration
name = "Read Out Loud"
description = "When you click on a sign, if it has text written on it, all nearby characters and creatures within a certain radius will read it out loud together."
author = "Dylan Li"
version = "1.0.0"

forumthread = ""
api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- Mod configuration options
configuration_options = {
    {
        name = "ReadRadius",
        label = STRINGS.MOD.TITLE,
        options = {
            { description = "1", data = 1 },
            { description = "2", data = 2 },
            { description = "3", data = 3 },
            { description = "4", data = 4 },
            { description = "5", data = 5 },
            { description = "6", data = 6 },
            { description = "7", data = 7 },
            { description = "8", data = 8 },
            { description = "9", data = 9 },
            { description = "10", data = 10 },
            { description = "11", data = 11 },
            { description = "12", data = 12 },
            { description = "13", data = 13 },
            { description = "14", data = 14 },
            { description = "15", data = 15 },
            { description = "16", data = 16 },
            { description = "17", data = 17 },
            { description = "18", data = 18 },
            { description = "19", data = 19 },
            { description = "20", data = 20 },
            { description = "23", data = 23 },
            { description = "24", data = 24 },
            { description = "25", data = 25 },
            { description = "26", data = 26 },
            { description = "27", data = 27 },
            { description = "28", data = 28 },
            { description = "29", data = 29 },
            { description = "30", data = 30 },
        },
        default = 5,
    },
    {
        name = "ReadInterval",
        label = STRINGS.MOD.FIELD.READ_INTERVAL,
        options = {
            { description = "10", data = 10 },
            { description = "50", data = 50 },
            { description = "100", data = 100 },
            { description = "150", data = 150 },
            { description = "200", data = 200 },
            { description = "250", data = 250 },
            { description = "300", data = 300 },
            { description = "350", data = 350 },
            { description = "400", data = 400 },
            { description = "450", data = 450 },
            { description = "500", data = 500 },
            default = 250
        }
    }
}