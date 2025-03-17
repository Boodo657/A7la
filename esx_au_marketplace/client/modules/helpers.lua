Helpers = {
    IsBlacklistVehicle = function(model)
        for key, vehicle in pairs(Config.BlacklistVehicles) do
            if vehicle == model then
                return true
            end
        end
        return false
    end,

    GenerateVehicleLabels = function(vehicles)
        for key, vehicle in pairs(vehicles) do
            if Helpers.IsBlacklistVehicle(vehicle.model) then
                table.remove(vehicles, key)
            else
                vehicle.label = GetLabelText(GetDisplayNameFromVehicleModel(vehicle.model))
            end
        end
        return vehicles
    end,

    DrawHelpText = function(text)
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayHelp(0, false, true, -1)
    end,

    -- Create the blips for the marketplaces
    CreateBlip = function()
        Helpers.blip = AddBlipForCoord(-1570.9833984375, -482.55883789063, 35.713371276855)
        SetBlipSprite(Helpers.blip, 793)
        SetBlipDisplay(Helpers.blip, 4)
        SetBlipScale(Helpers.blip, 1.0)
        SetBlipColour(Helpers.blip, 2)
        SetBlipAsShortRange(Helpers.blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('AU Trade Center')
        EndTextCommandSetBlipName(Helpers.blip)
    end,

    -- Check if the player has the required job
    JobCheck = function(job)
        if type(job) == 'table' then
            return job[PlayerData.job.name]
        else
            return ESX.PlayerData.job.name == job
        end

        return false
    end,

    GetListedProducts = function(listProducts, items)

        for key, item in pairs(items) do
            if not listProducts[item.name] then
                --table.remove(items, key)
                items[key] = nil
            else
                items[key].pricelimits = listProducts[item.name]
            end
        end

        return items
    end
}