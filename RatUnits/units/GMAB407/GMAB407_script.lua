local AStructureUnit = import('/lua/aeonunits.lua').AStructureUnit

local WeaponFile = import('/lua/sim/defaultweapons.lua')

local AIFQuantumWarhead = import('/lua/aeonweapons.lua').AIFQuantumWarhead
local AIFCommanderDeathWeapon = import('/lua/aeonweapons.lua').AIFCommanderDeathWeapon

local EffectUtil = import('/lua/EffectUtilities.lua')

GMAB407 = Class(AStructureUnit) {
    Weapons = {
        DeathWeapon = Class(AIFCommanderDeathWeapon) {},
        NukeMissiles = Class(AIFQuantumWarhead) {},
    },
}
TypeClass = GMAB407
