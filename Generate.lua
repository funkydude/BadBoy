
local _, t = ...

t.gen = function(...)
	local total = {}
	for i = 1, select("#", ...) do
		local tbl = {}
		local pos = 0
		local str = ""
		local entry = select(i, ...)
		for i = 1, select("#", strsplit("^", entry)) do
			local db = select(i, strsplit("^", entry))
			for j = 1, select("#", strsplit(",", db)) do
				local text = select(j, strsplit(",", db))
				local n = tonumber(text)
				if j == 1 then
					if pos > 0 then
						tbl[pos] = str
						str = ""
					end
					pos = pos + 1
				end
				str = str .. string.char(n)
			end
		end
		tbl[pos] = str
		total[i] = tbl
	end
	t.gen = nil
	return total[1], total[2], total[3], total[4], total[5], total[6], total[7], total[8], total[9]
end
