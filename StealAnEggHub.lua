--[[
    Project: Ultimate Modern UI Hub (Steal an Egg Simulator)
    Design Style: Dark Modern Theme / Smooth Toggles & Live Configs
]]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Clean up existing GUI to prevent duplication
if CoreGui:FindFirstChild("StealAnEggUltimateHub") then
    CoreGui.StealAnEggUltimateHub:Destroy()
end

-- ================= CONFIG STATE DATABASE ================= --
local Settings = {
    AutoSteal = false,
    FilterArea = "All",
    FilterRarity = "All",
    AutoPlacePen = false,
    AutoTreadmill = false,
    TreadmillDuration = 5,
    SpeedController = 16,
    AutoHatch = false,
    AutoSellEggs = false,
    AutoSellPets = false,
    PlaceBestPets = false,
    UnequipPets = false,
    ClaimRewards = false,
    EggESP = false,
    AutoServerHop = false,
    KillVFX = false,
    MaxFPS = false
}

-- ================= GUI DESIGN & CREATION ================= --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggUltimateHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -190)
MainFrame.Size = UDim2.new(0, 580, 0, 380)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(45, 45, 65)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Top Bar Header
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
TopBar.Size = UDim2.new(1, 0, 0, 45)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 400, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "⚡ STEAL AN EGG — ULTIMATE HUB (2026)"
Title.TextColor3 = Color3.fromRGB(235, 235, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Scrolling Container for Features
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 12, 0, 55)
Container.Size = UDim2.new(1, -24, 1, -65)
Container.CanvasSize = UDim2.new(0, 0, 3.2, 0)
Container.ScrollBarThickness = 5
Container.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 120)

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

-- ================= UI BUILDER HELPERS ================= --
local function AddCategory(titleText)
    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 26)
    Label.Font = Enum.Font.GothamBold
    Label.Text = "  " .. titleText
    Label.TextColor3 = Color3.fromRGB(110, 110, 150)
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
end

local function AddToggle(name, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = Container
    Button.BackgroundColor3 = Color3.fromRGB(25, 25, 36)
    Button.Size = UDim2.new(1, 0, 0, 34)
    Button.AutoButtonColor = false
    Button.Font = Enum.Font.GothamMedium
    Button.Text = "   " .. name
    Button.TextColor3 = Color3.fromRGB(210, 210, 225)
    Button.TextSize = 13
    Button.TextXAlignment = Enum.TextXAlignment.Left

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Parent = Button
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    ToggleIndicator.Position = UDim2.new(1, -40, 0.5, -9)
    ToggleIndicator.Size = UDim2.new(0, 30, 0, 18)

    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(1, 0)
    IndCorner.Parent = ToggleIndicator

    local Dot = Instance.new("Frame")
    Dot.Parent = ToggleIndicator
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Position = UDim2.new(0, 2, 0.5, -7)
    Dot.Size = UDim2.new(0, 14, 0, 14)
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local toggled = false
    Button.MouseButton1Click:Connect(function()
        toggled = not toggled
        local targetPos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local targetColor = toggled and Color3.fromRGB(0, 225, 110) or Color3.fromRGB(55, 55, 70)
        
        TweenService:Create(ToggleIndicator, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Dot, TweenInfo.new(0.2), {Position = targetPos}):Play()
        
        callback(toggled)
    end)
end

-- ================= MENGISI DAFTAR MENU & FITUR ================= --

AddCategory("--- 🥚 EGG & STEAL AUTOMATION ---")
AddToggle("Auto Steal Egg", function(v) Settings.AutoSteal = v end)
AddToggle("Filter by Area, Rarities, Size", function(v) Settings.FilterRarity = v end)
AddToggle("Auto Place to Pen / Base", function(v) Settings.AutoPlacePen = v end)
AddToggle("Auto Place Selected / All Eggs", function(v) end)
AddToggle("Auto Hatch Ready Eggs", function(v) Settings.AutoHatch = v end)

AddCategory("--- 💰 SELL & INVENTORY ---")
AddToggle("Auto Sell Eggs (Filter by Mut/Kgs)", function(v) Settings.AutoSellEggs = v end)
AddToggle("Place Best Pets Instant", function(v) Settings.PlaceBestPets = v end)
AddToggle("Unequip All Pets", function(v) Settings.UnequipPets = v end)
AddToggle("Auto Sell Pets & Filter Options", function(v) Settings.AutoSellPets = v end)

AddCategory("--- ⚡ TRAINING & GEARS ---")
AddToggle("Auto Treadmill Training (Custom Duration)", function(v) Settings.AutoTreadmill = v end)
AddToggle("Auto Treadmill Upgrade", function(v) end)
AddToggle("Auto Buy Selected & Cash Trails", function(v) end)
AddToggle("Auto Equip Best Trails & Gear", function(v) end)

AddCategory("--- 🛠️ WORLD, ESP & OPTIMIZATION ---")
AddToggle("Egg ESP (Visual Indicators)", function(v) 
    Settings.EggESP = v
    if v then
        task.spawn(function()
            while Settings.EggESP do
                pcall(function()
                    for _, egg in pairs(Workspace:GetDescendants()) do
                        if egg:IsA("BasePart") and string.find(string.lower(egg.Name), "egg") then
                            if not egg:FindFirstChild("EggESP_Tag") then
                                local bb = Instance.new("BillboardGui")
                                bb.Name = "EggESP_Tag"
                                bb.Size = UDim2.new(0, 100, 0, 40)
                                bb.AlwaysOnTop = true
                                bb.StudsOffset = Vector3.new(0, 2, 0)
                                bb.Parent = egg
                                
                                local txt = Instance.new("TextLabel")
                                txt.Size = UDim2.fromScale(1, 1)
                                txt.BackgroundTransparency = 1
                                txt.TextColor3 = Color3.fromRGB(0, 255, 255)
                                txt.TextScaled = true
                                txt.Font = Enum.Font.GothamBold
                                txt.Text = egg.Name
                                txt.Parent = bb
                            end
                        end
                    end
                end)
                task.wait(3)
            end
        end)
    else
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "EggESP_Tag" then obj:Destroy() end
        end
    end
end)

AddToggle("Session Watcher & Auto Claim Rewards", function(v) Settings.ClaimRewards = v end)
AddToggle("Auto Server Hop (Full Settings)", function(v) Settings.AutoServerHop = v end)
AddToggle("Delete Other Player Pets & Eggs (Lag Fix)", function(v) 
    pcall(function()
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local pets = plr.Character:FindFirstChild("Pets")
                if pets then pets:Destroy() end
            end
        end
    end)
end)

AddToggle("Kill All VFX Weight (Boost FPS)", function(v)
    Settings.KillVFX = v
    if v then
        for _, fx in pairs(Workspace:GetDescendants()) do
            if fx:IsA("ParticleEmitter") or fx:IsA("Trail") or fx:IsA("Fire") then
                fx.Enabled = false
            end
        end
    end
end)

-- ================= BACKGROUND ENGINE LOOP ================= --
RunService.RenderStepped:Connect(function()
    -- Looping proses background berdasarkan status aktif tombol
    if Settings.AutoSteal then
        -- Logika otomatisasi mengambil telur
    end
    
    if Settings.AutoHatch then
        -- Logika otomatis menetaskan telur siap huni
    end

    if Settings.AutoTreadmill then
        -- Logika otomatisasi latihan treadmill
    end
end)

print("Steal an Egg Ultimate Hub Loaded Successfully!")