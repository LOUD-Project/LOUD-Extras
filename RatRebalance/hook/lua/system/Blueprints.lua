do

local function ReenableArchimedes(all_bps)
	table.insert(all_bps.sel0320.Categories, 'BUILTBYTIER3FACTORY')
end

OldModBlueprints = ModBlueprints

function ModBlueprints(all_blueprints)
	local modCfg = {}
	for _, v in __active_mods do
		if v.uid == '2c796a72-6d5a-11eb-9439-RATREBALANCE' then
			modCfg = v.config
			break
		end
	end
	if not modCfg then return end

	if modCfg['Archimedes'] == 'on' and all_blueprints.Unit.sel0320 then
		ReenableArchimedes(all_blueprints.Unit)
	end

	OldModBlueprints(all_blueprints)
end

end