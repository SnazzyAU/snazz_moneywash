ESX = nil


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function secondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

function sendToDiscord(color, name, message, footer)
	local embed = {
		{
			["color"] = color,
			["title"] = "**".. name .."**",
			["description"] = message,
			["footer"] = {
				["text"] = footer,
			},
		}
	}
  
	PerformHttpRequest(Config.DiscordWebhook, function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('snazz:washMoney')
AddEventHandler('snazz:washMoney', function(amount)
	local playerName = GetPlayerName(source) 
	local xPlayer = ESX.GetPlayerFromId(source)
	tax = Config.PercentageCut
    amount = ESX.Math.Round(tonumber(amount))
	washedCash = amount * tax
	washedTotal = ESX.Math.Round(tonumber(washedCash))
	discordAmount = Config.AmountPerDelivery


	if Config.EnableTimer == true then
		if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)
            TriggerClientEvent("pNotify:SendNotification", source, {text = "Waiting to wash money..."})			
			
			if Config.Discord then
				sendToDiscord(65280, 'New Money Wash Detected','**Player Name:** ' .. playerName .. '\n' .. '**Player ID:** ' .. source .. '\n' .. '**Remaining Dirty Money:** $' .. xPlayer.getAccount('black_money').money .. '\n\n' .. 'Player has started to wash their money. The player spent $' .. discordAmount .. ' of dirty money and is getting $' .. washedTotal .. ' in clean back!',"")
			end
			
			Citizen.Wait(Config.MoneyWashTime)
		
            TriggerClientEvent("pNotify:SendNotification", source, {text = "You have recieved " .. ESX.Math.GroupDigits(washedTotal) .. " clean money!"})
			xPlayer.addMoney(washedTotal)
		else
            TriggerClientEvent("pNotify:SendNotification", source, {text = "Not enough black money!", type = "error"})
			TriggerClientEvent('esx:showNotification', xPlayer.source, ('Not enough black money!'))
		end
	else 
	
		if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)
			TriggerClientEvent("pNotify:SendNotification", source, {text = "You have washed " .. ESX.Math.GroupDigits(amount) .. " dirty money." .. "You have recieved" .. ESX.Math.GroupDigits(washedTotal) .. "clean money!"})
			xPlayer.addMoney(washedTotal)
		else
            TriggerClientEvent("pNotify:SendNotification", source, {text = "Not enough black money!", type = "error"})
            TriggerClientEvent('esx:showNotification', xPlayer.source, ('Not enough black money!'))
		end
	end
end)
