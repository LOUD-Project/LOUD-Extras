--****************************************************************************
--**
--**  File     : ?????
--**  Author(s):  Gordon Duclos
--**
--**  Summary  :  Heavy Quarnon Cannon Projectile script, 
--**
--**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------


local SHeavyQuarnonOrbitalCannon = import( ExpWarsPath .. '/lua/modprojectiles.lua').SHeavyQuarnonOrbitalCannon

--SDFHeavyQuarnonCannon01 = Class( import( ExpWarsPath .. '/lua/modprojectiles.lua').SHeavyQuarnonOrbitalCannon ) {
SDFHeavyQuarnonCannon01 = Class( SHeavyQuarnonOrbitalCannon ) {
}

TypeClass = SDFHeavyQuarnonCannon01
