require('src/dependencies')

local ship = nil
local asteroids = {}
function love.load()
    math.randomseed(os.time())

    love.window.setTitle('Asteroids Clone')
    love.graphics.setDefaultFilter('nearest')
    WINDOW_WIDTH, WINDOW_HEIGHT = love.graphics.getDimensions()

    ship = Ship({x = WINDOW_WIDTH / 2, y = WINDOW_HEIGHT / 2,})
    asteroidMaker = AsteroidMaker()

    love.keyboard.keypressed = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keypressed[key] = true
end

function love.update(dt)
    asteroidMaker:update(dt)
    ship:update(dt)

    love.keyboard.keypressed = {}
end

function love.draw()
    asteroidMaker:draw()
    ship:draw()
end
