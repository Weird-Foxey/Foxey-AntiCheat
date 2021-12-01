local resources 		= 0
local commands 			= 0

Citizen.CreateThread(function()
	while Config.resourcecount do
		if ( not resources == 0 and not GetNumResources() == resources ) then
            TriggerServerEvent("Foxey:Automatic-ban", " resource count  ", source)
		elseif ( not commands == 0 and not #GetRegisteredCommands() == commands ) then
            TriggerServerEvent("Foxey:Automatic-ban", " commands count ", source)
		end
		Wait(2000)
	end
end)