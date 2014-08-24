require "util"

-- Pseudo-object definitions
require "raft"
require "raftguy"
require "fish"
require "boat_base"

require "rope"

function love.load()
	width, height = love.graphics.getDimensions()
	
	loadImages()
	
	-- Camera coords
	cam_x = 0.0
	cam_y = 0.0
	
	-- Camera velocity
	cam_vx = 0.0
	cam_vy = 0.0
	
	-- Control flags
	press_up =  false
	press_down = false
	press_left = false
	press_right = false
	
	zoom_in = false
	zoom_out = false
	
	scale_factor = 1.0
	
	-- Universal timer
	ticks = 0
	
	zoom_timer = 0
	
	-- Spawn some test raft sprites
	for i = 1, 200 do
		sprites = addRaft(sprites)
		
		
		if math.random() < 0.2 then
			sprites = addRaftguy(sprites, sprites)
		elseif math.random() < 0.1 then
			sprites = addFriendlyTurret(sprites, sprites)
		end
	end
	
	-- Spawn some test fish
	for i = 1, 500 do
		sprites = addFish(sprites)
	end
	
	-- Spawn some enemy boats
	for i = 1, 20 do
		sprites = addBoat(sprites)
	end
	
	-- Spawn our hero!
	
	sprites = addRaft(sprites)
	
	sprites.x = 50
	sprites.y = 50
	sprites = addRaftguy(sprites, sprites)
	sprites.state = "Active"
	sprites.img = raftguy[0]
	
	ropes = nil
	
	fps = 60
end


function loadImages()
	
	-- Water overlay images
	water = {}
	water[0] = love.graphics.newImage("gfx/water_01.png")
	
	raft = {}
	raft[0] = love.graphics.newImage("gfx/raft_01.png")
	
	fish = {}
	fish[0] = love.graphics.newImage("gfx/fish_01.png")
	
	raftguy = {}
	raftguy[0] = love.graphics.newImage("gfx/raftguy_01.png")
	raftguy[1] = love.graphics.newImage("gfx/raftguy_02.png")
	raftguy[2] = love.graphics.newImage("gfx/raftguy_03.png")
	
	boat_base = love.graphics.newImage("gfx/boat_base.png")
	
	turret = love.graphics.newImage("gfx/turret.png")
	bullet = love.graphics.newImage("gfx/bullet.png")
	wake = love.graphics.newImage("gfx/wake_02.png")
end

