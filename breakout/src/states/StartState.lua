StartState = Class({ __includes = BaseState })

local highlighted = 1

function StartState:update(dt)
	if highlighted == 1 and love.keyboard.wasPressed("return") then
		gSounds["confirm"]:play()
		gStateMachine:change("play")
	end

	if love.keyboard.wasPressed("w") or love.keyboard.wasPressed("s") then
		highlighted = highlighted == 1 and 2 or 1
		gSounds["paddle-hit"]:play()
	end

	if love.keyboard.wasPressed("q") then
		love.event.quit()
	end
end

function StartState:render()
	love.graphics.setFont(gFonts["large"])
	love.graphics.printf("BREAKOUT", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, "center")

	love.graphics.setFont(gFonts["medium"])

	if highlighted == 1 then
		love.graphics.setColor(103 / 255, 1, 1)
	end
	love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, "center")

	love.graphics.setColor(1, 1, 1)

	if highlighted == 2 then
		love.graphics.setColor(103 / 255, 1, 1)
	end
	love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, "center")

	love.graphics.setColor(1, 1, 1)
end
