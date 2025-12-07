local file = io.open("input.txt", "r")
if file == nil then
	print("File not found")
	return
end
local content = file:read("*all")
file:close()

local sIdx = 0

local grid = {}
for line in content:gmatch("[^\r\n]+") do
	local t = {}
	for i = 1, #line do
		t[i] = line:sub(i, i)
		if t[i] == "S" then
			sIdx = i
		end
	end
	table.insert(grid, t)
end

local usedSpaces = {}

local function run1(x, y)
	if usedSpaces[x .. "-" .. y] then
		return 0
	end
	usedSpaces[x .. "-" .. y] = true
	if y == #grid then
		return 0
	elseif grid[y][x] == "^" then
		return run1(x - 1, y) + run1(x + 1, y) + 1
	else
		return run1(x, y + 1)
	end
end

local result1 = run1(sIdx, 1)
print("Part 1 answer: " .. result1)

local cache = {}

local function run2(x, y)
	if cache[x .. "-" .. y] then
		return cache[x .. "-" .. y]
	end
	if y == #grid then
		return 0
	elseif grid[y][x] == "^" then
		local result = run2(x - 1, y) + run2(x + 1, y) + 1
		cache[x .. "-" .. y] = result
		return result
	else
		local result = run2(x, y + 1)
		cache[x .. "-" .. y] = result
		return result
	end
end

local result2 = run2(sIdx, 1) + 1
print("Part 2 answer: " .. result2)
