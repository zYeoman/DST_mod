local _fun = {}

_fun.count = function(t)
    return #t
end

_fun.sum = function(t)
    local sum = 0
    for i, v in pairs(t) do
        sum = sum + v
    end
    return sum
end

_fun.avg = function(t)
    return _fun.sum(t) / _fun.count(t)
end

_fun.max = function(t)
    return math.max(unpack(t))
end

_fun.min = function(t)
    return math.min(unpack(t))
end

_fun.varp = function(t)
    local avg = _fun.avg(t)
    local sub = 0
    for i, v in pairs(t) do
        sub = sub + (v - avg) ^ 2
    end
    return sub / _fun.count(t)
end

_fun.stddevp = function(t)
    return math.sqrt(_fun.varp(t))
end
return _fun