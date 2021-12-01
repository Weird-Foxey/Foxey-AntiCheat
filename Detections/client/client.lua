RegisterNetEvent(Config.Loadcommand)
AddEventHandler(Config.Loadcommand, function()
    Citizen.Wait(Config.Loadwait)
    spawned = true
    if Config.debug then
        print('AC is checking you now')
    end
end)

RegisterNetEvent(Config.UnLoadcommand)
AddEventHandler(Config.UnLoadcommand, function()
	spawned = false
    if Config.debug then
        print('AC stoped checking you now')
    end
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(50)
		SetEntityProofs(GetPlayerPed(-1), false, true, true, false, false, false, false, false)
	end
end)

