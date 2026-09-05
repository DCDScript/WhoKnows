local JennieTrackSession = "KPOPARMY2612422"

if _G[JennieTrackSession] then
    return
end

_G[JennieTrackSession] = true

local MinjiService = game:GetService("TeleportService")
local ChaewonPlayers = game:GetService("Players")
local KarinaActiveConnections = {}
local WonyoungToggleState = nil
local SakuraEnv = getfenv()
local JennieHookMeta = SakuraEnv["hookmetamethod"]
local JisooNamecall = SakuraEnv["getnamecallmethod"]
local RoseGetConnections = SakuraEnv["getconnections"]
local LisaCheckCaller = SakuraEnv["checkcaller"]
local AespaGame = SakuraEnv["game"]

local YejiNamecallHook
YejiNamecallHook = JennieHookMeta(AespaGame, "__namecall", function(self, ...)
    local RyujinMethod = JisooNamecall()
    
    if self == MinjiService and (RyujinMethod == "Teleport" or RyujinMethod == "TeleportAsync") then
        print("[Anti-Hop] Blocked a server hop attempt!")
        return nil
    end
    
    if LisaCheckCaller() then
        return YejiNamecallHook(self, ...)
    end
    
    local YunaSuccess, SullyoonName = pcall(function() return self.Name end)
    if YunaSuccess and (SullyoonName == "AskIdleHopFlush" or SullyoonName == "AskRescueHop") then
        if RyujinMethod == "InvokeServer" or RyujinMethod == "FireServer" then
            print("[Anti-Hop] Blocked anti-cheat triggering remote: " .. SullyoonName)
            if RyujinMethod == "InvokeServer" then
                return coroutine.yield()
            end
            return nil
        end
    end
    
    return YejiNamecallHook(self, ...)
end)

local function KazuhaSyncState()
    local EunchaeConfigs = _G.DecodeAPI.Configs or {}
    local HaerinState = EunchaeConfigs.AntiAfkToggleState == true
    
    if WonyoungToggleState ~= HaerinState then
        WonyoungToggleState = HaerinState
        
        if HaerinState then
            for _, NingningConn in ipairs(RoseGetConnections(ChaewonPlayers.LocalPlayer.Idled)) do
                NingningConn:Disable()
                table.insert(KarinaActiveConnections, NingningConn)
            end
            
            task.spawn(function()
                local WinterRemotesFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Shared") 
                    and game:GetService("ReplicatedStorage").Shared:FindFirstChild("Remotes")
                
                if WinterRemotesFolder then
                    local GiselleRemotesMod = require(WinterRemotesFolder)
                    if GiselleRemotesMod and GiselleRemotesMod.Telemetry and GiselleRemotesMod.Telemetry.SubmitIdleState then
                        while WonyoungToggleState == true do
                            GiselleRemotesMod.Telemetry.SubmitIdleState:FireServer(false)
                            if GiselleRemotesMod.IdleRescue and GiselleRemotesMod.IdleRescue.SubmitIdleFlag then
                                GiselleRemotesMod.IdleRescue.SubmitIdleFlag:FireServer(false)
                            end
                            task.wait(15)
                        end
                    end
                end
            end)
            
        else
            for _, NingningConn in ipairs(KarinaActiveConnections) do
                NingningConn:Enable()
            end
            KarinaActiveConnections = {}
        end

        if _G.PostMailboxTerminalAlert then
            local NayeonStatusText = HaerinState and "Enabled" or "Disabled"
            _G.PostMailboxTerminalAlert("Anti-AFK", "" .. NayeonStatusText, false)
        end
        print("Anti-AFK State Changed: " .. tostring(HaerinState))
    end
    
    return HaerinState
end

task.spawn(function()
    while task.wait(1) do
        KazuhaSyncState()
    end
end)
