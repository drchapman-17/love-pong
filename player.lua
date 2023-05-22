Player = Object.extend(Object)


function Player:new(name, x, y, width, height)
	self.name = name
	self.original_x = x 
	self.original_y = y 
	self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = 260
end

function Player:reset()
	self.x = self.original_x
    self.y = self.original_y
end

function Player:update( dt, direction)
	local window_width, window_height = love.graphics.getDimensions( )
	if direction == "up" and self.y > 10 then
		self.y = self.y - self.speed * dt
	end
	if direction == "down" and (self.y+self.height)<window_height-10 then
		self.y = self.y + self.speed * dt
	end
end

function Player:draw()
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end