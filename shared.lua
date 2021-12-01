shared = {}

shared.spawned = false



RegisterCommand("ImSpawned", function(source,args,rawCommand)
    shared.spawned = true
    print('yes you are spawned')
end, false)
