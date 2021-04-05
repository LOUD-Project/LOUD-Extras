--****************************************************************************
--**
--**  File     :  ????
--**  Author(s):  modified by Asdrubaelvect
--**
--**  Summary  :  Cybran Orbital Heavy Bolter Cannon projectile 
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------


local COrbitalHeavyBolterCanonProjectile = import( ExpWarsPath .. '/lua/modprojectiles.lua' ).COrbitalHeavyBolterCanonProjectile


CDFBolter01 = Class( COrbitalHeavyBolterCanonProjectile ) {
}

TypeClass = CDFBolter01
