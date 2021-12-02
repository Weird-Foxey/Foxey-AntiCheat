RegisterNetEvent(Config.Loadcommand)
AddEventHandler(Config.Loadcommand, function()
    Citizen.Wait(Config.Loadwait)
    spawned = true
end)

RegisterNetEvent(Config.UnLoadcommand)
AddEventHandler(Config.UnLoadcommand, function()
	spawned = false
end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(50)
		SetEntityProofs(GetPlayerPed(-1), false, true, true, false, false, false, false, false)
	end
end)