function love.draw()
	
	--t_test = love.timer.getTime()

	love.graphics.setColor(10, 100, 210)
	love.graphics.rectangle('fill', 0, 0, width, height)
	
	drawWaterLayer(30, 20, 0)
	drawWaterLayer(-10, 30, math.pi / 2)
	drawWaterLayer(15, 0, math.pi * 1.5)
	
	-- Render all ropes
	rope = ropes
	while rope do
		a_sx, a_sy = to_screenspace(rope.a.x, rope.a.y)
		b_sx, b_sy = to_screenspace(rope.b.x, rope.b.y)
		
		love.graphics.setColor(20, 20, 20)
		
		love.graphics.setLineWidth(2 * scale_factor)
		
		love.graphics.line(a_sx, a_sy, b_sx, b_sy)
		
		if rope_debug then
			a_ax, a_ay, b_ax, b_ay = get_rope_forces(rope)
			
			love.graphics.setColor(255, 0, 0)
			
			love.graphics.line(a_sx, a_sy, a_sx + a_ax * 64, a_sy + a_ay * 64)
			love.graphics.circle("fill", a_sx + a_ax * 64, a_sy + a_ay * 64, 10, 10)
			
			love.graphics.line(b_sx, b_sy, b_sx + b_ax * 64, b_sy + b_ay * 64)
			love.graphics.circle("fill", b_sx + b_ax * 64, b_sy + b_ay * 64, 10, 10)
		end
		
		rope = rope.next
	end
	
	-- Render all sprites
	sprite = sprites
	while sprite do
		
		if is_visible(sprite) then	
			sx, sy = to_screenspace(sprite.x, sprite.y)
			-- If applicable, render sprite shadows
			if sprite.shadow then
				love.graphics.setColor(20, 20, 20, 120)
				love.graphics.draw(sprite.img,
					sx,
					sy + 10 * scale_factor,
					sprite.r, sprite.s * scale_factor, sprite.s * scale_factor, 64, 64)
			end
			
			-- Apply various and sundry special effects
			if sprite.effect == 1 then
				love.graphics.setColor(math.sin(ticks) * 64 + 191, 255, math.sin(ticks) * 64 + 191)
				love.graphics.draw(sprite.img,
					sx,
					sy,
					sprite.r, sprite.s * scale_factor, sprite.s * scale_factor, 64, 64)
				
			elseif sprite.effect == 2 then
				love.graphics.setColor(255, math.sin(ticks) * 64 + 191, math.sin(ticks) * 64 + 191)
				love.graphics.draw(sprite.img,
					sx,
					sy,
					sprite.r, sprite.s * scale_factor, sprite.s * scale_factor, 64, 64)
			elseif sprite.effect == 3 then
				love.graphics.setColor(255, 255, 255, math.max((sprite.life_timer - ticks) / WAKE_LIFESPAN * 255, 0))
				love.graphics.draw(sprite.img,
					sx,
					sy,
					sprite.r, sprite.s * scale_factor, sprite.s * scale_factor, 64, 64)
			else
				love.graphics.setColor(255, 255, 255)
				love.graphics.draw(sprite.img,
					sx,
					sy,
					sprite.r, sprite.s * scale_factor, sprite.s * scale_factor, 64, 64)
			end
			
			if sprite.t == "Boat" then
				if boat_debug and sprite.target ~= nil then
					
					love.graphics.print(sprite_dist(sprite, sprite.target), sx, sy)
				end
				
			end
			
			if sprite.t == "Raftguy" then
				-- Draw food bar for the raft guy
							
				love.graphics.setColor(20, 40, 60)
				love.graphics.rectangle("fill", sx - 64 * scale_factor, sy - 64 * scale_factor, 128 * scale_factor, 16 * scale_factor)
				
				love.graphics.setColor(255 * (1 - sprite.food / 100), 255 * (sprite.food / 100), 10)
				love.graphics.rectangle("fill", sx - 62 * scale_factor, sy - 62 * scale_factor, 124 * (sprite.food / 100) * scale_factor, 12 * scale_factor)
				
				-- Show the anticipated cost of moving
				if sprite.parent == selected_sprite then
					food_cost = FOOD_LOSS_MOVE_RATE * math.min(RAFT_MAX_VEL, dist(selection_startx, selection_starty, mouse_x, mouse_y) / scale_factor / 64.0)
					
					love.graphics.setColor(255, 10, 10)
					love.graphics.rectangle("fill",
						sx - 62 * scale_factor + 124 * ((sprite.food - food_cost) / 100) * scale_factor,
						sy - 62 * scale_factor,
						124 * (food_cost / 100.0) * scale_factor,
						12 * scale_factor)
				end
							
			end
		end
				
		sprite = sprite.next
	end
	
	-- Render movement UI bits
	if selected_sprite ~= nil then
		
		love.graphics.setColor(220, 250, 255)
		sx, sy = to_screenspace(selected_sprite.x, selected_sprite.y)
		
		love.graphics.setLineWidth(3)
		love.graphics.circle("line", sx, sy, 80 * scale_factor, 40)
			
		love.graphics.line(sx, sy, mouse_x, mouse_y)
			
		dir = angle(sx, sy,  mouse_x, mouse_y)
			
		love.graphics.line(mouse_x, mouse_y, mouse_x + math.cos(dir - 0.35) * 64, mouse_y + math.sin(dir - 0.35) * 64)
		love.graphics.line(mouse_x, mouse_y, mouse_x + math.cos(dir + 0.35) * 64, mouse_y + math.sin(dir + 0.35) * 64)
	end
	
	-- Render rope targeting
	if rope_sprite ~= nil then
		love.graphics.setColor(255, 250, 220)
		sx, sy = to_screenspace(rope_sprite.x, rope_sprite.y)
		
		love.graphics.setLineWidth(3)
		love.graphics.circle("line", sx, sy, 80 * scale_factor, 40)
			
		love.graphics.line(sx, sy, mouse_x, mouse_y)
			
		dir = angle(sx, sy,  mouse_x, mouse_y)
		
		mx, my = to_worldspace(mouse_x, mouse_y)
		
		length = dist(rope_sprite.x, rope_sprite.y, mx, my)
		
		if length > ROPE_MAX_LENGTH then
			love.graphics.line(mouse_x - math.cos(dir - 0.7) * 64, mouse_y - math.sin(dir - 0.7) * 64, mouse_x + math.cos(dir - 0.7) * 64, mouse_y + math.sin(dir - 0.7) * 64)
			love.graphics.line(mouse_x - math.cos(dir + 0.7) * 64, mouse_y - math.sin(dir + 0.7) * 64, mouse_x + math.cos(dir + 0.7) * 64, mouse_y + math.sin(dir + 0.7) * 64)
		else
			love.graphics.circle("line", mouse_x, mouse_y, 24, 12)
		end
	end
	
	if debug_on then
		love.graphics.setColor(250, 250, 250)
		love.graphics.print("FPS: " .. fps, 20, 20)
		love.graphics.print("CamX: " .. math.ceil(cam_x  * 10) / 10, 20, 40)
		love.graphics.print("CamY: " .. math.ceil(cam_y  * 10) / 10, 120, 40)
		love.graphics.print("Ropes: " .. rope_count, 20, 60)
	end
	
	
	--print (love.timer.getTime() - t_test)

