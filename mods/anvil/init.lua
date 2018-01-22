anvil = {}
realtest.registered_anvil_recipes = {}

function realtest.register_anvil_recipe(RecipeDef)
	local recipe = {
		type = RecipeDef.type or "forge",
		item1 = RecipeDef.item1 or "",
		item2 = RecipeDef.item2 or "",
		rmitem1 = RecipeDef.rmitem1,
		rmitem2 = RecipeDef.rmitem2,
		output = RecipeDef.output or "",
		level = RecipeDef.level or 0,
		instrument = RecipeDef.instrument or "hammer",
		material = RecipeDef.material, -- just to make the craft guide more manageable
	}
	if recipe.rmitem1 == nil then
		recipe.rmitem1 = true
	end
	if recipe.rmitem2 == nil then
		recipe.rmitem2 = true
	end
	if recipe.level < 0 then
		recipe.level = 0
	end
	if recipe.output ~= "" and recipe.item1 ~= "" and (recipe.type == "forge" or recipe.type == "weld") then
		table.insert(realtest.registered_anvil_recipes, recipe)
	end
end

--Unshaped metals, buckets, double ingots, sheets, hammers, locks and hatches
for i, metal in ipairs(metals.list) do
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_unshaped",
		output = "metals:"..metal.."_ingot",
		material = metal,
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_sheet",
		item2 = "scribing_table:plan_bucket",
		rmitem2 = false,
		output = "instruments:bucket_"..metal,
		level = metals.levels[i],
		material = metal,
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_doubleingot",
		output = "metals:"..metal.."_sheet",
		level = metals.levels[i] - 1,
		material = metal,
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_doubleingot",
		output = "metals:"..metal.."_ingot 2",
		level = metals.levels[i] - 1,
		instrument = "chisel",
		material = metal,
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_doublesheet",
		output = "metals:"..metal.."_sheet 2",
		level = metals.levels[i] - 1,
		instrument = "chisel",
		material = metal,
	})
	realtest.register_anvil_recipe({
		type = "weld",
		item1 = "metals:"..metal.."_ingot",
		item2 = "metals:"..metal.."_ingot",
		output = "metals:"..metal.."_doubleingot",
		level = metals.levels[i] - 1,
		material = metal,
	})
	realtest.register_anvil_recipe({
		type = "weld",
		item1 = "metals:"..metal.."_sheet",
		item2 = "metals:"..metal.."_sheet",
		output = "metals:"..metal.."_doublesheet",
		level = metals.levels[i] - 1,
		material = metal,
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_ingot",
		item2 = "scribing_table:plan_lock",
		rmitem2 = false,
		output = "metals:"..metal.."_lock",
		level = metals.levels[i],
		material = metal,
	})
	realtest.register_anvil_recipe({
		item1 = "metals:"..metal.."_ingot",
		item2 = "scribing_table:plan_hatch",
		rmitem2 = false,
		output = "hatches:"..metal.."_hatch_closed",
		level = metals.levels[i],
		material = metal,
	})
	-- receipe for coin production
	realtest.register_anvil_recipe({
		item1 = "metals:gold_sheet",
		output = "money:coin 15",
		level = metals.levels[i],
		instrument = "chisel",
		material = "gold",
	})
end
-- general receipes (for flux production; used for welding)
realtest.register_anvil_recipe({
	item1 = "minerals:borax",
	output = "minerals:flux 8"
})
realtest.register_anvil_recipe({
	item1 = "minerals:sylvite",
	output = "minerals:flux 4"
})
-- receipe for coin production
-- realtest.register_anvil_recipe({
-- 	item1 = "metals:gold_sheet",
-- 	output = "money:coin 15",
-- 	level = metals.levels[i],
-- 	instrument = "chisel",
-- 	material = "gold",
-- })
--Pig iron --> Wrought iron
realtest.register_anvil_recipe({
	item1 = "metals:pig_iron_ingot",
	output = "metals:wrought_iron_ingot",
	level = 2,
	material = "wrought_iron",
})
--Instruments
local anvil_instruments =
	{{"axe", "_ingot"},
	 {"pick", "_ingot"},
	 {"shovel", "_ingot"},
	 {"spear", "_ingot"},
	 {"chisel", "_ingot"},
	 {"sword", "_doubleingot"},
	 {"hammer", "_doubleingot"},
	 {"saw", "_sheet"}
	}
