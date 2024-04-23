-- PB_CHEF_LINECOOK_Waitress.LUA
---- (1) ----

unit.hideWidget()
chef_linecook_version = "1.2.2RC-2"

function adjustIndustryName(text)
    text = text:lower()
    split = strSplit(text, " ")
    text = split[2]
    for i = 3, 10 do
        if split[i] == nil then split[i] = "" end
        if split[i] == "xs" or split[i] == "s" or split[i] == "m" or split[i] == "l" or split[i] == "xl" then
            return text .. " " .. split[i]
        end
    end
    return text
end

function getStack(industryname)
    local entryStack = newStack()
    local isTransferUnit = (industryname == "unit l")

    if isTransferUnit then
        local added = {}
        for count = 1, 30 do
            local ikey = "needed" .. count
            if databank.hasKey(ikey) == 1 then
                local itemid = databank.getStringValue(ikey)
                if added[itemid] ~= true then
                    system.print("adding need to stack: " .. itemid)

                    local item = requirements[mfloor(tonumber(itemid))]
                    if item then
                        entryStack.push(item)
                        added[itemid] = true
                    end
                end
            end
            databank.clearValue(ikey)
        end
        if entryStack.size > 0 then return entryStack end
    end

    for id, item in pairs(requirements) do
        local known = getKnown(item.id) -- do we already know this item's proper industry?

        if isTransferUnit or (known == "" or known == industryname) then
            entryStack.push(item)
        end
    end
    return shuffle(entryStack)
end

function checkForOverproducing(slot, info)
    if info.state == 2 or info.state == 7 then
        local outputs = info.currentProducts
        local itemId = outputs[1].id
        local current = 0
        local maintain = 0

        if info.maintainProductAmount > 0 then
            maintain = mceil(info.maintainProductAmount)
        end

        if itemId and requirements[itemId] and maintain > (maintainMultiplier * requirements[itemId].quantity) then
            slot.stop(false, false)
        elseif itemId == nil or requirements[itemId] == nil then
            slot.stop(false, false)
        end
    end
end

complete = 0
functions = {}

functions.slot1 = function() doIndustry(slot1, functions.slot1) end
functions.slot2 = function() doIndustry(slot2, functions.slot2) end
functions.slot3 = function() doIndustry(slot3, functions.slot3) end
functions.slot4 = function() doIndustry(slot4, functions.slot4) end
functions.slot5 = function() doIndustry(slot5, functions.slot5) end
functions.slot6 = function() doIndustry(slot6, functions.slot6) end
functions.slot7 = function() doIndustry(slot7, functions.slot7) end
functions.slot8 = function() doIndustry(slot8, functions.slot8) end
functions.slot9 = function() doIndustry(slot9, functions.slot9) end
functions.slot10 = function() doIndustry(slot10, functions.slot10) end

cook_check = 0
function doIndustry(slot, f)
    if slot and slot.getLocalId and industries[slot.getLocalId()] then
        local industry = industries[slot.getLocalId()]
        local state = checkCooking(slot, industry, f)

        cook_check = cook_check + 1
        while cook_check < 10 do y(f) end -- wait for everyone do be done

        if state ~= 2 then doBuild(slot, industry, f) end
    else
        cook_check = cook_check + 1
    end
end

local stacks = {}
local cooking = {}
function checkCooking(slot, industry, f)
    local industryname = industry.name

    local info = slot.getInfo()
    local state = info.state

    if state == 2 then -- cooking something
        outputs = slot.getOutputs()
        if outputs and outputs[1] then
            cooking[outputs[1].id] = true
            --- system.print(industryname .. " cooking " .. getName(outputs[1].id))
            if industryname ~= "unit l" then setKnown(outputs[1].id, industry.name) end

            -- make sure we're not cooking too many, sometimes a bug will put in way too many
        end
    end
    checkForOverproducing(slot, info)

    return state
end

function doBuild(slot, industry, f)
    if industry == nil then return end

    local slotId = slot.getLocalId()
    local industryname = industry.name

    local info = slot.getInfo()
    local state = info.state
    local skip = false

    local stack
    if stacks[industryname] == nil or stacks[industryname].size == 0 then
        stacks[industryname] = getStack(industryname)
    end
    stack = stacks[industryname]

    -- system.print("Checking industry for " .. industryname .. " with stack size " .. stack.size .. " state: " .. state)

    while state ~= 2 and skip == false and stack.size > 0 do
        if state == 7 or state == 2 then skip = true end
        if state == 3 and industryname == "refiner m" then skip = true end

        if skip then
            system.print("Skipping " .. industryname .. " with state " .. state)
            return
        end

        local item = stack.pop()
        if item ~= nil then
            if state ~= 1 then -- no need to stop idle industry
                y(f)
                slot.stop(false, false)
            end

            y(f)
            slot.setOutput(item.id)

            -- ensure the output item is the wanted id
            y(f)
            local outputs = slot.getOutputs()
            if outputs and outputs[1] and outputs[1].id == item.id then
                y(f)
                slot.startMaintain(item.quantity * maintainMultiplier)
                system.print(industryname .. " maintaining " .. getName(item.id) .. " x" .. item.quantity)

                setKnown(industryname, item.id)
                -- get the new status, e.g. do we need schematics?
                y(f)
                local info = slot.getInfo()
                state = info.state
                if state == 2 or state == 6 or state == 7 then
                    cooking[outputs[1].id] = true
                end

                if industryname == "unit l" then
                    -- some items, e.g. basic pipes, need at least 200 for transfers
                    -- we need to let the other boards know this
                    local inputs = slot.getInputs()
                    if inputs[1].quantity > 1 then
                        databank.setIntValue("transfer:" .. item.id, mfloor(inputs[1].quantity))
                    end
                elseif unitname == "chef" and state == 3 then
                    local inputs = slot.getInputs()
                    local count = 0
                    for _, input_item in pairs(inputs) do
                        addNeed(input_item)
                    end
                end
                -- make sure we're not cooking too many, sometimes a bug will put in way too many
                checkForOverproducing(slot, info)
            end
        end
    end
