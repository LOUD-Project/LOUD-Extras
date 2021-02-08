#****************************************************************************
#**
#**  File     :  /units/QSB4410/QSB4410_script.lua
#**
#**  Summary  :  Seraphim Heavy Shield Generator Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local SShieldStructureUnit = import('/lua/seraphimunits.lua').SShieldStructureUnit
local DeathNukeWeapon = import('/lua/sim/defaultweapons.lua').ShieldDeathWeapon

QSB4410 = Class(SShieldStructureUnit) {
    
    Weapons = {
        DeathWeapon = Class(DeathNukeWeapon) {},
    },

    ShieldEffects = {
        '/effects/emitters/seraphim_shield_generator_t3_02_emit.bp',
        '/effects/emitters/seraphim_shield_generator_t3_03_emit.bp', 
        '/effects/emitters/seraphim_shield_generator_t3_04_emit.bp',        
    },
    
    OnStopBeingBuilt = function(self,builder,layer)
        SShieldStructureUnit.OnStopBeingBuilt(self,builder,layer)
        self.ShieldEffectsBag = {}
    end,

    OnShieldEnabled = function(self)
        SShieldStructureUnit.OnShieldEnabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 0, self:GetArmy(), v ) )
        end
    end,

    OnShieldDisabled = function(self)
        SShieldStructureUnit.OnShieldDisabled(self)
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
            self.ShieldEffectsBag = {}
        end
    end,
    
    OnKilled = function(self, instigator, type, overkillRatio)
        SShieldStructureUnit.OnKilled(self, instigator, type, overkillRatio)
        if self.ShieldEffctsBag then
            for k,v in self.ShieldEffectsBag do
                v:Destroy()
            end
        end
    end,
}

TypeClass = QSB4410