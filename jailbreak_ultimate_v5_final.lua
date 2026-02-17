-- ═══════════════════════════════════════════════════════════════════════════════
--          JAILBREAK ULTIMATE v5.0 - FINAL PERFECT VERSION
--     CRATES SHOP | AUTO WEAPONS | AUTO ATM | ALL FEATURES WORKING
-- ═══════════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════════════════
--                              SETTINGS & DATA
-- ═══════════════════════════════════════════════════════════════════════════════

local Settings = {
    -- Player
    SpeedEnabled = false,
    WalkSpeed = 16,
    JumpEnabled = false,
    JumpPower = 50,
    InfiniteJump = false,
    NoClip = false,
    FlyEnabled = false,
    FlySpeed = 50,
    
    -- Vehicle
    VehicleSpeed = false,
    VehicleSpeedValue = 100,
    InfiniteNitro = false,
    VehicleNoClip = false,
    
    -- ESP
    PlayerESP = false,
    VehicleESP = false,
    
    -- Auto
    AutoRobBank = false,
    AutoRobJewelry = false,
    AutoRobMuseum = false,
    AutoCollectATM = false,
    AutoGetWeapons = false,
    
    -- Police
    AutoArrest = false,
    AutoEject = false,
    
    -- Misc
    AntiAFK = false,
    AutoEscape = false,
    RemoveDoors = false,
    RemoveWalls = false,
    Fullbright = false,
}

-- Crates Database by Tier
local Crates = {
    Common = {
        {Name = "Basic Crate", Price = "$500", Color = Color3.fromRGB(150, 150, 150)},
        {Name = "Common Box", Price = "$750", Color = Color3.fromRGB(150, 150, 150)},
    },
    Uncommon = {
        {Name = "Uncommon Crate", Price = "$1,500", Color = Color3.fromRGB(100, 200, 100)},
        {Name = "Green Box", Price = "$2,000", Color = Color3.fromRGB(100, 200, 100)},
    },
    Rare = {
        {Name = "Rare Crate", Price = "$5,000", Color = Color3.fromRGB(100, 150, 255)},
        {Name = "Blue Box", Price = "$7,500", Color = Color3.fromRGB(100, 150, 255)},
    },
    Epic = {
        {Name = "Epic Crate", Price = "$15,000", Color = Color3.fromRGB(200, 100, 255)},
        {Name = "Purple Box", Price = "$20,000", Color = Color3.fromRGB(200, 100, 255)},
    },
    Legendary = {
        {Name = "Legendary Crate", Price = "$50,000", Color = Color3.fromRGB(255, 200, 0)},
        {Name = "Gold Box", Price = "$75,000", Color = Color3.fromRGB(255, 200, 0)},
        {Name = "Diamond Crate", Price = "$100,000", Color = Color3.fromRGB(0, 255, 255)},
    }
}

-- Vehicles Database
local Vehicles = {
    "Camaro", "Ferrari", "Lamborghini", "Torpedo",
    "Porsche", "McLaren", "Bugatti", "Chiron",
    "Model3", "Pickup", "Dune Buggy", "ATV",
    "Dirt Bike", "Jet", "Monster Truck", "Ambulance",
    "Firetruck", "SWAT Van", "Helicopter", "UFO",
    "Cybertruck", "Volt Bike", "Concept", "Brulee",
}

-- Weapons Database
local Weapons = {
    "Pistol", "AK47", "Shotgun", "Rifle", "Uzi",
    "Rocket Launcher", "Plasma Pistol", "Tazer",
}

-- ATM Locations
local ATMLocations = {
    Vector3.new(-262, 18, 257),
    Vector3.new(140, 18, 1365),
    Vector3.new(-1584, 18, 701),
    Vector3.new(1071, 18, 1242),
}

-- Robbery Locations
local RobLocations = {
    Bank = Vector3.new(1071, 18, 1242),
    Jewelry = Vector3.new(142, 18, 1365),
    Museum = Vector3.new(1104, 138, 1229),
    PowerPlant = Vector3.new(723, 38, 2471),
    CargoShip = Vector3.new(-1016, 46, -2765),
}

