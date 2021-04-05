local EW_DefaultUnits = import( import('/lua/game.lua').ExpWarsPath .. '/lua/EW_DefaultUnits.lua' )
local EffectUtil = import( '/lua/EffectUtilities.lua' )

CSubFactoryUnit = Class( EW_DefaultUnits.SubFactoryUnit ) {}
CHeroWalkingLandUnit = Class( EW_DefaultUnits.HeroWalkingLandUnit ) {}
CLandResearchLabUnit = Class( EW_DefaultUnits.LandResearchLabUnit ) {}
CAirResearchLabUnit = Class( EW_DefaultUnits.AirResearchLabUnit ) {}
CNavalResearchLabUnit = Class( EW_DefaultUnits.NavalResearchLabUnit ) {}

CPortalFactoryUnit = Class( EW_DefaultUnits.PortalFactoryUnit ) {
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        if not unitBeingBuilt then return end
        WaitSeconds( 0.1 )
        EffectUtil.CreateCybranFactoryBuildEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones, self.BuildEffectsBag )
    end,
}
