ores = {}


minetest.register_ore({
	ore_type       = "scatter",
	ore            = "ores:peat",
	wherein        = "default:dirt",
	clust_scarcity = 20*20*20,
	clust_num_ores = 343,
	clust_size     = 7,
	height_min     = -31000,
	height_max     = 0,
})

dofile(minetest.get_modpath("ores").."/registration.lua")
