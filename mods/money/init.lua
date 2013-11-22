dofile(minetest.get_modpath("money").."/shop.lua")

minetest.register_craftitem("money:coin",{
	description = "Coin(s)",
	tiles = {"coin.png"},
	inventory_image = "coin.png",
	wield_image = "coin.png",
})
