minetest.register_craftitem("grounds:clay_lump", {
	description = "Clay Lump",
	inventory_image = "grounds_clay_lump.png"
})

minetest.register_craft({
	type = "cooking",
	output = "default:clay_brick",
	recipe = "grounds:clay_lump",
})

minetest.register_node("grounds:clay", {
	description = "Clay",
	tiles = {"default_sand.png^grounds_clay.png"},
	is_ground_content = true,
	groups = {crumbly=3},
	drop = 'default:clay_lump 4',
	sounds = default.node_sound_dirt_defaults(),
})

dofile(minetest.get_modpath("grounds").."/dirt.lua")
dofile(minetest.get_modpath("grounds").."/stone.lua")
