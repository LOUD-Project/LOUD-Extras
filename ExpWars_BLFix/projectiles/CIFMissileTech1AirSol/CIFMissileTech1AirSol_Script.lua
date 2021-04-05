--
-- Cybran "Loa" Tactical Missile, mobile unit launcher variant of this missile,
-- lower and straighter trajectory. Splits into child projectile if it takes enough
-- damage.
--
local CLOATacticalMissileProjectile = import('/lua/cybranprojectiles.lua').CLOATacticalMissileProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker
local EffectTemplate = import('/lua/EffectTemplates.lua')

CIFMissileTactical01 = Class(CLOATacticalMissileProjectile) {


    OnCreate = function(self)
        CLOATacticalMissileProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
        self.Split = false
        self.MoveThread = self:ForkThread(self.MovementThread)
    end,

    MovementThread = function(self)        
        self.WaitTime = 1
        self:SetTurnRate(180)      
    end,  
      
}
TypeClass = CIFMissileTactical01

