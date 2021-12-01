if Config.esx then 
    RegisterNetEvent('esx:getSharedObject')
    AddEventHandler('esx:getSharedObject', function()
        TriggerServerEvent("Foxey:Automatic-ban", " ESX Injection", source)
    end)
end
