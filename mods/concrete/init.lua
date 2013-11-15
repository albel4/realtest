minetest.register_node("concrete:concrete_block", {
	description = "Solid Concrete Block",
	drawtype = "normal",
	tiles = {"concrete_block.png"},
	paramtype = "light",
	drop = "concrete:concrete_block",
	groups = {cracky=1},	
})

realtest.register_stair("concrete:concrete_block",nil,nil,nil,
"Concrete Block Stair",nil,nil)
realtest.register_slab("concrete:concrete_block",nil,nil,nil,
"Concrete Block Slab",nil,nil)

minetest.register_node("concrete:concrete_stripe", {
	description = "Solid Concrete Block with Warning Stripes",
	drawtype = "normal",
	tiles = {"concrete_block.png",
             "concrete_block.png",
             "concrete_block.png^concrete_stripe.png"},
	paramtype = "light",
	drop = "concrete:concrete_stripe",
	groups = {cracky=1},	
})

realtest.register_stair("concrete:concrete_stripe",nil,nil,nil,
"Concrete Block with Warning Stripes Stair",nil,nil)
realtest.register_slab("concrete:concrete_stripe",nil,nil,nil,
"Concrete Block with Warning Stripes Slab",nil,nil)

minetest.register_craft({
	output = "concrete:concrete_block 5",
	recipe = {
		{"default:stone", "metals:steel_ingot", "default:stone"},
		{"metals:steel_ingot","default:stone","metals:steel_ingot"},
		{"default:stone","metals:steel_ingot","default:stone"},
	}
})

minetest.register_craft({
	output = "concrete:concrete_stripe",
	recipe = {
		{"default:stone", "metals:steel_ingot", "default:stone"},
		{"metals:steel_ingot","default:stone","metals:steel_ingot"},
		{"default:stone","metals:steel_ingot","default:stone"},
	}
})

minetest.register_craft({
	type = 'shapeless',
    output = 'concrete:concrete_stripe',
    recipe = {'dye:yellow', 'dye:black', 'concrete:concrete_block'},
})
