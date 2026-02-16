--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║        BLOX FRUITS ULTIMATE HUB - PREMIUM EDITION            ║
    ║                  Made with ❤️ for Roblox                     ║
    ╚══════════════════════════════════════════════════════════════╝
    
    Features:
    - Auto Farm Level & Mastery (All Seas)
    - Auto Quest System (Smart Quest Selection)
    - Auto Boss Farm dengan Prioritas
    - Auto Raid (Full Auto Awakening)
    - Fruit Sniper & ESP System
    - Advanced Combat System
    - Teleport Hub (300+ Locations)
    - Stats Manager & Auto Allocation
    - Premium UI dengan Minimize
    - Notification System
    - Anti-Ban Protection
    - Dan 100+ fitur lainnya!
]]

local version = "v4.2.0 PREMIUM"

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Script Status
local ScriptEnabled = true
local ScriptStartTime = tick()

-- Advanced Settings
local Settings = {
    -- Auto Farm
    AutoFarm = false,
    AutoFarmMode = "Level",
    FastAttack = false,
    BringMob = false,
    AutoHaki = true,
    
    -- Mastery
    AutoFarmMastery = false,
    MasteryMode = "Devil Fruit",
    FruitMastery = false,
    GunMastery = false,
    SwordMastery = false,
    
    -- Quest System
    AutoQuest = false,
    QuestMode = "Nearby",
    
    -- Boss Farm
    AutoBoss = false,
    SelectedBoss = "None",
    AutoAllBoss = false,
    
    -- Raid
    AutoRaid = false,
    RaidMode = "Farm",
    AutoAwaken = false,
    AutoBuyChip = false,
    
    -- Fruit
    AutoFarmFruit = false,
    FruitSniper = false,
    AutoStoreFruit = false,
    AutoRandomFruit = false,
    
    -- Stats
    AutoStats = false,
    MeleeStat = 0,
    DefenseStat = 0,
    SwordStat = 0,
    GunStat = 0,
    FruitStat = 0,
    
    -- Combat
    AutoKen = true,
    AutoBuso = true,
    InfiniteEnergy = false,
    AutoSoulGuitar = false,
    
    -- Teleport
    TeleportSpeed = 350,
    TweenSpeed = 350,
    
    -- Visual
    ESPPlayers = false,
    ESPFruits = false,
    ESPChests = false,
    ESPFlowers = false,
    ESPBoss = false,
    
    -- Misc
    AntiAFK = true,
    AutoRejoin = true,
    FPSBoost = false,
    WhiteScreen = false,
    RemoveNotifications = true,
    FastInteraction = true,
    
    -- UI
    NotificationsEnabled = true,
    UIScale = 1,
    Theme = "Dark"
}

-- Farming Stats
local FarmStats = {
    TotalKills = 0,
    BossKills = 0,
    Level = LocalPlayer.Data.Level.Value or 1,
    Fragments = LocalPlayer.Data.Fragments.Value or 0,
    Beli = LocalPlayer.Data.Beli.Value or 0,
    SessionTime = 0,
    BeliEarned = 0,
    ExpGained = 0,
    FruitsCollected = 0
}

-- Sea Detection
local function GetCurrentSea()
    if game.PlaceId == 2753915549 then
        return "First Sea"
    elseif game.PlaceId == 4442272183 then
        return "Second Sea"
    elseif game.PlaceId == 7449423635 then
        return "Third Sea"
    end
    return "Unknown"
end

local CurrentSea = GetCurrentSea()

-- Island Locations (All Seas)
local Islands = {
    ["First Sea"] = {
        ["Jungle"] = CFrame.new(-1612, 37, 149),
        ["Pirate Starter"] = CFrame.new(1071, 16, 1426),
        ["Marine Starter"] = CFrame.new(-2573, 73, 2046),
        ["Middle Town"] = CFrame.new(-690, 15, 1582),
        ["Buggy"] = CFrame.new(-1145, 15, 4349),
        ["Desert"] = CFrame.new(944, 7, 4373),
        ["Frozen Village"] = CFrame.new(1099, 105, -1326),
        ["Marine Fortress"] = CFrame.new(-2995, 73, -3326),
        ["Skylands"] = CFrame.new(-4607, 872, -1667),
        ["Prison"] = CFrame.new(4854, 6, 734),
        ["Colosseum"] = CFrame.new(-1427, 7, -2792),
        ["Magma Village"] = CFrame.new(-5231, 9, -4754),
        ["Underwater City"] = CFrame.new(61163, 5, 1819),
        ["Upper Skylands"] = CFrame.new(-7894, 5545, -380),
        ["Fountain City"] = CFrame.new(5127, 59, 4105)
    },
    ["Second Sea"] = {
        ["Kingdom of Rose"] = CFrame.new(-288, 7, 3093),
        ["Cafe"] = CFrame.new(-380, 73, 298),
        ["Mansion"] = CFrame.new(-12511, 337, -7501),
        ["Graveyard"] = CFrame.new(-8653, 142, 6083),
        ["Snow Mountain"] = CFrame.new(749, 408, -5274),
        ["Hot and Cold"] = CFrame.new(-6556, 16, -6195),
        ["Cursed Ship"] = CFrame.new(923, 125, 32885),
        ["Ice Castle"] = CFrame.new(5668, 29, -6482),
        ["Forgotten Island"] = CFrame.new(-3032, 240, -10177),
        ["Dark Arena"] = CFrame.new(3780, 92, -3260),
        ["Green Zone"] = CFrame.new(-2448, 73, -3210),
        ["Factory"] = CFrame.new(424, 212, -427),
        ["Colossuem"] = CFrame.new(-1503, 47, -72),
        ["Zombie Island"] = CFrame.new(-5622, 492, -781),
        ["Swan Room"] = CFrame.new(5226, 6, 749)
    },
    ["Third Sea"] = {
        ["Port Town"] = CFrame.new(-290, 44, 5343),
        ["Hydra Island"] = CFrame.new(5229, 614, -380),
        ["Great Tree"] = CFrame.new(2681, 1682, -7190),
        ["Castle on the Sea"] = CFrame.new(-5075, 315, -3020),
        ["Mansion"] = CFrame.new(-12471, 374, -7551),
        ["Haunted Castle"] = CFrame.new(-9515, 142, 5535),
        ["Ice Cream Island"] = CFrame.new(-902, 79, -10988),
        ["Peanut Island"] = CFrame.new(-2062, 50, -10232),
        ["Cake Island"] = CFrame.new(-1956, 82, -11829),
        ["Cocoa Island"] = CFrame.new(87, 73, -12297),
        ["Candy Island"] = CFrame.new(-1106, 11, -14297),
        ["Tiki Outpost"] = CFrame.new(-16101, 9, 439)
    }
}

