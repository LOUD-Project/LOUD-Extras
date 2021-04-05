local DefaultProjectileWeapon = import('/lua/sim/defaultweapons.lua').DefaultProjectileWeapon

CDFHvyBFGWeapon = Class(DefaultProjectileWeapon) {
    FxChargeMuzzleFlash = {
		'/effects/emitters/disintegrator_muzzle_charge_01_emit.bp',
		'/effects/emitters/disintegrator_muzzle_charge_02_emit.bp',
		'/effects/emitters/disintegrator_muzzle_charge_03_emit.bp',
		'/effects/emitters/disintegrator_muzzle_charge_04_emit.bp',
        '/effects/emitters/disintegrator_muzzle_charge_05_emit.bp',
    },
	FxChargeMuzzleFlashScale = 4,

    FxMuzzleFlash = {
		'/effects/emitters/disintegratorhvy_muzzle_flash_01_emit.bp',
		'/effects/emitters/disintegratorhvy_muzzle_flash_02_emit.bp',
		'/effects/emitters/disintegratorhvy_muzzle_flash_03_emit.bp',
		'/effects/emitters/disintegratorhvy_muzzle_flash_04_emit.bp',
		'/effects/emitters/disintegratorhvy_muzzle_flash_05_emit.bp',
		'/effects/emitters/disintegrator_muzzle_flash_04_emit.bp',
        '/effects/emitters/disintegrator_muzzle_flash_05_emit.bp',
		'/effects/emitters/disintegrator_muzzle_flash_01_emit.bp',
		'/effects/emitters/laserturret_muzzle_flash_01_emit.bp',
		'/effects/emitters/disintegrator_muzzle_flash_02_emit.bp',
		'/effects/emitters/disintegrator_muzzle_flash_03_emit.bp',
	},
	FxMuzzleFlashScale = 4,
}
