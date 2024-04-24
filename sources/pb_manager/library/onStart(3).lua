---- (3) ----
function bruteFixWrongQuantity(inputs)
    for _, input_item in pairs(inputs) do
        if ignore_list[item.id] ~= true then
            if ingredients[input_item.id] == nil then
                ingredients[input_item.id] = { id = input_item.id, quantity = 0 }
                new = true
            end
            ---
            quantity = ingredients[input_item.id].quantity)
            -----
            local tName = string.lower(getName(item.id))
            if tName == nil then tName = "-=-" end
            local ms, me = tName:find("luminescent")
            if ms then
                local iiName = string.lower(getName(input_item.id))
                local ms2, me2 = iiName:find("advanced glass")
                if ms2 then
                    quantity = 1200
                    system.print(" >>> debug >>> " ..
                        tName .. ":" .. iiName .. ":" .. ingredients[input_item.id].quantity .. "=>" .. quantity)
                end
                local ms2, me2 = iiName:find("led")
                if ms2 then
                    quantity = 120
                    system.print(" >>> debug >>> " ..
                        tName .. ":" .. iiName .. ":" .. ingredients[input_item.id].quantity .. "=>" .. quantity)
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
                        quantity = 2400
                        system.print(" >>> debug >>> " ..
                            tName ..
                            ":" .. iiName .. ":" .. ingredients[input_item.id].quantity .. "=>" .. quantity)
                    end
                    local ms2, me2 = iiName:find("product")
                    if ms2 then
                        quantity = 2800
                        system.print(" >>> debug >>> " ..
                            tName ..
                            ":" .. iiName .. ":" .. ingredients[input_item.id].quantity .. "=>" .. quantity)
                    end
                end
            end
            ---
            if recurse == false then quantity = math.ceil(quantity * line_multiplier / num_lines) end
            if line_mins[input_item.id] then
                quantity = math.max(line_mins[input_item.id], quantity)
            end
            ---
            ingredients[input_item.id].quantity = math.max(quantity, ingredients[input_item.id].quantity)
            local hard_production_cap = 2 * 2800
            if ingredients[input_item.id].quantity ~= nil
                and ingredients[input_item.id].quantity > hard_production_cap then
                ingredients[input_item.id].quantity = math.min(hard_production_cap,
                    ingredients[input_item.id].quantity)
            end
        end
    end
end