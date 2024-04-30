---- (3) ----
IndustryStatus              = {}
IndustryStatus.stopped      = 1
IndustryStatus.running      = 2
IndustryStatus.jammed       = 3
IndustryStatus.storage_full = 4
IndustryStatus.bad_cfg      = 5
IndustryStatus.pending      = 6
IndustryStatus.no_schemas   = 7

function isATransferUnit(industryname)
    local isATransferUnit = false
    if industryname == "unit l" or
        industryname == "waitress" then
        isATransferUnit = true
    end
    return isATransferUnit
end

function isNotATransferUnit(industryname)
    return (not isATransferUnit(industryname))
end
