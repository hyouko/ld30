require "util"

function addRaftguy(list, parent)
	list = {next = list,
						t = "Raftguy",
						state = "Sleep",
						x = parent.x,
						y = parent.y - 16,
						r = 0,
						s = 0.8,
						img = raftguy[2],
						layer = 2,
						shadow = true,
						effect = 0,
						order = 0,
						cleanup = false,
						parent = parent,
						food = 100,
						controller =
							function(self, dt)
								self.x = self.parent.x
								self.y = self.parent.y - 16
								
								if self.state == "Sleep" then
									self.food = val_clamp(self.food - dt * FOOD_LOSS_RATE / 3, 0, 100)
								elseif self.state == "Active" then
									self.food = val_clamp(self.food - dt * FOOD_LOSS_RATE, 0, 100)
								end
								
								if self.food == 0 then
									self.img = raftguy[1]
									state = "Dead"
								end
							end}
	parent.child = list
	return list
end