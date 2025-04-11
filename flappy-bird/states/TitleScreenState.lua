TitleScreenState = Class({ __includes = BaseState })

function TitleScreenState:update(dt)
	if love.keyboard.wasPressed("return") then
		gStateMachine:change("countdown")
	end
end

function TitleScreenState:render()
	love.graphics.setFont(flappyFont)
	love.graphics.printf("Speedy Bird", 0, 64, VIRTUAL_WIDTH, "center")

	love.graphics.setFont(mediumFont)
	love.graphics.printf("Enter to Start\nSpace to Jump", 0, 100, VIRTUAL_WIDTH, "center")

	if not io.open("bestTime.txt", "r") then
		local bestTimeFile = io.open("bestTime.txt", "w")
		bestTimeFile:write(0)
		bestTimeFile:close()
	end
	local bestTimeFile = io.open("bestTime.txt", "r")
	bestTime = bestTimeFile:read()
	bestTimeFile:close()

	love.graphics.printf(string.format("Best Time: %.2f", bestTime), 0, 150, VIRTUAL_WIDTH, "center")
end
