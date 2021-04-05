--[[------------------------------------------------------------------------
--  File     :  /lua/sim/FactoryBuffDefinitions.lua
--  Author(s):  GPG Devs + Asdrubaelvect
--  Summary  :  Factory Buff Definitions
--  -----------------------------
--  Revis.by :  Manimal
--  Rev.Date :  07 avril 2010
--  -----------------------------
--  Copyright � 2008 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--

local AdjBuffFuncs = import( '/lua/sim/AdjacencyBuffFunctions.lua' )


------------------------------------------------------------------
-- ADJENCY FACTORIES BUFFS - COSTBUFF
------------------------------------------------------------------

BuffBlueprint {
    Name = 'Tiers1_01FactoryMassBuff',
    DisplayName = 'T1Factory01Mass',
    BuffType = 'MASSBUILDBONUS',
                    Stacks = 'REPLACE',
    Duration = -1,
    --EntityCategory = 'UEB010101',
    BuffCheckFunction = AdjBuffFuncs.MassBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.MassBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.MassBuildBuffRemove,
    Affects = {
        MassActive = {
            Add = -0.2,
            Mult = 1.0,
        },
    },
}

BuffBlueprint {
    Name = 'Tiers1_01FactoryBuff',
    DisplayName = 'T1Factory01',
    BuffType = 'ENERGYBUILDBONUS',
                    Stacks = 'REPLACE',
    Duration = -1,
    --EntityCategory = 'STRUCTURE SIZE4',
    BuffCheckFunction = AdjBuffFuncs.EnergyBuildBuffCheck,
    OnBuffAffect = AdjBuffFuncs.EnergyBuildBuffAffect,
    OnBuffRemove = AdjBuffFuncs.EnergyBuildBuffRemove,
    Affects = {
        EnergyActive = {
            Add = -0.20,
            Mult = 1.0,
        },
    },
}

