-- Locals
local BanList            = {}
local BanListLoad        = false

local DISCORD_WEBHOOK = Config.Webhook
local DISCORD_NAME = "XNA | Foxey AC"
local DISCORD_IMAGE = "https://cdn.discordapp.com/attachments/915014695444967425/915014858716643349/gaming-logo-template-featuring-cuphead-inspired-graphics-2957_4.png"

PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, content = "Foxey AntiCheat **ONLINE**", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })

-- Banlist load
CreateThread(function()
	while true do
		Wait(1000)
		if BanListLoad == false then
			loadBanList()
			if BanList ~= {} then
				BanListLoad = true
			end
		end
	end
end)

-- Banlist Reload
CreateThread(function()
	while true do
		Wait(600000)
		if BanListLoad == true then
			loadBanList()
		end
	end
end)

RegisterNetEvent("Foxey:reloadbanlist")
AddEventHandler("Foxey:reloadbanlist", function()
	loadBanList()
end)

RegisterServerEvent('Foxey:Automatic-ban')
AddEventHandler('Foxey:Automatic-ban', function(reason,servertarget,securityToken)
		local license,identifier,liveid,xblid,discord,playerip,target
		local duree     = 0
		local reason    = reason

		if not reason then reason = "Foxey AC" end

		if tostring(source) == "" then
			target = tonumber(servertarget)
		else
			target = source
		end

		if not IsPlayerAceAllowed(target, "Foxey.AC") then
			if target and target > 0 then
				local ping = GetPlayerPing(target)

				if ping and ping > 0 then
					if duree and duree < 365 then
						local sourceplayername = "Foxey-AC"
						local targetplayername = GetPlayerName(target)

						for k,v in ipairs(GetPlayerIdentifiers(target))do
							if string.sub(v, 1, string.len("license:")) == "license:" then
								license = v
							elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
								identifier = v
							elseif string.sub(v, 1, string.len("live:")) == "live:" then
								liveid = v
							elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
								xblid  = v
							elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
								discord = v
							elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
								playerip = v
							end
						end

						if duree > 0 then
							ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,0) --Timed ban here
							PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, content = targetplayername .. "**Banned** \nReason: ".. reason, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
							DropPlayer(target, "Foxey baned you for" .. reason)
						else
							ban(target,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,1) --Perm ban here
							PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, content = targetplayername .. " **Banned** \nReason: ".. reason, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
							DropPlayer(target, "Foxey baned you for" .. reason)
						end
					else
						print("BanSql Error : Foxey time invalid.")
					end
				else
					print("BanSql Error : Foxey target are not online.")
				end
			else
				print("BanSql Error : Foxey have recive invalid id.")
			end
		
		loadBanList()
	end
end)

-- Player join check
AddEventHandler('playerConnecting', function(playerName,setKickReason)
	local license,steamID,liveid,xblid,discord,playerip  = "n/a","n/a","n/a","n/a","n/a","n/a"

	for k,v in ipairs(GetPlayerIdentifiers(source))do
		if string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamID = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xblid  = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			playerip = v
		end
	end

	--Si Banlist pas chargée
	if (Banlist == {}) then
		Citizen.Wait(1000)
	end

	for i = 1, #BanList, 1 do
		if
			((tostring(BanList[i].license)) == tostring(license)
			or (tostring(BanList[i].identifier)) == tostring(steamID)
			or (tostring(BanList[i].liveid)) == tostring(liveid)
			or (tostring(BanList[i].xblid)) == tostring(xblid)
			or (tostring(BanList[i].discord)) == tostring(discord)
			or (tostring(BanList[i].playerip)) == tostring(playerip))
		then
			if (tonumber(BanList[i].permanent)) == 1 then
				setKickReason("\n\n 🛑🛑 BANNED BY Foxey ANTICHEAT 🛑🛑 \n\n ⚠️ Reason: " .. BanList[i].reason .. " \n\n ❌ XNA DEVELOPMENT ❌")
				CancelEvent()
				break
			end
		end
	end
end)

-- Ban Fuction
function ban(source,license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,duree,reason,permanent)
--calcul total expiration (en secondes)
	local expiration = duree * 86400
	local timeat     = os.time()
	local added      = os.date()

	if expiration < os.time() then
		expiration = os.time()+expiration
	end

	table.insert(BanList, {
		license    = license,
		identifier = identifier,
		liveid     = liveid,
		xblid      = xblid,
		discord    = discord,
		playerip   = playerip,
		reason     = reason,
		expiration = expiration,
		permanent  = permanent
	})

	MySQL.Async.execute('INSERT INTO Foxey_AntiCheat (license,identifier,liveid,xblid,discord,playerip,targetplayername,sourceplayername,reason,expiration,timeat,permanent) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@targetplayername,@sourceplayername,@reason,@expiration,@timeat,@permanent)', {
		['@license']          = license,
		['@identifier']       = identifier,
		['@liveid']           = liveid,
		['@xblid']            = xblid,
		['@discord']          = discord,
		['@playerip']         = playerip,
		['@targetplayername'] = targetplayername,
		['@sourceplayername'] = sourceplayername,
		['@reason']           = reason,
		['@expiration']       = expiration,
		['@timeat']           = timeat,
		['@permanent']        = permanent,
	}, function()
	end)

	BanListHistoryLoad = false
end

-- Banlist fuction

function loadBanList()
	MySQL.Async.fetchAll('SELECT * FROM Foxey_AntiCheat', {}, function(data)
		BanList = {}

		for i=1, #data, 1 do
			table.insert(BanList, {
				license    = data[i].license,
				identifier = data[i].identifier,
				liveid     = data[i].liveid,
				xblid      = data[i].xblid,
				discord    = data[i].discord,
				playerip   = data[i].playerip,
				reason     = data[i].reason,
				expiration = data[i].expiration,
				permanent  = data[i].permanent
			})
		end
	end)
end


RegisterServerEvent('FoxeyACM:kickPlayer')
AddEventHandler('FoxeyACM:kickPlayer', function(reason,servertarget)
	DropPlayer(servertarget, "You Are Kicked by a admin \nReason: " .. reason .. " \n\n ❌ XNA DEVELOPMENT ❌ \n Foxey AC")
end)