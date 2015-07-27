joiner_table = {}
realtest.registered_joiner_table_recipes = {}

function realtest.register_joiner_table_recipe(RecipeDef)
	local recipe = {
		item1 = RecipeDef.item1 or "",
		item2 = RecipeDef.item2 or "",
		rmitem1 = RecipeDef.rmitem1,
		rmitem2 = RecipeDef.rmitem2,
		output = RecipeDef.output or "",
		instrument = RecipeDef.instrument or "saw",
	}
	if recipe.rmitem1 == nil then
		recipe.rmitem1 = true
	end
	if recipe.rmitem2 == nil then
		recipe.rmitem2 = true
	end
	if recipe.output ~= "" and recipe.item1 ~= "" then
		table.insert(realtest.registered_joiner_table_recipes, recipe)
	end
end

for _, tree in pairs(realtest.registered_trees_list) do
	realtest.register_joiner_table_recipe({
		item1 = tree.."_log",
		output = tree.."_plank 4"
	})
	realtest.register_joiner_table_recipe({
		item1 = tree.."_plank",
		output = tree.."_stick 4"
	})
end

for _, tree in pairs(realtest.registered_trees) do
	local planks = tree.textures.planks
	minetest.register_node("joiner_table:joiner_table_"..tree.name:remove_modname_prefix(), {
		description = tree.description .. " Joiner Table",
		tiles = {planks.."^joiner_table_top.png", planks, planks.."^joiner_table_side.png",
				planks.."^joiner_table_side2.png", planks.."^joiner_table_side3.png", planks.."^joiner_table_face.png"},
		groups = {oddly_breakable_by_hand=3, dig_immediate=2},
		sounds = default.node_sound_wood_defaults(),
		paramtype = "light",
		paramtype2 = "facedir",
		can_dig = function(pos,player)
			local meta = minetest.get_meta(pos);
			local inv = meta:get_inventory()
			return inv:is_empty("src1") and inv:is_empty("src2") and inv:is_empty("instruments") and inv:is_empty("output")
		end,
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", "size[8,8]"..
					-- add a link to the joiner table's craft guide
					"button[2.8,2.25;1,0.5;guide;Guide]"..
					"button_exit[6.3,2.25;1,0.5;quit;Exit]"..
					"button[0.5,0.25;1.35,1;buttonCraft;Craft]"..
					"button[1.6,0.25;0.9,1;buttonCraft10;x10]"..
					"label[3.9,0.3;Input 1:]"..
					"list[current_name;src1;3.9,0.75;1,1;]"..
					"image[4.69,0.72;0.54,1.5;anvil_arrow.png]"..
					"label[5.1,0.3;Input 2:]"..
					"list[current_name;src2;5.1,0.75;1,1;]"..
					"label[0.5,1.1;Instruments:]"..
					"list[current_name;instruments;0.5,1.5;2,2;]"..
					"label[4.5,2.85;Output]"..
					"list[current_name;output;4.5,2;1,1;]"..
					"list[current_player;main;0,4;8,4;]")
			meta:set_string("infotext", "Joiner Table")
			local inv = meta:get_inventory()
			inv:set_size("src1", 1)
			inv:set_size("src2", 1)
			inv:set_size("instruments", 4)
			inv:set_size("output", 1)
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			if( fields and fields.guide and sender ) then
				realtest.show_craft_guide_joiner_table( sender, "realtest:craft_guide_joiner_table", fields);
				return;
			end

			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
	
			local src1, src2 = inv:get_stack("src1", 1), inv:get_stack("src2", 1)
			local output = inv:get_stack("output", 1)
			
			local find_instrument = function(instrument)
				for i = 1, 4 do
					local istack = inv:get_stack("instruments", i)
					if minetest.get_node_group(istack:get_name(), instrument) == 1 then
						return i
					end
				end
				return nil
			end
			
			local craft = function()
				for _, recipe in ipairs(realtest.registered_joiner_table_recipes) do
					local instr = find_instrument(recipe.instrument)
					local instr_stack = nil
					if instr then
						instr_stack = inv:get_stack("instruments", instr)
					end
					if instr_stack and recipe.item1 == src1:get_name() and recipe.item2 == src2:get_name() then
						if inv:room_for_item("output", recipe.output) then
							if recipe.rmitem1 then
								src1:take_item()
								inv:set_stack("src1", 1, src1)
							end
							if recipe.item2 ~= "" and recipe.rmitem2 then
								src2:take_item()
								inv:set_stack("src2", 1, src2)
							end
							output:add_item(recipe.output)
							inv:set_stack("output", 1, output)
							instr_stack:add_wear(65535/minetest.get_item_group(instr_stack:get_name(), "durability")/4)
							inv:set_stack("instruments", instr, instr_stack)
						end
						return
					end
				end
			end
			
			if fields["buttonCraft"] then
				craft()
			elseif fields["buttonCraft10"] then
				for i = 0, 9 do
					craft()
				end
			end
		end,
	})
	minetest.register_craft({
		output = "joiner_table:joiner_table_"..tree.name:remove_modname_prefix(),
		recipe = {
			{tree.name.."_planks", tree.name.."_planks"},
			{tree.name.."_planks", tree.name.."_planks"}
		}
	})
