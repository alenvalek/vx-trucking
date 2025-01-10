lib.locale()
local config = require 'config'
local boss = require 'client/boss'
local vehicle = require "client/vehicle"
local mission = require "client/mission"
local player = require 'client/player'
require 'shared/utils'


CreateThread(function()
    while true do
        if mission.missionStarted and mission.trailer and mission.currentMission ~= nil then
            local destination = mission.currentMission.position
            local pedCoords = GetEntityCoords(cache.ped)
            local pedVehicle = GetVehiclePedIsIn(cache.ped, false)
            local isTrailerAttached = IsVehicleAttachedToTrailer(pedVehicle)
            local trailerPos = GetEntityCoords(mission.trailer)

            if isTrailerAttached then
                mission.SwitchToBlip("mission")
            else
                mission.SwitchToBlip("cargo")
            end

            if #(pedCoords - destination.xyz) < 50.0 and pedVehicle then
                local markerBounds = {
                    xMin = destination.x - 2.5,
                    xMax = destination.x + 2.5,
                    yMin = destination.y - 6.25,
                    yMax = destination.y + 6.25
                }

                local trailerBounds = {
                    xMin = trailerPos.x - 2.0,
                    xMax = trailerPos.x + 2.0,
                    yMin = trailerPos.y - 5.0,
                    yMax = trailerPos.y + 5.0
                }

                local isInsideBounds =
                    trailerBounds.xMin >= markerBounds.xMin and trailerBounds.xMax <= markerBounds.xMax and
                    trailerBounds.yMin >= markerBounds.yMin and trailerBounds.yMax <= markerBounds.yMax

                local markerColor = isInsideBounds and config.Colors["inBoundColor"] or config.Colors
                    ["outOfBoundsColor"]

                DrawMarker(30, destination.x, destination.y, destination.z, 0.0, 0.0, 90.0, 0.0, destination.w, 0.0, 5.0,
                    2.0, 12.5,
                    markerColor.r, markerColor.g, markerColor.b, 255, false, false, 2, nil, nil, false)

                if isInsideBounds and IsVehicleStopped(pedVehicle) then
                    if not mission.textUIShown then
                        lib.showTextUI(locale("unload_cargo_key_input", "E"))
                        mission.textUIShown = true
                    end

                    if IsControlJustPressed(0, 38) then
                        mission.FinishMission()
                    end
                else
                    if mission.textUIShown then
                        lib.hideTextUI()
                        mission.textUIShown = false
                    end
                end

                Wait(1)
            else
                if mission.textUIShown then
                    lib.hideTextUI()
                    mission.textUIShown = false
                end

                Wait(500)
            end
        else
            Wait(1000)
        end
    end
end)

local function PlaySignContractAnimation()
    return lib.progressBar({
        duration = 2000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true },
        anim = { dict = 'amb@world_human_clipboard@male@idle_a', clip = 'idle_c' },
        prop = { model = 'p_amb_clipboard_01', pos = vec3(0.03, 0, 0.02), rot = vec3(0.0, 0.0, -1.5) }
    })
end

local function RentTruck(model, cost, jobLocationKey)
    if PlaySignContractAnimation() then
        local spawnPosition = GetClosestVacantParkingLot(config.JobLocations[jobLocationKey].VehicleParkingSpots)

        if not spawnPosition then
            lib.notify({
                title = 'No parking spots available',
                description = 'Please try again later.',
                icon = 'fa-solid fa-square-parking',
                type = 'error',
                position = 'center-right',
            })
            return
        end

        local rentedTruck = vehicle.SpawnVehicle(model, spawnPosition)
        local vehicleNetId = NetworkGetNetworkIdFromEntity(rentedTruck)

        local vehicleData = {
            model = model,
            plate = GetVehicleNumberPlateText(rentedTruck),
            netId = vehicleNetId,
            deposit = cost
        }

        TriggerServerEvent('vx_trucking:server:rent_truck', vehicleData)

        lib.notify({
            title = 'Truck rented',
            description = 'You have rented a ' .. Capitalize(model) .. ' for $' .. cost,
            icon = 'fa-solid fa-truck-moving',
            type = 'success',
            position = 'center-right',
        })
    else
        lib.notify({
            title = 'Canceled',
            description = 'Truck rental was canceled.',
            icon = 'fa-solid fa-truck-moving',
            type = 'warning',
            position = 'center-right',
        })
    end
