--[[------------------------------------------------------------------------
--  File	 :  /units/URSE0001/URSE0001_script.lua
--  Author(s):  Jessica St. Croix
--  Summary  :  Cybran Support Spaceships (URO1102)
--  -----------------------------
--  Modif.by :  AsdrubaelVect
--  Rev.Date :  5 septembre 2009
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  20 novembre 2009
--  -----------------------------
--  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--
local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local CIFBombNeutronWeapon = import('/lua/cybranweapons.lua').CIFBombNeutronWeapon
local CAANanoDartWeapon = import('/lua/cybranweapons.lua').CAANanoDartWeapon

local fxutil = import('/lua/effectutilities.lua')

URSE0001 = Class(CAirUnit) {
	DestroyNoFallRandomChance = 1.1,

	Weapons = {
		Bomb = Class(CIFBombNeutronWeapon) {},
		AAGun = Class(CAANanoDartWeapon) {},
	},

    MovementAmbientExhaustBones = {
		'Reacteur02',
		'Reacteur01',
		'Reacteur03',
		'Reacteur04',
    },

    OnMotionHorzEventChange = function(self, new, old )
		CAirUnit.OnMotionHorzEventChange(self, new, old)

		if self.ThrustExhaustTT1 == nil then
			if self.MovementAmbientExhaustEffectsBag then
				fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
			else
				self.MovementAmbientExhaustEffectsBag = {}
			end
			self.ThrustExhaustTT1 = self:ForkThread(self.MovementAmbientExhaustThread)
		end

        if new == 'Stopped' and self.ThrustExhaustTT1 != nil then
			KillThread(self.ThrustExhaustTT1)
			fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
			self.ThrustExhaustTT1 = nil
        end
    end,

    MovementAmbientExhaustThread = function(self)
		while not self:IsDead() do
			local ExhaustEffects = {
				'/effects/emitters/missile_cruise_munition_trail_01_emit.bp',
			}
			local ExhaustBeam = '/Mods/ExpWars_BLFix/effects/emitters/cybran_missile_exhaust_fire_beam_11_emit.bp'
			local army = self:GetArmy()

			for kE, vE in ExhaustEffects do
				for kB, vB in self.MovementAmbientExhaustBones do
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE ))
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateBeamEmitterOnEntity( self, vB, army, ExhaustBeam ))
				end
			end

			WaitSeconds(5)
			fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
		end
    end,
}

TypeClass = URSE0001
