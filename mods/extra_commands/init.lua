--
--Kill/Heal Yourself (requires server priv for heal)
--

minetest.register_chatcommand("suicide", {
	description = "Commit Suicide",
	privs = {},
	func = function(name, param, player)
		minetest.chat_send_player(name, "Suiciding...")
		minetest.get_player_by_name(name):set_hp(0);
	end,
})

minetest.register_chatcommand("heal", {
	description = "Completely Heal",
	privs = {server=true},
	func = function(name, param, player)
		minetest.chat_send_player(name, "Healing...")
		minetest.get_player_by_name(name):set_hp(20);
	end,
})
