local ExpWarsPath = import( '/lua/game.lua' ).ExpWarsPath
local CollisionBeam = import( '/lua/sim/CollisionBeam.lua' ).CollisionBeam
local EffectTemplate = import( '/lua/EffectTemplates.lua' )
local Util = import( '/lua/utilities.lua' )

MicrowaveLaserCollisionBeam03 = Class( MicrowaveLaserCollisionBeam01 ) {
    TerrainImpactScale = 0.1,
	FxBeamStartPointScale = 0.1,
	FxBeamEndPointScale = 0.1,
	FxBeamScale = 0.1,
    FxBeamStartPoint = EffectTemplate.CMicrowaveLaserMuzzle01,
    FxBeam = { ExpWarsPath .. '/effects/Emitters/microwave_laser_beam_04_emit.bp' },
    FxBeamEndPoint = EffectTemplate.CMicrowaveLaserEndPoint01,

	OnImpact = function( self, impactType, targetEntity )
        if impactType == 'Terrain' then
            if self.Scorching == nil then
                self.Scorching = self:ForkThread( self.ScorchThread )
            end
        elseif not impactType == 'Unit' then
            KillThread( self.Scorching )
            self.Scorching = nil
        end
        CollisionBeam.OnImpact( self, impactType, targetEntity )
    end,

    OnDisable = function( self )
        CollisionBeam.OnDisable( self )
        KillThread( self.Scorching )
        self.Scorching = nil
    end,

    ScorchThread = function(self)
        local army = self:GetArmy()
        local size = 0.1 + ( Random() * 0.1 )
        local CurrentPosition = self:GetPosition( 1 )
        local LastPosition = Vector( 0, 0, 0 )
        local skipCount = 1
        while true do
            if Util.GetDistanceBetweenTwoVectors( CurrentPosition, LastPosition ) > 0.25 or skipCount > 100 then
                CreateSplat( CurrentPosition, Util.GetRandomFloat(0,2*math.pi), self.SplatTexture, size, size, 100, 100, army )
                LastPosition = CurrentPosition
                skipCount = 1
            else
                skipCount = skipCount + self.ScorchSplatDropTime
            end

            WaitSeconds( self.ScorchSplatDropTime )
            size = 0.1 + ( Random() * 0.1 )
            CurrentPosition = self:GetPosition( 1 )
        end
    end,
}
