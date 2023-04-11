local function readFile(fileName)
	local f = assert(io.open(fileName, "r"))
	local content = f:read("*all")
	f:close()
	return content
end
-- local env = os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH") .. "\\.config\\wezterm\\pic\\"
local home_dir = os.getenv("HOME") .. "/.config/wezterm/pic/"
print(home_dir)

-- Random pic
-- home_dir = home_dir .. "pic_list.txt"
-- print(home_dir)
-- print(readFile(home_dir))
local file = io.open(home_dir .. "pic_list.txt", "r")
-- print(file)
local pic_list = {}
for line in file:lines() do
	table.insert(pic_list, line)
end
file:close()
local pic = home_dir .. pic_list[math.random(#pic_list)]
print(pic)
--
