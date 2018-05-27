local function Asteroid(def)
    local asteroid = {
        x = def.x,
        y = def.y,
        velocity = def.velocity,
        radius = def.radius,
        angle = def.angle,
        pointsNum = def.pointsNum,

        destroyed = false,
    }

    local offsets = {}
    for i = 1, asteroid.pointsNum do
        offsets[i] = math.random(-12, 12)
    end

    local function onLaserUpdate(l)
        if asteroid:collides(l) then
            asteroid.destroyed = true
            Event:unsubscribe('laser_update', onLaserUpdate)
        end
    end

    Event:subscribe('laser_update', onLaserUpdate)

    local function getShape()
        local mapped = {}
        for i = 1, asteroid.pointsNum do
            local angle = (i * 2 * math.pi) / asteroid.pointsNum
            local x = asteroid.radius * math.cos(angle)
            local y = asteroid.radius * math.sin(angle)
            -- mapped[i] = {asteroid.x + x, asteroid.y + y}
            table.insert(mapped, asteroid.x + x + offsets[i])
            table.insert(mapped, asteroid.y + y + offsets[i])
        end

        return mapped
    end

    function asteroid:getBounds()
        local shape = getShape()
        local xPoints = {}
        local yPoints = {}
        for i = 1, #shape do
            if i % 2 == 0 then
                table.insert(yPoints, shape[i])
            else
                table.insert(xPoints, shape[i])
            end
        end

        return {
            xMin = math.min(unpack(xPoints)),
            yMin = math.min(unpack(yPoints)),
            xMax = math.max(unpack(xPoints)),
            yMax = math.max(unpack(yPoints)),
        }
    end

    -- TODO: Move out.
    local function clamp(value, min, max)
        if value < min then
            value = min
        elseif value > max then
            value = max
        end

        return value
    end

    function asteroid:collides(other)
        local b = self:getBounds()
        local closestX = clamp(other.x, b.xMin, b.xMax)
        local closestY = clamp(other.y, b.yMin, b.yMax)
        local dX = other.x - closestX
        local dY = other.y - closestY

        return (dX * dX + dY * dY) < (other.radius * other.radius)
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
        if not self.destroyed then -- TODO: Update
            love.graphics.polygon('line', unpack(getShape()))
        end

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
