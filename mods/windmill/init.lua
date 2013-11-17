minetest.register_node("windmill:windmill_farm", {
	description = "Farm Style Windmill",
	drawtype = "signlike",
	visual_scale = 1.6,
	tiles = {
	{name="windmill_farm.png", animation={type="vertical_frames", aspect_w=160, aspect_h=160, length=0.6}}
	},
	inventory_image = "windmill_farm_inv.png",
	wield_image = "windmill_farm_inv.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = <default>
		--wall_bottom = <default>
		--wall_side = <default>
	},
	groups = {choppy=2,dig_immediate=2},
})

minetest.register_node("windmill:windmill_wooden", {
	description = "Wooden Windmill",
	drawtype = "signlike",
	visual_scale =3,
	tiles = {
	{name="windmill_wooden.png", animation={type="vertical_frames", aspect_w=160, aspect_h=160, length=1.4}}
	},
	inventory_image = "windmill_wooden_inv.png",
	wield_image = "windmill_wooden_inv.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	selection_box = {
		type = "wallmounted",
		--wall_top = <default>
		--wall_bottom = <default>
		--wall_side = <default>
	},
	groups = {choppy=2,dig_immediate=2},
})

for _, tree in pairs(realtest.registered_trees) do
	minetest.register_craft({
		output = "windmill:windmill_farm",
		recipe = {
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
			{tree.name.."_plank", tree.name.."_stick", tree.name.."_plank"},
			{tree.name.."_plank", tree.name.."_plank", tree.name.."_plank"},
		}
	})
	minetest.register_craft({
		output = "windmill:windmill_wooden",
		recipe = {
			{"", tree.name.."_plank", ""},
			{tree.name.."_plank", tree.name.."_stick", tree.name.."_plank"},
			{"", tree.name.."_plank", ""},
		}
	})
end
