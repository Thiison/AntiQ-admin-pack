--==--==--==--
-- Config
--==--==--==--

config = {
    controls = {
        -- [[Controls, list can be found here : https://docs.fivem.net/game-references/controls/]]
        openKey = 166, -- [[F11]]
		adminmenukey = 166, -- [[F11]]
        goUp = 85, -- [[Q]]
        goDown = 48, -- [[Z]]
        turnLeft = 34, -- [[A]]
        turnRight = 35, -- [[D]]
        goForward = 32,  -- [[W]]
        goBackward = 33, -- [[S]]
        changeSpeed = 21, -- [[L-Shift]]
    },

    speeds = {
        -- [[If you wish to change the speeds or labels there are associated with then here is the place.]]
        { label = "Very Slow", speed = 0},
        { label = "Slow", speed = 0.5},
        { label = "Normal", speed = 2},
        { label = "Fast", speed = 4},
        { label = "Very Fast", speed = 6},
        { label = "Extrem Fast", speed = 10},
        { label = "Super Fast", speed = 20},
        { label = "Maximum Speed", speed = 25}
    },

    offsets = {
        y = 0.5, -- [[How much distance you move forward and backward while the respective button is pressed]]
        z = 0.2, -- [[How much distance you move upward and downward while the respective button is pressed]]
        h = 3, -- [[How much you rotate. ]]
    },

    -- [[Background colour of the buttons. (It may be the standard black on first opening, just re-opening.)]]
    bgR = 0, -- [[Red]]
    bgG = 0, -- [[Green]]
    bgB = 0, -- [[Blue]]
    bgA = 80, -- [[Alpha]]
}

--==--==--==--
-- End Of Config
--==--==--==--

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while not ESX.GetPlayerData().job do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

noclipActive = false -- [[Wouldn't touch this.]]

index = 1 -- [[Used to determine the index of the speeds table.]]

Citizen.CreateThread(function()

    buttons = setupScaleform("instructional_buttons")

    currentSpeed = config.speeds[index].speed

    while true do
        Citizen.Wait(1)

        if IsControlJustPressed(1, config.controls.openKey) then
            noclipActive = false

            if IsPedInAnyVehicle(PlayerPedId(), false) then
                noclipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
            else
                noclipEntity = PlayerPedId()
            end

            SetEntityCollision(noclipEntity, not noclipActive, not noclipActive)
            FreezeEntityPosition(noclipEntity, noclipActive)
            SetEntityInvincible(noclipEntity, noclipActive)
            SetVehicleRadioEnabled(noclipEntity, not noclipActive) -- [[Stop radio from appearing when going upwards.]]
        end

        if noclipActive then
            DrawScaleformMovieFullscreen(buttons)

            local yoff = 0.0
            local zoff = 0.0

            if IsControlJustPressed(1, config.controls.changeSpeed) then
                if index ~= 8 then
                    index = index+1
                    currentSpeed = config.speeds[index].speed
                else
                    currentSpeed = config.speeds[1].speed
                    index = 1
                end
                setupScaleform("instructional_buttons")
            end

			if IsControlPressed(0, config.controls.goForward) then
                yoff = config.offsets.y
			end
			
            if IsControlPressed(0, config.controls.goBackward) then
                yoff = -config.offsets.y
			end
			
            if IsControlPressed(0, config.controls.turnLeft) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)+config.offsets.h)
			end
			
            if IsControlPressed(0, config.controls.turnRight) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)-config.offsets.h)
			end
			
            if IsControlPressed(0, config.controls.goUp) then
                zoff = config.offsets.z
			end
			
            if IsControlPressed(0, config.controls.goDown) then
                zoff = -config.offsets.z
			end
			
            local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
            local heading = GetEntityHeading(noclipEntity)
            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
            SetEntityHeading(noclipEntity, heading)
            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
        end
    end
end)

