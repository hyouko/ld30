require "util"

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
					order = 0,
					vx = 0,
					vy = 0,
					cleanup = false,
					nearest_boat = nil,
					nearest_boat_d = 500000,
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

function addFriendlyTurret(list, parent)
	list = {next = list,
						t = "FriendlyTurret",
						state = "Sleep",
						x = parent.x,
						y = parent.y,
						r = 0,
						s = 1.0,
						img = turret,
						layer = 2,
						shadow = true,
						effect = 0,
						order = i,
						parent = parent,
						cleanup = false,
						fire_timer = ticks,
						controller =
							function(self, dt)
								self.x = self.parent.x
								self.y = self.parent.y
								
								if self.parent.nearest_boat ~= nil and self.state == "Active" then
									self.r = angle_avg(self.r, sprite_angle(self.parent.nearest_boat, self.parent), 0.8)
								end
								
								if self.fire_timer < ticks and self.state ==  "Active" then
									sprites = addBullet(sprites, self, "Friendly")							
									
									self.fire_timer = ticks + RAFT_FIRE_DELAY
								end
								
								
								
								
							end}
	parent.child = list
	return list
end
