--
-- UEF Anti-Matter Shells
--

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local TArtilleryAntiMatterProjectile = import( ExpWarsPath .. '/lua/modprojectiles.lua' ).TArtilleryAntiMatterProjectile

TIFAntiMatterShells01 = Class(TArtilleryAntiMatterProjectile) {
}

TypeClass = TIFAntiMatterShells01
