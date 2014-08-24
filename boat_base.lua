require "util"

BOAT_DECEL = 0.98
BOAT_ACCEL = 0.05
BOAT_TURN = 0.9
BOAT_TURN_THRESHOLD = 1.5
BOAT_MAX_VEL = 12
BOAT_MIN_TARGET_RANGE = 300
BOAT_MAX_TARGET_RANGE = 2000

function addBoat(list)
	list = {next = list,
					t = "Boat",
					x = math.random(-4000, 4000),
					y = math.random(-4000, 4000),
					r = math.random() * math.pi * 0.5 - math.pi * 0.25,
					s = 1,
					img = boat_base,
					layer = 1,
					shadow = true,
					effect = 0,
					order = 0,
					vx = 0,
					vy = 0,
					child = nil,
					target = nil,
					target_timer = ticks,
					controller =
						function(self, dt) 
							
							if self.target_timer < ticks or self.target == nil then
								if self.target ~= nil then
									self.target.effect = 0
								end
								
								self.target = get_random_nearby_target(self)
								
								self.target_timer = ticks + math.random(5, 20)
							end
							
							-- Accelerate toward target
							if self.target ~= nil then
								self.target.effect = 2
								
								d = sprite_dist(self, self.target)
								dir = -sprite_angle(self, self.target) + val_clamp((1200 - d) / 1200, -math.pi / 2, math.pi / 2)
								
								self.vx = self.vx - BOAT_ACCEL * math.cos(dir)
								self.vy = self.vy + BOAT_ACCEL * math.sin(dir)
								self.effect = 1
							else
								self.effect = 2
							end
							
							
							-- Update position based on velocity
							self.x = self.x + self.vx
							self.y = self.y + self.vy
							
							-- Update rotation of raft sprite if moving
							if dist(0, 0, self.vx, self.vy) > BOAT_TURN_THRESHOLD then
								newdir = math.atan2(self.vy, self.vx)
								self.r = angle_avg(self.r, newdir, BOAT_TURN)	
								
							end
							
							self.vx = self.vx * BOAT_DECEL
							self.vy = self.vy * BOAT_DECEL
							
							-- Decelerate raft
							while dist(0, 0, self.vx, self.vy) > BOAT_MAX_VEL do
								self.vx = self.vx * BOAT_DECEL
								self.vy = self.vy * BOAT_DECEL
							end
							
							
						end}
	return list
end