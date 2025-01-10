local vehicle = {}

function vehicle.SpawnVehicle(model, spawnPosition)
    LoadModel(model)

    local vehicle = CreateVehicle(
        model,
        spawnPosition.x,
        spawnPosition.y,
        spawnPosition.z,
        spawnPosition.w,
        true,
        false
    )

    SetModelAsNoLongerNeeded(model)
    return vehicle
end

function vehicle.IsVehicleStopped(vehicle)
    local speed = GetEntitySpeed(vehicle)
    return speed < 1.0
end

function vehicle.DeleteVehicle(vehicle)
    if vehicle then
        DeleteEntity(vehicle)
    end
end

return vehicle
