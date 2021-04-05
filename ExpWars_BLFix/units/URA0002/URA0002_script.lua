--****************************************************************************
--**
--**  File     :  /cdimage/units/UEA0001/UEA0001_script.lua
--**  Author(s):  John Comes
--**
--**  Summary  :  UEF CDR Pod Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local MissileRedirect = import('/lua/defaultantiprojectile.lua').MissileRedirect

URA0002 = Class(CAirUnit) {
    Parent = nil,
	
	OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        local bp = self:GetBlueprint().Defense.AntiMissile
        local antiMissile = MissileRedirect {
            Owner = self,
            Radius = bp.Radius,
            AttachBone = bp.AttachBone,
            RedirectRateOfFire = bp.RedirectRateOfFire
        }
        self.Trash:Add(antiMissile)
        self.UnitComplete = true
    end,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Parent:NotifyOfPodDeath(self.Pod)
        self.Parent = nil
        CAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

}

TypeClass = URA0002