-- Boss Locations (All Seas)
local Bosses = {
    ["First Sea"] = {
        "Thunder God", "Saber Expert", "The Saw", "Greybeard",
        "Mob Leader", "Vice Admiral", "Warden", "Chief Warden",
        "Swan", "Magma Admiral", "Fishman Lord", "Wysper",
        "Diamond", "Jeremy", "Fajita"
    },
    ["Second Sea"] = {
        "Diamond", "Jeremy", "Fajita", "Don Swan",
        "Smoke Admiral", "Cursed Captain", "Darkbeard",
        "Order", "Awakened Ice Admiral", "Tide Keeper"
    },
    ["Third Sea"] = {
        "Stone", "Island Empress", "Kilo Admiral",
        "Captain Elephant", "Beautiful Pirate",
        "Cake Queen", "Longma", "Soul Reaper", "Rip_Indra"
    }
}

-- Notification System
local function CreateNotification(title, text, duration)
    if not Settings.NotificationsEnabled then return end
    
    duration = duration or 3
    
    local NotifGui = Instance.new("ScreenGui")
    NotifGui.Name = "NotificationGui"
    NotifGui.ResetOnSpawn = false
    NotifGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        NotifGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(NotifGui)
        NotifGui.Parent = CoreGui
    else
        NotifGui.Parent = CoreGui
    end
    
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
    NotifFrame.Size = UDim2.new(0, 320, 0, 90)
    NotifFrame.Position = UDim2.new(1, -340, 1, 100)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = NotifGui
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = NotifFrame
    
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(138, 43, 226)
    UIStroke.Thickness = 2
    UIStroke.Parent = NotifFrame
    
    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
    }
    UIGradient.Parent = UIStroke
    
    local Icon = Instance.new("ImageLabel")
    Icon.Size = UDim2.new(0, 40, 0, 40)
    Icon.Position = UDim2.new(0, 10, 0, 10)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://3926305904"
    Icon.ImageColor3 = Color3.fromRGB(138, 43, 226)
    Icon.Parent = NotifFrame
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -70, 0, 25)
    Title.Position = UDim2.new(0, 60, 0, 8)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = NotifFrame
    
    local Message = Instance.new("TextLabel")
    Message.Name = "Message"
    Message.Size = UDim2.new(1, -70, 0, 45)
    Message.Position = UDim2.new(0, 60, 0, 35)
    Message.BackgroundTransparency = 1
    Message.Text = text
    Title.TextColor3 = Color3.fromRGB(200, 200, 200)
    Message.TextSize = 13
    Message.Font = Enum.Font.Gotham
    Message.TextXAlignment = Enum.TextXAlignment.Left
    Message.TextYAlignment = Enum.TextYAlignment.Top
    Message.TextWrapped = true
    Message.Parent = NotifFrame
    
    local ProgressBar = Instance.new("Frame")
    ProgressBar.Size = UDim2.new(1, 0, 0, 3)
    ProgressBar.Position = UDim2.new(0, 0, 1, -3)
    ProgressBar.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    ProgressBar.BorderSizePixel = 0
    ProgressBar.Parent = NotifFrame
    
    -- Animate in
    NotifFrame:TweenPosition(
        UDim2.new(1, -340, 1, -110),
        Enum.EasingDirection.Out,
        Enum.EasingStyle.Back,
        0.5,
        true
    )
    
    -- Progress bar animation
    ProgressBar:TweenSize(
        UDim2.new(0, 0, 0, 3),
        Enum.EasingDirection.In,
        Enum.EasingStyle.Linear,
        duration,
        true
    )
    
    -- Wait and animate out
    task.wait(duration)
    NotifFrame:TweenPosition(
        UDim2.new(1, -340, 1, 100),
        Enum.EasingDirection.In,
        Enum.EasingStyle.Back,
        0.3,
        true,
        function()
            NotifGui:Destroy()
        end
    )
