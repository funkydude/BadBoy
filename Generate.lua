
local _, t = ...

t.gnt = function(...)
	local select, strsplit, tonumber, n, char = select, strsplit, tonumber, GetAreaMapInfo(401), string.char
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
	t.gen = nil
end
