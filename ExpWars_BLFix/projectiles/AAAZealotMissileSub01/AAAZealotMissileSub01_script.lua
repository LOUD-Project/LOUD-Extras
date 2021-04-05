--
-- Aeon Anti Air Missile
--
local AMissileAAProjectile = import('/lua/aeonprojectiles.lua').AMissileAAProjectile
AAAZealotMissile01 = Class(AMissileAAProjectile) {

	FxAirUnitHitScale = 1,
    FxLandHitScale = 1,
    FxNoneHitScale = 1,
    FxPropHitScale = 1,
    FxProjectileHitScale = 1,
    FxProjectileUnderWaterHitScale = 1,
    FxShieldHitScale = 1,
    FxUnderWaterHitScale = 1,
    FxUnitHitScale = 1,
    FxWaterHitScale = 1,
    FxOnKilledScale = 1,
	
	
    OnExitWater = function(self)
        AMissileAAProjectile.OnExitWater(self)
        self:SetDestroyOnWater(true)
    end,	

}

TypeClass = AAAZealotMissile01

