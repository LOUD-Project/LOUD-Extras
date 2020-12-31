local CSubUnit = import('/lua/cybranunits.lua').CSubUnit

local Weapon = import('/lua/sim/Weapon.lua').Weapon
local WeaponFile = import('/lua/sim/defaultweapons.lua')
local CybranWeaponsFile = import('/lua/cybranweapons.lua')

local CAAAutocannon = import('/lua/cybranweapons.lua').CAAAutocannon
local CANNaniteTorpedoWeapon = import('/lua/cybranweapons.lua').CANNaniteTorpedoWeapon
local CIFMissileLoaWeapon = import('/lua/cybranweapons.lua').CIFMissileLoaWeapon

GMRS302 = Class(CSubUnit) {
    DeathThreadDestructionWaitTime = 0,
    
    Weapons = {
        CruiseMissile = Class(CIFMissileLoaWeapon){},
        AAGunFL = Class(CAAAutocannon) {},
        AAGunFR = Class(CAAAutocannon) {},
        AAGunBL = Class(CAAAutocannon) {},
        AAGunBR = Class(CAAAutocannon) {},
        TorpedoA = Class(CANNaniteTorpedoWeapon) {},
        TorpedoAA = Class(CANNaniteTorpedoWeapon) {},
        TorpedoAAA = Class(CANNaniteTorpedoWeapon) {},
        TorpedoB = Class(CANNaniteTorpedoWeapon) {},
        TorpedoBB = Class(CANNaniteTorpedoWeapon) {},
        TorpedoBBB = Class(CANNaniteTorpedoWeapon) {},
    },
#    OnStopBeingBuilt = function(self, builder, layer)
#        CSubUnit.OnStopBeingBuilt(self,builder,layer)
#        if(self:GetCurrentLayer() == 'Water') then
#			# Enable weapon
#			self:SetWeaponEnabledByLabel('MainGun', true)
#        elseif (self:GetCurrentLayer() == 'UnderWater') then
#			# Disable Weapon
#			self:SetWeaponDisableByLabel('MainGun', false)
#       end
#       self.WeaponsEnabled = true
#    end,
	OnLayerChange = function(self, new, old)
		CSubUnit.OnLayerChange(self, new, old)
		if self.WeaponsEnabled then
			if( new == 'Water' ) then
				# Enable Minigun
				self:SetWeaponEnabledByLabel('MainGun', true)
				self:SetWeaponEnabledByLabel('AAGunFL', true)
				self:SetWeaponEnabledByLabel('AAGunFR', true)
				self:SetWeaponEnabledByLabel('AAGunBL', true)
				self:SetWeaponEnabledByLabel('AAGunBR', true)
			elseif ( new == 'UnderWater' ) then
				# Disable Land Minigun
				self:SetWeaponDisableByLabel('MainGun', false)
				self:SetWeaponDisableByLabel('AAGunFL', false)
				self:SetWeaponDisableByLabel('AAGunFR', false)
				self:SetWeaponDisableByLabel('AAGunBL', false)
				self:SetWeaponDisableByLabel('AAGunBR', false)
			end
		end
	end,
}

TypeClass = GMRS302