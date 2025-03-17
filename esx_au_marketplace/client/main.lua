ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(5)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(5)
	end

	ESX.PlayerData = ESX.GetPlayerData()

    
end)

local mymarket = nil

Citizen.CreateThread(function()
	Citizen.Wait(1000)
	fontId = exports.NanoBase:NanoFontID()
end)

ClosestMarket = {
    -- Name of the marketplace
    Name = 'AU Global Market',
    -- Define to 'normal' or 'blackmarket'
    Type = 'blackmarket',
    -- You can whitelist the market for specific jobs
    -- Set it to a table to add jobs to the whitelist, set it to false to disable it
    -- Here is an example of a whitelist with 2 jobs: JobCheck = { ['police'] = true, ['ambulance'] = true }
    -- Here is an example of a whitelist with 1 job: JobCheck = 'police'
    JobCheck = false,
    -- You can whitelist the possibility to sell products for specific jobs
    -- Set it to a table to add jobs to the whitelist, set it to false to disable it
    -- Here is an example of a whitelist with 2 jobs: SellerCheck = { ['police'] = true, ['ambulance'] = true }
    SellerCheck = false,
    -- The location of the marketplace (X, Y, Z)
    Location = vector3(28.96, -1018.68, 29.6),
    -- Blip settings
    Blip = {
        Sprite = 52,
        Color = 2,
        Scale = 1.0,
        Label = 'The Black Market'
    },
    Marker = {
        Type = 2,
        Rotation = { 0.0, 180.0, 0.0 },
        Scale = 0.4,
        Color = { R = 222, G = 186, B = 77, A = 255 },
        BobUpAndDown = true,
        FaceCamera = true,
        MarkerDistance = 5.0,
        TextDistance = 2.0 
    }
}
LastMarket = nil

Citizen.CreateThread(
    function()
        while true do
            if allowedUniverse[universeId] then 
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                local Mcoords = vector3(-1570.9833984375, -482.55883789063, 35.613371276855)
                local dst = #(coords - Mcoords)
                if dst < 15 and dst >  1.5 then
                    local text = "ﻊﺋﺎﻀﺒﻟﺍ ﻝﻭﺍﺪﺗ ﺰﻛﺮﻣ"
                    DrawText3D(Mcoords.x, Mcoords.y, Mcoords.z,  "~w~[~o~- ~b~ "..text.." ~o~-~w~]")
                    DrawMarker(27, Mcoords.x, Mcoords.y, Mcoords.z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0,  3.0, 1.0, 0,255,0, 155, false, true, 2, false, false, false, false)
                elseif dst < 3.5 then
                    local text = "ﺕﺎﺠﺘﻨﻤﻟﺍ ﺽﺮﻌﻟ"
                    DrawMarker(27, Mcoords.x, Mcoords.y, Mcoords.z - 1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 3.0,  3.0, 1.0, 0,255,0, 155, false, true, 2, false, false, false, false)
                    DrawText3D(Mcoords.x, Mcoords.y, Mcoords.z,  "~b~(~y~-~g~F4~y~-~b~) ~b~[~y~- ~y~ "..text.." ~y~-~b~]")
                end
                Citizen.Wait(3)
            else
                Citizen.Wait(5000)
            end
        end
    end
)

RegisterNetEvent('esx:playerLoaded', function()
	ESX.PlayerData  = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx_au_marketplace:updateUI', function(shopItems, auctionItems, playerItems, playerWeapons, playerVehicles, playerListedItems)
    --playerItems = Helpers.GetListedProducts(Config.ListProducts, playerItems)
    SendNUIMessage({ type = 'UpdateUI', shopItems = shopItems, auctionItems = auctionItems, playerItems = playerItems, playerWeapons = playerWeapons, playerVehicles = Helpers.GenerateVehicleLabels(playerVehicles), playerListedItems = playerListedItems })
end)

RegisterNetEvent('esx_au_marketplace:addNormalVehicle', function(name, data)
    data.label = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    TriggerServerEvent('esx_au_marketplace:addNormalVehicle', name, data)
end)

RegisterNetEvent('esx_au_marketplace:addAuctionVehicle', function(name, data)
    data.label = GetLabelText(GetDisplayNameFromVehicleModel(data.model))
    TriggerServerEvent('esx_au_marketplace:addAuctionVehicle', name, data)
end)

RegisterNetEvent('esx_au_marketplace:sellerNotification', function(notification)
    SendNUIMessage({ type = 'ShowNotification', notification = notification })
end)

