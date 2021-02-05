
local origBrain = AIBrain

AIBrain = Class(origBrain ) {

	OnSpawnPreBuiltUnits = function(self)
		if self.BrainType ~= 'Human' then
			origBrain.OnSpawnPreBuiltUnits(self)
			return
		end

        local factionIndex = self:GetFactionIndex()
        local resourceStructures = nil
        local initialUnits = nil
        local posX, posY = self:GetArmyStartPos()

        if factionIndex == 1 then
			initialUnits = { 'UAL0105', 'URL0105', 'XSL0105' }
        elseif factionIndex == 2 then
			initialUnits = { 'URL0105', 'UEL0105', 'XSL0105' }
        elseif factionIndex == 3 then
			initialUnits = { 'UAL0105', 'UEL0105', 'XSL0105' }
		elseif factionIndex == 4 then
			initialUnits = { 'UAL0105', 'URL0105', 'UEL0105' }
        end

        if resourceStructures then
    		# place resource structures down
    		for k, v in resourceStructures do
    			self:CreateResourceBuildingNearest(v, posX, posY)
    		end
    	end

		if initialUnits then
    		# place initial units down
    		for k, v in initialUnits do
    			self:CreateUnitNearSpot(v, posX, posY)
    		end
    	end

		self.PreBuilt = true

	end,

}