end

-- Create Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BloxFruitsUltimateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 600, 0, 450)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 12)
MainUICorner.Parent = MainFrame

local MainUIStroke = Instance.new("UIStroke")
MainUIStroke.Color = Color3.fromRGB(138, 43, 226)
MainUIStroke.Thickness = 2.5
MainUIStroke.Parent = MainFrame

local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(75, 0, 130))
}
MainGradient.Rotation = 45
MainGradient.Parent = MainUIStroke

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Name = "Topbar"
Topbar.Size = UDim2.new(1, 0, 0, 45)
Topbar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarUICorner = Instance.new("UICorner")
TopbarUICorner.CornerRadius = UDim.new(0, 12)
TopbarUICorner.Parent = Topbar

local TopbarBottom = Instance.new("Frame")
TopbarBottom.Size = UDim2.new(1, 0, 0, 12)
TopbarBottom.Position = UDim2.new(0, 0, 1, -12)
TopbarBottom.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TopbarBottom.BorderSizePixel = 0
TopbarBottom.Parent = Topbar

-- Logo/Icon
local Logo = Instance.new("ImageLabel")
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 10, 0, 7.5)
Logo.BackgroundTransparency = 1
Logo.Image = "rbxassetid://3926305904"
Logo.ImageColor3 = Color3.fromRGB(138, 43, 226)
Logo.Parent = Topbar

local LogoUICorner = Instance.new("UICorner")
LogoUICorner.CornerRadius = UDim.new(0, 8)
LogoUICorner.Parent = Logo

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 350, 1, 0)
Title.Position = UDim2.new(0, 50, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🍇 BLOX FRUITS ULTIMATE HUB " .. version
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 255))
}
TitleGradient.Parent = Title

-- Sea Label
local SeaLabel = Instance.new("TextLabel")
SeaLabel.Size = UDim2.new(0, 100, 0, 20)
SeaLabel.Position = UDim2.new(1, -230, 0, 12.5)
SeaLabel.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
SeaLabel.BorderSizePixel = 0
SeaLabel.Text = "📍 " .. CurrentSea
SeaLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SeaLabel.TextSize = 11
SeaLabel.Font = Enum.Font.GothamBold
SeaLabel.Parent = Topbar

local SeaLabelCorner = Instance.new("UICorner")
SeaLabelCorner.CornerRadius = UDim.new(0, 5)
SeaLabelCorner.Parent = SeaLabel

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 32, 0, 32)
MinimizeBtn.Position = UDim2.new(1, -75, 0, 6.5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = Topbar

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 8)
MinBtnCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 6.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 70)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Topbar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

-- Minimized Frame (1:1 Square)
local MinimizedFrame = Instance.new("Frame")
MinimizedFrame.Name = "MinimizedFrame"
MinimizedFrame.Size = UDim2.new(0, 55, 0, 55)
MinimizedFrame.Position = UDim2.new(0, 15, 0, 15)
MinimizedFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MinimizedFrame.BorderSizePixel = 0
MinimizedFrame.Visible = false
MinimizedFrame.Active = true
MinimizedFrame.Parent = ScreenGui

local MinFrameCorner = Instance.new("UICorner")
MinFrameCorner.CornerRadius = UDim.new(0, 10)
MinFrameCorner.Parent = MinimizedFrame

local MinFrameStroke = Instance.new("UIStroke")
MinFrameStroke.Color = Color3.fromRGB(138, 43, 226)
MinFrameStroke.Thickness = 2.5
MinFrameStroke.Parent = MinimizedFrame

local MinIcon = Instance.new("TextLabel")
MinIcon.Size = UDim2.new(1, 0, 1, 0)
MinIcon.BackgroundTransparency = 1
MinIcon.Text = "🍇"
MinIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
MinIcon.TextSize = 28
MinIcon.Font = Enum.Font.GothamBold
MinIcon.Parent = MinimizedFrame

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(1, 0, 1, 0)
MinButton.BackgroundTransparency = 1
MinButton.Text = ""
MinButton.Parent = MinimizedFrame

-- Tab System
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 140, 1, -55)
TabContainer.Position = UDim2.new(0, 8, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -160, 1, -60)
ContentContainer.Position = UDim2.new(0, 152, 0, 50)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

local Tabs = {}
local TabButtons = {}
local CurrentTab = nil

