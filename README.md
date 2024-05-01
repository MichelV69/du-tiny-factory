# Tiny Factory

## Current Version

"1.2.2"

## Explanation / Reasoning

Market too far to go buy stuff? Industry line too obnoxious to setup for a few knock off items? Then this is the solution for you!

The Tiny Factory will handle the industry lines for you. Just tell it what you want, turn it on, make sure it has ores and schematics, and it'll handle the rest! This Tiny Factory in a box, composed of only 20 industry units, can make any Basic, Uncommon, or Advanced item that can be produced by the XS, S, M, or L Assembly Line.

<https://du-creators.org/makers/Squizz/ship/Tiny%20Factory>

## Instructions

To add an item, look it up by name on <https://du-lua.dev/#/items>
Enter the value below into the primary board, which is the one sitting on top of the pedestal. As you see in the examples, left side is the item id, right side is the item quantity. Then turn on the primary board! The programming boards will work together to handle the rest.

    -- some example complicated items for testing your new Tiny Factory
    items[286542481] = 1 -- emergency control unit xs
    items[184261427] = 1 -- screen xs
    items[1866437084] = 1 -- remote controller xs
    items[3663249627] = 2 -- elevator xs

    -- some example basic items for testing each assembly line
    items[1727614690] = 1 -- wing xs
    items[2532454166] = 1 -- wing s
    items[404188468] = 1 -- wing m
    items[2375915630] = 1 -- atmo engine l

### Equipment Names

* Do NOT rename your industry units.  DUTF requies that it be able to read the "original" name to figure out what job to give to what equipment.
* Software / Programming boards and Manual Switches connected to them **must** have a digit as the last character for "chef", "waitress" and "linecook".  It cannot be a "zero";  so "chef1" is okay, but "chef01" is **not**
* Any Switch controlled by Manager **must** have the same name as the device they are connected to.  So, the Switch for "linecook1" must be named "linecook1", the Switch for "chef2" must be named "chef2", etcetera.

## FAQ

* I want to change what gets made, how do I do that? Just CTRL-L on the primary board, edit the values, and click Apply. Then turn the board on! If it was already on, turn it off and then back on again.
* I want to make things like honeycomb, scrap, fuel, or warp cells, how do I do that? The Tiny Factory's default configuration only produces things that are made with Assemblers. If you'd like to customize the final products, remove one an assembler of your choice and replace it with the industry that can make your preferred final product. Link Line 1 and Line 2 Hubs to this industry as inputs, and link the Output Hub as Output. Finally, link the industry to the "chef" programming board as this board handles the final product production. After doing this turn your factory off and back on again!
* What is this "Unknown Schematic" I see in the LUA chat window? This is normal. The game's scripting does not provide information on what industry units create which items, so the boards have to figure it out. When a board tries to apply an element to an industry that does not make that element, you will see the error. When a successful match is found, it will be saved to the databank and used in the future. The error will happen more and more infrequently until it goes away completely! At least, until you add more items to be made...
* Do I have to be present for this to work? Yes! Like any LUA in game, a player must be present. If you go too far, or turn off the primary boards, the industries will eventually finish what they can and won't be assigned new jobs to complete.
* My client is not set to English and this doesn't work, help?! My apologies, some of the scripting had to be based on the English names for things because the game's scripting leaves out important information. Since my primary language is Bad English other languages and their nuances are just a no go for me. Therefore, client languages other than English are not supported.
* How will I know if an industry needs schematics or ore? When an industry needs schematics, the code will HARD STOP on that particular industry and !SCHEMATICS! will be displayed in red on the screen. Same goes for ore, if you run low, the refiner will hard stop on that ore and the screen will display !NEED ORE! in red. In each case, you can select the industry to see what exactly it requires.

## Discord

Still have questions? Ask here! <https://discord.com/channels/760240626942869546/1078009204792631437/>

## Is it DRM protected?

No! Completely DRM FREE! Play with the code, break it, improve it, have fun!

## Shopping List

* 4x Basic Container M
* 1x Basic Container XS
* 2x Basic Recycler
* 5x Container Hub
* 1x Databank XS
* 5x Manual Switch XS
* 6x Programming Board XS
* 1x Screen M
* 1x Screen XS
* 1x Static/Space Core Unit XS

* 2x Uncommon 3d Printer
* 2x Uncommon Chemical
* 2x Uncommon Electronics
* 2x Uncommon Glass Furnace
* 2x Uncommon Metalworks
* 2x Uncommon Refiner
* 2x Uncommon Smelter

* 1x Uncommon Assembly Line L
* 1x Uncommon Assembly Line M
* 1x Uncommon Assembly Line S
* 1x Uncommon Assembly Line XS

## Blueprints

Ready-to-build BPs are available upon request. Contact PE902Gaming in DU to arrange to get one.

## Updates

### how to read V-numbers

This project uses the [Semantic Versioning](https://en.wikipedia.org/wiki/Software_versioning#Semantic_versioning).

> *Breaking changes are indicated by increasing the **major number** (**high risk**); new, non-breaking features increment the **minor number** (**medium risk**); and all other non-breaking changes increment the **patch number** (**lowest risk**).*

A letter suffix is an indication of a patch-in-progress / waiting for testing, and should ***never*** be used in a production environment.

An "-RC" indicates a "release candidate" and *should* be safe to use in production, but you may also be the victim of a Country Music song plot if you do.

## History

* v1.2.3 - (unreleased) Improvements to "large feed lots" handling, fixes to crashed board auto-restart, documentation.
* v1.2.2 - (22apr2024) Includes fixes for some honeycomb and lumi glass not being produced due to shortages, and moving most user-config items into 'customer'
* v1.2.1 - Fork of original code by <https://github.com/MichelV69> (DU: PE902Gaming). Include changes for screen display priority.
* v1.1.2 - Big fix on ingredient checking for items with more than one recipe, such as Catalyst 3.
* v1.1.1 - Minor bug fixes and other improvements
* v1.1.0 - Minor bug fixes and other improvements
* v1.0.1 - Fixed bug in screen's programming board.
* v1.1.0 - Updated blueprints to include items for a schematics container. No software updates.
