local Freecamallow = true


AddEventHandler('playerSpawned', function()
  Freecamallow = false
end)


RegisterNetEvent(Config.freecamallowcommand)
AddEventHandler(Config.freecamallowcommand, function()
  Freecamallow = true
end)


RegisterNetEvent(Config.freecamdenycommand)
AddEventHandler(Config.freecamdenycommand, function()
  Freecamallow = false
end)

Citizen.CreateThread(function()
    while Config.freecam do
        Citizen.Wait(Config.Time + 2)
        if not Freecamallow then
            local camRight, camForward, camUp, camPosition = GetCamMatrix(GetRenderingCam())
            if camRight  ~= vector3(0, 0, 0) or camForward  ~= vector3(0, 0, 0) or camUp  ~= vector3(0, 0, 0) or camPosition  ~= vector3(0, 0, 0) then
                TriggerServerEvent("Foxey:Automatic-ban", " Free Cam ", source)
            end
        end
    end
end)