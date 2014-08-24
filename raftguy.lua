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
								
								if self.food <= 0 and self.state ~= "Dead" then
									self.img = raftguy[1]
									self.state = "Dead"
									
									--love.audio.rewind(wav_yarr)
									love.audio.play(wav_yarr)
								end
								
								if self.state == "Sleep" then
									self.img = raftguy[2]
									self.food = val_clamp(self.food - dt * FOOD_LOSS_RATE / 3, 0, 100)
								elseif self.state == "Active" then
									self.img = raftguy[0]
									self.food = val_clamp(self.food - dt * FOOD_LOSS_RATE, 0, 100)
								elseif self.state == "Dead" then
									self.img = raftguy[1]
									self.food = 0
								end
								
								
							end}
	parent.child = list
	return list
end