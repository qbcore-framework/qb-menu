local menuOpened = false

local function openMenu(data)
    if not data then return end
    menuOpened = true
    SendNUIMessage({
        action = 'OPEN_MENU',
        data = data
    })
end

local function closeMenu()
    menuOpened = false
    SendNUIMessage({
        action = 'CLOSE_MENU'
    })
end

RegisterNUICallback('clickedButton', function(data)
    PlaySoundFrontend(-1, 'Highlight_Cancel','DLC_HEIST_PLANNING_BOARD_SOUNDS', 1) 
    SetNuiFocus(false)
    if data.isServer then
        TriggerServerEvent(data.event, data.args)
    else
        TriggerEvent(data.event, data.args)
    end
end)

RegisterNUICallback('closeMenu', function()
    SetNuiFocus(false)
end)

RegisterCommand('+playerfocus', function()
    if menuOpened then
        SetNuiFocus(true, true)
    end
end)

RegisterKeyMapping('+playerFocus', 'Give Menu Focus', 'keyboard', 'LMENU')

exports("openMenu", openMenu)
exports("closeMenu", closeMenu)