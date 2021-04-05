--****************************************************************************
--**
--**  File     :  /cdimage/units/URL0302/URL0302_script.lua
--**  Author(s):  David Tomandl, Jessica St. Croix
--**
--**  Summary  :  Cybran Sub Commander Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local CWalkingLandUnit = import('/lua/cybranunits.lua').CWalkingLandUnit
local CWeapons = import('/lua/cybranweapons.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Buff = import('/lua/sim/Buff.lua')

local CAAMissileNaniteWeapon = CWeapons.CAAMissileNaniteWeapon
local CDFLaserDisintegratorWeapon = CWeapons.CDFLaserDisintegratorWeapon02
local CIFCommanderDeathWeapon = CWeapons.CIFCommanderDeathWeapon

local CIFArtilleryWeapon = import('/lua/cybranweapons.lua').CIFArtilleryWeapon

local CDFHeavyMicrowaveLaserGenerator = CWeapons.CDFHeavyMicrowaveLaserGenerator

local CDFElectronBolterWeapon = CWeapons.CDFElectronBolterWeapon

local CDFParticleCannonWeapon = CWeapons.CDFParticleCannonWeapon

URL0302 = Class(CWalkingLandUnit) {
    --LeftFoot = 'Left_Foot02',
    --RightFoot = 'Right_Foot02',

    Weapons = {
        DeathWeapon = Class(CIFCommanderDeathWeapon) {},
        RightDisintegrator = Class(CDFLaserDisintegratorWeapon) {},
		
		UpgradeRightDisintegrator = Class(CDFLaserDisintegratorWeapon) {},
		UpgradeLeftDisintegrator = Class(CDFLaserDisintegratorWeapon) {},
		
		ArtyGun = Class(CIFArtilleryWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/cybran_artillery_muzzle_flash_01_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_flash_02_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_smoke_01_emit.bp',
            },
        },

		MLG = Class(CDFHeavyMicrowaveLaserGenerator) {
            DisabledFiringBones = {'MLGMuzzle01'},
            
            SetOnTransport = function(self, transportstate)
                CDFHeavyMicrowaveLaserGenerator.SetOnTransport(self, transportstate)
                self:ForkThread(self.OnTransportWatch)
            end,
            
            OnTransportWatch = function(self)
                while self:GetOnTransport() do
                    self:PlayFxBeamEnd()
                    self:SetWeaponEnabled(false)
                    WaitSeconds(0.3)
                end
            end,          
        },
		
		RightLaserTurret01 = Class(CDFElectronBolterWeapon) {},
        LeftLaserTurret01 = Class(CDFElectronBolterWeapon) {},
		RightLaserTurret02 = Class(CDFElectronBolterWeapon) {},
        LeftLaserTurret02 = Class(CDFElectronBolterWeapon) {},
		
		AAGunRight = Class(CDFParticleCannonWeapon) {},
		AAGunLeft = Class(CDFParticleCannonWeapon) {},
		
        NMissile = Class(CAAMissileNaniteWeapon) {},
    },

    -- ********
    -- Creation
    -- ********
    OnCreate = function(self)
        CWalkingLandUnit.OnCreate(self)
        self:SetCapturable(false)
		----Armure 1
        self:HideBone('ArmureUpgrade01_01', true)
		self:HideBone('ArmureUpgrade01_02', true)
		self:HideBone('ArmureUpgrade01_03', true)
		self:HideBone('ArmureUpgrade01_04', true)
		self:HideBone('ArmureUpgrade01_05', true)
		----/Armure 1	
		----Armure 2
		self:HideBone('ArmureUpgrade02_01', true)
		self:HideBone('ArmureUpgrade02_02', true)
		self:HideBone('ArmureUpgrade02_03', true)
		self:HideBone('ArmureUpgrade02_04', true)
		----/Armure 2	
		----Armure 3
		self:HideBone('ArmureUpgrade03_01', true)
		self:HideBone('ArmureUpgrade03_02', true)
		self:HideBone('ArmureUpgrade03_03', true)
		self:HideBone('ArmureUpgrade03_04', true)
		self:HideBone('ArmureUpgrade03_05', true)
		self:HideBone('ArmureUpgrade03_06', true)
		----/Armure 3
		----Stealth
		self:HideBone('Stealth01', true)
		----/Stealth
		----Cloak
		self:HideBone('Cloak01', true)
		----/Cloak	
		----Arty
		self:HideBone('UpgradeArty01', true)
		----/Arty
		----MLG
		self:HideBone('UpgradeMLG01', true)
		----/MLG
		----ArmeUpgrade
		self:HideBone('UpgradeArmeLeft01', true)
		self:HideBone('UpgradeArmeRight01', true)
		----/ArmeUpgrade
		----UpgradeArmeIII
		self:HideBone('UpgradeArme01', true)
		self:HideBone('UpgradeArme02', true)
		self:HideBone('UpgradeArme03', true)
		self:HideBone('UpgradeArme04', true)
		----/UpgradearmeIII
		----RocketPads
		self:HideBone('RightRocketPad01', true)
		self:HideBone('RightRocketPad02', true)
		self:HideBone('LeftRocketPad01', true)
		self:HideBone('LeftRocketPad02', true)
		----/RocketPads
		----AntiAir
		self:HideBone('UpgradeAntiAirRight', true)
		self:HideBone('UpgradeAntiAirLeft', true)
		----/AntiAir
		
        self:SetWeaponEnabledByLabel('NMissile', false)
		self:SetWeaponEnabledByLabel('ArtyGun', false)
		self:SetWeaponEnabledByLabel('MLG', false)  
		self:SetWeaponEnabledByLabel('UpgradeRightDisintegrator', false)  
		self:SetWeaponEnabledByLabel('UpgradeLeftDisintegrator', false)  
		
		self:SetWeaponEnabledByLabel('RightLaserTurret01', false)  
		self:SetWeaponEnabledByLabel('RightLaserTurret02', false)  
		
		self:SetWeaponEnabledByLabel('LeftLaserTurret01', false)  
		self:SetWeaponEnabledByLabel('LeftLaserTurret02', false)  
		
		self:SetWeaponEnabledByLabel('AAGunRight', false)
		self:SetWeaponEnabledByLabel('AAGunLeft', false)
		
        if self:GetBlueprint().General.BuildBones then
            self:SetupBuildBones()
        end
        self.IntelButtonSet = true
    end,

    OnPrepareArmToBuild = function(self)
        CWalkingLandUnit.OnPrepareArmToBuild(self)
        self:BuildManipulatorSetEnabled(true)
        self.BuildArmManipulator:SetPrecedence(20)
        self:SetWeaponEnabledByLabel('RightDisintegrator', false)
        self.BuildArmManipulator:SetHeadingPitch( self:GetWeaponManipulatorByLabel('RightDisintegrator'):GetHeadingPitch() )
    end,
    
    OnStopCapture = function(self, target)
        CWalkingLandUnit.OnStopCapture(self, target)
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self:SetWeaponEnabledByLabel('RightDisintegrator', true)
        self:GetWeaponManipulatorByLabel('RightDisintegrator'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,

    OnFailedCapture = function(self, target)
        CWalkingLandUnit.OnFailedCapture(self, target)
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self:SetWeaponEnabledByLabel('RightDisintegrator', true)
        self:GetWeaponManipulatorByLabel('RightDisintegrator'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,
    
    OnStopReclaim = function(self, target)
        CWalkingLandUnit.OnStopReclaim(self, target)
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self:SetWeaponEnabledByLabel('RightDisintegrator', true)
        self:GetWeaponManipulatorByLabel('RightDisintegrator'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,

    -- ********
    -- Engineering effects
    -- ********
    OnStartBuild = function(self, unitBeingBuilt, order)    
        CWalkingLandUnit.OnStartBuild(self, unitBeingBuilt, order)
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true   
    end,    

    OnStopBuild = function(self, unitBeingBuilt)
        CWalkingLandUnit.OnStopBuild(self, unitBeingBuilt)
        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil
        self.BuildingUnit = false
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)   
        self:SetWeaponEnabledByLabel('RightDisintegrator', true)    
        self:GetWeaponManipulatorByLabel('RightDisintegrator'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,    
    
    OnFailedToBuild = function(self)
        CWalkingLandUnit.OnFailedToBuild(self)
        self:BuildManipulatorSetEnabled(false)
        self.BuildArmManipulator:SetPrecedence(0)
        self:SetWeaponEnabledByLabel('RightDisintegrator', true)
        self:GetWeaponManipulatorByLabel('RightDisintegrator'):SetHeadingPitch( self.BuildArmManipulator:GetHeadingPitch() )
    end,
    
    CreateBuildEffects = function( self, unitBeingBuilt, order )
       EffectUtil.SpawnBuildBots( self, unitBeingBuilt, 3, self.BuildEffectsBag )
       EffectUtil.CreateCybranBuildBeams( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        self:BuildManipulatorSetEnabled(false)
        self:SetMaintenanceConsumptionInactive()
        self:DisableUnitIntel('RadarStealth')
        self:DisableUnitIntel('SonarStealth')
        self:DisableUnitIntel('Cloak')
        self.LeftArmUpgrade = 'EngineeringArm'
        self.RightArmUpgrade = 'Disintegrator'
    end,

    SetupIntel = function(self, layer)
        CWalkingLandUnit.SetupIntel(self)
        if layer == 'Seabed' or layer == 'Sub' then
            self:EnableIntel('WaterVision')
        else
            self:EnableIntel('Vision')
        end

        self:EnableIntel('Radar')
        self:EnableIntel('Sonar')
    end,



    OnScriptBitSet = function(self, bit)
        if bit == 8 then -- cloak toggle
            self:StopUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionInactive()
            self:DisableUnitIntel('Cloak')
            self:DisableUnitIntel('RadarStealth')
            self:DisableUnitIntel('RadarStealthField')
            self:DisableUnitIntel('SonarStealth')
            self:DisableUnitIntel('SonarStealthField')          
        end
    end,

    OnScriptBitClear = function(self, bit)
        if bit == 8 then -- cloak toggle
            self:PlayUnitAmbientSound( 'ActiveLoop' )
            self:SetMaintenanceConsumptionActive()
            self:EnableUnitIntel('Cloak')
            self:EnableUnitIntel('RadarStealth')
            self:EnableUnitIntel('RadarStealthField')
            self:EnableUnitIntel('SonarStealth')
            self:EnableUnitIntel('SonarStealthField')
        end
    end,
           

    -- ************
    -- Enhancements
    -- ************
    CreateEnhancement = function(self, enh)
        CWalkingLandUnit.CreateEnhancement(self, enh)
        local bp = self:GetBlueprint().Enhancements[enh]
        if not bp then return end
        if enh == 'CloakingGenerator' then
            self.StealthEnh = false
			self.CloakEnh = true 
            self:EnableUnitIntel('Cloak')
             		
        elseif enh == 'CloakingGeneratorRemove' then
            self:DisableUnitIntel('Cloak')
            self.StealthEnh = false
            self.CloakEnh = false 
            self:RemoveToggleCap('RULEUTC_CloakToggle')
        elseif enh == 'StealthGenerator' then
            self:AddToggleCap('RULEUTC_CloakToggle')
            if self.IntelEffectsBag then
                EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
                self.IntelEffectsBag = nil
            end
            self.CloakEnh = false        
            self.StealthEnh = true
            self:EnableUnitIntel('RadarStealth')
            self:EnableUnitIntel('SonarStealth')          
        elseif enh == 'StealthGeneratorRemove' then
            self:RemoveToggleCap('RULEUTC_CloakToggle')
            self:DisableUnitIntel('RadarStealth')
            self:DisableUnitIntel('SonarStealth')           
            self.StealthEnh = false
            self.CloakEnh = false 
			
			
        elseif enh == 'AdvancedArmorI' then
            if not Buffs['ArmureIBonus'] then
               BuffBlueprint {
                    Name = 'ArmureIBonus',
                    DisplayName = 'ArmureIBonus',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'ALWAYS',
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
            if Buff.HasBuff( self, 'ArmureIBonus' ) then
                Buff.RemoveBuff( self, 'ArmureIBonus' )
            end  
            Buff.ApplyBuff(self, 'ArmureIBonus')                		
        elseif enh == 'AdvancedArmorIRemove' then
            if Buff.HasBuff( self, 'ArmureIBonus' ) then
                Buff.RemoveBuff( self, 'ArmureIBonus' )
            end 			
		
		elseif enh == 'AdvancedArmorII' then
            if not Buffs['ArmureIIBonus'] then
               BuffBlueprint {
                    Name = 'ArmureIIBonus',
                    DisplayName = 'ArmureIIBonus',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'ALWAYS',
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
            if Buff.HasBuff( self, 'ArmureIIBonus' ) then
                Buff.RemoveBuff( self, 'ArmureIIBonus' )
            end  
            Buff.ApplyBuff(self, 'ArmureIIBonus')                		
        elseif enh == 'AdvancedArmorIIRemove' then
            if Buff.HasBuff( self, 'ArmureIIBonus' ) then
                Buff.RemoveBuff( self, 'ArmureIIBonus' )
            end 		
			if Buff.HasBuff( self, 'ArmureIBonus' ) then
                Buff.RemoveBuff( self, 'ArmureIBonus' )	
            end	
		elseif enh == 'AdvancedArmorIII' then 
            if not Buffs['ArmureIIIBonus'] then
               BuffBlueprint {
                    Name = 'ArmureIIIBonus',
                    DisplayName = 'ArmureIIIBonus',
                    BuffType = 'MAXHEALTH',
                    Stacks = 'ALWAYS',
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
            if Buff.HasBuff( self, 'ArmureIIIBonus' ) then
                Buff.RemoveBuff( self, 'ArmureIIIBonus' )
            end  
            Buff.ApplyBuff(self, 'ArmureIIIBonus')                		
        elseif enh == 'AdvancedArmorIIIRemove' then
			if Buff.HasBuff( self, 'ArmureIBonus' ) then
                Buff.RemoveBuff( self, 'ArmureIBonus' )	
            end
			if Buff.HasBuff( self, 'ArmureIIBonus' ) then
                Buff.RemoveBuff( self, 'ArmureIIBonus' )
			end	
			if Buff.HasBuff( self, 'ArmureIIIBonus' ) then
                Buff.RemoveBuff( self, 'ArmureIIIBonus' )
            end 

		elseif enh == 'ArtyUpgrade' then
            self:SetWeaponEnabledByLabel('ArtyGun', true)
        elseif enh == 'ArtyUpgradeRemove' then
            self:SetWeaponEnabledByLabel('ArtyGun', false)
		elseif enh == 'MicrowaveLaserGenerator' then
            self:SetWeaponEnabledByLabel('MLG', true)
        elseif enh == 'MicrowaveLaserGeneratorRemove' then
            self:SetWeaponEnabledByLabel('MLG', false)
			
		elseif enh == 'DisintegratorPulseLaserR' then
            self:SetWeaponEnabledByLabel('UpgradeRightDisintegrator', true)
        elseif enh == 'DisintegratorPulseLaserRRemove' then
            self:SetWeaponEnabledByLabel('UpgradeRightDisintegrator', false)
			
		elseif enh == 'DisintegratorPulseLaserL' then
            self:SetWeaponEnabledByLabel('UpgradeLeftDisintegrator', true)
        elseif enh == 'DisintegratorPulseLaserLRemove' then
            self:SetWeaponEnabledByLabel('UpgradeLeftDisintegrator', false)	
	
		
		elseif enh == 'ElectronBolterR' then
            self:SetWeaponEnabledByLabel('RightLaserTurret01', true)  
			self:SetWeaponEnabledByLabel('RightLaserTurret02', true)  
        elseif enh == 'ElectronBolterRRemove' then
            self:SetWeaponEnabledByLabel('RightLaserTurret01', false)  
			self:SetWeaponEnabledByLabel('RightLaserTurret02', false)  	
		
		elseif enh == 'ElectronBolterL' then
            self:SetWeaponEnabledByLabel('LeftLaserTurret01', true)  
			self:SetWeaponEnabledByLabel('LeftLaserTurret02', true)  
        elseif enh == 'ElectronBolterLRemove' then
            self:SetWeaponEnabledByLabel('LeftLaserTurret01', false)  
			self:SetWeaponEnabledByLabel('LeftLaserTurret02', false)  	
		
		elseif enh =='AdvancedDamagesR' then
            local wep = self:GetWeaponByLabel('RightDisintegrator')
			local wep2 = self:GetWeaponByLabel('UpgradeRightDisintegrator')
			local wep3 = self:GetWeaponByLabel('RightLaserTurret01')
			local wep4 = self:GetWeaponByLabel('RightLaserTurret02')		
            wep:AddDamageMod(bp.DesintegratorDamageMod)          
            wep2:AddDamageMod(bp.DesintegratorDamageMod)
			wep3:AddDamageMod(bp.LaserDamageMod)  
			wep4:AddDamageMod(bp.LaserDamageMod)  
        elseif enh =='AdvancedDamagesRRemove' then
            local bp = self:GetBlueprint().Enhancements['RightDisintegrator']	
			local bp = self:GetBlueprint().Enhancements['UpgradeRightDisintegrator']
			local bp = self:GetBlueprint().Enhancements['RightLaserTurret01']
			local bp = self:GetBlueprint().Enhancements['RightLaserTurret02']			
            if not bp then return end
            local wep = self:GetWeaponByLabel('RightDisintegrator')
			local wep2 = self:GetWeaponByLabel('UpgradeRightDisintegrator')
            wep:AddDamageMod(-bp.DesintegratorDamageMod)
			wep2:AddDamageMod(-bp.DesintegratorDamageMod)		
			local wep3 = self:GetWeaponByLabel('RightLaserTurret01')
			local wep4 = self:GetWeaponByLabel('RightLaserTurret02')
			wep3:AddDamageMod(-bp.LaserDamageMod)
			wep4:AddDamageMod(-bp.LaserDamageMod)

		elseif enh =='AdvancedDamagesL' then
            local wep = self:GetWeaponByLabel('RightDisintegrator')
			local wep2 = self:GetWeaponByLabel('UpgradeRightDisintegrator')
			local wep3 = self:GetWeaponByLabel('RightLaserTurret01')
			local wep4 = self:GetWeaponByLabel('RightLaserTurret02')		
            wep:AddDamageMod(bp.DesintegratorDamageMod)          
            wep2:AddDamageMod(bp.DesintegratorDamageMod)
			wep3:AddDamageMod(bp.LaserDamageMod)  
			wep4:AddDamageMod(bp.LaserDamageMod)  
        elseif enh =='AdvancedDamagesLRemove' then
            local bp = self:GetBlueprint().Enhancements['RightDisintegrator']	
			local bp = self:GetBlueprint().Enhancements['UpgradeLeftDisintegrator']
			local bp = self:GetBlueprint().Enhancements['LeftLaserTurret01']
			local bp = self:GetBlueprint().Enhancements['LeftLaserTurret02']			
            if not bp then return end
            local wep = self:GetWeaponByLabel('RightDisintegrator')
			local wep2 = self:GetWeaponByLabel('UpgradeLeftDisintegrator')
            wep:AddDamageMod(-bp.DesintegratorDamageMod)
			wep2:AddDamageMod(-bp.DesintegratorDamageMod)		
			local wep3 = self:GetWeaponByLabel('LeftLaserTurret01')
			local wep4 = self:GetWeaponByLabel('LeftLaserTurret02')
			wep3:AddDamageMod(-bp.LaserDamageMod)
			wep4:AddDamageMod(-bp.LaserDamageMod)
	
        elseif enh == 'AntiAirUpgradeR' then
            self:SetWeaponEnabledByLabel('AAGunRight', true)
        elseif enh == 'AntiAirUpgradeRRemove' then
			self:SetWeaponEnabledByLabel('AAGunRight', false)
		elseif enh == 'AntiAirUpgradeL' then
            self:SetWeaponEnabledByLabel('AAGunLeft', true)
        elseif enh == 'AntiAirUpgradeLRemove' then
			self:SetWeaponEnabledByLabel('AAGunLeft', false)	
		
		elseif enh == 'AdvancedAntiAirR' then
			local bp = self:GetBlueprint().Enhancements['AdvancedAntiAirR']	
            if not bp then return end
            local wep = self:GetWeaponByLabel('AAGunRight')
			wep:ChangeMaxRadius(bp.NewMaxRadius or 45)
        elseif enh == 'AdvancedAntiAirRRemove' then
			local bp = self:GetBlueprint().Enhancements['AdvancedAntiAirR']
            if not bp then return end
            local wep = self:GetWeaponByLabel('AAGunRight')
            local bpDisrupt = self:GetBlueprint().Weapon[1].MaxRadius
            wep:ChangeMaxRadius(bpDisrupt or 30)  		
			
		elseif enh == 'AdvancedAntiAirL' then
			local bp = self:GetBlueprint().Enhancements['AdvancedAntiAirL']	
            if not bp then return end
            local wep = self:GetWeaponByLabel('AAGunLeft')
			wep:ChangeMaxRadius(bp.NewMaxRadius or 100)
        elseif enh == 'AdvancedAntiAirLRemove' then
			local bp = self:GetBlueprint().Enhancements['AdvancedAntiAirL']
            if not bp then return end
            local wep = self:GetWeaponByLabel('AAGunLeft')
            local bpDisrupt = self:GetBlueprint().Weapon[1].MaxRadius
            wep:ChangeMaxRadius(bpDisrupt or 30) 	
       
        end             
    end,

    -- *****
    -- Death
    -- *****
    OnKilled = function(self, instigator, type, overkillRatio)
        local bp
        for k, v in self:GetBlueprint().Buffs do
            if v.Add.OnDeath then
                bp = v
            end
        end 
        --if we could find a blueprint with v.Add.OnDeath, then add the buff 
        if bp != nil then 
            --Apply Buff
			self:AddBuff(bp)
        end
        --otherwise, we should finish killing the unit
        CWalkingLandUnit.OnKilled(self, instigator, type, overkillRatio)
    end,
    
    IntelEffects = {
		Cloak = {
		    {
			    Bones = {
				    'Head',
				    'LeftBras03',
					'RightBras03',
					'LeftBras03',
				    'RightBras01',
					'LeftBras01',
				    'Torso',
				    'URL0301', --Normal
				    'Right_Leg01_B03',
					'Right_Leg01_B02',
					'Right_Leg01_B01',
					'Left_Leg01_B03',
					'Left_Leg01_B02',
					'Left_Leg01_B01',
					
					'Right_Leg02_B03',
					'Right_Leg02_B02',
					'Right_Leg02_B01',
					'Left_Leg02_B03',
					'Left_Leg02_B02',
					'Left_Leg02_B01',
		    },
			    Scale = 1.0,
			    Type = 'Cloak01',
		    },
		},
		Field = {
		    {
			    Bones = {
				    'Head',
				    'LeftBras03',
					'RightBras03',
					'LeftBras03',
				    'RightBras01',
					'LeftBras01',
				    'Torso',
				    'URL0301',  --Normal
				    'Right_Leg01_B03',
					'Right_Leg01_B02',
					'Right_Leg01_B01',
					'Left_Leg01_B03',
					'Left_Leg01_B02',
					'Left_Leg01_B01',
					
					'Right_Leg02_B03',
					'Right_Leg02_B02',
					'Right_Leg02_B01',
					'Left_Leg02_B03',
					'Left_Leg02_B02',
					'Left_Leg02_B01',
			    },
			    Scale = 1.6,
			    Type = 'Cloak01',
		    },	
        },	
    },
    
    OnIntelEnabled = function(self)
        CWalkingLandUnit.OnIntelEnabled(self)
        if self.CloakEnh and self:IsIntelEnabled('Cloak') then 
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['CloakingGenerator'].MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()
            if not self.IntelEffectsBag then
			    self.IntelEffectsBag = {}
			    self.CreateTerrainTypeEffects( self, self.IntelEffects.Cloak, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
			end            
        elseif self.StealthEnh and self:IsIntelEnabled('RadarStealth') and self:IsIntelEnabled('SonarStealth') then
            self:SetEnergyMaintenanceConsumptionOverride(self:GetBlueprint().Enhancements['StealthGenerator'].MaintenanceConsumptionPerSecondEnergy or 0)
            self:SetMaintenanceConsumptionActive()  
            if not self.IntelEffectsBag then 
	            self.IntelEffectsBag = {}
		        self.CreateTerrainTypeEffects( self, self.IntelEffects.Field, 'FXIdle',  self:GetCurrentLayer(), nil, self.IntelEffectsBag )
		    end                  
        end		
    end,

    OnIntelDisabled = function(self)
        CWalkingLandUnit.OnIntelDisabled(self)
        if self.IntelEffectsBag then
            EffectUtil.CleanupEffectBag(self,'IntelEffectsBag')
            self.IntelEffectsBag = nil
        end
        if self.CloakEnh and not self:IsIntelEnabled('Cloak') then
            self:SetMaintenanceConsumptionInactive()
        elseif self.StealthEnh and not self:IsIntelEnabled('RadarStealth') and not self:IsIntelEnabled('SonarStealth') then
            self:SetMaintenanceConsumptionInactive()
        end          
    end,
    
    OnPaused = function(self)
        CWalkingLandUnit.OnPaused(self)
        if self.BuildingUnit then
            CWalkingLandUnit.StopBuildingEffects(self, self:GetUnitBeingBuilt())
        end    
    end,
    
    OnUnpaused = function(self)
        if self.BuildingUnit then
            CWalkingLandUnit.StartBuildingEffects(self, self:GetUnitBeingBuilt(), self.UnitBuildOrder)
        end
        CWalkingLandUnit.OnUnpaused(self)
    end,        
}

TypeClass = URL0302
