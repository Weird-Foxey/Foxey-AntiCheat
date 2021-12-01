Citizen.CreateThread(function()
    while Config.antispectate do
    Citizen.Wait(Config.Time + 3)    
        if NetworkIsInSpectatorMode() then
            TriggerServerEvent("Foxey:Automatic-ban", " Spectating ", source)
        end
    end
end)