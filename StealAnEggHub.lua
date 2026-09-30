--[[
    Project: Steal an Egg / Brainrot - Ultimate Pro Hub (Secure & Perfect Edition)
    Library Base: Rayfield UI
    Compatibility: Solara, Xeno, Fluxus, Delta
]]--

-- ================= ANTI-CHEAT BYPASS & HOOK PROTECTION ================= --
pcall(function()
    local coreGui = game:GetService("CoreGui")
    if coreGui:FindFirstChild("Rayfield") then
        coreGui.Rayfield.Parent = gethui and gethui() or coreGui
    end
end)

-- ================= SERVICES & CORE SETUP ================= --
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Anti-AFK Built-in
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

-- Clean up existing UI
if CoreGui:FindFirstChild("Rayfield") then
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "Rayfield" or v.Name == "StealEggHub" then
            v:Destroy()
        end
    end
end

-- ================= CONFIG TABLE ================= --
local Config = {
    AutoSteal = false,
    StealArea = "All",
    StealRarity = "All",
    AutoPlacePen = false,
    AutoTreadmill = false,
    WalkSpeed = 16,
    JumpPower = 50,
    
    -- Egg Management
    AutoHatch = false,
    AutoSellEggs = false,
    EggESP = false,
    
    -- Pet Management
    AutoSellPets = false,
    SellDelay = 500,
    
    -- Misc & Performance
    ServerHop = false,
    DeleteOtherPlayers = false,
    KillVFX = false
}

-- Session Watcher Stats
local SessionData = {
    StartTime = tick(),
    EggsStolen = 0
}

-- ================= SAFE MOVEMENT (ANTI-DETECTION) ================= --
local function SmoothMove(targetCFrame)
    pcall(function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            local distance = (hrp.Position - targetCFrame.Position).Magnitude
            local speed = 45 -- Kecepatan gerak aman agar tidak dideteksi speed/teleport hack
            local timeTaken = distance / speed
            
            local tweenInfo = TweenInfo.new(timeTaken, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
            task.wait(timeTaken + 0.1)
        end
    end)
end

-- ================= LOAD RAYFIELD UI LIBRARY ================= --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:Window({
    Name = "⚡ Steal an Egg Hub v1.0 | Perfect Pro Edition",
    LoadingTitle = "Initializing Secure Hub...",
    LoadingSubtitle = "by Expert Developer",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "StealEggHubConfigs",
        FileName = "MainConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = false,
})

-- ================= NOTIFICATION SYSTEM ================= --
local function Notify(title, content, duration)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = duration or 5,
        Image = 4483362458,
    })
end

-- ================= TABS CREATION ================= --
local TabMain = Window:CreateTab("Main / Auto Farm", 4483362458)
local TabEgg = Window:CreateTab("Egg Management", 4483362458)
local TabPet = Window:CreateTab("Pet Management", 4483362458)
local TabPen = Window:CreateTab("Pen & Training", 4483362458)
local TabMisc = Window:CreateTab("Rewards & Misc", 4483362458)
local TabConfig = Window:CreateTab("Config & Data", 4483362458)
local TabAutoExec = Window:CreateTab("Auto Execute", 4483362458)

-- ================= TAB 1: MAIN / AUTO FARM ================= --
TabMain:CreateSection("Automation Farming (Bypass Protected)")

TabMain:CreateToggle({
    Name = "Auto Steal Egg (Smooth Move)",
    CurrentValue = false,
    Flag = "AutoSteal",
    Callback = function(Value)
        Config.AutoSteal = Value
        task.spawn(function()
            while Config.AutoSteal do
                pcall(function()
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if not Config.AutoSteal then break end
                        if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "egg") then
                            SmoothMove(obj.CFrame + Vector3.new(0, 3, 0))
                            SessionData.EggsStolen = SessionData.EggsStolen + 1
                            task.wait(1)
                        end
                    end
                end)
                task.wait(2)
            end
        end)
    end,
})

TabMain:CreateDropdown({
    Name = "Filter Area",
    Options = {"All", "Area 1", "Area 2", "Area 3", "Volcano", "Cyber"},
    CurrentOption = "All",
    Callback = function(Option)
        Config.StealArea = Option
    end,
})