end

-- Draw an animating layer of water
function drawWaterLayer(xvel, yvel, r)
	
	x_offset = (xvel * ticks - cam_x) % 128
	y_offset = (yvel * ticks - cam_y) % 128
	
	for x = (x_offset - 256) * scale_factor, width + (x_offset + 256) * scale_factor, 128 * scale_factor do
		for y = (y_offset - 256) * scale_factor, height + (y_offset + 256) * scale_factor, 128 * scale_factor do
			love.graphics.draw(water[0], x, y, r, scale_factor, scale_factor)	
		end
	end
	
end

function love.update(dt)
	ticks = ticks + dt
	
	--scale_factor = math.sin(ticks) * 0.25 + 1.0
	for t = 0, math.min(4 / 60, dt), 1 / 60.0 do
		cam_x = cam_x + cam_vx / scale_factor
		cam_y = cam_y + cam_vy / scale_factor
		
		-- Identify if mouse is initiating scrolling
		mouse_x = love.mouse.getX()
		mouse_y = love.mouse.getY()
		
		-- Accelerate camera based on inputs
		if press_up or mouse_y <= height * 0.1 then
			cam_vy = cam_vy - 1
		end
		
		if press_down or mouse_y >= height * 0.9 then
			cam_vy = cam_vy + 1
		end
		
		if press_left or mouse_x <= width * 0.1 then
			cam_vx = cam_vx - 1
		end
		
		if press_right or mouse_x >= width * 0.9 then
			cam_vx = cam_vx + 1
		end
		
		-- Zoom in / out based on inputs
		if zoom_timer > ticks then
			if zoom_in and scale_factor < 2 then
				
				cam_x = cam_x + width * scale_factor * 0.005
				cam_y = cam_y + height * scale_factor * 0.005
				
				scale_factor = math.min(2, scale_factor * 1.01)
				
			end
			
			if zoom_out and scale_factor > 0.25 then
				
				cam_x = cam_x - width * scale_factor * 0.005
				cam_y = cam_y - height * scale_factor * 0.005
				
				scale_factor = math.max(0.25, scale_factor * 0.99)
				
				
			end
		else
			zoom_in = false
			zoom_out = false
		end
		
		-- Decelerate camera
		if math.abs(cam_vx) > 0.2 then
			cam_vx = cam_vx * 0.9
		else
			cam_vx = 0
		end
		
		if math.abs(cam_vy) > 0.2 then
			cam_vy = cam_vy * 0.9
		else
			cam_vy = 0
		end
		
		--Sort sprite objects
		
		
		
		sprites = mergeSort(sprites, sprite_compare)
		
		
		
		-- Handle rope constraints
		
		rope = ropes
		rope_count = 0
		while rope do
			rope_count = rope_count + 1
			-- If objects have drifted further than the length of the rope, apply appropriate forces to bring them in check
			a_ax, a_ay, b_ax, b_ay = get_rope_forces(rope)
			
			rope.a.vx = rope.a.vx + a_ax
			rope.a.vy = rope.a.vy + a_ay
			
			rope.b.vx = rope.b.vx + b_ax
			rope.b.vy = rope.b.vy + b_ay
			
			rope = rope.next
		end
		
		sprite = sprites
		i = 1
		while sprite do
			
			-- Check for collisions with other raft sprites
			if sprite.t == "Raft" or sprite.t == "Boat" then
				other = sprites
				
				if sprite.t == "Raft" then
					sprite.nearest_boat = nil
					sprite.nearest_boat_d = 50000
					
				end
				
				while other do
					if sprite.t == "Raft" then
						if (other.t == "Raft" or other.t == "Boat") and other ~= sprite then
							col_dist = dist(sprite.x, sprite.y, other.x, other.y)
							
							if col_dist < sprite.nearest_boat_d and other.t == "Boat" then
								sprite.nearest_boat_d = col_dist
								sprite.nearest_boat = other
							end
							
							if col_dist < 128 then
								dir = angle(sprite.x, sprite.y, other.x, other.y)
								
								sprite.vx = sprite.vx + math.cos(dir) * (132 - col_dist) / 64.0
								sprite.vy = sprite.vy + math.sin(dir) * (132 - col_dist) / 64.0
							end
						end
						
						if other.t == "Bullet" and other.state == "Enemy" and other.cleanup ~= true then
							col_dist = dist(sprite.x, sprite.y, other.x, other.y)
							if col_dist < 128 then
								if sprite.child ~= nil and sprite.child.t == "Raftguy" and sprite.child.state ~= "Dead" then
									sprite.child.food = math.max(0, sprite.child.food - BULLET_DAMAGE)
																	
								end
								
								other.cleanup = true
								
								dir = angle(sprite.x, sprite.y, other.x, other.y)
								
								sprite.vx = sprite.vx + math.cos(dir) * BULLET_IMPACT
								sprite.vy = sprite.vy + math.sin(dir) * BULLET_IMPACT
								
							end
						end
						
						-- Fish collisions
						if other.t == "Fish" and other.cleanup ~= true then
							col_dist = dist(sprite.x, sprite.y, other.x, other.y)
							if col_dist < 128 then
								if sprite.child ~= nil and sprite.child.t == "Raftguy" and sprite.child.state == "Active" and sprite.child.food > 0 then
									sprite.child.food = math.min(100, sprite.child.food + FISH_FOOD_VAL)
									
									-- Feed all other actives
									feed = sprites
									while feed do
										if feed.t == "Raftguy" and feed.state == "Active" and feed.food > 0 then
											feed.food = math.min(100, feed.food + FISH_SHARE_VAL)
										end
										feed = feed.next
									end
																	
									-- Flag fish for removal
									other.cleanup = true
								else
									dir = angle(sprite.x, sprite.y, other.x, other.y)
								
									other.vx = other.vx - math.cos(dir) * (132 - col_dist) / 64.0
									other.vy = other.vy - math.sin(dir) * (132 - col_dist) / 64.0
								end
								
							end
						end
					elseif sprite.t == "Boat" then
						
						if (other.t == "Raft" or other.t == "Boat") and other ~= sprite then
							col_dist = dist(sprite.x, sprite.y, other.x, other.y)
							if col_dist < 128 then
								dir = angle(sprite.x, sprite.y, other.x, other.y)
								
								sprite.vx = sprite.vx + math.cos(dir) * (132 - col_dist) / 64.0
								sprite.vy = sprite.vy + math.sin(dir) * (132 - col_dist) / 64.0
							end
						end
						
						if other.t == "Bullet" and other.state == "Friendly" and other.cleanup ~= true then
							col_dist = dist(sprite.x, sprite.y, other.x, other.y)
							if col_dist < 128 then
								
								sprite.health = math.max(0, sprite.health - BULLET_DAMAGE)																	
											
								other.cleanup = true
								
								dir = angle(sprite.x, sprite.y, other.x, other.y)
								
								sprite.vx = sprite.vx + math.cos(dir) * BULLET_IMPACT
								sprite.vy = sprite.vy + math.sin(dir) * BULLET_IMPACT
								
							end
						end
					end
					
					
					other = other.next
					
				end
			end
			
			-- Run sprite controller
			if sprite.controller ~= nil then
				sprite.controller(sprite, 1 / 60)
			end
			sprite.order = i
			i = i + 1
			sprite = sprite.next
		end
		
		sprites = cleanup_sprites(sprites)
	end
	
	fps = math.ceil((1 / dt + fps * 29) / 3) / 10