for _, instrument in ipairs(anvil_instruments) do
	for i, metal in ipairs(metals.list) do
		-- the proper way to do that is to check whether we have metal in instruments.metals list or not
		-- but who cares?
		local output_name = "instruments:"..instrument[1].."_"..metal.."_head"
		if minetest.registered_items[output_name] then
			realtest.register_anvil_recipe({
				item1 = "metals:"..metal..instrument[2],
				item2 = "scribing_table:plan_"..instrument[1],
				rmitem2 = false,
				output = output_name,
				level = metals.levels[i],
				material = metal,
			})
		end
	end
end

local anvils = {
	{'stone', 'Stone', 0, 61*2.3},
	{'desert_stone', 'Desert Stone', 0, 61*2.3},
	{'copper', 'Copper', 1, 411*2.3},
	{'rose_gold', 'Rose Gold', 2, 521*2.3},
	{'bismuth_bronze', 'Bismuth Bronze', 2, 581*2.3},
	{'black_bronze', 'Black Bronze', 2, 531*2.3},
	{'bronze', 'Bronze', 2, 601*2.3},
	{'wrought_iron', 'Wrought Iron', 3, 801*2.3},
	{'steel', 'Steel', 4, 1101*2.3},
	{'black_steel', 'Black Steel', 5, 1501*2.3}
}

minetest.register_craft({
	output = 'anvil:anvil_stone',
	recipe = {
		{'default:stone','default:stone','default:stone'},
		{'','default:stone',''},
		{'default:stone','default:stone','default:stone'},
	}
})

minetest.register_craft({
	output = 'anvil:anvil_desert_stone',
	recipe = {
		{'default:desert_stone','default:desert_stone','default:desert_stone'},
		{'','default:desert_stone',''},
		{'default:desert_stone','default:desert_stone','default:desert_stone'},
	}
})

for _, anvil in ipairs(anvils) do
	if anvil[1] ~= "stone" then
		minetest.register_craft({
			output = "anvil:anvil_"..anvil[1],
			recipe = {
				{"metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot"},
				{"","metals:"..anvil[1].."_doubleingot",""},
				{"metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot","metals:"..anvil[1].."_doubleingot"},
			}
		})
	end
end

