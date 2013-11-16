hud = {}

--minetest.after(SAVE_INTERVAL, timer, SAVE_INTERVAL)

local function hide_builtin(player)
	 player:hud_set_flags({crosshair = true, hotbar = true, healthbar = true, wielditem = true, breathbar = true})
end


local function costum_hud(player)

 --fancy hotbar
 player:hud_set_hotbar_image("hud_hotbar.png")
 player:hud_set_hotbar_selected_image("hud_hotbar_selected.png")
end

minetest.register_on_joinplayer(function(player)
	minetest.after(0.5, function()
		hide_builtin(player)
		costum_hud(player)
	end)
end)
