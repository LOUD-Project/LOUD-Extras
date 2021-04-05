--[[------------------------------------------------------------------------
--  File     :  /units/XSLE0001/XSL0001_script.lua
--  Author(s):  GPG Devs
--  Summary  :  Seraphim Heavy Bot Script
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  -----------------------------
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--


local SWalkingLandUnit = import('/lua/seraphimunits.lua').SWalkingLandUnit
local SDFAireauBolterWeapon = import('/lua/seraphimweapons.lua').SDFAireauBolterWeapon02
local SAAOlarisCannonWeapon = import('/lua/seraphimweapons.lua').SAAOlarisCannonWeapon
local SeraphimWeapons = import('/lua/seraphimweapons.lua')
local SDFHeavyQuarnonCannon = SeraphimWeapons.SDFHeavyQuarnonCannon

XSLE0001 = Class(SWalkingLandUnit) {
    Weapons = {
        MainGun = Class(SDFAireauBolterWeapon) {},
		AAGun = Class(SAAOlarisCannonWeapon) {},
		FrontTurret = Class(SDFHeavyQuarnonCannon) {},
    },
}

TypeClass = XSLE0001
