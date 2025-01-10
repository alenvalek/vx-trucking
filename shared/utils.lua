function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(500)
    end
end

function GetClosestVacantParkingLot(coordsArray)
    local playerCoords = GetEntityCoords(cache.ped)

    local closest = {
        distance = 1000,
        index = nil
    }

    for i = 1, #coordsArray do
        local tempCoords = coordsArray[i].xyz
        local tempDistance = #(playerCoords - tempCoords)
        if tempDistance < closest.distance then
            if #lib.getNearbyVehicles(tempCoords, 4.0, true) == 0 and #lib.getNearbyPlayers(tempCoords, 4.0, true) == 0 then
                closest.distance = tempDistance
                closest.index = i
            end
        end
    end
    return coordsArray[closest.index] or false
end

function Capitalize(str)
    str = str:gsub("%d", "")

    return (str:gsub("^%l", string.upper))
end

function IsValueInArray(array, value)
    for i = 1, #array do if array[i] == value then return true end end
    return false
end