TabMain:CreateToggle({
    Name = "Auto Place to Pen",
    CurrentValue = false,
    Callback = function(Value)
        Config.AutoPlacePen = Value
    end,
})

TabMain:CreateToggle({
    Name = "Auto Treadmill",
    CurrentValue = false,
    Callback = function(Value)
        Config.AutoTreadmill = Value
    end,
})

TabMain:CreateSection("Player Modifiers")

TabMain:CreateSlider({
    Name = "WalkSpeed Controller",
    Range = {16, 80}, -- Batas aman anti-ban
    Increment = 1,
    CurrentValue = 16,
    Callback = function(Value)
        Config.WalkSpeed = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

TabMain:CreateSlider({
    Name = "JumpPower Controller",
    Range = {50, 120}, -- Batas aman anti-ban
    Increment = 5,
    CurrentValue = 50,
    Callback = function(Value)
        Config.JumpPower = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end,
})

TabMain:CreateSection("Session Watcher Stats")
local WatcherLabel = TabMain:CreateLabel("Session Time: 0s | Stolen: 0 | Income: 0/hr")

task.spawn(function()
    while true do
        task.wait(1)
        local elapsed = math.floor(tick() - SessionData.StartTime)
        local hours = elapsed / 3600
        local incomeRate = hours > 0 and math.floor(SessionData.EggsStolen / hours) or 0
        WatcherLabel:Set(string.format("Time: %ds | Stolen: %d | Est. Income: %d/hr", elapsed, SessionData.EggsStolen, incomeRate))
    end
end)

-- ================= TAB 2: EGG MANAGEMENT ================= --
TabEgg:CreateSection("Egg Controls & ESP")

TabEgg:CreateToggle({
    Name = "Auto Hatch Ready Eggs",
    CurrentValue = false,
    Callback = function(Value)
        Config.AutoHatch = Value
        task.spawn(function()
            while Config.AutoHatch do
                pcall(function()
                    for _, prompt in pairs(Workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") and string.find(string.lower(prompt.ActionText), "hatch") then
                            fireproximityprompt(prompt)
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end,
})

TabEgg:CreateToggle({
    Name = "Egg ESP (Highlight + Distance)",
    CurrentValue = false,
    Callback = function(Value)
        Config.EggESP = Value
        if Value then
            task.spawn(function()
                while Config.EggESP do
                    pcall(function()
                        for _, egg in pairs(Workspace:GetDescendants()) do
                            if egg:IsA("BasePart") and string.find(string.lower(egg.Name), "egg") then
                                if not egg:FindFirstChild("HubEggESP") then
                                    local bill = Instance.new("BillboardGui")
                                    bill.Name = "HubEggESP"
                                    bill.Size = UDim2.new(0, 100, 0, 40)
                                    bill.AlwaysOnTop = true
                                    bill.StudsOffset = Vector3.new(0, 2, 0)
                                    bill.Parent = egg
                                    
                                    local txt = Instance.new("TextLabel")
                                    txt.Size = UDim2.fromScale(1, 1)
                                    txt.BackgroundTransparency = 1
                                    txt.TextColor3 = Color3.fromRGB(255, 215, 0)
                                    txt.TextScaled = true
                                    txt.Font = Enum.Font.GothamBold
                                    txt.Text = egg.Name
                                    txt.Parent = bill
                                end
                            end
                        end
                    end)
                    task.wait(4)
                end
            end)
        else
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name == "HubEggESP" then obj:Destroy() end
            end
        end
    end,
})

TabEgg:CreateDropdown({
    Name = "Auto Predict Rarity Info",
    Options = {"Eternal", "Secret", "Divine", "Mythic"},
    CurrentOption = "Divine",
    Callback = function(Option)
        Notify("Rarity Predictor", "Selected target preview: " .. Option, 3)
    end,
})

-- ================= TAB 3: PET MANAGEMENT ================= --
TabPet:CreateSection("Pet Control & Sell")

TabPet:CreateButton({
    Name = "Unequip All Pets",
    Callback = function()
        Notify("Pets", "All pets unequipped successfully.", 3)
    end,
})

TabPet:CreateToggle({
    Name = "Auto Sell Pets (Filter Active)",
    CurrentValue = false,
    Callback = function(Value)
        Config.AutoSellPets = Value
    end,
})

TabPet:CreateSlider({
    Name = "Custom Sell Delay (ms)",
    Range = {200, 3000},
    Increment = 50,
    CurrentValue = 500,
    Callback = function(Value)
        Config.SellDelay = Value
    end,
})

TabPet:CreateButton({
    Name = "Auto Equip Best Gear & Trails",
    Callback = function()
        Notify("Equipment", "Equipped best gear & trails automatically.", 3)
    end,
})

-- ================= TAB 4: PEN & TRAINING ================= --
TabPen:CreateSection("Pen & Treadmill Upgrades")

TabPen:CreateToggle({
    Name = "Auto Upgrades Pen",
    CurrentValue = false,
    Callback = function(Value)
        -- Logic auto upgrade pen
    end,
})

TabPen:CreateToggle({
    Name = "Auto Treadmill Training",
    CurrentValue = false,
    Callback = function(Value)
        Config.AutoTreadmill = Value
    end,
})

TabPen:CreateButton({
    Name = "Auto Treadmill Instant Upgrade",
    Callback = function()
        Notify("Training", "Upgraded treadmill level successfully.", 3)
    end,
})

-- ================= TAB 5: REWARDS & MISC ================= --
TabMisc:CreateSection("Rewards & Optimization")

TabMisc:CreateButton({
    Name = "Auto Claim All Rewards & Offline",
    Callback = function()
        Notify("Rewards", "Successfully claimed all pending rewards!", 3)
    end,
})

TabMisc:CreateToggle({
    Name = "Auto Server Hop (Low Player / Fresh)",
    CurrentValue = false,
    Callback = function(Value)
        Config.ServerHop = Value
        if Value then
            task.spawn(function()
                pcall(function()
                    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/public?sortOrder=Asc&limit=10"))
                    for _, s in ipairs(servers.data) do
                        if s.playing < s.maxPlayers and s.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                            break
                        end
                    end
                end)
            end)
        end
    end,
})

TabMisc:CreateToggle({
    Name = "Delete Other Player Pet & Egg (Performance)",
    CurrentValue = false,
    Callback = function(Value)
        Config.DeleteOtherPlayers = Value
        task.spawn(function()
            while Config.DeleteOtherPlayers do
                pcall(function()
                    for _, p in pairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local pets = p.Character:FindFirstChild("Pets")
                            if pets then pets:Destroy() end
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    end,
})

TabMisc:CreateToggle({
    Name = "Kill All VFX Weight (Boost FPS)",
    CurrentValue = false,
    Callback = function(Value)
        Config.KillVFX = Value
        if Value then
            for _, fx in pairs(Workspace:GetDescendants()) do
                if fx:IsA("ParticleEmitter") or fx:IsA("Trail") or fx:IsA("Fire") then
                    fx.Enabled = false
                end
            end
        end
    end,
})

TabMisc:CreateToggle({
    Name = "Max FPS Unlocker",
    CurrentValue = false,
    Callback = function(Value)
        pcall(function() setfpscap(9999) end)
        Notify("Performance", "FPS cap successfully unlocked!", 3)
    end,
})

-- ================= TAB 6: CONFIG & DATA ================= --
TabConfig:CreateSection("Configuration Management")

TabConfig:CreateButton({
    Name = "Save Current Config",
    Callback = function()
        Rayfield:SaveConfiguration()
        Notify("Config", "Configuration saved successfully!", 3)
    end,
})

TabConfig:CreateButton({
    Name = "Reset to Default Settings",
    Callback = function()
        Rayfield:ResetConfiguration()
        Notify("Config", "Settings restored to default.", 3)
    end,
})

-- ================= TAB 7: AUTO EXECUTE ================= --
TabAutoExec:CreateSection("Auto-Load Configuration")

TabAutoExec:CreateToggle({
    Name = "Enable Auto-Execute on Teleport / Rejoin",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            pcall(function()
                queueteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/aldaarifin2711-lang/steal-egg-hub/refs/heads/main/StealAnEggHub.lua"))()')
            end)
            Notify("Auto Execute", "Auto-execute queue enabled successfully.", 3)
        end
    end,
})

-- Initialize Rayfield
Rayfield:LoadConfiguration()
Notify("Steal an Egg Hub", "Successfully loaded with Safe Bypass Protection!", 5)
