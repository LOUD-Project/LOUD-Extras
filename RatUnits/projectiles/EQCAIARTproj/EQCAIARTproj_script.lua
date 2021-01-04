local TDFGaussCannonProjectile = import('/lua/terranprojectiles.lua').TDFShipGaussCannonProjectile
TDFGauss03 = Class(TDFGaussCannonProjectile) {
    FxTrails = {'/effects/emitters/gauss_cannon_munition_trail_03_emit.bp',},
    FxLandHitScale = 7.5,
}
TypeClass = TDFGauss03

