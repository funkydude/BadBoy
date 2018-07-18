
local _, t = ...

t.gnt = function(u, ...)
	local select, strsplit, tonumber, n, char = select, strsplit, tonumber, C_Map.GetMapInfo(u).parentMapID, string.char
	for i = 1, select("#", ...) do
		local tbl = {}
		local pos = 0
		local str = ""
		local entry = select(i, ...)
		for l = 1, select("#", strsplit("^", entry)) do
			local db = select(l, strsplit("^", entry))
			for j = 1, select("#", strsplit(",", db)) do
				local t = select(j, strsplit(",", db))
				local rn = tonumber(t)
				rn = rn - i - n
				if j == 1 then
					if pos > 0 then
						tbl[pos] = str
						str = ""
					end
					pos = pos + 1
				end
				str = str .. char(rn)
			end
		end
		tbl[pos] = str
		t[i] = tbl
	end
	t.gnt = nil
end

local strfind = string.find
t.is = function(msg)
	local a = 0
	for i = 1, 6 do
		for j=1, #t[i] do
			if strfind(msg, t[i][j]) then
				a = i>5 and a+3 or i>4 and a-1 or i>3 and a+2 or i>2 and a+1 or a+10
			end
		end
	end
	return a > 3
end
