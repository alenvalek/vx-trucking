local boss = {}
local config = require 'config'
local player = require 'client/player'
local mission = require 'client/mission'


local bossPeds = {}

function boss.CreateBossPed(BossPed, jobLocationKey)
    local pedModel = BossPed.model
    local pedPosition = BossPed.position

    LoadModel(pedModel)

    local ped = CreatePed(1, pedModel, pedPosition.x, pedPosition.y, pedPosition.z - 1, pedPosition.w,
        false, false)

    boss.bossPed = ped

    FreezeEntityPosition(boss.bossPed, true)
    SetEntityInvincible(boss.bossPed, true)
    SetBlockingOfNonTemporaryEvents(boss.bossPed, true)
    SetModelAsNoLongerNeeded(pedModel)

    boss.jobLocationKey = jobLocationKey

    bossPeds[jobLocationKey] = { bossPed = ped, jobLocationKey = jobLocationKey }
end

function boss.AddEntityContextMenuToPed(jobLocationKey)
    exports.ox_target:addLocalEntity(bossPeds[jobLocationKey].bossPed, {
        {
            name = 'boss_target_take_job' .. jobLocationKey,
            label = locale('take_job'),
            icon = 'fa-solid fa-suitcase',
            event = 'vx_trucking:client:interact_take_job',
            canInteract = function()
                local isPlayerInGroup = player.isInGroup('trucking_co')

                if not isPlayerInGroup then
                    return true
                else
                    return false
                end
            end
        },
        {
            name = 'boss_target_rent_truck' .. jobLocationKey,
            label = locale('rent_vehicle'),
            icon = 'fa-solid fa-truck-moving',
            event = 'vx_trucking:client:interact_rent_menu',
            canInteract = function()
                local isPlayerInGroup = player.isInGroup('trucking_co')

                if isPlayerInGroup then
                    return true
                else
                    return false
                end
            end,
            args = {
                jobLocationKey = jobLocationKey
            }
        },
        {
            name = 'boss_target_job' .. jobLocationKey,
            label = locale("find_a_job"),
            icon = 'fa-solid fa-truck-ramp-box',
            event = 'vx_trucking:client:interact_jobs_menu',
            canInteract = function()
                local isPlayerInGroup = player.isInGroup('trucking_co')

                if isPlayerInGroup and not mission.missionStarted then
                    return true
                else
                    return false
                end
            end,
            args = {
                jobLocationKey = jobLocationKey
            }
        },
        {
            name = 'boss_target_rented_trucks' .. jobLocationKey,
            label = locale("return_rented_trucks"),
            icon = 'fa-solid fa-rotate-left',
            event = 'vx_trucking:client:interact_show_rented_vehicles',
            canInteract = function()
                local playerRentedVehicles = lib.callback.await('vx_trucking:server:getPlayerRentedVehicles')

                if #playerRentedVehicles > 0 then
                    return true
                else
                    return false
                end
            end
        },
        {
            name = 'boss_target_collect_payment' .. jobLocationKey,
            label = locale("collect_payment"),
            icon = 'fa-solid fa-coins',
            serverEvent = 'vx_trucking:server:collect_mission_reward',
            canInteract = function()
                local hasPlayerAnyRewards = lib.callback.await("vx_trucking:server:getHasPlayerMissionReward")

                if hasPlayerAnyRewards then
                    return true
                else
                    return false
                end
            end
        },
        {
            name = 'boss_target_cancel_mission' .. jobLocationKey,
            label = locale('cancel_mission'),
            icon = 'fa-solid fa-arrow-right-from-bracket',
            serverEvent = 'vx_trucking:server:cancel_mission',
            canInteract = function()
                local isPlayerOnMission = lib.callback.await('vx_trucking:server:getIsPlayerOnMission')

                if isPlayerOnMission then
                    return true
                else
                    return false
                end
            end
        },
        {
            name = 'boss_target_quit_job' .. jobLocationKey,
            label = locale('quit_job'),
            icon = 'fa-solid fa-arrow-right-from-bracket',
            serverEvent = 'vx_trucking:server:quit_job',
            canInteract = function()
                local isPlayerInGroup = player.isInGroup('trucking_co')

                if isPlayerInGroup then
                    return true
                else
                    return false
                end
            end
        },
    })

    local rentContextOptions = {}
    local jobContextOptions = {}

    for i = 1, #config.JobLocations[jobLocationKey].Trucks do
        local truck = config.JobLocations[jobLocationKey].Trucks[i]
        table.insert(rentContextOptions, {
            title = Capitalize(truck.model),
            description = locale('rent_price', truck.startCost),
            icon = ('https://docs.fivem.net/vehicles/%s.webp'):format(truck.model),
            serverEvent = 'vx_trucking:server:validate_rent_truck',
            args = {
                model = truck.model,
                cost = truck.startCost,
                jobLocationKey = bossPeds[jobLocationKey].jobLocationKey
            }
        })
    end

    for missionId, job in pairs(config.JobLocations[jobLocationKey].Jobs) do
        local bossPedLocation = config.JobLocations[jobLocationKey].BossPed.position
        local jobLocation = job.position
        local travelPathDistance = CalculateTravelDistanceBetweenPoints(
            bossPedLocation.x,
            bossPedLocation.y,
            bossPedLocation.z,
            jobLocation.x,
            jobLocation.y,
            jobLocation.z
        )

        local distanceInMiles = travelPathDistance * 0.000621371
        local distanceInKm = travelPathDistance / 1000

        local playerPrefUnit = (ShouldUseMetricMeasurements() and distanceInKm) or distanceInMiles

        table.insert(jobContextOptions, {
            title = job.name,
            description = locale("mission_desc", job.reward, playerPrefUnit),
            event = 'vx_trucking:client:interact_take_mission',
            args = {
                job = job,
                missionId = missionId
            }
        })
    end


    lib.registerContext({
        id = "rent_truck" .. jobLocationKey,
        title = locale("rent_a_truck"),
        options = {
            table.unpack(rentContextOptions)
        }
    })

    lib.registerContext({
        id = "truck_mission" .. jobLocationKey,
        title = locale("choose_a_job"),
        options = {
            table.unpack(jobContextOptions)
        }
    })
end

return boss
