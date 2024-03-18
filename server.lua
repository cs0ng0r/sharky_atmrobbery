ESX = exports['es_extended']:getSharedObject()


RegisterServerEvent("sharky-atmrobbery:success")
AddEventHandler("sharky-atmrobbery:success", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = math.random(Config.MinMoney, Config.MaxMoney)

    xPlayer.addAccountMoney('black_money', money)
    TriggerClientEvent('ox_lib:notify', source, {
        title = 'ATM RABLÁS',
        description = 'SIKERES ATM RABLÁS! LOPOTT ÖSSZEG: $' .. money,
        type = 'success'
    })
end)
