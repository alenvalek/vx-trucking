lib.locale()
local Ox = require '@ox_core/lib/init'
local config = require 'config'
require 'shared/utils'

local playerRentedTrucks = {}
local playerMissionAccumulated = {}

local function CreateJobGroupIfNotExists(groupName, data)
    local jobGroups = Ox.GetGroupsByType('job')

    if IsValueInArray(jobGroups, groupName) then return end

    Ox.CreateGroup(data)
end

local function ValidateRentedTrucks(source, data)
    if not playerRentedTrucks[source] then
        playerRentedTrucks[source] = {}
    end

    if #playerRentedTrucks[source] > 2 then
        TriggerClientEvent('ox_lib:notify', source, {
            title = locale('truck_limit_reached'),
            description = locale('truck_limit_reached_desc'),
            icon = 'fa-solid fa-truck-moving',
            type = 'error',
            position = 'center-right',
        })
        return
    end

    TriggerClientEvent('vx_trucking:client:rent_truck:notify', source, data.model, data.cost, data.jobLocationKey)
end

local function RentTruckEventHandler(source, vehicleData)
    if playerRentedTrucks[source] == nil then
        playerRentedTrucks[source] = {}
    end

    local player = Ox.GetPlayer(source)
    local playerAcc = player.getAccount()
    local bankBalance = playerAcc.get('balance')
    local inventoryCash = exports.ox_inventory:GetItemCount(source, 'money')
    local cost = vehicleData.deposit

    if (bankBalance >= cost) then
        playerAcc.removeBalance({
            amount = cost,
            message = 'Truck rental',
            overdraw = false
        })
    elseif (inventoryCash >= cost) then
        exports.ox_inventory:RemoveItem(source, 'money', cost)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            title = locale("insufficient_funds"),
            description = locale("insufficient_funds_desc"),
            icon = 'fa-solid fa-truck-moving',
            type = 'error',
            position = 'center-right',
        })
        return
    end

    table.insert(playerRentedTrucks[source], vehicleData)
end

local function ReturnRentedTruckEventHandler(source, networkId)
    if not playerRentedTrucks[source] then
        playerRentedTrucks[source] = {}
    end

    for i, v in ipairs(playerRentedTrucks[source]) do
        if v.netId == networkId then
            local vehicle = NetworkGetEntityFromNetworkId(networkId)

            table.remove(playerRentedTrucks[source], i)
            DeleteEntity(vehicle)

            local player = Ox.GetPlayer(source)
            local playerAcc = player.getAccount()

            playerAcc.addBalance({
                amount = v.deposit,
                message = locale("bank_message_rental_deposit"),
            })

            TriggerClientEvent('ox_lib:notify', source, {
                title = locale("truck_returned"),
                description = locale("truck_returned_desc"),
                icon = 'fa-solid fa-truck-moving',
                type = 'success',
                position = 'center-right',
            })
            break
        end
    end
end

local function StartMissionEventHandler(source, missionId, jobLocationKey)
    if not playerMissionAccumulated[source] then
        playerMissionAccumulated[source] = {
            withdrawable = 0,
            currentJobReward = config.JobLocations[jobLocationKey].Jobs[missionId].reward
        }
    else
        playerMissionAccumulated[source].currentJobReward = config.JobLocations[jobLocationKey].Jobs[missionId].reward
    end
end

local function DeliveredCargoEventHandler(source)
    local currentPlayerMissionAccumulated = playerMissionAccumulated[source]
    local missionWithdrawableAmount = currentPlayerMissionAccumulated.withdrawable
    local currentJobReward = currentPlayerMissionAccumulated.currentJobReward

    playerMissionAccumulated[source] = {
        withdrawable = missionWithdrawableAmount + currentJobReward,
        currentJobReward = 0
    }
end

local function CollectMissionRewardEventHandler(source)
    local player = Ox.GetPlayer(source)
    local playerAcc = player.getAccount()
    local withdrawableReward = playerMissionAccumulated[source].withdrawable

    playerAcc.addBalance({
        amount = withdrawableReward,
        message = locale("trucking_co_payslip"),
    })

    playerMissionAccumulated[source].withdrawable = 0

    TriggerClientEvent("ox_lib:notify", source, {
        title = locale("trucking_co_payslip"),
        description = locale("trucking_co_payslip_desc", withdrawableReward),
        icon = 'fa-solid fa-coins',
        type = 'success',
        position = 'center-right',
    })
end

