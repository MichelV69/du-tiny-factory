---- (2) ----
mceil = math.ceil
mfloor = math.floor

core = nil
databank = nil
screen = nil
industries = {}
lights = {}

for slot_name, slot in pairs(unit) do
    if type(slot) == "table" and type(slot.export) == "table" and slot.getClass then
        slotClass = slot.getClass():lower()
        if slotClass:sub(0, 8) == "coreunit" then
            core = slot
            -- system.print("core found")
        elseif slotClass == "databankunit" then
            databank = slot
            -- system.print("databank found")
        elseif slotClass:sub(0, 8) == "industry" then
            slotId = slot.getLocalId()
            industry = {
                id = slotId,
                slot = slot
            }
            table.insert(industries, industry)
        elseif slotClass == "lightunit" then
            system.print(slotClass .. " " .. slot.getName())
            lights[slot.getName()] = slot
        elseif slotClass == "screenunit" then
            screen = slot
            slot.activate()
            -- system.print("screen found")
        elseif slotClass == "manualswitchunit" then
            local name = slot.getName()
            buttons[name] = slot

            button_names[button_count] = name
            button_count = button_count + 1

            slot.deactivate()
        end
    end
end

names = {}
function getName(id, isIndustry)
    if id == nil then return "nil Id" end
    if names[id] == nil then
        name = system.getItem(id).locDisplayNameWithSize
        name = name:gsub(" xs$", " XS")
        name = name:gsub(" s$", " S")
        name = name:gsub(" m$", " M")
        name = name:gsub(" l$", " L")
        name = name:gsub(" xl$", " XL")
        name = name:gsub(" product$", " Product")
        name = name:gsub(" industry ", " I ")
        name = name:gsub(" Industry ", " I ")

        if isIndustry then
            name = name:gsub("^Basic ", "")
            name = name:gsub("^Uncommon ", "")
            name = name:gsub("^Advanced ", "")
            name = name:gsub(" M$", "")
            name = name:gsub(" I$", "")
        else
            --[[name = name:gsub("^Basic ", "B. ")
            name = name:gsub("^Uncommon ", "U. ")
            name = name:gsub("^Advanced ", "A. ")]]
        end

        names[id] = name
    end
    return names[id]
end
