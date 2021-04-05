--****************************************************************************
--**
--**  File     :  /effects/projectiles/TDFPlasmsaHeavy04/TDFPlasmsaHeavy04_script.lua
--**  Author(s):  Gordon Duclos modified by Asdrubaelvect
--**
--**  Summary  :  UEF Orbital Heavy Plasma Cannon projectile 
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************


------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local TOrbitalHeavyPlasmaCannonProjectile = import( ExpWarsPath .. '/lua/modprojectiles.lua').TOrbitalHeavyPlasmaCannonProjectile

TDFPlasmaHeavy04 = Class( TOrbitalHeavyPlasmaCannonProjectile ) {
}

TypeClass = TDFPlasmaHeavy04
