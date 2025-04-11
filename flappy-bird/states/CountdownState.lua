CountdownState = Class({ __includes = BaseState })

require("Bird")

local COUNTDOWN_TIME = 1.75

function CountdownState:init()
	self.countdown = 4
	self.bird = Bird()
	self.birdSpeed = ((VIRTUAL_WIDTH / 2 + self.bird.width / 2) / self.countdown) * COUNTDOWN_TIME
	self.bird.x = -self.bird.width
end

function CountdownState:update(dt)
	if self.countdown < 0 then
		gStateMachine:change("play")
	end
	self.bird.x = self.bird.x + self.birdSpeed * dt

	self.countdown = self.countdown - COUNTDOWN_TIME * dt
end

function CountdownState:render()
	love.graphics.setFont(hugeFont)
	if self.countdown < 1 then
		love.graphics.printf("GO!", 0, VIRTUAL_HEIGHT / 2 - 28, VIRTUAL_WIDTH, "center")
	else
		love.graphics.printf(string.format("%d", self.countdown), 0, VIRTUAL_HEIGHT / 2 - 28, VIRTUAL_WIDTH, "center")
	end

	self.bird:render()
end
