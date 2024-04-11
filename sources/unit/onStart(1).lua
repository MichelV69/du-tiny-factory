-- PB_MANAGER.LUA

unit.hideWidget()
manager_version = "1.2.1f"

items = {}
line_mins = {}
line_mins[2240749601] = 300 -- pure aluminum
line_mins[159858782] = 300  -- pure carbon
line_mins[198782496] = 300  -- pure iron
line_mins[2589986891] = 300 -- pure silicon

line_mins[2112763718] = 200 -- pure calcium
line_mins[2147954574] = 200 -- pure chromium
line_mins[1466453887] = 200 -- pure copper
line_mins[3603734543] = 200 -- pure sodium

line_mins[3810111622] = 100 -- pure lithium
line_mins[3012303017] = 100 -- pure nickel
line_mins[1807690770] = 100 -- pure silver
line_mins[3822811562] = 100 -- pure sulfur

dont_assign = {             -- list of raw minerals, these can't be produced, so they need to be ignored
    299255727,              -- coal
    4234772167,             -- hematite
    262147665,              -- bauxite
    3724036288,             -- quartz

    2029139010,             -- chromite
    3086347393,             -- limestone
    2289641763,             -- malachite
    343766315,              -- natron

    1050500112,             -- acanthite
    1065079614,             -- garnierette
    3837858336,             -- petalite
    4041459743,             -- pyrite

    3546085401,             -- cobaltite
    1467310917,             -- cryolite
    1866812055,             -- gold nuggets
    271971371,              -- kolbeckite

    789110817,              -- columbite
    629636034,              -- ilmenite
    3934774987,             -- rhodonite
    2162350405,             -- vanadinite
}

ignore_list = {} -- will be populated by the dont_assign list

function next()
    time = math.floor(system.getArkTime())

    out("status checking... ", time)

    for name, slot in pairs(buttons) do
        timeping = databank.getIntValue("ping:" .. name)
        if (time - timeping) > 30 then
            while slot.isActive() == 1 do slot.deactivate() end
            databank.clearValue("status:" .. name)
            out("toggling", name)
        end -- turn it off, let the buttonOn timer turn it back on
    end
end

function getIngredients(items, base, recurse)
    local new = false

    if base == nil then base = {} end
    local ingredients = base
    if recurse then ingredients = items end

    repeat
        new = false
        for _, item in pairs(items) do
            local item_id = item.id

            -- determine what we will need to build the item
            local recipes = system.getRecipes(item_id)
            local inputs = getPrimaryIngredients(item_id)
            local time_multiplier = 1

            if recipes and recipes[1] then
                local recipe = recipes[1]
                time_multiplier = math.ceil(300 / recipe.time) -- lua recipe.time is base time, but skills might allow you to make much more in less time, try to accomodate this

                for _, input_item in pairs(inputs) do
                    if ignore_list[item.id] ~= true then
                        if ingredients[input_item.id] == nil then
                            ingredients[input_item.id] = { id = input_item.id, quantity = 0 }
                            new = true
                        end

                        quantity = math.ceil(math.max(input_item.quantity * time_multiplier,
                            ingredients[input_item.id].quantity))

                        if recurse == false then quantity = math.ceil(quantity * line_multiplier / num_lines) end
                        if line_mins[input_item.id] then
                            quantity = math.max(line_mins[input_item.id], quantity)
                        end
                        ingredients[input_item.id].quantity = math.max(quantity, ingredients[input_item.id].quantity)

                        -----
                        local tName = string.lower(getName(item.id))
                        if tName == nil then tName = "-=-" end
                        local boostLevel = 1.22
                        local ms, me = tName:find("luminescent")
                        if ms then
                            local iiName = string.lower(getName(input_item.id))
                            local ms2, me2 = iiName:find("advanced glass")
                            if ms2 then
                                quantity = math.ceil(quantity * boostLevel)
                                system.print(" >>> debug >>> " ..
                                    tName ..
                                    ":" .. iiName .. ":" .. ingredients[input_item.id].quantity .. "=>" .. quantity)
                            end
                            local ms2, me2 = iiName:find("led")
                            if ms2 then
                                quantity = math.ceil(quantity * boostLevel)
                                system.print(" >>> debug >>> " ..
                                    tName ..
                                    ":" .. iiName .. ":" .. ingredients[input_item.id].quantity .. "=>" .. quantity)
                            end
                        end

                        hcTypes = { "aged", "galvanized", "glossy", "matte", "painted", "panel", "pattern", "polished",
                            "stained" }
                        hcPures = { "aluminium" }
                        for _, hcType in pairs(hcTypes) do
                            local ms, me = tName:find(string.lower(hcType))
                            local ofConcern = false
                            for _, hcPure in pairs(hcPures) do
                                local ms1, me1 = tName:find(string.lower(hcPure))
                                if ms1 then ofConcern = true end
                            end

                            if ms and ofConcern then
                                local iiName = string.lower(getName(input_item.id))
                                local ms2, me2 = iiName:find("pure")
                                if ms2 then
                                    quantity = math.ceil(quantity * boostLevel)
                                    system.print(" >>> debug >>> " ..
                                        tName ..
                                        ":" .. iiName .. ":" .. ingredients[input_item.id].quantity .. "=>" .. quantity)
                                end
                                local ms2, me2 = iiName:find("product")
                                if ms2 then
                                    quantity = math.ceil(quantity * boostLevel)
                                    system.print(" >>> debug >>> " ..
                                        tName ..
                                        ":" .. iiName .. ":" .. ingredients[input_item.id].quantity .. "=>" .. quantity)
                                end
                            end
                        end

                        local hard_production_cap = 3200
                        ingredients[input_item.id].quantity = math.min(ingredients[input_item.id].quantity,
                            hard_production_cap)
                    end
                end
            end
        end
    until (recurse == false or new == false)

    return ingredients
