--****************************************************************************
--**
--**  File     :  /units/URA0402/URA0402_script.lua
--**  Author(s):  David Tomandl, Jessica St. Croix
--**					Modified By Asdrubaelvect
--**  Summary  :  Cybran Anti Spaceships Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************
local Shield = import('/lua/shield.lua').Shield

local CAirUnit = import('/lua/cybranunits.lua').CAirUnit
local explosion = import('/lua/defaultexplosions.lua')
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')

URA0402 = Class(CAirUnit) {

    MovementAmbientExhaustBones = {
		'Reacteur02',
		'Reacteur01',
		'Reacteur03',
    },


    OnStopBeingBuilt = function(self,builder,layer)
        CAirUnit.OnStopBeingBuilt(self,builder,layer)
        self.AnimManip = CreateAnimator(self)
		---self:SetScriptBit('RULEUTC_ShieldToggle', false)
			self:ForkThread(self.OffShieldThread)
		self.Trash:Add(self.AnimManip)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)
    end,

    OnAttachedKilled = function(self, attached)
        attached:DetachFrom()
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        CAirUnit.OnKilled(self, instigator, type, overkillRatio)
        self:TransportDetachAllUnits(true)
    end,

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

    OnMotionVertEventChange = function(self, new, old)
        --LOG( 'OnMotionVertEventChange, new = ', new, ', old = ', old )
        CAirUnit.OnMotionVertEventChange(self, new, old)

        --Aborting a landing
        if ((new == 'Top' or new == 'Up') and old == 'Down') then
            self.AnimManip:SetRate(-1)
			self:ForkThread(self.OffShieldThread)
        elseif (new == 'Down') then
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationLand, false):SetRate(1)


			 self:ForkThread(self.ShieldThread)
        elseif (new == 'Up') then
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTakeOff, false):SetRate(1)

			self:ForkThread(self.OffShieldThread)

        end
    end,

    ShieldThread = function(self)
	WaitSeconds(10.1)
	self:CreateShield()
	self.Rotator1 = CreateRotator(self, 'Object03', 'y', nil, 30, 5, 30)
    self.Trash:Add(self.Rotator1)
	end,

    OffShieldThread = function(self)
	WaitSeconds(3.1)
		if self.Rotator1 then
			self.Rotator1:Destroy()
		end
	self:DestroyShield()
	self:SetMaintenanceConsumptionInactive()
	end,

    MovementAmbientExhaustThread = function(self)
		while not self:IsDead() do
			local ExhaustEffects = {
				'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',
				'/effects/emitters/nuke_munition_launch_trail_02_emit.bp',
				--/Mods/SoftLastAsdruMod
			}
			local ExhaustBeam = '/Mods/ExpWars_BLFix/effects/emitters/missile_exhaust_fire_beam_13_emit.bp'
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

TypeClass = URA0402