end

function love.keypressed(key)
	if key == "s" or key == "down" then
		press_down = true
	elseif key == "w" or key == "up" then
		press_up = true
	elseif key == "a" or key == "left" then
		press_left = true
	elseif key == "d" or key == "right" then
		press_right = true
	elseif key == "q" then
		zoom_in = true
		zoom_out = false
		zoom_timer = ticks + 10
	elseif key == "e" then
		zoom_in = false
		zoom_out = true
		zoom_timer = ticks + 10
	elseif key == "2" then
		screenshot = love.graphics.newScreenshot()
		screenshot:encode('drift_screen.bmp')
	end
end

function love.keyreleased(key)
	if key == "s" or key == "down" then
		press_down = false
	elseif key == "w" or key == "up" then
		press_up = false
	elseif key == "a" or key == "left" then
		press_left = false
	elseif key == "d" or key == "right" then
		press_right = false
	elseif key == "q" then
		zoom_in = false
		zoom_timer = ticks - 0.5
	elseif key == "e" then
		zoom_out = false
		zoom_timer = ticks - 0.5
	elseif key == "escape" then
		love.event.quit()
	end
end

function love.mousepressed(x, y, button)
	
	if button == "l" then
		if selected_sprite ~= nil then
			selected_sprite.effect = 0
		end
		
		sprite = sprites
		selected_sprite = nil
		while sprite do
			
			sx, sy = to_screenspace(sprite.x, sprite.y)
			
			if sprite.t == "Raft" and dist(x, y, sx, sy) <= 64 * scale_factor and sprite.child ~= nil and sprite.child.t == "Raftguy" and sprite.child.state == "Active" then
				selected_sprite = sprite
			end
			
			sprite = sprite.next
		end
		
		if selected_sprite ~= nil then
			selected_sprite.effect = 1
			selection_startx = x
			selection_starty = y
		end
	elseif button == "r" then
		sprite = sprites
		rope_sprite = nil
		while sprite do
			
			sx, sy = to_screenspace(sprite.x, sprite.y)
			
			if sprite.t == "Raft" and dist(x, y, sx, sy) <= 64 * scale_factor and sprite.child ~= nil and sprite.child.t == "Raftguy" and sprite.child.state == "Active" then
				rope_sprite = sprite
			end
			
			sprite = sprite.next
		end
		
		if rope_sprite ~= nil then
			rope_sprite.effect = 2
			rope_startx = x
			rope_starty = y
		end
		
	elseif button == "wd" then
		zoom_out = true
		zoom_in = false
		
		zoom_timer = ticks + 0.25
		
		
	elseif button == "wu" then
		zoom_out = false
		zoom_in = true
		
		zoom_timer = ticks + 0.25

	end
