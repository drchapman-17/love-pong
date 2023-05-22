Ball = Object.extend(Object)

x_directions = {1,-1}

function Ball:new(x, y, radius)
	self.x = x
    self.y = y
    self.original_x = x 
	self.original_y = y 
	self.radius = radius
    self.speed = 700
    self.direction = {x=0, y=0}
end

function Ball:reset()
	self.x = self.original_x
    self.y = self.original_y
    self.direction = {x=0, y=0}
end

function Ball:set_x_direction(ball_state)
	if ball_state == "first shot" then
		self.direction["x"] = x_directions[ math.random( #x_directions ) ]
	end
	if ball_state == "1_scored" then
		self.direction["x"] = 1
	end
	if ball_state == "2_scored" then
		self.direction["x"] = -1
	end
end

function Ball:update( dt)
		self.x = self.x + self.direction["x"] * self.speed * dt
		self.y = self.y + self.direction["y"] * self.speed * dt
end

function Ball:draw()
	 love.graphics.circle("line", self.x, self.y, self.radius)
end

function Ball:check_border_collision()
	local window_width, window_height = love.graphics.getDimensions( )
	if not (self.y - self.radius > 0) then
		self.direction["y"] = -self.direction["y"]
	end
	if not (self.y + self.radius < window_height) then
		self.direction["y"] = -self.direction["y"]
	end

end

function Ball:check_collision(e, entity)
	local maxangle = 45
	if entity == "player1" then
		
		if self.x < e.x + 2 * e.width -- platform surface
			and not (self.y + self.radius < e.y or self.y - self.radius > e.y + e.height) then -- y coordinates
			local angle = (((self.y - e.y) / e.height -0.5) *2)*maxangle
			--print("done1",  angle)
			self.direction["y"] = math.atan( angle*(math.pi/180))
    		self.direction['x'] = 1 -- should be computing angle
    		TEsound.play("sounds/pop.mp3", "static")
    	end
	end
	if entity == "player2"then
		if self.x > e.x - e.width 
			and not (self.y + self.radius < e.y or self.y - self.radius > e.y + e.height)then

			local angle = (((self.y - e.y) / e.height -0.5) *2)*maxangle
			--print("done2", angle)
			self.direction["y"] = math.atan(angle*(math.pi/180))
    		self.direction['x'] = -1
    		TEsound.play("sounds/pop.mp3", "static")
    	end
	end
end

