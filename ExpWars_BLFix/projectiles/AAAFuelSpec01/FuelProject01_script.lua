--
-- Aeon Anti Air Projectile
--
local SLosaareAAAutoCannon = import('/lua/seraphimprojectiles.lua').SLosaareAAAutoCannon

SAALosaareAutoCannon02 = Class(SLosaareAAAutoCannon) {

  OnImpact = function(self, TargetType, TargetEntity)
      SLosaareAAAutoCannon.OnImpact(self, TargetType, TargetEntity)
      if TargetType == 'UnitAir' then
        if TargetEntity then
          local fueluse = TargetEntity:GetFuelUseTime()
          local fuelratio = TargetEntity:GetFuelRatio()
          local currentfuel = fueluse * fuelratio
          if currentfuel > 0 then
              local newfuelvalue = 1 -- FuelDrainSec is a value in Seconds
				TargetEntity:SetFuelRatio(newfuelvalue / fueluse)
          end
        end
      end
  end,

}
TypeClass = SAALosaareAutoCannon02