end

local function InitializeJob()
    for jobLocationKey, jobLocation in pairs(config.JobLocations) do
        boss.CreateBossPed(jobLocation.BossPed, jobLocationKey)
        boss.AddEntityContextMenuToPed(jobLocationKey)
    end
end

local function InteractAcceptMission(data)
    if PlaySignContractAnimation() then
        mission.AcceptMission(data.job, data.missionId, boss.jobLocationKey)
    end
end

local function InteractRentMenu(data)
    lib.showContext("rent_truck" .. data.args.jobLocationKey)
end

local function InteractJobsMenu(data)
    lib.showContext("truck_mission" .. data.args.jobLocationKey)
end

local function InteractTakeJob()
    local isPlayerInGroup = player.isInGroup('trucking_co')

    if isPlayerInGroup then
        lib.notify({
            title = locale("already_in_group"),
            description = locale("already_in_group_desc"),
            icon = 'fa-solid fa-suitcase',
            type = 'error',
            position = 'center-right',
        })
        return
    end

    TriggerServerEvent('vx_trucking:server:take_job')
end

local function InteractShowRentedVehicles()
    local playerRentedVehicles = lib.callback.await('vx_trucking:server:getPlayerRentedVehicles', source)
    local rentedVehicleContext = {}

    for i = 1, #playerRentedVehicles do
        local vehicle = playerRentedVehicles[i]
        table.insert(rentedVehicleContext, {
            title = Capitalize(vehicle.model),
            description = "Plates: " .. vehicle.plate,
            icon = ('https://docs.fivem.net/vehicles/%s.webp'):format(vehicle.model),
            onSelect = function() TriggerServerEvent('vx_trucking:server:return_rented_truck', vehicle.netId) end
        })
    end

    lib.registerContext({
        id = "rented_trucks",
        title = locale("return_rented_trucks"),
        options = {
            table.unpack(rentedVehicleContext)
        }
    })

    lib.showContext("rented_trucks")
end

local function InteractCancelCurrentJob()
    if mission.missionStarted then
        lib.notify({
            title = locale("mission_cancelled"),
            description = locale("mission_cancelled_desc"),
            icon = 'fa-solid fa-truck-moving',
            type = 'success',
            position = 'center-right',
        })

        mission.CancelMission()
    else
        lib.notify({
            title = locale("no_active_mission"),
            description = locale("no_active_mission_desc"),
            icon = 'fa-solid fa-truck-moving',
            type = 'error',
            position = 'center-right',
        })
    end
end

local function HandleResourceStart(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    InitializeJob()
end

local function HandleResourceStop(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if mission.trailer and DoesEntityExist(mission.trailer) then DeleteEntity(mission.trailer) end
end

AddEventHandler('onClientResourceStart', HandleResourceStart)
AddEventHandler('onResourceStop', HandleResourceStop)
RegisterNetEvent('vx_trucking:client:interact_take_job', InteractTakeJob)
RegisterNetEvent('vx_trucking:client:interact_rent_menu', InteractRentMenu)
RegisterNetEvent('vx_trucking:client:interact_jobs_menu', InteractJobsMenu)
RegisterNetEvent('vx_trucking:client:interact_show_rented_vehicles', InteractShowRentedVehicles)
RegisterNetEvent('vx_trucking:client:interact_cancel_current_mission', InteractCancelCurrentJob)
RegisterNetEvent('vx_trucking:client:rent_truck:notify', RentTruck)
RegisterNetEvent('vx_trucking:client:interact_take_mission', InteractAcceptMission)
