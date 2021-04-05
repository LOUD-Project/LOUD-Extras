--[[------------------------------------------------------------------------
--  File	 :  /units/UAB2310/UAB2310_script.lua
--  Author(s):  John Comes, David Tomandl, Jessica St. Croix
--  Summary  :  Aeon Long Range Artillery Script UAB2302
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  Rev.Date :  18 mars 2010
--  -----------------------------
--  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Game = import( '/lua/game.lua' )

-- VARIABLE ''GLOBALE'' ( par Manimal )
local ExpWarsPath = Game.ExpWarsPath
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local AStructureUnit = import( '/lua/aeonunits.lua' ).AStructureUnit

local WeaponsFile = import ('/lua/aeonweapons.lua')
local ADFPhasonLaser = WeaponsFile.ADFPhasonLaser
local ADFCannonOblivionWeapon = WeaponsFile.ADFCannonOblivionWeapon02
local AAATemporalFizzWeapon = WeaponsFile.AAATemporalFizzWeapon


UAB2310 = Class( AStructureUnit ) {
    Weapons = {
        EyeWeapon = Class(ADFCannonOblivionWeapon) {},
		EyeWeapon01 = Class(ADFCannonOblivionWeapon) {},
		EyeWeapon02 = Class(ADFCannonOblivionWeapon) {},
		EyeWeapon03 = Class(ADFCannonOblivionWeapon) {},
        AAGun = Class(AAATemporalFizzWeapon) {
            ChargeEffectMuzzles = {'Muzzle_Right', 'Muzzle_Right01', 'Muzzle_Right02', 'Muzzle_Right03'},
            
            PlayFxRackSalvoChargeSequence = function(self)
                AAATemporalFizzWeapon.PlayFxRackSalvoChargeSequence(self)
                CreateAttachedEmitter( self.unit, 'Muzzle_Right', self.unit:GetArmy(), '/effects/emitters/temporal_fizz_muzzle_charge_02_emit.bp')
                CreateAttachedEmitter( self.unit, 'Muzzle_Right', self.unit:GetArmy(), '/effects/emitters/temporal_fizz_muzzle_charge_03_emit.bp')
                CreateAttachedEmitter( self.unit, 'Muzzle_Right01', self.unit:GetArmy(), '/effects/emitters/temporal_fizz_muzzle_charge_02_emit.bp')
                CreateAttachedEmitter( self.unit, 'Muzzle_Right01', self.unit:GetArmy(), '/effects/emitters/temporal_fizz_muzzle_charge_03_emit.bp')
                CreateAttachedEmitter( self.unit, 'Muzzle_Right02', self.unit:GetArmy(), '/effects/emitters/temporal_fizz_muzzle_charge_02_emit.bp')
                CreateAttachedEmitter( self.unit, 'Muzzle_Right02', self.unit:GetArmy(), '/effects/emitters/temporal_fizz_muzzle_charge_03_emit.bp')
                CreateAttachedEmitter( self.unit, 'Muzzle_Right03', self.unit:GetArmy(), '/effects/emitters/temporal_fizz_muzzle_charge_02_emit.bp')
                CreateAttachedEmitter( self.unit, 'Muzzle_Right03', self.unit:GetArmy(), '/effects/emitters/temporal_fizz_muzzle_charge_03_emit.bp')
       		end,
        },
    },

}

TypeClass = UAB2310
