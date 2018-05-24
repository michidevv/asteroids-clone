require('src/dependencies')

local ship = nil
local asteroids = {}
function love.load()
    math.randomseed(os.time())

    love.graphics.setDefaultFilter('nearest')
    love.window.setTitle('Asteroids Clone')

    ship = Ship({x = WINDOW_WIDTH / 2 - 15, y = WINDOW_HEIGHT / 2 + 45,})
    for i = 1, math.random(7, 15) do
        local pointsNum = math.random(4, 10)
        pointsNum = pointsNum % 2 == 0 and pointsNum or pointsNum + 1

        table.insert(asteroids, Asteroid({
            x = math.random(10, WINDOW_WIDTH),
            y = math.random(10, WINDOW_HEIGHT),
            radius = math.random(30, 60),
            velocity = math.random(20, 100),
            angle = math.random(0, math.pi * 2 - 1) + math.random(),
            pointsNum = pointsNum,
        }))
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    for i = 1, #asteroids do
        asteroids[i]:update(dt)
    end

    ship:update(dt)
end

function love.draw()
    for i = 1, #asteroids do
        asteroids[i]:draw(dt)
    end

    ship:draw()
end
