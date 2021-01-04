-- TMavaprojectiles.lua
-- Author: Burnie222
-- Based on /lua/modules/BlackOpsARprojectiles.lua

local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local EmitterProjectile = DefaultProjectileFile.EmitterProjectile

local TMEffectTemplate = import('/mods/RatUnits/lua/TMEffectTemplates.lua')

------------------
-- UEF Havoc Bomb
------------------
UefBRNAT3BOMBERproj = Class(EmitterProjectile) {
    FxTrails = {},
    FxImpactUnit = TMEffectTemplate.UEFDeath02,
    FxImpactProp = TMEffectTemplate.UEFDeath02,
    FxPropHitScale = 1.25,
    FxUnitHitScale = 1.25,
    FxLandHitScale = 1.25,
    FxImpactLand = TMEffectTemplate.UEFDeath02,
    FxImpactUnderWater = {},

    OnImpact = function(self, TargetType, TargetEntity)
        local army = self:GetArmy()
        CreateLightParticle( self, -1, army, 2.75, 4, 'sparkle_03', 'ramp_fire_03' )
        if TargetType == 'Terrain' then
            CreateSplat( self:GetPosition(), 0, 'scorch_008_albedo', 12, 12, 550, 200, army )

            --local blanketSides = 12
            --local blanketAngle = (2*math.pi) / blanketSides
            --local blanketStrength = 1
            --local blanketVelocity = 2.25

            --for i = 0, (blanketSides-1) do
            --    local blanketX = math.sin(i*blanketAngle)
            --    local blanketZ = math.cos(i*blanketAngle)
            --    local Blanketparts = self:CreateProjectile('/effects/entities/DestructionDust01/DestructionDust01_proj.bp', blanketX, 0.5, blanketZ, blanketX, 0, blanketZ)
            --        :SetVelocity(blanketVelocity):SetAcceleration(-0.3)
            --end
        end
        EmitterProjectile.OnImpact( self, TargetType, TargetEntity )
    end,
}