RegisterNetEvent('esx_au_marketplace:openMarket', function()
    LastMarket = ClosestMarket.Name
    ESX.TriggerServerCallback('esx_au_marketplace:getData', function(shopItems, auctionItems, playerItems, playerWeapons, playerVehicles, playerListedItems, onlinePlayers)
        --playerItems = Helpers.GetListedProducts(Config.ListProducts, playerItems)
        
        local listedshopItems = {}
        for key, item in pairs(shopItems) do
            if onlinePlayers[item.seller] then
                -- item.sellername = item.sellername .. " 🟢"
                -- item.online = true
                table.insert(listedshopItems, item)
            end
        end
        
        SendNUIMessage({ type = 'ShowUI', marketType = ClosestMarket.Type, translation = Translation, advertisement = Config.Advertisement, auction = Config.Auction, shopItems = listedshopItems, auctionItems = auctionItems, playerItems = playerItems, playerWeapons = playerWeapons, playerVehicles = Helpers.GenerateVehicleLabels(playerVehicles), playerListedItems = playerListedItems })
        SetNuiFocus(true, true)
        SetTimecycleModifier('hud_def_blur') 
    end, ClosestMarket.Name)
end)

RegisterCommand('openMarket', function()
    LastMarket = ClosestMarket.Name
    ESX.TriggerServerCallback('esx_au_marketplace:getData', function(shopItems, auctionItems, playerItems, playerWeapons, playerVehicles, playerListedItems, onlinePlayers)
        --playerItems = Helpers.GetListedProducts(Config.ListProducts, playerItems)
        local listedshopItems = {}
        for key, item in pairs(shopItems) do
            if onlinePlayers[item.seller] then
                -- item.sellername = item.sellername .. " 🟢"
                -- item.online = true
                table.insert(listedshopItems, item)
            end
        end

        SendNUIMessage({ type = 'ShowUI', marketType = ClosestMarket.Type, translation = Translation, advertisement = Config.Advertisement, auction = Config.Auction, shopItems = listedshopItems, auctionItems = auctionItems, playerItems = playerItems, playerWeapons = playerWeapons, playerVehicles = Helpers.GenerateVehicleLabels(playerVehicles), playerListedItems = playerListedItems })
        SetNuiFocus(true, true)
        SetTimecycleModifier('hud_def_blur') 
    end, ClosestMarket.Name)
end, false)
RegisterKeyMapping('openMarket', 'Open Market', 'keyboard', 'f4')

