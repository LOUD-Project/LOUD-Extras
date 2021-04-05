--[[------------------------------------------------------------------------
--  File     :  /effects/entities/UnitTeleport01/UnitTeleport01_script.lua
--  Author(s):  Gordon Duclos
--  Summary  :  Unit Teleport effect entity
--  ----------------------------------------------------------
--  Modif.by :  Asdrubael
--  Rev.Date :  31 juillet 2011
--  ----------------------------------------------------------
--  Revis.by :  Manimal
--  Rev.Date :  01 aout 2011 -> Ajout de ma variable ExpWarsPath
--  ----------------------------------------------------------
--  Revis.by :  nnnnnnn
--  Rev.Date :  dd mmmmm yyyy
--  ----------------------------------------------------------
--  Copyright � 2006 Gas Powered Games, Inc.  All rights reserved.
------------------------------------------------------------------------]]--

--===============================================================================
local Game = import('/lua/game.lua')

-- VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
--===============================================================================

local TeleportProjectile = import( ExpWarsPath .. '/lua/teleporteffect.lua').TeleportProjectile
local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
local EffectTemplate = import('/lua/EffectTemplates.lua')

UnitTeleportEffect06 = Class(TeleportProjectile) {

}

TypeClass = UnitTeleportEffect06
