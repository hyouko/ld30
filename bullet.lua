BULLET_LIFESPAN = 1.5
BULLET_VEL = 20
BULLET_DAMAGE = 10
BULLET_IMPACT = 4

function addBullet(list, parent, state)
	list = {next = list,
					t = "Bullet",
					state = state,
					x = parent.x,
					y = parent.y,
					r = 0,
					s = 1,
					img = bullet,
					layer = 3,
					shadow = true,
					effect = 0,
					order = 0,
					life_timer = ticks + BULLET_LIFESPAN,
					cleanup = false,
					vx = math.cos(parent.r) * BULLET_VEL,
					vy = math.sin(parent.r) * BULLET_VEL,
					controller =
						function(self, dt)
							self.x = self.x + self.vx
							self.y = self.y + self.vy
							
							self_cleanup = self.life_timer < ticks
								
						end
					}
	return list
end