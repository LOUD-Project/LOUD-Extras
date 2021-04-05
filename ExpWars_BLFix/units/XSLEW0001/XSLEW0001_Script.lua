--****************************************************************************
--**
--**  File     :  /Mods/ExpeWars/units/XSLEW0001/XSLEW0001_script.lua
--**  Author(s):  Drew Staltman, Jessica St. Croix, Gordon Duclos, Aaron Lundquist
--**
--**  Summary  :  Seraphim Tech 2 Experimental Bot script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit

local WeaponsFile = import ('/lua/seraphimweapons.lua')
local SDFExperimentalPhasonProj = WeaponsFile.SDFExperimentalPhasonProj
local SDFUltraChromaticBeamGenerator = WeaponsFile.SDFUltraChromaticBeamGenerator02

XSLEW0001 = Class(SWalkingLandUnit) {
    Weapons = {
		TorsoWeapon = Class(SDFExperimentalPhasonProj) {},
		ArmsWeapons = Class(SDFUltraChromaticBeamGenerator) {},
    },
}
TypeClass = XSLEW0001