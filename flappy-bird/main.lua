Class = require("libraries/class")
push = require("libraries/push")
require("StateMachine")
require("states/BaseState")
require("states/TitleScreenState")
require("states/CountdownState")
require("states/PlayState")

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage("sprites/background.png")
local BACKGROUND_WIDTH = background:getWidth()
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = BACKGROUND_WIDTH - VIRTUAL_WIDTH

local ground = love.graphics.newImage("sprites/ground.png")
local groundScroll = 0
local groundScrollSpeed = logSpeed

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setTitle("Speedy Bird")
	push:setupScreen(
		VIRTUAL_WIDTH,
		VIRTUAL_HEIGHT,
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
		{ fullscreen = false, resizable = true, vsync = true }
	)

	smallFont = love.graphics.newFont("fonts/font.ttf", 8)
	mediumFont = love.graphics.newFont("fonts/flappy.ttf", 14)
	flappyFont = love.graphics.newFont("fonts/flappy.ttf", 28)
	hugeFont = love.graphics.newFont("fonts/flappy.ttf", 56)
	love.graphics.setFont(flappyFont)

	sounds = {
		["jump"] = love.audio.newSource("sounds/jump.wav", "static"),
		["lost"] = love.audio.newSource("sounds/lost.wav", "static"),
	}

	math.randomseed(os.time())

	love.keyboard.keysPressed = {}

	gStateMachine = StateMachine({
		["title"] = function()
			return TitleScreenState()
		end,
		["countdown"] = function()
			return CountdownState()
		end,
		["play"] = function()
			return PlayState()
		end,
	})
	gStateMachine:change("title")
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true

	if key == "q" then
		love.event.quit()
	end
end

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.update(dt)
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
	groundScroll = (groundScroll + groundScrollSpeed * dt) % VIRTUAL_WIDTH
	groundScrollSpeed = logSpeed

	gStateMachine:update(dt)

	love.keyboard.keysPressed = {}
end

function love.draw()
	push:start()

	love.graphics.draw(background, -backgroundScroll, 0)

	gStateMachine:render()

	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

	push:finish()
end
