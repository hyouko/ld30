require "util"

function addFish(list)
	list = {next = list,
					t = "fish",
					x = math.random(-4000, 4000),
					y = math.random(-4000, 4000),
					r = math.random() * math.pi * 2 - math.pi,
					s = 1,
					img = fish[0],
					layer = 0,
					shadow = false,
					effect = 0,
					order = i,
					vx = math.random() * 2 - 1,
					vy = math.random() * 2 - 1,
					controller =
						function(self, dt)
							self.x = self.x + self.vx
							self.y = self.y + self.vy
							self.r = math.atan2(self.vy, self.vx) + math.sin(ticks * 3) * 0.1 - math.pi * 0.25
						end
					}
	return list
end