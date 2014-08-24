require "util"
require "bullet"

BOAT_DECEL = 0.98
BOAT_ACCEL = 0.05
BOAT_TURN = 0.9
BOAT_TURN_THRESHOLD = 1.5
BOAT_MAX_VEL = 8
BOAT_MIN_TARGET_RANGE = 300
BOAT_MAX_TARGET_RANGE = 4000
BOAT_FIRE_DELAY = 2

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
					cleanup = false,
					controller =
						function(self, dt) 
							
							if self.target_timer < ticks or self.target == nil or (self.target ~= nil and self.target.state == "Dead") then
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
								if  d < 800 then
									dir = -sprite_angle(self, self.target) + val_clamp((400 - d) / 400, -math.pi / 2, math.pi / 2)
								else
									dir = -sprite_angle(self, self.target)
								end
								
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
	return addTurret(list, list)
end

function addTurret(list, parent)
	list = {next = list,
						t = "Turret",
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
								
								if self.fire_timer < ticks then
									sprites = addBullet(sprites, self, "Enemy")							
									
									self.fire_timer = ticks + BOAT_FIRE_DELAY
								end
								
								if self.parent.target ~= nil then
									self.r = angle_avg(self.r, sprite_angle(self.parent.target, self.parent), 0.9)
								end
								
							end}
	parent.child = list
	return list
end