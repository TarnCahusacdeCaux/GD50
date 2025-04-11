Bird = Class()

BIRD_IMAGE = love.graphics.newImage("sprites/bird.png")
local BIRD_WIDTH, BIRD_HEIGHT = BIRD_IMAGE:getDimensions()

local GRAVITY = 20
local JUMP_FORCE = -5

love.mouseButtonsPressed = {}

function Bird:init()
	self.width, self.height = BIRD_WIDTH, BIRD_HEIGHT
	self.x = VIRTUAL_WIDTH / 2 - self.width / 2
	self.y = VIRTUAL_HEIGHT / 2 - self.height / 2
	self.dy = 0
	self.gravity = GRAVITY
	self.jumpForce = JUMP_FORCE
end

function love.mousepressed(x, y, button)
	love.mouseButtonsPressed[button] = true
end

function love.mouseWasPressed(button)
	return love.mouseButtonsPressed[button]
end

function Bird:update(dt)
	if self.y < 0 then
		self.y = 0
	end

	self.dy = self.dy + self.gravity * dt
	self.y = self.y + self.dy

	love.mouseButtonsPressed = {}
end

function Bird:render()
	love.graphics.draw(BIRD_IMAGE, self.x, self.y)
end
