function default.get_oven_active_formspec(pos, percent)
	local formspec =
		"size[8,7]"..
		"image[3.5,0.5;1,1;furnace_fire_bg.png^[lowpart:"..
		(100-percent)..":furnace_fire_fg.png]"..
		"list[current_name;fuel;3.5,1.5;1,1;]"..
		"list[current_name;src;2,0.5;1,1;]"..
		"list[current_name;dst;5,0.5;1,1;]"..
		"list[current_player;main;0,3;8,4;]"
	return formspec
end

default.oven_inactive_formspec =
	"size[8,7]"..
	"image[3.5,0.5;1,1;furnace_fire_bg.png]"..
	"list[current_name;fuel;3.5,1.5;1,1;]"..
	"list[current_name;src;2,0.5;1,1;]"..
	"list[current_name;dst;5,0.5;1,1;]"..
	"list[current_player;main;0,3;8,4;]"

minetest.register_node("oven:oven", {
	description = "Oven",
	tiles = {
		"oven_top.png", 
		"oven_base.png", 
		"oven_side.png",
		"oven_side.png", 
		"oven_back.png", 
		"oven_front.png"
	},
	inventory_image = "oven_front.png",
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.oven_inactive_formspec)
		meta:set_string("infotext", "Oven")
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Oven is empty")
				end
				return stack:get_count()
			else
				return 0
			end
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Oven is empty")
				end
				return count
			else
				return 0
			end
		elseif to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end,
})

minetest.register_node("oven:oven_active", {
	description = "Oven",
	tiles = {
		"oven_top.png", 
		"oven_base.png", 
		"oven_side_active.png",
		"oven_side_active.png", 
		"oven_back.png", 
		"oven_front.png"
	},
	paramtype2 = "facedir",
	light_source = 8,
	drop = "oven:oven",
	groups = {cracky=2, not_in_creative_inventory=1,hot=1},
	legacy_facedir_simple = true,
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", default.oven_inactive_formspec)
		meta:set_string("infotext", "Oven");
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if listname == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Oven is empty")
				end
				return stack:get_count()
			else
				return 0
			end
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local stack = inv:get_stack(from_list, from_index)
		if to_list == "fuel" then
			if minetest.get_craft_result({method="fuel",width=1,items={stack}}).time ~= 0 then
				if inv:is_empty("src") then
					meta:set_string("infotext","Oven is empty")
				end
				return count
			else
				return 0
			end
		elseif to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end,
})

function hacky_swap_node(pos,name)
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local meta0 = meta:to_table()
	if node.name == name then
		return
	end
	node.name = name
	local meta0 = meta:to_table()
	minetest.set_node(pos,node)
	meta = minetest.get_meta(pos)
	meta:from_table(meta0)
end

minetest.register_abm({
	nodenames = {"oven:oven","oven:oven_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		for i, name in ipairs({
				"fuel_totaltime",
				"fuel_time",
				"src_totaltime",
				"src_time"
		}) do
			if meta:get_string(name) == "" then
				meta:set_float(name, 0.0)
			end
		end

		local inv = meta:get_inventory()

		local srclist = inv:get_list("src")
		local cooked = nil
		local aftercooked
		
		if srclist then
			cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		end
		
		local was_active = false
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			was_active = true
			meta:set_float("fuel_time", meta:get_float("fuel_time") + 1)
			meta:set_float("src_time", meta:get_float("src_time") + 1)
			if cooked and cooked.item and meta:get_float("src_time") >= cooked.time then
				-- check if there's room for output in "dst" list
				if inv:room_for_item("dst",cooked.item) then
					-- Put result in "dst" list
					inv:add_item("dst", cooked.item)
					-- take stuff from "src" list
					inv:set_stack("src", 1, aftercooked.items[1])
				else
					print("Could not insert '"..cooked.item:to_string().."'")
				end
				meta:set_string("src_time", 0)
			end
		end
		
		if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
			local percent = math.floor(meta:get_float("fuel_time") /
					meta:get_float("fuel_totaltime") * 100)
			meta:set_string("infotext","Oven active: "..percent.."%")
			hacky_swap_node(pos,"oven:oven_active")
			meta:set_string("formspec",default.get_oven_active_formspec(pos, percent))
			return
		end

		local fuel = nil
		local afterfuel
		local cooked = nil
		local fuellist = inv:get_list("fuel")
		local srclist = inv:get_list("src")
		
		if srclist then
			cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		end
		if fuellist then
			fuel, afterfuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
		end

		if fuel and fuel.time <= 0 then
			meta:set_string("infotext","Oven out of fuel")
			hacky_swap_node(pos,"oven:oven")
			meta:set_string("formspec", default.oven_inactive_formspec)
			return
		end

		if cooked and cooked.item and cooked.item:is_empty() then
			if was_active then
				meta:set_string("infotext","Oven is empty")
				hacky_swap_node(pos,"oven:oven")
				meta:set_string("formspec", default.oven_inactive_formspec)
			end
			return
		end
		if fuel and fuel.time then
			meta:set_string("fuel_totaltime", fuel.time)
			meta:set_string("fuel_time", 0)
		
			inv:set_stack("fuel", 1, afterfuel.items[1])
		end
	end,
})

minetest.register_craft({
	output = "oven:oven",
	recipe = {
		{"metals:pig_iron_doublesheet","metals:pig_iron_doublesheet","metals:pig_iron_doublesheet"},
		{"metals:pig_iron_doublesheet","","metals:pig_iron_doublesheet"},
		{"metals:pig_iron_doublesheet","metals:pig_iron_doublesheet","metals:pig_iron_doublesheet"},
	}
})

minetest.register_craft({
	output = "oven:oven",
	recipe = {
		{"metals:wrought_iron_doublesheet","metals:wrought_iron_doublesheet","metals:wrought_iron_doublesheet"},
		{"metals:wrought_iron_doublesheet","","metals:wrought_iron_doublesheet"},
		{"metals:wrought_iron_doublesheet","metals:wrought_iron_doublesheet","metals:wrought_iron_doublesheet"},
	}
})

minetest.register_craft({
	output = "oven:oven",
	recipe = {
		{"metals:steel_doublesheet","metals:steel_doublesheet","metals:steel_doublesheet"},
		{"metals:steel_doublesheet","","metals:steel_doublesheet"},
		{"metals:steel_doublesheet","metals:steel_doublesheet","metals:steel_doublesheet"},
	}
})

minetest.register_craft({
	output = "oven:oven",
	recipe = {
		{"metals:black_steel_doublesheet","metals:black_steel_doublesheet","metals:black_steel_doublesheet"},
		{"metals:black_steel_doublesheet","","metals:black_steel_doublesheet"},
		{"metals:black_steel_doublesheet","metals:black_steel_doublesheet","metals:black_steel_doublesheet"},
	}
})
