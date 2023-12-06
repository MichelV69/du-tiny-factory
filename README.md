# Tiny Factory

Market too far to go buy stuff? Industry line too obnoxious to setup for a few knock off items? Then this is the solution for you!

The Tiny Factory will handle the industry lines for you. Just tell it what you want, turn it on, make sure it has ores and schematics, and it'll handle the rest! This Tiny Factory in a box, composed of only 20 industry units, can make any Basic, Uncommon, or Advanced item that can be produced by the XS, S, M, or L Assembly Line.

https://du-creators.org/makers/Squizz/ship/Tiny%20Factory

## Instructions:

To add an item, look it up by name on https://du-lua.dev/#/items
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

## FAQ:
* I want to change what gets made, how do I do that? Just CTRL-L on the primary board, edit the values, and click Apply. Then turn the board on! If it was already on, turn it off and then back on again.
* I want to make things like honeycomb, scrap, fuel, or warp cells, how do I do that? The Tiny Factory's default configuration only produces things that are made with Assemblers. If you'd like to customize the final products, remove one an assembler of your choice and replace it with the industry that can make your preferred final product. Link Line 1 and Line 2 Hubs to this industry as inputs, and link the Output Hub as Output. Finally, link the industry to the "chef" programming board as this board handles the final product production. After doing this turn your factory off and back on again!
* What is this "Unknown Schematic" I see in the LUA chat window? This is normal. The game's scripting does not provide information on what industry units create which items, so the boards have to figure it out. When a board tries to apply an element to an industry that does not make that element, you will see the error. When a successful match is found, it will be saved to the databank and used in the future. The error will happen more and more infrequently until it goes away completely! At least, until you add more items to be made...
* Do I have to be present for this to work? Yes! Like any LUA in game, a player must be present. If you go too far, or turn off the primary boards, the industries will eventually finish what they can and won't be assigned new jobs to complete.
* My client is not set to English and this doesn't work, help?! My apologies, some of the scripting had to be based on the English names for things because the game's scripting leaves out important information. Since my primary language is Bad English other languages and their nuances are just a no go for me. Therefore, client languages other than English are not supported.
* How will I know if an industry needs schematics or ore? When an industry needs schematics, the code will HARD STOP on that particular industry and !SCHEMATICS! will be displayed in red on the screen. Same goes for ore, if you run low, the refiner will hard stop on that ore and the screen will display !NEED ORE! in red. In each case, you can select the industry to see what exactly it requires.

## Discord

Still have questions? Ask here! https://discord.com/channels/760240626942869546/1078009204792631437/

## Release

There are two versions currently available at my Haven base: ::pos{0,27,-14.3128,30.9315,9.6166}

* Space Core Unit XS
* Static Core Unit XS

DRM FREE! Play with the code, break it, improve it, have fun!

## Roadmap

Future versions will include all Rare industries so that all tiers can be assembled. Larger cores will include optional XL Assembly Line as well.

## Shopping List 

(all industries sold at Alioth location)

* 4x Basic Container M
* 1x Basic Container XS
* 2x Basic Recycler
* 5x Container Hub
* 1x Databank XS
* 4x Long Light L
* 5x Manual Switch XS
* 6x Programming Board XS
* 1x Screen M
* 1x Screen XS
* 2x Square Light M
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

# Update History

* v1.1.2 - Big fix on ingredient checking for items with more than one recipe, such as Catalyst 3.
* v1.1.1 - Minor bug fixes and other improvements
* v1.1.0 - Minor bug fixes and other improvements
* v1.0.1 - Fixed bug in screen's programming board.
* v1.1.0 - Updated blueprints to include items for a schematics container. No software updates.
