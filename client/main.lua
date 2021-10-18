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
exports('clearHistory', clearHistory)


--[[
EXAMPLE MENU
--]]


RegisterCommand("qbmenutest", function(source, args, raw)
    openMenu({
        {
            header = "Main Title",
            isMenuHeader = true, -- Set to true to make a nonclickable title
        },
        {
            header = "Sub Menu Button",
            txt = "This goes to a sub menu",
            params = {
                event = "qb-menu:client:testMenu2",
                args = {
                    number = 1,
                }
            }
        },
    })
end)

RegisterNetEvent('qb-menu:client:testMenu2', function(data)
    local number = data.number
    openMenu({
        {
            header = "< Go Back",
        },
        {
            header = "Number: "..number,
            txt = "Other",
            params = {
                event = "qb-menu:client:testButton",
                args = {
                    message = "This was called by clicking this button"
                }
            }
        },
    })
end)

RegisterNetEvent('qb-menu:client:testButton', function(data)
    TriggerEvent('QBCore:Notify', data.message)
end)