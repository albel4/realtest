local plant = {}

plant.types = {
	{"flax", "Flax", "farming_flax", "farming:string"},
	{"spelt", "Spelt", "farming_spelt", "farming:wheat"},
	{"soy", "Soy", "farming_soy", "farming:soy"},
}

for _, row in ipairs(plant.types) do
	local name = row[1]
	local desc = row[2]
	local tile = row[3]
	local dropitem = row[4]
for i=1,4 do
--Define what each plant drops
	local drop = {
		items = {
			{items = {dropitem},rarity=5-i},
			{items = {dropitem},rarity=7-i*2},
			{items = {dropitem},rarity=9-i*3},
			{items = {'farming:seed_'..name},rarity=5-i},
			{items = {'farming:seed_'..name},rarity=7-i*2},
			{items = {'farming:seed_'..name},rarity=9-i*3},
		}
	}
--Register the plant nodes for each growth stage
	minetest.register_node("farming:"..name.."_"..i, {
	    description = desc.." Stage "..i,
		drawtype = "plantlike",
		tiles = {"farming_"..name.."_"..i..".png"},
		paramtype = "light",
		walkable = false,
		buildable_to = true,
		drop = drop,
		selection_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
		},
		groups = {snappy=3,flammable=2,plant=1,name=i,not_in_creative_inventory=1,attached_node=1},
		sounds = default.node_sound_leaves_defaults(),
	})
--Register the seeds for each plant
    minetest.register_node("farming:seed_"..name, {
	    drawtype = "raillike",
	    description = desc.." Seeds",
	    tiles = {"farming_seed_placed.png"},
	    inventory_image = "farming_"..name.."_seed.png",
	    groups = {snappy=3, plant=1, attached_node=1},
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
--And finally, the abms to control growth
    minetest.register_abm({
	    nodenames = {"farming:seed_"..name},
	    interval = 200,
	    chance = 10,
	    action = function(pos, node)
	        if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	            minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:"..name.."_1"})
	        end
	    end
    })
    minetest.register_abm({
	    nodenames = {"farming:"..name.."_1"},
	    interval = 200,
	    chance = 10,
	    action = function(pos, node)
	        if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	            minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:"..name.."_2"})
	        end
	    end
    })
    minetest.register_abm({
	    nodenames = {"farming:"..name.."_2"},
	    interval = 200,
	    chance = 10,
	    action = function(pos, node)
	        if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	            minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:"..name.."_3"})
	        end
	    end
    })
    minetest.register_abm({
	    nodenames = {"farming:"..name.."_3"},
	    interval = 200,
	    chance = 10,
	    action = function(pos, node)
	        if minetest.get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == "farming:soil"  then
	            minetest.add_node({x=pos.x,y=pos.y,z=pos.z}, {name="farming:"..name.."_4"})
	        end
	    end
    })
end
end

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

minetest.register_craftitem("farming:jar", {
	description = "Glass Jar",
	inventory_image = "farming_jar.png",
	wield_image = "farming_jar.png",
})

minetest.register_craftitem("farming:soy", {
	description = "Soy Beans",
	on_use=minetest.item_eat(2),
	inventory_image = "farming_soy.png",
	wield_image = "farming_soy.png",
})
minetest.register_craftitem("farming:soy_milk", {
	description = "Soy Milk",
	on_use=minetest.item_eat(8),
	inventory_image = "farming_soy_milk.png",
	wield_image = "farming_soy_milk.png",
})

--
--Cake
--

minetest.register_node("farming:cake", {
    drawtype = "nodebox",
	description = "CAKE!!!",
	tiles = {"farming_cake_top.png","farming_cake_base.png","farming_cake_side.png"},
	groups = {crumbly=3},
	paramtype = "light",
	drop = "farming:cake",
	on_use=minetest.item_eat(16),
	node_box = {
	    type = "fixed",
		fixed = {
			{-6/16, -8/16, -4/16, 6/16, 0/16, 4/16},
			{-4/16, -8/16, -6/16, 4/16, 0/16, 6/16},
			{-5/16, -8/16, -5/16, 5/16, 0/16, 5/16},
		},
	},
	selection_box = {
        type = "fixed",
	    fixed = {
		    {-8/16,-8/16,-8/16,8/16,0/16,8/16},
	    },
    },
})

minetest.register_craftitem("farming:dough", {
	description = "Cake Mixture",
	inventory_image = "farming_cakedough.png",
	wield_image = "farming_cakedough.png",
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


minetest.register_craft({
	output = "farming:dough",
	recipe = {
		{"bushes:sugar",,"farming:soy_milk", "bushes:sugar"},
		{"farming:flour","farming:flour","farming:flour"},
	}
})

minetest.register_craft({
	type = "cooking",
	output = "farming:cake",
	recipe = "farming:dough",
	cooktime = 30,
})

minetest.register_craft({
	output = "farming:soy_milk",
	recipe = {
		{"farming:soy"},
		{"farming:jar"},
	}
})

minetest.register_craft({
	output = "farming:jar 12",
	recipe = {
		{"default:glass","","default:glass"},
		{"default:glass","","default:glass"},
		{"default:glass","default:glass","default:glass"},
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
--Rope
--

minetest.register_node("farming:rope",{
	description = "Rope",
	drawtype = "nodebox",
	sunlight_propagates = true,
	tiles = {"farming_rope.png"},
	inventory_image = "farming_rope_inv.png",
	wield_image = "farming_rope_inv.png",
	groups = {choppy=3,snappy=3,oddly_breakable_by_hand=3,flammable=1},
	paramtype = "light",
	climbable = true,
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-2/16, -8/16, -2/16, 2/16, 8/16, 2/16}, 
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-3/16, -8/16, -3/16, 3/16, 8/16, 3/16},
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

--
--Anthill
--
local SPAWN_DELAY = 1000
local SPAWN_CHANCE = 200
local anthill_seed_diff = 339

minetest.register_alias("farming:anthill", "air") -- to get rid of the old ones.

plantslib:spawn_on_surfaces({
	spawn_delay = SPAWN_DELAY,
	spawn_plants = {"farming:ant_hill"},
	avoid_radius = 10,
	spawn_chance = SPAWN_CHANCE/10,
	spawn_surfaces = {"default:dirt_with_grass"},
	avoid_nodes = {"farming:ant_hill"},
	seed_diff = anthill_seed_diff,
	light_min = 1,
})

minetest.register_node("farming:ant_hill",{
	description = "Ant Hill",
	drawtype = "nodebox",
	sunlight_propagates = true,
	tiles = {"farming_anthill.png"},
	groups = {oddly_breakable_by_hand=3,not_in_creative_inventory=1},
	paramtype = "light",
	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -8/16, 8/16, -7/16, 8/16},
			{-7/16, -7/16, -7/16, 7/16, -6/16, 7/16},
			{-6/16, -6/16, -6/16, 6/16, -5/16, 6/16},
			{-5/16, -5/16, -5/16, 5/16, -4/16, 5/16},
			{-4/16, -4/16, -4/16, 4/16, -3/16, 4/16},
			{-3/16, -3/16, -3/16, 3/16, -2/16, 3/16},
			{-2/16, -2/16, -2/16, 2/16, -1/16, 2/16},
			{-1/16, -1/16, -1/16, 1/16, 0/16, 1/16},
		},
	},
		drop = {
			max_items = 2,
			items = {
				{
					items = {"farming:seed_soy"},
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
					items = {"farming:seed_soy"},
					rarity = 6,
				},
				{
					items = {"default:dirt"},
					rarity = 3,
				},
			}
		}
})

