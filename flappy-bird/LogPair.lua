LogPair = Class()

function LogPair:init(y)
	self.x = VIRTUAL_WIDTH + 32
	self.y = y
	self.logs = {
		["upper"] = Log("top", self.y),
		["lower"] = Log("bottom", self.y + LOG_HEIGHT + math.random(80, 100)),
	}
	self.remove = false
end

function LogPair:update(dt)
	if self.x > -LOG_WIDTH then
		self.x = self.x - logSpeed * dt
		self.logs["upper"].x = self.x
		self.logs["lower"].x = self.x
	else
		self.remove = true
	end
end

function LogPair:render()
	for key, log in pairs(self.logs) do
		log:render()
	end
end
