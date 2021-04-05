--****************************************************************************
--**
--**  File     :  /units/UEA0401/UEA0401_script.lua
--**  Author(s):  Drew Staltman, Gordon Duclos, Greg Kohne
--**					Modified By Asdrubaelvect
--**  Summary  :  UEF Spaceships Script
--**
--**  Copyright � 2007 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local TSeaUnit = import('/lua/terranunits.lua').TSeaUnit
local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TSAMLauncher = import('/lua/terranweapons.lua').TSAMLauncher
local TDFHiroPlasmaCannon = import('/lua/terranweapons.lua').TDFHiroPlasmaCannon
local TOrbitalDeathLaserBeamWeapon = import('/lua/terranweapons.lua').TOrbitalDeathLaserBeamWeapon
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')

UEA0401 = Class(TAirUnit) {
    Weapons = {
	    MissileRack01 = Class(TSAMLauncher) {},
		HiroCannonFront = Class(TDFHiroPlasmaCannon) {},
		HiroCannonBack = Class(TDFHiroPlasmaCannon) {},
		OrbitalDeathLaserWeapon = Class(TOrbitalDeathLaserBeamWeapon){  		
		},
	},
	
	
    MovementAmbientExhaustBones = {
		'Reacteur02',
		'Reacteur01',
		'Reacteur03',
		'Reacteur04',		
    },

    OnMotionHorzEventChange = function(self, new, old )
		TAirUnit.OnMotionHorzEventChange(self, new, old)
	
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
				'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',
				'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',	
			}
			local ExhaustBeam =  ExpWarsPath .. '/effects/emitters/missile_exhaust_fire_beam_11_emit.bp'
			local army = self:GetArmy()			
			
			for kE, vE in ExhaustEffects do
				for kB, vB in self.MovementAmbientExhaustBones do
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE ))
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateBeamEmitterOnEntity( self, vB, army, ExhaustBeam ))
				end
			end
			
			WaitSeconds(0)
			fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
							
			--WaitSeconds(util.GetRandomFloat(0,3))
		end	
    end,		
	
	
}
TypeClass = UEA0401