--****************************************************************************
--**
--**  File     :  /cdimage/units/URL0303/URL0303_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--**
--**  Summary  :  Cybran Siege Assault Bot Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local Weapon = import('/lua/sim/Weapon.lua').Weapon
local cWeapons = import('/lua/cybranweapons.lua')
local CDFLaserDisintegratorWeapon = cWeapons.CDFLaserDisintegratorWeapon01
local CDFElectronBolterWeapon = cWeapons.CDFElectronBolterWeapon
local MissileRedirect = import('/lua/defaultantiprojectile.lua').MissileRedirect
local CDFRocketIridiumWeapon02 = import('/lua/cybranweapons.lua').CDFRocketIridiumWeapon02
local CAAMissileNaniteWeapon = import('/lua/cybranweapons.lua').CAAMissileNaniteWeapon

URLEW0001 = Class(CWalkingLandUnit) {
    SwitchAnims = false,
	IsWaiting = false,

    Weapons = {
		HeavyBolter = Class(CDFElectronBolterWeapon) {},
		Disintigrator = Class(CDFLaserDisintegratorWeapon) {},
        
		MissileRack = Class(CDFRocketIridiumWeapon02) {},
    },
	
	OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('HeavyBolter', true)
		self:SetWeaponEnabledByLabel('Disintigrator', true)
		self:SetWeaponEnabledByLabel('MissileRack', false)


    end,
	
	
    TransformThread = function(self, land)
        if( not self.AnimManip ) then
            self.AnimManip = CreateAnimator(self)
        end
        local bp = self:GetBlueprint()
        local scale = bp.Display.UniformScale or 1

        if( land ) then
		self:SetWeaponEnabledByLabel('Disintigrator', false)
		self:SetWeaponEnabledByLabel('HeavyBolter', false)
			self:SetImmobile(true)
			self:SetSpeedMult(0)          
            
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetRate(1)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
			self.IsWaiting = false
            self.Trash:Add(self.AnimManip)
		self:SetWeaponEnabledByLabel('MissileRack', true)

			self.SwitchAnims = true
        else
            self:SetImmobile(true)
		self:SetWeaponEnabledByLabel('MissileRack', false)
 
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetAnimationFraction(1)
            self.AnimManip:SetRate(-1)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
			self.IsWaiting = false
			self:SetSpeedMult(1)
            self.AnimManip:Destroy()
            self.AnimManip = nil
            self:SetImmobile(false)
		self:SetWeaponEnabledByLabel('Disintigrator', true)
		self:SetWeaponEnabledByLabel('HeavyBolter', true)	
        end
    end,

	
    OnScriptBitSet = function(self, bit)
        CWalkingLandUnit.OnScriptBitSet(self, bit)
		local bp = self:GetBlueprint()
        if bit == 1 then 
			self.AT1 = self:ForkThread(self.TransformThread, true)
        end
    end,

    OnScriptBitClear = function(self, bit)
        CWalkingLandUnit.OnScriptBitClear(self, bit)
        if bit == 1 then 
			self.AT1 = self:ForkThread(self.TransformThread, false)
        end
    end,		
}

TypeClass = URLEW0001