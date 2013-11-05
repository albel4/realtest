--
--Flax Registry
--

for i=1,4 do
	local drop = {
		items = {
			{items = {'farming:string'},rarity=5-i},
			{items = {'farming:string'},rarity=6-i*2},
			{items = {'farming:string'},rarity=7-i*3},
			{items = {'farming:seed_flax'},rarity=5-i},
			{items = {'farming:seed_flax'},rarity=6-i*2},
			{items = {'farming:seed_flax'},rarity=7-i*3},
		}
	}
	minetest.register_node("farming:flax_"..i, {
		drawtype = "plantlike",
		tiles = {"farming_flax_"..i..".png"},
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		is_ground_content = true,
		drop = drop,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		groups = {snappy=3,flammable=2,plant=1,flax=i,not_in_creative_inventory=1,attached_node=1},
		sounds = default.node_sound_leaves_defaults(),
	})
end

minetest.register_node("farming:seed_flax", {
	drawtype = "raillike",
	description = "Flax Seeds",
	tiles = {"farming_seed_placed.png"},
	inventory_image = "farming_flax_seed.png",
	groups = {snappy=3, plant=1},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
    type = "fixed",
	fixed = {
		{-0.500000,-0.500000,-0.500000,0.500000,-0.3,0.500000},
	    },
    },
    drop = "",
})

--
--Spelt registry
--
for i=1,4 do
	local drop = {
		items = {
			{items = {'farming:wheat'},rarity=5-i},
			{items = {'farming:wheat'},rarity=6-i*2},
			{items = {'farming:wheat'},rarity=7-i*3},
			{items = {'farming:seed_spelt'},rarity=5-i},
			{items = {'farming:seed_spelt'},rarity=6-i*2},
			{items = {'farming:seed_spelt'},rarity=7-i*3},
		}
	}
	minetest.register_node("farming:spelt_"..i, {
		drawtype = "plantlike",
		tiles = {"farming_spelt_"..i..".png"},
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		is_ground_content = true,
		drop = drop,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		groups = {snappy=3,flammable=2,plant=1,flax=i,not_in_creative_inventory=1,attached_node=1},
		sounds = default.node_sound_leaves_defaults(),
	})
end

minetest.register_node("farming:seed_spelt", {
	drawtype = "raillike",
	description = "Spelt (Wheat) Seeds",
	tiles = {"farming_seed_placed.png"},
	inventory_image = "farming_spelt_seed.png",
	groups = {snappy=3, plant=1},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
    type = "fixed",
	fixed = {
		{-0.500000,-0.500000,-0.500000,0.500000,-0.3,0.500000},
	    },
    },
    drop = "",
})

--
--Seed Growing ABMs

minetest.register_abm({
	nodenames = {"farming:seed_flax"},
	interval = 200,
	chance = 10,
	action = function(pos, node)
	    if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	        minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:flax_1"})
	    end
	end
})

minetest.register_abm({
	nodenames = {"farming:seed_spelt"},
	interval = 200,
	chance = 10,
	action = function(pos, node)
	    if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	        minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:spelt_1"})
	    end
	end
})

--
--Plant Growing ABMs
--

--Flax
minetest.register_abm({
	nodenames = {"farming:flax_1"},
	interval = 200,
	chance = 10,
	action = function(pos, node)
	    if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	        minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:flax_2"})
	    end
	end
})
minetest.register_abm({
	nodenames = {"farming:flax_2"},
	interval = 200,
	chance = 10,
	action = function(pos, node)
	    if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	        minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:flax_3"})
	    end
	end
})
minetest.register_abm({
	nodenames = {"farming:flax_3"},
	interval = 200,
	chance = 10,
	action = function(pos, node)
	    if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	        minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:flax_4"})
	    end
	end
})

--Spelt
minetest.register_abm({
	nodenames = {"farming:spelt_1"},
	interval = 200,
	chance = 10,
	action = function(pos, node)
	    if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	        minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:spelt_2"})
	    end
	end
})
minetest.register_abm({
	nodenames = {"farming:spelt_2"},
	interval = 200,
	chance = 10,
	action = function(pos, node)
	    if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	        minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:spelt_3"})
	    end
	end
})
minetest.register_abm({
	nodenames = {"farming:spelt_3"},
	interval = 200,
	chance = 10,
	action = function(pos, node)
	    if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	        minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:spelt_4"})
	    end
	end
})

--
--Farming Soil registry
--

minetest.register_node("farming:soil", {
	description = "Farming Soil",
	tiles = {"farming_soil.png",
	         "default_dirt.png"},
	groups = {crumbly=3},
	paramtype = "light",
	drop = "default:dirt",
})

--
--Craftitem Registry
--
minetest.register_craftitem("farming:string", {
	description = "String",
	inventory_image = "farming_string.png",
	wield_image = "farming_string.png",
})

minetest.register_craftitem("farming:wheat", {
	description = "Spelt",
	inventory_image = "farming_wheat.png",
	wield_image = "farming_wheat.png",
})

