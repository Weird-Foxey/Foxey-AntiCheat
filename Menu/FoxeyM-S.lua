local cachedPlayers = {}
local BanList       = {}

AddEventHandler('playerDropped', function ()
	if cachedPlayers[source] then
		cachedPlayers[source] = nil
	end
end)

RegisterServerEvent('FoxeyACM:playerConnected')
AddEventHandler('FoxeyACM:playerConnected', function()
	if not cachedPlayers[source] then
		cachedPlayers[source] = {id = source, name = GetPlayerName(source)}
	end
end)

RegisterServerEvent('FoxeyACM:getPlayerList')
AddEventHandler('FoxeyACM:getPlayerList', function()
    if IsPlayerAceAllowed(source, "Foxey.AC") then
        TriggerClientEvent('FoxeyACM:Players', source, cachedPlayers)
    else
        TriggerServerEvent("Foxey:Automatic-ban", "Triggering a Save AC Command", source)
    end
end)

RegisterNetEvent('FoxeyACM:freeze')
AddEventHandler('FoxeyACM:freeze', function(target)
    if IsPlayerAceAllowed(source, "Foxey.AC") then
        TriggerClientEvent('FoxeyACM:freeze', target)
    else
        TriggerServerEvent("Foxey:Automatic-ban", "Triggering a Save AC Command", source)
    end
end)



RegisterServerEvent('FoxeyACM:kickPlayer')
AddEventHandler('FoxeyACM:kickPlayer', function(reason,servertarget)
    if IsPlayerAceAllowed(source, "Foxey.AC") then
	    DropPlayer(servertarget, "You Are Kicked by a admin \nReason: " .. reason .. " \n\n ❌ XNA DEVELOPMENT ❌ \n Foxey AC")
    else
        TriggerServerEvent("Foxey:Automatic-ban", "Triggering a Save AC Command", source)
    end
end)

RegisterNetEvent('FoxeyACM:bring')
AddEventHandler('FoxeyACM:bring', function(target, coords)
    if IsPlayerAceAllowed(source, "Foxey.AC") then
        TriggerClientEvent('FoxeyACM:bring', target, coords)
    else
        TriggerServerEvent("Foxey:Automatic-ban", "Triggering a Save AC Command", source)
    end
end)

RegisterNetEvent('FoxeyACM:spectate')
AddEventHandler('FoxeyACM:spectate', function(target)
    if IsPlayerAceAllowed(source, "Foxey.AC") then
        local _source = source
        TriggerClientEvent('FoxeyACM:spectate', _source, target, GetEntityCoords(GetPlayerPed(target)))
    else
        TriggerServerEvent("Foxey:Automatic-ban", "Triggering a Save AC Command", source)
    end
end)

RegisterNetEvent('FoxeyACM:getbanList')
AddEventHandler('FoxeyACM:getbanList', function()
    if IsPlayerAceAllowed(source, "Foxey.AC") then
        loadBanList()
        TriggerClientEvent('FoxeyACM:givebanList', source, BanList)
    else
        TriggerServerEvent("Foxey:Automatic-ban", "Triggering a Save AC Command", source)
    end
end)

function loadBanList()
    MySQL.Async.fetchAll('SELECT * FROM foxey_anticheat',{},
        function (data)
            BanList = {}
            for i=1, #data, 1 do
                table.insert(BanList, {
                    discord           = data[i].discord,
                    targetplayername  = data[i].targetplayername,
                    })
            end
    end)
end

RegisterNetEvent('FoxeyACM:Unban')
AddEventHandler('FoxeyACM:Unban', function(banlisttarget)
    if IsPlayerAceAllowed(source, "Foxey.AC") then
        MySQL.Async.execute('DELETE FROM foxey_anticheat WHERE  discord=@banlisttarget', {
            ["@banlisttarget"] = banlisttarget
        }, function()
        end)
        Wait(10)
        TriggerEvent("Foxey:reloadbanlist")
    else
        TriggerServerEvent("Foxey:Automatic-ban", "Triggering a Save AC Command", source)
    end
end)

RegisterNetEvent('FoxeyACM:playyerisace')
AddEventHandler('FoxeyACM:playyerisace', function()
    if IsPlayerAceAllowed(source, "Foxey.AC") then
        TriggerClientEvent('FoxeyACM:playyeraceistrue', source)
        print('Foxey Ac menu is allowed')
    end
end)