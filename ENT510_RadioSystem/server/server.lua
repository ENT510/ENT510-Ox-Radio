---@diagnostic disable: missing-parameter

RegisterServerEvent("ent510:salvaCanzone", function(nomeCanzone, urlCanzone)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.insert('INSERT INTO ent_song_list (identifier, nameSong, urlSong) VALUES (?, ?, ?)', {
        xPlayer.identifier,
        nomeCanzone,
        urlCanzone
    }, function(id)
    end)
end)

ESX.RegisterServerCallback("ent510:checkCanzoniSalvate", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.query('SELECT nameSong, urlSong FROM ent_song_list WHERE identifier = ?', { xPlayer.identifier },
        function(result)
            if #result >= 1 then
                cb(result)
            else
                NotifiKaizer(source, Radio.Translate.NotifyNoSong)
                TriggerClientEvent('DisabilitaCamServer', source) 
            end
        end)
end)

RegisterCommand(Radio.PlaceItemCommand, function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local radione = exports.ox_inventory:GetItem(source, Radio.OxItem, false, true)

    if radione >= 1 then
        TriggerClientEvent('ent510:piazzaProp', source, Radio.ItemProp)
        local success = exports.ox_inventory:RemoveItem(source, Radio.OxItem, 1)
        NotifiKaizer(source, Radio.Translate.NotifyYesItem )
    else
        NotifiKaizer(source, Radio.Translate.NotifyNoItem , "fa-solid fa-circle-exclamation" , 'yellow')
    end
end)

RegisterNetEvent('ent510:avviaSong')
AddEventHandler('ent510:avviaSong', function(urlCanzone, nameCanzone, playerCoords)
    for k, v in pairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        local sessionePlayer = GetPlayerRoutingBucket(xPlayer.source)
        local sessioneOwner = GetPlayerRoutingBucket(source)
        if sessionePlayer == sessioneOwner then
            exports.xsound:PlayUrlPos(xPlayer.source, nameCanzone, urlCanzone, 1.0,
                vector3(playerCoords.x, playerCoords.y, playerCoords.z), false)
        end
    end
end)

RegisterNetEvent('ent510:stopSong')
AddEventHandler('ent510:stopSong', function(nameCanzone)
    for k, v in pairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        local sessionePlayer = GetPlayerRoutingBucket(xPlayer.source)
        local sessioneOwner = GetPlayerRoutingBucket(source)
        if sessionePlayer == sessioneOwner then
            exports.xsound:Destroy(xPlayer.source, nameCanzone)
        end
    end
end)

RegisterServerEvent("ent_radio:takeProp")
AddEventHandler("ent_radio:takeProp", function(propNetId, nameCanzone)
    for k, v in pairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        local playerId = source
        local player = ESX.GetPlayerFromId(playerId)
        if player then
            local success = exports.ox_inventory:AddItem(playerId, Radio.OxItem, 1)
            NotifiKaizer(playerId, Radio.Translate.TakeRadioCorr )
        end
    end
end)

RegisterNetEvent('ent510:GestisciVolumeCanzone')
AddEventHandler('ent510:GestisciVolumeCanzone', function(nameCanzone, volume)
    for k, v in pairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        local sessionePlayer = GetPlayerRoutingBucket(xPlayer.source)
        local sessioneOwner = GetPlayerRoutingBucket(source)
        if sessionePlayer == sessioneOwner then
            exports.xsound:setVolume(xPlayer.source, nameCanzone, volume)
        end
    end
end)

RegisterNetEvent('ent510:EliminaCanzone')
AddEventHandler('ent510:EliminaCanzone', function(nameCanzone)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer and xPlayer.identifier and nameCanzone then
        MySQL.rawExecute('DELETE FROM ent_song_list WHERE identifier = ? AND nameSong = ?', { xPlayer.identifier, nameCanzone }, function(rowsChanged)

        end)
    else
        print("Uno dei parametri è nullo o non valido.")
    end
end)

RegisterNetEvent('ent510:GestisciDistanceCanzone')
AddEventHandler('ent510:GestisciDistanceCanzone', function(nameCanzone, distance)
    for k, v in pairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(v)
        local sessionePlayer = GetPlayerRoutingBucket(xPlayer.source)
        local sessioneOwner = GetPlayerRoutingBucket(source)
        if sessionePlayer == sessioneOwner then
            exports.xsound:Distance(xPlayer.source, nameCanzone, distance)
        end
    end
end)

function NotifiKaizer(source, msg , icona , color)
    TriggerClientEvent('ox_lib:notify', source, {
        title = Radio.Translate.TitleNotify,
        description = msg,
        position = 'top-left',
        time = 4000,
        type = 'inform',
        icon = icona,
        iconColor = color
    })
end

function CreateTable()
    local result = MySQL.query.await('SHOW TABLES LIKE ?', { 'ent_song_list' })
    if #result > 0 then
        print("The [^3ent_song_list^7] table already exists in the database")
    else
        MySQL.query([[
            CREATE TABLE IF NOT EXISTS `ent_song_list` (
                `identifier` varchar(46) DEFAULT NULL,
                `nameSong` varchar(50) DEFAULT NULL,
                `urlSong` varchar(50) DEFAULT NULL
              ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
        ]])
        print("The [^4ent_song_list^7] table has been created correctly")
    end
end
if Radio.RunSQL then 
    CreateTable()
end



