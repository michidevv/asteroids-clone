local function Ship(def)
    local ship = {
        x = def.x,
        y = def.y,
        velocity = def.velocity or 0,
        acceleration = def.acceleration or 500,

        maxVelocity = def.maxVelocity or 300,

        angle = 0,
    }

    local isAccelerating = false
    local lasers = {}

    local function handleControl(self, dt)
        if love.keyboard.isDown('up') then
            isAccelerating = true
            if self.velocity < self.maxVelocity then
                self.velocity = self.velocity + self.acceleration * dt
            end
        end

        if love.keyboard.isDown('down') then
            if self.velocity > -self.maxVelocity then
                self.velocity = self.velocity - self.acceleration * dt
            end
        end

        if love.keyboard.isDown('left') then
            self.angle = (self.angle - 3 * dt) % (math.pi * 2)
        end

        if love.keyboard.isDown('right') then
            self.angle = (self.angle + 3 * dt) % (math.pi * 2)
        end

        if love.keyboard.keypressed['space'] then
            table.insert(lasers, Laser {
                x = self.x,
                y = self.y,
                angle = self.angle,
            })
        end
    end

    function ship:update(dt)
        isAccelerating = false
        handleControl(self, dt)

        local forceX, forceY = self:calculateForce()
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

        for i = #lasers, 1, -1 do
            lasers[i]:update(dt)
            if lasers[i].x < 0 or lasers[i].x > WINDOW_WIDTH or
                lasers[i].y < 0 or lasers[i].y > WINDOW_HEIGHT then
                table.remove(lasers, i)
            end
        end
    end

    function ship:draw()
        love.graphics.push()
        love.graphics.translate(self.x + 5, self.y - 10)
        love.graphics.rotate(self.angle)

        love.graphics.polygon('line', 0, -10, -7, 12, 0, 7, 7, 12)

        if isAccelerating then
            love.graphics.polygon('line', -3, 13, 3, 13, 0, 20)
        end

        love.graphics.pop()

        for i = 1, #lasers do
            lasers[i]:draw()
        end
    end

    return Utils.include(ship, Force)
end

return Ship
