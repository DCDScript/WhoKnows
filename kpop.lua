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

return(function(...)local i={"VSuPkgucazWwWg+7WSbnkgWNLZbmt1bnqzyPOT0hHZbPWXRwJT0OOTpmLTuhivycw74ENc97O7JiJ7Q8O1xil79/3Z4hl1xMx";"yZqrHJ.kBI]l*iKnq*#","ylSkTp[J6^)qimhZ";"yZqc:O6nUh","Vbowp1V==";"VZ+DHZm==","yfQ?]\"uf","V8+Dq8G==";"V8dNV1d7r";"Vgyni8+3=";"yfQ?*bc67V";"VB0NOgd8r1doVfhqSP+B=","VmOlkRxhBmhqkPh/o","y4T+oO_2egDu&@","Vg07iT0V=";"VBbnyckhKcD7ER9DicG==","y_4(Ak"}local function m(m)return i[m+27622]end for m,k in ipairs({{1,17},{1;14};{15;17}})do while k[1]<k[2]do i[k[1]],i[k[2]],k[1],k[2]=i[k[2]],i[k[1]],k[1]+1,k[2]-1 end end do local m=i local k={[")"]=82,l=16;U=39,["%"]=75;W=50,["<"]=31,["`"]=74,["#"]=2;H=6;["?"]=40,["/"]=36;g=38,a=7;I=28;h=66,E=73,["@"]=5;["3"]=83,j=52,P=49;["1"]=64,R=54;m=71;["."]=26;n=80;["7"]=60;Y=69,p=18,O=76,["4"]=34;F=43;[";"]=46;f=30,["2"]=9,Q=55;["&"]=41;["5"]=47;N=19;J=68;c=32,["]"]=53;["$"]=58,C=77,L=61,["^"]=1;d=11;["9"]=45;X=4,["!"]=3,s=79;t=0;i=70;["0"]=12,q=24;u=35,["\\"]=57,e=8;A=21,V=84,r=67;K=20;[">"]=62,["6"]=22,["="]=78;D=25;_=37;["+"]=27;["8"]=48;B=56;["("]=33;o=63;["-"]=29;["\'"]=14,T=72,["["]=17,M=42;[":"]=81,["\""]=59;Z=23,S=13,k=10;G=15,[","]=51,b=65;["*"]=44}local H=table.insert local A={["1"]=24,o=53;B=20;P=17;R=18;M=32;["/"]=8,d=22,n=1;a=58,["4"]=38,u=7;E=4;["5"]=44;t=47;p=39;["7"]=13,f=14,V=48,H=45,z=11,["6"]=59;K=2,S=26,C=40;["2"]=31,s=10;v=15,["8"]=29,D=5;w=61,b=23,Q=3,l=36,W=50;Z=25;r=43,["0"]=6;x=51;["+"]=54,L=46,X=30,g=28;i=33;y=55,m=16;U=9,J=35,j=42,N=57,e=62;c=12,O=37;Y=63;["3"]=56;F=34,I=49,["9"]=19,G=0;k=52,q=41;h=21;T=27,A=60}local s=table.concat local u=string.len local e=math.floor local j=type local F=string.char local t=string.sub for i=1,#m,1 do local a=m[i]if j(a)=="string"then local j=t(a,1,1)if j=="V"then a=t(a,2)local k=u(a)local j={}local b=1 local K=0 local v=0 while b<=k do local i=t(a,b,b)local m=A[i]if m then K=K+m*(64^((3-v)))v=v+1 if v==4 then v=0 local i=e(K/65536)local m=e((K%65536)/256)local k=K%256 H(j,F(i,m,k))K=0 end elseif i=="="then H(j,F(e(K/65536)))if b>=k or t(a,b+1,b+1)~="="then H(j,F(e((K%65536)/256)))end break end b=b+1 end m[i]=s(j)elseif j=="y"then a=t(a,2)local A=u(a)local j={}local b=1 while b<=A do local i=(A-b)+1 local m=i>=5 and 5 or i local s=0 local u=m>1 for i=0,4,1 do local H if i<m then local m=t(a,b+i,b+i)H=k[m]if not H then u=false break end else H=84 end s=s*85+H end if u then local i=e(s/16777216)%256 local k=e(s/65536)%256 local A=e(s/256)%256 local u=s%256 if m==5 then H(j,F(i,k,A,u))elseif m==4 then H(j,F(i,k,A))elseif m==3 then H(j,F(i,k))elseif m==2 then H(j,F(i))end end b=b+m end m[i]=s(j)end end end end return(function(u,e,i,s,H,A,j,v,K,y,b,J,c,a,h,k,t,S,F)J,F,K,b,a,v,c,k,t,h,S,y=function(i,m)local H=K(m)local A=function(...)return k(i,{...},m,H)end return A end,{},function(i)for m=1,#i,1 do t[i[m]]=t[i[m]]+1 end if A then local k=A(true)local H=u(k)H[m(-27614)],H[m(-27620)],H[m(-27618)]=i,v,function()return 1388943 end return k else return s({},{[m(-27620)]=v;[m(-27614)]=i;[m(-27618)]=function()return 1388943 end})end end,0,function()b=b+1 t[b]=1 return b end,function(i)local m,k=1,i[1]while k do t[k],m=t[k]-1,1+m if 0==t[k]then t[k],F[k]=nil,nil end k=i[m]end end,function(i,m)local H=K(m)local A=function()return k(i,{},m,H)end return A end,function(k,A,s,u)local j,F,t,a,b while k do if 9274848>k then if k<4357013 then j,k={},i[m(-27605)]elseif 6584745>k then k=8346623 elseif k<7821250 then j,t=m(-27611),m(-27619)k=i[j]b=m(-27621)F=i[t]b,a=F[b],m(-27607)t={b(F,a)}j=k(H(t))k=j()j,k={},i[m(-27613)]else k=7606107>7469294 k=k and 10203074 or 2840413 end else if k<12287880 then F=m(-27608)j=i[F]F=m(-27617)k=j[F]F=60 j=k(F)j=m(-27610)k=i[j]F=S(7295878,{})j=k(F)k=8346623 elseif k<14603122 then j,a=m(-27611),m(-27607)k=i[j]t=m(-27619)F=i[t]b=m(-27621)b=F[b]t={b(F,a)}j=k(H(t))k=j()k,j=i[m(-27609)],{}elseif 15456804>k then t=m(-27608)j=i[t]t,F=m(-27615),A k=j[t]t=y(16080050,{})j=k(t)t=m(-27608)j=i[t]t=m(-27615)k=j[t]t=y(5873613,{})j=k(t)k,j=i[m(-27606)],{}else F=c(14372687,{})j=m(-27610)k=i[j]j=k(F)j,k={},i[m(-27612)]end end end k=#u return H(j)end,{},function(i)t[i]=t[i]-1 if 0==t[i]then t[i],F[i]=nil,nil end end,function(i,m)local H=K(m)local A=function(A,s)return k(i,{A,s},m,H)end return A end,function(i,m)local H=K(m)local A=function(A,s,u)return k(i,{A,s,u},m,H)end return A end return(J(14833558,{}))(H(j))end)(getmetatable,select,getfenv and getfenv()or _ENV,setmetatable,unpack or table[m(-27616)],newproxy,{...})end)(...)
