
local cam
local inCam

local confirmed
local heading

function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function DrawPropAxes(prop)
    local propForward, propRight, propUp, propCoords = GetEntityMatrix(prop)

    local propXAxisEnd = propCoords + propRight * 1.0
    local propYAxisEnd = propCoords + propForward * 1.0
    local propZAxisEnd = propCoords + propUp * 1.0

    DrawLine(propCoords.x, propCoords.y, propCoords.z + 0.1, propXAxisEnd.x, propXAxisEnd.y, propXAxisEnd.z, 255, 0, 0,
        255)
    DrawLine(propCoords.x, propCoords.y, propCoords.z + 0.1, propYAxisEnd.x, propYAxisEnd.y, propYAxisEnd.z, 0, 255, 0,
        255)
    DrawLine(propCoords.x, propCoords.y, propCoords.z + 0.1, propZAxisEnd.x, propZAxisEnd.y, propZAxisEnd.z, 0, 0, 255,
        255)
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination
        .x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

RegisterNetEvent('ent510:piazzaProp')
AddEventHandler('ent510:piazzaProp', function(prop,nameCanzone)
    prop = joaat(prop)
    heading = 0.0
    confirmed = false

    RequestModel(prop)
    while not HasModelLoaded(prop) do
        Wait(0)
    end

    local hit, coords

    while not hit do
        hit, coords = RayCastGamePlayCamera(10.0)
        Wait(0)
    end

    local propObject = CreateObject(prop, coords.x, coords.y, coords.z, true, false, true)


    lib.requestAnimDict("pickup_object")
    local playerPed = cache.ped or PlayerPedId()

    exports.ox_target:addLocalEntity(propObject, {
        {
            name = 'radio' .. propObject,
            label = Radio.Translate.TargetLabelOpen,
            icon = Radio.IconTargetOpen,
            distance = Radio.DistanceInteraction,
            onSelect = function(entity, distance, coords, name)
                lib.showMenu('ent510_radio')
                if Radio.CameraOn then
                    CamON(PlayerPedId())
                end
            end
        },
        {
            name = 'takeRadio' .. propObject,
            label = Radio.Translate.TargetLabelTake,
            icon = Radio.IconTargetTake,
            distance = Radio.DistanceInteraction,
            onSelect = function(data)
                TaskPlayAnim(playerPed, "pickup_object", "pickup_low", 8.0, 8.0, 1000, 50, 0, false, false, false)
                Wait(900)
                TriggerServerEvent("ent_radio:takeProp", propObject)
                TriggerServerEvent('ent510:stopSong',nameCanzone)
                DeleteEntity(propObject)
                ClearPedTasks(playerPed)
            end
        },
    })

    CamON = function(ped)
        local coords = GetOffsetFromEntityInWorldCoords(ped, 0, 1.6, 0)
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(camera, true)
        RenderScriptCams(true, true, 1250, 1, 0)
        SetCamCoord(camera, coords.x, coords.y, coords.z + 0.65)
        SetCamFov(camera, 38.0)
        SetCamRot(camera, 0.0, 0.0, GetEntityHeading(ped) + 180)

        PointCamAtPedBone(camera, ped, 31086, 0.0 - 0.3, 0.0, 0.03, 1)
        local camCoords = GetCamCoord(camera)
        TaskLookAtCoord(ped, camCoords.x, camCoords.y, camCoords.z, 5000, 1, 1)
        SetCamUseShallowDofMode(camera, true)
        SetCamNearDof(camera, 1.2)
        SetCamFarDof(camera, 12.0)
        SetCamDofStrength(camera, 1.0)
        SetCamDofMaxNearInFocusDistance(camera, 1.0)
        Citizen.CreateThread(function()
            while DoesCamExist(camera) do
                SetUseHiDof()
                Wait(0)
            end
        end)
    end

    function CamOFF()
        FreezeEntityPosition(PlayerPedId(), false)
        DeleteObject(obj)
        RenderScriptCams(false, true, 1250, 1, 0)
        DestroyCam(cam, false)
        inCam = false
        ClearPedTasks(playerPed)
    end

    function TastiTextUi()
        lib.showTextUI(
            Radio.Translate.PlaceProp ..
            '                                                                                       ' ..
            '\n' .. Radio.Translate.CancProp ..
            '                                                                                       ' ..
            '\n' .. Radio.Translate.RotProp,
            {
                position = "left-center",
                icon = 'hand',
                style = {
                    borderRadius = 0,
                    backgroundColor = 'black',
                    color = 'white'
                }
            }
        )
    end

    CreateThread(function()
        while not confirmed do
            hit, coords, entity = RayCastGamePlayCamera(10.0)
            TastiTextUi()
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            SetEntityCoordsNoOffset(propObject, coords.x, coords.y, coords.z, false, false, false, true)
            FreezeEntityPosition(propObject, true)
            SetEntityCollision(propObject, false, false)
            SetEntityAlpha(propObject, 100, false)

            DrawPropAxes(propObject)
            Wait(0)

            if IsControlPressed(0, 15) then  
                heading = heading + 5.0
            elseif IsControlPressed(0, 14) then 
                heading = heading - 5.0
            end

            if IsControlJustPressed(0, 177) then
                DeleteObject(propObject)
                lib.hideTextUI()
                TriggerServerEvent("ent_radio:takeProp", propObject)
                confirmed = true
            end

            if heading > 360.0 then
                heading = 0.0
            elseif heading < 0.0 then
                heading = 360.0
            end
            SetEntityHeading(propObject, heading)

            if IsControlJustPressed(0, 38) then -- "E"
                confirmed = true
                SetEntityAlpha(propObject, 255, false)
                SetEntityCollision(propObject, true, true)
                FreezeEntityPosition(propObject, true)
                lib.hideTextUI()
            end
        end
    end)
end)
