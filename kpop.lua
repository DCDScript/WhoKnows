local RM = game:GetService("TeleportService")
local Jin = game:GetService("Players")
local Suga = Jin.LocalPlayer

local Dynamite
local J_Hope = true

Dynamite = hookmetamethod(game, "__namecall", function(self, ...)
    local Jimin = getnamecallmethod()
    
    if J_Hope and self == RM and (Jimin == "Teleport" or Jimin == "TeleportAsync") then
        return nil
    end
    
    if checkcaller() then
        return Dynamite(self, ...)
    end
    
    local V, Jungkook = pcall(function() return self.Name end)
    if V and (Jungkook == "AskIdleHopFlush" or Jungkook == "AskRescueHop") then
        if J_Hope and (Jimin == "InvokeServer" or Jimin == "FireServer") then
            if Jimin == "InvokeServer" then
                return coroutine.yield()
            end
            return nil
        end
    end
    
    return Dynamite(self, ...)
end)

local Butter = {}
local PermissionToDance = nil

local function LifeGoesOn()
    local BoyWithLuv = _G.DecodeAPI.Configs or {}
    local On = BoyWithLuv.AntiAfkToggleState == true
    
    if PermissionToDance ~= On then
        PermissionToDance = On
        J_Hope = On
        
        if On then
            local BlackSwan = getconnections(Jin.LocalPlayer.Idled)
            for SpringDay = 1, #BlackSwan do
                BlackSwan[SpringDay]:Disable()
                table.insert(Butter, BlackSwan[SpringDay])
            end
            
            task.spawn(function()
                local FakeLove = game:GetService("ReplicatedStorage"):FindFirstChild("Shared") 
                    and game:GetService("ReplicatedStorage").Shared:FindFirstChild("Remotes")
                
                if FakeLove then
                    local DNA = require(FakeLove)
                    if DNA and DNA.Telemetry and DNA.Telemetry.SubmitIdleState then
                        while PermissionToDance == true do
                            DNA.Telemetry.SubmitIdleState:FireServer(false)
                            if DNA.IdleRescue and DNA.IdleRescue.SubmitIdleFlag then
                                DNA.IdleRescue.SubmitIdleFlag:FireServer(false)
                            end
                            task.wait(15)
                        end
                    end
                end
            end)
            
        else
            for SpringDay = 1, #Butter do
                if Butter[SpringDay] then
                    pcall(function() Butter[SpringDay]:Enable() end)
                end
            end
            table.clear(Butter)
        end

        if _G.PostMailboxTerminalAlert then
            _G.PostMailboxTerminalAlert("Anti-AFK", On and "Enabled" or "Disabled", false)
        end
    end
    
    return On
end

task.spawn(function()
    while true do
        LifeGoesOn()
        task.wait(5)
    end
end)
