local QBCore = exports['qb-core']:GetCoreObject()
local Config, Zones, PlayerData = load(LoadResourceFile(GetCurrentResourceName(), 'config.lua'))()
local MenuActive, TooltipActive, HasFocus, InZone, CurrentZoneOptions = false, false, false, false, {}

local Functions = {
    AddCircleZone = function(self, name, center, radius, options, menuoptions)
        Zones[name] = CircleZone:Create(center, radius, options)
        Zones[name].menuoptions = menuoptions

        Zones[name]:onPlayerInOut(function(isInside, point)
            if isInside then
                if Config.Debug then
                    print('Entered Zone')
                end
                TooltipActive = true
                CurrentZoneOptions = menuoptions
                InZone = true
                SendNUIMessage({
                    action = "OpenTooltip",
                    menu = self:CloneTable(menuoptions)
                })
            else
                if Config.Debug then
                    print('Exited Zone')
                end
                TooltipActive = false
                InZone = false
                SendNUIMessage({
                    action = "CloseMenuFull"
                })
            end
        end)
    end,

    AddBoxZone = function(self, name, center, length, width, options, menuoptions)
        Zones[name] = BoxZone:Create(center, length, width, options)
        Zones[name].menuoptions = menuoptions

        Zones[name]:onPlayerInOut(function(isInside, point)
            if isInside then
                if Config.Debug then
                    print('Entered Zone')
                end
                TooltipActive = true
                CurrentZoneOptions = menuoptions
                InZone = true
                SendNUIMessage({
                    action = "OpenTooltip",
                    menu = self:CloneTable(menuoptions)
                })
            else
                if Config.Debug then
                    print('Exited Zone')
                end
                TooltipActive = false
                InZone = false
                SendNUIMessage({
                    action = "CloseMenuFull"
                })
            end
        end)
    end,

    AddPolyZone = function(self, name, points, options, menuoptions)
		Zones[name] = PolyZone:Create(points, options)
		Zones[name].menuoptions = menuoptions

        Zones[name]:onPlayerInOut(function(isInside, point)
            if isInside then
                if Config.Debug then
                    print('Entered Zone')
                end
                TooltipActive = true
                CurrentZoneOptions = menuoptions
                InZone = true
                SendNUIMessage({
                    action = "OpenTooltip",
                    menu = self:CloneTable(menuoptions)
                })
            else
                if Config.Debug then
                    print('Exited Zone')
                end
                TooltipActive = false
                InZone = false
                SendNUIMessage({
                    action = "CloseMenuFull"
                })
            end
        end)
    end,

    AddEntityZone = function(self, name, entity, options, menuoptions)
		Zones[name] = EntityZone:Create(entity, options)
        Zones[name].menuoptions = menuoptions

        Zones[name]:onPlayerInOut(function(isInside, point)
            if isInside then
                if Config.Debug then
                    print('Entered Zone')
                end
                TooltipActive = true
                CurrentZoneOptions = menuoptions
                InZone = true
                SendNUIMessage({
                    action = "OpenTooltip",
                    menu = self:CloneTable(menuoptions)
                })
            else
                if Config.Debug then
                    print('Exited Zone')
                end
                TooltipActive = false
                InZone = false
                SendNUIMessage({
                    action = "CloseMenuFull"
                })
            end
        end)
	end,

    AddComboZone = function(self, zones, options, menuoptions)
		Zones[name] = ComboZone:Create(zones, options)
		Zones[name].menuoptions = menuoptions

        Zones[name]:onPlayerInOut(function(isInside, point, zone)
            if isInside then
                if Config.Debug then
                    print('Entered Zone')
                end
                TooltipActive = true
                CurrentZoneOptions = menuoptions
                InZone = true
                SendNUIMessage({
                    action = "OpenTooltip",
                    menu = self:CloneTable(menuoptions)
                })
            else
                if Config.Debug then
                    print('Exited Zone')
                end
                TooltipActive = false
                InZone = false
                SendNUIMessage({
                    action = "CloseMenuFull"
                })
            end
        end)
    end,

    RemoveZone = function(self, name)
		if not Zones[name] then return end
		if Zones[name].destroy then
			Zones[name]:destroy()
		end
		Zones[name] = nil
	end,

    GetZoneData = function(self, name)
		return Zones[name]
	end,

    EnableMenuFocus = function(self, force, currOptions)
        if (TooltipActive and InZone and not MenuActive) or force then
            CurrentZoneOptions = currOptions or CurrentZoneOptions
            SetNuiFocus(true, true)
            SendNUIMessage({
                action = "OpenUI",
                menu = self:CloneTable(CurrentZoneOptions)
            })
            HasFocus, MenuActive = true, true
        end
    end,

    DisableMenuFocus = function(self, force)
        if (MenuActive and not HasFocus) or force then
            SetNuiFocus(false, false)
            HasFocus = false
        end
    end,

    CloneTable = function(self, table)
		local copy = {}
		for k,v in pairs(table) do
			if type(v) == 'table' then
				copy[k] = self:CloneTable(v)
			else
				if type(v) == 'function' then v = nil end
				copy[k] = v
			end
		end
		return copy
	end,
}

