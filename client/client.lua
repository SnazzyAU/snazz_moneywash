local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

-- Variables
ESX = nil
src = source
local curRanPos

-- Grabs a random location from Config.MoneyWashLocations, then sorts it into X and Y so that it can set a GPS waypoint.
function RandomLocation()
    curRanPos = Config.MoneyWashLocations[math.random(1, #Config.MoneyWashLocations)]
    SetNewWaypoint(curRanPos)
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Sorts Config.WhitelistedJobs into each line and checks if the players job matches it. 
function Authorized()
	if ESX.PlayerData.job == nil then
		return false
	end
	
	for _,job in pairs(Config.WhitelistedJobs) do
		
		if job == ESX.PlayerData.job.name then
			return true
		end
	end
	
	return false
	
end

function DrawText3D(x,y,z, text) -- some useful function, use it if you want!
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.3,0.3)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

-- Grabs a random location from Config.MoneyWashLocations, then sorts it into X and Y so that it can set a GPS waypoint.
--function RandomLocation()
--    position = Config.MoneyWashLocations[math.random(1, #Config.MoneyWashLocations)]
--    SetNewWaypoint(position)
--end

Citizen.CreateThread(function()
    local isAuthorized = Authorized()
    while true do
        Wait(1)
        local isAuthorized = Authorized()
        local ped = PlayerPedId()
		local pPos = GetEntityCoords(ped)
        local dist = #(pPos-Config.StartLocation)
        if isAuthorized or Config.Whitelist == false then
            if dist < 3.0 then
                DrawText3D(Config.StartLocation.x, Config.StartLocation.y, Config.StartLocation.z, "Press [E] to wash your money!")

                if IsControlJustPressed(0,Keys["E"]) then
                    if Config.DebugMode then
			print("[DEBUG] E was pressed.")
		    end

                    RandomLocation()
                    
					while curRanPos == nil do 
						Wait(0) 
					end
                    
					if Config.DebugMode then
						print("[DEBUG] Before the while.")
					end
						
					while true do
						Wait(0)
						local ped = PlayerPedId()
						local pPos = GetEntityCoords(ped)
						
						local dist2 = #(pPos-curRanPos)

						if dist2 < 3.0 then
							DrawText3D(curRanPos.x,curRanPos.y,curRanPos.z, "Press [E] to deliver the package!")
							
							if Config.DebugMode then
								print("[DEBUG] Ater distance check.")
							end
									
							if IsControlJustPressed(0,Keys["E"]) then
								
								if Config.DebugMode then
									print("[DEBUG] Triggered server event.")
								end
									
								local ped = PlayerPedId()
								local pPos = GetEntityCoords(ped)
								local playerName = GetPlayerName(ped)
				
								TriggerServerEvent('snazz:washMoney', Config.AmountPerDelivery)
								break
							end
						end
					end
                end
            end
        end
    end
end)
