function addMine(list, x, y)
	list = {next = list,
					t = "Mine",
					x = x or math.random(-4000, 4000),
					y = y or math.random(-4000, 4000),
					r = 0,
					s = 1,
					img = mine,
					layer = 1,
					shadow = true,
					effect = 0,
					order = 1,
					cleanup = false,
					controller = nil}
	return list
end