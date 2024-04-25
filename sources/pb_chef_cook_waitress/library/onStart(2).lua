---- (2) ----
function strSplit(a, b)
    result = {}
    for c in (a .. b):gmatch("(.-)" .. b) do table.insert(result, c) end; return result
end

mfloor   = math.floor
mceil    = math.ceil
mmin     = math.min
mmax     = math.max
mrandom  = math.random
unitName = unit.getName()

function newStack()
    local o = {}
    o.entries = {}
    o.size = 0
    o.push = function(object)
        if object ~= nil then
            o.size = o.size + 1
            o.entries[o.size] = object
        end
    end
    o.pop = function()
        if o.size > 0 then
            o.size = o.size - 1
            return o.entries[o.size + 1]
        end
    end
    return o
end

function shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = mrandom(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end
