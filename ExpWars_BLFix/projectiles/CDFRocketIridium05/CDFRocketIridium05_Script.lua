--****************************************************************************
--**
--**  File     :  /data/projectiles/CDFRocketIridium02/CDFRocketIridium02_script.lua
--**  Author(s):  Matt Vainio
--**
--**  Summary  :  Cybran Iridium Rocket Tubes, DRL0204
--**
--**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local CIridiumRocketProjectile = import('/lua/cybranprojectiles.lua').CIridiumRocketProjectile
CDFRocketIridium04 = Class(CIridiumRocketProjectile) {

    OnCreate = function(self)
        CIridiumRocketProjectile.OnCreate(self)
		self:TrackTarget(false)
        self:ForkThread(self.UpdateThread)
		
    end,

    UpdateThread = function(self)
        WaitSeconds(2)
		self:TrackTarget(true)
		--self:UseGravity(false)
    end,

}

TypeClass = CDFRocketIridium04