end

function love.mousereleased(x, y, button)
	if button == "l" then
		if selected_sprite ~= nil then
			vel = math.min(RAFT_MAX_VEL, dist(selection_startx, selection_starty, x, y) / scale_factor / 64.0)
			dir = -angle(selection_startx, selection_starty, x, y)
			
			selected_sprite.vx = -math.cos(dir) * vel
			selected_sprite.vy = math.sin(dir) * vel
						
			selected_sprite.effect = 0
			
			selected_sprite.child.food = selected_sprite.child.food - FOOD_LOSS_MOVE_RATE * vel
			
			selected_sprite = nil
		end
	elseif button == "r" then
		if rope_sprite ~= nil then
			sprite = sprites
			target_sprite = nil
			while sprite do
				
				sx, sy = to_screenspace(sprite.x, sprite.y)
				
				if sprite.t == "Raft" and dist(x, y, sx, sy) <= 64 * scale_factor then
					target_sprite = sprite
				end
				
				sprite = sprite.next
			end
			
			mx, my = to_worldspace(x, y)
		
			length = dist(rope_sprite.x, rope_sprite.y, mx, my)
			
			if target_sprite ~= nil and rope_sprite ~= target_sprite and not rope_exists(ropes, target_sprite, rope_sprite) and length <= ROPE_MAX_LENGTH then
				ropes = addRope(ropes, rope_sprite, target_sprite, sprite_dist(rope_sprite, target_sprite) * 1.05)
				
				if target_sprite.child ~= nil and target_sprite.child.state == "Sleep" then
					if target_sprite.child.t == "Raftguy" then
						target_sprite.child.state = "Active"
						target_sprite.child.img = raftguy[0]
					elseif target_sprite.child.t == "FriendlyTurret" then
						target_sprite.child.state = "Active"
					end
				end
			end
			
			rope_sprite.effect = 0
			
			rope_sprite = nil
		
			
		end
	elseif button == "wd" then
		zoom_out = false
	elseif button == "wu" then
		zoom_in = false
	end
end

