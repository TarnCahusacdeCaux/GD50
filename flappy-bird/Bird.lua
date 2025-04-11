Bird = Class()

BIRD_IMAGE = love.graphics.newImage("sprites/bird.png")
local BIRD_WIDTH, BIRD_HEIGHT = BIRD_IMAGE:getDimensions()

local GRAVITY = 20
local JUMP_FORCE = -5

function Bird:init()
	self.width, self.height = BIRD_WIDTH, BIRD_HEIGHT
	self.x = VIRTUAL_WIDTH / 2 - self.width / 2
	self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
	self.dy = 0
	self.gravity = GRAVITY
	self.jumpForce = JUMP_FORCE
end

function Bird:update(dt)
	if love.keyboard.wasPressed("space") then
		sounds["jump"]:play()
		self.dy = self.jumpForce
	end

	if self.y < 0 then
		self.y = 0
	end

	self.dy = self.dy + self.gravity * dt
	self.y = self.y + self.dy
end

function Bird:render()
	love.graphics.draw(BIRD_IMAGE, self.x, self.y)
end
