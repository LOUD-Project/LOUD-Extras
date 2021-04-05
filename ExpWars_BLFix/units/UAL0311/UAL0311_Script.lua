--[[------------------------------------------------------------------------
--  File	 :  /units/UAL0311/UAL0311_script.lua
--  Author(s):  Dru Staltman, Matt Vainio
--  Summary  :  Aeon Shield Disruptor Script DAL0310
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  -----------------------------
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Game = import( '/lua/game.lua' )

-- VARIABLE ''GLOBALE'' ( par Manimal )
local ExpWarsPath = Game.ExpWarsPath
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local ALandUnit = import( '/lua/aeonunits.lua' ).ALandUnit

local ACruiseMissileWeapon = import('/lua/aeonweapons.lua').ACruiseMissileWeapon

UAL0311 = Class( ALandUnit ) {
    Weapons = {
        MissileRack = Class(ACruiseMissileWeapon) {},
    },
}

TypeClass = UAL0311
