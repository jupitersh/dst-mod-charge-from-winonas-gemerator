-- This information tells other players more about the mod
name = "Charge from Winona's G.E.M.erator"
description = "WX-78 can got charged by touching the Winona's G.E.M.erator."
author = "辣椒小皇纸"
version = "1.0.3"
forumthread = ""
api_version = 10

all_clients_require_mod = false
client_only_mod = false
dst_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

----------------------
-- General settings --
----------------------

countoption = {}

for i=10,200,10 do
    countoption[#countoption + 1] = {
        description = i,
        data = i,
    }
end

configuration_options =
{
	{
		name = "fuel_rate",
		label = "Fuel Rate",
		hover = "How many seconds the fulfilled G.E.M.erator will last when touched.\nEvery second of touch will produce a lightning strike effect to the player.\n设置满宝石的发电机持续时间（秒），每秒可获得一次雷击效果",
		options = countoption,
		default = 100,
	},
}