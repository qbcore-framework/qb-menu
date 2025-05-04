local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

local headerShown = false
local sendData = nil
local menuFocus = false

-- Functions

local function setMenuFocus(state)
    menuFocus = state
    SetNuiFocus(state, state)
end

local function sortData(data, skipfirst)
    local header = data[1]
    local tempData = data
    if skipfirst then table.remove(tempData,1) end
    table.sort(tempData, function(a,b) return a.header < b.header end)
    if skipfirst then table.insert(tempData,1,header) end
    return tempData
end

local function openMenu(data, sort, skipFirst)
    if not data or not next(data) then return end
    if sort then data = sortData(data, skipFirst) end
	for _,v in pairs(data) do
		if v["icon"] then
			if QBCore.Shared.Items[tostring(v["icon"])] then
				if not string.find(QBCore.Shared.Items[tostring(v["icon"])].image, "//") and not string.find(v["icon"], "//") then
                    v["icon"] = "nui://qb-inventory/html/images/"..QBCore.Shared.Items[tostring(v["icon"])].image
				end
			end
		end
	end
    setMenuFocus(true)
    headerShown = false
    sendData = data
    SendNUIMessage({
        action = 'OPEN_MENU',
        data = table.clone(data)
    })
end

local function closeMenu()
    sendData = nil
    headerShown = false
    setMenuFocus(false)
    SendNUIMessage({
        action = 'CLOSE_MENU'
    })
end

local function showHeader(data)
    if not data or not next(data) then return end
    headerShown = true
    sendData = data
    SendNUIMessage({
        action = 'SHOW_HEADER',
        data = table.clone(data)
    })
end

-- Events

RegisterNetEvent('qb-menu:client:openMenu', function(data, sort, skipFirst)
    openMenu(data, sort, skipFirst)
end)

RegisterNetEvent('qb-menu:client:closeMenu', function()
    closeMenu()
end)

-- NUI Callbacks

RegisterNUICallback('clickedButton', function(option, cb)
    if headerShown then headerShown = false end
    PlaySoundFrontend(-1, 'Highlight_Cancel', 'DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
    setMenuFocus(false)
    if sendData then
        local data = sendData[tonumber(option)]
        sendData = nil
        if data.action ~= nil then
            data.action()
            cb('ok')
            return
        end
        if data then
            if data.params.event then
                if data.params.isServer then
                    TriggerServerEvent(data.params.event, data.params.args)
                elseif data.params.isCommand then
                    ExecuteCommand(data.params.event)
                elseif data.params.isQBCommand then
                    TriggerServerEvent('QBCore:CallCommand', data.params.event, data.params.args)
                elseif data.params.isAction then
                    data.params.event(data.params.args)
                else
                    TriggerEvent(data.params.event, data.params.args)
                end
            end
        end
    end
    cb('ok')
end)


RegisterNUICallback('closeMenu', function(_, cb)
    headerShown = false
    sendData = nil
    setMenuFocus(false)
    cb('ok')
    TriggerEvent("qb-menu:client:menuClosed")
end)

-- Command and Keymapping

RegisterCommand('playerfocus', function()
    if headerShown and not menuFocus then
        setMenuFocus(true)
    end
end)

RegisterKeyMapping('playerFocus', 'Give Menu Focus', 'keyboard', 'LMENU')

-- Exports

exports('openMenu', openMenu)
exports('closeMenu', closeMenu)
exports('showHeader', showHeader)