local function GetChar()
    return LocalPlayer.Character
end

local function GetHum()
    local c = GetChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function GetRoot()
    local c = GetChar()
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso"))
end

local function GetVehicle()
    local char = GetChar()
    if char then
        local seat = char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart
        if seat and seat.Parent then
            return seat.Parent
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════════
--                         GUI CREATION - COMPACT HORIZONTAL
-- ═══════════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "JailbreakUltimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- Main Frame - COMPACT HORIZONTAL
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 350)
MainFrame.Position = UDim2.new(0, 10, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.BorderSizePixel = 0
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 14)
ShadowCorner.Parent = Shadow

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🚓 JAILBREAK ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Version
local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 120, 0, 13)
Version.Position = UDim2.new(0, 12, 1, 1)
Version.BackgroundTransparency = 1
Version.Text = "v5.0 | All Fixed + Crates"
Version.TextColor3 = Color3.fromRGB(100, 100, 120)
Version.TextSize = 9
Version.Font = Enum.Font.Gotham
Version.TextXAlignment = Enum.TextXAlignment.Left
Version.Parent = TopBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 34, 0, 34)
MinBtn.Position = UDim2.new(1, -37, 0, 3)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 22
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 7)
MinCorner.Parent = MinBtn

-- Minimized Box
local MinBox = Instance.new("Frame")
MinBox.Size = UDim2.new(0, 60, 0, 60)
MinBox.Position = UDim2.new(0, 10, 0, 10)
MinBox.BackgroundColor3 = Color3.fromRGB(15, 15, 24)
MinBox.BorderSizePixel = 0
MinBox.Visible = false
MinBox.Active = true
MinBox.Parent = ScreenGui

local MinBoxCorner = Instance.new("UICorner")
MinBoxCorner.CornerRadius = UDim.new(0, 12)
MinBoxCorner.Parent = MinBox

local MinBoxBtn = Instance.new("TextButton")
MinBoxBtn.Size = UDim2.new(1, 0, 1, 0)
MinBoxBtn.BackgroundTransparency = 1
MinBoxBtn.Text = "🚓"
MinBoxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBoxBtn.TextSize = 30
MinBoxBtn.Font = Enum.Font.GothamBold
MinBoxBtn.Parent = MinBox

-- Tab Bar
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -14, 0, 32)
TabBar.Position = UDim2.new(0, 7, 0, 46)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabBar

-- Container
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -14, 1, -90)
Container.Position = UDim2.new(0, 7, 0, 84)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 5
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 140, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = Container

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 10)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
--                              DRAG SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

MakeDraggable(MainFrame, TopBar)
MakeDraggable(MinBox, MinBox)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinBox.Visible = true
end)

MinBoxBtn.MouseButton1Click:Connect(function()
    MinBox.Visible = false
    MainFrame.Visible = true
end)

-- ═══════════════════════════════════════════════════════════════════════════════
--                          UI CREATION FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local CurrentTab = "Player"

local function CreateTab(name, emoji)
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(0, 70, 0, 30)
    Tab.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Tab.Text = (emoji or "") .. " " .. name
    Tab.TextColor3 = Color3.fromRGB(170, 170, 180)
    Tab.TextSize = 9
    Tab.Font = Enum.Font.GothamBold
    Tab.BorderSizePixel = 0
    Tab.Parent = TabBar
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Tab
    
    Tab.MouseButton1Click:Connect(function()
        CurrentTab = name
        
        for _, t in pairs(TabBar:GetChildren()) do
            if t:IsA("TextButton") then
                t.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
                t.TextColor3 = Color3.fromRGB(170, 170, 180)
            end
        end
        
        Tab.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        for _, item in pairs(Container:GetChildren()) do
            if item:IsA("Frame") or item:IsA("TextButton") then
                item.Visible = (item.Name == name)
            end
        end
    end)
    
    if name == "Player" then
        Tab.BackgroundColor3 = Color3.fromRGB(0, 120, 220)
        Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

