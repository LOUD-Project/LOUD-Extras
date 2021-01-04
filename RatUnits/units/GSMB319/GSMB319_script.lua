local SStructureUnit = import('/lua/seraphimunits.lua').SStructureUnit
local SWeapons = import('/lua/seraphimweapons.lua')
local SIFCommanderDeathWeapon = SWeapons.SIFCommanderDeathWeapon
local SIFExperimentalStrategicMissile = import('/lua/seraphimweapons.lua').SIFExperimentalStrategicMissile
local EffectUtil = import('/lua/EffectUtilities.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

GSMB319 = Class(SStructureUnit) {

    Weapons = {
	DeathWeapon = Class(SIFCommanderDeathWeapon) {},
        InainoMIRVMissile = Class(SIFExperimentalStrategicMissile) {},
    },
}

TypeClass = GSMB319
