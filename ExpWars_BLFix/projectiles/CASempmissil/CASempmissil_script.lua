--
-- AA Missile for Cybrans
--

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local CEMPMissileProjectile = import( ExpWarsPath .. '/lua/modprojectiles.lua').CEMPMissileProjectile

CAAMissileNanite02 = Class( CEMPMissileProjectile ) {

    OnCreate = function(self)
        CEMPMissileProjectile.OnCreate(self)
        self:ForkThread(self.UpdateThread)
		
    end,

    UpdateThread = function(self)
        WaitSeconds(0.2)
        self:SetMaxSpeed(25)
		self:TrackTarget(true)
		--self:UseGravity(false)
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        CEMPMissileProjectile.OnImpact(self, TargetType, TargetEntity)
    end,
}

TypeClass = CAAMissileNanite02

