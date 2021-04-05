--****************************************************************************
--**
--**  File     :  /cdimage/units/XSBEW0003/XSBEW0003_script.lua
--**  Author(s):  Jessica St. Croix, Gordon Duclos, Aaron Lundquist
--**
--**  Summary  :  Seraphim Battleship Script
--**
--**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

local SSubUnit = import('/lua/seraphimunits.lua').SSubUnit
local SeraphimWeapons = import('/lua/seraphimweapons.lua')

local SIFZthuthaamArtilleryCannon = import('/lua/seraphimweapons.lua').SIFZthuthaamArtilleryCannon
local SDFHeavyQuarnonCannon = import('/lua/seraphimweapons.lua').SDFHeavyQuarnonCannon
local SAAOlarisCannonWeapon = import('/lua/seraphimweapons.lua').SAAOlarisCannonWeapon


XSBEW0003 = Class(SSubUnit) {
    FxDamageScale = 2,
    DestructionTicks = 400,
	
    Weapons = {
        CenterWeapon = Class(SIFZthuthaamArtilleryCannon){},
		FrontTurret = Class(SDFHeavyQuarnonCannon) {},
		BackTurret = Class(SDFHeavyQuarnonCannon) {},
		AntiAirLeft = Class(SAAOlarisCannonWeapon) {},
		AntiAirRight = Class(SAAOlarisCannonWeapon) {},
    },	

    OnStopBeingBuilt = function(self,builder,layer)
        SSubUnit.OnStopBeingBuilt(self,builder,layer)
		self.Trash:Add(CreateRotator(self, 'Rotator01', 'y', nil, -30, 0, 0))
        self.Trash:Add(CreateRotator(self, 'Rotator02', 'y', nil, 30, 0, 0))
    end,
	
	
}

TypeClass = XSBEW0003