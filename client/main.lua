local headerShown = false
local sendData = false

local function openMenu(data)
    if not data or not next(data) then return end
    SetNuiFocus(true, true)
    headerShown = false
    SendNUIMessage({
        action = 'OPEN_MENU',
        data = table.clone(data)
    })
    sendData = data
end

local function closeMenu()
    headerShown = false
    SetNuiFocus(false)
    SendNUIMessage({
        action = 'CLOSE_MENU'
    })
end

local function showHeader(data)
    if not data or not next(data) then return end
    headerShown = true
    SendNUIMessage({
        action = 'SHOW_HEADER',
        data = table.clone(data)
    })
    sendData = data
end

RegisterNetEvent('qb-menu:client:openMenu', function(data)
    openMenu(data)
end)

RegisterNetEvent('qb-menu:client:closeMenu', function()
    closeMenu()
end)

RegisterNUICallback('clickedButton', function(option)
    if headerShown then headerShown = false end
    PlaySoundFrontend(-1, 'Highlight_Cancel','DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
    SetNuiFocus(false)
    local data = sendData[tonumber(option)]
    if data then
        if data.params.event then
            if data.params.isServer then
                TriggerServerEvent(data.params.event, data.params.args)
            elseif data.params.isCommand then
                ExecuteCommand(data.params.event)
            elseif data.params.isQBCommand then
                TriggerServerEvent('QBCore:CallCommand', data.params.event, data.params.args)
            elseif data.params.isAction then
                data.params.event(data.args)
            else
                TriggerEvent(data.params.event, data.params.args)
            end
        end
    end
    sendData = false
end)

RegisterNUICallback('closeMenu', function()
    headerShown = false
    SetNuiFocus(false)
end)

RegisterCommand('+playerfocus', function()
    if headerShown then
        SetNuiFocus(true, true)
    end
end)

RegisterKeyMapping('+playerFocus', '[qb-menu] Give Menu Focus~', 'keyboard', 'LMENU')

exports('openMenu', openMenu)
exports('closeMenu', closeMenu)
exports('showHeader', showHeader)
exports('clearHistory', clearHistory)
