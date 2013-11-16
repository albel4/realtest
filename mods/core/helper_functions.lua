function table:contains(v)
	for _, i in ipairs(self) do
		if i == v then
			return true
		end
	end
	return false
end

function table:get_index(value)
	for i, v in ipairs(self) do
		if v == value then
			return i
		end
	end
end

function copy_table(t)
    local u = { }
    for k, v in pairs(t) do
        u[k] = v
    end
    return setmetatable(u, getmetatable(t))
end

function mod_pos(p, dx, dy, dz)
    return { x = p.x + dx, y = p.y + dy, z = p.z + dz }
end

function hacky_swap_node(pos,name)
	local node = minetest.get_node(pos)
	local meta = minetest.get_meta(pos)
	local meta0 = meta:to_table()
	if node.name == name then
		return
	end
	node.name = name
	local meta0 = meta:to_table()
	minetest.set_node(pos,node)
	meta = minetest.get_meta(pos)
	meta:from_table(meta0)
end

function string:capitalize()
	return self:sub(1,1):upper()..self:sub(2):lower()
end

function string:remove_modname_prefix()
	for i = 1,2 do
		local i = self:find(":")
		if i then
			self = self:sub(i+1)
		end
	end
	return self
end

function string:get_modname_prefix()
	local i = self:find(":")
	if i == 1 then
		self = self:sub(2, -1)
	end
	i = self:find(":")
	if i then
		return self:sub(1, i-1)
	end
	return self
end

function merge(lhs, rhs)
	local merged_table = {}
	for _, v in ipairs(lhs) do
		table.insert(merged_table, v)
	end
	for _, v in ipairs(rhs) do
		table.insert(merged_table, v)
	end
	return merged_table
end

function rshift(x, by)
  return math.floor(x / 2 ^ by)
end

--Papyrus Growth

minetest.register_abm({
	nodenames = {"default:papyrus"},
	neighbors = {"default:dirt", "default:dirt_with_grass"},
	interval = 100,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y-1
		local name = minetest.get_node(pos).name
		if name == "default:dirt" or name == "default:dirt_with_grass" then
			if minetest.find_node_near(pos, 3, {"group:water"}) == nil then
				return
			end
			pos.y = pos.y+1
			local height = 0
			while minetest.get_node(pos).name == "default:papyrus" and height < 4 do
				height = height+1
				pos.y = pos.y+1
			end
			if height < 4 then
				if minetest.get_node(pos).name == "air" then
					minetest.set_node(pos, {name="default:papyrus"})
				end
			end
		end
	end,
})

--Cactus Growth

minetest.register_abm({
	nodenames = {"default:cactus"},
	neighbors = {"default:sand", "default:desert_sand"},
	interval = 100,
	chance = 20,
	action = function(pos, node)
		pos.y = pos.y-1
		local name = minetest.get_node(pos).name
		if name == "default:sand" or name == "default:desert_sand" then
			pos.y = pos.y+1
			local height = 0
			while minetest.get_node(pos).name == "default:cactus" and height < 4 do
				height = height+1
				pos.y = pos.y+1
			end
			if height < 4 then
				if minetest.get_node(pos).name == "air" then
					minetest.set_node(pos, {name="default:cactus"})
				end
			end
		end
	end,
})

