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

message = {}

minetest.register_chatcommand("a", {
        params = "<message>",
        description = "Ask server to announce something in chat, eg: We need to shut down for maintenance.",
        privs = {server=true},
        func = function(name, param)
        message = param
		if message == "" then
			minetest.chat_send_player(name, "Message Required")
			return
		end
		if message ~= "" then
            message = string.match(param, "^([^ ]+)$")
                    minetest.chat_send_all("-!- Server Announcement -!-")
                    minetest.chat_send_all("- "..message.." -")
        end
    end
})
