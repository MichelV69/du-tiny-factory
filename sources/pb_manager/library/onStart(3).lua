---- (3) ----
function fixLumiGlassQty(item_id, input_item_id, ingredients)
    local tName = string.lower(getName(item_id))
    local quantity = 0

    if tName == nil then tName = "-=-" end
    local ms, me = tName:find("luminescent")
    if not ms then
        return quantity
    end

    local iiName = string.lower(getName(input_item_id))
    local ms2, me2 = iiName:find("advanced glass")
    if ms2 then
        quantity = 1200
        --- system.print(" >>> fixLumiGlassQty >>> " .. tName .. ":" .. iiName .. ":" .. ingredients[input_item_id].quantity .. "=>" .. quantity)
    end
    local ms2, me2 = iiName:find("led")
    if ms2 then
        quantity = 120
        --- system.print(" >>> fixLumiGlassQty >>> " .. tName .. ":" .. iiName .. ":" .. ingredients[input_item_id].quantity .. "=>" .. quantity)
    end
    return quantity
end

function fixHCPureQty(item_id, input_item_id, ingredients)
    hcTypes = { "aged", "galvanized", "glossy", "matte", "painted", "panel", "pattern", "polished",
        "stained" }
    hcPures = { "aluminium", "steel", "plastic", "carbon fiber" }

    local tName = string.lower(getName(item_id))
    local quantity = 0

    if tName == nil then tName = "-=-" end
    for _, hcType in pairs(hcTypes) do
        local ms, me = tName:find(string.lower(hcType))
        local ofConcern = false
        for _, hcPure in pairs(hcPures) do
            local ms1, me1 = tName:find(string.lower(hcPure))
            if ms1 then ofConcern = true end
        end

        if ms and ofConcern then
            local iiName = string.lower(getName(input_item_id))
            local ms2, me2 = iiName:find("pure")
            if ms2 then
                quantity = 2400
                --- system.print(" >>> fixHCPureQty >>> " .. tName .. ":" .. iiName .. ":" .. ingredients[input_item_id].quantity .. "=>" .. quantity)
            end
            local ms2, me2 = iiName:find("product")
            if ms2 then
                quantity = 2800
                ---system.print(" >>> fixHCPureQty >>> " .. tName ..  ":" .. iiName .. ":" .. ingredients[input_item_id].quantity .. "=>" .. quantity)
            end
        end
    end
    return quantity
end

function fixFuelStock(item_id, input_item_id, ingredients)
    local tName = string.lower(getName(item_id))
    local quantity = 0

    if tName == nil then tName = "-=-" end
    local ms, me = tName:find("fuel")
    if not ms then
        return quantity
    end

    system.print(" >>> ------ >>> ")
    fuelStocks = { "oxygen", "hydrogen" }
    for _, fuelStock in pairs(fuelStocks) do
        local iiName = string.lower(getName(input_item_id))
        local ms1, me1 = iiName:find(fuelStock)
        if ms1 then
            local fuelPerChemFactory = 88
            quantity                 = num_lines * fuelPerChemFactory
            system.print(" >>> fixFuelStock >>> " ..
                tName .. ":" .. iiName .. ":" .. ingredients[input_item_id].quantity .. "=>" .. quantity)
        end
    end
    return quantity
end

function bruteFixWrongQuantity(recurse, item_id, ingredients, inputs, line_multiplier, num_lines)
    local hard_production_cap = 2 * 2800

    for _, input_item in pairs(inputs) do
        new = false
        if ignore_list[item_id] == true then
            return ingredients
        end

        if ingredients[input_item.id] == nil then
            ingredients[input_item.id] = { id = input_item.id, quantity = 1 }
            new = true
        end
        ---
        quantity = ingredients[input_item.id].quantity
        -----
        quantity = math.max(quantity, fixLumiGlassQty(item_id, input_item.id, ingredients))
        quantity = math.max(quantity, fixHCPureQty(item_id, input_item.id, ingredients))
        quantity = math.max(quantity, fixFuelStock(item_id, input_item.id, ingredients))
        --- system.print(" >>> [quantity: " ..quantity .. "][ingredients.quantity: " .. ingredients[input_item.id].quantity .."]")

        ---
        if recurse == false then
            quantity = math.ceil(quantity * line_multiplier / num_lines)
        end
        if line_mins[input_item.id] then
            quantity = math.max(quantity, line_mins[input_item.id])
        end
        --- system.print(" >>> [quantity:" ..quantity .. "][ingredients.quantity:" .. ingredients[input_item.id].quantity .."]")
        --- system.print(" >>> ------------------- ")

        ---
        ingredients[input_item.id].quantity = math.max(quantity, ingredients[input_item.id].quantity)
        if ingredients[input_item.id].quantity ~= nil
            and ingredients[input_item.id].quantity > hard_production_cap then
            ingredients[input_item.id].quantity = math.min(hard_production_cap,
                ingredients[input_item.id].quantity)
        end
    end -- for pairs

    return ingredients
end
