local version = tonumber( (string.gsub(string.gsub(GetVersion(), '1.5.', ''), '1.6.', '')) )

if version < 3652 then -- All versions below 3652 don't have buildin global icon support, so we need to insert the icons by our own function
    LOG('Nuclear Repulsor Shields: [unitview.lua '..debug.getinfo(1).currentline..'] - Gameversion is older then 3652. Hooking "UpdateWindow" to add our own unit icons')

local MyUnitIdTable = {
   qsb4409=true, -- Athayi Ythisioz - (City Shield Generator)
   qnb4409=true, -- Nebis - (City Shield Generator)
   qrb4409=true, -- ED7: Isola - (City Shield Generator)
   qrb4208=true, -- ED6: Gilmore - (Village Shield Generator)
   qab4410=true, -- Jenks - (Metropolis Shield Generator)
   qab4409=true, -- Gloucester - (City Shield Generator)
   qsb4410=true, -- Athayii Ythisioz - (Metropolis Shield Generator)
   qsb4408=true, -- Atha Ythisioz - (Village Shield Generator)
   qrb4410=true, -- ED8: Bovill - (Metropolis Shield Generator)
   qnb4410=true, -- Wagos - (Metropolis Shield Generator)
   qnb4408=true, -- Vapor - (Village Shield Generator)
   qeb4408=true, -- UHSD Puls: Cochran - (Village Shield Generator)
   qeb4410=true, -- EXHSD Puls: Bucksport - (Metropolis Shield Generator)
   qab4408=true, -- Cashton - (Village Shield Generator)
   qeb4409=true, -- EXSD Puls: Belmont - (City Shield Generator)
}

    local IconPath = "/Mods/NuclearRepulsorShields"

    local oldUpdateWindow = UpdateWindow
    function UpdateWindow(info)
        oldUpdateWindow(info)
        if MyUnitIdTable[info.blueprintId] then
            controls.icon:SetTexture(IconPath .. '/icons/units/' .. info.blueprintId .. '_icon.dds')
        end
    end

else
    LOG('Nuclear Repulsor Shields: [unitview.lua '..debug.getinfo(1).currentline..'] - Gameversion is 3652 or newer. No need to insert the unit icons by our own function.')
end