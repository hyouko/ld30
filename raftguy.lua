require "util"

function addRaftguy(list, parent)
	list = {next = list,
						t = "Raftguy",
						x = parent.x,
						y = parent.y - 16,
						r = 0,
						s = 0.8,
						img = raftguy[0],
						layer = 2,
						shadow = true,
						effect = 0,
						order = i,
						parent = parent,
						controller =
							function(self, dt)
								self.x = self.parent.x
								self.y = self.parent.y - 16
							end}
	return list
end