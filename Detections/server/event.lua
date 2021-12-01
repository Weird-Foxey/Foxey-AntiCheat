-- Anti Server events
if Config.BlacklistedEvent then
    for _, eventInfo in pairs(Config.BlacklistedEvents) do
        if (registeredEvents == nil) then
            registeredEvents = {}
        end

        if (registeredEvents[eventInfo] == nil or not registeredEvents[eventInfo]) then
            RegisterNetEvent(eventInfo)
            AddEventHandler(eventInfo, function()
                TriggerEvent("Foxey:Automatic-ban", " SERVER Event protection, ", source)
            end)

            registeredEvents[eventInfo] = true
        end
    end
end