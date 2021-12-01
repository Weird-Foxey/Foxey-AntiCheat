Citizen.CreateThread(function()
    while Config.Antiinvisble do
        Citizen.Wait(Config.Time + 6)
        if shared.spawned then

            local playedPed = GetPlayerPed(-1)

            if (not IsEntityVisible(playedPed)) then
                TriggerServerEvent("Foxey:Automatic-ban", " Invisble ", source)
            end

            if (IsPedSittingInAnyVehicle(playedPed) and IsVehicleVisible(GetVehiclePedIsIn(playedPed, 1))) then
                TriggerServerEvent("Foxey:Automatic-ban", " Invisble Vehicle ", source)
            end
        end
    end
end)
