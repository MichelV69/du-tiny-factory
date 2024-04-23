--- (1)
UNIT_STOPPED                       = 1
UNIT_WORKING                       = 2
UNIT_JAMMED                        = 3
UNIT_FULL_STORAGE                  = 4
UNIT_BAD_CFG                       = 5
UNIT_WAITING                       = 6
UNIT_NO_SCHEMAS                    = 7

StatusCodeTable                    = {}
StatusCodeTable[UNIT_STOPPED]      = { state = "Stopped" }
StatusCodeTable[UNIT_WORKING]      = { state = "Working on Last Job" }
StatusCodeTable[UNIT_JAMMED]       = { state = "Jammed" }
StatusCodeTable[UNIT_FULL_STORAGE] = { state = "Storage Full" }
StatusCodeTable[UNIT_BAD_CFG]      = { state = "Missing Containers" }
StatusCodeTable[UNIT_WAITING]      = { state = "Waiting for Work" }
StatusCodeTable[UNIT_NO_SCHEMAS]   = { state = "No Schemas" }
--- eof ---
