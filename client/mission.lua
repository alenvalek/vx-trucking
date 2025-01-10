local config = require 'config'
local vehicle = require 'client/vehicle'

local mission = {
    currentMission = nil,
    missionStarted = nil,
    missionBlip = nil,
    cargoBlip = nil,
    trailer = nil,
}

function mission.AcceptMission(job, missionId, jobLocationKey)
    mission.currentMission = job
    mission.missionStarted = true

    mission.trailer = vehicle.SpawnVehicle(job.trailerType, config.JobLocations[jobLocationKey].TrailerSpawnPosition)
    mission.CreateMissionCargoBlip()

    TriggerServerEvent('vx_trucking:server:startMission', missionId, jobLocationKey)
end

function mission.FinishMission()
    lib.hideTextUI()

    mission.missionStarted = false

    if mission.missionBlip ~= nil then
        RemoveBlip(mission.missionBlip)
        mission.missionBlip = nil
    end

    if mission.trailer ~= nil then
        DeleteEntity(mission.trailer)
        mission.trailer = nil
    end

    lib.notify({
        title = locale("mission_completed"),
        description = locale("mission_completed_desc"),
        icon = 'fa-solid fa-truck-moving',
        type = 'success',
        position = 'center-right',
    })

    TriggerServerEvent("vx_trucking:server:delivered_cargo")
end

function mission.CreateMissionBlip()
    local destination = mission.currentMission.position
    local jobName = mission.currentMission.name

    mission.missionBlip = AddBlipForCoord(destination.x, destination.y, destination.z)
    SetBlipSprite(mission.missionBlip, 479)
    SetBlipColour(mission.missionBlip, 2)
    SetBlipScale(mission.missionBlip, 0.8)
    SetBlipAsShortRange(mission.missionBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(jobName)
    EndTextCommandSetBlipName(mission.missionBlip)
    SetBlipRoute(mission.missionBlip, true)
    SetBlipRouteColour(mission.missionBlip, 2)
end

function mission.CreateMissionCargoBlip()
    local destination = GetEntityCoords(mission.trailer)

    mission.cargoBlip = AddBlipForCoord(destination.x, destination.y, destination.z)
    SetBlipSprite(mission.cargoBlip, 479)
    SetBlipColour(mission.cargoBlip, 2)
    SetBlipScale(mission.cargoBlip, 0.8)
    SetBlipAsShortRange(mission.cargoBlip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cargo")
    EndTextCommandSetBlipName(mission.cargoBlip)
end

function mission.SwitchToBlip(blipType)
    if blipType == "mission" then
        if mission.missionBlip == nil then
            mission.CreateMissionBlip()
        end
        if mission.cargoBlip ~= nil then
            RemoveBlip(mission.cargoBlip)
            mission.cargoBlip = nil
        end
    else
        if mission.cargoBlip == nil then
            mission.CreateMissionCargoBlip()
        end

        if mission.missionBlip ~= nil then
            RemoveBlip(mission.missionBlip)
            mission.missionBlip = nil
        end
    end
end

function mission.CancelMission()
    lib.hideTextUI()

    mission.currentMission = nil
    mission.missionStarted = false

    if mission.missionBlip ~= nil then
        RemoveBlip(mission.missionBlip)
        mission.missionBlip = nil
    end

    if mission.trailer ~= nil then
        DeleteEntity(mission.trailer)
        mission.trailer = nil
    end

    if mission.cargoBlip ~= nil then
        RemoveBlip(mission.cargoBlip)
        mission.cargoBlip = nil
    end

    TriggerServerEvent("vx_trucking:server:cancelMission")
end

return mission