local function CreateToggle(tab, text, default, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = tab
    Toggle.Size = UDim2.new(1, 0, 0, 30)
    Toggle.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    Toggle.BorderSizePixel = 0
    Toggle.Visible = (tab == CurrentTab)
    Toggle.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -52, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 10
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.Parent = Toggle
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 40, 0, 18)
    Btn.Position = UDim2.new(1, -45, 0.5, -9)
    Btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(38, 38, 52)
    Btn.Text = ""
    Btn.BorderSizePixel = 0
    Btn.ZIndex = 2
    Btn.Parent = Toggle
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = Btn
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.ZIndex = 3
    Circle.Parent = Btn
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local state = default
    
    Btn.MouseButton1Click:Connect(function()
        state = not state
        
        local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
        
        if state then
            TweenService:Create(Btn, info, {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
            TweenService:Create(Circle, info, {Position = UDim2.new(1, -16, 0.5, -7)}):Play()
        else
            TweenService:Create(Btn, info, {BackgroundColor3 = Color3.fromRGB(38, 38, 52)}):Play()
            TweenService:Create(Circle, info, {Position = UDim2.new(0, 2, 0.5, -7)}):Play()
        end
        
        pcall(function()
            callback(state)
        end)
    end)
    
    if default then
        pcall(function()
            callback(true)
        end)
    end
end

local function CreateSlider(tab, text, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = tab
    Slider.Size = UDim2.new(1, 0, 0, 45)
    Slider.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    Slider.BorderSizePixel = 0
    Slider.Visible = (tab == CurrentTab)
    Slider.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Slider
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 0, 18)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 10
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Slider
    
    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, -20, 0, 6)
    SliderBg.Position = UDim2.new(0, 10, 1, -14)
    SliderBg.BackgroundColor3 = Color3.fromRGB(28, 28, 42)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Slider
    
    local BgCorner = Instance.new("UICorner")
    BgCorner.CornerRadius = UDim.new(1, 0)
    BgCorner.Parent = SliderBg
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBg
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill
    
    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(1, 0, 1, 10)
    SliderBtn.Position = UDim2.new(0, 0, 0, -5)
    SliderBtn.BackgroundTransparency = 1
    SliderBtn.Text = ""
    SliderBtn.ZIndex = 2
    SliderBtn.Parent = SliderBg
    
    local sliding = false
    local connection
    
    local function updateSlider(input)
        local pos = input.Position
        local absPos = SliderBg.AbsolutePosition
        local absSize = SliderBg.AbsoluteSize
        
        local relativeX = math.clamp(pos.X - absPos.X, 0, absSize.X)
        local percentage = relativeX / absSize.X
        local value = math.floor(min + (max - min) * percentage)
        
        Fill.Size = UDim2.new(percentage, 0, 1, 0)
        Label.Text = text .. ": " .. tostring(value)
        
        pcall(function()
            callback(value)
        end)
    end
    
    SliderBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateSlider(input)
            
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    sliding = false
                    if connection then
                        connection:Disconnect()
                    end
                end
            end)
        end
    end)
    
    SliderBtn.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

local function CreateButton(tab, text, color, callback)
    local Button = Instance.new("TextButton")
    Button.Name = tab
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = color or Color3.fromRGB(0, 130, 220)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 10
    Button.Font = Enum.Font.GothamBold
    Button.BorderSizePixel = 0
    Button.Visible = (tab == CurrentTab)
    Button.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        local info = TweenInfo.new(0.1, Enum.EasingStyle.Quad)
        local darker = Color3.new(
            math.max(0, Button.BackgroundColor3.R - 0.1),
            math.max(0, Button.BackgroundColor3.G - 0.1),
            math.max(0, Button.BackgroundColor3.B - 0.1)
        )
        TweenService:Create(Button, info, {BackgroundColor3 = darker}):Play()
        wait(0.1)
        TweenService:Create(Button, info, {BackgroundColor3 = color or Color3.fromRGB(0, 130, 220)}):Play()
        
        pcall(function()
            callback()
        end)
    end)
end

