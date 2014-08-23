require "util"

RAFT_DECEL = 0.98
RAFT_TURN = 0.9
RAFT_TURN_THRESHOLD = 1.5
RAFT_MAX_VEL = 8

function addRaft(list)
	list = {next = list,
					t = "Raft",
					x = math.random(-4000, 4000),
					y = math.random(-4000, 4000),
					r = math.random() * math.pi * 0.5 - math.pi * 0.25,
					s = 1,
					img = raft[0],
					layer = 1,
					shadow = true,
					effect = 0,
					order = i,
					vx = 0,
					vy = 0,
					child = nil,
					controller =
						function(self, dt) 
							
							-- Update position based on velocity
							self.x = self.x + self.vx
							self.y = self.y + self.vy
							
							-- Update rotation of raft sprite if moving
							if dist(0, 0, self.vx, self.vy) > RAFT_TURN_THRESHOLD then
								newdir = math.atan2(self.vy, self.vx)
								self.r = angle_avg(self.r, newdir, RAFT_TURN)	
								
							end
							
							self.vx = self.vx * RAFT_DECEL
							self.vy = self.vy * RAFT_DECEL
							
							-- Decelerate raft
							while dist(0, 0, self.vx, self.vy) > RAFT_MAX_VEL do
								self.vx = self.vx * RAFT_DECEL
								self.vy = self.vy * RAFT_DECEL
							end
							
							
						end}
	return list
end