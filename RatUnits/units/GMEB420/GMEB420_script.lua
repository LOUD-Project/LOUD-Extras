local TStructureUnit = import('/lua/terranunits.lua').TStructureUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TIFStrategicMissileWeapon = import('/lua/terranweapons.lua').TIFStrategicMissileWeapon
local TIFCommanderDeathWeapon = import('/lua/terranweapons.lua').TIFCommanderDeathWeapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')

GMEB420 = Class(TStructureUnit) {
    Weapons = {
        DeathWeapon = Class(TIFCommanderDeathWeapon) {},
        NukeMissiles = Class(TIFStrategicMissileWeapon) {},
    },
}
TypeClass = GMEB420