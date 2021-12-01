if Config.GiveWeaponsProtection then
    AddEventHandler("giveWeaponEvent", function(sender, data)
        CancelEvent()
        print(sender.." Tried to give weapons")
        TriggerEvent("Foxey:Automatic-ban", " giveWeaponEvent, ", sender)
    end)
end