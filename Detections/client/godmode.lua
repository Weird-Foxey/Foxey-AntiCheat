Citizen.CreateThread(function()
    while Config.antigodmode do

        if GetPlayerInvincible(player) then
            TriggerServerEvent("XNA:Automatic-ban", " Godmode ", source)
        end

        
        Citizen.Wait(10000)
        local curPed = PlayerPedId()
        local curHealth = GetEntityHealth(curPed)
        SetEntityHealth( curPed, curHealth-2)
        local curWait = math.random(10,150)

        Citizen.Wait(curWait)

        if not IsPlayerDead(PlayerId()) then
            if PlayerPedId() == curPed and GetEntityHealth(curPed) == curHealth and GetEntityHealth(curPed) ~= 0 then
                avert = avert + 1
            elseif GetEntityHealth(curPed) == curHealth-2 then
                SetEntityHealth(curPed, GetEntityHealth(curPed)+2)
            elseif GetEntityHealth(curPed) > 201 then
                TriggerServerEvent("XNA:Automatic-ban", " Godmode ", source)
            end
        end
    end
end)