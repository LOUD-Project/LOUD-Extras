--[[------------------------------------------------------------------------
--  File	 :  /units/XSL0302/XSL0302_script.lua
--  Author(s):  Jessica St. Croix, Gordon Duclos
--  Summary  :  Seraphim Sub Commander Script
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  -----------------------------
--  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--


local SHoverLandUnit = import('/lua/seraphimunits.lua').SHoverLandUnit
local AWeapons = import('/lua/aeonweapons.lua')
local SWeapons = import('/lua/seraphimweapons.lua')
local Buff = import('/lua/sim/Buff.lua')

local SDFLightChronotronCannonWeapon = SWeapons.SDFLightChronotronCannonWeapon
local SDFOverChargeWeapon = SWeapons.SDFLightChronotronCannonOverchargeWeapon
local SIFLaanseTacticalMissileLauncher = SWeapons.SIFLaanseTacticalMissileLauncher

local SIFThunthoCannonWeapon = import('/lua/seraphimweapons.lua').SIFThunthoCannonWeapon

local SAALosaareAutoCannonWeapon = import('/lua/seraphimweapons.lua').SAALosaareAutoCannonWeapon

local AIFCommanderDeathWeapon = AWeapons.AIFCommanderDeathWeapon
local EffectUtil = import('/lua/EffectUtilities.lua')

XSL0302 = Class(SHoverLandUnit) {
    
	SwitchAnims = true,
    Walking = true,
	IsWaiting = false,
	
    Weapons = {
        LightChronatronCannon = Class(SDFLightChronotronCannonWeapon) {},
        DeathWeapon = Class(AIFCommanderDeathWeapon) {},
		MissileWeapon01 = Class(SIFLaanseTacticalMissileLauncher) {},
		MissileWeapon02 = Class(SIFLaanseTacticalMissileLauncher) {},
		UpgradeChronatronCannon01 = Class(SDFLightChronotronCannonWeapon) {},
		UpgradeChronatronCannon02 = Class(SDFLightChronotronCannonWeapon) {},
		ArtyGun01 = Class(SIFThunthoCannonWeapon) {},
		ArtyGun02 = Class(SIFThunthoCannonWeapon) {},
		AntiAir01 = Class(SAALosaareAutoCannonWeapon) {},
		AntiAir02 = Class(SAALosaareAutoCannonWeapon) {},
    },
    
	OnCreate = function(self)
        SHoverLandUnit.OnCreate(self)
		
		self.Trash:Add(CreateRotator(self, 'RoueD01', 'y', nil, 130, 130, 130))
		self.Trash:Add(CreateRotator(self, 'RoueD02', 'y', nil, -130, -130, -130))
		self.Trash:Add(CreateRotator(self, 'RoueG01', 'y', nil, 130, 130, 130))
		self.Trash:Add(CreateRotator(self, 'RoueG02', 'y', nil, -130, -130, -130))
		
		self.Trash:Add(CreateRotator(self, 'RoueD03', 'y', nil, 130, 130, 130))
		self.Trash:Add(CreateRotator(self, 'RoueD04', 'y', nil, -130, -130, -130))
		self.Trash:Add(CreateRotator(self, 'RoueG03', 'y', nil, 130, 130, 130))
		self.Trash:Add(CreateRotator(self, 'RoueG04', 'y', nil, -130, -130, -130))
		
        ----Armure 1
		self:HideBone('ArmureUpgrade01_01', true)
		self:HideBone('ArmureUpgrade01_02', true)
		self:HideBone('ArmureUpgrade01_03', true)
		self:HideBone('ArmureUpgrade01_04', true)
		----Armure 2
		self:HideBone('ArmureUpgrade02_01', true)
		----Armure 3
		self:HideBone('ArmureUpgrade03_01', true)
		----Missile 1
		self:HideBone('Back_Upgrade01', true)
		----Missile 2
		self:HideBone('Back_Upgrade02', true)
		self:SetWeaponEnabledByLabel('MissileWeapon01', false)
		self:HideBone('Back_Upgrade03', true)
		self:SetWeaponEnabledByLabel('MissileWeapon02', false)
		----ArmeCot�s
		self:HideBone('Right_Upgrade_Weapon01_01', true)
		self:SetWeaponEnabledByLabel('UpgradeChronatronCannon01', false)
		self:HideBone('Left_Upgrade_Weapon01_01', true)
		self:SetWeaponEnabledByLabel('UpgradeChronatronCannon02', false)
		----ArmeArtyCot�s
		self:HideBone('LeftArty01_01', true)
		self:SetWeaponEnabledByLabel('ArtyGun01', false)
		self:HideBone('RightArty01_01', true)
		self:SetWeaponEnabledByLabel('ArtyGun02', false)
		----ArmeAntiAir
		self:HideBone('AATurretLeft01', true)
		self:SetWeaponEnabledByLabel('AntiAir01', false)
		self:HideBone('AATurretRight01', true)
		self:SetWeaponEnabledByLabel('AntiAir02', false)
    end,


	
	   CreateEnhancement = function(self, enh)
        SHoverLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh =='AdvancedArmorI' then
		if not Buffs['SERAPHIMHEALTHBUFF'] then
		BuffBlueprint {
                    Name = 'SERAPHIMHEALTHBUFF',
                    DisplayName = 'SERAPHIMHEALTHBUFF',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },					
                    },
                }
            end
		Buff.ApplyBuff(self, 'SERAPHIMHEALTHBUFF')
		
        elseif enh =='AdvancedArmorIRemove' then
			if Buff.HasBuff( self, 'SERAPHIMHEALTHBUFF' ) then
                Buff.RemoveBuff( self, 'SERAPHIMHEALTHBUFF' )
            end
		
		elseif enh =='AdvancedArmorII' then
			if not Buffs['SERAPHIMHEALTHBUFFII'] then
		BuffBlueprint {
                    Name = 'SERAPHIMHEALTHBUFFII',
                    DisplayName = 'SERAPHIMHEALTHBUFFII',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },					
                    },
                }
            end
		Buff.ApplyBuff(self, 'SERAPHIMHEALTHBUFFII')
		
		elseif enh =='AdvancedArmorIIRemove' then
			if Buff.HasBuff( self, 'SERAPHIMHEALTHBUFF' ) then
                Buff.RemoveBuff( self, 'SERAPHIMHEALTHBUFF' )
            end
		
		elseif enh =='AdvancedArmorIII' then
			if not Buffs['SERAPHIMHEALTHBUFFIII'] then
		BuffBlueprint {
                    Name = 'SERAPHIMHEALTHBUFFIII',
                    DisplayName = 'SERAPHIMHEALTHBUFFIII',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'REPLACE',
                    Duration = -1,
                    Affects = {
                        MaxHealth = {
                            Add = bp.NewHealth,
                            Mult = 1.0,
                        },
                        Regen = {
                            Add = bp.NewRegenRate,
                            Mult = 1.0,
                        },					
                    },
                }
            end
		Buff.ApplyBuff(self, 'SERAPHIMHEALTHBUFFIII')
		
		elseif enh =='AdvancedArmorIIIRemove' then
			if Buff.HasBuff( self, 'SERAPHIMHEALTHBUFF' ) then
                Buff.RemoveBuff( self, 'SERAPHIMHEALTHBUFF' )
            end
		
		
		elseif enh == 'MissileDeckI' then
            self:SetWeaponEnabledByLabel('MissileWeapon01', true)
        elseif enh == 'MissileDeckIRemove' then
            self:SetWeaponEnabledByLabel('MissileWeapon01', false)
			
		elseif enh == 'MissileDeckII' then
            self:SetWeaponEnabledByLabel('MissileWeapon02', true)
        elseif enh == 'MissileDeckIIRemove' then
            self:SetWeaponEnabledByLabel('MissileWeapon02', false)
		
		
		elseif enh == 'ChronatronCannonLI' then
            self:SetWeaponEnabledByLabel('UpgradeChronatronCannon01', true)
        elseif enh == 'ChronatronCannonLIRemove' then
            self:SetWeaponEnabledByLabel('UpgradeChronatronCannon01', false)
			
		elseif enh == 'ChronatronCannonRI' then
            self:SetWeaponEnabledByLabel('UpgradeChronatronCannon02', true)
        elseif enh == 'ChronatronCannonRIRemove' then
            self:SetWeaponEnabledByLabel('UpgradeChronatronCannon02', false)
			
		elseif enh == 'ArtyWeaponLI' then
            self:SetWeaponEnabledByLabel('ArtyGun01', true)
        elseif enh == 'ArtyWeaponLIRemove' then
            self:SetWeaponEnabledByLabel('ArtyGun01', false)	
		
		elseif enh == 'ArtyWeaponRI' then
            self:SetWeaponEnabledByLabel('ArtyGun02', true)
        elseif enh == 'ArtyWeaponRIRemove' then
            self:SetWeaponEnabledByLabel('ArtyGun02', false)	
					
		elseif enh == 'AntiAirWeaponLI' then
            self:SetWeaponEnabledByLabel('AntiAir01', true)
        elseif enh == 'AntiAirWeaponLIRemove' then
            self:SetWeaponEnabledByLabel('AntiAir01', false)	
			
		elseif enh == 'AntiAirWeaponRI' then
            self:SetWeaponEnabledByLabel('AntiAir02', true)
        elseif enh == 'AntiAirWeaponRIRemove' then
            self:SetWeaponEnabledByLabel('AntiAir02', false)	
		
		elseif enh == 'AntiAirWeaponLII' then
			local bp = self:GetBlueprint().Enhancements[enh]
            local wep = self:GetWeaponByLabel('AntiAir01')
            wep:ChangeRateOfFire(bp.NewRateOfFire or 1)
        elseif enh == 'AntiAirWeaponLIIRemove' then
			local wep = self:GetWeaponByLabel('AntiAir01')
            local bpDisrupt = self:GetBlueprint().Weapon[1].RateOfFire
            wep:ChangeRateOfFire(bpDisrupt or 0.5) 
			
		elseif enh == 'AntiAirWeaponRII' then
            local bp = self:GetBlueprint().Enhancements[enh]
            local wep = self:GetWeaponByLabel('AntiAir02')
            wep:ChangeRateOfFire(bp.NewRateOfFire or 1)
        elseif enh == 'AntiAirWeaponRIIRemove' then
            local wep = self:GetWeaponByLabel('AntiAir02')
            local bpDisrupt = self:GetBlueprint().Weapon[1].RateOfFire
            wep:ChangeRateOfFire(bpDisrupt or 0.50) 		
			
		end
    end,
    
    OnPaused = function(self)
        SHoverLandUnit.OnPaused(self)
        if self.BuildingUnit then
            SHoverLandUnit.StopBuildingEffects(self, self:GetUnitBeingBuilt())
        end    
    end,
    
    OnUnpaused = function(self)
        if self.BuildingUnit then
            SHoverLandUnit.StartBuildingEffects(self, self:GetUnitBeingBuilt(), self.UnitBuildOrder)
        end
        SHoverLandUnit.OnUnpaused(self)
    end,         

}

TypeClass = XSL0302
