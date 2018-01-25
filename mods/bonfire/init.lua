bonfire = {}

bonfire.formspec =
	"size[8,9]"..
	"image[2,2;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;fuel;2,3;1,1;]"..
	"list[current_name;src;2,1;1,1;]"..
	"list[current_name;dst;5,1;2,1;]"..
	"list[current_player;main;0,5;8,4;]"..
	"listring[current_name;dst]"..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
	"listring[current_name;fuel]"..
	"listring[current_player;main]"

realtest.bonfire_fuels = {}
function realtest.add_bonfire_fuel(fuel)
	if fuel then
		table.insert(realtest.bonfire_fuels, fuel)
	end
end
realtest.add_bonfire_fuel("default:cactus")
realtest.add_bonfire_fuel("default:papyrus")
realtest.add_bonfire_fuel("default:torch")
realtest.add_bonfire_fuel("default:sign_wall")
realtest.add_bonfire_fuel("ores:peat")
realtest.add_bonfire_fuel("minerals:charcoal")

minetest.register_node("bonfire:self", {
	description = "Bonfire",
	tiles = {"bonfire_top.png", "bonfire_bottom.png", "bonfire_side.png"},
	particle_image = {"bonfire_bottom.png"},
	drawtype = "nodebox",
	paramtype = "light",
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,-0.45,0.5},
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,-0.45,0.5},
		},
	},
	drop = "",
	groups = {crumbly=3, oddly_breakable_by_hand=1, not_in_creative_inventory=1},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", bonfire.formspec)
		meta:set_string("infotext", "Bonfire")
		meta:set_int("active", 0)
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 2)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("fuel") and inv:is_empty("src") and inv:is_empty("dst") then
			return true
		end
		return false
	end,
})

minetest.register_node("bonfire:self_active", {
	description = "Bonfire",
	tiles = {"bonfire_top_active.png", 
	         "bonfire_bottom.png", 
	         {name="bonfire_flame.png",
		     animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.8}},
	},
	particle_image = {"bonfire_bottom.png"},
	drawtype = "nodebox",
	paramtype = "light",
	damage_per_second = 6,
	walkable = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.45001,-0.5,0.5,-0.45,0.5},--Base
			{-5/16, -8/16, -3/16, 5/16, 8/16, -3/16},--Fire
			{-5/16, -8/16, 3/16, 5/16, 8/16, 3/16},--Fire
			{-3/16, -8/16, -5/16, -3/16, 8/16, 5/16},--Fire
			{3/16, -8/16, -5/16, 3/16, 8/16, 5/16},--Fire
		},
	},
	selection_box = {
		type = "fixed",
		fixed = {
			{-0.5,-0.5,-0.5,0.5,-0.45,0.5},
		},
	},
	light_source = 12,
	drop = "",
	groups = {igniter=1,crumbly=3, not_in_creative_inventory=1,fires=1},
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", bonfire.formspec)
		meta:set_string("infotext", "Bonfire")
		meta:set_int("active", 0)
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 2)
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if inv:is_empty("fuel") and inv:is_empty("src") and inv:is_empty("dst") then
			return true
		end
		return false
	end,
})

minetest.register_abm({
	nodenames = {"bonfire:self","bonfire:self_active"},
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
		
		if meta:get_int("active") == 1 then
			if meta:get_int("sound_play") ~= 1 then
				meta:set_int("sound_handle", minetest.sound_play("bonfire_burning", {pos=pos, max_hear_distance = 4,loop=true,gain=0.8}))
				meta:set_int("sound_play", 1)
			end
			local inv = meta:get_inventory()

			local srclist = inv:get_list("src")
			local cooked = nil
		
			if srclist then
				cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
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
						srcstack = inv:get_stack("src", 1)
						srcstack:take_item()
						inv:set_stack("src", 1, srcstack)
					--else
						--print("Could not insert '"..cooked.item.."'")
					end
					meta:set_string("src_time", 0)
				end
			end
		
			if meta:get_float("fuel_time") < meta:get_float("fuel_totaltime") then
				local percent = math.floor(meta:get_float("fuel_time") /
						meta:get_float("fuel_totaltime") * 100)
				meta:set_string("infotext","Bonfire active: "..percent.."%")
				hacky_swap_node(pos,"bonfire:self_active")
				meta:set_string("formspec",
					"size[8,9]"..
					"image[2,2;1,1;default_furnace_fire_bg.png^[lowpart:"..
							(100-percent)..":default_furnace_fire_fg.png]"..
					"list[current_name;fuel;2,3;1,1;]"..
					"list[current_name;src;2,1;1,1;]"..
					"list[current_name;dst;5,1;2,1;]"..
					"list[current_player;main;0,5;8,4;]"..
					"listring[current_name;dst]"..
					"listring[current_player;main]"..
					"listring[current_name;src]"..
					"listring[current_player;main]"..
					"listring[current_name;fuel]"..
					"listring[current_player;main]"
				)
				return
			end

			local fuel = nil
			local cooked = nil
			local fuellist = inv:get_list("fuel")
			local srclist = inv:get_list("src")
		
			if srclist then
				cooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
			end
			if fuellist then
				fuel = minetest.get_craft_result({method = "fuel", width = 1, items = fuellist})
				if fuel and not table.contains(realtest.bonfire_fuels, inv:get_stack("fuel", 1):get_name()) then
					fuel.time = 0
				end 
			end

			if fuel.time <= 0 then
				meta:set_string("infotext","Bonfire out of fuel")
				hacky_swap_node(pos,"bonfire:self")
				meta:set_string("formspec", bonfire.formspec)
				meta:set_int("active", 0)
				meta:set_int("sound_play", 0)
				minetest.sound_stop(meta:get_int("sound_handle"))
				return
			end

			meta:set_string("fuel_totaltime", fuel.time)
			meta:set_string("fuel_time", 0)
		
			local stack = inv:get_stack("fuel", 1)
			stack:take_item()
			inv:set_stack("fuel", 1, stack)
		end
	end,
})
