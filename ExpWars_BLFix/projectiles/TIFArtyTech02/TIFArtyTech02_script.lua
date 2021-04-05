--
-- UEF Anti-Matter Shells
--

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local TArtilleryAntiMatterProjectile = import( ExpWarsPath .. '/lua/modprojectiles.lua' ).TArtilleryAntiMatterSmallProjectile

TIFAntiMatterShells02 = Class(TArtilleryAntiMatterProjectile) {
}

TypeClass = TIFAntiMatterShells02