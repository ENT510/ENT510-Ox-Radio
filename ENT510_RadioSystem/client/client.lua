
local inCam

lib.registerMenu({
    id = 'ent510_radio',
    title = Radio.Translate.TitleMenu,
    position = Radio.PositionMenu,
    disableInput = Radio.DisableMove,
    onClose = function()
        CamOFF()
    end,
    options = {
        { label = Radio.Translate.MenuTitleSave, description = '', icon = 'fa-solid fa-download',    iconColor = '#4DABF7' },
        { label = Radio.Translate.MenuOpenList,  description = '', icon = 'fa-solid fa-earth-asia',  iconColor = '#4DABF7' },
    },
}, function(selected)
    if selected == 1 then
        local input = lib.inputDialog(Radio.Translate.DialogTitleSave, {
            { type = 'input', label = Radio.Translate.DialogSaveTitle, description = Radio.Translate.DialogSaveTitleDesc, icon = 'fa-solid fa-floppy-disk', placeholder = Radio.Translate.DialogSaveTitlePlaceHolder, required = true, min = 1, max = 100 },
            { type = 'input', label = Radio.Translate.DialogSaveUrl,   description = Radio.Translate.DialogSaveUrlDesc,   icon = 'fa-solid fa-floppy-disk', placeholder = 'https://www.youtube.com/watch?',           required = true, min = 1, max = 100 },
        })

        if not input then
            return lib.showMenu('ent510_radio')
        end
        TriggerServerEvent('ent510:salvaCanzone', input[1], input[2])
        NotificaSucces(Radio.Translate.NotifySongSaved .. ' - ' .. input[1])
        CamOFF()
    elseif selected == 2 then
        ESX.TriggerServerCallback('ent510:checkCanzoniSalvate', function(cb)
            MenuCanzoniSalvate(cb)
        end)
    end
end)

function MenuCanzoniSalvate(cb)
    local options = {}
    for k, v in pairs(cb) do
        table.insert(options,
            { label = '[' .. k .. '] ' .. v.nameSong, icon = 'fa-solid fa-floppy-disk', iconColor = '#FD7E14', args = { urlCanzone = v.urlSong, nomeCanzone = v.nameSong } })
    end
    Wait(50)
    lib.registerMenu({
        id = 'ent510_radio_lista',
        title = Radio.Translate.ListSongTitle,
        position = Radio.PositionMenu,
        disableInput = Radio.DisableMove,
        onClose = function(keyPressed)
            -- print('Menu closed')

            if keyPressed then
                return
                    lib.showMenu('ent510_radio')
            end
        end,
        options = options
    }, function(selected, scrollIndex, args)
        if selected then
            local urlCanzone = args.urlCanzone
            local nameCanzone = args.nomeCanzone
            local playerCoords = GetEntityCoords(PlayerPedId())
            OpenSceltaAzione(urlCanzone, nameCanzone, playerCoords)
        end
    end)
    lib.showMenu('ent510_radio_lista')
end

function OpenSceltaAzione(urlCanzone, nameCanzone, playerCoords)
    lib.registerMenu({
        id = 'action_song',
        title = Radio.Translate.ActionMusic,
        disableInput = Radio.DisableMove,

        position = Radio.PositionMenu,
        onClose = function(keyPressed)
            -- print('Menu closed')
            if keyPressed then
                return
                    lib.showMenu('ent510_radio_lista')
            end
        end,
        options = {
            { label = Radio.Translate.MenuOpt1,  icon = 'fa-solid fa-play',  close = false,           iconColor = '#3BC9DB' },
            { label = Radio.Translate.MenuOpt2,  icon = 'fas fa-sliders-h',  iconColor = '#3BC9DB' },
            { label = Radio.Translate.MenuOpt3,  icon = 'fa-solid fa-stop',  close = false,           iconColor = '#3BC9DB' },
            { label = Radio.Translate.MenuOpt4,  description = '',           icon = 'fas fa-road',    iconColor = '#3BC9DB' },
            { label = Radio.Translate.MenuOpt5,  description = '',           icon = 'fa-solid fa-x',  iconColor = '#4DABF7' },
        }
    }, function(selected, scrollIndex, args)
        if selected == 1 then
            TriggerServerEvent('ent510:avviaSong', urlCanzone, nameCanzone, playerCoords)
            NotificaSucces(Radio.Translate.NotifySongStarted .. ' - ' .. nameCanzone)
        elseif selected == 2 then
            local input = lib.inputDialog(Radio.Translate.DialogTitleVolume, {
                { type = "slider", label = Radio.Translate.DialogVolume, icon = 'fas fa-sliders-h', description = '0.1 / max 1.0', max = 1, step = 0.1 }
            })
            if not input then
                return
                    lib.showMenu('action_song')
            end
            TriggerServerEvent('ent510:GestisciVolumeCanzone', nameCanzone, input[1])
            NotificaSucces(Radio.Translate.NotifyVolChanged .. ' ' .. input[1])
            CamOFF()
        elseif selected == 3 then
            TriggerServerEvent('ent510:stopSong', nameCanzone)
            NotificaSucces(Radio.Translate.SongStopped .. ' - ' .. nameCanzone)
        elseif selected == 4 then
            local input = lib.inputDialog(Radio.Translate.DialogManageDistance, {
                { type = "slider", label = Radio.Translate.DialogDistance, icon = 'fas fa-road', description = 'MIN: 5 MAX: 50', max = 50, step = 1 }
            })
            if not input then
                return
                    lib.showMenu('action_song')
            end
            TriggerServerEvent('ent510:GestisciDistanceCanzone', nameCanzone, input[1])
            NotificaSucces(Radio.Translate.NotifyDistChanged .. ' - ' .. input[1] .. ' ' .. 'MT')

            CamOFF()
        end
        if selected == 5 then
            local NomePlayer = GetPlayerName(PlayerId())
            local cazzoman = lib.alertDialog({
                header = Radio.Translate.Hello .. ' ' .. NomePlayer,
                content = Radio.Translate.ConfirmDelete .. ' ' .. nameCanzone,
                centered = false,
                cancel = true,
                labels = {
                    cancel = Radio.Translate.CancelAction ,
                    confirm = Radio.Translate.DeleteSong
                }
            })
            if cazzoman == 'cancel' then
                return CamOFF()
            end
            NotificaSucces(Radio.Translate.DeletedCurrentSong .. ' - ' .. nameCanzone)
            TriggerServerEvent('ent510:EliminaCanzone', nameCanzone)
            CamOFF()
        end
    end)
    lib.showMenu('action_song')
end

RegisterNetEvent('DisabilitaCamServer')
AddEventHandler('DisabilitaCamServer', function()
    local playerPed = PlayerPedId() 
    FreezeEntityPosition(playerPed, false)
    -- DeleteObject(obj)
    RenderScriptCams(false, true, 1250, 1, 0)
    DestroyCam(cam, false)
    inCam = false
    ClearPedTasks(playerPed)
end)
