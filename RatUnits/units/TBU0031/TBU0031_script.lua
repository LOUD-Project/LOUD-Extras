local TSubUnit = import('/lua/terranunits.lua').TSubUnit

local WeaponFile = import('/lua/terranweapons.lua')

local TIFCruiseMissileLauncherSub = WeaponFile.TIFCruiseMissileLauncherSub
local TIFStrategicMissileWeapon = WeaponFile.TIFStrategicMissileWeapon
local TIFCommanderDeathWeapon = import('/lua/terranweapons.lua').TIFCommanderDeathWeapon

local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')

TBU0031 = Class(TSubUnit) {
    DeathThreadDestructionWaitTime = 0,
    Weapons = {
        DeathWeapon = Class(TIFCommanderDeathWeapon) {},
        CruiseMissiles = Class(TIFCruiseMissileLauncherSub) {
            CurrentRack = 1,
           
            PlayFxMuzzleSequence = function(self, muzzle)
                local bp = self:GetBlueprint()
                self.Rotator = CreateRotator(self.unit, bp.RackBones[self.CurrentRack].RackBone, 'z', nil, 90, 90, 90)
                muzzle = bp.RackBones[self.CurrentRack].MuzzleBones[1]
                self.Rotator:SetGoal(90)
                TIFCruiseMissileLauncherSub.PlayFxMuzzleSequence(self, muzzle)
                WaitFor(self.Rotator)
                WaitSeconds(1)
            end,
            
            CreateProjectileAtMuzzle = function(self, muzzle)
                muzzle = self:GetBlueprint().RackBones[self.CurrentRack].MuzzleBones[1]
                if self.CurrentRack >= 6 then
                    self.CurrentRack = 1
                else
                    self.CurrentRack = self.CurrentRack + 1
                end
                TIFCruiseMissileLauncherSub.CreateProjectileAtMuzzle(self, muzzle)
            end,
            
            PlayFxRackReloadSequence = function(self)
                WaitSeconds(1)
                self.Rotator:SetGoal(0)
                WaitFor(self.Rotator)
                self.Rotator:Destroy()
                self.Rotator = nil
            end,
        },
        NukeMissiles = Class(TIFStrategicMissileWeapon) {
            CurrentRack = 1,
           
            PlayFxMuzzleSequence = function(self, muzzle)
                local bp = self:GetBlueprint()
                self.Rotator = CreateRotator(self.unit, bp.RackBones[self.CurrentRack].RackBone, 'z', nil, 90, 90, 90)
                muzzle = bp.RackBones[self.CurrentRack].MuzzleBones[1]
                self.Rotator:SetGoal(90)
                TIFStrategicMissileWeapon.PlayFxMuzzleSequence(self, muzzle)
                WaitFor(self.Rotator)
                WaitSeconds(1)
            end,
            
            CreateProjectileAtMuzzle = function(self, muzzle)
                muzzle = self:GetBlueprint().RackBones[self.CurrentRack].MuzzleBones[1]
                if self.CurrentRack >= 2 then
                    self.CurrentRack = 1
                else
                    self.CurrentRack = self.CurrentRack + 1
                end
                TIFStrategicMissileWeapon.CreateProjectileAtMuzzle(self, muzzle)
            end,
            
            PlayFxRackReloadSequence = function(self)
                WaitSeconds(1)
                self.Rotator:SetGoal(0)
                WaitFor(self.Rotator)
                self.Rotator:Destroy()
                self.Rotator = nil
            end,
        },
    },
}

TypeClass = TBU0031

