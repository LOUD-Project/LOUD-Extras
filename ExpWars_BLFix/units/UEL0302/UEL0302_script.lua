--****************************************************************************
--**
--**  File     :  /Mods/units/UEL0302/UEL0302_script.lua
--**  Author(s):  Jessica St. Croix, Gordon Duclos
--**
--**  Summary  :  UEF Sub Commander Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
--**
--**	Notes Asdrubaelvect
--** Ne pas tenir compte Left et Right.
--**
--**
--**
--****************************************************************************
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Game = import( '/lua/game.lua' )

-- VARIABLE ''GLOBALE'' ( par Manimal )
local ExpWarsPath = Game.ExpWarsPath
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local TWalkingLandUnit = import( '/lua/terranunits.lua').TWalkingLandUnit

local Shield = import('/lua/shield.lua').Shield
local EffectUtil = import('/lua/EffectUtilities.lua')

local TWeapons = import('/lua/terranweapons.lua')
local TDFHeavyPlasmaCannonWeapon = TWeapons.TDFHeavyPlasmaCannonWeapon

local TIFCruiseMissileUnpackingLauncher = TWeapons.TIFCruiseMissileUnpackingLauncher

local TIFCommanderDeathWeapon = TWeapons.TIFCommanderDeathWeapon

local TIFFragLauncherWeapon = TWeapons.TDFFragmentationGrenadeLauncherWeapon

local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher

local Buff = import('/lua/sim/Buff.lua')