for _, anvil in ipairs(anvils) do
	minetest.register_node("anvil:anvil_"..anvil[1], {
		description = anvil[2] .. " Anvil",
		tiles = {"anvil_"..anvil[1].."_top.png","anvil_"..anvil[1].."_top.png","anvil_"..anvil[1].."_side.png"},
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "facedir",
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
				{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
				{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
				{-0.35,-0.1,-0.2,0.35,0.1,0.2},
			},
		},
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5,-0.5,-0.3,0.5,-0.4,0.3},
				{-0.35,-0.4,-0.25,0.35,-0.3,0.25},
				{-0.3,-0.3,-0.15,0.3,-0.1,0.15},
				{-0.35,-0.1,-0.2,0.35,0.1,0.2},
			},
		},
		groups = {oddly_breakable_by_hand=2, falling_node=1, dig_immediate=1},
		sounds = default.node_sound_stone_defaults(),
		can_dig = function(pos,player)
			local meta = minetest.env:get_meta(pos);
			local inv = meta:get_inventory()
			if inv:is_empty("src1") and inv:is_empty("src2") and inv:is_empty("hammer")
				and inv:is_empty("output") and inv:is_empty("flux") then
				return true
			end
			return false
		end,
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_string(
				"formspec", "size[8,7]"..
				-- some (hopefully) helpful buttons
				"button[2.0,1.75;1,0.5;guide;Guide]"..
				"button_exit[5,1.75;1,0.5;quit;Exit]"..
				"label[2.9,-0.2;Input 1:]"..
				"label[4.1,-0.2;Input 2:]"..
				"label[1.0,1.1;Instrument:]"..
				"label[6.0,1.1;Flux:]"..
				"label[3.5,2.35;Output]"..
				-- the rest of the formspec
				"button[0.5,0.25;1.35,1;buttonForge;Forge]"..
				"button[1.6,0.25;0.9,1;buttonForge10;x10]"..
				"list[current_name;src1;2.9,0.25;1,1;]"..
				"image[3.69,0.22;0.54,1.5;anvil_arrow.png]"..
				"list[current_name;src2;4.1,0.25;1,1;]"..
				"button[5.5,0.25;1.35,1;buttonWeld;Weld]"..
				"button[6.6,0.25;0.9,1;buttonWeld10;x10]"..
				"list[current_name;hammer;1,1.5;1,1;]"..
				"list[current_name;output;3.5,1.5;1,1;]"..
				"list[current_name;flux;6,1.5;1,1;]"..
				"list[current_player;main;0,3;8,4;]"..
				"listring[current_name;output]"..
				"listring[current_player;main]"..
				"listring[current_name;hammer]"..
				"listring[current_player;main]"..
				"listring[current_name;src1]"..
				"listring[current_player;main]"..
				"listring[current_name;src2]"..
				"listring[current_player;main]"..
				"listring[current_name;flux]"..
				"listring[current_player;main]"
			)
			meta:set_string("infotext", anvil[2].." Anvil")
			local inv = meta:get_inventory()
			inv:set_size("src1", 1)
			inv:set_size("src2", 1)
			inv:set_size("hammer", 1)
			inv:set_size("output", 1)
			inv:set_size("flux", 1)
		end,
		on_receive_fields = function(pos, formname, fields, sender)
			if( fields and fields.guide and sender ) then
				-- anvils made from diffrent materials have diffrent capabilities
				fields.anvil_typ = anvil[1];
				realtest.show_craft_guide_anvil( sender, "realtest:craft_guide_anvil", fields);
				return;
			end
			local meta = minetest.env:get_meta(pos)
			local inv = meta:get_inventory()

			local src1, src2 = inv:get_stack("src1", 1), inv:get_stack("src2", 1)
			local instrument, flux = inv:get_stack("hammer", 1), inv:get_stack("flux", 1)
			local output = inv:get_stack("output", 1)
			local forge = function()
				for _, recipe in ipairs(realtest.registered_anvil_recipes) do
					if recipe.type == "forge" and recipe.item1 == src1:get_name() and recipe.item2 == src2:get_name() and
						anvil[3] >= recipe.level and
						minetest.get_item_group(instrument:get_name(),  recipe.instrument) == 1 and
						minetest.get_item_group(instrument:get_name(), "material_level") >= recipe.level - 1 then
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
							instrument:add_wear(65535/minetest.get_item_group(instrument:get_name(), "durability"))
							inv:set_stack("hammer", 1, instrument)
						end
						return
					end
				end
			end
			local weld = function()
				if flux:get_name() == "minerals:flux" then
					for _, recipe in ipairs(realtest.registered_anvil_recipes) do
						if recipe.type == "weld" and recipe.item1 == src1:get_name() and recipe.item2 == src2:get_name() and
							anvil[3] >= recipe.level and
							minetest.get_item_group(instrument:get_name(),  recipe.instrument) == 1 and
							minetest.get_item_group(instrument:get_name(), "material_level") >= recipe.level then
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
								flux:take_item()
								inv:set_stack("flux", 1, flux)
								instrument:add_wear(65535/minetest.get_item_group(instrument:get_name(), "durability")/2)
								inv:set_stack("hammer", 1, instrument)
							end
							return
						end
					end
				end
			end
			if fields["buttonForge"] then
				forge()
			elseif fields["buttonForge10"] then
				for i = 0, 9 do
					forge()
				end
			elseif fields["buttonWeld"] then
				weld()
			elseif fields["buttonWeld10"] then
				for i = 0, 9 do
					weld()
				end
			end
		end,
	})
end


