scribing_table = {}

realtest.registered_instrument_plans = {}
function realtest.register_instrument_plan(name, PlanDef)
	if PlanDef.bitmap then
		local plan = {
			name = name,
			description = PlanDef.description or "Plan",
			bitmap = PlanDef.bitmap,
			inventory_image = PlanDef.inventory_image or "scribing_table_plan.png",
			paper = PlanDef.paper or "default:paper"
		}
		minetest.register_craftitem(name, {
			description = plan.description,
			inventory_image = plan.inventory_image,
		})
		table.insert(realtest.registered_instrument_plans, plan)
	end
end

realtest.register_instrument_plan("scribing_table:plan_axe", {
	description = "Axe Plan",
	inventory_image = "scribing_table_plan.png^(instruments_axe_copper.png^[transformR90)",
	bitmap = {0,1,0,0,0,
		  1,1,1,1,0,
		  1,1,1,1,1,
		  1,1,1,1,0,
		  0,1,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_hammer", {
	description = "Hammer Plan",
	inventory_image = "scribing_table_plan.png^(instruments_hammer_copper.png^[transformR90)",
	bitmap = {1,1,1,1,1,
		  1,1,1,1,1,
		  1,1,1,1,1,
		  0,0,1,0,0,
		  0,0,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_pick", {
	description = "Pick Plan",
	inventory_image = "scribing_table_plan.png^instruments_pick_copper.png",
	bitmap = {0,1,1,1,0,
		  1,0,0,0,1,
		  0,0,0,0,0,
		  0,0,0,0,0,
		  0,0,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_shovel", {
	description = "Shovel Plan",
	inventory_image = "scribing_table_plan.png^(instruments_shovel_copper.png^[transformR90)",
	bitmap = {0,1,1,1,0,
		  0,1,1,1,0,
		  0,1,1,1,0,
		  0,1,1,1,0,
		  0,0,1,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_spear", {
	description = "Spear Plan",
	inventory_image = "scribing_table_plan.png^instruments_spear_copper.png",
	bitmap = {1,1,0,0,0,
		  1,1,1,0,0,
		  0,1,0,0,0,
		  0,0,0,0,0,
		  0,0,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_sword", {
	description = "Sword Plan",
	inventory_image = "scribing_table_plan.png^(instruments_sword_copper.png^[transformR90)",
	bitmap = {0,0,0,1,1,
		  0,0,1,1,1,
		  0,1,1,1,0,
		  0,1,1,0,0,
		  1,0,0,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_bucket", {
	description = "Bucket Plan",
	inventory_image = "instruments_bucket_copper.png^scribing_table_plan.png",
	bitmap = {1,0,0,0,1,
		  1,0,0,0,1,
		  1,0,0,0,1,
		  1,0,0,0,1,
		  0,1,1,1,0,}
})

realtest.register_instrument_plan("scribing_table:plan_chisel", {
	description = "Chisel Plan",
	inventory_image = "scribing_table_plan.png^instruments_chisel_copper.png",
	bitmap = {0,0,1,0,0,
		  0,0,1,0,0,
		  0,0,1,0,0,
		  0,0,1,0,0,
		  0,0,1,0,0,}
})

realtest.register_instrument_plan("scribing_table:plan_lock", {
	description = "Lock Plan",
	inventory_image = "scribing_table_plan.png^metals_copper_lock.png",
	bitmap = {0,1,1,1,0,
		  0,1,0,1,0,
		  0,1,1,1,0,
		  0,1,1,1,0,
		  0,1,1,1,0,}
})

realtest.register_instrument_plan("scribing_table:plan_saw", {
	description = "Saw Plan",
	inventory_image = "scribing_table_plan.png^instruments_saw_copper.png",
	bitmap = {1,1,0,0,0,
		  1,1,1,0,0,
		  0,1,1,1,0,
		  0,1,1,1,1,
		  0,0,0,1,1,}
})

realtest.register_instrument_plan("scribing_table:stonebricks", {
	description = "Stonebricks Plan",
	inventory_image = "default_stone_bricks.png^scribing_table_plan.png",
	bitmap = {1,1,1,1,1,
		  1,0,0,0,1,
		  1,1,1,1,1,
		  1,0,1,0,1,
		  1,1,1,1,1,}
})

realtest.register_instrument_plan("scribing_table:plan_hatch", {
	description = "Hatch Plan",
	inventory_image = "hatches_copper_hatch.png^scribing_table_plan.png",
	bitmap = {1,1,1,1,1,
		  1,0,1,0,1,
		  1,1,1,1,1,
		  1,0,1,0,1,
		  1,1,1,1,1,}
})

local function check_recipe(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	for _, plan in pairs(realtest.registered_instrument_plans) do
		local paperstack, res_craft = inv:get_stack("paper", 1)
		if paperstack:get_name() == plan.paper then
			local f = true
			for j = 1,25 do
				local dye = inv:get_stack("dye", j)
				if  (minetest.registered_items[dye:get_name()].groups["dye"] == 1   and plan.bitmap[j] == 0) or
					(minetest.registered_items[dye:get_name()].groups["dye"] == nil and plan.bitmap[j] == 1) then
					f = false
					break
				end
			end
			if f then
				if inv:room_for_item("res", plan.name) then
					paperstack:take_item()
					inv:set_stack("paper", 1, paperstack)
					for i=1,25 do
						local dye = inv:get_stack("dye",i)
						dye:take_item()
						inv:set_stack("dye", i, dye)
					end
					inv:add_item("res", plan.name)
				end
				break
			end
		end
	end
end

for i, tree_name in ipairs(realtest.registered_trees_list) do
	local tree = realtest.registered_trees[tree_name]
	minetest.register_node("scribing_table:scribing_table_"..tree.name:remove_modname_prefix(), {
		description = tree.description.." Scribing Table",
		tiles = {tree.textures.planks.."^scribing_table_top.png", tree.textures.planks, tree.textures.planks.."^scribing_table_side.png"},
		drawtype = "nodebox",
		paramtype = "light",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.5,-0.5,0.5,0.3,0.5},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.5,-0.5,0.5,0.3,0.5},
			},
		},
		groups = {oddly_breakable_by_hand=3, dig_immediate=2},
		sounds = default.node_sound_wood_defaults(),
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", 
				"size[8,10]"..
				"button_exit[7.2,3.0;1,0.5;quit;Exit]"..
				"button[5.5,4.8;1,0.5;guide;Guide]"..
				"label[6.5,0.1;Paper:]"..
				"list[current_name;paper;6.5,0.5;1,1;]"..
				"label[0.5,0.1;Dyes for the scripture (color does not matter):]"..
				"list[current_name;dye;0.5,0.5;5,5;]"..
				"label[6.5,5.3;Output]"..
				"list[current_name;res;6.5,4.5;1,1;]"..
				"image[5.5,1.5;2,3.4;scribing_table_arrow.png]"..
				"list[current_player;main;0,6;8,4;]"
			)
			meta:set_string("infotext", "Scribing Table")
			local inv = meta:get_inventory()
			inv:set_size("paper", 1)
			inv:set_size("dye", 25)
			inv:set_size("res", 1)
		end,
		on_metadata_inventory_move = function(pos, from_list, from_index,to_list, to_index, count, player)
			check_recipe(pos)
		end,
		on_metadata_inventory_put = function(pos, listname, index, stack, player)
			check_recipe(pos)
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			check_recipe(pos)
		end,
		can_dig = function(pos,player)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if inv:is_empty("paper") and inv:is_empty("dye") and inv:is_empty("res") then
				return true
			end
			return false
		end,
		on_receive_fields = function(pos, formname, fields, sender)	
			if( fields and fields.guide and sender ) then
				realtest.show_craft_guide_scribing_table( sender, "realtest:craft_guide_scribing_table", fields);
			end
		end,
	})
	minetest.register_craft({
	output = "scribing_table:scribing_table_"..tree.name:remove_modname_prefix(),
	recipe = {
		{"","group:stick",""},
		{tree.name.."_plank","default:glass",tree.name.."_plank"},
		{tree.name.."_plank",tree.name.."_plank",tree.name.."_plank"},
	}
})
end


realtest.show_craft_guide_scribing_table = function( player, formname, fields)
	if( formname ~= "realtest:craft_guide_scribing_table" or not( player ) or fields.quit) then
		return;
	end

	-- select the plan that is to be shown
	local nr = 1;
	for i, v in ipairs(realtest.registered_instrument_plans) do
		if( v and v.name and fields[ v.name ]) then
			nr = i;
		end
	end
	local plan = realtest.registered_instrument_plans[ nr ];
	-- abort if no plan can be found
	if( not( plan )) then
		return;
	end

	local formspec = 
		"size[8,8]"..
		"label[0,0;Create a "..tostring(plan.description).." by placing any dye this way:]"..
		-- extra exit button for those tablet users
		"button_exit[7.2,3.0;1,0.5;quit;Exit]"..
		-- some labels as found on the main formspec
		"label[6.5,0.1;Paper:]"..
		"label[6.5,5.3;Output]"..
		-- background for the paper and plan slots
		"box[6.5,0.5;0.8,0.9;#BBBBBB]"..
		"box[6.5,4.5;0.8,0.9;#BBBBBB]"..
		"item_image[6.5,0.5;1,1;"..plan.paper.."]"..
		"item_image[6.5,4.5;1,1;"..plan.name.."]"..
		"image[5.5,1.5;2,3.4;scribing_table_arrow.png]"..
		"label[0,5.5;Select plan to show:]";

	-- show the actual receipe
	for x=1,5 do
		for y=1,5 do
			-- imitate an inventory slot
			formspec = formspec.."box["..(-0.5+x)..","..(-0.5+y)..";0.8,0.9;#BBBBBB]";
			-- show symbolic green dye where needed (green is cheapest)
			if( plan.bitmap[ x+5*(y-1)]==1 ) then
				formspec = formspec..
					"item_image["..(-0.5+x)..","..(-0.5+y)..";1,1;dye:green]";
			end
		end
	end

	-- show a list of all receipes to select from
	for i, v in ipairs(realtest.registered_instrument_plans) do
		formspec = formspec..
			"item_image_button["..tostring((i-1)%8)..","..
					      tostring(6+math.floor((i-1)/8))..";1,1;"..
					      v.name..";"..v.name..";"..
					      minetest.formspec_escape(v.description).."]";
	end

	minetest.show_formspec( player:get_player_name(), "realtest:craft_guide_scribing_table", formspec );
end

-- make sure we receive player input; needed for showing formspecs directly
minetest.register_on_player_receive_fields( realtest.show_craft_guide_scribing_table );