function noclipenable(noclipActive)
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                noclipEntity = GetVehiclePedIsIn(PlayerPedId(), false)
            else
                noclipEntity = PlayerPedId()
            end

            SetEntityCollision(noclipEntity, not noclipActive, not noclipActive)
            FreezeEntityPosition(noclipEntity, noclipActive)
            SetEntityInvincible(noclipEntity, noclipActive)
            SetVehicleRadioEnabled(noclipEntity, not noclipActive) -- [[Stop radio from appearing when going upwards.]]
        end

        if noclipActive then
            DrawScaleformMovieFullscreen(buttons)

            local yoff = 0.0
            local zoff = 0.0

            if IsControlJustPressed(1, config.controls.changeSpeed) then
                if index ~= 8 then
                    index = index+1
                    currentSpeed = config.speeds[index].speed
                else
                    currentSpeed = config.speeds[1].speed
                    index = 1
                end
                setupScaleform("instructional_buttons")
            end

			if IsControlPressed(0, config.controls.goForward) then
                yoff = config.offsets.y
			end
			
            if IsControlPressed(0, config.controls.goBackward) then
                yoff = -config.offsets.y
			end
			
            if IsControlPressed(0, config.controls.turnLeft) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)+config.offsets.h)
			end
			
            if IsControlPressed(0, config.controls.turnRight) then
                SetEntityHeading(noclipEntity, GetEntityHeading(noclipEntity)-config.offsets.h)
			end
			
            if IsControlPressed(0, config.controls.goUp) then
                zoff = config.offsets.z
			end
			
            if IsControlPressed(0, config.controls.goDown) then
                zoff = -config.offsets.z
			end
			
            local newPos = GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))
            local heading = GetEntityHeading(noclipEntity)
            SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
            SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
            SetEntityHeading(noclipEntity, heading)
            SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, noclipActive, noclipActive, noclipActive)
end

Citizen.CreateThread(function()

    buttons = setupScaleform("instructional_buttons")

    currentSpeed = config.speeds[index].speed

    while true do
        Citizen.Wait(1)

        if IsControlJustPressed(1, config.controls.adminmenukey) then
			TriggerServerEvent('asdasd_getgroup')		
		end
    end
end)

function getPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        table.insert(players, {id = GetPlayerServerId(player), name = GetPlayerName(player)})
    end
    return players
end

RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false)
end)

RegisterNUICallback('quick', function(data, cb)
	if data.type == "slay_all" or data.type == "bring_all" or data.type == "slap_all" then
		TriggerServerEvent('es_admin:all', data.type)
	else
		TriggerServerEvent('es_admin:quick', data.id, data.type)
	end
end)

RegisterNUICallback('set', function(data, cb)
	TriggerServerEvent('es_admin:set', data.type, data.user, data.param)
end)

RegisterNetEvent('asdasd_openmenu')
AddEventHandler('asdasd_openmenu', function()

ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'adminmenu', -- Replace the menu name
  {
    title    = ('Admin Menu'),
    align = 'center', -- Menu position
	
    elements = { -- Contains menu elements
      {label = ('Vehicle Interaction'),     value = 'superadminmenu'},	  
      {label = ('Turn on Noclip'),     value = 'noclip'},
      {label = ('Invisibility On/Off'),      value = 'lathatatlansag'},	  
      {label = ('Start Communityservice'),      value = 'kozmunka'},
      {label = ('End Communityservice'),      value = 'kozmunkakiv'},	  
      {label = ('Clear chat'),      value = 'chattorles'}
    }
  },
      
  function(data, menu) -- This part contains the code that executes when you press enter
    if data.current.value == 'superadminmenu' then
		TriggerEvent('asdasd_superadminmenu')

    elseif data.current.value == 'noclip' then
		noclipActive = true
		noclipenable(noclipActive)
		menu.close()
		ESX.ShowNotification('~g~Admin Menu~s~: Noclip Bekapcsolva!')
	elseif data.current.value == 'tpmarker' then
		TriggerEvent("esx_admin:tpm")
		menu.close()
	elseif data.current.value == 'kozmunka' then
		menu.close()	
		jatekosid(data.current.value)
	elseif data.current.value == 'kozmunkakiv' then
		menu.close()	
		jatekosid(data.current.value)	
	elseif data.current.value == 'chattorles' then
		TriggerServerEvent('chat:torles')
		ESX.ShowNotification('~g~Admin Menu~s~: Chat cleared')
	elseif data.current.value == 'lathatatlansag' then
	local ped = PlayerPedId()
		invisible = not invisible
		if invisible then
		SetEntityVisible(ped, false)
		ESX.ShowNotification('~g~Admin Menu~s~: Invisibility ON!')
		
		else
		SetEntityVisible(ped, true)
		ESX.ShowNotification('~g~Admin Menu~s~: Invisibility OFF!')

		end
      -- Here the action when field 1 is selected
    end   
  end,
  function(data, menu) -- This part contains the code  that executes when the return key is pressed.
      menu.close() -- Close the menu
  end
)

end)

