require "util"

FOOD_LOSS_RATE = 0.25
FOOD_LOSS_MOVE_RATE = 0.5

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
						food = 100,
						controller =
							function(self, dt)
								self.x = self.parent.x
								self.y = self.parent.y - 16
								
								self.food = val_clamp(self.food - dt * FOOD_LOSS_RATE, 0, 100)
								
								if self.food == 0 then
									self.img = raftguy[1]
								end
							end}
	parent.child = list
	return list
end