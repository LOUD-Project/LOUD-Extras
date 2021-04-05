--****************************************************************************
--**
--**  File     :  /units/URS0205/URS0205_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--**
--**  Summary  :  Cybran Heavy Attack Sub Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local CSubUnit = import('/lua/cybranunits.lua').CSubUnit
local CANNaniteTorpedoWeapon = import('/lua/cybranweapons.lua').CANNaniteTorpedoWeapon
local CDFLaserHeavyWeapon = import('/lua/cybranweapons.lua').CDFLaserHeavyWeapon
local Buff = import('/lua/sim/Buff.lua')

local hasHEBI = false -- Flag signalant Enhancement avec Heavy Electron Bolter
local hasHEBII = false
local hasHEBI = false
local hasHEBIV = false
local hasHEBV = false

URS0205 = Class(CSubUnit) {
    DeathThreadDestructionWaitTime = 0,
    
    Weapons = {
        MainGun = Class(CDFLaserHeavyWeapon) {},
        Torpedo01 = Class(CANNaniteTorpedoWeapon) {},
    },
    OnCreate = function(self)
		CSubUnit.OnCreate(self)
			self:HideBone('Upgrade01', true)  
			self:HideBone('Upgrade02', true)  
			self.hasHEBI = false
			self.hasHEBII = false
			self.hasHEBIII = false
			self.hasHEBIV = false
			self.hasHEBV = false
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        CSubUnit.OnStopBeingBuilt(self,builder,layer)
		self:SetWeaponEnabledByLabel('Torpedo01', true)
		self:SetWeaponEnabledByLabel('MainGun', true)
		self.WeaponsEnabled = true
		self:AddUnitCallback(self.OnVeteran, 'OnVeteran') 
    end,	

	--Level--
	OnVeteran = function ( self )
        local bp = self:GetBlueprint()
		local enh = 'VeterancyI'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		--local bp = self:GetBlueprint().Enhancements[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyI' then
				hasHEBI = true    -- Signale HEB INSTALL�
				hasHEBII = false
				hasHEBIII = false
				hasHEBIV = false
				hasHEBV = false
                BuffBlueprint {
                    Name = 'UEFHEALTHBUFF',
                    DisplayName = 'UEFHEALTHBUFF',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.10,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1,
                        },
                    },
                }
            end
			Buff.ApplyBuff(self, 'UEFHEALTHBUFF')
		end	
	----------------------------------
        local bp = self:GetBlueprint()
		local enh = 'VeterancyII'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		-- ADDS MY CUSTOM ENHANCEMENT !
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyII' then
				local wep = self:GetWeaponByLabel('Torpedo01')  
				local wep2 = self:GetWeaponByLabel('MainGun')  				
				wep:ChangeRateOfFire(bp.NewRateOfFire or 1.0)
				wep2:ChangeRateOfFire(bp.NewRateOfFireII or 1.5)
				hasHEBI = true
				hasHEBII = true    -- Signale HEB INSTALL�
				hasHEBIII = false
				hasHEBIV = false
				hasHEBV = false
			end
		end
	----------------------------------
        local bp = self:GetBlueprint()
		local enh = 'VeterancyIII'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		-- ADDS MY CUSTOM ENHANCEMENT !
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyIII' then
				self:ShowBone('Upgrade01', true)
				hasHEBI = true
				hasHEBII = true    -- Signale HEB INSTALL�
				hasHEBIII = true
				hasHEBIV = false
				hasHEBV = false
			end
		end
	----------------------------------
        local bp = self:GetBlueprint()
		local enh = 'VeterancyIV'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		-- ADDS MY CUSTOM ENHANCEMENT !
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyIV' then
			self:ShowBone('Upgrade02', true)
				hasHEBI = true
				hasHEBII = true    -- Signale HEB INSTALL�
				hasHEBIII = true
				hasHEBIV = true
				hasHEBV = false
                BuffBlueprint {
                    Name = 'UEFHEALTHBUFF',
                    DisplayName = 'UEFHEALTHBUFF',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.15,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.2,
                        },
                    },
                }
            end
			Buff.ApplyBuff(self, 'UEFHEALTHBUFF')
		end	
	--------------------------------------
        local bp = self:GetBlueprint()
		local enh = 'VeterancyV'
		local bpEnh = bp.ExpeWars_Enhancement[enh]
		if not bpEnh then return end
        local bpEnhEAVLevel = bpEnh.EnabledAtVeterancyLevel
		-- ADDS MY CUSTOM ENHANCEMENT !
		if bpEnhEAVLevel and bpEnhEAVLevel > 0 and ( self.VeteranLevel == bpEnhEAVLevel ) then
			if enh =='VeterancyV' then
				local wep = self:GetWeaponByLabel('Torpedo01')
				local wep3 = self:GetWeaponByLabel('MainGun')
			
				wep:AddDamageMod(bpEnh.BolterIDamageMod)  
				wep:ChangeRateOfFire(bp.NewRateOfFireI or 1.95)
							
				wep3:AddDamageMod(bpEnh.BolterIIIDamageMod) 
				wep3:ChangeRateOfFire(bp.NewRateOfFireIII or 1.8)

				hasHEBI = true
				hasHEBII = true    -- Signale HEB INSTALL�
				hasHEBIII = true
				hasHEBIV = true
				hasHEBV = true
            end
		end
end,		
	
}

TypeClass = URS0205