realtest.show_craft_guide_anvil = function( player, formname, fields)
	if( formname ~= "realtest:craft_guide_anvil" or not( player ) or fields.quit) then
		return;
	end
	if( not( fields.material )) then
		if( fields.old_material ) then
			fields.material = fields.old_material;
		else
			fields.material = metals.list[1];
		end
	end

	-- select the plan that is to be shown
	local nr = 1;
	for i, v in ipairs(realtest.registered_anvil_recipes ) do
		if( v and v.output and fields[ v.output ]) then
			nr = i;
		end
	end
	local plan = realtest.registered_anvil_recipes[ nr ];
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

	local how_to = "Forge";
	if( plan.type and plan.type=="weld" ) then
		how_to = "Weld";
	end

	local formspec =
		"size[12,8]"..
		"label[1.5,-0.2;"..how_to.." "..tostring(stack:get_count()).."x "..name.." this way (click on "..how_to.."):]"..
		-- extra exit button for those tablet users
		"button_exit[5,2.25;1,0.5;quit;Exit]"..
		-- labels that describe the general usage of a slot
		"label[2.9,0.3;Input 1:]"..
		"label[4.1,0.3;Input 2:]"..
		"label[1.0,1.6;Instrument:]"..
		"label[6.0,1.6;Flux:]"..
		"label[3.5,2.85;Output]"..
		"label[8,-0.4;Select metal type to work with:]"..
		-- buttons that do nothing; they exist just so that the interface looks similar
		"button[0.5,0.75;1.35,1;nothing;Forge]"..
		"button[1.6,0.75;0.9,1;nothing;x10]"..
		"button[5.5,0.75;1.35,1;buttonWeld;Weld]"..
		"button[6.6,0.75;0.9,1;buttonWeld10;x10]"..
		"image[3.69,0.72;0.54,1.5;anvil_arrow.png]"..
		-- background for the inventory slots
		"box[2.9,0.75;0.8,0.9;#BBBBBB]"..
		"box[4.1,0.75;0.8,0.9;#BBBBBB]"..
		"box[3.5,1.99;0.8,0.9;#BBBBBB]"..
		"item_image[3.5,2.0;1,1;"..plan.output.."]"..
		-- the 4 simulated slots for the instruments
		"box[1.0,1.99;0.8,0.9;#BBBBBB]"..
		"box[6.0,1.99;0.8,0.9;#BBBBBB]"..
		-- hide the material (=selected metal) somewhere
		"field[-10,-10;0.1,0.1;old_material;"..fields.material..";"..fields.material.."]"..
		-- some receipes output more of the same item than just one
		"label[3.0,2.5;"..tostring(stack:get_count()).."x]"..
		"label[0,3.5;Select receipe to show:]";

	-- show the indigrents
	if( plan.item1 and plan.item1 ~= "" and minetest.registered_items[ plan.item1 ]) then
		local button = "item_image[2.9,0.75;1,1;"..plan.item1.."]";
		for _, v in ipairs(realtest.registered_anvil_recipes) do
			if( v.output == plan.item1 ) then
				button = "item_image_button[2.9,0.75;1,1;"..v.output..";"..v.output..";]";
			end
		end
		formspec = formspec..button;
	end
	-- the second slot usually takes a plan
	if( plan.item2 and plan.item2 ~= "" and minetest.registered_items[ plan.item2 ]) then
		local button = "item_image[4.1,0.75;1,1;"..plan.item2.."]";
		for _, v in ipairs(realtest.registered_anvil_recipes) do
			if( v.output == plan.item2 ) then
				button = "item_image_button[4.1,0.75;1,1;"..v.output..";"..v.output..";]";
			end
		end
		formspec = formspec..button;
	end

	-- show the instrument needed
	if( plan.instrument and plan.instrument ~= "" and minetest.registered_items[ "instruments:"..plan.instrument.."_copper"  ]) then
		-- find a suitable instrument that can be used to work on this
		local found = -1;
		print(dump(plan))
		for i,v in ipairs( instruments.levels ) do
			if( found<1 and plan.level <= v ) then
				found = i;
			end
		end
		local instrument_material = "copper"; -- fallback
		if( found ) then
			instrument_material = instruments.materials[ found ];
		end
		-- the instrument may need to be made out of a diffrent material
		formspec = formspec.."item_image_button[1.0,2.0;1,1;instruments:"..plan.instrument.."_"..instrument_material..";material;"..instrument_material.."]";
	-- show error message for unkown tools
	elseif( plan.instrument and plan.instrument ~= "" ) then
		formspec = formspec.."label[0.5,2.5;ERROR]";
	end
	-- welding requires flux
	if( plan.type and plan.type=="weld") then
		formspec = formspec.."item_image[6.0,2.0;1,1;minerals:flux]";
	end


	-- show a list of all receipes to select from
	local i = 1;
	for _, v in ipairs(realtest.registered_anvil_recipes) do
		if( v and not( v.material ) or v.material == fields.material) then
			formspec = formspec..
				"item_image_button["..tostring((i-1)%8)..","..
					      tostring(4+math.floor((i-1)/8))..";1,1;"..
					      v.output..";"..v.output..";]";
--					      minetest.formspec_escape(v.output).."]";
			i = i+1;
		end
	end
	-- show the metals to select from
	for i, v in ipairs( metals.list ) do
		formspec = formspec..
				"image_button["..tostring(8+(i-1)%4)..","..
					      tostring(math.floor((i-1)/4))..";1,1;"..
					      "metals_"..v.."_block.png;material;"..
					      v.."]";
	end

	-- show the anvils that can do this task
	formspec = formspec.."label[0,6.9;The following anvils are strong enough for this task ";
	if( plan.type=="weld") then
		formspec = formspec.."(welding can be done on all anvils):]";
	else
		formspec = formspec.." (at least strength "..tostring(plan.level).."):]";
	end
	for i,anvil in ipairs( anvils ) do
		if( anvil[3] >= plan.level or plan.type=="weld") then
			formspec = formspec.."item_image_button["..tostring(i-1)..",7.3;1,1;anvil:anvil_"..anvil[1]..";material;"..anvil[1].."]";
		end
	end

	minetest.show_formspec( player:get_player_name(), "realtest:craft_guide_anvil", formspec );
end

-- make sure we receive player input; needed for showing formspecs directly
minetest.register_on_player_receive_fields( realtest.show_craft_guide_anvil );
