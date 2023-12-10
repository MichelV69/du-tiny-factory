--- -
local colHeaders = {"Load Ore", " ", " ", " ", "Elements ", "Honeycomb"}  --bottom row Hub labels
local fontSize = 14 --on-screen font size
local topMargin = 22 --don't change at random
local custom_col_header_yPos = -1 --don't change at random
--- -
local rslib = require('rslib')
if not init then
    rx, ry = getResolution()
    init = true
end

local config = { fontSize = fontSize}
local fontHeaderSize = fontSize+2
local font = loadFont('RobotoMono', fontSize)
local fontHeader = loadFont('RobotoMono', fontHeaderSize)
local l = {}
l.data = createLayer()
l.banner = createLayer()


DEFAULT_COL_HEADER_YPOS = 511
local y_pos = DEFAULT_COL_HEADER_YPOS
if custom_col_header_yPos ~= -1 then y_pos = custom_col_header_yPos end

local x_width = rx / #colHeaders+1
local x_pad = x_width / -2

for colNo, thisHeader in ipairs(colHeaders) do
    local backCenter = #thisHeader * fontHeaderSize / 2
    addText(l.banner, fontHeader, thisHeader, x_pad + (x_width * colNo) - backCenter, y_pos, 0)
    end

--- -
function stringToTable(a,b)result={} for c in(a..b):gmatch("(.-)"..b) do table.insert(result,c) end; return result end

function pad(text, pad)
    if pad == nil then return text end
    if pad < 0 then
        pad = math.abs(pad)
        while string.len(text) < pad do text = " " .. text end
    elseif pad > 0 then
        while string.len(text) < pad do text = text .. " " end
    end
    return text
end

function ToColor(w,x,y,z) return {r = w, g = x, b = y, o = z} end

names = {}
function fixText(text)
    if names[text] == nil then
        text = text:gsub("%B ", "Basic ")
        text = text:gsub(" I ", " Industry ")
        text = text:gsub(" S ", " Smelter ")
        text = text:gsub(" E ", " Electronics ")
        text = text:gsub(" 3 ", " 3d ")
        text = text:gsub(" R ", " Refiner ")
        text = text:gsub(" P ", " Printer ")
        text = text:gsub(" M ", " Metalwork ")
        text = text:gsub("TU " , "Transfer Unit ")
        text = text:gsub(" AL ", " Assembly Line ")

        text = text:gsub("`I", "Cycling")
        text = text:gsub("`R", "Running")
        text = text:gsub("`W", "Cycling")
        text = text:gsub("`J", "JAMMED!")
        text = text:gsub("`P", "Cycling")
        text = text:gsub("!!", "!SCHEMATICS!")

        names[text] = text
    end
    return names[text]
end
function getPixelWidth(text)
  local HvW = 0.85
  return (HvW * #text * fontSize)
end

local xcoords = {}
xcoords[1] = getPixelWidth("123")
xcoords[2] = xcoords[1] + getPixelWidth("waitress009")
xcoords[3] = xcoords[2] + getPixelWidth("honeycomb refinery")
xcoords[4] = xcoords[3] + getPixelWidth("running")
xcoords[5] = xcoords[4] + getPixelWidth("123456")
xcoords[6] = xcoords[5] + getPixelWidth("123456")

local padding = {}
padding[1] = -5
padding[4] = -5
padding[5] = -5
-- padding[6] = -5

local white = ToColor(1, 1, 1, 1)
local red = ToColor(1, 0, 0, 1)
local green = ToColor(0, 1, 0, 1)
local yellow = ToColor(1,1,0,1)

local goldenRatio = 1.61803399
local grUsed = (goldenRatio - 1) /2

local incomingScreenData = {}
incomingScreenData = stringToTable(getInput(), "\n")

local encapData = {}
encapData.manager_version = incomingScreenData[1]
encapData.num_lines       = incomingScreenData[2]
encapData.feed_multiplier = incomingScreenData[3]
encapData.line_multiplier = incomingScreenData[4]
encapData.industry_elements = incomingScreenData[5]
encapData.factory_desc = incomingScreenData[6]
encapData.size = 6

if #incomingScreenData > encapData.size then
    for i = encapData.size,1,-1 do
      table.remove(incomingScreenData, i)
      end
    end

if encapData.manager_version   == nil then encapData.manager_version   = -1 end
if encapData.num_lines         == nil then encapData.num_lines         = 1 end
if encapData.feed_multiplier   == nil then encapData.feed_multiplier   = 1 end
if encapData.line_multiplier   == nil then encapData.line_multiplier   = 1 end
if encapData.industry_elements == nil then encapData.industry_elements = 1 end

color = white
setNextFillColor(l.data, color.r, color.g, color.b, color.o)
setNextFillColor(l.banner, color.r, color.g, color.b, color.o)
local rowCount = 1

y = rowCount * (fontSize + (fontSize * grUsed)) + topMargin
topLine = "[Manager v" .. encapData.manager_version .. "] [Configured Lines:" .. encapData.num_lines .. "]"
topLine = topLine .. " [TF Controlled Machines: " .. encapData.industry_elements .. "]"
topLine = topLine .. " [Feed X" .. encapData.feed_multiplier .. "] [Line X" .. encapData.line_multiplier  .. "]"
addText(l.banner, fontHeader, topLine, xcoords[1], y, AlignH_Center, AlignV_Middle, ToColor(0.5, 0.5, 0.5, 0.5))

rowCount = rowCount + 1
y = rowCount * (fontSize + (fontSize * grUsed)) + topMargin
topLine = "[Sub-Factory Description: " .. encapData.factory_desc   .. "]"
addText(l.banner, fontHeader, topLine, xcoords[1], y, AlignH_Center, AlignV_Middle, ToColor(0.5, 0.5, 0.5, 0.5))

rowCount = rowCount + 2
for _,text in pairs(incomingScreenData) do
    y = rowCount * (fontSize + (fontSize * grUsed)) + topMargin
    split = stringToTable(text, ",")
    local color = white
    if split[3] == "`R" then color = green end
    if split[3] == "!!" then color = red end
    if split[2] == "Refiner" and split[3] == '`W' then
        color = red
        split[3] = "!NEED ORE!"
    end
    if split[1] ~= "" then
        rowCount = rowCount + 1
        for j, t in pairs(split) do
            setNextFillColor(l.data, color.r, color.g, color.b, color.o)
            addText(l.data, font, pad( fixText(t:gsub("^||", "line")), padding[j]), xcoords[j], y, AlignH_Center, AlignV_Middle, ToColor(0.5, 0.5, 0.5, 0.5))
        end
    end
end

requestAnimationFrame(2200)
--- eof ---
