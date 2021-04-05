--****************************************************************************
--**
--**  File     :  /units/UALEW0001/UALEW0001_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--**
--**  Summary  :  Aeon Destroyer Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Game = import( '/lua/game.lua' )

-- VARIABLE ''GLOBALE'' ( par Manimal )
local ExpWarsPath = Game.ExpWarsPath
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local AHoverLandUnit = import( '/lua/aeonunits.lua' ).AHoverLandUnit

local AeonWeapons = import('/lua/aeonweapons.lua')
local ADFGravitonProjectorWeapon = AeonWeapons.ADFGravitonProjectorWeapon
local AAAZealotMissileWeapon = AeonWeapons.AAAZealotMissileWeapon


UALEW0001 = Class( AHoverLandUnit ) {
    Weapons = {
		MainGun = Class(ADFGravitonProjectorWeapon) {},
		AntiAirMissiles = Class(AAAZealotMissileWeapon) {},
    },
}

TypeClass = UALEW0001
