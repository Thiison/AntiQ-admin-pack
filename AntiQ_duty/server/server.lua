ESX 						   = nil
local SuperAdminsConnected       	   = 0
local ModeratorsConnected       	   = 0
local FinalAdminMode = false
local SecondFinalAdminMode = false
local UserGroup 
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_adminmode:AdminsInMode')
AddEventHandler('esx_adminmode:AdminsInMode', function(FinalAdminMode)
local _source = source
SecondFinalAdminMode = FinalAdminMode
end)



ESX.RegisterServerCallback('esx_adminmode:GetGroup', function(source, cb , UserGroup)
    local xPlayer = ESX.GetPlayerFromId(source)
    UserGroup = xPlayer.getGroup()

    cb(UserGroup)
end)

RegisterServerEvent('esx_adminmode:OnAdminLoad')
AddEventHandler('esx_adminmode:OnAdminLoad', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local Group = xPlayer.getGroup()
	local Name = xPlayer.getName()
	if Group ~= 'User' then
		--print('^8STAFF^0 '..Name..' Has ^2joined^0 the server. He was placed in ^2Player^0 Mode!')
	end
end)

RegisterServerEvent('esx_adminmode:EnterStaffModeMSG')
AddEventHandler('esx_adminmode:EnterStaffModeMSG', function(IsInAdminMode)
	local xPlayer = ESX.GetPlayerFromId(source)
	local Name = xPlayer.getName()
	local AdminNameMode = IsInAdminMode
	if AdminNameMode then
	--TriggerClientEvent('chat:addMessage', -1, { args = { '^4INFO:^0 '..Name..' Has entered ^1STAFF^0 mode! 🛡️'} })
   TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(43, 42, 39, 1); border-radius: 3px;"><i class="fab fa-autoprefixer"style=" font color="black"> ^1An admin ^7has entered duty!</font></b></div>',
        args = { fal, msg, id }
	})
	else
	--TriggerClientEvent('chat:addMessage', -1, { args = { '^4INFO:^0 '..Name..' Has entered ^2PLAYER^0 mode! 🚶'} })
    TriggerClientEvent('chat:addMessage', -1, {
        template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(43, 42, 39, 1); border-radius: 3px;"><i class="fab fa-autoprefixer"style=" font color="black"> ^1An admin ^7has left duty!</font></b></div>',
        args = { fal, msg, id }
	})
	end
end)


RegisterServerEvent('esx_adminmode:StaffModeLogs')
AddEventHandler('esx_adminmode:StaffModeLogs',function(Name, IsInAdminMode)
	local AdminName = Name
	local WhatModeAdminIs = IsInAdminMode
	local date = os.date("%d-%m-%y")
	local time = os.date("%X")
	local xPlayer = ESX.GetPlayerFromId(source)
	local Group = xPlayer.getGroup()
	local StringAdminMode = ''
	local MySQLQueryLOG
	if WhatModeAdminIs then
		StringAdminMode ='ADMIN'
	else
		StringAdminMode = 'Játékos'
	end
	MySQLQueryLOG = MySQL.Sync.execute("INSERT INTO staff_mode (staff, mode) VALUES (@AdminName,@StringAdminMode)", {['@AdminName'] = AdminName, ['@StringAdminMode'] = StringAdminMode})

	--print('^3ESX_ADMINMODE^0 - LOGS')
	--print('-------------------------------------------------')
	if WhatModeAdminIs then
		--print('^2'..AdminName..' ^0Has just Entered ^8STAFF^0 Mode!')
	else
		--print('^2'..AdminName..' ^0Has just Entered ^2Player^0 Mode!')
	end
	if MySQLQueryLOG then
	--print('This change was ^2Successfuly^0 stored in the ^4DataBase^0!\nChange was made on - ^8'..date.." ^0at^8 "..time..'!^0')
	else
	--print('^1ERROR: ^0This change was ^1NOT^0 stored in the ^4DataBase^0!\n^1ATTEMPT^0  was made on - ^8'..date.." ^0at^8 "..time..'!^0')
	end
	--print('^2'..AdminName..' ^0is a ^8'.. Group..'^0.')
	--print('-------------------------------------------------')
end)

RegisterCommand('dgdgygygydgfgdgyg', function(source, args, rawCommand)
	local xPlayers = ESX.GetPlayers()
	TriggerClientEvent('chat:addMessage', source, { args = { '^1^*|____________💂ADMINOK💂____________|'} })
    for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])   
		local name = xPlayer.getName()
		local Group = xPlayer.getGroup()
        if Group == 'superadmin' and SecondFinalAdminMode then
            	TriggerClientEvent('chat:addMessage', source, { args = { '^1^*[TULAJDONOS]^0 ^4^*' ..name.. '^0, ^1^*ADMINSZOLGÁLATBAN^0 van. 🛡️'} })
			elseif Group == 'admin' and SecondFinalAdminMode then
				TriggerClientEvent('chat:addMessage', source, { args = { '^5^*[ADMIN]^0 ^4^*' ..name.. '^0, ^1^*ADMINSZOLGÁLATBAN^0 van. 🛡️'} })
			elseif Group == 'superadmin' and not SecondFinalAdminMode then
				TriggerClientEvent('chat:addMessage', source, { args = { '^1^*[TULAJDONOS]^0 ^4^*' ..name.. '^0, ^2^*NINCS^0 adminszolgálatban. 🚶'} })
			elseif Group == 'admin' and not SecondFinalAdminMode then
				TriggerClientEvent('chat:addMessage', source, { args = { '^5^*[ADMIN]^0 ^4^*' ..name.. ', ^2^*NINCS^0 adminszolgálatban. 🚶'} })
        end
    end
end)

