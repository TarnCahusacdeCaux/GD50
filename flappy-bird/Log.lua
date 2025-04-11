Log = Class()

local LOG_IMAGE = love.graphics.newImage("sprites/log1.png")

LOG_WIDTH, LOG_HEIGHT = LOG_IMAGE:getDimensions()

function Log:init(orientation, y)
	self.x = VIRTUAL_WIDTH
	self.y = y
	self.width = LOG_WIDTH
	self.height = LOG_HEIGHT
	self.orientation = orientation
end

function Log:update(dt) end

function Log:render()
	love.graphics.draw(
		LOG_IMAGE,
		self.x,
		(self.orientation == "top" and self.y + LOG_HEIGHT or self.y),
		0,
		1,
		self.orientation == "top" and -1 or 1
	)
end