end

realtest.show_craft_guide_joiner_table = function( player, formname, fields)
	if( formname ~= "realtest:craft_guide_joiner_table" or not( player ) or fields.quit) then
		return;
	end

	-- select the plan that is to be shown
	local nr = 1;
	for i, v in ipairs(realtest.registered_joiner_table_recipes ) do
		if( v and v.output and fields[ v.output ]) then
			nr = i;
		end
	end
	local plan = realtest.registered_joiner_table_recipes[ nr ];
	-- abort if no plan can be found
	if( not( plan )) then
		return;
	end

	local stack = ItemStack( plan.output );
	local def = stack:get_definition();
	local name = "";
	if( def ) then
		name = def.description;
	end
	if( not( name )) then
		name = plan.output;
	end
		

	local formspec =
		"size[8,9]"..
		"label[0,0;Create "..tostring(stack:get_count()).."x "..name.." this way:]"..
		-- extra exit button for those tablet users
		"button_exit[6.3,2.25;1,0.5;quit;Exit]"..
		-- labels that describe the general usage of a slot
		"label[3.9,0.3;Input 1:]"..
		"label[5.1,0.3;Input 2:]"..
		"label[0.5,1.1;Instruments:]"..
		"label[4.5,2.85;Output]"..
		-- the buttons serve only decorative purposes here
		"button[0.5,0.25;1.35,1;nothing;Craft]"..
		"button[1.6,0.25;0.9,1;nothing;x10]"..
		"image[4.69,0.72;0.54,1.5;anvil_arrow.png]"..
		-- background for the inventory slots
		"box[3.9,0.75;0.8,0.9;#BBBBBB]"..
		"box[5.1,0.75;0.8,0.9;#BBBBBB]"..
		"box[4.5,1.98;0.8,0.9;#BBBBBB]"..
		"item_image[4.5,2;1,1;"..plan.output.."]"..
		-- the 4 simulated slots for the instruments
		"box[0.5,1.5;0.8,0.9;#BBBBBB]"..
		"box[0.5,2.5;0.8,0.9;#BBBBBB]"..
		"box[1.5,1.5;0.8,0.9;#BBBBBB]"..
		"box[1.5,2.5;0.8,0.9;#BBBBBB]"..
		-- some receipes output more of the same item than just one
		"label[4.0,2.5;"..tostring(stack:get_count()).."x]"..
		"label[0,3.5;Select receipe to show:]";

	-- show the indigrents
	if( plan.item1 and plan.item1 ~= "" and minetest.registered_items[ plan.item1 ]) then
		formspec = formspec.."item_image[3.9,0.75;1,1;"..plan.item1.."]";
	end
	-- the second slot usually takes a plan
	if( plan.item2 and plan.item2 ~= "" and minetest.registered_items[ plan.item2 ]) then
		formspec = formspec.."item_image[5.1,0.75;1,1;"..plan.item2.."]";
	end
	-- show the instrument needed
	if( plan.instrument and plan.instrument ~= "" and minetest.registered_items[ "instruments:"..plan.instrument.."_copper"  ]) then
		formspec = formspec.."item_image[1.5,1.5;1,1;instruments:"..plan.instrument.."_copper]";
	-- show error message for unkown tools
	elseif( plan.instrument and plan.instrument ~= "" ) then
		formspec = formspec.."label[0.5,2.5;ERROR]";
	end

	-- show a list of all receipes to select from
	for i, v in ipairs(realtest.registered_joiner_table_recipes) do
		formspec = formspec..
			"item_image_button["..tostring((i-1)%8)..","..
					      tostring(4+math.floor((i-1)/8))..";1,1;"..
					      v.output..";"..v.output..";"..
					      minetest.formspec_escape(v.output).."]";
	end

	minetest.show_formspec( player:get_player_name(), "realtest:craft_guide_joiner_table", formspec );
end

-- make sure we receive player input; needed for showing formspecs directly
minetest.register_on_player_receive_fields( realtest.show_craft_guide_joiner_table );