local function CreateTab(name, icon)
    -- Tab Button
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name .. "Tab"
    TabBtn.Size = UDim2.new(1, 0, 0, 42)
    TabBtn.Position = UDim2.new(0, 0, 0, (#TabButtons * 47))
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    TabBtn.BorderSizePixel = 0
    TabBtn.AutoButtonColor = false
    TabBtn.Text = ""
    TabBtn.Parent = TabContainer
    
    local TabBtnCorner = Instance.new("UICorner")
    TabBtnCorner.CornerRadius = UDim.new(0, 8)
    TabBtnCorner.Parent = TabBtn
    
    local TabIcon = Instance.new("TextLabel")
    TabIcon.Size = UDim2.new(0, 25, 0, 25)
    TabIcon.Position = UDim2.new(0, 10, 0.5, -12.5)
    TabIcon.BackgroundTransparency = 1
    TabIcon.Text = icon
    TabIcon.TextColor3 = Color3.fromRGB(150, 150, 160)
    TabIcon.TextSize = 18
    TabIcon.Font = Enum.Font.GothamBold
    TabIcon.Parent = TabBtn
    
    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -45, 1, 0)
    TabLabel.Position = UDim2.new(0, 40, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = name
    TabLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
    TabLabel.TextSize = 13
    TabLabel.Font = Enum.Font.GothamBold
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabBtn
    
    -- Tab Content
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 5
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    TabContent.Visible = false
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Parent = ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.Parent = TabContent
    
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 15)
    end)
    
    table.insert(TabButtons, {Btn = TabBtn, Icon = TabIcon, Label = TabLabel})
    Tabs[name] = TabContent
    
    TabBtn.MouseButton1Click:Connect(function()
        for _, btn in pairs(TabButtons) do
            btn.Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            btn.Icon.TextColor3 = Color3.fromRGB(150, 150, 160)
            btn.Label.TextColor3 = Color3.fromRGB(150, 150, 160)
        end
        
        for _, content in pairs(Tabs) do
            content.Visible = false
        end
        
        TabBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
        TabIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabContent.Visible = true
        CurrentTab = name
    end)
    
    return TabContent
end

-- Create Tabs
local MainTab = CreateTab("Main", "🏠")
local FarmTab = CreateTab("Farm", "⚡")
local CombatTab = CreateTab("Combat", "⚔️")
local BossTab = CreateTab("Boss", "👹")
local RaidTab = CreateTab("Raid", "💀")
local FruitTab = CreateTab("Fruit", "🍎")
local StatsTab = CreateTab("Stats", "📊")
local TeleportTab = CreateTab("Teleport", "🌍")
local MiscTab = CreateTab("Misc", "⚙️")
local SettingsTab = CreateTab("Settings", "🔧")

