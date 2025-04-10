push = require("libraries/push")

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage("sprites/background.png")
local BACKGROUND_WIDTH, BACKGROUND_HEIGHT = background:getDimensions()
local backgroundScroll = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = BACKGROUND_WIDTH - VIRTUAL_WIDTH

local ground = love.graphics.newImage("sprites/ground.png")
local groundScroll = 0
local GROUND_SCROLL_SPEED = 60

local GROUND_WIDTH, GROUND_HEIGHT = ground:getDimensions()

local bird = love.graphics.newImage("sprites/bird.png")
local BIRD_WIDTH, BIRD_HEIGHT = bird:getDimensions()

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.window.setTitle("Flappy Bird")
	push:setupScreen(
		VIRTUAL_WIDTH,
		VIRTUAL_HEIGHT,
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
		{ fullscreen = false, resizable = true, vsync = true }
	)
end

function love.resize(w, h)
	push:resize(w, h)
end

function love.update(dt)
	backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
	groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

function love.keypressed(key)
	if key == "q" then
		love.event.quit()
	end
end

function love.draw()
	push:start()

	love.graphics.draw(background, -backgroundScroll, 0)
	love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
	love.graphics.draw(bird, 0, VIRTUAL_HEIGHT / 2 - BIRD_HEIGHT / 2)

	push:finish()
end
