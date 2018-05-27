local function AsteroidMaker(def)
    local asteroidMaker = {
        asteroids = {},
    }

    asteroidMaker = Utils.include(asteroidMaker, Timer)

    local function makeAsteroid(params)
        local pointsNum = params.pointsNum or math.random(4, 10)
        -- The number of arguments for love.graphics.polygon should be even.
        pointsNum = pointsNum % 2 == 0 and pointsNum or pointsNum + 1

        table.insert(asteroidMaker.asteroids, Asteroid({
            x = params.x or math.random(10, WINDOW_WIDTH),
            y = params.y or math.random(10, WINDOW_HEIGHT),
            radius = params.radius or math.random(15, 60),
            velocity = params.velocity or math.random(40, 180),
            angle = params.angle or math.random(0, math.pi * 2 - 1) + math.random(),
            pointsNum = pointsNum,
        }))
    end

    local function makeAsteroids()
        for i = 1, math.random(7, 15) do
            makeAsteroid({})
        end
    end

    makeAsteroids()

    local function removeDestroyed(asteroids, i)
        local a = asteroids[i]
        if a and a.destroyed then
            table.remove(asteroids, i)
        end
    end
    local function isOffscreen(a)
        return a.x - a.radius > WINDOW_WIDTH or a.x < -a.radius or
            a.y - a.radius > WINDOW_HEIGHT or a.y < -a.radius
    end
    local function removeOffscreen(asteroids, i)
        local a = asteroids[i]
        if a and isOffscreen(a) then
            table.remove(asteroids, i)
        end
    end
    local function clearUnactive(asteroids, i)
        removeOffscreen(asteroids, i)
        removeDestroyed(asteroids, i)
    end

    local function getAsteroidParams()
        local radius = math.random(15, 60)
        local positions = {
            {
                x = math.random(radius, WINDOW_WIDTH),
                y = -radius,
                angle = math.random(math.pi / 2, (math.pi / 2) * 3),
            },
            {
                x = math.random(radius, WINDOW_WIDTH),
                y = WINDOW_HEIGHT + radius,
                angle = (math.random(1, 2) % 2) == 0 and
                    math.random((math.pi * 3) / 2, math.pi * 2) or math.random(0, math.pi / 2),
            },
            {
                x = -radius,
                y = math.random(radius, WINDOW_HEIGHT),
                angle = math.random(0, math.pi),
            },
            {
                x = WINDOW_WIDTH + radius,
                y = math.random(radius, WINDOW_HEIGHT),
                angle = math.random(math.pi, math.pi * 2),
            },
        }
        local params = positions[math.random(1, 4)]
        params.radius = radius

        return params
    end

    local function generateAsteroid()
        local t = asteroidMaker.timers.asteroidMakeTimeout
        if t and t > 0 then
            return
        end

        asteroidMaker:timeout(math.random(0.2, 0.5), 'asteroidMakeTimeout')
        makeAsteroid({}) -- getAsteroidParams()
    end

    function asteroidMaker:update(dt)
        self:updateTimers(dt)
        for i = #self.asteroids, 1, -1 do
            self.asteroids[i]:update(dt)
            clearUnactive(self.asteroids, i)
        end

        generateAsteroid()

        Event:dispatch('asteroids_update', self.asteroids)
    end

    function asteroidMaker:draw()
        for i = #self.asteroids, 1, -1 do
            self.asteroids[i]:draw(dt)
        end
    end

    return asteroidMaker
end

return AsteroidMaker
