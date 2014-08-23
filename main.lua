function love.load()
	width, height = love.graphics.getDimensions()
	
	-- Camera coords
	cam_x = 0.0
	cam_y = 0.0
end

function love.draw()
	
	love.graphics.setColor(10, 10, 10)
	love.graphics.rectangle('fill', 0, 0, width, height)
	
	love.graphics.setColor(180, 180, 180)
	love.graphics.print('Hello, world!', 0, 0)
end


function love.update(dt)
	
end

function love.keypressed(key)

end

function love.keyreleased(key)
	
end

function love.mousepressed(x, y, button)
	
end

function love.mousereleased(x, y, button)
	
end