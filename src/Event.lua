local Event = {
    events = {},
}

function Event:dispatch(event, ...)
    local listeners = self.events[event]
    if listeners ~= nil and #listeners > 0 then
        for i = #listeners, 1, -1 do
            listeners[i](...)
        end
    end
end

function Event:unsubscribe(event, cb)
    local listeners = self.events[event]
    if not listeners or #listeners == 0 then
        return
    end

    for i, v in ipairs(listeners) do
        if v == cb then
          -- listeners[i] = nil -- TODO: Investigate
          table.remove(listeners, i)
        end
    end
end

function Event:subscribe(event, cb)
    local listeners = self.events[event] or {}
    table.insert(listeners, cb)
    self.events[event] = listeners

    -- Return unsubscribe function.
    return function() self:unsubscribe(event, cb) end
end

return Event
