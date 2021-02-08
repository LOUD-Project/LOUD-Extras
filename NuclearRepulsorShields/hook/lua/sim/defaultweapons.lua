ShieldDeathWeapon = Class(BareBonesWeapon) {
    OnFire = function(self)
    end,

    Fire = function(self)
        local NukeDamage = import('/Mods/NuclearRepulsorShields/hook/lua/sim/NukeDamage.lua').NukeAOE
        local bp = self:GetBlueprint()
        local proj = self.unit:CreateProjectile(bp.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
        local data = {
            NukeOuterRingDamage = bp.NukeOuterRingDamage,
            NukeOuterRingRadius = bp.NukeOuterRingRadius,
            NukeOuterRingTicks = bp.NukeOuterRingTicks,
            NukeOuterRingTotalTime = bp.NukeOuterRingTotalTime,
            NukeInnerRingDamage = bp.NukeInnerRingDamage,
            NukeInnerRingRadius = bp.NukeInnerRingRadius,
            NukeInnerRingTicks = bp.NukeInnerRingTicks,
            NukeInnerRingTotalTime = bp.NukeInnerRingTotalTime,
        }
        proj:PassData(data)
    end,
}
