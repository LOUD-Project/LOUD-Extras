--
-- Terran Napalm Carpet Bomb
--

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local TShieldProjectile = import( ExpWarsPath .. '/lua/modprojectiles.lua' ).TShieldProjectile

TIFshieldMissile = Class(TShieldProjectile) {
    OnImpact = function(self, TargetType, targetEntity)
		TShieldProjectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('EAD0001', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
    end,
}

TypeClass = TIFshieldMissile
