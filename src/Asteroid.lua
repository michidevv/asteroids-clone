local function Asteroid(def)
    local asteroid = {
        x = def.x,
        y = def.y,
        velocity = def.velocity,
        radius = def.radius,
        angle = def.angle,
        pointsNum = def.pointsNum,
    }

    local offsets = {}
    for i = 1, asteroid.pointsNum do
        offsets[i] = math.random(-15, 15)
    end

    local function makeShape()
        local mapped = {}
        for i = 1, asteroid.pointsNum do
            local angle = (i * 2 * math.pi) / asteroid.pointsNum
            local x = asteroid.radius * math.cos(angle)
            local y = asteroid.radius * math.sin(angle)
            -- mapped[i] = {asteroid.x + x, asteroid.y + y}
            table.insert(mapped, asteroid.x + x + offsets[i])
            table.insert(mapped, asteroid.y + y + offsets[i])
        end

        return unpack(mapped)
    end

    function asteroid:update(dt)
        self.x = self.x + (math.cos(self.angle) * self.velocity) * dt
        self.y = self.y + (math.sin(self.angle) * self.velocity) * dt

        -- if self.x > WINDOW_WIDTH then
        --     self.x = 0 - self.radius * 2
        -- elseif self.x + self.radius * 2 < 0 then
        --     self.x = WINDOW_WIDTH - self.radius * 2
        -- elseif self.y > WINDOW_HEIGHT then
        --     self.y = 0 - self.radius * 2
        -- elseif self.y + self.radius * 2 < 0 then
        --     self.y = WINDOW_HEIGHT
        -- end
    end

    function asteroid:draw()
        love.graphics.polygon('line', makeShape())

        -- UFO polygon
        -- love.graphics.polygon('line',
        --     self.x - 6, self.y + 10,
        --     self.x + 6, self.y + 10,

        --     self.x + 10, self.y + 5,
        --     self.x - 10, self.y + 5
        -- )
        -- love.graphics.polygon('line',
        --     self.x + 10, self.y + 5,
        --     self.x - 10, self.y + 5,

        --     self.x - 5, self.y,
        --     self.x + 5, self.y
        -- )
        -- love.graphics.polygon('line',
        --     self.x - 5, self.y,
        --     self.x + 5, self.y,

        --     self.x + 3, self.y - 5,
        --     self.x - 3, self.y - 5
        -- )
    end

    return asteroid
end

return Asteroid
