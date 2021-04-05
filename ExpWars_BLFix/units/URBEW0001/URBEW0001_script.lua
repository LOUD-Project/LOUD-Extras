--****************************************************************************
--**
--**  File     :  /units/URB2401/URB2401_script.lua
--**  Author(s):  Modified By Asdrubaelvect for Experiementals Wars.
--**  Summary  :  Cybran Tech 2 Experimental Defense center
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------


local CStructureUnit = import('/lua/cybranunits.lua').CStructureUnit

local CybranWeaponsFile = import(ExpWarsPath .. '/lua/modweapons.lua')

local CDFHeavyMicrowaveLaserGeneratorDefense = CybranWeaponsFile.CDFHeavyMicrowaveLaserGeneratorDefense
local CWeaponsFile = import('/lua/cybranweapons.lua')
local CIFGrenadeWeapon = CWeaponsFile.CIFGrenadeWeapon
local CAANanoDartWeapon = CWeaponsFile.CAANanoDartWeapon

local EffectTemplate = import('/lua/EffectTemplates.lua')
local utilities = import('/lua/Utilities.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')


URB2401 = Class(CStructureUnit) {

	Weapons = {
        MainGun = Class(CDFHeavyMicrowaveLaserGeneratorDefense) {},
		Missile02 = Class(CAANanoDartWeapon) {},
        ArtyGun01 = Class(CIFGrenadeWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/cybran_artillery_muzzle_flash_01_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_flash_02_emit.bp',
                '/effects/emitters/cannon_muzzle_smoke_02_emit.bp',
            },
            FxMuzzleFlashScale = 0.5,
        },
        ArtyGun02 = Class(CIFGrenadeWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/cybran_artillery_muzzle_flash_01_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_flash_02_emit.bp',
                '/effects/emitters/cannon_muzzle_smoke_02_emit.bp',
            },
            FxMuzzleFlashScale = 0.5,
        },
        ArtyGun03 = Class(CIFGrenadeWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/cybran_artillery_muzzle_flash_01_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_flash_02_emit.bp',
                '/effects/emitters/cannon_muzzle_smoke_02_emit.bp',
            },
            FxMuzzleFlashScale = 0.5,
        },
        ArtyGun04 = Class(CIFGrenadeWeapon) {
            FxMuzzleFlash = {
                '/effects/emitters/cybran_artillery_muzzle_flash_01_emit.bp',
                '/effects/emitters/cybran_artillery_muzzle_flash_02_emit.bp',
                '/effects/emitters/cannon_muzzle_smoke_02_emit.bp',
            },
            FxMuzzleFlashScale = 0.5,
        },
	},


}

TypeClass = URB2401
