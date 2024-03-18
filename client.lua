ESX = exports['es_extended']:getSharedObject()

local robbed = false
local busy = false

CreateThread(function()
	while true do
		Wait(1)
		if not robbed and nearATM() and IsControlJustReleased(0, 23) then
			lib.progressBar({
				duration = 5000,
				label = 'ATM Feltörése',
				useWhileDead = false,
				disable = {
					move = true,
				},
			})
			TriggerEvent('sharky-atmrobbery:connecting')
			busy = true
			Wait(10000)
			busy = false
			lib.notify({
				title = 'ATM Rablás',
				description = 'Feltörés elindítva. Várj türelemmel!',
				type = 'success'
			})
			TriggerEvent("mhacking:show")
			TriggerEvent("mhacking:start", 7, 35, hackCallback)
		end
	end
end)

function hackCallback(success)
	if success then
		TriggerEvent('mhacking:hide')
		TriggerServerEvent("sharky-atmrobbery:success")
		robbed = true
		Wait(600000)
		robbed = false
	else
		TriggerEvent('mhacking:hide')
		lib.notify({
			title = 'ATM Rablás',
			description = 'Sikertelen feltörés! Próbáld újra később!',
			type = 'error'
		})
		robbed = true
		Wait(300000)
		robbed = false
	end
end

RegisterNetEvent('sharky-atmrobbery:connecting')
AddEventHandler('sharky-atmrobbery:connecting', function()
	RequestAnimDict("mini@repair")
	while (not HasAnimDictLoaded("mini@repair")) do
		Wait(0)
	end
	TaskPlayAnim(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 50, 0, false, false, false)
	Wait(10000)
	ClearPedTasks(GetPlayerPed(-1))
end)

function nearATM()
	local player = GetPlayerPed(-1)
	local playerloc = GetEntityCoords(player, 0)

	for _, search in pairs(Config.ATMs) do
		local distance = GetDistanceBetweenCoords(search.x, search.y, search.z, playerloc['x'], playerloc['y'],
			playerloc['z'], true)

		if distance <= 3 then
			DrawText3Ds(search.x, search.y, search.z + .5, 'ATM Feltörése (F)')
			return true
		end
	end
end

CreateThread(function()
	while true do
		Wait(10)
		while busy do
			Wait(0)
			DisableControlAction(0, 32, true)
			DisableControlAction(0, 34, true)
			DisableControlAction(0, 31, true)
			DisableControlAction(0, 30, true)
			DisableControlAction(0, 22, true)
			DisableControlAction(0, 44, true)
		end
	end
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x, y, z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end
