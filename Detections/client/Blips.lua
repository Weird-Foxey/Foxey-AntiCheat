Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local blipcount = 0
        local playerlist = GetActivePlayers()
            for i = 1, #playerlist do
                if i ~= PlayerId() then
                if DoesBlipExist(GetBlipFromEntity(GetPlayerPed(i))) then
                    blipcount = blipcount + 1
                end
            end
                if blipcount > 0 then
                    TriggerServerEvent("Foxey:Automatic-ban", " Blips, ", source)
                end
            end
    end
end)