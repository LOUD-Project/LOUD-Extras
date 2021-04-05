--****************************************************************************
--**
--**  File     :  /cdimage/units/UEA0001/UEA0001_script.lua
--**  Author(s):  John Comes
--**
--**  Summary  :  UEF CDR Pod Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local AAirUnit = import('/lua/aeonunits.lua').AAirUnit

UAA0001 = Class(AAirUnit) {
    Parent = nil,

    SetParent = function(self, parent, podName)
        self.Parent = parent
        self.Pod = podName
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self.Parent:NotifyOfPodDeath(self.Pod)
        self.Parent = nil
        AAirUnit.OnKilled(self, instigator, type, overkillRatio)
    end,

}

TypeClass = UAA0001