--****************************************************************************
--**
--**  File     :  /units/UEAEW0002/UEAEW0002_script.lua
--**  Author(s):  John Comes, David Tomandl
--**
--**  Summary  :  UEF 
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************


local TAirUnit = import('/lua/terranunits.lua').TAirUnit


local WeaponsFile = import('/lua/terranweapons.lua')
local TDFRiotWeapon = WeaponsFile.TDFRiotWeapon
local TIFCruiseMissileUnpackingLauncher = import('/lua/terranweapons.lua').TIFCruiseMissileUnpackingLauncher

local util = import('/lua/utilities.lua')
local fxutil = import('/lua/effectutilities.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

UEAEW0002 = Class(TAirUnit) {

		
    ShieldEffects = {
        '/effects/emitters/terran_shield_generator_t2_01_emit.bp',
        '/effects/emitters/terran_shield_generator_t2_02_emit.bp',
    },
    
    Weapons = {
        Riotgun01 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
        Riotgun02 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
        Riotgun03 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
        Riotgun04 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
        Riotgun05 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },
        Riotgun06 = Class(TDFRiotWeapon) {
            FxMuzzleFlash = EffectTemplate.TRiotGunMuzzleFxTank
        },	
        MissileWeapon = Class(TIFCruiseMissileUnpackingLauncher) {
            FxMuzzleFlash = {'/effects/emitters/terran_mobile_missile_launch_01_emit.bp'},
        },		
    },	
	
    OnStopBeingBuilt = function(self,builder,layer)
        TAirUnit.OnStopBeingBuilt(self,builder,layer)
		self.ShieldEffectsBag = {}
    end,
    
    OnShieldEnabled = function(self)
        TAirUnit.OnShieldEnabled(self)
        KillThread( self.DestroyManipulatorsThread )

        if not self.AnimationManipulator then
            local myBlueprint = self:GetBlueprint()
            --LOG( 'it is ', repr(myBlueprint.Display.AnimationOpen) )
            self.AnimationManipulator = CreateAnimator(self)
            self.AnimationManipulator:PlayAnim( myBlueprint.Display.AnimationOpen )
            self.Trash:Add( self.AnimationManipulator )
        end
        self.AnimationManipulator:SetRate(1)
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
        for k, v in self.ShieldEffects do
            table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'ShieldEffect01', self:GetArmy(), v ) )
			table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'ShieldEffect02', self:GetArmy(), v ) )
			table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'ShieldEffect03', self:GetArmy(), v ) )
			table.insert( self.ShieldEffectsBag, CreateAttachedEmitter( self, 'ShieldEffect04', self:GetArmy(), v ) )
        end
    end,

    OnShieldDisabled = function(self)
        TAirUnit.OnShieldDisabled(self)
        KillThread( self.DestroyManipulatorsThread )
        self.DestroyManipulatorsThread = self:ForkThread( self.DestroyManipulators )
        
        if self.ShieldEffectsBag then
            for k, v in self.ShieldEffectsBag do
                v:Destroy()
            end
		    self.ShieldEffectsBag = {}
		end
    end,

    DestroyManipulators = function(self)

        if self.AnimationManipulator then
            self.AnimationManipulator:SetRate(-1)
            WaitFor( self.AnimationManipulator )
            self.AnimationManipulator:Destroy()
            self.AnimationManipulator = nil
        end
    end,
}

TypeClass = UEAEW0002