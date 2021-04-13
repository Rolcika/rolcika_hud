ESX = nil
local lastJob = nil
local isAmmoboxShown = false

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
  Citizen.Wait(3000)
  if PlayerData == nil or PlayerData.job == nil then
	  	PlayerData = ESX.GetPlayerData()
	end
	SendNUIMessage({
		action = 'initGUI',
		data = { whiteMode = Config.enableWhiteBackgroundMode, enableAmmo = Config.enableAmmoBox, colorInvert = Config.disableIconColorInvert }
	})
end)

local dugamapa = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsControlPressed(1, 243) then
			SetRadarBigmapEnabled(false, false)
		end
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  SetRadarBigmapEnabled(false, false)
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function showAlert(message, time, color)
	SendNUIMessage({
		action = 'showAlert',
		message = message,
		time = time,
		color = color
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
	ESX.TriggerServerCallback('poggu_hud:retrieveData', function(data)
			SendNUIMessage({
				action = 'setMoney',
				cash = data.cash,
				bank = data.bank,
				black_money = data.black_money,
				society = data.society
			})
		end)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(9000)
		if(PlayerData ~= nil) then
			local jobName = PlayerData.job.label..' - '..PlayerData.job.grade_label
			if(lastJob ~= jobName) then
				lastJob = jobName
				SendNUIMessage({
					action = 'setJob',
					data = jobName
				})
			end
		end
	end
end)

Citizen.CreateThread(function()
 while true do
		Citizen.Wait(200)
		if Config.enableAmmoBox then
			local playerPed = GetPlayerPed(-1)
			local weapon, hash = GetCurrentPedWeapon(playerPed, 1)
			if(weapon) then
				isAmmoboxShown = true
				local _,ammoInClip = GetAmmoInClip(playerPed, hash)
				SendNUIMessage({
						action = 'setAmmo',
						data = ammoInClip..'/'.. GetAmmoInPedWeapon(playerPed, hash) - ammoInClip
				})
			else
				if isAmmoboxShown then
					isAmmoboxShown = false
					SendNUIMessage({
						action = 'hideAmmobox'
					})
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame(3) -- CASH
		HideHudComponentThisFrame(4) -- MP CASH
		HideHudComponentThisFrame(2) -- weapon icon
		HideHudComponentThisFrame(9) -- STREET NAME
		HideHudComponentThisFrame(7) -- Area NAME
		HideHudComponentThisFrame(8) -- Vehicle Class
		HideHudComponentThisFrame(6) -- Vehicle Name
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1, 311) then
			SendNUIMessage({
				action = 'showAdvanced'
			})
		end
	end
end)

--[[
	file: client.lua
	resource: esx_customui
	author: Mihailo

]]

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

local status = nil
local r,g,b,a = 30,136,229,255 -- สี R G B
local voice = {default = 7.0, shout = 20.0, whisper = 1.5, current = 0} -- ร ะ ย ะ ไ ม ค์

---------------------------------
--- ห ล อ ด ค ว า ม เ ห นื่ อ ย ---
---------------------------------
Citizen.CreateThread(function()
    while true do

        Citizen.Wait(100)
        
        SendNUIMessage({
            show = IsPauseMenuActive(),
            health = (GetEntityHealth(GetPlayerPed(-1))-100),
            stamina = 100-GetPlayerSprintStaminaRemaining(PlayerId()),
            st = status,
        })
    end
end)
------------
-- E N D ---
------------

-------------------------
--- ห ล อ ด อ า ห า ร ---
-------------------------
RegisterNetEvent('esx_customui:updateStatus')
AddEventHandler('esx_customui:updateStatus', function(Status)
    status = Status
    SendNUIMessage({
        action = "updateStatus",
        st = Status,
    })
end)
------------
-- E N D ---
------------

-----------------------
--- ห ล อ ด เ ลื อ ด ---
-----------------------
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(2500)
     local ped = GetPlayerPed(-1)
     local health = GetEntityHealth(ped)
     local armor = GetPedArmour(ped)
     SendNUIMessage({
        heal = health,
        armor = armor
     });
  end
end)
------------
-- E N D ---
------------

---------------------------------------
--- ทำ ง า น เ มื่ อ เ ซิ ฟ เ ว อ ร์ เ ริ่ ม ---
---------------------------------------
AddEventHandler('onClientMapStart', function()
  NetworkSetTalkerProximity(voice.default)
end)
------------
-- E N D ---
------------

----------------------------
--- ร ะ บ บ เ สี ย ง ห ลั ก ---
----------------------------
--[[Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    local coords = GetEntityCoords(PlayerPedId())
    if IsControlJustPressed(0, Keys['H']) and IsControlPressed(1, Keys['LEFTSHIFT']) then
      voice.current = (voice.current + 1) % 3
      if voice.current == 0 then
        NetworkSetTalkerProximity(voice.default)
        SendNUIMessage({voiceheal = 50});
      elseif voice.current == 1 then
        NetworkSetTalkerProximity(voice.shout)
        SendNUIMessage({voiceheal = 100});
      elseif voice.current == 2 then
        NetworkSetTalkerProximity(voice.whisper)
        SendNUIMessage({voiceheal = 25});
      end
    end
    if IsControlJustPressed(0, Keys['H']) and IsControlPressed(1, Keys['LEFTSHIFT']) then
      if voice.current == 0 then
        voiceS = voice.default
      elseif voice.current == 1 then
        voiceS = voice.shout
      elseif voice.current == 2 then
        voiceS = voice.whisper
      end
      Marker(1, coords.x, coords.y, coords.z, voiceS * 2.0)
    end
    if NetworkIsPlayerTalking(PlayerId()) then
      SendNUIMessage({talking = true})
    elseif not NetworkIsPlayerTalking(PlayerId()) then
      SendNUIMessage({talking = false})
    end
  end
end)]]
------------
-- E N D ---
------------

------------------
--- อ ย่ า แ ต ะ ---
------------------
function Marker(type, x, y, z, voiceS)
  DrawMarker(type, x, y, z - 1.7, 0.0, 0.0, 0.0, 0, 0.0, 0.0, voiceS, voiceS, 1.0, r, g, b, a, false, true, 2, false, false, false, false)
end
------------
-- E N D ---
------------