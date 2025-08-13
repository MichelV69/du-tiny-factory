---- (1) ----
unit.hideWidget()
screen_version = "1.2.3a"

functions = {}
functions.iterate = function()
    iterations = 0
    elementsIdList = core.getElementIdList()
    unSorted = {}

    for index, id in ipairs(elementsIdList) do
        local class = core.getElementClassById(id):sub(0, 8):lower()
        local name = getName(core.getElementItemIdById(id), true)
        if class == "industry" then
            info = core.getElementIndustryInfoById(id)
            local outputs = info.currentProducts
            if outputs and outputs[1] and outputs[1].id then
                local itemId = outputs[1].id
                local current = 0
                local maintain = 0
                local itemname = getName(itemId, false)
                local state = info.state
                system.print(state .. " - " .. itemname)

                if false and state ~= UNIT_WORKING and (manager_items[itemId] == nil and manager_items["" .. itemID] == nil) and (linecook_items[itemId] == nil and linecook_items["" .. itemId] == nil) then
                    -- this machine is doing nothing that we care about, so ignore it
                else
                    if info.currentProductAmount > 0 then
                        current = mceil(info.currentProductAmount)
                        if current > 99999 then
                            current = mfloor(current / 16777216)
                        end
                    end
                    if info.maintainProductAmount > 0 then
                        maintain = mceil(info.maintainProductAmount)
                    end

                    if state == UNIT_STOPPED then
                        state = "`I"
                    elseif state == UNIT_WORKING then
                        state = "`R"
                    elseif state == UNIT_JAMMED then
                        state = "`W"
                    elseif state == UNIT_FULL_STORAGE or state == UNIT_BAD_CFG then
                        state = "`J"
                    elseif state == UNIT_WAITING then
                        state = "`P"
                    elseif state == UNIT_NO_SCHEMAS then
                        state = "!!"
                    else
                        state = "?UNKNOWN?"
                    end

                    local currentLineID = getLine(id)
                    if currentLineID ~= "" then
                        table.insert(unSorted,
                            currentLineID
                            .. "," .. name
                            .. "," .. state
                            .. "," .. current
                            .. "," .. maintain
                            .. "," .. itemname
                        )
                    end
                end
            end
        end

        iterations = iterations + 1
        if iterations >= 50 then
            iterations = 0
            -- coroutine.yield(functions.iterate)
        end
    end

    --- screen display by priority START ---
    local screenRows = {}
    screenRows['white'] = {}
    screenRows['green'] = {}
    screenRows['yellow'] = {}
    screenRows['red'] = {}

    for _, text in pairs(unSorted) do
        split = stringToTable(text, ",")
        local typicalData = true
        if split[3] == "`R" then
            table.insert(screenRows.green, text)
            typicalData = false
        end
        if split[3] == "!!" or split[3] == "`J" then
            table.insert(screenRows.yellow, text)
            typicalData = false
        end
        if split[2] == "Refiner" and split[3] == '`W' then
            table.insert(screenRows.red, text)
            typicalData = false
        end
        if typicalData then table.insert(screenRows.white, text) end
    end

    table.sort(screenRows.red)
    table.sort(screenRows.yellow)
    table.sort(screenRows.green)
    table.sort(screenRows.white)

    shuffledWhite = {}
    for i, record in ipairs(screenRows.white) do
        local pos = math.random(1, #shuffledWhite + 1)
        table.insert(shuffledWhite, pos, record)
    end

    local priorityTable = {}
    for _, data in pairs(screenRows.red) do
        table.insert(priorityTable, data)
    end
    for _, data in pairs(screenRows.yellow) do
        table.insert(priorityTable, data)
    end
    for _, data in pairs(screenRows.green) do
        table.insert(priorityTable, data)
    end
    for _, data in pairs(shuffledWhite) do
        table.insert(priorityTable, data)
    end
    --- screen display by priority END ---

    output = ""
    header_block = ""
    total = 0
    eol = "\n"

    header_block = manager_version .. eol .. num_lines .. eol .. feed_multiplier .. eol
    header_block = header_block .. line_multiplier .. eol .. #unSorted .. eol
    header_block = header_block .. factory_desc .. eol

    output = header_block
    message_size_left = 1024 - #header_block

    for i, line in pairs(priorityTable) do
        local len = string.len(line) + 1
        if total + len <= message_size_left then
            output = output .. line .. eol
            total = total + len
        end
    end

    if output == "" then output = " ... pending ... " end
    screen.activate()
    screen.setScriptInput(output)
    system.print("output set")
end

lines = {}
function getLine(id)
    if lines[id] == nil or lines[id] == "" then
        lines[id] = databank.getStringValue("slot" .. id)
        lines[id] = lines[id]:gsub("linecook", "||")
    end
    return lines[id]
end

function ping()
    databank.setIntValue(pingkey, mfloor(system.getArkTime()))
end

pingkey = "ping:" .. unit.getName()
unit.setTimer("ping", 10)

screen.setScriptInput(" ... pending ... ")
screen.activate()

databank.setStringValue("screen_version", screen_version)

manager_items = deserialize(databank.getStringValue("chef"))
linecook_items = deserialize(databank.getStringValue("linecook"))

feed_multiplier = math.max(1.0, databank.getFloatValue("feed_multiplier"))
line_multiplier = math.max(1.0, databank.getFloatValue("line_multiplier"))
num_lines = math.max(1, databank.getIntValue("num_lines"))
manager_version = databank.getStringValue("manager_version")
factory_desc = databank.getStringValue("factory_desc")

-- do not change the below
nestco = {}
function nestco:new(a)
    local b = {}
    setmetatable(b, self)
    self.__index = self; b.functions = a or {}
    b.coroutines = {}
    function b.update() return b:_update() end; function b.init() return b:_init() end; function b.run() return b:_run() end; function b.update() return
        b:_update() end; b.init()
    b.main = coroutine.create(b.run)
    return b
end; function nestco:_init() for c, d in pairs(self.functions) do self.coroutines[c] = coroutine.create(d) end end; function nestco:_run() for c, e in pairs(self.coroutines) do
        local f = coroutine.status(e)
        if f == "dead" then self.coroutines[c] = coroutine.create(self.functions[c]) elseif f == "suspended" then assert(
            coroutine.resume(e)) end
    end end; function nestco:_update()
    local f = coroutine.status(self.main)
    if f == "dead" then self.main = coroutine.create(self.run) elseif f == "suspended" then assert(coroutine.resume(self
        .main)) end
end

NestCo = nestco:new(functions)
unit.setTimer("update", 1)
-- do not chang the above
