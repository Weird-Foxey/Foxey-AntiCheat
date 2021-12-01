if Config.ExplosionProtection then
    AddEventHandler("explosionEvent",function(sender, ev)
        CancelEvent()
        for _, v in ipairs(Config.BlockedExplosions) do
            if ev.explosionType == v then
                CancelEvent()
                TriggerEvent("Foxey:Automatic-ban", " Explosion protection, ", sender)
                return
            end
        end
    end)
end