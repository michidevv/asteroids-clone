local function Ship(def)
    local ship = {
        x = def.x,
        y = def.y,
        velocity = def.velocity or 0,
        acceleration = def.acceleration or 150,

        direction = 0,
    }

    local function calculateForce()
        local dir = ship.direction - math.pi / 2
        local x = math.cos(dir)
        local y = math.sin(dir)

        return x, y
    end

    function ship:update(dt)
        if love.keyboard.isDown('up') then
            if self.velocity < 200 then
                self.velocity = self.velocity + self.acceleration * dt
            end
        end

        if love.keyboard.isDown('down') then
            if self.velocity > -200 then
                self.velocity = self.velocity - self.acceleration * dt
            end
        end

        if love.keyboard.isDown('left') then
            self.direction = (self.direction - 2 * dt) % (math.pi * 2)
        end

        if love.keyboard.isDown('right') then
            self.direction = (self.direction + 2 * dt) % (math.pi * 2)
        end

        local forceX, forceY = calculateForce()
        self.x = self.x + (forceX * self.velocity) * dt
        self.y = self.y + (forceY * self.velocity) * dt

        if self.x > WINDOW_WIDTH then
            self.x = 0 - 20
        elseif self.x + 20 < 0 then
            self.x = WINDOW_WIDTH - 20
        elseif self.y > WINDOW_HEIGHT then
            self.y = 0 - 20
        elseif self.y + 20 < 0 then
            self.y = WINDOW_HEIGHT
        end
    end

    function ship:draw()
        love.graphics.push()
        love.graphics.translate(self.x + 5, self.y - 10)
        love.graphics.rotate(self.direction)

        love.graphics.polygon('line', 0, -10, -7, 12, 0, 7, 7, 12)

        love.graphics.pop()
    end

    return ship
end

return Ship
