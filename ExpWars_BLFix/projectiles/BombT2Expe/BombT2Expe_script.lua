--
-- Aeon Very Fast Anti-Missile Missile
--

------------------------------------------------------------------------
local Game = import('/lua/game.lua')

--VARIABLE ''GLOBALE'' (par Manimal)
local ExpWarsPath = Game.ExpWarsPath
------------------------------------------------------------------------

local AIMBombExpe01 = import( ExpWarsPath .. '/lua/modprojectiles.lua').AIMBombExpe01

AIMAntiMissile01 = Class(AIMBombExpe01) {
    OnCreate = function(self)
        AIMBombExpe01.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 5.0)
    end,
}

TypeClass = AIMAntiMissile01

