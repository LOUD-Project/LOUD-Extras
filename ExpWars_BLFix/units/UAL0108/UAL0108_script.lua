--****************************************************************************
--**
--**  File     :  /units/UAL0108/UAL0108_script.lua
--**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
--**
--**  Summary  :  Aeon Mobile Torpedo Launcher Script
--**
--**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
--****************************************************************************


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local Game = import( '/lua/game.lua' )

-- VARIABLE ''GLOBALE'' ( par Manimal )
local ExpWarsPath = Game.ExpWarsPath
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local ALandUnit = import( '/lua/aeonunits.lua' ).ALandUnit

local AANChronoTorpedoWeapon = import('/lua/aeonweapons.lua').AANChronoTorpedoWeapon

UAL0108 = Class( ALandUnit ) {
    Weapons = {
        Turret01 = Class(AANChronoTorpedoWeapon) {
		},
	},

	OnCreate = function(self)
		ALandUnit.OnCreate(self)

        self.DomeEntity = import('/lua/sim/Entity.lua').Entity({Owner = self,})
        self.DomeEntity:AttachBoneTo( -1, self, 'UAB01' )
        self.DomeEntity:SetMesh('/effects/Entities/UAB2205_Dome/UAB2205_Dome_mesh')
        self.DomeEntity:SetDrawScale(0.35)
		self.Rotator1 = CreateRotator(self, 'Object02', 'y', nil, 100, 15, 100)
        self.Trash:Add(self.Rotator1)		
		self.Rotator1 = CreateRotator(self, 'Object03', 'y', nil, -100, -15, -100)
        self.Trash:Add(self.Rotator2)	
        self.DomeEntity:SetVizToAllies('Intel')
        self.DomeEntity:SetVizToNeutrals('Intel')
        self.DomeEntity:SetVizToEnemies('Intel')         
        self.Trash:Add(self.DomeEntity)
		self:SetElevation(1) 
	end,    

    OnStopBeingBuilt = function(self, builder, layer)
        ALandUnit.OnStopBeingBuilt(self,builder,layer)
        if(self:GetCurrentLayer() == 'Land') then
			--self:SetElevation(1.3) 	
			---self.AT1 = self:ForkThread(self.TransformThread, false)
        elseif (self:GetCurrentLayer() == 'Water') then
			--self:SetElevation(-0.1) 	
        end
       self.WeaponsEnabled = true
    end,

	OnLayerChange = function(self, new, old)
		ALandUnit.OnLayerChange(self, new, old)
        if( old != 'None' ) then
            if( self.AT1 ) then
                self.AT1:Destroy()
                self.AT1 = nil
            end
            local myBlueprint = self:GetBlueprint()
			if( new == 'Land' ) then
				self.AT1 = self:ForkThread(self.TransformThread, false)
			elseif ( new == 'Water' ) then
				self.AT1 = self:ForkThread(self.TransformThread, true)				
			end
		end
	end,
	
    TransformThread = function(self, land)
        if( not self.AnimManip ) then
            self.AnimManip = CreateAnimator(self)
        end
        local bp = self:GetBlueprint()
        local scale = bp.Display.UniformScale or 1

        if( land ) then
            --self:SetImmobile(true)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetRate(1)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
			self.IsWaiting = false
			--self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY*1.0)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
            --self:SetImmobile(false)
            self.SwitchAnims = true
            self.Walking = true
            self.Trash:Add(self.AnimManip)
        else
            self:SetImmobile(true)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetAnimationFraction(1)
            self.AnimManip:SetRate(-2.5)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
			--self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY * 0.5)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
			self.IsWaiting = false
            self.AnimManip:Destroy()
            self.AnimManip = nil
            self:SetImmobile(false)
            self.Walking = false
        end
    end,

}

TypeClass = UAL0108