local function TakeJobEventHandler(source)
    local player = Ox.GetPlayer(source)

    player.setGroup('trucking_co', 1)

    TriggerClientEvent("ox_lib:notify", source, {
        title = locale("job_employed"),
        description = locale("job_employed_desc", 0),
        icon = 'fa-solid fa-suitcase',
        type = 'success',
        position = 'center-right',
    })
end

local function QuitJobEventHandler(source)
    local player = Ox.GetPlayer(source)

    player.setGroup('trucking_co')

    TriggerClientEvent("ox_lib:notify", source, {
        title = locale("job_quit"),
        description = locale("job_quit_desc", 0),
        icon = 'fa-solid fa-suitcase',
        type = 'success',
        position = 'center-right',
    })
end

local function getIsPlayerOnMission(source)
    local isPlayerOnMission = false

    if playerMissionAccumulated[source] ~= nil then
        if playerMissionAccumulated[source].currentJobReward > 0 then
            isPlayerOnMission = true
        end
    else
        isPlayerOnMission = false
    end

    return isPlayerOnMission
end

local function getHasPlayerMissionRewardCallback(source)
    local hasPlayerReward = false

    if playerMissionAccumulated[source] ~= nil then
        hasPlayerReward = playerMissionAccumulated[source].withdrawable > 0
    else
        hasPlayerReward = false
    end

    return hasPlayerReward
end

local function getPlayerRentedVehiclesCallback(source)
    local playerRentedVehicles = playerRentedTrucks[source]
    local filteredPlayerRentedVehicles = {}

    if not playerRentedVehicles then
        return {}
    end

    local playerPosition = GetEntityCoords(GetPlayerPed(source))

    for i, v in ipairs(playerRentedVehicles) do
        local vehicle = NetworkGetEntityFromNetworkId(playerRentedVehicles[i].netId)
        local vehiclePosition = GetEntityCoords(vehicle)

        if (#(playerPosition - vehiclePosition) <= 45.0) then
            table.insert(filteredPlayerRentedVehicles, playerRentedVehicles[i])
        end
    end


    return filteredPlayerRentedVehicles
end

local function CancelCurrentMissionEventHandler(source)
    playerMissionAccumulated[source] = nil
    TriggerClientEvent('vx_trucking:client:interact_cancel_current_mission', source)
end

AddEventHandler('playerDropped', function()
    local source = source

    playerRentedTrucks[source] = nil
    playerMissionAccumulated[source] = nil
end)

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    CreateJobGroupIfNotExists('trucking_co', {
        name = 'trucking_co',
        label = 'Trucking Co.',
        grades = {
            { label = "Rookie Trucker",      accountRole = nil },
            { label = "Apprentice Trucker",  accountRole = nil },
            { label = "Experienced Trucker", accountRole = nil },
            { label = "TruckingLegend",      accountRole = nil },
        },
        type = 'job',
        hasAccount = false
    })
end)

RegisterNetEvent('vx_trucking:server:validate_rent_truck', function(data)
    ValidateRentedTrucks(source, data)
end)

RegisterNetEvent('vx_trucking:server:rent_truck', function(vehicleData)
    RentTruckEventHandler(source, vehicleData)
end)

RegisterNetEvent("vx_trucking:server:return_rented_truck", function(networkId)
    ReturnRentedTruckEventHandler(source, networkId)
end)

RegisterNetEvent('vx_trucking:server:startMission', function(missionId, jobLocationKey)
    StartMissionEventHandler(source, missionId, jobLocationKey)
end)

RegisterNetEvent('vx_trucking:server:delivered_cargo', function()
    DeliveredCargoEventHandler(source)
end)

RegisterNetEvent('vx_trucking:server:collect_mission_reward', function()
    CollectMissionRewardEventHandler(source)
end)

RegisterNetEvent("vx_trucking:server:take_job", function()
    TakeJobEventHandler(source)
end)

RegisterNetEvent("vx_trucking:server:quit_job", function()
    QuitJobEventHandler(source)
end)

RegisterNetEvent('vx_trucking:server:cancel_mission', function()
    CancelCurrentMissionEventHandler(source)
end)

lib.callback.register("vx_trucking:server:getHasPlayerMissionReward", function(source)
    return getHasPlayerMissionRewardCallback(source)
end)

lib.callback.register("vx_trucking:server:getIsPlayerOnMission", function(source)
    return getIsPlayerOnMission(source)
end)

lib.callback.register('vx_trucking:server:getPlayerRentedVehicles', function(source)
    return getPlayerRentedVehiclesCallback(source)
end)