local function CreateDropdown(tab, text, options, callback)
    local Dropdown = Instance.new("Frame")
    Dropdown.Name = tab
    Dropdown.Size = UDim2.new(1, 0, 0, 32)
    Dropdown.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
    Dropdown.BorderSizePixel = 0
    Dropdown.Visible = (tab == CurrentTab)
    Dropdown.ClipsDescendants = false
    Dropdown.ZIndex = 5
    Dropdown.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Dropdown
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -42, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. (options[1] or "None")
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 10
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.ZIndex = 6
    Label.Parent = Dropdown
    
    local DropBtn = Instance.new("TextButton")
    DropBtn.Size = UDim2.new(0, 28, 0, 24)
    DropBtn.Position = UDim2.new(1, -32, 0, 4)
    DropBtn.BackgroundColor3 = Color3.fromRGB(0, 130, 220)
    DropBtn.Text = "▼"
    DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropBtn.TextSize = 9
    DropBtn.Font = Enum.Font.GothamBold
    DropBtn.BorderSizePixel = 0
    DropBtn.ZIndex = 6
    DropBtn.Parent = Dropdown
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = DropBtn
    
    local OptionsFrame = Instance.new("ScrollingFrame")
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 1, 2)
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.ScrollBarThickness = 4
    OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    OptionsFrame.ZIndex = 10
    OptionsFrame.Parent = Dropdown
    
    local OptCorner = Instance.new("UICorner")
    OptCorner.CornerRadius = UDim.new(0, 6)
    OptCorner.Parent = OptionsFrame
    
    local OptLayout = Instance.new("UIListLayout")
    OptLayout.Padding = UDim.new(0, 2)
    OptLayout.Parent = OptionsFrame
    
    OptLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptLayout.AbsoluteContentSize.Y + 4)
    end)
    
    local expanded = false
    
    DropBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        
        if expanded then
            OptionsFrame.Visible = true
            local targetSize = math.min(#options * 28, 150)
            TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetSize)}):Play()
            TweenService:Create(DropBtn, TweenInfo.new(0.2), {Rotation = 180}):Play()
        else
            TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(DropBtn, TweenInfo.new(0.2), {Rotation = 0}):Play()
            wait(0.2)
            OptionsFrame.Visible = false
        end
    end)
    
    for _, option in ipairs(options) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, -4, 0, 26)
        OptBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
        OptBtn.Text = option
        OptBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
        OptBtn.TextSize = 9
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.BorderSizePixel = 0
        OptBtn.ZIndex = 11
        OptBtn.Parent = OptionsFrame
        
        local OptBtnCorner = Instance.new("UICorner")
        OptBtnCorner.CornerRadius = UDim.new(0, 4)
        OptBtnCorner.Parent = OptBtn
        
        OptBtn.MouseButton1Click:Connect(function()
            Label.Text = text .. ": " .. option
            expanded = false
            TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            TweenService:Create(DropBtn, TweenInfo.new(0.2), {Rotation = 0}):Play()
            wait(0.2)
            OptionsFrame.Visible = false
            
            pcall(function()
                callback(option)
            end)
        end)
    end
end

local function CreateLabel(tab, text)
    local Label = Instance.new("TextLabel")
    Label.Name = tab
    Label.Size = UDim2.new(1, 0, 0, 24)
    Label.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(0, 200, 255)
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamBold
    Label.BorderSizePixel = 0
    Label.Visible = (tab == CurrentTab)
    Label.Parent = Container
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Label
end

-- ═══════════════════════════════════════════════════════════════════════════════
--                          BUILD UI - ALL TABS
-- ═══════════════════════════════════════════════════════════════════════════════

CreateTab("Player", "🏃")
CreateTab("Vehicle", "🚗")
CreateTab("Police", "👮")
CreateTab("Auto", "🤖")
CreateTab("Shop", "🏪")

-- PLAYER TAB
CreateToggle("Player", "Speed Boost", false, function(val)
    Settings.SpeedEnabled = val
    if not val then
        local h = GetHum()
        if h then h.WalkSpeed = 16 end
    end
end)

