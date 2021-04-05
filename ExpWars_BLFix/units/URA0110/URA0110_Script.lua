--[[------------------------------------------------------------------------
--  File     :  /units/URA0110/URA0110_script.lua
--  Author(s):  John Comes, David Tomandl
--  Summary  :  Cybran Bomber Script
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  -----------------------------
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--


local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
--local CIFBombNeutronWeapon = import('/lua/cybranweapons.lua').CIFBombNeutronWeapon
local TIFCruiseMissileLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileLauncher

URA0110 = Class(CAirUnit) {
    Weapons = {
        Bomb = Class(TIFCruiseMissileLauncher) {},
        },
    ExhaustBones = {'Exhaust_L','Exhaust_R',},
    ContrailBones = {'Contrail_L','Contrail_R',},
	
    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        if( not self.OpenAnimManip ) then
            self.OpenAnimManip = CreateAnimator(self)
        end
        local bp = self:GetBlueprint()
		self.OpenAnimManip = CreateAnimator(self)
		self.OpenAnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen, false)
    end,
}

TypeClass = URA0110
