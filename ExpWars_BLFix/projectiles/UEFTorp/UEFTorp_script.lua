--
-- Depth Charge Script
------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local UEFTorpedoe01Projectile = import(ExpWarsPath .. '/lua/modprojectiles.lua').UEFTorpedoe01Projectile
local VizMarker = import('/lua/sim/VizMarker.lua').VizMarker

AANDepthCharge03 = Class(UEFTorpedoe01Projectile) {

    CountdownLength = 10,
    FxEnterWater= { '/effects/emitters/water_splash_ripples_ring_01_emit.bp',
                    '/effects/emitters/water_splash_plume_01_emit.bp',},
	FxEnterWaterScale = 3, 

    OnCreate = function(self)
        UEFTorpedoe01Projectile.OnCreate(self)
    end,


    OnEnterWater = function(self)
        UEFTorpedoe01Projectile.OnEnterWater(self)

        local army = self:GetArmy()

        for i in self.FxEnterWater do --splash
            CreateEmitterAtEntity(self,army,self.FxEnterWater[i])
        end

        self:SetMaxSpeed(10)
        self:SetVelocity(5)
        self:SetAcceleration(10)
        self:TrackTarget(true)
        self:StayUnderwater(true)
        self:SetTurnRate(240)
        self:SetVelocityAlign(true)
        self:SetStayUpright(false)
        self:ForkThread(self.EnterWaterMovementThread)
    end,
    
    EnterWaterMovementThread = function(self)
        WaitTicks(1)
        self:SetVelocity(5.2)
    end,

    OnLostTarget = function(self)
        self:SetMaxSpeed(10)
        self:SetAcceleration(5)
        self:ForkThread(self.CountdownMovement)
    end,

    CountdownMovement = function(self)
        WaitSeconds(0.1)
        self:SetMaxSpeed(0)
        self:SetAcceleration(0)
        self:SetVelocity(0)
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        --LOG('Projectile impacted with: ' .. TargetType)
        local pos = self:GetPosition()
        local spec = {
            X = pos[1],
            Z = pos[3],
            Radius = 30,
            LifeTime = 10,
            Omni = false,
            Vision = false,
            Army = self:GetArmy(),
        }
        local vizEntity = VizMarker(spec)
        UEFTorpedoe01Projectile.OnImpact(self, TargetType, TargetEntity)
    end,
}

TypeClass = AANDepthCharge03