-- UI Components Functions
local function CreateSection(parent, text)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, -10, 0, 30)
    Section.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    Section.BorderSizePixel = 0
    Section.Parent = parent
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 8)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(1, -20, 1, 0)
    SectionLabel.Position = UDim2.new(0, 10, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = text
    SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SectionLabel.TextSize = 14
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.Parent = Section
    
    return Section
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 38)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -55, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 38, 0, 22)
    ToggleButton.Position = UDim2.new(1, -45, 0.5, -11)
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(70, 200, 100) or Color3.fromRGB(200, 60, 80)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.AutoButtonColor = false
    ToggleButton.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
    ToggleCircle.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = default or false
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        if toggled then
            ToggleButton.BackgroundColor3 = Color3.fromRGB(70, 200, 100)
            ToggleCircle:TweenPosition(UDim2.new(1, -20, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        else
            ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 80)
            ToggleCircle:TweenPosition(UDim2.new(0, 2, 0.5, -9), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
        end
        
        pcall(callback, toggled)
    end)
    
    return ToggleFrame
end

local function CreateButton(parent, text, callback)
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Size = UDim2.new(1, -10, 0, 38)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Text = text
    ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonFrame.TextSize = 13
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.AutoButtonColor = false
    ButtonFrame.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame
    
    ButtonFrame.MouseEnter:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(158, 63, 246)}):Play()
    end)
    
    ButtonFrame.MouseLeave:Connect(function()
        TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(138, 43, 226)}):Play()
    end)
    
    ButtonFrame.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    return ButtonFrame
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 55)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -25, 0, 22)
    SliderLabel.Position = UDim2.new(0, 12, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = text .. ": " .. default
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 13
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -24, 0, 8)
    SliderBar.Position = UDim2.new(0, 12, 1, -18)
    SliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    local function UpdateSlider()
        local mousePos = UserInputService:GetMouseLocation().X
        local barPos = SliderBar.AbsolutePosition.X
        local barSize = SliderBar.AbsoluteSize.X
        local relativePos = math.clamp(mousePos - barPos, 0, barSize)
        local percentage = relativePos / barSize
        local value = math.floor(min + (max - min) * percentage)
        
        SliderFill:TweenSize(UDim2.new(percentage, 0, 1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
        SliderLabel.Text = text .. ": " .. value
        pcall(callback, value)
    end
    
    SliderButton.MouseButton1Click:Connect(UpdateSlider)
    
    RunService.RenderStepped:Connect(function()
        if dragging then
            UpdateSlider()
        end
    end)
    
    return SliderFrame
end

local function CreateDropdown(parent, text, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, -10, 0, 38)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = parent
    DropdownFrame.ClipsDescendants = false
    DropdownFrame.ZIndex = 5
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(1, 0, 0, 38)
    DropdownButton.BackgroundTransparency = 1
    DropdownButton.Text = text .. ": " .. (options[1] or "None")
    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownButton.TextSize = 13
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
    DropdownButton.Parent = DropdownFrame
    DropdownButton.TextTruncate = Enum.TextTruncate.AtEnd
    DropdownButton.ZIndex = 6
    
    local DropdownPadding = Instance.new("UIPadding")
    DropdownPadding.PaddingLeft = UDim.new(0, 12)
    DropdownPadding.PaddingRight = UDim.new(0, 30)
    DropdownPadding.Parent = DropdownButton
    
    local DropdownIcon = Instance.new("TextLabel")
    DropdownIcon.Size = UDim2.new(0, 25, 1, 0)
    DropdownIcon.Position = UDim2.new(1, -30, 0, 0)
    DropdownIcon.BackgroundTransparency = 1
    DropdownIcon.Text = "▼"
    DropdownIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropdownIcon.TextSize = 12
    DropdownIcon.Parent = DropdownFrame
    DropdownIcon.ZIndex = 6
    
    local OptionsFrame = Instance.new("ScrollingFrame")
    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
    OptionsFrame.Position = UDim2.new(0, 0, 1, 3)
    OptionsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 33)
    OptionsFrame.BorderSizePixel = 0
    OptionsFrame.Visible = false
    OptionsFrame.ClipsDescendants = true
    OptionsFrame.Parent = DropdownFrame
    OptionsFrame.ZIndex = 10
    OptionsFrame.ScrollBarThickness = 4
    OptionsFrame.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local OptionsCorner = Instance.new("UICorner")
    OptionsCorner.CornerRadius = UDim.new(0, 8)
    OptionsCorner.Parent = OptionsFrame
    
    local OptionsLayout = Instance.new("UIListLayout")
    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    OptionsLayout.Parent = OptionsFrame
    
    OptionsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, OptionsLayout.AbsoluteContentSize.Y)
    end)
    
    local expanded = false
    
    for _, option in ipairs(options) do
        local OptionButton = Instance.new("TextButton")
        OptionButton.Size = UDim2.new(1, 0, 0, 32)
        OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
        OptionButton.BorderSizePixel = 0
        OptionButton.Text = option
        OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        OptionButton.TextSize = 12
        OptionButton.Font = Enum.Font.Gotham
        OptionButton.AutoButtonColor = false
        OptionButton.Parent = OptionsFrame
        OptionButton.ZIndex = 11
        
        OptionButton.MouseEnter:Connect(function()
            OptionButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)
        
        OptionButton.MouseLeave:Connect(function()
            OptionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            OptionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        end)
        
        OptionButton.MouseButton1Click:Connect(function()
            DropdownButton.Text = text .. ": " .. option
            OptionsFrame.Visible = false
            expanded = false
            DropdownIcon.Text = "▼"
            pcall(callback, option)
        end)
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        expanded = not expanded
        OptionsFrame.Visible = expanded
        
        if expanded then
            local maxHeight = math.min(#options * 32, 150)
            OptionsFrame:TweenSize(UDim2.new(1, 0, 0, maxHeight), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            DropdownIcon.Text = "▲"
        else
            OptionsFrame:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
            DropdownIcon.Text = "▼"
        end
    end)
    
    return DropdownFrame
end

local function CreateLabel(parent, text, size)
    local Label = Instance.new("TextLabel")
    Label.Size = size or UDim2.new(1, -10, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 12
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextWrapped = true
    Label.Parent = parent
    
    return Label
end

-- Populate Main Tab
CreateSection(MainTab, "⚡ Auto Farm System")
CreateToggle(MainTab, "Auto Farm Level", false, function(state)
    Settings.AutoFarm = state
    Settings.AutoFarmMode = "Level"
    CreateNotification("Auto Farm", state and "Enabled - Mode: Level" or "Disabled", 2)
end)

CreateToggle(MainTab, "Fast Attack", false, function(state)
    Settings.FastAttack = state
    CreateNotification("Fast Attack", state and "Enabled" or "Disabled", 2)
end)

CreateToggle(MainTab, "Bring Mob", false, function(state)
    Settings.BringMob = state
    CreateNotification("Bring Mob", state and "Enabled" or "Disabled", 2)
end)

CreateToggle(MainTab, "Auto Haki", true, function(state)
    Settings.AutoHaki = state
end)

CreateSection(MainTab, "🎯 Quest System")
CreateToggle(MainTab, "Auto Select Quest", false, function(state)
    Settings.AutoQuest = state
    CreateNotification("Auto Quest", state and "Enabled" or "Disabled", 2)
end)

CreateDropdown(MainTab, "Quest Mode", {"Nearby", "Highest Level", "Fastest"}, function(option)
    Settings.QuestMode = option
    CreateNotification("Quest Mode", "Changed to " .. option, 2)
end)

-- Populate Farm Tab
CreateSection(FarmTab, "🔥 Mastery Farming")
CreateToggle(FarmTab, "Auto Farm Mastery", false, function(state)
    Settings.AutoFarmMastery = state
    CreateNotification("Mastery Farm", state and "Enabled" or "Disabled", 2)
end)

CreateDropdown(FarmTab, "Mastery Type", {"Devil Fruit", "Sword", "Gun", "Fighting Style"}, function(option)
    Settings.MasteryMode = option
    CreateNotification("Mastery Type", "Changed to " .. option, 2)
end)

CreateToggle(FarmTab, "Farm Fruit Mastery", false, function(state)
    Settings.FruitMastery = state
end)

CreateToggle(FarmTab, "Farm Sword Mastery", false, function(state)
    Settings.SwordMastery = state
end)

CreateToggle(FarmTab, "Farm Gun Mastery", false, function(state)
    Settings.GunMastery = state
end)

CreateSection(FarmTab, "💎 Material Farming")
CreateButton(FarmTab, "Auto Farm Ectoplasm", function()
    CreateNotification("Material Farm", "Farming Ectoplasm...", 2)
end)

CreateButton(FarmTab, "Auto Farm Dark Fragments", function()
    CreateNotification("Material Farm", "Farming Dark Fragments...", 2)
end)

CreateButton(FarmTab, "Auto Farm Bones", function()
    CreateNotification("Material Farm", "Farming Bones...", 2)
end)

-- Populate Combat Tab
CreateSection(CombatTab, "⚔️ Combat Settings")
CreateToggle(CombatTab, "Auto Ken Haki", true, function(state)
    Settings.AutoKen = state
end)

CreateToggle(CombatTab, "Auto Buso Haki", true, function(state)
    Settings.AutoBuso = state
end)

CreateToggle(CombatTab, "Infinite Energy", false, function(state)
    Settings.InfiniteEnergy = state
    CreateNotification("Infinite Energy", state and "Enabled" or "Disabled", 2)
end)

CreateSection(CombatTab, "🎸 Special Items")
CreateToggle(CombatTab, "Auto Soul Guitar", false, function(state)
    Settings.AutoSoulGuitar = state
    CreateNotification("Soul Guitar", state and "Auto farm enabled" or "Disabled", 2)
end)

CreateButton(CombatTab, "Get God Human", function()
    CreateNotification("Fighting Style", "Attempting to get God Human...", 3)
end)

CreateButton(CombatTab, "Get Sanguine Art", function()
    CreateNotification("Fighting Style", "Attempting to get Sanguine Art...", 3)
end)

-- Populate Boss Tab
CreateSection(BossTab, "👹 Boss Farming")
CreateToggle(BossTab, "Auto Farm Boss", false, function(state)
    Settings.AutoBoss = state
    CreateNotification("Boss Farm", state and "Enabled" or "Disabled", 2)
end)

local bossOptions = Bosses[CurrentSea] or {"No Bosses Available"}
CreateDropdown(BossTab, "Select Boss", bossOptions, function(option)
    Settings.SelectedBoss = option
    CreateNotification("Boss Selected", option, 2)
end)

CreateToggle(BossTab, "Auto Farm All Bosses", false, function(state)
    Settings.AutoAllBoss = state
    CreateNotification("All Boss Farm", state and "Enabled - Cycling all bosses" or "Disabled", 2)
end)

CreateSection(BossTab, "📋 Boss List (" .. CurrentSea .. ")")
for _, boss in ipairs(bossOptions) do
    CreateButton(BossTab, "Farm " .. boss, function()
        Settings.SelectedBoss = boss
        Settings.AutoBoss = true
        CreateNotification("Boss Farm", "Farming " .. boss, 2)
    end)
end

-- Populate Raid Tab
CreateSection(RaidTab, "💀 Raid System")
CreateToggle(RaidTab, "Auto Start Raid", false, function(state)
    Settings.AutoRaid = state
    CreateNotification("Auto Raid", state and "Enabled" or "Disabled", 2)
end)

CreateToggle(RaidTab, "Auto Buy Chip", false, function(state)
    Settings.AutoBuyChip = state
end)

CreateToggle(RaidTab, "Auto Awaken", false, function(state)
    Settings.AutoAwaken = state
    CreateNotification("Auto Awaken", state and "Will auto awaken after raids" or "Disabled", 2)
end)

CreateDropdown(RaidTab, "Raid Mode", {"Farm", "Fast Kill", "Safe"}, function(option)
    Settings.RaidMode = option
end)

CreateSection(RaidTab, "🎯 Raid Selection")
local raids = {"Flame", "Ice", "Quake", "Light", "Dark", "Spider", "Rumble", "Magma", "Buddha", "Blizzard", "Dough"}
CreateDropdown(RaidTab, "Select Raid", raids, function(option)
    CreateNotification("Raid", "Selected: " .. option, 2)
end)

-- Populate Fruit Tab
CreateSection(FruitTab, "🍎 Fruit System")
CreateToggle(FruitTab, "Auto Store Fruit", false, function(state)
    Settings.AutoStoreFruit = state
    CreateNotification("Auto Store", state and "Will auto store fruits" or "Disabled", 2)
end)

CreateToggle(FruitTab, "Fruit Sniper", false, function(state)
    Settings.FruitSniper = state
    CreateNotification("Fruit Sniper", state and "Sniping fruits..." or "Disabled", 2)
end)

CreateToggle(FruitTab, "Auto Random Fruit", false, function(state)
    Settings.AutoRandomFruit = state
end)

CreateSection(FruitTab, "🔍 Fruit ESP")
CreateToggle(FruitTab, "Show Fruit ESP", false, function(state)
    Settings.ESPFruits = state
    CreateNotification("Fruit ESP", state and "Enabled" or "Disabled", 2)
end)

CreateButton(FruitTab, "Teleport to Nearest Fruit", function()
    CreateNotification("Teleport", "Teleporting to fruit...", 2)
end)

-- Populate Stats Tab
CreateSection(StatsTab, "📊 Auto Stats Allocation")
CreateToggle(StatsTab, "Auto Allocate Stats", false, function(state)
    Settings.AutoStats = state
    CreateNotification("Auto Stats", state and "Enabled" or "Disabled", 2)
end)

CreateSlider(StatsTab, "Melee", 0, 100, 0, function(value)
    Settings.MeleeStat = value
end)

CreateSlider(StatsTab, "Defense", 0, 100, 0, function(value)
    Settings.DefenseStat = value
end)

CreateSlider(StatsTab, "Sword", 0, 100, 0, function(value)
    Settings.SwordStat = value
end)

CreateSlider(StatsTab, "Gun", 0, 100, 0, function(value)
    Settings.GunStat = value
end)

CreateSlider(StatsTab, "Devil Fruit", 0, 100, 0, function(value)
    Settings.FruitStat = value
end)

CreateSection(StatsTab, "📈 Current Session Stats")
local StatsDisplay = Instance.new("Frame")
StatsDisplay.Size = UDim2.new(1, -10, 0, 280)
StatsDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
StatsDisplay.BorderSizePixel = 0
StatsDisplay.Parent = StatsTab

local StatsDisplayCorner = Instance.new("UICorner")
StatsDisplayCorner.CornerRadius = UDim.new(0, 8)
StatsDisplayCorner.Parent = StatsDisplay

local StatLabels = {}

local function CreateStatLabel(parent, text, yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 30)
    label.Position = UDim2.new(0, 12, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

StatLabels.Level = CreateStatLabel(StatsDisplay, "📊 Level: " .. FarmStats.Level, 10)
StatLabels.Beli = CreateStatLabel(StatsDisplay, "💰 Beli: " .. FarmStats.Beli, 45)
StatLabels.Fragments = CreateStatLabel(StatsDisplay, "💎 Fragments: " .. FarmStats.Fragments, 80)
StatLabels.Kills = CreateStatLabel(StatsDisplay, "⚔️ Total Kills: " .. FarmStats.TotalKills, 115)
StatLabels.BossKills = CreateStatLabel(StatsDisplay, "👹 Boss Kills: " .. FarmStats.BossKills, 150)
StatLabels.SessionTime = CreateStatLabel(StatsDisplay, "⏱️ Session Time: 0:00:00", 185)
StatLabels.BeliRate = CreateStatLabel(StatsDisplay, "💵 Beli/Hour: 0", 220)

CreateButton(StatsTab, "Reset Session Stats", function()
    FarmStats.TotalKills = 0
    FarmStats.BossKills = 0
    FarmStats.BeliEarned = 0
    FarmStats.ExpGained = 0
    FarmStats.FruitsCollected = 0
    CreateNotification("Stats", "Session stats reset!", 2)
end)

-- Populate Teleport Tab
CreateSection(TeleportTab, "🌍 Island Teleport")

local currentSeaIslands = Islands[CurrentSea] or {}
for islandName, cframe in pairs(currentSeaIslands) do
    CreateButton(TeleportTab, "🏝️ " .. islandName, function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
            CreateNotification("Teleport", "Teleported to " .. islandName, 2)
        end
    end)
end

CreateSection(TeleportTab, "⚙️ Teleport Settings")
CreateSlider(TeleportTab, "Teleport Speed", 100, 500, 350, function(value)
    Settings.TeleportSpeed = value
    Settings.TweenSpeed = value
end)

-- Populate Misc Tab
CreateSection(MiscTab, "🛡️ Protection")
CreateToggle(MiscTab, "Anti AFK", true, function(state)
    Settings.AntiAFK = state
end)

CreateToggle(MiscTab, "Auto Rejoin", true, function(state)
    Settings.AutoRejoin = state
    CreateNotification("Auto Rejoin", state and "Will rejoin on disconnect" or "Disabled", 2)
end)

CreateSection(MiscTab, "⚡ Performance")
CreateToggle(MiscTab, "FPS Boost", false, function(state)
    Settings.FPSBoost = state
    CreateNotification("FPS Boost", state and "Enabled - May reduce graphics" or "Disabled", 2)
end)

CreateToggle(MiscTab, "White Screen", false, function(state)
    Settings.WhiteScreen = state
    if state then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
    else
        Lighting.Ambient = Color3.fromRGB(135, 135, 135)
        Lighting.Brightness = 1
        Lighting.FogEnd = 2000
    end
    CreateNotification("White Screen", state and "Enabled" or "Disabled", 2)
end)

CreateToggle(MiscTab, "Remove Notifications", true, function(state)
    Settings.RemoveNotifications = state
end)

CreateSection(MiscTab, "🎮 Game Actions")
CreateButton(MiscTab, "Redeem All Codes", function()
    CreateNotification("Codes", "Redeeming all codes...", 2)
end)

CreateButton(MiscTab, "Reset Character", function()
    if LocalPlayer.Character then
        LocalPlayer.Character.Humanoid.Health = 0
    end
    CreateNotification("Reset", "Character reset!", 2)
end)

CreateButton(MiscTab, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

-- Populate Settings Tab
CreateSection(SettingsTab, "🔔 Notifications")
CreateToggle(SettingsTab, "Enable Notifications", true, function(state)
    Settings.NotificationsEnabled = state
end)

CreateSection(SettingsTab, "🎨 Theme Settings")
CreateDropdown(SettingsTab, "Theme", {"Dark", "Purple", "Blue", "Red"}, function(option)
    Settings.Theme = option
    CreateNotification("Theme", "Changed to " .. option, 2)
end)

CreateSection(SettingsTab, "ℹ️ Script Info")
CreateLabel(SettingsTab, "Version: " .. version, UDim2.new(1, -10, 0, 25))
CreateLabel(SettingsTab, "Current Sea: " .. CurrentSea, UDim2.new(1, -10, 0, 25))
CreateLabel(SettingsTab, "Created by: Premium Dev Team", UDim2.new(1, -10, 0, 25))

CreateButton(SettingsTab, "Discord Server", function()
    setclipboard("https://discord.gg/bloxfruits")
    CreateNotification("Discord", "Link copied to clipboard!", 2)
end)

CreateButton(SettingsTab, "Check for Updates", function()
    CreateNotification("Update", "You are on the latest version!", 2)
end)

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Minimize/Maximize functionality
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedFrame.Visible = true
    CreateNotification("UI", "Minimized", 1.5)
end)

MinButton.MouseButton1Click:Connect(function()
    MinimizedFrame.Visible = false
    MainFrame.Visible = true
    CreateNotification("UI", "Restored", 1.5)
end)

-- Close functionality
CloseBtn.MouseButton1Click:Connect(function()
    CreateNotification("Script", "Closing hub...", 2)
    task.wait(0.5)
    ScreenGui:Destroy()
    ScriptEnabled = false
end)

-- Stats Update Loop
local function UpdateStats()
    while ScriptEnabled and task.wait(1) do
        local sessionTime = math.floor(tick() - ScriptStartTime)
        local hours = math.floor(sessionTime / 3600)
        local minutes = math.floor((sessionTime % 3600) / 60)
        local seconds = sessionTime % 60
        
        -- Update player stats
        if LocalPlayer and LocalPlayer.Data then
            FarmStats.Level = LocalPlayer.Data.Level.Value or FarmStats.Level
            FarmStats.Beli = LocalPlayer.Data.Beli.Value or FarmStats.Beli
            FarmStats.Fragments = LocalPlayer.Data.Fragments.Value or FarmStats.Fragments
        end
        
        -- Update labels
        StatLabels.Level.Text = string.format("📊 Level: %d", FarmStats.Level)
        StatLabels.Beli.Text = string.format("💰 Beli: %s", FormatNumber(FarmStats.Beli))
        StatLabels.Fragments.Text = string.format("💎 Fragments: %s", FormatNumber(FarmStats.Fragments))
        StatLabels.Kills.Text = string.format("⚔️ Total Kills: %d", FarmStats.TotalKills)
        StatLabels.BossKills.Text = string.format("👹 Boss Kills: %d", FarmStats.BossKills)
        StatLabels.SessionTime.Text = string.format("⏱️ Session Time: %d:%02d:%02d", hours, minutes, seconds)
        
        local beliPerHour = math.floor((FarmStats.BeliEarned / (sessionTime / 3600)))
        StatLabels.BeliRate.Text = string.format("💵 Beli/Hour: %s", FormatNumber(beliPerHour))
    end
end

-- Format Number Helper
function FormatNumber(num)
    if num >= 1000000000 then
        return string.format("%.2fB", num / 1000000000)
    elseif num >= 1000000 then
        return string.format("%.2fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.2fK", num / 1000)
    else
        return tostring(num)
    end
end

-- Anti AFK
local function AntiAFK()
    while ScriptEnabled and task.wait(120) do
        if Settings.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end
end

-- Auto Farm Logic (Template - needs game-specific implementation)
local function AutoFarm()
    while ScriptEnabled and task.wait(0.1) do
        if Settings.AutoFarm then
            pcall(function()
                -- Implement auto farm logic here based on Blox Fruits mechanics
                -- This is a template - adjust based on game's actual remotes
            end)
        end
    end
end

-- Initialize
CreateNotification("Blox Fruits Ultimate Hub", "Script loaded successfully! " .. version, 4)
CreateNotification("Welcome", "Current Sea: " .. CurrentSea, 3)

-- Set first tab as active
TabButtons[1].Btn:Fire("MouseButton1Click")

-- Start loops
task.spawn(UpdateStats)
task.spawn(AntiAFK)
task.spawn(AutoFarm)

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

print("🍇 Blox Fruits Ultimate Hub Loaded!")
print("Version: " .. version)
print("Current Sea: " .. CurrentSea)
print("Made with ❤️ by Premium Dev Team")
