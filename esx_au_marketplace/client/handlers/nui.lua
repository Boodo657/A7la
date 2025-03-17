RegisterNuiCallback('close', function(data, cb)
    TriggerEvent('au_filters:Reset')
    SetNuiFocus(false, false)
end)

local waitingServer = false

RegisterNuiCallback('addItem', function(data, cb)
    -- SendNUIMessage({ type = 'ShowNotification', notification = 'تم الغاء التريد سنتر | لا يمكنك الاضافة' })
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local Mcoords = vector3(-1570.9833984375, -482.55883789063, 35.613371276855)
    local dst = #(coords - Mcoords)
    if dst > 5 then
        SendNUIMessage({ type = 'ShowNotification', notification = 'اذهب لمركز تداول البضائع للقدرة علي عرض المنتج' })
        return cb(false)
    end
    SendNUIMessage({ type = 'CloseUI' })
    if not waitingServer then
        waitingServer = true
        ESX.TriggerServerCallback('esx_au_marketplace:addItem', function(result, reason)
            waitingServer = false
            cb(result)
            if reason then ESX.ShowNotification(true, reason) end
        end, LastMarket, data)
    end
end)

RegisterNuiCallback('unlistProduct', function(data, cb)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local Mcoords = vector3(-1570.9833984375, -482.55883789063, 35.613371276855)
    local dst = #(coords - Mcoords)
    if dst > 5 then
        SendNUIMessage({ type = 'ShowNotification', notification = 'اذهب لمركز تداول البضائع للقدرة علي سحب المنتج' })
        return cb(false)
    end
    SendNUIMessage({ type = 'CloseUI' })
    if not waitingServer then
        waitingServer = true
        ESX.TriggerServerCallback('esx_au_marketplace:unlistProduct', function(result)
            waitingServer = false
            cb(result)
        end, LastMarket, data.product)
    end
end)

RegisterNuiCallback('editItem', function(data, cb)
    if not waitingServer then
        waitingServer = true
        print(ESX.DumpTable(data))
        ESX.TriggerServerCallback('esx_au_marketplace:editItem', function(result)
            waitingServer = false
            cb(result)
        end, LastMarket, data)
    end
end)

RegisterNuiCallback('buyItem', function(data, cb)
    -- SendNUIMessage({ type = 'ShowNotification', notification = 'تم الغاء التريد سنتر | لا يمكنك الشراء' })
    if data.count > 0 then
        if not waitingServer then
            waitingServer = true
            Citizen.CreateThread(function()
                local cooldown = math.random(10,2000)
                Citizen.Wait(cooldown)
                ESX.TriggerServerCallback('esx_au_marketplace:buyItem', function(result, reason)
                    waitingServer = false
                    cb(result)
                    if reason then ESX.ShowNotification(true, reason) end
                end, LastMarket, data.count, data.item, ClosestMarket.Type == 'blackmarket')
            end)
            
        end
    else
        ESX.ShowNotification(true, "عدد غير صحيح")
    end
end)

RegisterNuiCallback('getPlayerStats', function(data, cb)
    ESX.TriggerServerCallback('esx_au_marketplace:getPlayerStats', function(stats)
        cb(stats)
    end)
end)

RegisterNuiCallback('buyAdvertisement', function(data, cb)
    ESX.TriggerServerCallback('esx_au_marketplace:buyAdvertisement', function(result, reason)
        cb(result)
        if reason then ESX.ShowNotification(true, reason) end
    end, LastMarket, data)
end)

RegisterNuiCallback('unlistAuctionProduct', function(data, cb)
    if not waitingServer then
        waitingServer = true
        ESX.TriggerServerCallback('esx_au_marketplace:unlistAuctionProduct', function(result)
            waitingServer = false
            cb(result)
        end, LastMarket, data.product)
    end
end)

RegisterNuiCallback('placeOffer', function(data, cb)
    if not waitingServer then
        waitingServer = true
        ESX.TriggerServerCallback('esx_au_marketplace:placeOffer', function(result, reason)
            waitingServer = false
            cb(result)
            if reason then ESX.ShowNotification(true, reason) end
        end, LastMarket, data)
    end
end)

RegisterNuiCallback('notify', function(data, cb)
    ESX.ShowNotification(true, data.text)
    cb(true)
end)

RegisterNuiCallback('callItem', function(data, cb)
    SendNUIMessage({ type = 'CloseUI' })
    ESX.TriggerServerCallback('esx_au_marketplace:callItem', function(phoneNumber)
        if phoneNumber then
            --TriggerServerEvent('gcPhone:startCall', phoneNumber)
            exports["lb-phone"]:CreateCall({ number = phoneNumber })
        end
        cb(result)
    end, data.itemInfo)
    cb(true)
end)

