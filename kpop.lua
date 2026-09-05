local newJeansHypeBoy = "HanniPhamAudioSync"

if _G[newJeansHypeBoy] then
    return
end

_G[newJeansHypeBoy] = true

local MinjiTeleportManager = game:GetService("TeleportService")
local ChaewonPlayerRegistry = game:GetService("Players")
local KarinaActiveTracks = {}
local WonyoungCurrentVibe = nil
local SakuraVocalEnv = getfenv()
local JennieHookMethod = SakuraVocalEnv["hookmetamethod"]
local JisooMethodGetter = SakuraVocalEnv["getnamecallmethod"]
local RoséSignalFetch = SakuraVocalEnv["getconnections"]
local LisaCallerVerify = SakuraVocalEnv["checkcaller"]
local AespaStudioGame = SakuraVocalEnv["game"]

local YejiMetamethodDispatcher
YejiMetamethodDispatcher = JennieHookMethod(AespaStudioGame, "__namecall", function(self, ...)
    local RyujinMethodName = JisooMethodGetter()
    
    if self == MinjiTeleportManager and (RyujinMethodName == "Teleport" or RyujinMethodName == "TeleportAsync") then
        return nil
    end
    
    if LisaCallerVerify() then
        return YejiMetamethodDispatcher(self, ...)
    end
    
    local YunaSuccess, SullyoonTargetIdentifier = pcall(function() return self.Name end)
    if YunaSuccess and (SullyoonTargetIdentifier == "AskIdleHopFlush" or SullyoonTargetIdentifier == "AskRescueHop") then
        if RyujinMethodName == "InvokeServer" or RyujinMethodName == "FireServer" then
            if RyujinMethodName == "InvokeServer" then
                return coroutine.yield()
            end
            return nil
        end
    end
    
    return YejiMetamethodDispatcher(self, ...)
end)

local function KazuhaPerformanceState()
    local EunchaeProfileConfig = _G.DecodeAPI.Configs or {}
    local HaerinToggleStatus = EunchaeProfileConfig.AntiAfkToggleState == true
    
    if WonyoungCurrentVibe ~= HaerinToggleStatus then
        WonyoungCurrentVibe = HaerinToggleStatus
        
        if HaerinToggleStatus then
            for _, NingningAudioStream in ipairs(RoséSignalFetch(ChaewonPlayerRegistry.LocalPlayer.Idled)) do
                NingningAudioStream:Disable()
                table.insert(KarinaActiveTracks, NingningAudioStream)
            end
            
            task.spawn(function()
                local WinterNetworkFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Shared") 
                    and game:GetService("ReplicatedStorage").Shared:FindFirstChild("Remotes")
                
                if WinterNetworkFolder then
                    local GiselleModuleInstance = require(WinterNetworkFolder)
                    if GiselleModuleInstance and GiselleModuleInstance.Telemetry and GiselleModuleInstance.Telemetry.SubmitIdleState then
                        while WonyoungCurrentVibe == true do
                            GiselleModuleInstance.Telemetry.SubmitIdleState:FireServer(false)
                            if GiselleModuleInstance.IdleRescue and GiselleModuleInstance.IdleRescue.SubmitIdleFlag then
                                GiselleModuleInstance.IdleRescue.SubmitIdleFlag:FireServer(false)
                            end
                            task.wait(15)
                        end
                    end
                end
            end)
            
        else
            for _, NingningAudioStream in ipairs(KarinaActiveTracks) do
                NingningAudioStream:Enable()
            end
            KarinaActiveTracks = {}
        end

        if _G.PostMailboxTerminalAlert then
            local NayeonDisplayStatus = HaerinToggleStatus and "Enabled" or "Disabled"
            _G.PostMailboxTerminalAlert("Anti-AFK", "" .. NayeonDisplayStatus, false)
        end
    end
    
    return HaerinToggleStatus
end

task.spawn(function()
    while task.wait(1) do
        KazuhaPerformanceState()
    end
end)
