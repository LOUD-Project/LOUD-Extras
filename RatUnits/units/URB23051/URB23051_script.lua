local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit

local Weapon = import('/lua/sim/Weapon.lua').Weapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')

local CIFMissileStrategicWeapon = import('/lua/cybranweapons.lua').CIFMissileStrategicWeapon
local CIFCommanderDeathWeapon = CybranWeaponsFile.CIFCommanderDeathWeapon

URB2305 = Class(CStructureUnit) {
    Weapons = {
        DeathWeapon = Class(CIFCommanderDeathWeapon) {},
        NukeMissiles = Class(CIFMissileStrategicWeapon) {},
    },
    
}

TypeClass = URB2305
