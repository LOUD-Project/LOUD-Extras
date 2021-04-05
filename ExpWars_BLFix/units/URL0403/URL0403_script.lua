--****************************************************************************
--**
--**  File     :  /cdimage/units/URL0402/URL0402_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
--**
--**  Summary  :  Cybran Spider Bot Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------


local CWalkingLandUnit = import( '/lua/cybranunits.lua').CWalkingLandUnit
local Weapon = import('/lua/sim/Weapon.lua').Weapon
local CybranWeaponsFile = import(ExpWarsPath .. '/lua/modweapons.lua')

local CybranWeaponsFile2 = import('/lua/cybranweapons.lua')

local CDFHeavyMicrowaveLaserGeneratorDefense = CybranWeaponsFile.CDFHeavyMicrowaveLaserGeneratorDefense
local CDFHvyProtonCannonWeapon = CybranWeaponsFile2.CDFHvyProtonCannonWeapon
local CDFElectronBolterWeapon = CybranWeaponsFile2.CDFElectronBolterWeapon
local CAAMissileNaniteWeapon = CybranWeaponsFile2.CAAMissileNaniteWeapon


local explosion = import('/lua/defaultexplosions.lua')
local CreateDeathExplosion = explosion.CreateDefaultHitExplosionAtBone
local EffectTemplate = import('/lua/EffectTemplates.lua')
local utilities = import('/lua/Utilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')
local Entity = import('/lua/sim/Entity.lua').Entity


URL0403 = Class(CWalkingLandUnit) {

 Weapons = {
        MainGun = Class(CDFHeavyMicrowaveLaserGeneratorDefense) {},
		ParticleGun = Class(CDFHvyProtonCannonWeapon) {},
		LaserTurretI = Class(CDFElectronBolterWeapon) {},
		LaserTurretII = Class(CDFElectronBolterWeapon) {},
		ParticleGunG = Class(CDFHvyProtonCannonWeapon) {},
		ParticleGunD = Class(CDFHvyProtonCannonWeapon) {},
		LaserTurretIII = Class(CDFElectronBolterWeapon) {},
		LaserTurretIV = Class(CDFElectronBolterWeapon) {},
		LaserTurretV = Class(CDFElectronBolterWeapon) {},
		LaserTurretVI = Class(CDFElectronBolterWeapon) {},
		LaserTurretVII = Class(CDFElectronBolterWeapon) {},
		LaserTurretVIII = Class(CDFElectronBolterWeapon) {},
		AntiAirMissileI = Class(CAAMissileNaniteWeapon) {},
		AntiAirMissileII = Class(CAAMissileNaniteWeapon) {},
		AntiAirMissileIII = Class(CAAMissileNaniteWeapon) {},
		AntiAirMissileIV = Class(CAAMissileNaniteWeapon) {},
    },


    OnStartBeingBuilt = function(self, builder, layer)
        CWalkingLandUnit.OnStartBeingBuilt(self, builder, layer)
        if not self.AnimationManipulator then
            self.AnimationManipulator = CreateAnimator(self)
            self.Trash:Add(self.AnimationManipulator)
        end
        self.AnimationManipulator:PlayAnim(self:GetBlueprint().Display.AnimationActivate, false):SetRate(0)
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        CWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
        if self.AnimationManipulator then
            self:SetUnSelectable(true)
            self.AnimationManipulator:SetRate(0.7)
            self:ForkThread(function()
                WaitSeconds(self.AnimationManipulator:GetAnimationDuration()*self.AnimationManipulator:GetRate())
                self:SetUnSelectable(false)
                self.AnimationManipulator:Destroy()
            end)
        end
        self:SetMaintenanceConsumptionActive()
        local layer = self:GetCurrentLayer()
        self.WeaponsEnabled = true
    end,


}

TypeClass = URL0403
