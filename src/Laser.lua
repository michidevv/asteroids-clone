local function Laser(def)
    local laser = {
        x = def.x,
        y = def.y,
        velocity = def.velocity or 700,
        angle = def.angle,
        radius = def.radius or 2
    }

    function laser:update(dt)
        local forceX, forceY = self:calculateForce()
        self.x = self.x + (forceX * self.velocity) * dt
        self.y = self.y + (forceY * self.velocity) * dt

        Event:dispatch('laser_update', self)
    end

    function laser:draw()
        love.graphics.circle('line', self.x, self.y, self.radius)
    end

    return Utils.include(laser, Force)
end

return Laser
