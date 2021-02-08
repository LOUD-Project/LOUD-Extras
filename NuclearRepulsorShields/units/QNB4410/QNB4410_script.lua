-- T4 shield generator

local NShieldStructureUnit = import('/lua/nomadsunits.lua').NShieldStructureUnit
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').ShieldDeathWeapon

QNB4410 = Class(NShieldStructureUnit) {

    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
    },

    ShieldEffects = {
        '/effects/Entities/Shield05/Shield05c_emit.bp',
    },

    OnStopBeingBuilt = function(self,builder,layer)
        NShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        NShieldStructureUnit.OnShieldEnabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'shield', self:GetArmy(), v ):ScaleEmitter(0.75) )
        end
    end,

    OnShieldDisabled = function(self)
        NShieldStructureUnit.OnShieldDisabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,
}

TypeClass = QNB4410