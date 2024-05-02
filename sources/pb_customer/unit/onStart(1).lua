---- (1) ----
-- PB_CUSTOMER.LUA
customer_version    = "1.2.3a"
local items         = {} -- don't modify this line
--- ---
CLASSIC_YPOS          = 488
THREELINE_YPOS        = 511

--- << user configuration section >> ---
local factory_desc    = "'A'-System - Critical Station Components" -- If you have more than one, change this
local feed_multiplier = 1.11                                    -- how much extra to be produced and kept waiting in the feeder bin
local line_multiplier = 1.11                                    -- how much extra should be produced waiting to be transferred to feeder bin (will max at 1000)
local num_lines       = 3                                       -- the number of linecook support lines

---
local defaultColHeaderYPos   = CLASSIC_YPOS          -- pick one of above two, or set your own integer value
local colHeaders             = { "Inputs", " ", " ", "Outputs" } --bottom row Hub labels
local fontSize               = 14                    --on-screen font size
local topMargin              = 22                    --don't change at random
local custom_col_header_yPos = -1                    --don't change at random

items[4139262245]     = 8                                       -- Transfer Unit l
--- << END of user configuration section >> ---

databank_clear  = false --global ... no, do NOT clear the databank next time this starts
--->> databank_clear = true  --global ... yes, DO clear the databank next time this starts
-- don't modify the following
if databank_clear == true then databank.clear() end

databank.setFloatValue("feed_multiplier", feed_multiplier)
databank.setFloatValue("line_multiplier", line_multiplier)
databank.setIntValue("num_lines", num_lines)

databank.setStringValue("orders", serialize(items));
databank.setStringValue("factory_desc", factory_desc)

databank.setStringValue("defaultColHeaderYPos", defaultColHeaderYPos)
databank.setStringValue("colHeaders", colHeaders)
databank.setStringValue("fontSize", fontSize)
databank.setStringValue("topMargin", topMargin)
databank.setStringValue("custom_col_header_yPos", custom_col_header_yPos)

manager.deactivate()
unit.setTimer("on", 0.1)

if screen then screen.activate() end

--- eof ---