exports("AddCircleZone", function(name, center, radius, options, menuoptions)
    Functions:AddCircleZone(name, center, radius, options, menuoptions)
end)

exports("AddBoxZone", function(name, center, length, width, options, menuoptions)
    Functions:AddBoxZone(name, center, length, width, options, menuoptions)
end)

exports("AddPolyZone", function(name, points, options, menuoptions)
    Functions:AddPolyZone(name, points, options, menuoptions)
end)

exports("AddComboZone", function(zones, options, menuoptions)
    Functions:AddComboZone(zones, options, menuoptions)
end)

exports("AddEntityZone", function(name, entity, options, menuoptions)
    Functions:AddEntityZone(name, entity, options, menuoptions)
end)

exports("RemoveZone", function(name)
    Functions:RemoveZone(name)
end)

exports("FetchFunctions", function()
    return Functions
end)

RegisterNUICallback('SelectOption', function(option, cb)
    SetNuiFocus(false, false)
    local data = CurrentZoneOptions.buttons[option]
    CreateThread(function()
        Wait(50)
        if data.action then
            data.action()
        elseif data.event then
            if data.type == "client" then
                TriggerEvent(data.event, data)
            elseif data.type == "server" then
                TriggerServerEvent(data.event, data)
            elseif data.type == "command" then
                ExecuteCommand(data.event)
            elseif data.type == "qbcommand" then
                TriggerServerEvent('QBCore:CallCommand', data.event, data)
            else
                TriggerEvent(data.event, data)
            end
        else
            if Config.Debug then
                print("No trigger setup")
            end
        end
    end)
end)

RegisterNUICallback('CloseMenu', function(data, cb)
    SetNuiFocus(false, false)
    HasFocus, MenuActive = false, false
end)

CreateThread(function()
    RegisterCommand('+playerMenuFocus', function()
        Functions:EnableMenuFocus(false)
    end, false)
    RegisterCommand('-playerMenuFocus', function()
        Functions:DisableMenuFocus(false)
    end, false)
    RegisterKeyMapping("+playerMenuFocus", "Enable Menu Focus~", "keyboard", "LMENU")
    TriggerEvent("chat:removeSuggestion", "/+playerMenuFocus")
    TriggerEvent("chat:removeSuggestion", "/-playerMenuFocus")

    if Config.CircleZones and next(Config.CircleZones) then
        for k, v in pairs(Config.CircleZones) do
            Functions:AddCircleZone(v.name, v.coords, v.radius, {
                name = v.name,
                debugPoly = v.debugPoly
            }, v.menuoptions)
        end
    elseif Config.CircleZones == nil then
        if Config.Debug then
            print("Config.CircleZones doesn't exist in the config.")
        end
    end

    if Config.BoxZones and next(Config.BoxZones) then
        for k, v in pairs(Config.BoxZones) do
            Functions:AddBoxZone(v.name, v.coords, v.length, v.width, {
                name = v.name,
                heading = v.heading,
                debugPoly = v.debugPoly,
                minZ = v.minZ,
                maxZ = v.maxZ
            }, v.menuoptions)
        end
    elseif Config.BoxZones == nil then
        if Config.Debug then
            print("Config.BoxZones doesn't exist in the config.")
        end
    end

    if Config.PolyZones and next(Config.PolyZones) then
        for k, v in pairs(Config.PolyZones) do
            Functions:AddPolyZone(v.name, v.points, {
                name = v.name,
                debugPoly = v.debugPoly,
                minZ = v.minZ,
                maxZ = v.maxZ
            }, v.menuoptions)
        end
    elseif Config.PolyZones == nil then
        if Config.Debug then
            print("Config.PolyZones doesn't exist in the config.")
        end
    end
end)

RegisterNetEvent('qb-menu:client:OpenMenu', function(data)
    if data.OpenAction ~= 'OpenTooltip' then
        Functions:EnableMenuFocus(true, data.menuoptions)
    else
        TooltipActive = true
    end
    SendNUIMessage({
        action = data.OpenAction,
        menu = data.menuoptions
    })
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('QBCore:ClientOnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerData.gang = GangInfo
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
    PlayerData = val
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		PlayerData = QBCore.Functions.GetPlayerData()
	end
end)