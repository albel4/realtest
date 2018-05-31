--This allows trees act *almost* like falling nodes, useful for big trees!

local falling_trees = minetest.settings:get_bool("falling_trees")

if not falling_trees then
	if minetest.is_singleplayer() then
		falling_trees = false
	else
		falling_trees = true
	end
end

if falling_trees == true then
	function realtest.dig_tree(pos, node, name, digger, height, radius, drop)
		minetest.node_dig(pos, node, digger)

		if minetest.is_protected(pos, digger:get_player_name()) then
			return
		end

		local base_y = pos.y
		for i = 1, (height + 5) do
			pos.y = base_y + i
			local node = minetest.get_node(pos)
			if node.name ~= name or i == (height + 5) then
      -- if node.name ~= name or node.name ~= name.."_top" or i == (height + 5) then
				minetest.remove_node({x = pos.x, y = pos.y-1, z = pos.z})
				for k = -radius, radius do
				for l = -radius, radius do
				for j = 0, 1 do
					local tree_bellow = minetest.get_node({x = pos.x+k, y = pos.y-1, z = pos.z+l})
					if tree_bellow.name ~= name then
						local pos1 = {x = pos.x+k, y = pos.y+j, z = pos.z+l}
						if minetest.get_node(pos1).name == name then
							minetest.spawn_item(pos1, drop)
							minetest.remove_node(pos1)
						end
					end
				end
				end
				end
				return
			elseif node.name == name then
				minetest.set_node({x = pos.x, y = pos.y-1, z = pos.z}, {name = name})
			end
		end
	end
else
	function realtest.dig_tree(pos, node, name, digger, height, radius, drop)
		minetest.node_dig(pos, node, digger)
		return
	end
end
