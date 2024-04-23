for name, switch in pairs(buttons) do
    if switch.isActive() == false then
        while switch.isActive() == false do switch.activate() end
        return
    end
end