minetest.register_craftitem("farming:flour", {
	description = "Pile of Flour",
	inventory_image = "farming_flour.png",
	wield_image = "farming_flour.png",
})

minetest.register_craftitem("farming:bread", {
	description = "Loaf of Bread",
	inventory_image = "farming_bread.png",
	wield_image = "farming_bread.png",
	on_use=minetest.item_eat(8)
})

--
--Crafting
--
minetest.register_craft({
	output = "farming:flour",
	recipe = {
		{"farming:wheat","farming:wheat"},
		{"farming:wheat","farming:wheat"},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "farming:bread",
	recipe = "farming:flour",
	cooktime = 30,
})

minetest.register_craft({
	output = "farming:hoe_head 4",
	recipe = {
	    {"","default:cobble","default:cobble"},
		{"default:cobble","",""},
	}
})

minetest.register_craft({
	output = "farming:hoe",
	recipe = {
	    {"farming:hoe_head"},
		{"group:stick"},
	}
})

--
--The hoe (only stone for now)
--
minetest.register_craftitem("farming:hoe_head", {
	description = "Hoe Head",
	inventory_image = "farming_hoe_head.png",
})

minetest.register_craftitem("farming:hoe", {
	description = "Hoe",
	inventory_image = "farming_hoe.png",
})

--
--Farming soil-dirt abm
--

minetest.register_abm({
	nodenames = {"farming:soil"},
	interval = 30,
	chance = 3,
	action = function(pos, node)
	    if minetest.get_node({x=pos.x,y=pos.y+1,z=pos.z}).name == "group:plant"  then
	        minetest.add_node({x=pos.x,y=pos.y-1,z=pos.z}, {name="default:dirt"})
	    end
	end
})
--
--Hoe functions
--

minetest.register_node(":default:dirt", {
	description = "Dirt",
	tiles = {"default_dirt.png"},
	is_ground_content = true,
	groups = {crumbly=3,soil=1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.25},
	}),
	on_punch = function(pos, node, puncher)
		if puncher:get_wielded_item():get_name() == "farming:hoe" then
			minetest.env:set_node(pos, {name="farming:soil"})
		end
	end,
})

minetest.register_node(":default:dirt_with_grass", {
	description = "Grass",
	tiles = {"default_dirt_grass.png", 
	         "default_dirt.png", 
	         "default_dirt_grass.png"},
	is_ground_content = true,
	groups = {crumbly=3,soil=1},
	drop = 'default:dirt',
	sounds = default.node_sound_dirt_defaults({
		footstep = {name="default_grass_footstep", gain=0.25},
	}),
	on_punch = function(pos, node, puncher)
		if puncher:get_wielded_item():get_name() == "farming:hoe" then
			minetest.env:set_node(pos, {name="farming:soil"})
		end
	end,
})

--
--Bird Nest
--
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "farming:nest",
	wherein        = "group:leaves",
	clust_scarcity = 10*10*10,
	clust_num_ores = 1,
	clust_size     = 1,
	height_min     = -10,
	height_max     = 200,
})

minetest.register_node("farming:nest", {
	drawtype = "nodebox",
	description = "Bird's Nest",
	tiles = {"farming_birdnest.png"},
	groups = {snappy=3},
	paramtype = "light",
	sunlight_propagates = true,
	node_box = {
    type = "fixed",
	fixed = {
		{-3/16,-8/16,-3/16,3/16,-6/16,3/16}, --Base
		{-5/16,-6/16,-5/16,5/16,-4/16,5/16}, --Middle
		{-6/16,-4/16,-6/16,-4/16,-0/16,6/16}, --Top Section
		{4/16,-4/16,-6/16,6/16,-0/16,6/16}, --Top Section
		{-6/16,-4/16,-6/16,6/16,-0/16,-4/16}, --Top Section
		{-6/16,-4/16,4/16,6/16,-0/16,6/16}, --Top Section
	    },
    },
		drop = {
			max_items = 2,
			items = {
				{
					items = {"farming:seed_flax"},
					rarity = 3,
				},
				{
					items = {"farming:seed_spelt"},
					rarity = 3,
				},
				{
					items = {"farming:seed_flax"},
					rarity = 6,
				},
				{
					items = {"farming:seed_spelt"},
					rarity = 6,
				},
				{
					items = {"default:stick"},
					rarity = 3,
				},
			}
		}
})

--
--Rope
--

minetest.register_node("farming:rope",{
	description = "Rope",
	drawtype = "nodebox",
	sunlight_propagates = true,
	tiles = {"farming_rope.png"},
	inventory_image = "farming_rope.png",
	wield_image = "farming_rope.png",
	groups = {choppy=3,snappy=3,oddly_breakable_by_hand=3,flammable=1},
	paramtype = "light",
	climbable = true,
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-1/16, -8/16, -1/16, 1/16, 8/16, 1/16}, 
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-1/16, -8/16, -1/16, 1/16, 8/16, 1/16},
		},
	},
})

minetest.register_craft({
	output = "farming:rope",
	recipe = {
	    {"farming:string"},
		{"farming:string"},
		{"farming:string"},
	}
})

