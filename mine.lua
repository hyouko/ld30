function addMine(list)
	list = {next = list,
					t = "Mine",
					x = math.random(-4000, 4000),
					y = math.random(-4000, 4000),
					r = math.random() * math.pi * 0.5 - math.pi * 0.25,
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