end

needcount = 1
needs_added = {}
function addNeed(item)
    if needs_added[item.id] == true then return end
    while databank.hasKey("needed" .. needcount) == 1 and needcount < 30 do
        needcount = needcount + 1
    end
    if needcount <= 30 then
        databank.setStringValue("needed" .. needcount, item.id)
        system.print(needcount .. " Need: " .. item.id)
        needs_added[item.id] = true
    end
end

known_industry = {}
function getKnown(id)
    local key = "known:" .. id
    if known_industry[key] == nil or known_industry[key] == "" then
        known_industry[key] = databank.getStringValue(key)
    end
    return known_industry[key]
end

slot_status_saved = {}
function setKnown(industryname, id)
    local key = "known:" .. id
    if industryname ~= "unit l" and slot_status_saved[key] == nil then
        databank.setStringValue(key, industryname)
        known_industry[key] = industryname
        slot_status_saved[key] = true
    end
end

names = {}
function getName(id)
    if names[id] == nil then
        names[id] = system.getItem(id).locDisplayNameWithSize
    end
    return names[id]
end

pingkey = "ping:" .. unitName
function ping()
    databank.setIntValue(pingkey, mfloor(system.getArkTime()))
end

-- acutal execution starts here

databank = nil
industries = {}
status = {}
stacks = {}

for slot_name, slot in pairs(unit) do
    if type(slot) == "table" and type(slot.export) == "table" and slot.getClass then
        slotClass = slot.getClass():lower()

        if slotClass == 'databankunit' then
            databank = slot
        elseif slotClass:sub(0, 8) == "industry" then
            slotId = slot.getLocalId()
            industry = {
                id = slotId,
                slot = slot,
                name = adjustIndustryName(slot.getName())
            }
            industries[slotId] = industry
            -- table.insert(industries, industry)
        end
    end
end

for id, industry in pairs(industries) do
    databank.setStringValue("slot" .. industry.id, unitName)
end

databank.setStringValue("chef_linecook_version", chef_linecook_version)
databank.setStringValue("status:" .. unit.getName(), "active")

unitname = unit.getName():lower()
unitkey = unitname:gsub("%d$", "")
local raw = databank.getStringValue(unitkey)
if raw == "" then
    system.print("empty value for " .. unitkey)
    return unit.exit()
end

feed_multiplier = math.max(1.0, databank.getFloatValue("feed_multiplier"))
line_multiplier = math.max(1.0, databank.getFloatValue("line_multiplier"))
num_lines = math.max(1, databank.getIntValue("num_lines"))

if num_lines <= 0 then
    num_lines = 1
elseif num_lines > 1 then
    num_lines = mceil(num_lines / 1.25)
end
items = deserialize(databank.getStringValue(unit.getName():gsub("%d$", "")))
requirements = {}
local count = 0
for _, item in pairs(items) do
    if unitkey == "linecook" then
        local tu_quantity = databank.getIntValue("transfer:" .. item.id)
        tu_quantity = math.ceil(tu_quantity / num_lines)
        if tu_quantity > item.quantity then
            system.print("Transfer Unit upgrading " ..
            getName(item.id) .. " from " .. item.quantity .. " to " .. tu_quantity)
            item.quantity = tu_quantity
        end

        -- some items we should never have more than a few of, such as catalysts
        -- hardcode to restrict those item quantities
        if item.id == 3729464848     -- catalyst 3
            or item.id == 3729464849 -- catalyst 4
            or item.id == 3729464850 -- catalyst 5
        then
            item.quantity = math.min(item.quantity, 5)
        end
    end

    requirements[item.id] = item
    count = count + 1
    system.print(getName(item.id) .. " x" .. item.quantity)
end
if count == 0 then
    system.print("0 items to build - exiting")
    unit.exit()
    return
end

maintainMultiplier = 1
if unitName == "waitress" then
    maintainMultiplier = math.max(maintainMultiplier, feed_multiplier)
end

unit.setTimer("next", 1)
unit.setTimer("ping", 5)

-- do not change the following
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
function y(f) coroutine.yield(f) end