RegisterNetEvent('asdasd_superadminmenu')
AddEventHandler('asdasd_superadminmenu', function()

ESX.UI.Menu.Open( 'default', GetCurrentResourceName(), 'superadminmenu', -- Replace the menu name
  {
    title    = ('Admin Menu'),
    align = 'top-left', -- Menu position
	
    elements = { -- Contains menu elements
      {label = ('Fix Vehicle'),      value = 'fixcar'},
      {label = ('Burst Tyre'),      value = 'tyreburst'},
      {label = ('Set fuel to 0'),      value = 'nofuel'},
      {label = ('Get Vehicle Hash'),      value = 'gethash'}

	  }
  },
      
  function(data, menu) -- This part contains the code that executes when you press enter
	if data.current.value == 'fixcar' then
		local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, 1000)
		SetVehicleEngineOn( vehicle, true, true )
		SetVehicleFixed(vehicle)
		SetVehicleFuelLevel(vehicle, 100.0)		
		SetVehicleDirtLevel(vehicle, 0)
		ESX.ShowNotification("~g~Admin Menu~s~: Vehicle fixed!")
	else
		ESX.ShowNotification("~g~Admin Menu~s~: You have to sit in a vehicle!")
	end	
	elseif data.current.value == 'gethash' then
		local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehiclehash = GetHashKey(vehicle)
		ESX.ShowNotification("~g~Vehicle Hash~s~: " ..vehiclehash)
	else
		ESX.ShowNotification("~g~Admin Menu~s~: You have to sit in a vehicle!")
	end		
	elseif data.current.value == 'bomcar' then
		local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleEngineHealth(vehicle, -1)
		SetVehicleEngineOn( vehicle, false, false )				
		ESX.ShowNotification("~g~Admin Menu~s~: Vehicle engine destroyed!")
	else
		ESX.ShowNotification("~g~Admin Menu~s~: You have to sit in a vehicle!")
	end
	elseif data.current.value == 'nofuel' then
		local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local playerPed = GetPlayerPed(-1)
		SetVehicleFuelLevel(vehicle, 0)
		ESX.ShowNotification("~g~Admin Menu~s~: Fuel set to 0!")
	else
		ESX.ShowNotification("~g~Admin Menu~s~: You have to sit in a vehicle!")
	end		
	elseif data.current.value == 'tyreburst' then
		local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		SetVehicleTyreBurst(vehicle, 0, true, 1000.0)
		SetVehicleTyreBurst(vehicle, 1, true, 1000.0)
		SetVehicleTyreBurst(vehicle, 2, true, 1000.0)
		SetVehicleTyreBurst(vehicle, 3, true, 1000.0)
		SetVehicleTyreBurst(vehicle, 4, true, 1000.0)
		SetVehicleTyreBurst(vehicle, 5, true, 1000.0)
		SetVehicleTyreBurst(vehicle, 6, true, 1000.0)
		ESX.ShowNotification("~g~Admin Menu~s~: Vehicle tyres bursted!")
	else
		ESX.ShowNotification("~g~Admin Menu~s~: You have to sit in a vehicle!")
	end	
	elseif data.current.value == 'durrogas' then
		durrogas = not durrogas
		
	local playerPed = GetPlayerPed(-1)
	if IsPedInAnyVehicle(playerPed, false) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
			if durrogas then
			ESX.ShowNotification("~g~ASD.ASD Admin~s~: Jármü durrogás ~g~bekapcsolva!")
			EnableVehicleExhaustPops(vehicle, true)
			else
			EnableVehicleExhaustPops(vehicle, false)			
			ESX.ShowNotification("~g~ASD.ASD Admin~s~: Jármü durrogás ~r~kikapcsolva!")
		end
	else
		ESX.ShowNotification("~g~Admin Menu~s~: You have to sit in a vehicle!")
	end		
    end   
  end,
  function(data, menu) -- This part contains the code  that executes when the return key is pressed.
      menu.close() -- Close the menu
  end
)

end)

function jatekosid(ertek)
ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'jatekosid',
  {
    title = ('Enter player ID!')
  },
  function(data, menu)
    local amount = tonumber(data.value)
	if amount == nil then
      ESX.ShowNotification('Invalid ID!')
    else
      menu.close()
      if ertek == 'kozmunka' then
		kozmunka(amount)
	  elseif ertek == 'kozmunkakiv' then
		TriggerServerEvent('esx_communityservice:endCommunityServiceCommand', amount)
		ESX.ShowNotification("~g~You have ended the community service of this player: ~b~"..amount.." ID")
	  end
    end
  end,
  function(data, menu)
    menu.close()
  end)

end

function kozmunka(jatekosid)
ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'kozegyseg',
  {
    title = ('Enter the quantity of the community service!')
  },
  function(data, menu)
    local amount = tonumber(data.value)
	if amount == nil then
      ESX.ShowNotification('Invalid quantity!')
    else
      menu.close()
		TriggerServerEvent('esx_communityservice:sendToCommunityService', GetPlayerServerId(PlayerId()) ,jatekosid, amount)
    end
  end,
  function(data, menu)
    menu.close()
  end)
end

--==--==--==--
-- End Of Script
--==--==--==--