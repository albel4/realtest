local SL = rawget(_G, "intllib") and intllib.Getter() or function(s) return s end

dofile(minetest.get_modpath(minetest.get_current_modname()).."/zcg.lua")
--dofile(minetest.get_modpath(minetest.get_current_modname()).."/cooking.lua")
--dofile(minetest.get_modpath(minetest.get_current_modname()).."/forbidden.lua")
--dofile(minetest.get_modpath(minetest.get_current_modname()).."/protection.lua")
--dofile(minetest.get_modpath(minetest.get_current_modname()).."/potions.lua")
--dofile(minetest.get_modpath(minetest.get_current_modname()).."/brewing.lua")
--dofile(minetest.get_modpath(minetest.get_current_modname()).."/master.lua")

--Inventory Plus
inventory_plus = {}

inventory_plus.set_inventory_formspec = function(player, formspec)
	minetest.show_formspec(player:get_player_name(), "custom", formspec)
end

minetest.register_on_player_receive_fields(function(player,formname,fields)
	if fields.main then
		local name = player:get_player_name()
		local formspec_armor = armor:get_armor_formspec(name)
		if formspec_armor ~= nil then
			minetest.show_formspec(player:get_player_name(), "armor", formspec_armor)
		end
	end
end)

minetest.register_craft({
	output = 'craftsbooks:crafts_book',
	recipe = {
		{'group:stick', 'group:stick', 'group:stick'},
		{'group:stick', 'default:book', 'group:stick'},
		{'group:stick', 'group:stick', 'group:stick'},
	}
})

-- minetest.register_craft({
-- 	output = 'craftsbooks:cooking_book',
-- 	recipe = {
-- 		{'default:coal_lump', 'default:coal_lump', 'default:coal_lump'},
-- 		{'default:coal_lump', 'default:book', 'default:coal_lump'},
-- 		{'default:coal_lump', 'default:coal_lump', 'default:coal_lump'},
-- 	}
-- })
--
-- minetest.register_craft({
-- 	output = 'craftsbooks:protection_book',
-- 	recipe = {
-- 		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
-- 		{'default:steel_ingot', 'craftsbooks:crafts_book', 'default:steel_ingot'},
-- 		{'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
-- 	}
-- })
--
-- minetest.register_craft({
-- 	output = 'craftsbooks:brewing_book',
-- 	recipe = {
-- 		{'lottpotion:brewer', 'craftsbooks:cooking_book'},
-- 	}
-- })
--
-- minetest.register_craft({
-- 	output = 'craftsbooks:potions_book',
-- 	recipe = {
-- 		{'lottpotion:potion_brewer', 'craftsbooks:cooking_book'},
-- 	}
-- })
--
-- minetest.register_craft({
-- 	output = 'craftsbooks:forbidden_crafts_book',
-- 	recipe = {
-- 		{'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
-- 		{'default:gold_ingot', 'craftsbooks:protection_book', 'default:gold_ingot'},
-- 		{'default:gold_ingot', 'default:gold_ingot', 'default:gold_ingot'},
-- 	}
-- })
--
-- minetest.register_craft({
-- 	output = 'craftsbooks:master_book',
-- 	recipe = {
-- 		{'craftsbooks:cooking_book', 'craftsbooks:potions_book', 'lottores:tilkal_ingot'},
-- 		{'craftsbooks:protection_book', 'craftsbooks:forbidden_crafts_book', 'lottores:mithril_ingot'},
-- 		{'craftsbooks:crafts_book', 'craftsbooks:brewing_book', 'lottores:tilkal_ingot'},
-- 	}
-- })

if minetest.setting_getbool("msg_loading_mods") then minetest.log("action", minetest.get_current_modname().." mod LOADED") end
