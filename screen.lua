--- -
local colHeaders = {"Source", "Line 1", "Line 2", "Finished"}  --bottom row Hub labels
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
local l = createLayer()

DEFAULT_COL_HEADER_YPOS = 490
local y_pos = DEFAULT_COL_HEADER_YPOS
if custom_col_header_yPos ~= -1 then y_pos = custom_col_header_yPos end

local x_width = rx / #colHeaders+1
local x_pad = x_width / -2

for colNo, thisHeader in ipairs(colHeaders) do
    local backCenter = #thisHeader * fontHeaderSize / 2
    addText(l, fontHeader, thisHeader, x_pad + (x_width * colNo) - backCenter, y_pos, 0)
    end

--- -
function strSplit(a,b)result={} for c in(a..b):gmatch("(.-)"..b) do table.insert(result,c) end; return result end

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

xcoords = {}
xcoords[1] = getPixelWidth("123")
xcoords[2] = xcoords[1] + getPixelWidth("waitress009")
xcoords[3] = xcoords[2] + getPixelWidth("honeycomb refinery")
xcoords[4] = xcoords[3] + getPixelWidth("running")
xcoords[5] = xcoords[4] + getPixelWidth("123456")
xcoords[6] = xcoords[5] + getPixelWidth("123456")

padding = {}
padding[1] = -5
padding[4] = -5
padding[5] = -5
-- padding[6] = -5

local white = ToColor(1, 1, 1, 1)
local red = ToColor(1, 0, 0, 1)
local green = ToColor(0, 1, 0, 1)

local goldenRatio = 1.61803399
local grUsed = (goldenRatio - 1) /2

--- screen display by priority START ---
local screenRows = {}
 screenRows['white'] = {}
 screenRows['green'] = {}
 screenRows['yellow'] = {}
 screenRows['red'] = {}

for _ , text in pairs(strSplit(getInput(), "\n")) do
    split = strSplit(text, ",")
    local typicalData = true
    if split[3] == "`R" then
      table.insert(screenRows.green, text)
      typicalData = false
      end
    if split[3] == "!!" then
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

local priorityTable = {}
for _,data in pairs(screenRows.red) do
  table.insert(priorityTable, data)
end
for _,data in pairs(screenRows.yellow) do
  table.insert(priorityTable, data)
end
for _,data in pairs(screenRows.green) do
  table.insert(priorityTable, data)
end
for _,data in pairs(screenRows.white) do
  table.insert(priorityTable, data)
end

local rowCount = 1
for _,text in pairs(priorityTable) do
    y = rowCount * (fontSize + (fontSize * grUsed)) + topMargin
    split = strSplit(text, ",")
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
            setNextFillColor(l, color.r, color.g, color.b, color.o)
            addText(l, font, pad( fixText(t:gsub("^||", "line")), padding[j]), xcoords[j], y, AlignH_Center, AlignV_Middle, ToColor(0.5, 0.5, 0.5, 0.5))
        end
    end
end
--- screen display by priority END ---

requestAnimationFrame(1000)
--- eof ---
