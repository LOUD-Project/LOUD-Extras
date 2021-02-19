#****************************************************************************
#**
#**  File     :  /cdimage/units/OEA0401/OEA0401_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix
#**
#**  Summary  :  UEF Strategic Bomber Script
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local TAirUnit = import('/lua/terranunits.lua').TAirUnit
local TDFHeavyPlasmaGatlingCannonWeapon = import('/lua/terranweapons.lua').TDFHeavyPlasmaGatlingCannonWeapon
local TAirToAirLinkedRailgun = import('/lua/terranweapons.lua').TAirToAirLinkedRailgun
local TDFIonizedPlasmaCannon = import('/lua/terranweapons.lua').TDFIonizedPlasmaCannon
local TDFGaussCannonWeapon = import('/lua/terranweapons.lua').TDFGaussCannonWeapon
local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')

OEA0401 = Class(TAirUnit) {
    Weapons = {
        SideRiotGun = Class(TDFHeavyPlasmaGatlingCannonWeapon) {
        PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                TDFHeavyPlasmaGatlingCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'SideGat_Rotator', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(300)
                end
                TDFHeavyPlasmaGatlingCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,            
        },
        NoseRiotGun = Class(TDFHeavyPlasmaGatlingCannonWeapon) {
        PlayFxWeaponPackSequence = function(self)
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(0)
                end
                TDFHeavyPlasmaGatlingCannonWeapon.PlayFxWeaponPackSequence(self)
            end,
        
            PlayFxWeaponUnpackSequence = function(self)
                if not self.SpinManip then 
                    self.SpinManip = CreateRotator(self.unit, 'NoseGat_Rotator', 'z', nil, 270, 180, 60)
                    self.unit.Trash:Add(self.SpinManip)
                end
                
                if self.SpinManip then
                    self.SpinManip:SetTargetSpeed(300)
                end
                TDFHeavyPlasmaGatlingCannonWeapon.PlayFxWeaponUnpackSequence(self)
            end,            
        },
        SidePlamsaGun01 = Class(TDFIonizedPlasmaCannon) {},
        SidePlamsaGun02 = Class(TDFIonizedPlasmaCannon) {},
        SidePlamsaGun03 = Class(TDFIonizedPlasmaCannon) {},
        SideHeavyCannon = Class(TDFGaussCannonWeapon) {},
        AARailGun1 = Class(TAirToAirLinkedRailgun) {},
        AARailGun2 = Class(TAirToAirLinkedRailgun) {},
        AARailGun3 = Class(TAirToAirLinkedRailgun) {},
        AARailGun4 = Class(TAirToAirLinkedRailgun) {},
    },
    
    DestroyNoFallRandomChance = 1.1,
    MovementAmbientExhaustBones = {
		'Exhaust_1',
		'Exhaust_2',
		'Exhaust_3',
		'Exhaust_4',
		'Exhaust_5',
		'Exhaust_6',
    },
    OnMotionHorzEventChange = function( self, new, old )	
    
    	if self.ThrustExhaustTT1 == nil then 
			if self.MovementAmbientExhaustEffectsBag then
				fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
			else
				self.MovementAmbientExhaustEffectsBag = {}
			end
			self.ThrustExhaustTT1 = self:ForkThread(self.MovementAmbientExhaustThread)
		end
    	if ( new == 'Stopping' or new == 'Stopped' ) then
    		self:ForkThread(self.Patrol)
    		KillThread(self.ThrustExhaustTT1)
			fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
			self.ThrustExhaustTT1 = nil
    	end
    	TAirUnit.OnMotionHorzEventChange(self, new, old)
    end,
    Patrol = function(self)
		local unitPos = self:GetPosition()
		local direction = Random(1,2)
		if direction == 1 then
		IssueClearCommands({self})
		IssueGuard({self}, {unitPos[1]+15, unitPos[2], unitPos[3]+5})
		LOG('*positive!')
		else
		IssueClearCommands({self})
		IssueGuard({self}, {unitPos[1]-15, unitPos[2], unitPos[3]-5})
		LOG('*negative!')
		end
	end,
	MovementAmbientExhaustThread = function(self)
		while not self:IsDead() do
			local ExhaustEffects = {
				'/effects/emitters/dirty_exhaust_smoke_01_emit.bp',
				'/effects/emitters/dirty_exhaust_sparks_01_emit.bp',			
			}
			local ExhaustBeam = '/effects/emitters/missile_exhaust_fire_beam_03_emit.bp'
			local army = self:GetArmy()			
			
			for kE, vE in ExhaustEffects do
				for kB, vB in self.MovementAmbientExhaustBones do
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateAttachedEmitter(self, vB, army, vE ))
					table.insert( self.MovementAmbientExhaustEffectsBag, CreateBeamEmitterOnEntity( self, vB, army, ExhaustBeam ))
				end
			end
			
			WaitSeconds(2)
			fxutil.CleanupEffectBag(self,'MovementAmbientExhaustEffectsBag')
							
			WaitSeconds(util.GetRandomFloat(1,7))
		end	
    end,
}

TypeClass = OEA0401
