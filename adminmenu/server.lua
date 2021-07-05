ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('chat:torles')
AddEventHandler('chat:torles', function()
	TriggerClientEvent('chat:clear', -1)
end)

RegisterNetEvent('asdasd_getgroup')
AddEventHandler('asdasd_getgroup', function()
 local _source = source
 local xPlayer  = ESX.GetPlayerFromId(_source)
 local adminrank = xPlayer.getGroup()
	
if adminrank == 'superadmin' or adminrank == 'admin' then
	TriggerClientEvent('asdasd_openmenu', _source)
	else
	TriggerClientEvent('esx:showNotification', source, '~g~ASD.ASD Admin: ~s~~r~Nincs hozzá jogosultságod!')
end


end)