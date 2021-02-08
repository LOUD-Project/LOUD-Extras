
local OLDSetupSession = SetupSession
function SetupSession()
    OLDSetupSession()
    import('/mods/nuclearrepulsorshields/lua/AI/AIBuilders/NuclearRepulsorShields.lua')
end