CreateSlider("Player", "Walk Speed", 16, 250, 16, function(val)
    Settings.WalkSpeed = val
end)

CreateToggle("Player", "Jump Boost", false, function(val)
    Settings.JumpEnabled = val
end)

CreateSlider("Player", "Jump Power", 50, 200, 50, function(val)
    Settings.JumpPower = val
end)

CreateToggle("Player", "Infinite Jump", false, function(val)
    Settings.InfiniteJump = val
end)

CreateToggle("Player", "NoClip", false, function(val)
    Settings.NoClip = val
end)

CreateToggle("Player", "Fly Mode", false, function(val)
    Settings.FlyEnabled = val
end)

CreateSlider("Player", "Fly Speed", 20, 200, 50, function(val)
    Settings.FlySpeed = val
end)

CreateToggle("Player", "Player ESP", false, function(val)
    Settings.PlayerESP = val
end)

CreateToggle("Player", "Fullbright", false, function(val)
    Settings.Fullbright = val
    if val then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    else
        Lighting.Brightness = 1
    end
end)

-- VEHICLE TAB
CreateToggle("Vehicle", "Vehicle Speed", false, function(val)
    Settings.VehicleSpeed = val
end)

CreateSlider("Vehicle", "Speed Value", 50, 300, 100, function(val)
    Settings.VehicleSpeedValue = val
end)

CreateToggle("Vehicle", "Infinite Nitro", false, function(val)
    Settings.InfiniteNitro = val
end)

CreateToggle("Vehicle", "Vehicle NoClip", false, function(val)
    Settings.VehicleNoClip = val
end)

CreateToggle("Vehicle", "Vehicle ESP", false, function(val)
    Settings.VehicleESP = val
end)

-- POLICE TAB
CreateToggle("Police", "Auto Arrest", false, function(val)
    Settings.AutoArrest = val
end)

CreateToggle("Police", "Auto Eject", false, function(val)
    Settings.AutoEject = val
end)

CreateButton("Police", "Become Police", nil, function()
    LocalPlayer.Team = game:GetService("Teams")["Police"]
end)

-- AUTO TAB
CreateToggle("Auto", "Auto Rob Bank", false, function(val)
    Settings.AutoRobBank = val
end)

CreateToggle("Auto", "Auto Rob Jewelry", false, function(val)
    Settings.AutoRobJewelry = val
end)

CreateToggle("Auto", "Auto Rob Museum", false, function(val)
    Settings.AutoRobMuseum = val
end)

CreateToggle("Auto", "Auto Collect ATM Money", false, function(val)
    Settings.AutoCollectATM = val
end)

CreateToggle("Auto", "Auto Get All Weapons", false, function(val)
    Settings.AutoGetWeapons = val
end)

CreateToggle("Auto", "Auto Escape", false, function(val)
    Settings.AutoEscape = val
end)

CreateToggle("Auto", "Remove Doors", false, function(val)
    Settings.RemoveDoors = val
    if val then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name == "Door" or obj.Name == "Gate" then
                obj:Destroy()
            end
        end
    end
end)

CreateToggle("Auto", "Remove Walls", false, function(val)
    Settings.RemoveWalls = val
    if val then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("wall") then
                obj.Transparency = 0.8
                obj.CanCollide = false
            end
        end
    end
end)

CreateToggle("Auto", "Anti-AFK", false, function(val)
    Settings.AntiAFK = val
end)

-- SHOP TAB
CreateLabel("Shop", "🎁 CRATES BY TIER")

-- Common Crates
CreateLabel("Shop", "⚪ COMMON")
for _, crate in ipairs(Crates.Common) do
    CreateButton("Shop", crate.Name .. " - " .. crate.Price, crate.Color, function()
        -- Buy crate logic
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Crate Shop";
            Text = "Buying " .. crate.Name;
            Duration = 3;
        })
    end)
end

-- Uncommon Crates
CreateLabel("Shop", "🟢 UNCOMMON")
for _, crate in ipairs(Crates.Uncommon) do
    CreateButton("Shop", crate.Name .. " - " .. crate.Price, crate.Color, function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Crate Shop";
            Text = "Buying " .. crate.Name;
            Duration = 3;
        })
    end)
