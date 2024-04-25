---- (2) ----
function clean(param)
    if param == nil then return " " end
    return param
end

function out(a, b, c, d)
    system.print(clean(a) .. " " .. clean(b) .. " " .. clean(c) .. " " .. clean(d))
end

function getName(id)
    if id == nil then return "nil Id" end
    if names[id] == nil then
        name = system.getItem(id).locDisplayNameWithSize
        name = name:gsub(" xs$", " XS")
        name = name:gsub(" s$", " S")
        name = name:gsub(" m$", " M")
        name = name:gsub(" l$", " L")
        name = name:gsub(" xl$", " XL")
        name = name:gsub(" product$", " Product")
        names[id] = name
    end
    return names[id]
end

function getPrimaryIngredients(item_id)
    local recipes = system.getRecipes(item_id)
    if not recipes[1] then return {} end

    local primary_ingredients = {}
    local max_produced = 0
    for _, recipe in pairs(recipes) do
        for __, output_item in pairs(recipe.products) do
            if output_item.id == item_id and output_item.quantity > max_produced then
                primary_ingredients = recipe.ingredients
                max_produced = output_item.quantity
            end
        end
    end
    return primary_ingredients
end
