local RM = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Suga = Players.LocalPlayer

local hasHook = typeof(hookmetamethod) == "function" and typeof(getnamecallmethod) == "function" and typeof(checkcaller) == "function"
local hasGetConnections = typeof(getconnections) == "function"
local hasNewClosure = typeof(newcclosure) == "function"

if not hasHook then
    warn("[Anti-AFK] hookmetamethod not supported on this executor - teleport/hop block disabled")
end

local J_Hope = true
local Dynamite
local oldNamecall

if hasHook then
    local ok, err = pcall(function()
        Dynamite = hookmetamethod(game, "__namecall", hasNewClosure and newcclosure(function(self, ...)
            local Jimin
            local ok2, result = pcall(getnamecallmethod)
            if not ok2 then return Dynamite(self, ...) end
            Jimin = result
            
            if checkcaller() then
                return Dynamite(self, ...)
            end
            if J_Hope and self == RM then
                if Jimin == "Teleport" or Jimin == "TeleportAsync" or Jimin == "TeleportToPrivateServer" or Jimin == "TeleportToPlaceInstance" then
                    return nil
                end
            end
            
            local success, remoteName = pcall(function() return self.Name end)
            if success and (remoteName == "AskIdleHopFlush" or remoteName == "AskRescueHop") then
                if J_Hope and (Jimin == "InvokeServer" or Jimin == "FireServer") then
                    if Jimin == "InvokeServer" then
                        return nil
                    end
                    return nil
                end
            end
            
            return Dynamite(self, ...)
        end) or function(self, ...)
            local Jimin
            local ok2, result = pcall(getnamecallmethod)
            if not ok2 then return Dynamite(self, ...) end
            Jimin = result
            
            if checkcaller() then
                return Dynamite(self, ...)
            end
            if J_Hope and self == RM and (Jimin == "Teleport" or Jimin == "TeleportAsync") then
                return nil
            end
            local V, Jungkook = pcall(function() return self.Name end)
            if V and (Jungkook == "AskIdleHopFlush" or Jungkook == "AskRescueHop") then
                if J_Hope and (Jimin == "InvokeServer" or Jimin == "FireServer") then
                    if Jimin == "InvokeServer" then return nil end
                    return nil
                end
            end
            return Dynamite(self, ...)
        end)
    end)
    if not ok then
        warn("[Anti-AFK] Failed to hook __namecall: " .. tostring(err))
        hasHook = false
    end
end

local Butter = {}
local PermissionToDance = nil
local TelemetryThread = nil

local function safeDisableIdled()
    if not hasGetConnections then return end
    if not Suga then return end
    
    local ok, connections = pcall(getconnections, Suga.Idled)
    if not ok or typeof(connections) ~= "table" then return end
    
    for i = 1, #connections do
        local conn = connections[i]
        local ok2 = pcall(function()
            if conn and conn.Disable then
                conn:Disable()
                table.insert(Butter, conn)
            end
        end)
    end
end

local function safeEnableIdled()
    for i = 1, #Butter do
        local conn = Butter[i]
        pcall(function()
            if conn and conn.Enable then
                conn:Enable()
            end
        end)
    end
    if table.clear then
        pcall(table.clear, Butter)
    else
        for i = #Butter, 1, -1 do Butter[i] = nil end
    end
end

local function startTelemetryLoop()
    if TelemetryThread then
        pcall(task.cancel, TelemetryThread)
        TelemetryThread = nil
    end
    
    TelemetryThread = task.spawn(function()
        local Shared = nil
        local FakeLove = nil
        local DNA = nil
        
        for _ = 1, 10 do
            local ok1 = pcall(function()
                Shared = ReplicatedStorage:FindFirstChild("Shared")
                if Shared then
                    FakeLove = Shared:FindFirstChild("Remotes")
                end
            end)
            if FakeLove then break end
            task.wait(0.5)
            if PermissionToDance ~= true then return end
        end
        
        if not FakeLove then return end
        
        local ok, result = pcall(require, FakeLove)
        if not ok or not result then return end
        DNA = result
        
        if not DNA or not DNA.Telemetry or not DNA.Telemetry.SubmitIdleState then
            return
        end
        while PermissionToDance == true do
            local ok2 = pcall(function()
                DNA.Telemetry.SubmitIdleState:FireServer(false)
                if DNA.IdleRescue and DNA.IdleRescue.SubmitIdleFlag then
                    DNA.IdleRescue.SubmitIdleFlag:FireServer(false)
                end
            end)
            if not ok2 then
                task.wait(15)
            else
                task.wait(15)
            end
        end
    end)
end

local function stopTelemetryLoop()
    if TelemetryThread then
        pcall(task.cancel, TelemetryThread)
        TelemetryThread = nil
    end
end

local function LifeGoesOn()
    local ok, isOn = pcall(function()
        local cfg = _G.DecodeAPI and _G.DecodeAPI.Configs
        if not cfg then return false end
        return cfg.AntiAfkToggleState == true
    end)
    
    local On = ok and isOn or false
    
    if PermissionToDance ~= On then
        PermissionToDance = On
        J_Hope = On
        
        if On then
            pcall(safeDisableIdled)
            pcall(startTelemetryLoop)
        else
            pcall(safeEnableIdled)
            pcall(stopTelemetryLoop)
        end

        pcall(function()
            if _G.PostMailboxTerminalAlert then
                _G.PostMailboxTerminalAlert("Anti-AFK", On and "Enabled" or "Disabled", false)
            end
        end)
    end
    
    return On
end

task.spawn(function()
    while true do
        local ok, err = pcall(LifeGoesOn)
        if not ok then
            warn("[Anti-AFK] LifeGoesOn error: " .. tostring(err))
        end
        task.wait(3)
    end
end)

pcall(LifeGoesOn)
