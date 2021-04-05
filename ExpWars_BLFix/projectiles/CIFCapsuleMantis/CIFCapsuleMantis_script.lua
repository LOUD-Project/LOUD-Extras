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

TIFshieldMissile = Class( TShieldProjectile ) {

		OnCreate = function(self)
		TShieldProjectile.OnCreate(self)
		local ChildProjectileBP = ExpWarsPath .. '/projectiles/CIFCapsuleMantis01/CIFCapsuleMantis01_proj.bp'


        local vx, vy, vz = self:GetVelocity()
        local velocity = 2

		-- One initial projectile following same directional path as the original
        --self:CreateChildProjectile(ChildProjectileBP):SetVelocity(vx, vy, vz):SetVelocity(velocity):PassDamageData(self.DamageData)

		-- Create several other projectiles in a dispersal pattern
        local numProjectiles = 5
        local angle = (2*math.pi) / numProjectiles
        local angleInitial = RandomFloat( 0, angle )
        local angleVariation = angle * 0.35
        local spreadMul = 0.2

        local xVec = 0
        local yVec = vy
        local zVec = 0

        -- Launch projectiles at semi-random angles away from split location
        for i = 0, (numProjectiles -1) do
            xVec = vx + (math.sin(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
            zVec = vz + (math.cos(angleInitial + (i*angle) + RandomFloat(-angleVariation, angleVariation))) * spreadMul
            local proj = self:CreateChildProjectile(ChildProjectileBP)
            proj:SetVelocity(xVec,yVec,zVec)
            proj:SetVelocity(velocity)
            proj:PassDamageData(self.DamageData)
        end
        local pos = self:GetPosition()
        self:Destroy()
    end,

}

TypeClass = TIFshieldMissile
