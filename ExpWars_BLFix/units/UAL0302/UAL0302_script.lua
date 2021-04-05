--[[------------------------------------------------------------------------
--  File	 :  /units/UAL0302/UAL0302_script.lua
--  Author(s):  Jessica St. Croix
--  Summary  :  Aeon Sub Commander Script UAL0302
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  -----------------------------
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Game = import( '/lua/game.lua' )

-- VARIABLE ''GLOBALE'' ( par Manimal )
local ExpWarsPath = Game.ExpWarsPath
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local AWalkingLandUnit = import( '/lua/aeonunits.lua' ).AWalkingLandUnit

local AWeapons = import('/lua/aeonweapons.lua')
local ADFReactonCannon = AWeapons.ADFReactonCannon
local AIFCommanderDeathWeapon = AWeapons.AIFCommanderDeathWeapon

local AIFMissileTacticalSerpentineWeapon = import('/lua/aeonweapons.lua').AIFMissileTacticalSerpentineWeapon

local AAAZealotMissileWeapon = import('/lua/aeonweapons.lua').AAAZealotMissileWeapon

local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')



UAL0302 = Class(AWalkingLandUnit) {    
    Weapons = {
        ReactonCannon = Class(ADFReactonCannon) {},
		
		CenterHeavyCannon = Class(ADFReactonCannon) {},
		
		MissileRack = Class(AIFMissileTacticalSerpentineWeapon) {},
		
		LeftUpgradeReactonCannon = Class(ADFReactonCannon) {},
		RightUpgradeReactonCannon = Class(ADFReactonCannon) {},
		
		AntiAirMissiles01L = Class(AAAZealotMissileWeapon) {},
		AntiAirMissiles01R = Class(AAAZealotMissileWeapon) {},
		AntiAirMissiles02L = Class(AAAZealotMissileWeapon) {},
		AntiAirMissiles02R = Class(AAAZealotMissileWeapon) {},
		
        DeathWeapon = Class(AIFCommanderDeathWeapon) {},
    },
    
    
    OnCreate = function(self)
        AWalkingLandUnit.OnCreate(self)
        self:SetCapturable(false)
        self:HideBone('UpgradeArmure01_01', true)
		self:HideBone('UpgradeShield01_01', true)
		self:HideBone('UpgradeShield01_02', true)
		self:HideBone('UpgradeShield01_03', true)
		self:HideBone('UpgradeShield01_04', true)
		self:HideBone('UpgradeArmeLourde01_01', true)
		self:HideBone('UpgradeLanceMissile', true)
		self:HideBone('UpgradeArmeLeft01', true)
		self:HideBone('UpgradeArmeRight01', true)
		self:HideBone('UpgradeArmeRight02_01', true)
		self:HideBone('UpgradeArmeLeft02_01', true)
		
		self:HideBone('UpgradeArmeLeft03_02', true)
		self:HideBone('UpgradeArmeRight03_02', true)
		
		self:HideBone('Fix_AA_Right_01', true)
		self:HideBone('Fix_AA_Right_02', true)
		
		self:HideBone('Fix_AA_Left_01', true)
		self:HideBone('Fix_AA_Left_02', true)
		
		self:SetWeaponEnabledByLabel('CenterHeavyCannon', false)
		self:SetWeaponEnabledByLabel('MissileRack', false)
		self:SetWeaponEnabledByLabel('LeftUpgradeReactonCannon', false)
		self:SetWeaponEnabledByLabel('RightUpgradeReactonCannon', false)
		
		self:SetWeaponEnabledByLabel('AntiAirMissiles01L', false)
		self:SetWeaponEnabledByLabel('AntiAirMissiles01R', false)
		self:SetWeaponEnabledByLabel('AntiAirMissiles02L', false)
		self:SetWeaponEnabledByLabel('AntiAirMissiles02R', false)
        self:SetupBuildBones()
    end,
    
    CreateEnhancement = function(self, enh)
        AWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
		if enh =='AdvancedArmorI' then
		if not Buffs['AEONHEALTHBUFF'] then
		BuffBlueprint {
                    Name = 'AEONHEALTHBUFF',
                    DisplayName = 'AEONHEALTHBUFF',
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
		Buff.ApplyBuff(self, 'AEONHEALTHBUFF')
		
        elseif enh =='AdvancedArmorIRemove' then
			if Buff.HasBuff( self, 'AEONHEALTHBUFF' ) then
                Buff.RemoveBuff( self, 'AEONHEALTHBUFF' )
            end
		
		elseif enh =='AdvancedArmorII' then
			if not Buffs['AEONHEALTHBUFFII'] then
		BuffBlueprint {
                    Name = 'AEONHEALTHBUFFII',
                    DisplayName = 'AEONHEALTHBUFFII',
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
		Buff.ApplyBuff(self, 'AEONHEALTHBUFFII')
		
        elseif enh =='AdvancedArmorIIRemove' then
			if Buff.HasBuff( self, 'AEONHEALTHBUFFII' ) then
                Buff.RemoveBuff( self, 'AEONHEALTHBUFFII' )
            end
		
        elseif enh == 'Shield' then
            self:AddToggleCap('RULEUTC_ShieldToggle')
            self:CreatePersonalShield(bp)
            self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
        elseif enh == 'ShieldRemove' then
            self:DestroyShield()
            self:SetMaintenanceConsumptionInactive()
            RemoveUnitEnhancement(self, 'ShieldRemove')
            self:RemoveToggleCap('RULEUTC_ShieldToggle')
			
		elseif enh == 'CenterHeavyCannon' then
            self:SetWeaponEnabledByLabel('CenterHeavyCannon', true)
        elseif enh == 'CenterHeavyCannonRemove' then
			self:SetWeaponEnabledByLabel('CenterHeavyCannon', false)	
			
		elseif enh == 'CenterMissiles' then
            self:SetWeaponEnabledByLabel('MissileRack', true)
        elseif enh == 'CenterMissilesRemove' then
			self:SetWeaponEnabledByLabel('MissileRack', false)		
			
		elseif enh == 'LeftReactonCannon' then
            self:SetWeaponEnabledByLabel('LeftUpgradeReactonCannon', true)
        elseif enh == 'LeftReactonCannonRemove' then
			self:SetWeaponEnabledByLabel('LeftUpgradeReactonCannon', false)	
		
		elseif enh == 'RightReactonCannon' then
            self:SetWeaponEnabledByLabel('RightUpgradeReactonCannon', true)
        elseif enh == 'RightReactonCannonRemove' then
			self:SetWeaponEnabledByLabel('RightUpgradeReactonCannon', false)	
		
		
		elseif enh == 'RightMaxRadius' then
            local wep = self:GetWeaponByLabel('RightUpgradeReactonCannon')
            wep:ChangeMaxRadius(bp.NewMaxRadius or 36)
			local wep2 = self:GetWeaponByLabel('ReactonCannon')
            wep2:ChangeMaxRadius(bp.NewMaxRadius or 36)
        elseif enh == 'RightMaxRadiusRemove' then
            local wep = self:GetWeaponByLabel('RightUpgradeReactonCannon')
            local bpDisrupt = self:GetBlueprint().Weapon[1].MaxRadius
            wep:ChangeMaxRadius(bpDisrupt or 30)
			
		elseif enh == 'LeftMaxRadius' then
            local wep = self:GetWeaponByLabel('LeftUpgradeReactonCannon')
            wep:ChangeMaxRadius(bp.NewMaxRadius or 36)
			local wep2 = self:GetWeaponByLabel('ReactonCannon')
            wep2:ChangeMaxRadius(bp.NewMaxRadius or 36)
        elseif enh == 'LeftMaxRadiusRemove' then
            local wep = self:GetWeaponByLabel('LeftUpgradeReactonCannon')
            local bpDisrupt = self:GetBlueprint().Weapon[1].MaxRadius
            wep:ChangeMaxRadius(bpDisrupt or 30)
			
		--StabilitySupressant
        elseif enh =='RightStabilitySuppressant' then
            local wep = self:GetWeaponByLabel('RightUpgradeReactonCannon')
            wep:AddDamageMod(bp.NewDamageMod or 0)
			local wep2 = self:GetWeaponByLabel('ReactonCannon')
            wep2:AddDamageMod(bp.NewDamageMod or 0)
        elseif enh =='RightStabilitySuppressantRemove' then  ----VOIR PLUS TARD POUR AND ENH
            local wep = self:GetWeaponByLabel('RightReactonCannon')
            wep:AddDamageRadiusMod(bp.NewDamageRadiusMod or 0)	
		
		elseif enh =='LeftStabilitySuppressant' then
            local wep = self:GetWeaponByLabel('LeftUpgradeReactonCannon')
            wep:AddDamageMod(bp.NewDamageMod or 0)
			local wep2 = self:GetWeaponByLabel('ReactonCannon')
            wep2:AddDamageMod(bp.NewDamageMod or 0)
        elseif enh =='LeftStabilitySuppressantRemove' then  ----VOIR PLUS TARD POUR AND ENH
            local wep = self:GetWeaponByLabel('LeftReactonCannon')
            wep:AddDamageRadiusMod(bp.NewDamageRadiusMod or 0)	
			
			
		elseif enh == 'AntiAirUpgradeR' then
            self:SetWeaponEnabledByLabel('AntiAirMissiles01R', true)
        elseif enh == 'AntiAirUpgradeRRemove' then
			self:SetWeaponEnabledByLabel('AntiAirMissiles01R', false)
		elseif enh == 'AntiAirUpgradeL' then
            self:SetWeaponEnabledByLabel('AntiAirMissiles01L', true)
        elseif enh == 'AntiAirUpgradeLRemove' then
			self:SetWeaponEnabledByLabel('AntiAirMissiles01L', false)	

		elseif enh == 'AntiAirUpgrade02R' then
            self:SetWeaponEnabledByLabel('AntiAirMissiles02R', true)
        elseif enh == 'AntiAirUpgrade02RRemove' then
			self:SetWeaponEnabledByLabel('AntiAirMissiles02R', false)
		elseif enh == 'AntiAirUpgrade02L' then
            self:SetWeaponEnabledByLabel('AntiAirMissiles02L', true)
        elseif enh == 'AntiAirUpgrade02LRemove' then
			self:SetWeaponEnabledByLabel('AntiAirMissiles02L', false)	
		
			
        end
    end,
    
    --[[CreateHeavyShield = function(self, bp)
        WaitTicks(1)
        self:CreatePersonalShield(bp)
        self:SetEnergyMaintenanceConsumptionOverride(bp.MaintenanceConsumptionPerSecondEnergy or 0)     
        self:SetMaintenanceConsumptionActive()
    end,  ]]--  
    
    OnPaused = function(self)
        AWalkingLandUnit.OnPaused(self)
        if self.BuildingUnit then
            AWalkingLandUnit.StopBuildingEffects(self, self:GetUnitBeingBuilt())
        end    
    end,
    
    OnUnpaused = function(self)
        if self.BuildingUnit then
            AWalkingLandUnit.StartBuildingEffects(self, self:GetUnitBeingBuilt(), self.UnitBuildOrder)
        end
        AWalkingLandUnit.OnUnpaused(self)
    end,         
}

TypeClass = UAL0302
