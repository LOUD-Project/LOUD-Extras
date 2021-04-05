--****************************************************************************
--**
--**  File     :  /units/XSL0110/XSL0110_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Aaron Lundquist
--**
--**  Summary  :  Seraphim Mobile Light Shield
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local SShieldHoverLandUnit = import('/lua/seraphimunits.lua').SShieldHoverLandUnit

XSL0110 = Class(SShieldHoverLandUnit) {
   
    ShieldEffects = {
        '/effects/emitters/aeon_shield_generator_mobile_01_emit.bp',
    },
    
    OnStopBeingBuilt = function(self,builder,layer)
        SShieldHoverLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.ShieldEffectsBag = {}
    end,
    
    OnShieldEnabled = function(self)
        SShieldHoverLandUnit.OnShieldEnabled(self)
                
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
        SShieldHoverLandUnit.OnShieldDisabled(self)
         
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
    end,
}

TypeClass = XSL0110