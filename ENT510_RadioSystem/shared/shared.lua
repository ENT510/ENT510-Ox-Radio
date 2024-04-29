Radio = {}
Radio.PlaceItemCommand = 'radio'                 -- Command For Place Item
Radio.ScenarioEnabled = true                     -- If Radio.ScenarioEnabled is false dont use Animation
-- CAMERA
Radio.CameraOn = false                            -- If Radio.CameraOn is false dont use a Cam
-- OX TARGET
Radio.IconTargetOpen = 'fa-solid fa-headphones'  -- Icon Ox Target Open Radio
Radio.IconTargetTake = 'fa-solid fa-rotate-left' -- Icon Ox Target Take Radio
Radio.DistanceInteraction = 2.5                  -- Distance Interaction Target

Radio.RunSQL = true -- run first time, Automatically creates the table in the database

-- OX ITEM
Radio.ItemProp = 'ba_prop_battle_club_speaker_small' -- Props Radio 'https://forge.plebmasters.de/objects'
Radio.OxItem = 'boombox'                             -- Item Radio / Check Readme

-- MENU OX
Radio.DisableMove = true         -- If Radio.DisableMove is false You can move with the radio menu open
Radio.PositionMenu = 'top-right' -- Position Menu / 'top-left' or 'top-right' or 'bottom-left' or 'bottom-right'

Radio.Translate = {
    -- TARGET
    TargetLabelOpen = 'Open Radio',
    TargetLabelTake = 'Take Radio',
    -- MENU
    TitleMenu = 'ENT510 RADIO',
    ListSongTitle = 'SONGS LIST',
    MenuTitleSave = 'SAVE NEW SONG',
    ActionMusic = 'ACTION MUSIC',
    MenuOpenList = 'OPEN LIST SONGS',
    -- OPTIONS MENU
    MenuOpt1 = 'Start Song',
    MenuOpt2 = 'Manage Volume',
    MenuOpt3 = 'Stop Song',
    MenuOpt4 = 'Manage Distance Range',
    MenuOpt5 = 'Delete Current Song',
    -- DIALOG
    DialogTitleSave = 'SAVE SONG',
    DialogTitleVolume = 'MANAGE VOLUME',
    DialogManageDistance = 'MANAGE DISTANCE',
    DialogDistance = 'Distance',
    DialogVolume = 'Volume',
    DialogSaveTitle = 'Save Title',
    DialogSaveTitleDesc = 'Save Specific Song Title',
    DialogSaveTitlePlaceHolder = 'Gennaro Cozza - Sucamocazz',
    DialogSaveUrl = 'Save URL',
    DialogSaveUrlDesc = 'Save a song URL from YouTube',
    -- NOTIFY
    TitleNotify = 'ENT510 Radio Ox',
    NotifySongSaved = 'Song Saved Successfully | Title: ',
    NotifySongStarted = 'Song Started Successfully | Title: ',
    NotifyVolChanged = 'Volume Changed Correctly at : ',
    SongStopped = 'Song Stopped Successfully | Title: ',
    NotifyDistChanged = 'Distance Changed Correctly at: ',
    NotifyNoItem = 'You do not have the radio item in your inventory.',
    NotifyYesItem = 'Radio Placed Correctly',
    NotifyNoSong = 'You Have No Saved Songs',
    TakeRadioCorr = 'Radio Recovered Successfully',
    DeletedCurrentSong = 'You Have deleted The song With Name:',
    -- Text Ui Scaleform
    PlaceProp = '[E] - Place Prop',
    CancProp = '[CANC] - Delete Prop',
    RotProp = '[WHEEL MOUSE] - Rotate Prop',
    -- ALLERT
    ConfirmDelete = 'Are you sure you want to delete the song with the title:',
    Hello = 'HI',
    CancelAction = 'CANCEL ACTION',
    DeleteSong = 'DELETE CURRENT SONG'
}
