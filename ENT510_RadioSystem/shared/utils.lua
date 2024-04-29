
function NotificaSucces(msg , color)
    lib.notify({
        title = Radio.Translate.TitleNotify,
        description = msg,
        position = 'top-left',
        time = 4000,
        type = 'inform',
        icon = 'circle-check',
        iconColor = color
    })
end