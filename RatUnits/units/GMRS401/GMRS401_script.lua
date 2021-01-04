local CSubUnit = import('/lua/cybranunits.lua').CSubUnit

local Weapon = import('/lua/sim/Weapon.lua').Weapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')

local CIFCommanderDeathWeapon = import('/lua/cybranweapons.lua').CIFCommanderDeathWeapon
local CIFMissileLoaTacticalWeapon = import('/lua/cybranweapons.lua').CIFMissileLoaTacticalWeapon
local CIFMissileStrategicWeapon = import('/lua/cybranweapons.lua').CIFMissileStrategicWeapon
local CANTorpedoLauncherWeapon = CybranWeaponsFile.CANTorpedoLauncherWeapon

local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')

GMRS401 = Class(CSubUnit) {
    Weapons = {
        DeathWeapon = Class(CIFCommanderDeathWeapon) {},
        NukeMissile = Class(CIFMissileStrategicWeapon) {
		CurrentRack = 1,
           
            PlayFxMuzzleSequence = function(self, muzzle)
                local bp = self:GetBlueprint()
                self.Rotator = CreateRotator(self.unit, bp.RackBones[self.CurrentRack].RackBone, 'y', nil, 90, 90, 90)
                muzzle = bp.RackBones[self.CurrentRack].MuzzleBones[1]
                self.Rotator:SetGoal(90)
                CIFMissileStrategicWeapon.PlayFxMuzzleSequence(self, muzzle)
                WaitFor(self.Rotator)
                WaitSeconds(1)
            end,
            
            CreateProjectileAtMuzzle = function(self, muzzle)
                muzzle = self:GetBlueprint().RackBones[self.CurrentRack].MuzzleBones[1]
                if self.CurrentRack >= 12 then
                    self.CurrentRack = 1
                else
                    self.CurrentRack = self.CurrentRack + 1
                end
                CIFMissileStrategicWeapon.CreateProjectileAtMuzzle(self, muzzle)
            end,
            
            PlayFxRackReloadSequence = function(self)
                WaitSeconds(1)
                self.Rotator:SetGoal(0)
                WaitFor(self.Rotator)
                self.Rotator:Destroy()
                self.Rotator = nil
            end,
        },
        CruiseMissile = Class(CIFMissileLoaTacticalWeapon) {},
        Torpedo01 = Class(CANTorpedoLauncherWeapon) {},
        Torpedo02 = Class(CANTorpedoLauncherWeapon) {},
    },

    OnStopBeingBuilt = function(self,builder,layer)
        CSubUnit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
        self:RequestRefreshUI() 
     end,	
}

TypeClass = GMRS401