UEL0302 = Class(TWalkingLandUnit) {
    
    IntelEffects = {
		{
			Bones = {
				'Jetpack',
			},
			Scale = 0.5,
			Type = 'Jammer01',
		},
    },    

    Weapons = {
        RightHeavyPlasmaCannon01 = Class(TDFHeavyPlasmaCannonWeapon) {},
		
		MissileWeapon01 = Class(TIFCruiseMissileUnpackingLauncher) {},	
		MissileWeapon02 = Class(TIFCruiseMissileUnpackingLauncher) {},	
		NukeMissileWeapon = Class(TIFCruiseMissileUnpackingLauncher) {},	
		
		RightHeavyPlasmaCannonUpgrade = Class(TDFHeavyPlasmaCannonWeapon) {},
		LeftHeavyPlasmaCannonUpgrade = Class(TDFHeavyPlasmaCannonWeapon) {},
		
		RightGrenade = Class(TIFFragLauncherWeapon) {},
		LeftGrenade = Class(TIFFragLauncherWeapon) {},
		
		MissileRack01 = Class(TSAMLauncher) {},
		MissileRack02 = Class(TSAMLauncher) {},
		
		MissileRack03 = Class(TSAMLauncher) {},
		MissileRack04 = Class(TSAMLauncher) {},
		
        DeathWeapon = Class(TIFCommanderDeathWeapon) {},
    },

    OnCreate = function(self)
        TWalkingLandUnit.OnCreate(self)
        self:SetCapturable(false)
		--Advcd Armor I
		self:HideBone('UpgradeAdvArmor01_01', true)
		self:HideBone('UpgradeAdvArmor01_02', true)
		self:HideBone('UpgradeAdvArmor01_03', true)
		--/Advced Armor I
		--Advcd Armor II
		self:HideBone('UpgradeAdvArmor02_01', true)
		self:HideBone('UpgradeAdvArmor02_02', true)
		self:HideBone('UpgradeAdvArmor02_03', true)
		self:HideBone('UpgradeAdvArmor02_04', true)
		self:HideBone('UpgradeAdvArmor02_05', true)
		self:HideBone('UpgradeAdvArmor02_06', true) --
		--/Advced Armor II
		--Perso Bouclier I
		self:HideBone('ShieldUpgrade01_01', true)
		--/Perso Bouclier I
		--Missile I
		self:HideBone('MissileUpgrade01_01', true)
		self:HideBone('MissileDeckBack', true)
		--/Missile I
		--Missile II
		self:HideBone('MissileUpgrade02_01', true)
		--/Missile II
		--Missile III
		self:HideBone('MissileUpgrade03_01', true)
		--/Missile III
		--AntiTerrestreIArme
		self:HideBone('UpgradeGauche01_01', true)
		self:HideBone('UpgradeDroite01_01', true)
		self:HideBone('UpgradeGauche01_02', true)
		self:HideBone('UpgradeDroite01_02', true)
		--/AntiTerrestreIArme
		--AntiTerrestreIIArme
		self:HideBone('UpgradeRight03_01', true)
		self:HideBone('UpgradeLeft03_01', true)
		--/AntiTerrestreIIArme
		--AntiAirIArme
		self:HideBone('UpgradeAA01_01', true)
		self:HideBone('UpgradeAALeft01_01', true)
		self:HideBone('UpgradeAARight01_01', true)
		--/AntiAirIArme
		--AntiAirIIArme
		self:HideBone('LeftAA02', true)
		self:HideBone('RightAA02', true)
		--/AntiAirIIArme
        self:HideBone('Arm_Left_Barrel02', true) 
        self:HideBone('Arm_Right_Barrel02', true)
		self:HideBone('Arm_Left_Barrel03', true) 
        self:HideBone('Arm_Right_Barrel03', true)
        self:SetupBuildBones()
        
    end,
    
    OnStopBeingBuilt = function(self, builder, layer)
        TWalkingLandUnit.OnStopBeingBuilt(self, builder, layer)
		
		self.WeaponsEnabled = true		
		
		self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannon01', true)
		
        self:SetWeaponEnabledByLabel('MissileWeapon01', false)
        self:SetWeaponEnabledByLabel('MissileWeapon02', false)
		self:SetWeaponEnabledByLabel('NukeMissileWeapon', false)
		
		self:SetWeaponEnabledByLabel('LeftHeavyPlasmaCannonUpgrade', false)
		self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannonUpgrade', false)
		
		self:SetWeaponEnabledByLabel('RightGrenade', false)
		self:SetWeaponEnabledByLabel('LeftGrenade', false)
		
		self:SetWeaponEnabledByLabel('MissileRack01', false)
		self:SetWeaponEnabledByLabel('MissileRack02', false)

		self:SetWeaponEnabledByLabel('MissileRack03', false)
		self:SetWeaponEnabledByLabel('MissileRack04', false)
    end,


    CreateEnhancement = function(self, enh)
        TWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh =='AdvancedArmorI' then
		if not Buffs['UEFHEALTHBUFF'] then
		BuffBlueprint {
                    Name = 'UEFHEALTHBUFF',
                    DisplayName = 'UEFHEALTHBUFF',
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
		Buff.ApplyBuff(self, 'UEFHEALTHBUFF')
		
        elseif enh =='AdvancedArmorIRemove' then
			if Buff.HasBuff( self, 'UEFHEALTHBUFF' ) then
                Buff.RemoveBuff( self, 'UEFHEALTHBUFF' )
            end
		
		elseif enh =='AdvancedArmorII' then
			if not Buffs['UEFHEALTHBUFFII'] then
		BuffBlueprint {
                    Name = 'UEFHEALTHBUFFII',
                    DisplayName = 'UEFHEALTHBUFFII',
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
		Buff.ApplyBuff(self, 'UEFHEALTHBUFFII')
		
        elseif enh =='AdvancedArmorIIRemove' then
			if Buff.HasBuff( self, 'UEFHEALTHBUFFII' ) then
                Buff.RemoveBuff( self, 'UEFHEALTHBUFFII' )
            end
			if Buff.HasBuff( self, 'UEFHEALTHBUFF' ) then
                Buff.RemoveBuff( self, 'UEFHEALTHBUFF' )
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
			if Buff.HasBuff( self, 'UEFHEALTHBUFFII' ) then
                Buff.RemoveBuff( self, 'UEFHEALTHBUFFII' )
            end
			if Buff.HasBuff( self, 'UEFHEALTHBUFF' ) then
                Buff.RemoveBuff( self, 'UEFHEALTHBUFF' )
            end
        elseif enh == 'MissileDeckI' then
            self:SetWeaponEnabledByLabel('MissileWeapon01', true)
        elseif enh == 'MissileDeckIRemove' then
            self:SetWeaponEnabledByLabel('MissileWeapon01', false)
			
		elseif enh == 'MissileDeckII' then
            self:SetWeaponEnabledByLabel('MissileWeapon02', true)
        elseif enh == 'MissileDeckIIRemove' then
            self:SetWeaponEnabledByLabel('MissileWeapon02', false)
			
		elseif enh == 'MissileNukeI' then
            self:SetWeaponEnabledByLabel('NukeMissileWeapon', true)
        elseif enh == 'MissileNukeIRemove' then
            self:SetWeaponEnabledByLabel('NukeMissileWeapon', false) 
		
		elseif enh == 'HeavyPlasmaCannonRI' then
            self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannonUpgrade', true)
        elseif enh == 'HeavyPlasmaCannonRIRemove' then
            self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannonUpgrade', false)
			
		elseif enh == 'HeavyPlasmaCannonLI' then
            self:SetWeaponEnabledByLabel('LeftHeavyPlasmaCannonUpgrade', true)
        elseif enh == 'HeavyPlasmaCannonLIRemove' then
            self:SetWeaponEnabledByLabel('LeftHeavyPlasmaCannonUpgrade', false)	

			
		elseif enh =='AdvancedRangeR1' then ----20%
			local bp = self:GetBlueprint().Enhancements['AdvancedRangeR1']
            if not bp then return end
            local wep1 = self:GetWeaponByLabel('RightHeavyPlasmaCannon01')      
            wep1:ChangeMaxRadius(bp.NewMaxRadius or 30)
			local wep2 = self:GetWeaponByLabel('RightHeavyPlasmaCannonUpgrade')      
            wep2:ChangeMaxRadius(bp.NewMaxRadius or 30)
		elseif enh =='AdvancedRangeR1Remove' then
            local bp = self:GetBlueprint().Enhancements['AdvancedRangeR1']
            if not bp then return end
            local wep5 = self:GetWeaponByLabel('RightHeavyPlasmaCannon01')
			local wep6 = self:GetWeaponByLabel('RightHeavyPlasmaCannonUpgrade')
			local bpDisrupt = self:GetBlueprint().Weapon[1].MaxRadius
            wep5:ChangeMaxRadius(bpDisrupt or 25)
			wep6:ChangeMaxRadius(bpDisrupt or 25)
			
		elseif enh =='AdvancedRangeL1' then ----20%
			local bp = self:GetBlueprint().Enhancements['AdvancedRangeL1']
            if not bp then return end
            local wep3 = self:GetWeaponByLabel('RightHeavyPlasmaCannon01')      
            wep3:ChangeMaxRadius(bp.NewMaxRadius or 30)
			local wep4 = self:GetWeaponByLabel('LeftHeavyPlasmaCannonUpgrade')      
            wep4:ChangeMaxRadius(bp.NewMaxRadius or 30)
		elseif enh =='AdvancedRangeL1Remove' then
            local bp = self:GetBlueprint().Enhancements['AdvancedRangeL1']
            if not bp then return end
            local wep7 = self:GetWeaponByLabel('RightHeavyPlasmaCannon01')
			local wep8 = self:GetWeaponByLabel('LeftHeavyPlasmaCannonUpgrade')
			local bpDisrupt = self:GetBlueprint().Weapon[1].MaxRadius
            wep7:ChangeMaxRadius(bpDisrupt or 25)
			wep8:ChangeMaxRadius(bpDisrupt or 25)	
			
		elseif enh == 'GrenadeR1' then
            self:SetWeaponEnabledByLabel('LeftGrenade', true)
        --elseif enh == 'GrenadeR1Remove' then
		elseif enh == 'GrenadeR1Remove' or enh == 'AdvancedRangeR1Remove' then 
            self:SetWeaponEnabledByLabel('LeftGrenade', false)
			self:SetWeaponEnabledByLabel('RightHeavyPlasmaCannonUpgrade', false)
			
		elseif enh == 'GrenadeL1' then
            self:SetWeaponEnabledByLabel('RightGrenade', true)		
        --elseif enh == 'GrenadeL1Remove' then
        elseif enh == 'GrenadeL1Remove' or enh == 'AdvancedRangeL1Remove' then 
			self:SetWeaponEnabledByLabel('RightGrenade', false)	
			self:SetWeaponEnabledByLabel('LeftHeavyPlasmaCannonUpgrade', false)
		
		elseif enh == 'AntiAirMissilesRI' then
			self:SetWeaponEnabledByLabel('MissileRack01', true)
        elseif enh == 'AntiAirMissilesRIRemove' then
            self:SetWeaponEnabledByLabel('MissileRack01', false)
		elseif enh == 'AntiAirMissilesLI' then
			self:SetWeaponEnabledByLabel('MissileRack02', true)
        elseif enh == 'AntiAirMissilesLIRemove' then
            self:SetWeaponEnabledByLabel('MissileRack02', false)

		elseif enh == 'AntiAirMissilesRII' then
			self:SetWeaponEnabledByLabel('MissileRack03', true)
        elseif enh == 'AntiAirMissilesRIIRemove' then
            self:SetWeaponEnabledByLabel('MissileRack03', false)
		
		elseif enh == 'AntiAirMissilesLII' then
			self:SetWeaponEnabledByLabel('MissileRack04', true)
        elseif enh == 'AntiAirMissilesLIIRemove' then
            self:SetWeaponEnabledByLabel('MissileRack04', false)
		
		end					
    end,



}

TypeClass = UEL0302