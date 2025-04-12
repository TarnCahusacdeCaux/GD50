PlayState = Class({ __includes = BaseState })

require("Bird")
require("Log")
require("LogPair")

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

logSpeed = 90

function PlayState:init()
	self.bird = Bird()
	self.birdSpeed = 10
	self.birdSpeedIncrement = 0.04
	self.logPairs = {}
	self.logSpawnTimer = 0
	self.logSpawnEvery = math.random(1, 3)
	self.logSpeedIncrement = 10
	self.lastY = -LOG_HEIGHT + math.random(80) + 20
	self.time = 0
	self.bestTimeFile = io.open("bestTime.txt", "r")
	self.bestTime = tonumber(self.bestTimeFile:read())
	self.bestTimeFile:close()
end

function PlayState:update(dt)
	self.time = self.time + dt

	self.logSpawnTimer = self.logSpawnTimer + dt
	if self.logSpawnTimer > self.logSpawnEvery then
		local y =
			math.max(-LOG_HEIGHT + 10, math.min(self.lastY + math.random(-65, 65), VIRTUAL_HEIGHT - 90 - LOG_HEIGHT))
		self.lastY = y

		table.insert(self.logPairs, LogPair(y))
		self.logSpawnTimer = 0
	end

	self.bird.x = self.bird.x + self.birdSpeed * dt

	if self.bird.y + self.bird.height > VIRTUAL_HEIGHT - 18 then
		self.bird.x = self.bird.x - (logSpeed - self.birdSpeed) * dt
		self.bird.y = VIRTUAL_HEIGHT - self.bird.height - 16
		self.bird.dy = 0
		self.birdSpeed = 1
	end

	for key, pair in pairs(self.logPairs) do
		pair:update(dt)

		for key, log in pairs(pair.logs) do
			if collisionBetween(self.bird, log) and log.y < VIRTUAL_HEIGHT - 30 then
				self.bird.x = self.bird.x - logSpeed * dt - self.birdSpeed * dt
				self.birdSpeed = 1

				if
					log.orientation == "top"
					and self.bird.y <= log.y + log.height - 10
					and self.bird.x + self.bird.width > log.x + 2
				then
					self.bird.y = log.y + log.height - 10
				elseif
					log.orientation == "bottom"
					and self.bird.y + self.bird.height >= log.y + 6
					and self.bird.x + self.bird.width > log.x + 2
				then
					self.bird.dy = 0
					self.bird.y = log.y - self.bird.height + 10
				end
			end
		end
	end

	for key, pair in pairs(self.logPairs) do
		if pair.remove then
			table.remove(self.logPairs, key)
		end
	end

	if self.bird.x + self.bird.width < 0 then
		sounds["lost"]:play()

		if self.time > self.bestTime then
			self.bestTimeFile = io.open("bestTime.txt", "w")
			self.bestTimeFile:write(self.time)
			self.bestTimeFile:close()
		end

		gStateMachine:change("title")
	elseif self.bird.x > VIRTUAL_WIDTH - self.bird.width then
		self.bird.x = VIRTUAL_WIDTH - self.bird.width
	end

	if love.keyboard.wasPressed("space") then
		sounds["jump"]:play()
		self.bird.dy = self.bird.jumpForce
	elseif love.mouseWasPressed(1) then
		sounds["jump"]:play()
		self.bird.dy = self.bird.jumpForce
	end

	self.bird:update(dt)

	self.birdSpeed = self.birdSpeed + self.birdSpeedIncrement
	logSpeed = logSpeed + self.logSpeedIncrement * dt
	self.logSpawnEvery = math.random(1, 3)
end

function PlayState:render()
	for key, pair in pairs(self.logPairs) do
		pair:render()
	end

	love.graphics.setFont(flappyFont)
	love.graphics.print(string.format("%.2f", self.time), 10, 10)

	self.bird:render()
end

function collisionBetween(rect1, rect2)
	if
		rect1.x + 2 <= rect2.x + rect2.width
		and rect1.x + rect1.width - 2 >= rect2.x
		and rect1.y + 2 <= rect2.y + rect2.height
		and rect1.y + rect1.height - 2 >= rect2.y
	then
		return true
	end
	return false
end