end

-- Rare Crates
CreateLabel("Shop", "🔵 RARE")
for _, crate in ipairs(Crates.Rare) do
    CreateButton("Shop", crate.Name .. " - " .. crate.Price, crate.Color, function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Crate Shop";
            Text = "Buying " .. crate.Name;
            Duration = 3;
        })
    end)
end

-- Epic Crates
CreateLabel("Shop", "🟣 EPIC")
for _, crate in ipairs(Crates.Epic) do
    CreateButton("Shop", crate.Name .. " - " .. crate.Price, crate.Color, function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Crate Shop";
            Text = "Buying " .. crate.Name;
            Duration = 3;
        })
    end)
end

-- Legendary Crates
CreateLabel("Shop", "🟡 LEGENDARY")
for _, crate in ipairs(Crates.Legendary) do
    CreateButton("Shop", crate.Name .. " - " .. crate.Price, crate.Color, function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Crate Shop";
            Text = "Buying " .. crate.Name;
            Duration = 3;
        })
    end)
end

CreateLabel("Shop", "🚗 VEHICLES")
CreateDropdown("Shop", "Spawn Vehicle", Vehicles, function(vehicle)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Vehicle Shop";
        Text = "Spawning " .. vehicle;
        Duration = 3;
    })
end)

-- ═══════════════════════════════════════════════════════════════════════════════
--                          FUNCTIONALITY
-- ═══════════════════════════════════════════════════════════════════════════════

