local ASubUnit = import('/lua/aeonunits.lua').ASubUnit

local WeaponFile = import('/lua/aeonweapons.lua')

local AIFMissileTacticalSerpentineWeapon = WeaponFile.AIFMissileTacticalSerpentineWeapon
local AIFQuantumWarhead = WeaponFile.AIFQuantumWarhead
local AIFCommanderDeathWeapon = import('/lua/aeonweapons.lua').AIFCommanderDeathWeapon

local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')
local Effects = import('/lua/effecttemplates.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')

EXUAS0304 = Class(ASubUnit) {
    DeathThreadDestructionWaitTime = 0,
    Weapons = {
        DeathWeapon = Class(AIFCommanderDeathWeapon) {},
        CruiseMissiles = Class(AIFMissileTacticalSerpentineWeapon) {},
        NukeMissiles = Class(AIFQuantumWarhead) {},
    },
}

TypeClass = EXUAS0304

