local function toBits(num,bits)
    -- returns a table of bits, most significant first.
    bits = bits or math.max(1, select(2, math.frexp(num)))
    local t = {} -- will contain the bits
    for b = bits, 1, -1 do
        t[b] = math.fmod(num, 2)
        num = math.floor((num - t[b]) / 2)
    end
    local o = ""
    for _,v in pairs(t) do
        o = o .. tostring(v)
    end
    return o
end

local format = [[
animations {
  id: "%s_dot"
  start_tile: %d
  end_tile: %d
  playback: PLAYBACK_ONCE_FORWARD
  fps: 30
  flip_horizontal: 0
  flip_vertical: 0
}
]]

for i=0,15 do
    print(string.format(format, toBits(i, 4), 33+i, 33+i))
end
