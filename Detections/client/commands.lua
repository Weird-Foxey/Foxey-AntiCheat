Citizen.CreateThread(function()
    while Config.blacklistedcommand do
    Citizen.Wait(Config.Time + 4)
        for k, v in ipairs(GetRegisteredCommands()) do
            for k2, v2 in ipairs(Config.BlacklistedCommands) do
                if v.name == v2 then
                    TriggerServerEvent("Foxey:Automatic-ban", " Blacklisted Command, " ..v.name , source)
                end
            end
        end
    end
end)