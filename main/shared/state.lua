local M = {}

M.map_size = 100
M.map = {}

local function new_cell()
	return {d = nil}
end

M.connect = function(self, tilemap_url, tile_type, x, y)
	local tile_id = 193
	if self.state.map[x][y].d ~= tile_type then
		return
	end
	
	if self.state.map[x+1][y].d == tile_type then
		tile_id = tile_id + 1
	end
	if self.state.map[x][y-1].d == tile_type then
		tile_id = tile_id + 2
	end
	if self.state.map[x-1][y].d == tile_type then
		tile_id = tile_id + 4
	end
	if self.state.map[x][y+1].d == tile_type then
		tile_id = tile_id + 8
	end
	tilemap.set_tile(tilemap_url, "layer1", x, y, tile_id)
end

M.gen_block_thingy = function(self, t, x, y, gen)
	if gen <= 0 then
		return
	end
	--local blocks = {{x, y}}
	table.insert(t, {x, y})
	local directions = {
		{ 1,  0}, -- left
		{ 0, -1}, -- down
		{-1,  0}, -- right
		{ 0,  1}  -- up
	}

	--if math.random(1,100) > 50 then
	--	return
	--end

	for	i=1,math.random(1,gen) do
		local direction = directions[math.random(1, #directions)]
		local nx = x + direction[1]
		local ny = y + direction[2]
		if nx <= -M.map_size+2 or
			nx >= M.map_size-2 or
			ny <= -M.map_size+2 or
			ny >= M.map_size-2 then
				return
		end
		self:gen_block_thingy(t, nx, ny, gen-1)

		-- double take?
		if math.random(1,100) > 25 then
			local nx = nx + direction[1]
			local ny = ny + direction[2]
			self:gen_block_thingy(t, nx, ny, gen-1)
		end
	end

	--return blocks	
end

M.BLOCKS = {}
M.BLOCKS.HEAD = 1
M.BLOCKS.TAIL = 2
M.BLOCKS.WALL = 3
M.BLOCKS.READY = 4
M.BLOCKS.EATABLE = 5

M.new_map = function(self)
	local padding = 10
	local map_size = self.map_size + padding
	local map = {}
	for x = -map_size, map_size do
		map[x] = {}
		for y = -map_size, map_size do
			map[x][y] = new_cell()
		end
	end

	self.map = map
end

return M