--[[
CreateThread(function()
    Helpers.CreateBlips()
    if Config.UseQbTarget then
        for key, market in pairs(Config.Marketplaces) do
            exports['qb-target']:AddBoxZone('market-'..market.Name, market.Location, 1, 1, {
                name = 'market-'..market.Name,
                debugPoly = false
            }, {
                options = {
                    {
                        type = 'client',
                        event = 'esx_au_marketplace:openMarket',
                        icon = Translation.TargetIcon,
                        label = Translation.TargetLabel
                    }
                },
                distance = 1.5
            })
        end
        while true do
            for key, market in pairs(Config.Marketplaces) do
                if #(GetEntityCoords(PlayerPedId()) - market.Location) < market.Marker.MarkerDistance then
                    ClosestMarket = market
                end
            end
            Wait(0)
        end
    elseif Config.UseOxTarget then
        for key, market in pairs(Config.Marketplaces) do
            exports['ox_target']:addBoxZone({
                coords = market.Location,
                size = vector3(1, 1, 1),
                debug = false,
                options = {
                    {
                        name = 'openmarket',
                        event = 'esx_au_marketplace:openMarket',
                        icon = Translation.TargetIcon,
                        label = Translation.TargetLabel
                    }
                }
            })
        end
        while true do
            for key, market in pairs(Config.Marketplaces) do
                if #(GetEntityCoords(PlayerPedId()) - market.Location) < market.Marker.MarkerDistance then
                    ClosestMarket = market
                end
            end
            Wait(0)
        end
    else
        while true do
            for key, market in pairs(Config.Marketplaces) do
                if market.JobCheck then
                    if Helpers.JobCheck(market.JobCheck) then
                        if #(GetEntityCoords(PlayerPedId()) - market.Location) < market.Marker.TextDistance then
                            DrawMarker(market.Marker.Type, market.Location.x, market.Location.y, market.Location.z, 0.0, 0.0, 0.0, market.Marker.Rotation[1], market.Marker.Rotation[2], market.Marker.Rotation[3], market.Marker.Scale, market.Marker.Scale, market.Marker.Scale, market.Marker.Color.R, market.Marker.Color.G, market.Marker.Color.B, market.Marker.Color.A, market.Marker.BobUpAndDown, market.Marker.FaceCamera, 2, nil, nil, false)
                            Helpers.DrawHelpText(Translation.HelpText)
                            if IsControlJustReleased(0, 51) then
                                LastMarket = market.Name
                                ClosestMarket = market
                                ESX.TriggerServerCallback('esx_au_marketplace:getData', function(shopItems, auctionItems, playerItems, playerVehicles, playerListedItems)
                                    playerItems = Helpers.GetListedProducts(Config.ListProducts, playerItems)
                                    SendNUIMessage({ type = 'ShowUI', marketType = market.Type, translation = Translation, advertisement = Config.Advertisement, auction = Config.Auction, shopItems = shopItems, auctionItems = auctionItems, playerItems = playerItems, playerVehicles = Helpers.GenerateVehicleLabels(playerVehicles), playerListedItems = playerListedItems })
                                    SetNuiFocus(true, true)
        SetTimecycleModifier('hud_def_blur') 
                                end, market.Name)
                            end
                        elseif #(GetEntityCoords(PlayerPedId()) - market.Location) < market.Marker.MarkerDistance then
                            DrawMarker(market.Marker.Type, market.Location.x, market.Location.y, market.Location.z, 0.0, 0.0, 0.0, market.Marker.Rotation[1], market.Marker.Rotation[2], market.Marker.Rotation[3], market.Marker.Scale, market.Marker.Scale, market.Marker.Scale, market.Marker.Color.R, market.Marker.Color.G, market.Marker.Color.B, market.Marker.Color.A, market.Marker.BobUpAndDown, market.Marker.FaceCamera, 2, nil, nil, false)
                        end
                    end
                else
                    if #(GetEntityCoords(PlayerPedId()) - market.Location) < market.Marker.TextDistance then
                        Helpers.DrawHelpText(Translation.HelpText)
                        DrawMarker(market.Marker.Type, market.Location.x, market.Location.y, market.Location.z, 0.0, 0.0, 0.0, market.Marker.Rotation[1], market.Marker.Rotation[2], market.Marker.Rotation[3], market.Marker.Scale, market.Marker.Scale, market.Marker.Scale, market.Marker.Color.R, market.Marker.Color.G, market.Marker.Color.B, market.Marker.Color.A, market.Marker.BobUpAndDown, market.Marker.FaceCamera, 2, nil, nil, false)
                        if IsControlJustReleased(0, 51) then
                            LastMarket = market.Name
                            ClosestMarket = market
                            ESX.TriggerServerCallback('esx_au_marketplace:getData', function(shopItems, auctionItems, playerItems, playerVehicles, playerListedItems)
                                playerItems = Helpers.GetListedProducts(Config.ListProducts, playerItems)
                                SendNUIMessage({ type = 'ShowUI', marketType = market.Type, translation = Translation, advertisement = Config.Advertisement, auction = Config.Auction, shopItems = shopItems, auctionItems = auctionItems, playerItems = playerItems, playerVehicles = Helpers.GenerateVehicleLabels(playerVehicles), playerListedItems = playerListedItems })
                                SetNuiFocus(true, true)
        SetTimecycleModifier('hud_def_blur') 
                            end, market.Name)
                        end
                    elseif #(GetEntityCoords(PlayerPedId()) - market.Location) < market.Marker.MarkerDistance then
                        DrawMarker(market.Marker.Type, market.Location.x, market.Location.y, market.Location.z, 0.0, 0.0, 0.0, market.Marker.Rotation[1], market.Marker.Rotation[2], market.Marker.Rotation[3], market.Marker.Scale, market.Marker.Scale, market.Marker.Scale, market.Marker.Color.R, market.Marker.Color.G, market.Marker.Color.B, market.Marker.Color.A, market.Marker.BobUpAndDown, market.Marker.FaceCamera, 2, nil, nil, false)
                    end
                end
            end
            Wait(0)
        end
    end
end)
]]
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = ((1 / dist) * 2) * (1 / GetGameplayCamFov()) * 100

    if onScreen then
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.2 * scale, 0.65 * scale)
        SetTextFont(fontId)
        SetTextProportional(1)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextOutline()
        SetTextCentre(true)


        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(0.55 * scale, 4)
        local width = EndTextCommandGetWidth(4)

        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)
    end
end
