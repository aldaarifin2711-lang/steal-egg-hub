--[[
    Project: Steal An Egg - Ultimate Advanced Hub with Minimize Feature
    Features: Functional Auto Steal, Egg ESP, Treadmill, Safe Teleports, Server Hop, & Minimize UI
]]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

-- Clean up existing GUI
if CoreGui:FindFirstChild("StealAnEggUltimateHub") then
    CoreGui.StealAnEggUltimateHub:Destroy()
end

-- ================= ADVANCED CONFIG & STATE ================= --
local Config = {
    AutoSteal = false,
    AutoHatch = false,
    AutoTreadmill = false,
    EggESP = false,
    AutoSellEggs = false,
    AutoSellPets = false,
    KillVFX = false,
    ServerHopActive = false
}

-- ================= MODERN UI DESIGN ================= --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggUltimateHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
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
UIStroke.Color = Color3.fromRGB(60, 60, 90)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Top Bar Header
local TopBar = Instance.new("Frame")
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
Title.Text = "⚡ STEAL AN EGG — ADVANCED PRO HUB"
Title.TextColor3 = Color3.fromRGB(240, 240, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ================= MINIMIZE BUTTON & LOGIC ================= --
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 12, 0, 55)
Container.Size = UDim2.new(1, -24, 1, -65)
Container.CanvasSize = UDim2.new(0, 0, 3.5, 0)
Container.ScrollBarThickness = 5
Container.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 150)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Parent = TopBar
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
MinimizeBtn.Position = UDim2.new(1, -40, 0.5, -12)
MinimizeBtn.Size = UDim2.new(0, 28, 0, 24)
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    Container.Visible = not isMinimized
    
    local targetSize = isMinimized and UDim2.new(0, 580, 0, 45) or UDim2.new(0, 580, 0, 380)
    MinimizeBtn.Text = isMinimized and "+" or "-"
    
    TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = targetSize}):Play()
end)

-- ================= UI BUILDER HELPERS ================= --
local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

local function AddCategory(text)
    local Label = Instance.new("TextLabel")
    Label.Parent = Container
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1, 0, 0, 26)
    Label.Font = Enum.Font.GothamBold
    Label.Text = "  " .. text
    Label.TextColor3 = Color3.fromRGB(130, 130, 180)
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

-- ================= CORE FUNCTIONALITY IMPLEMENTATION ================= --

AddCategory("--- 🥚 FARMING & STEALING AUTOMATION ---")

AddToggle("Auto Steal Egg (Smart Target)", function(v)
    Config.AutoSteal = v
    task.spawn(function()
        while Config.AutoSteal do
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if not Config.AutoSteal then break end
                    if obj:IsA("BasePart") and (string.find(string.lower(obj.Name), "egg") or string.find(string.lower(obj.Name), "nest")) then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.5)
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

AddToggle("Auto Hatch Ready Eggs", function(v)
    Config.AutoHatch = v
    task.spawn(function()
        while Config.AutoHatch do
            pcall(function()
                for _, prompt in pairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and string.find(string.lower(prompt.ActionText), "hatch") then
                        fireproximityprompt(prompt)
                    end
                end
            end)
            task.wait(2)
        end
    end)
end)

AddCategory("--- ⚡ TRAINING & SPEED STATS ---")

AddToggle("Auto Treadmill Training (AFK Boost)", function(v)
    Config.AutoTreadmill = v
    task.spawn(function()
        while Config.AutoTreadmill do
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    for _, machine in pairs(Workspace:GetDescendants()) do
                        if string.find(string.lower(machine.Name), "treadmill") then
                            if machine:IsA("BasePart") then
                                character.HumanoidRootPart.CFrame = machine.CFrame + Vector3.new(0, 2, 0)
                            end
                        end
                    end
                end
            end)
            task.wait(1.5)
        end
    end)
end)

AddCategory("--- 🛠️ VISUAL, ESP & OPTIMIZATION ---")

AddToggle("Egg ESP (High Visibility)", function(v)
    Config.EggESP = v
    if v then
        task.spawn(function()
            while Config.EggESP do
                pcall(function()
                    for _, egg in pairs(Workspace:GetDescendants()) do
                        if egg:IsA("BasePart") and string.find(string.lower(egg.Name), "egg") then
                            if not egg:FindFirstChild("CustomEggESP") then
                                local bb = Instance.new("BillboardGui")
                                bb.Name = "CustomEggESP"
                                bb.Size = UDim2.new(0, 120, 0, 50)
                                bb.AlwaysOnTop = true
                                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                                bb.Parent = egg
                                
                                local txt = Instance.new("TextLabel")
                                txt.Size = UDim2.fromScale(1, 1)
                                txt.BackgroundTransparency = 1
                                txt.TextColor3 = Color3.fromRGB(0, 255, 200)
                                txt.TextScaled = true
                                txt.Font = Enum.Font.GothamBold
                                txt.Text = "🥚 " .. egg.Name
                                txt.Parent = bb
                            end
                        end
                    end
                end)
                task.wait(4)
            end
        end)
    else
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "CustomEggESP" then obj:Destroy() end
        end
    end
end)

AddToggle("Kill All VFX Weight (Boost FPS)", function(v)
    Config.KillVFX = v
    if v then
        for _, fx in pairs(Workspace:GetDescendants()) do
            if fx:IsA("ParticleEmitter") or fx:IsA("Trail") or fx:IsA("Fire") or fx:IsA("Sparkles") then
                fx.Enabled = false
            end
        end
    end
end)

AddCategory("--- 🌐 WORLD UTILITIES ---")

AddToggle("Auto Server Hop (Fresh Map)", function(v)
    Config.ServerHopActive = v
    task.spawn(function()
        if Config.ServerHopActive then
            local Servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/public?sortOrder=Asc&limit=100"))
            for _, srv in pairs(Servers.data) do
                if srv.playing < srv.maxPlayers and srv.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, srv.id, LocalPlayer)
                    break
                end
            end
        end
    end)
end)

print("Steal an Egg Advanced Pro Hub (Minimizable) Loaded Successfully!")
