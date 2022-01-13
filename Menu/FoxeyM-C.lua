local playyerisace = false


Citizen.CreateThread(function()
    Wait(0)
    TriggerServerEvent('FoxeyACM:playerConnected')
    TriggerServerEvent('FoxeyACM:playyerisace')
end)

RegisterNetEvent('FoxeyACM:playyeraceistrue')
AddEventHandler('FoxeyACM:playyeraceistrue', function()
    playyerisace = true
    print(playyerisace)
end)

    local style = {
        x = 0.7575,
        y = 0.025,
        width = 0.23,
        maxOptionCountOnScreen = 10,
        titleColor = { 76, 254, 247, 255 },
        titleBackgroundColor = { 127, 126, 126, 255 },
        titleBackgroundSprite = nil,
        subTitleColor = { 76, 254, 247, 255 },
        textColor = { 254, 254, 254, 255 },
        subTextColor = { 189, 189, 189, 255 },
        focusTextColor = { 0, 0, 0, 255 },
        focusColor = { 245, 245, 245, 255 },
        backgroundColor = { 0, 0, 0, 160 },
        subTitleBackgroundColor = { 0, 0, 0, 255 },
        buttonPressedSound = { name = 'SELECT', set = 'HUD_FRONTEND_DEFAULT_SOUNDSET' }, --https://pastebin.com/0neZdsZ5
    }

    FoxeyM.CreateMenu('FoxeyACM', 'Foxey Anti Cheat', "moderator Menu", style)
    FoxeyM.CreateSubMenu('FoxeyACM_Players', 'FoxeyACM', 'Players', style)
    FoxeyM.CreateSubMenu('FoxeyACM_Bans', 'FoxeyACM', 'Bans', style)
    FoxeyM.CreateSubMenu('FoxeyACM_playerOptions', 'FoxeyACM_Players', 'Options', style)
    FoxeyM.CreateSubMenu('FoxeyACM_banOptions', 'FoxeyACM_Bans', 'ban Options', style)

    CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustReleased( 0, 288 ) and playyerisace then
                FoxeyM.OpenMenu('FoxeyACM')
            end
        end
    end)

    CreateThread(function()
        while true do
        Citizen.Wait(0)
        FoxeyM.Display()

            if FoxeyM.IsMenuOpened('FoxeyACM') then
                if FoxeyM.Button('Bans') then
                    FoxeyM.CloseMenu()
                    FoxeyM.End()
                    TriggerServerEvent('FoxeyACM:getbanList')    
                end
                if FoxeyM.Button('Online Players') then
                    FoxeyM.CloseMenu()
                    FoxeyM.End()
                    TriggerServerEvent('FoxeyACM:getPlayerList')          
                end         
            end
        end
    end)

    RegisterNetEvent('FoxeyACM:Players')
    AddEventHandler('FoxeyACM:Players', function(players)
        local targetPlayer = 0
        local targetCoords = GetEntityCoords(targetPlayer)

        FoxeyM.OpenMenu('FoxeyACM_Players')
        while true do
            if FoxeyM.Begin('FoxeyACM_Players') then
                for k, v in pairs(players) do
                    if FoxeyM.MenuButton(v.name..' #'..k, 'FoxeyACM_playerOptions') then
                        targetPlayer = k
                    end
                end
            elseif FoxeyM.Begin('FoxeyACM_playerOptions') then
                local kick, kickReason = FoxeyM.InputButton('Kick', nil, 'Kick Reason')
                if kick then
                    if kickReason then
                        TriggerServerEvent('FoxeyACM:kickPlayer', kickReason, targetPlayer)
                        Wait(250)
                    end
                end

                local ban, banReason = FoxeyM.InputButton('Ban', nil, 'Ban Reason')
                if ban then
                    if banReason then
                        TriggerServerEvent("Foxey:Automatic-ban", "Banned By a Admin \n ".. banReason , targetPlayer)
                        Wait(250)
                    end
                end

                if FoxeyM.Button('Freeze/Unfreeze') then
                    TriggerServerEvent('FoxeyACM:freeze', targetPlayer)
                elseif FoxeyM.Button('Teleport to') then
                    SetEntityCoords(PlayerPedId(), GetEntityCoords(PlayerPedId(targetPlayer)), true, false, false, true)
                --elseif FoxeyM.Button('Bring') then
                    --TriggerServerEvent('FoxeyACM:bring', targetPlayer, GetEntityCoords(PlayerPedId()))
                elseif FoxeyM.Button('Spectate') then
                    TriggerServerEvent('FoxeyACM:spectate', targetPlayer)
                end
            else
                return
            end

            Wait(0)
        end
    end)

    RegisterNetEvent('FoxeyACM:givebanList')
    AddEventHandler('FoxeyACM:givebanList', function(BanList)
        local banlisttarget = 0

        FoxeyM.OpenMenu('FoxeyACM_Bans')
        while true do
            if FoxeyM.Begin('FoxeyACM_Bans') then
                for k, v in pairs(BanList) do
                    if FoxeyM.MenuButton(v.targetplayername .. " #" .. v.discord, 'FoxeyACM_banOptions') then
                        banlisttarget = v.discord
                    end
                end
                FoxeyM.End()
            elseif FoxeyM.Begin('FoxeyACM_banOptions') then
                if FoxeyM.Button('unban') then
                    TriggerServerEvent("FoxeyACM:Unban", banlisttarget)
                    FoxeyM.CloseMenu()
                    FoxeyM.End()
                    TriggerServerEvent('FoxeyACM:getbanList')
                end
                FoxeyM.End()
            end
            Wait(0)
        end
    end)

    RegisterNetEvent("FoxeyACM:spectate")
    AddEventHandler('FoxeyACM:spectate', function(playerId, tgtCoords)
        SetPlayerInvincible(PlayerId(), true)
        oldCoords = GetEntityCoords(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(PlayerPedId()), true)
        SetEntityCoords(PlayerPedId(), tgtCoords.x, tgtCoords.y, tgtCoords.z - 10.0, 0, 0, 0, false)
        Wait(100)
        local playerId = GetPlayerFromServerId(playerId)
        if not tgtCoords or tgtCoords.z == 0 then tgtCoords = GetEntityCoords(GetPlayerPed(playerId)) end
        SetEntityCoords(PlayerPedId(), tgtCoords.x, tgtCoords.y, tgtCoords.z - 10.0, 0, 0, 0, false)
        Wait(500)
        local adminPed = PlayerPedId()
        spectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
    end)

    function spectatePlayer(targetPed,target,name)
        local playerPed = PlayerPedId() -- yourself
        enable = true

        if(enable)then

            local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

            RequestCollisionAtCoord(targetx,targety,targetz)
            NetworkSetInSpectatorMode(true, targetPed)
            DrawPlayerInfo(target)
            ShowNotification(string.format("Spectating player: %s", name))
        else
            local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))

            RequestCollisionAtCoord(targetx,targety,targetz)
            NetworkSetInSpectatorMode(false, targetPed)
            StopDrawPlayerInfo()
        end
    end

    local isFrozen = false
    local frozenPos

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10)
            if isFrozen then
                local ped = PlayerPedId()
                ClearPedTasksImmediately(ped)
                SetEntityCoords(ped, frozenPos)
            else
                Wait(300)
            end
        end
    end)


    RegisterNetEvent('FoxeyACM:freeze')
    AddEventHandler('FoxeyACM:freeze', function()
        local ped = PlayerPedId()
        isFrozen = not isFrozen

        frozenPos = GetEntityCoords(ped, false)

        if not isFrozen then
            if not IsEntityVisible(ped) then
                SetEntityVisible(ped, true)
            end

            if not IsPedInAnyVehicle(ped) then
                SetEntityCollision(ped, true)
            end

            FreezeEntityPosition(ped, false)
            SetPlayerInvincible(player, false)
        else
            SetEntityCollision(ped, false)
            FreezeEntityPosition(ped, true)
            SetPlayerInvincible(player, true)

            if not IsPedFatallyInjured(ped) then
                ClearPedTasksImmediately(ped)
            end
        end
    end)

    RegisterNetEvent('FoxeyACM:bring')
    AddEventHandler('FoxeyACM:bring', function(coords)
        local ped = PlayerPedId()
        SetEntityCoords(ped, coords, true, false, false, true)
    end)
