--[[------------------------------------------------------------------------
--  File     :  /units/URA0205/URA0205_script.lua
--  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
--  Summary  :  Cybran EMP Bomber Script
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  -----------------------------
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--


local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CIFBombNeutronWeapon = import('/lua/cybranweapons.lua').CIFBombNeutronWeapon

URA0205 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(CIFBombNeutronWeapon) {},
		
    },
}

TypeClass = URA0205
