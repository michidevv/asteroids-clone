local Force = {
    calculateForce = function(self)
        local dir = self.angle - math.pi / 2
        local x = math.cos(dir)
        local y = math.sin(dir)

        return x, y
    end
}

return Force
