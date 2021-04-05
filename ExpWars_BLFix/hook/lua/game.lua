do
    local GetExpWarsPath = function()
        for i, mod in __active_mods do
            if mod.uid == "e403c941-1faa-42a5-bcce-4762af26140aBLFIX" then
                return mod.location
            end
        end
    end

    ExpWarsPath = GetExpWarsPath()
end
