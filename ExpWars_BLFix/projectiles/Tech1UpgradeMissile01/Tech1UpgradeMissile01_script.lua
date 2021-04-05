--
-- AA Missile for Cybrans
--

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local TMissileCruiseProjectile = import('/lua/terranprojectiles.lua').TMissileCruiseProjectile02
local Explosion = import('/lua/defaultexplosions.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

Tech1UpgradeMissile01 = Class( TMissileCruiseProjectile ) {

    OnCreate = function(self)
        TMissileCruiseProjectile.OnCreate(self)
        self:ForkThread(self.UpdateThread)
		
    end,

    UpdateThread = function(self)
        WaitSeconds(1.5)
        self:SetMaxSpeed(15)
		self:SetAcceleration(15)
		self:TrackTarget(true)
		---self:UseGravity(false)
    end,

    OnImpact = function(self, TargetType, TargetEntity)
		TMissileCruiseProjectile.OnImpact(self, TargetType, TargetEntity)
    end,
}

TypeClass = Tech1UpgradeMissile01

