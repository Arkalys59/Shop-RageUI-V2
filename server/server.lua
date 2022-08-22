
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('shop:buyItem')
AddEventHandler('shop:buyItem', function(info, label, name, price)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if info == 'cb' then
        local playerBank = xPlayer.getAccount('bank').money
        if playerBank >= price then
            xPlayer.addInventoryItem(name, 1)
            xPlayer.removeAccountMoney('bank', price)
            TriggerClientEvent('esx:showNotification', _src, "Vous avez acheté x1 "..label.." avec ~g~succès !")
        else
            TriggerClientEvent('esx:showNotification', _src, "Vous n'avez pas assez d'argent en banque !")
        end
    elseif info == 'liquide' then
        local playerMoney = xPlayer.getMoney() --xPlayer.getAccount('money').money
        if playerMoney >= price then
            xPlayer.addInventoryItem(name, 1)
            xPlayer.removeAccountMoney('money', price)
            TriggerClientEvent('esx:showNotification', _src, "Vous avez acheté x1 "..label.." avec ~g~succès !")
        else
            TriggerClientEvent('esx:showNotification', _src, "Vous n'avez pas assez d'argent en liquide !")
        end
    end
end)