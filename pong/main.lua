push = require("libraries/push")
class = require("libraries/class")
require("Ball")
require("Paddle")

windowWidth = 800
windowHeight = 600
virtualWidth = 432
virtualHeight = 243

paddleSpeed = 200

ballSpeedMultiplier = 1.1

function love.load()
	love.window.setTitle("Pong")

	push:setupScreen(
		virtualWidth,
		virtualHeight,
		windowWidth,
		windowHeight,
		{ fullscreen = false, resizable = true, vsync = true }
	)

	love.graphics.setDefaultFilter("nearest", "nearest")

	sounds = {
		["paddleHit"] = love.audio.newSource("sounds/paddleHit.wav", "static"),
		["wallHit"] = love.audio.newSource("sounds/wallHit.wav", "static"),
		["score"] = love.audio.newSource("sounds/score.wav", "static"),
	}

	love.keyboard.keysPressed = {}

	smallFont = love.graphics.newFont("fonts/font.ttf", 8)
	largeFont = love.graphics.newFont("fonts/font.ttf", 32)

	player1 = Paddle(10, 30, 5, 20)
	player2 = Paddle(virtualWidth - 10, virtualHeight - 30, 5, 20)

	ball = Ball(virtualWidth / 2 - 2, virtualHeight / 2 - 2, 4, 4)

	player1Score = 0
	player2Score = 0

	math.randomseed(os.time())

	gameState = "Start"

	gameMode = "Two Player"

	servingPlayer = 1

	botDifficulty = "Easy"
	botSpeed = 50

	winningPlayer = 0
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.update(dt)
	if gameState == "Start" then
		if love.keyboard.wasPressed("space") then
			gameState = "Serve"
		end
	elseif gameState == "Serve" then
		if servingPlayer == 1 then
			ball.x = player1.x + ball.width + 5
			ball.y = player1.y + player1.height / 2 - ball.height / 2

			if love.keyboard.wasPressed("e") then
				gameState = "Play"
				ball.dy = math.random(-50, 50)
				ball.dx = math.random(140, 200)
			end
		else
			if gameMode == "Two Player" then
				ball.x = player2.x - ball.width - 5
				ball.y = player2.y + player2.height / 2 - ball.height / 2

				if love.keyboard.wasPressed("return") then
					gameState = "Play"
					ball.dy = math.random(-50, 50)
					ball.dx = -math.random(140, 200)
				end
			elseif gameMode == "Single Player" then
				ball.x = player2.x - ball.width - 5
				ball.y = player2.y + player2.height / 2 - ball.height / 2

				gameState = "Play"
				ball.dy = math.random(-50, 50)
				ball.dx = -math.random(140, 200)
			elseif gameMode == "Lazy" then
				ball.x = player2.x - ball.width - 5
				ball.y = player2.y + player2.height / 2 - ball.height / 2
				gameState = "Play"
			end
		end
	elseif gameState == "Play" then
		if ball:collides(player1) then
			sounds["paddleHit"]:play()

			ball.dx = -ball.dx * ballSpeedMultiplier
			ball.x = player1.x + 5

			if ball.dy < 0 then
				ball.dy = -math.random(10, 150)
			else
				ball.dy = math.random(10, 150)
			end
		end
		if ball:collides(player2) then
			sounds["paddleHit"]:play()

			ball.dx = -ball.dx * ballSpeedMultiplier
			ball.x = player2.x - 4

			if ball.dy < 0 then
				ball.dy = math.random(10, 150)
			else
				ball.dy = -math.random(10, 150)
			end
		end

		if ball.y <= 0 then
			sounds["wallHit"]:play()

			ball.y = 0
			ball.dy = -ball.dy
		end
		if ball.y >= virtualHeight - 4 then
			sounds["wallHit"]:play()

			ball.y = virtualHeight - 4
			ball.dy = -ball.dy
		end

		if ball.x < 0 then
			sounds["score"]:play()

			player2Score = player2Score + 1
			servingPlayer = 1

			if player2Score >= 10 then
				winningPlayer = 2
				gameState = "Done"
			else
				gameState = "Serve"
				ball:reset()
			end
		end
		if ball.x > virtualWidth then
			sounds["score"]:play()

			player1Score = player1Score + 1
			servingPlayer = 2

			if player1Score >= 10 then
				winningPlayer = 1
				gameState = "Done"
			else
				gameState = "Serve"
				ball:reset()
			end
		end

		ball:update(dt)
	elseif gameState == "Done" then
		if love.keyboard.wasPressed("space") then
			servingPlayer = 1
			player1Score = 0
			player2Score = 0
			gameState = "Serve"

			if winningPlayer == 1 then
				servingPlayer = 2
			else
				servingPlayer = 1
			end
		end
	end

	if love.keyboard.isDown("w") then
		player1.dy = -paddleSpeed
	elseif love.keyboard.isDown("s") then
		player1.dy = paddleSpeed
	else
		player1.dy = 0
	end

	if gameMode == "Two Player" then
		if love.keyboard.isDown("up") then
			player2.dy = -paddleSpeed
		elseif love.keyboard.isDown("down") then
			player2.dy = paddleSpeed
		else
			player2.dy = 0
		end
	elseif gameMode == "Single Player" then
		local distance = math.sqrt((ball.y - player2.y) ^ 2)
		if distance > 2 or distance < -2 then
			player2.dy = ((ball.y - player2.y) / distance) * botSpeed
		else
			player2.dy = 0
		end
	elseif gameMode == "Lazy" then
		local distance = math.sqrt((ball.y - player2.y) ^ 2)
		if distance > 2 or distance < -2 then
			player2.dy = ((ball.y - player2.y) / distance) * botSpeed
		else
			player2.dy = 0
		end

		if ball.dx < 0 then
			local distance = math.sqrt((player1.x - ball.x) ^ 2 + (player1.y - ball.y) ^ 2)
			ball.dy = ((player1.y - ball.y) / distance) * 250
			ball.dx = ((player1.x - ball.x) / distance) * 250
		end
	end

	player1:update(dt)
	player2:update(dt)

	love.keyboard.keysPressed = {}
