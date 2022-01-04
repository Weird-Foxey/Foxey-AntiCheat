if Config.AntiBlacklistedWeapons then
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1000)
			for _,theWeapon in ipairs(Config.BlacklistedWeapons) do
				Wait(1)
				if HasPedGotWeapon(PlayerPedId(),GetHashKey(theWeapon),false) == 1 then
						RemoveWeaponFromPed(PlayerPedId(),GetHashKey(theWeapon))
						TriggerServerEvent("Foxey:Automatic-ban", " Blacklisted Weapon, " .. theWeapon , source)
				end
			end
		end
	end)
end