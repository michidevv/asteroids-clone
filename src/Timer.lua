local Timer = {
    timers = {},

    timeout = function (self, timer, key)
        assert(key ~= nil, 'Should provide timeout property value')
        self.timers[key] = timer
    end,

    updateTimers = function (self, dt)
        for k, v in pairs(self.timers) do
            if v > 0 then
                self.timers[k] = v - dt
            end
        end
    end
}

return Timer