end

function addBuild(id, quantity, is_input)
    if id == nil or quantity == nil then
        out("id or quantity can not be nil", id, quantity)
        return
    end
    local new = false
    local key = "" .. id

    if builds[key] == nil then
        builds[key] = { id = id }
        new = true
    end
    builds[key].quantity = math.ceil(quantity)

    return new
end

function saveTable(name, table)
    databank.clearValue(name)
    local raw = serialize(table)
    databank.setStringValue(name, raw)
    if databank.getStringValue(name) ~= raw then
        out("Unable to save to databank")
        unit.exit()
    end
end

databank = nil
buttons = {}
names = {}
builds = {}
activated = {}
screen = nil
button_names = {}

for slot_name, slot in pairs(unit) do
    if type(slot) == "table" and type(slot.export) == "table" and slot.getClass then
        slotClass = slot.getClass():lower()
        if slotClass == 'databankunit' then
            databank = slot
        elseif slotClass:sub(0, 8) == "industry" then
            slotId = slot.getLocalId()
            industry = {
                id = slotId,
                slot = slot
            }
            table.insert(industries, industry)
        elseif slotClass == "manualswitchunit" then
            buttons[slot.getName()] = slot
            table.insert(button_names, slot.getName())
        end
    end
end

feed_multiplier = math.max(1.0, databank.getFloatValue("feed_multiplier"))
line_multiplier = math.max(1.0, databank.getFloatValue("line_multiplier"))
num_lines = math.max(1, databank.getIntValue("num_lines"))

databank.setStringValue("manager_version", manager_version)

orders = deserialize(databank.getStringValue("orders"))
if orders == "" then orders = {} end
for id, quantity in pairs(orders) do
    items[tonumber(id)] = quantity
end
orders = nil

for name, slot in pairs(buttons) do
    slot.deactivate()
    if databank then databank.clearValue("status:" .. name) end
end

for _, id in pairs(dont_assign) do
    databank.setStringValue("industry:" .. id, "-")
    databank.setStringValue("known:" .. id, "-")
    ignore_list[id] = true
end

for id, qty in pairs(items) do
    addBuild(id, qty, "false")
end

-- save the main builds
saveTable("chef", builds)

-- all items added, now determine immediate ingredients to build each item
ingredients = getIngredients(builds, {}, false)
saveTable("waitress", ingredients)

-- immediate ingredients added, now determine all ingredients needed to build ingredients and required items
ingredients = getIngredients(ingredients, ingredients, true)
saveTable("linecook", ingredients)

unit.setTimer("buttonsOn", 2.5)
unit.setTimer("next", 20)

--- eof unit.onStart(1).lua ---
