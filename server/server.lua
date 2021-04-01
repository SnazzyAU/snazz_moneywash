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

RegisterServerEvent('snazz:washMoney')
AddEventHandler('snazz:washMoney', function(amount)
    print("Started trigger")
	local xPlayer = ESX.GetPlayerFromId(source)
	tax = Config.PercentageCut
    amount = ESX.Math.Round(tonumber(amount))
	washedCash = amount * tax
	washedTotal = ESX.Math.Round(tonumber(washedCash))
	
	if Config.EnableTimer == true then
		if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Waiting to wash money..."})
			Citizen.Wait(Config.MoneyWashTime)
			
			--TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You have recieved' .. ESX.Math.GroupDigits(washedTotal) .. 'clean money!', style = { ['background-color'] = '#ffffff', ['color'] = '#000000' } })
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "You have recieved " .. ESX.Math.GroupDigits(washedTotal) .. " clean money!"})
			xPlayer.addMoney(washedTotal)
		else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Not enough black money!", type = "error"})
			TriggerClientEvent('esx:showNotification', xPlayer.source, ('Not enough black money!'))
		end
	else 
	
		if amount > 0 and xPlayer.getAccount('black_money').money >= amount then
			xPlayer.removeAccountMoney('black_money', amount)
			TriggerClientEvent("pNotify:SendNotification", -1, {text = "You have washed " .. ESX.Math.GroupDigits(amount) .. " dirty money." .. "You have recieved" .. ESX.Math.GroupDigits(washedTotal) .. "clean money!"})
			xPlayer.addMoney(washedTotal)
		else
            TriggerClientEvent("pNotify:SendNotification", -1, {text = "Not enough black money!", type = "error"})
            TriggerClientEvent('esx:showNotification', xPlayer.source, ('Not enough black money!'))
		end
	end
	
end)