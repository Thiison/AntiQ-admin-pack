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

local PID           			= 0
local GUI           			= {}
ESX 			    			= nil
GUI.Time            			= 0
local PlayerData                = {}
local IsInAdminMode = false
local CanShow = false
local ServerAdminMode = false
local LastAdminMode = false
local isGodMode = true
local LastUserGroup 
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
  TriggerServerEvent('esx_adminmode:OnAdminLoad')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	print('Nível de admin: ' .. g)
	group = g
end)	

local model = "s_m_m_chemsec_01"
RegisterCommand('duty', function(source, args, rawCommand)

    ESX.TriggerServerCallback('esx_adminmode:GetGroup', function(UserGroup)
    LastUserGroup = UserGroup
    
    if LastUserGroup ~= 'user' then
        if not IsInAdminMode then
            IsInAdminMode = true
            AdminInMode = true
            SetGodMode(IsInAdminMode)
            --exports['mythic_notify']:DoHudText('success', 'You have entered STAFF mode!')
            local Name = GetPlayerName(source)
            TriggerEvent('esx_adminmode:AdminMode',IsInAdminMode)
            CheckAdminsOnline(AdminInMode)
            TriggerServerEvent('esx_adminmode:EnterStaffModeMSG',IsInAdminMode)
            TriggerServerEvent('esx_adminmode:StaffModeLogs', Name, IsInAdminMode)

            RequestModel(model)
            while not HasModelLoaded(model) do
                Citizen.Wait(20)
            end
            SetPlayerModel(PlayerId(), model)
            SetModelAsNoLongerNeeded(model)
        else
            IsInAdminMode = false
            AdminInMode = false
            SetGodMode(IsInAdminMode)
            --exports['mythic_notify']:DoHudText('error', 'You left STAFF mode!')
            TriggerEvent('esx_adminmode:AdminMode',IsInAdminMode)
            local Name = GetPlayerName(source)
            CheckAdminsOnline(AdminInMode)
            TriggerServerEvent('esx_adminmode:EnterStaffModeMSG',IsInAdminMode)

            TriggerServerEvent('esx_adminmode:StaffModeLogs', Name, IsInAdminMode)

            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                if skin.sex == 0 then
                    RequestModel("mp_m_freemode_01")
                    while not HasModelLoaded("mp_m_freemode_01") do
                        Citizen.Wait(0)
                    end 
                    SetPlayerModel(PlayerId(), "mp_m_freemode_01")
                    SetModelAsNoLongerNeeded("mp_m_freemode_01")

                    TriggerEvent('skinchanger:loadSkin', skin)
                else
                    RequestModel("mp_f_freemode_01")
                    while not HasModelLoaded("mp_f_freemode_01") do
                        Citizen.Wait(0)
                    end 
                    SetPlayerModel(PlayerId(), "mp_f_freemode_01")
                    SetModelAsNoLongerNeeded("mp_f_freemode_01")

                    TriggerEvent('skinchanger:loadSkin', skin)
                end
            end)

        end
    else
        exports['mythic_notify']:DoHudText('error', 'You have not enough permission!')
    end
end)
end)


function SetGodMode(isGodMode)
    if IsInAdminMode then
            exports['mythic_notify']:DoHudText('success', 'You have entered duty!')
            SetEntityInvincible(GetPlayerPed(-1), true)
            SetPlayerInvincible(PlayerId(), true)
            SetPedCanRagdoll(GetPlayerPed(-1), false)
            ClearPedBloodDamage(GetPlayerPed(-1))
            ResetPedVisibleDamage(GetPlayerPed(-1))
            ClearPedLastWeaponDamage(GetPlayerPed(-1))
            SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
            SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
            SetEntityCanBeDamaged(GetPlayerPed(-1), false)
    else
            exports['mythic_notify']:DoHudText('error', 'You have left duty!')
            SetEntityInvincible(GetPlayerPed(-1), false)
			SetPlayerInvincible(PlayerId(), false)
			SetPedCanRagdoll(GetPlayerPed(-1), true)
			ClearPedLastWeaponDamage(GetPlayerPed(-1))
			SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
			SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
            SetEntityCanBeDamaged(GetPlayerPed(-1), true)
    end
end

RegisterNetEvent('esx_adminmode:AdminMode')
AddEventHandler('esx_adminmode:AdminMode', function(IsInAdminMode)

    if IsInAdminMode then
    CanShow = true
    else
    CanShow = false
    end
end)

--ADMIN FUNCTIONS 
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(1)
            if CanShow then
                local coordsMe = GetEntityCoords(GetPlayerPed(Ped), false)
                local coords = GetEntityCoords(PlayerPedId(), false)
                local Ped = GetPlayerPed(-1)
                local x, y, z = table.unpack(GetEntityCoords(Ped))
                local Health = GetEntityHealth(Ped)
                local Armor = GetPedArmour(Ped)
                roundx = tonumber(string.format("%.2f", x))
                roundy = tonumber(string.format("%.2f", y))
                roundz = tonumber(string.format("%.2f", z))
                local h = GetEntityHeading(Ped)
                roundh =  tonumber(string.format("%.2f", h))
                --DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']," Pozíció | ~g~X: "..roundx.. "~s~ | ~o~ Y: "..roundy.." ~s~ | ~b~ Z: ".. roundz.." ~s~| ~p~h: ".. roundh.. " ~s~|")
                --DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']-0.15," ❤️ ~r~Élet | "..Health)
                --DrawText3D(coordsMe['x'], coordsMe['y'], coordsMe['z']-0.295," 🛡️ ~b~Armor | "..Armor)
            else
                CanShow = false
                Citizen.Wait(1000)
            end
    end
end)

function CheckAdminsOnline(AdminInMode)

    if AdminInMode then
    ServerAdminMode = true
    else
    ServerAdminMode = false
    end
    TriggerServerEvent('esx_adminmode:AdminsInMode', ServerAdminMode)
end

--TELEPORT

RegisterCommand("AdminTP", function(source)
    ESX.TriggerServerCallback('esx_adminmode:GetGroup', function(UserGroup)
        LastUserGroup = UserGroup
        TriggerEvent('esx_adminmode:AdminMode',IsInAdminMode)
        if LastUserGroup ~= 'user'then
            if IsInAdminMode then
                local WaypointHandle = GetFirstBlipInfoId(8)
                if DoesBlipExist(WaypointHandle) then
                    for height = 1, 1000 do
                        local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords, height + 0.0)
                    end
                    exports['mythic_notify']:DoHudText('inform', 'Teleported!')  
                else
                    exports['mythic_notify']:DoHudText('inform', 'Please Set a Waypoint!')
                end
            else
                exports['mythic_notify']:DoHudText('error', 'You must be in STAFF mode to teleport!')        
            end
    else
        exports['mythic_notify']:DoHudText('error', 'You must be STAFF to teleport!')
        end
    end)
end)



function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
    SetTextScale(0.40, 0.40)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextOutline()
    AddTextComponentString(text)
    DrawText(_x,_y)
    end
end

