--****************************************************************************
--** 
--**  File     :  /Mods/units/UALEW0002/UALEW0002_script.lua 
--** 
--** 
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************


------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local AHoverLandUnit = import( '/lua/aeonunits.lua' ).AHoverLandUnit

local WeaponsFile = import ( ExpWarsPath .. '/lua/modweapons.lua' )
local ADFTractorClaw02 = WeaponsFile.ADFTractorClaw02

local utilities = import('/lua/utilities.lua')
local explosion = import('/lua/defaultexplosions.lua')
local FxAmbient = import('/lua/effecttemplates.lua').AT2PowerAmbient

UALEW0002 = Class( AHoverLandUnit ) {
    Weapons = {
		ArmTractor01 = Class( ADFTractorClaw02 ) {},

    },
	
    OnStopBeingBuilt = function(self,builder,layer)
        AHoverLandUnit.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateRotator(self, 'Object07', 'z', nil, 180, 0, 180))
		self.Trash:Add(CreateRotator(self, 'Object01', 'y', nil, 360, 0, 180))
		self.Trash:Add(CreateRotator(self, 'Object02', 'x', nil, 360, 0, 180))
    	
		for k, v in FxAmbient do
			CreateAttachedEmitter( self, 'Object02', self:GetArmy(), v )
		end
	
	end,	

	
	
}

TypeClass = UALEW0002
