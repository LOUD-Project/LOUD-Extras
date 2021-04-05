local EffectUtil = import( '/lua/EffectUtilities.lua' )
local EW_DefaultUnits = import( import('/lua/game.lua').ExpWarsPath .. '/lua/EW_DefaultUnits.lua' )

TQuantumGateUnitII = Class( EW_DefaultUnits.QuantumGateUnit ) {}
TConstructionEggUnit = Class( TStructureUnit ) {}
TSubFactoryUnit = Class( EW_DefaultUnits.SubFactoryUnit ) {}
TPortalFactoryUnit = Class( EW_DefaultUnits.PortalFactoryUnit ) {
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        if not unitBeingBuilt then return end
        WaitSeconds( 0.1 )
        for k, v in self:GetBlueprint().General.BuildBones.BuildEffectBones do
            self.BuildEffectsBag:Add( CreateAttachedEmitter( self, v, self:GetArmy(), '/effects/emitters/flashing_blue_glow_01_emit.bp' ) )
            self.BuildEffectsBag:Add( self:ForkThread( EffectUtil.CreateDefaultBuildBeams, unitBeingBuilt, {v}, self.BuildEffectsBag ) )
        end
    end,
}
THeroWalkingLandUnit = Class( EW_DefaultUnits.HeroWalkingLandUnit ) {}
TLandResearchLabUnit = Class( EW_DefaultUnits.LandResearchLabUnit ) {}
TAirResearchLabUnit = Class( EW_DefaultUnits.AirResearchLabUnit ) {}
TNavalResearchLabUnit = Class( EW_DefaultUnits.NavalResearchLabUnit ) {}
