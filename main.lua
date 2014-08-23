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
	
	-- TEMP - generate a random batch of raft sprites
	for i = 1, 500 do
		sprites = {next = sprites,
					x = math.random(-4000, 4000),
					y = math.random(-4000, 4000),
					r = math.random(-math.pi * 0.25, math.pi * 0.25),
					s = 1,
					img = raft[0],
					shadow = true,
					controller = nil}
	end
	
	fps = 60
end

function loadImages()
	
	-- Water overlay images
	water = {}
	water[0] = love.graphics.newImage("gfx/water_01.png")
	
	raft = {}
	raft[0] = love.graphics.newImage("gfx/raft_01.png")
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
		
		-- If applicable, render sprite shadows
		if sprite.shadow then
			love.graphics.setColor(20, 20, 20, 120)
			love.graphics.draw(sprite.img, (sprite.x - cam_x) * scale_factor, (sprite.y + 10 - cam_y) * scale_factor, sprite.r, sprite.s * scale_factor, sprite.s * scale_factor)
		end

		love.graphics.setColor(255, 255, 255)
		love.graphics.draw(sprite.img, (sprite.x - cam_x) * scale_factor, (sprite.y - cam_y) * scale_factor, sprite.r, sprite.s * scale_factor, sprite.s * scale_factor)
		
		sprite = sprite.next
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
	
	
	-- Accelerate camera based on inputs
	if press_up then
		cam_vy = cam_vy - 1
	end
	
	if press_down then
		cam_vy = cam_vy + 1
	end
	
	if press_left then
		cam_vx = cam_vx - 1
	end
	
	if press_right then
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
		cam_vx = math.min(cam_vx * 0.9, 5)
	else
		cam_vx = 0
	end
	
	if math.abs(cam_vy) > 0.2 then
		cam_vy = math.min(cam_vy * 0.9, 5)
	else
		cam_vy = 0
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
	end
end

function love.mousepressed(x, y, button)
	
end

function love.mousereleased(x, y, button)
	
end