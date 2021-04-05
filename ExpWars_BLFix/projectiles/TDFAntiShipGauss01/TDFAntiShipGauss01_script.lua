--
-- Terran Gauss Cannon Projectile
--
local TDFAntiShipGaussCannonProjectile = import('/Mods/ExpWars_BLFix/lua/modprojectiles.lua').TDFAntiShipGaussCannonProjectile--TDFShipGaussCannonProjectile

TDFAntiShipGaussCannonProjectile = Class(TDFAntiShipGaussCannonProjectile) {
    FxTrails = {'/effects/emitters/gauss_cannon_munition_trail_03_emit.bp',},

}
TypeClass = TDFAntiShipGaussCannonProjectile
