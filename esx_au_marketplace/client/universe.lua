ESX = nil
playerLoaded = false
universeId = nil
allowedUniverse = {
    [0] = true
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(5)
    end
	while ESX.GetPlayerData().job == nil do Citizen.Wait(5) end
    playerLoaded = true
end)

RegisterNetEvent("au_portal:joinedUniverse")
AddEventHandler("au_portal:joinedUniverse", function (newUniverse, resource)
    if (universeId == newUniverse) or (resource and GetCurrentResourceName() ~= resource) then return end
    Citizen.CreateThread(function()
        universeId = newUniverse

        while not playerLoaded do Citizen.Wait(5) end

        if allowedUniverse[universeId] then
            InitResource()
        else
            DestructResource()
        end
    end)
end)

function InitResource()
    Helpers.CreateBlip()
end

function DestructResource()
    RemoveBlip(Helpers.blip)
end