end

function love.draw()
	push:apply("start")

	love.graphics.clear(40 / 255, 45 / 255, 52 / 255)

	love.graphics.setFont(smallFont)
	love.graphics.printf(string.format(gameMode), 0, 10, virtualWidth, "center")
	if gameMode == "Single Player" or gameMode == "Lazy" then
		love.graphics.printf(
			string.format("Bot Difficulty: %s", botDifficulty),
			0,
			virtualHeight - 20,
			virtualWidth,
			"center"
		)
	end
	if gameState == "Start" then
		love.graphics.printf("Press Space to Start", 0, 25, virtualWidth, "center")
	elseif gameState == "Serve" then
		if servingPlayer == 1 then
			love.graphics.printf(string.format("Player %s's Serve!", servingPlayer), 0, 25, virtualWidth, "center")
		elseif gameMode == "Single Player" or gameMode == "Lazy" and servingPlayer == 2 then
			love.graphics.printf(string.format("Bot's Serve!"), 0, 25, virtualWidth, "center")
		else
			love.graphics.printf(string.format("Player %s's Serve!", servingPlayer), 0, 25, virtualWidth, "center")
		end
	elseif gameState == "Done" then
		love.graphics.printf("Press Space to Play Again", 0, 25, virtualWidth, "center")

		love.graphics.setColor(1, 215 / 255, 0)
		love.graphics.setFont(largeFont)
		love.graphics.printf(
			string.format("Player%s Wins!", winningPlayer),
			0,
			virtualHeight / 2,
			virtualWidth,
			"center"
		)
		love.graphics.setColor(1, 1, 1)
	end

	love.graphics.setFont(largeFont)
	love.graphics.print(tostring(player1Score), virtualWidth / 2 - 50, virtualHeight / 3)
	love.graphics.print(tostring(player2Score), virtualWidth / 2 + 30, virtualHeight / 3)

	if gameState == "Done" and winningPlayer == 1 then
		love.graphics.setColor(1, 215 / 255, 0)
	end
	player1:render()
	love.graphics.setColor(1, 1, 1)

	if gameState == "Done" and winningPlayer == 2 then
		love.graphics.setColor(1, 215 / 255, 0)
	end
	player2:render()
	love.graphics.setColor(1, 1, 1)

	if ball.dx > 400 or ball.dx < -400 then
		love.graphics.setColor(0.6, 0.3, 0)
	end
	ball:render()
	love.graphics.setColor(1, 1, 1)

	displayFPS()

	push:apply("end")
end

function love.keypressed(key)
	if key == "q" then
		love.event.quit()
	elseif key == "f" then
		if gameMode == "Two Player" then
			gameMode = "Single Player"
		elseif gameMode == "Single Player" then
			gameMode = "Lazy"
		elseif gameMode == "Lazy" then
			gameMode = "Two Player"
		end
	elseif key == "d" then
		if botDifficulty == "Easy" then
			botDifficulty = "Medium"
			botSpeed = 100
		elseif botDifficulty == "Medium" then
			botDifficulty = "Hard"
			botSpeed = 120
		elseif botDifficulty == "Hard" then
			botDifficulty = "Impossible"
			botSpeed = 150
		elseif botDifficulty == "Impossible" then
			botDifficulty = "Easy"
			botSpeed = 50
		end
	end

	love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
	if love.keyboard.keysPressed[key] then
		return true
	else
		return false
	end
end

function displayFPS()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(0, 1, 0)
	love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end
