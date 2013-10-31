-- init.lua
-- workbench minetest mod, by darkrose
-- Copyright (C) Lisa Milne 2012 <lisa@ltmnet.com>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Lesser General Public License as
-- published by the Free Software Foundation, either version 2.1 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this program.  If not, see
-- <http://www.gnu.org/licenses/>

minetest.register_on_joinplayer(function(player)
	player:get_inventory():set_width("craft", 2)
	player:get_inventory():set_size("craft", 2*2)
	player:set_inventory_formspec("size[8,7.5]"
		.."list[current_player;main;0,3.5;8,4;]"
		.."list[current_player;craft;3,0.5;2,2;]"
		.."image[5,1;1,1;workbench_craftarrow.png]"
		.."list[current_player;craftpreview;6,1;1,1;]")
end)

for _, tree in pairs(realtest.registered_trees) do
	minetest.register_node("workbench:work_bench_"..tree.name:remove_modname_prefix(), {
		description = tree.description .. " Workbench",
		tiles = {"trees_"..tree.name:remove_modname_prefix().."_trunk_top.png^workbench_top.png", 
		         "trees_"..tree.name:remove_modname_prefix().."_trunk_top.png", 
		         "trees_"..tree.name:remove_modname_prefix().."_trunk.png^workbench_side.png"},
		groups = {oddly_breakable_by_hand=3, dig_immediate=2},
		sounds = default.node_sound_wood_defaults(),
		paramtype = "light",
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
			"size[8,9]"..
			"list[current_name;table;1,1;3,3;]"..
			"image[4,1.6;2,2;workbench_craftarrow.png]"..
			"list[current_name;dst;6,2;1,1;]"..
			"list[current_player;main;0,5;8,4;]")
		meta:set_string("infotext", "WorkBench")
		local inv = meta:get_inventory()
		inv:set_size("table", 9)
		inv:set_size("dst", 1)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if inv:is_empty("table") and inv:is_empty("dst") then
			return true
		end
		return false
	end,
	allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
		if to_list == "dst" then
			return 0
		end
		return count
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "dst" then
			return 0
		end
		return stack:get_count()
	end,
	allow_metadata_inventory_take = function(pos, listname, index, stack, player)
		return stack:get_count()
	end,
	on_metadata_inventory_move = function(pos, from_list, from_index,
			to_list, to_index, count, player)
		minetest.node_metadata_inventory_move_allow_all(
				pos, from_list, from_index, to_list, to_index, count, player)
		if to_list == "table" or from_list == "table" then
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()
			local tablelist = inv:get_list("table")
			local crafted = nil

			if tablelist then
				crafted = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
			end

			if crafted then
				inv:set_stack("dst", 1, crafted.item)
			else
				inv:set_stack("dst", 1, nil)
			end
		end
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "table" then
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()
			local tablelist = inv:get_list("table")
			local crafted = nil

			if tablelist then
				crafted = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
			end

			if crafted then
				inv:set_stack("dst", 1, crafted.item)
			else
				inv:set_stack("dst", 1, nil)
			end
		end
	end,
	on_metadata_inventory_take = function(pos, listname, index, count, player)
		if listname == "table" then
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()
			local tablelist = inv:get_list("table")
			local crafted = nil

			if tablelist then
				crafted = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
			end

			if crafted then
				inv:set_stack("dst", 1, crafted.item)
			else
				inv:set_stack("dst", 1, nil)
			end
		elseif listname == "dst" then
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()
			local tablelist = inv:get_list("table")
			local crafted = nil
			local table_dec = nil

			if tablelist then
				crafted,table_dec = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
			end

			if table_dec then
				inv:set_list("table", table_dec.items)
			else
				inv:set_list("table", nil)
			end

			local tablelist = inv:get_list("table")

			if tablelist then
				crafted,table_dec = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
			end

			if crafted then
				inv:set_stack("dst", 1, crafted.item)
			else
				inv:set_stack("dst", 1, nil)
			end
		end
		return post
	end,
	})
	minetest.register_craft({
		output = "workbench:work_bench_"..tree.name:remove_modname_prefix(),
		recipe = {
			{tree.name.."_log", tree.name.."_log"},
			{tree.name.."_log", tree.name.."_log"}
		}
	})
end
