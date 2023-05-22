--Loads Variables and Objects in the Game Engine

score = {player_1=0, player_2=0}

function love.load()
	Object = require "classic"
	require "player"
	require "ball"
	require "tesound"
	fullscreen=false
	font = love.graphics.newFont("fonts/font.ttf", 40)
	can_start = true
	ball_state = "first shot"
	
	success = love.window.setMode( 1280, 720 )
	window_width, window_height = love.graphics.getDimensions( )
	center = {} 
	center["x"] = (window_width/2)
	center["y"] = (window_height/2)
	player_width = 15
	player_height = 100
	x1 = 50
	x2 = window_width - (50 + player_width)
	y = window_height/2 - player_height/2
	-- args: name, x, y
	p1 = Player("Player1", x1, y, player_width, player_height)
	p2 = Player("Player2", x2, y, player_width, player_height)
	ball = Ball(center["x"], center["y"], 10)
end

function reset_placements()
	p1.reset(p1)
	p2.reset(p2)
	ball.reset(ball)
	can_start=true
end



function check_scores()
	if ball.x - ball.radius > (x2 + player_width)  then
		score["player_1"] = score["player_1"] + 1
		--print(score["player_1"], score["player_2"])
		ball_state="1_scored"
		reset_placements()
		
	end
	if ball.x + ball.radius < x1 then -- + here for a bit of tolerance (gameplay feature)
		score["player_2"] = score["player_2"] + 1
		--print(score["player_1"], score["player_2"])
		ball_state="2_scored"
		reset_placements()
	end
end

-- Updates Values
function love.update(dt)
	if love.keyboard.isDown("f11") then
		if fullscreen == false then
			love.window.setFullscreen(true, "exclusive")
			fullscreen=true
		else
			love.window.setFullscreen(false, "exclusive")
			fullscreen=false
		end
	end
	-- reset game
	if love.keyboard.isDown("r") then
		reset_placements()
		score = {player_1=0, player_2=0}
	end
	-- start game
	if can_start and love.keyboard.isDown("space") then

    	ball.set_x_direction(ball, ball_state)
    	can_start = false
    end
	-- player1
	if love.keyboard.isDown("w") then
    	p1.update(p1, dt, "up")
    end
    if love.keyboard.isDown("s") then
    	p1.update(p1, dt, "down")
    end
    --player2
    if love.keyboard.isDown("i") then
    	p2.update(p2, dt, "up")
    end
    if love.keyboard.isDown("k") then
    	p2.update(p2, dt, "down")
    end
    ball.check_border_collision(ball)
    ball.check_collision(ball, p1, "player1")
    ball.check_collision(ball, p2, "player2")
    ball.update(ball, dt)
    check_scores()
end

--Draws in the Window
function love.draw()
	--set colour
	--love.graphics.setColor(love.math.colorFromBytes(128, 234, 0))
	love.graphics.setColor(love.math.colorFromBytes(200, 60, 200))
	--set line width
	love.graphics.setLineWidth( 2 )
	love.graphics.setPointSize( 2 )

	love.graphics.print(score['player_1'] .. " pts.", font, 100,30)
	love.graphics.print(score['player_2'] .. " pts.", font, window_width-180, 30)
	--draw field
	draw_middle_field()

	--draw players
	p1.draw(p1)
	p2.draw(p2)
	--draw ball
	ball.draw(ball)
end

function draw_middle_field()
	love.graphics.setLineWidth( 1 )
	step = 30
	line_x = window_width/2
	local j = 1
	love.graphics.points({center["x"], center["y"]})
	for i=0,window_height-step-10,step do
		if (j%2==0) then
			love.graphics.line(line_x, center["y"]+i, line_x, center["y"]+i+step)
			love.graphics.line(line_x, center["y"]-i, line_x, center["y"]-i-step)
		end
		j= j+1
	end

	love.graphics.setLineWidth( 2 )
end