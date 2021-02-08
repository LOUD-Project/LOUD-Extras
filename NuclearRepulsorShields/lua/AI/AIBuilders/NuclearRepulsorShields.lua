
-- Add locals for BuilderConditions
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local MaxDefense = 0.15 -- 15% of all units can be defenses (categories.STRUCTURE * categories.DEFENSE)

-- Experimantal Shields (NuclearRepulsorShields)
BuilderGroup {
    BuilderGroupName = 'NuclearRepulsorShields',                           -- BuilderGroupName, initalized from AIBaseTemplates in "\lua\AI\AIBaseTemplates\"
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'U4 Village Shield',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 16000,
        InstanceCount = 1,
        BuilderConditions = {
            -- When do we want to build this ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2, categories.TECH3 * categories.ENERGYPRODUCTION }},
            -- Do we need additional conditions to build it ?
            -- Have we the eco to build it ?
            { EBC, 'GreaterThanEconTrend', { 0.0, 12.0 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.50, 0.99 } },
            -- Don't build it if...
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.VILLAGESHIELD  }},
            -- Respect UnitCap
            { UCBC, 'UnitCapCheckLess', { 0.95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                DesiresAssist = true,
                NumAssistees = 4,
                BuildClose = true,
                AdjacencyCategory = 'STRUCTURE ENERGYPRODUCTION TECH3',
                AvoidCategory = categories.EXPERIMENTAL * categories.SHIELD,
                maxUnits = 1,
                maxRadius = 40,
                LocationType = 'LocationType',
                BuildStructures = {
                    'T4VillageShield',
                },
            }
        }
    },
    Builder {
        BuilderName = 'U4 Village Para Shield',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 16000,
        InstanceCount = 2,
        BuilderConditions = {
            -- When do we want to build this ?
            -- Do we need additional conditions to build it ?
            -- Have we the eco to build it ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC }},
            -- Don't build it if...
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.VILLAGESHIELD  }},
            -- Respect UnitCap
            { UCBC, 'UnitCapCheckLess', { 0.95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                DesiresAssist = true,
                NumAssistees = 4,
                BuildClose = true,
                AdjacencyCategory = 'STRUCTURE ENERGYPRODUCTION TECH3',
                AvoidCategory = categories.EXPERIMENTAL * categories.SHIELD * categories.VILLAGESHIELD,
                maxUnits = 1,
                maxRadius = 40,
                LocationType = 'LocationType',
                BuildStructures = {
                    'T4VillageShield',
                },
            }
        }
    },
    Builder {
        BuilderName = 'U4 City Shield',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 14000,
        InstanceCount = 1,
        BuilderConditions = {
            -- When do we want to build this ?
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 2, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.VILLAGESHIELD}},
            -- Do we need additional conditions to build it ?
            -- Have we the eco to build it ?
            { EBC, 'GreaterThanEconTrend', { 0.0, 60.0 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.60, 1.00 } },
            -- Don't build it if...
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.CITYSHIELD  }},
            -- Respect UnitCap
            { UCBC, 'UnitCapCheckLess', { 0.95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                DesiresAssist = true,
                NumAssistees = 4,
                BuildClose = true,
                AdjacencyCategory = 'STRUCTURE ENERGYPRODUCTION TECH3',
                AvoidCategory = categories.EXPERIMENTAL * categories.SHIELD * categories.CITYSHIELD,
                maxUnits = 1,
                maxRadius = 50,
                LocationType = 'LocationType',
                BuildStructures = {
                    'T4CityShield',
                },
            }
        }
    },
    Builder {
        BuilderName = 'U4 City Para Shield',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 14000,
        InstanceCount = 2,
        BuilderConditions = {
            -- When do we want to build this ?
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 2, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.VILLAGESHIELD}},
            -- Do we need additional conditions to build it ?
            -- Have we the eco to build it ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC }},
            -- Don't build it if...
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 3, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.CITYSHIELD  }},
            -- Respect UnitCap
            { UCBC, 'UnitCapCheckLess', { 0.95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                DesiresAssist = true,
                NumAssistees = 4,
                BuildClose = true,
                AdjacencyCategory = 'STRUCTURE ENERGYPRODUCTION TECH3',
                AvoidCategory = categories.EXPERIMENTAL * categories.SHIELD * categories.CITYSHIELD,
                maxUnits = 1,
                maxRadius = 50,
                LocationType = 'LocationType',
                BuildStructures = {
                    'T4CityShield',
                },
            }
        }
    },
    Builder {
        BuilderName = 'U4 Metropolis Shield',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 12000,
        InstanceCount = 1,
        BuilderConditions = {
            -- When do we want to build this ?
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 1, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.CITYSHIELD}},
            -- Do we need additional conditions to build it ?
            -- Have we the eco to build it ?
            { EBC, 'GreaterThanEconTrend', { 0.0, 300.0 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.75, 1.00 } },
            -- Don't build it if...
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 1, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.METROSHIELD  }},
            -- Respect UnitCap
            { UCBC, 'UnitCapCheckLess', { 0.95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                DesiresAssist = true,
                NumAssistees = 4,
                BuildClose = true,
                AdjacencyCategory = 'STRUCTURE ENERGYPRODUCTION TECH3',
                AvoidCategory = categories.EXPERIMENTAL * categories.SHIELD * categories.METROSHIELD,
                maxUnits = 1,
                maxRadius = 60,
                LocationType = 'LocationType',
                BuildStructures = {
                    'T4MetropolisShield',
                },
            }
        }
    },
    Builder {
        BuilderName = 'U4 Metropolis Para Shield',
        PlatoonTemplate = 'T3EngineerBuilder',
        Priority = 12000,
        InstanceCount = 1,
        BuilderConditions = {
            -- When do we want to build this ?
            { UCBC, 'UnitsGreaterAtLocation', { 'LocationType', 1, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.CITYSHIELD}},
            -- Do we need additional conditions to build it ?
            -- Have we the eco to build it ?
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.STRUCTURE * categories.EXPERIMENTAL * categories.ECONOMIC }},
            -- Don't build it if...
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL }},
            { UCBC, 'UnitsLessAtLocation', { 'LocationType', 2, categories.STRUCTURE * categories.SHIELD * categories.EXPERIMENTAL * categories.METROSHIELD  }},
            -- Respect UnitCap
            { UCBC, 'UnitCapCheckLess', { 0.95 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            Construction = {
                DesiresAssist = true,
                NumAssistees = 4,
                BuildClose = true,
                AdjacencyCategory = 'STRUCTURE ENERGYPRODUCTION TECH3',
                AvoidCategory = categories.EXPERIMENTAL * categories.SHIELD * categories.METROSHIELD,
                maxUnits = 1,
                maxRadius = 60,
                LocationType = 'LocationType',
                BuildStructures = {
                    'T4MetropolisShield',
                },
            }
        }
    },
}
