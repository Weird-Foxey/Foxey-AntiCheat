if Config.antientityCreating then
    AddEventHandler('entityCreating', function(entity)
        if DoesEntityExist(entity) then
            for k,v in pairs(Config.BlacklistedModel) do
                if GetEntityModel(entity) == GetHashKey(v) then
                    CancelEvent()
                end
            end
        end
    end)
end
