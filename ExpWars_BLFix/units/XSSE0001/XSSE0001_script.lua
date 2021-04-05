local SAirUnit = import('/lua/seraphimunits.lua').SAirUnit
local SWeapon = import('/lua/seraphimweapons.lua')
local SAAShleoCannonWeapon = SWeapon.SAAShleoCannonWeapon
local SDFUltraChromaticBeamGenerator = SWeapon.SDFUltraChromaticBeamGeneratorEW

XSSE0001 = Class(SAirUnit) {
    Weapons = {
        MainGun = Class(SDFUltraChromaticBeamGenerator) {},
        AAGun = Class(SAAShleoCannonWeapon) {},
    },
}

TypeClass = XSSE0001
