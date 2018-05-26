local Utils = {
    include = function(target, mixin) -- Allow providing a list of mixins
        for k, v in pairs(mixin) do
            assert(target[k] == nil, '`target` contains duplicate key')
            target[k] = v
        end

        return target
    end,
}

return Utils
