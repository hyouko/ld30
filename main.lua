require "util"

-- Pseudo-object definitions
require "raft"
require "raftguy"
require "fish"

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
	
	-- Spawn some test raft sprites
	for i = 1, 200 do
		sprites = addRaft(sprites)
		
		if math.random() < 0.2 then
			sprites = addRaftguy(sprites, sprites)
		end
	end
	
	-- Spawn some test fish
	for i = 1, 500 do
		sprites = addFish(sprites)
	end
	
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
end

function love.draw()
	love.graphics.setColor(10, 100, 210)
	love.graphics.rectangle('fill', 0, 0, width, height)
	
	drawWaterLayer(30, 20, 0)
	drawWaterLayer(-10, 30, math.pi / 2)
	drawWaterLayer(15, 0, math.pi * 1.5)
	
	-- Render all sprites
	sprite = sprites
	while sprite do
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
			
			
			
		else
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(sprite.img,
				sx,
				sy,
				sprite.r, sprite.s * scale_factor, sprite.s * scale_factor, 64, 64)
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
	
	if debug_on then
		love.graphics.setColor(250, 250, 250)
		love.graphics.print("FPS: " .. fps, 20, 20)
		love.graphics.print("CamX: " .. math.ceil(cam_x  * 10) / 10, 20, 40)
		love.graphics.print("CamY: " .. math.ceil(cam_y  * 10) / 10, 120, 40)
	end
	
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
	
	cam_x = cam_x + cam_vx
	cam_y = cam_y + cam_vy
	
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
	if zoom_in then
		scale_factor = math.min(1.5, scale_factor * 1.005)
	end
	
	if zoom_out then
		scale_factor = math.max(0.5, scale_factor * 0.995)
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
	
	sprite = sprites
	i = 1
	while sprite do
		
		-- Check for collisions with other raft sprites
		if sprite.t == "Raft" then
			other = sprites
			while other do
				if other.t == "Raft" and other ~= sprite then
					col_dist = dist(sprite.x, sprite.y, other.x, other.y)
					if col_dist < 128 then
						dir = angle(sprite.x, sprite.y, other.x, other.y)
						
						sprite.vx = sprite.vx + math.cos(dir) * (132 - col_dist) / 64.0
						sprite.vy = sprite.vy + math.sin(dir) * (132 - col_dist) / 64.0
					end
				end
				other = other.next
			end
		end
		
		
		-- Run sprite controller
		if sprite.controller ~= nil then
			sprite.controller(sprite, dt)
		end
		sprite.order = i
		i = i + 1
		sprite = sprite.next
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
	elseif key == "e" then
		zoom_out = true
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
	elseif key == "e" then
		zoom_out = false
	elseif key == "escape" then
		love.event.quit()
	end
end

function love.mousepressed(x, y, button)
	
	if selected_sprite ~= nil then
		selected_sprite.effect = 0
	end
	
	sprite = sprites
	selected_sprite = nil
	while sprite do
		
		sx, sy = to_screenspace(sprite.x, sprite.y)
		
		if sprite.t == "Raft" and dist(x, y, sx, sy) <= 64 * scale_factor and sprite.child ~= nil and sprite.child.t == "Raftguy" and sprite.child.food > 0 then
			selected_sprite = sprite
		end
		
		sprite = sprite.next
	end
	
	if selected_sprite ~= nil then
		selected_sprite.effect = 1
		selection_startx = x
		selection_starty = y
	end
	
end

function love.mousereleased(x, y, button)
	if selected_sprite ~= nil then
		vel = math.min(RAFT_MAX_VEL, dist(selection_startx, selection_starty, x, y) / scale_factor / 64.0)
		dir = -angle(selection_startx, selection_starty, x, y)
		
		selected_sprite.vx = -math.cos(dir) * vel
		selected_sprite.vy = math.sin(dir) * vel
		
		selected_sprite.effect = 0
		
		selected_sprite.child.food = selected_sprite.child.food - FOOD_LOSS_MOVE_RATE * vel
		
		selected_sprite = nil
	end
end

