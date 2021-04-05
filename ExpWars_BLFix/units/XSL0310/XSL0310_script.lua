--[[------------------------------------------------------------------------
--  File     :  /units/XSL0310/XSL0310_script.lua
--  Author(s):  GPG Devs
--  Summary  :  Seraphim Mobile Shield Generator Script
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  -----------------------------
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--


local SSeaUnit = import('/lua/seraphimunits.lua').SSeaUnit
local SIFInainoWeapon = import('/lua/seraphimweapons.lua').SIFInainoWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')
local SLaanseMissileWeapon = import('/lua/seraphimweapons.lua').SLaanseMissileWeapon

XSL0310 = Class(SSeaUnit) {
    Weapons = {
        InainoMissiles = Class(SIFInainoWeapon) { 
        
            -- launch charge
			LaunchEffects = function(self)   
				----LOG ("launch effects") 
				local FxLaunch = EffectTemplate.SIFInainoPreLaunch01 
				
				WaitSeconds(1.5)
 				self.unit:PlayUnitAmbientSound( 'NukeCharge' )
				for k, v in FxLaunch do
					CreateEmitterAtEntity( self.unit, self.unit:GetArmy(), v )
				end
				WaitSeconds(9.5)
				self.unit:StopUnitAmbientSound( 'NukeCharge' )

			end,   
		  
			PlayFxWeaponUnpackSequence = function(self)
				self:ForkThread(self.LaunchEffects)
				SIFInainoWeapon.PlayFxWeaponUnpackSequence(self)
			end,  
        },
    },
}

TypeClass = XSL0310
