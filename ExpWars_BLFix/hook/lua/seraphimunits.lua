local EffectUtil = import( '/lua/EffectUtilities.lua' )
local EW_DefaultUnits = import( import('/lua/game.lua').ExpWarsPath .. '/lua/EW_DefaultUnits.lua' )

SSubFactoryUnit = Class( EW_DefaultUnits.SubFactoryUnit ) {}
SHeroWalkingLandUnit = Class( EW_DefaultUnits.HeroWalkingLandUnit ) {}
SLandResearchLabUnit = Class( EW_DefaultUnits.LandResearchLabUnit ) {}
SAirResearchLabUnit = Class( EW_DefaultUnits.AirResearchLabUnit ) {}
SNavalResearchLabUnit = Class( EW_DefaultUnits.NavalResearchLabUnit ) {}
SPortalFactoryUnit = Class( EW_DefaultUnits.PortalFactoryUnit ) {

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        if not unitBeingBuilt then return end
        EffectUtil.CreateSeraphimUnitEngineerBuildingEffects( self, unitBeingBuilt, self:GetBlueprint().General.BuildBones.BuildEffectBones, self.BuildEffectsBag )
    end,

}
