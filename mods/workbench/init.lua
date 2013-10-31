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
if not minetest.setting_getbool("creative_mode") then
  minetest.register_on_joinplayer(function(player)
	  player:get_inventory():set_width("craft", 2)
	  player:get_inventory():set_size("craft", 2*2)
	  player:set_inventory_formspec("size[8,7.5]"
		  .."list[current_player;main;0,3.5;8,4;]"
		  .."list[current_player;craft;3,0.5;2,2;]"
		  .."image[5,1;1,1;workbench_craftarrow.png]"
		  .."list[current_player;craftpreview;6,1;1,1;]")
  end)
end

--
--Helper Functions
--
local update_craft_table = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_stack("craftpreview", 1, minetest.get_craft_result({method = "normal", items = inv:get_list("craft"), width = 3}).item)
end

local CRAFTING_FORMSPEC = "size[9,9]"..
"list[current_player;main;0,5;8,4;]"..
"list[current_name;craft;2,1;3,3;]"..
"image[5,2;1,1;workbench_craftarrow.png]"..
"list[current_name;craftpreview;6,2;1,1;]"

--Node Registry

for _, tree in pairs(realtest.registered_trees) do
	minetest.register_node("workbench:work_bench_"..tree.name:remove_modname_prefix(), {
		description = tree.description .. " Workbench",
		tiles = {"trees_"..tree.name:remove_modname_prefix().."_trunk_top.png^workbench_top.png", 
		         "trees_"..tree.name:remove_modname_prefix().."_trunk_top.png", 
		         "trees_"..tree.name:remove_modname_prefix().."_trunk.png^workbench_side.png"},
		groups = {oddly_breakable_by_hand=3, dig_immediate=2},
		sounds = default.node_sound_wood_defaults(),
		paramtype = "light",
	on_construct = function(pos, node)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size("craft", 9)
		inv:set_width("craft", 3)
		inv:set_size("craftresult", 1)
		inv:set_size("craftpreview", 1)
		meta:set_string("formspec", CRAFTING_FORMSPEC)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		if inv:is_empty("craft") then
			return true
		end
		return false
	end,
	on_metadata_inventory_take = update_craft_table,
	on_metadata_inventory_move = update_craft_table,
	on_metadata_inventory_put = update_craft_table,
	})
	minetest.register_craft({
		output = "workbench:work_bench_"..tree.name:remove_modname_prefix(),
		recipe = {
			{tree.name.."_log", tree.name.."_log"},
			{tree.name.."_log", tree.name.."_log"}
		}
	})
end
