-- simple male/female player textures mod
-- based on player_textures by PilzAdam
-- License:  WTFPL

local worldpath = minetest.get_worldpath()
local textures_config = worldpath.."/player_skins_db.txt"

if io.open(textures_config, "r") ~= nil then
	io.input(textures_config)
	skins_cfg = io.read("*all")
	print(dump(skins_cfg))
	mf_skins_table = minetest.deserialize(skins_cfg)
	io.close()
end

mf_skins_table = mf_skins_table or {}

minetest.register_on_joinplayer(
	function(player)
		local pn = player:get_player_name()
		local skin_name = "skin_"..pn

		local skin_gender = { "player_male.png" }
		print("Skin for "..pn.." was set to "..dump(mf_skins_table[skin_name]))
		if mf_skins_table[skin_name] == "f" then
			skin_gender = { "player_female.png" }
		end

		player:set_properties({
			visual = "mesh",
			visual_size = {x=1, y=1},
			textures = skin_gender
		})
	end
)

-- commands

minetest.register_chatcommand("skin", {
    params = "name gender",
    description = "Set a player's default skin to either male (m) or female (f).",
    func = function(name, param)
		if minetest.get_player_privs(name).basic_privs then
			-- this line borrowed from worldedit
			local _,_, username, gender = param:find("^([^%s]+)%s+(.+)$")

			if minetest.auth_table[username] then
				if gender ~= "f" and gender ~= "m" then gender = "m" end

				mf_skins_table["skin_"..username] = gender
				minetest.chat_send_player(name, "Set skin for "..username.." to "..gender)
			else
				minetest.chat_send_player(name, "That player does not exist.")
			end
		else
				minetest.chat_send_player(name, "You are not authorized to run that command.")
		end
    end
})

minetest.register_on_shutdown(function()
	print(dump(mf_skins_table))
	local file = io.open(textures_config, "w")
		file:write(minetest.serialize(mf_skins_table))
	io.close()
end)

