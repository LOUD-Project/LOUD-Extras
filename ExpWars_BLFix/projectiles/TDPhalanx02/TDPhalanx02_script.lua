--
-- Terran Phalanx basic projectile
--

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------


local TShellPhalanx02Projectile = import( ExpWarsPath .. '/lua/modprojectiles.lua').TShellPhalanx02Projectile

TDPhalanx01 = Class( TShellPhalanx02Projectile ) { }

TypeClass = TDPhalanx01

