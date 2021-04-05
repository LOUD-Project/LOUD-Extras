--****************************************************************************
--**
--**  File     :  /projectiles/CIFNeutronClusterBomb01/CIFNeutronClusterBomb01.lua
--**  Author(s):  Gordon Duclos
--**
--**  Summary  :  Cybran Neutron Cluster bomb
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************


------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local TShieldProjectile = import( ExpWarsPath .. '/lua/modprojectiles.lua').TShieldProjectile

local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local EffectTemplate = import('/lua/EffectTemplates.lua')

TIFshieldMissile = Class(TShieldProjectile) {

 OnImpact = function(self, TargetType, targetEntity)

		TShieldProjectile.OnImpact( self, TargetType, targetEntity )
		local location = self:GetPosition()
		local ShieldUnit =CreateUnitHPR('XRL0004', self:GetArmy(), location[1], location[2], location[3], 0, 0, 0)
   end,
}

TypeClass = TIFshieldMissile