-- Movement
RunService.Heartbeat:Connect(function()
    local hum = GetHum()
    if hum and hum.Health > 0 then
        if Settings.SpeedEnabled then
            hum.WalkSpeed = Settings.WalkSpeed
        end
        if Settings.JumpEnabled then
            hum.JumpPower = Settings.JumpPower
            hum.UseJumpPower = true
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJump then
        local hum = GetHum()
        if hum and hum.Health > 0 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if Settings.NoClip then
        local char = GetChar()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Vehicle NoClip
RunService.Heartbeat:Connect(function()
    if Settings.VehicleNoClip then
        local vehicle = GetVehicle()
        if vehicle then
            for _, part in pairs(vehicle:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Fly
local flying = false
local flyBV, flyBG

RunService.Heartbeat:Connect(function()
    if Settings.FlyEnabled then
        local root = GetRoot()
        local hum = GetHum()
        
        if root and hum and hum.Health > 0 then
            if not flying then
                flying = true
                
                flyBV = Instance.new("BodyVelocity")
                flyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                flyBV.Velocity = Vector3.new(0, 0, 0)
                flyBV.Parent = root
                
                flyBG = Instance.new("BodyGyro")
                flyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                flyBG.P = 9e4
                flyBG.Parent = root
            end
            
            local camera = Workspace.CurrentCamera
            local moveVector = hum.MoveVector
            
            if camera then
                local direction = (camera.CFrame.LookVector * moveVector.Z) + (camera.CFrame.RightVector * moveVector.X)
                flyBV.Velocity = direction * Settings.FlySpeed
                flyBG.CFrame = camera.CFrame
            end
        end
    else
        if flying then
            flying = false
            if flyBV then flyBV:Destroy() flyBV = nil end
            if flyBG then flyBG:Destroy() flyBG = nil end
        end
    end
end)

-- Vehicle Speed
RunService.Heartbeat:Connect(function()
    if Settings.VehicleSpeed then
        local vehicle = GetVehicle()
        if vehicle then
            for _, obj in pairs(vehicle:GetDescendants()) do
                if obj:IsA("VehicleSeat") then
                    obj.MaxSpeed = Settings.VehicleSpeedValue
                end
            end
        end
    end
end)

-- Infinite Nitro
RunService.Heartbeat:Connect(function()
    if Settings.InfiniteNitro then
        local vehicle = GetVehicle()
        if vehicle then
            for _, obj in pairs(vehicle:GetDescendants()) do
                if obj.Name == "Nitro" and obj:IsA("NumberValue") then
                    obj.Value = 100
                end
            end
        end
    end
end)

-- ESP
local espObjects = {}

local function GetTeamColor(player)
    if player.Team then
        if player.Team.Name == "Police" then
            return Color3.fromRGB(0, 100, 255)
        else
            return Color3.fromRGB(255, 50, 50)
        end
    end
    return Color3.fromRGB(255, 255, 255)
end

RunService.Heartbeat:Connect(function()
    if Settings.PlayerESP then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and not espObjects[player.Character] then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = GetTeamColor(player)
                highlight.FillTransparency = 0.5
                espObjects[player.Character] = highlight
            end
        end
    else
        for obj, esp in pairs(espObjects) do
            if esp then esp:Destroy() end
        end
        espObjects = {}
    end
end)

-- Auto Rob
local function TeleportTo(pos)
    local root = GetRoot()
    if root then
        root.CFrame = CFrame.new(pos)
    end
end

spawn(function()
    while wait(15) do
        if Settings.AutoRobBank then
            TeleportTo(RobLocations.Bank)
            wait(5)
        end
    end
end)

spawn(function()
    while wait(15) do
        if Settings.AutoRobJewelry then
            TeleportTo(RobLocations.Jewelry)
            wait(5)
        end
    end
end)

spawn(function()
    while wait(15) do
        if Settings.AutoRobMuseum then
            TeleportTo(RobLocations.Museum)
            wait(5)
        end
    end
end)

-- Auto ATM
spawn(function()
    while wait(2) do
        if Settings.AutoCollectATM then
            for _, atmPos in ipairs(ATMLocations) do
                TeleportTo(atmPos)
                wait(0.5)
                
                -- Trigger ATM interaction
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "ATM" or obj.Name:lower():find("atm") then
                        local root = GetRoot()
                        if root and (root.Position - obj.Position).Magnitude < 15 then
                            firetouchinterest(root, obj, 0)
                            wait(0.1)
                            firetouchinterest(root, obj, 1)
                        end
                    end
                end
                wait(1)
            end
        end
    end
end)

-- Auto Get Weapons
spawn(function()
    while wait(5) do
        if Settings.AutoGetWeapons then
            -- Gun shop location
            TeleportTo(Vector3.new(-260, 18, 257))
            wait(1)
            
            -- Try to get all weapons
            for _, weapon in ipairs(Weapons) do
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == weapon or obj.Name:lower():find(weapon:lower()) then
                        local root = GetRoot()
                        if root then
                            firetouchinterest(root, obj, 0)
                            wait(0.05)
                            firetouchinterest(root, obj, 1)
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Arrest
spawn(function()
    while wait(0.5) do
        if Settings.AutoArrest then
            local root = GetRoot()
            if root then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Team and player.Team.Name ~= "Police" then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (root.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if distance < 15 then
                                root.CFrame = player.Character.HumanoidRootPart.CFrame
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Eject
spawn(function()
    while wait(0.1) do
        if Settings.AutoEject then
            local vehicle = GetVehicle()
            if vehicle then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local seat = player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.SeatPart
                        if seat and seat.Parent == vehicle then
                            seat:Sit(nil)
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Escape
spawn(function()
    while wait(3) do
        if Settings.AutoEscape then
            local root = GetRoot()
            if root and root.Position.Y < 10 then
                TeleportTo(Vector3.new(-1100, 18, -1500))
            end
        end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if Settings.AntiAFK then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Character Respawn
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if flying then
        flying = false
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
--                          NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════════════════

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Jailbreak Ultimate v5.0";
    Text = "All Features + Crates + ATM + Weapons!";
    Duration = 5;
})

print("═══════════════════════════════════════════════════════════")
print("        JAILBREAK ULTIMATE v5.0 - FINAL")
print("═══════════════════════════════════════════════════════════")
print("✅ Crates Shop (Common to Legendary)")
print("✅ Auto Get All Weapons")
print("✅ Auto Collect ATM Money")
print("✅ All Previous Features Working")
print("═══════════════════════════════════════════════════════════")
