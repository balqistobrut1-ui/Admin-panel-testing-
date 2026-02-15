-- Ro-Ghoul Ultimate Script Hub
-- Game: https://www.roblox.com/games/914010731/Ro-Ghoul
-- Made by Claude AI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Variables
local ScriptEnabled = true
local AutoFarmEnabled = false
local AutoStatEnabled = false
local ESPEnabled = false
local FullBrightEnabled = false
local InfiniteStaminaEnabled = false
local WalkSpeedEnabled = false
local JumpPowerEnabled = false
local AutoCollectYenEnabled = false
local AutoCollectMaskEnabled = false
local KillAuraEnabled = false
local AntiBanEnabled = true

local WalkSpeedValue = 50
local JumpPowerValue = 100
local FarmDistance = 15
local SelectedStat = "Strength"
local SelectedMob = "All"

-- Anti-Ban System
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(Self, ...)
    local Args = {...}
    local Method = getnamecallmethod()
    
    if AntiBanEnabled and Method == "FireServer" then
        if tostring(Self):find("Ban") or tostring(Self):find("Kick") or tostring(Self):find("Report") then
            return wait(9e9)
        end
    end
    
    return OldNamecall(Self, ...)
end)

-- Functions
local function GetMobs()
    local mobs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Name ~= Player.Name and v.Humanoid.Health > 0 then
                table.insert(mobs, v)
            end
        end
    end
    return mobs
end

local function GetClosestMob()
    local closest = nil
    local closestDistance = math.huge
    
    for _, mob in pairs(GetMobs()) do
        if mob and mob:FindFirstChild("HumanoidRootPart") then
            local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closest = mob
                closestDistance = distance
            end
        end
    end
    
    return closest
end

local function TeleportTo(position)
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

local function AttackMob(mob)
    if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
        -- Click attack
        local args = {
            [1] = "Click",
            [2] = mob
        }
        game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
    end
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGhoulUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if Player.PlayerGui:FindFirstChild("RoGhoulUI") then
    Player.PlayerGui:FindFirstChild("RoGhoulUI"):Destroy()
end

ScreenGui.Parent = Player.PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Custom Drag
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👻 Ro-Ghoul Hub"
Title.TextColor3 = Color3.fromRGB(255, 50, 100)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -64, 0, 6)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 16
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Minimized Box
local MinimizedBox = Instance.new("TextButton")
MinimizedBox.Size = UDim2.new(0, 50, 0, 50)
MinimizedBox.Position = UDim2.new(0, 10, 0, 10)
MinimizedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MinimizedBox.Text = "👻"
MinimizedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedBox.TextSize = 24
MinimizedBox.Font = Enum.Font.GothamBold
MinimizedBox.Visible = false
MinimizedBox.Parent = ScreenGui

local MinBoxCorner = Instance.new("UICorner")
MinBoxCorner.CornerRadius = UDim.new(0, 10)
MinBoxCorner.Parent = MinimizedBox

-- Tabs Frame
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, -16, 0, 35)
TabsFrame.Position = UDim2.new(0, 8, 0, 48)
TabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
TabsFrame.BorderSizePixel = 0
TabsFrame.Parent = MainFrame

local TabsCorner = Instance.new("UICorner")
TabsCorner.CornerRadius = UDim.new(0, 8)
TabsCorner.Parent = TabsFrame

local TabsLayout = Instance.new("UIListLayout")
TabsLayout.FillDirection = Enum.FillDirection.Horizontal
TabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabsLayout.Padding = UDim.new(0, 5)
TabsLayout.Parent = TabsFrame

-- Content Scroll Frame
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Size = UDim2.new(1, -16, 1, -95)
ContentScroll.Position = UDim2.new(0, 8, 0, 91)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 5
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.Parent = MainFrame

-- Auto resize canvas
local function UpdateCanvasSize()
    local contentSize = 0
    for _, child in pairs(ContentScroll:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            contentSize = contentSize + child.Size.Y.Offset + 6
        end
    end
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, contentSize + 10)
end

-- Tab System
local currentTab = "Main"
local tabs = {"Main", "Combat", "Visuals", "Stats"}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Name = name .. "Tab"
    TabBtn.Size = UDim2.new(0, 70, 1, -6)
    TabBtn.BackgroundColor3 = name == "Main" and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(35, 35, 50)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.TextSize = 12
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Parent = TabsFrame
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabBtn
    
    TabBtn.MouseButton1Click:Connect(function()
        currentTab = name
        for _, tab in pairs(TabsFrame:GetChildren()) do
            if tab:IsA("TextButton") then
                tab.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            end
        end
        TabBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
        
        -- Hide all content
        for _, content in pairs(ContentScroll:GetChildren()) do
            if content:IsA("GuiObject") then
                content.Visible = false
            end
        end
        
        -- Show selected tab content
        for _, content in pairs(ContentScroll:GetChildren()) do
            if content.Name:find(name) then
                content.Visible = true
            end
        end
        
        UpdateCanvasSize()
    end)
    
    return TabBtn
end

for _, tabName in ipairs(tabs) do
    CreateTab(tabName)
end

-- Create Toggle Button Function
local function CreateToggle(name, tab, position, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = tab .. "_" .. name
    ToggleFrame.Size = UDim2.new(1, -8, 0, 40)
    ToggleFrame.Position = position
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Visible = tab == "Main"
    ToggleFrame.Parent = ContentScroll
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 45, 0, 24)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -12)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    ToggleBtn.Text = ""
    ToggleBtn.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = ToggleBtn
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 35, 1, 0)
    Status.Position = UDim2.new(1, -40, 0, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "OFF"
    Status.TextColor3 = Color3.fromRGB(220, 50, 50)
    Status.TextSize = 11
    Status.Font = Enum.Font.GothamBold
    Status.Parent = ToggleFrame
    
    local enabled = false
    
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        
        if enabled then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            Status.Text = "ON"
            Status.TextColor3 = Color3.fromRGB(50, 220, 100)
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            Status.Text = "OFF"
            Status.TextColor3 = Color3.fromRGB(220, 50, 50)
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
    end)
    
    return ToggleFrame
end

-- Create Slider Function
local function CreateSlider(name, tab, position, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = tab .. "_" .. name
    SliderFrame.Size = UDim2.new(1, -8, 0, 55)
    SliderFrame.Position = position
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Visible = tab == "Main"
    SliderFrame.Parent = ContentScroll
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -20, 0, 6)
    SliderBar.Position = UDim2.new(0, 10, 0, 33)
    SliderBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.Parent = SliderBar
    
    local SliderBtnCorner = Instance.new("UICorner")
    SliderBtnCorner.CornerRadius = UDim.new(1, 0)
    SliderBtnCorner.Parent = SliderButton
    
    local sliderDragging = false
    local currentValue = default
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
        end
    end)
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = false
        end
    end)
    
    RunService.RenderStepped:Connect(function()
        if sliderDragging then
            local mousePos = UserInputService:GetMouseLocation()
            local sliderPos = SliderBar.AbsolutePosition
            local sliderSize = SliderBar.AbsoluteSize
            
            local relativePos = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
            local percentage = relativePos / sliderSize.X
            
            currentValue = math.floor(min + (percentage * (max - min)))
            
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            SliderButton.Position = UDim2.new(percentage, -8, 0.5, -8)
            Label.Text = name .. ": " .. currentValue
            
            callback(currentValue)
        end
    end)
    
    return SliderFrame
end

-- Create Dropdown Function
local function CreateDropdown(name, tab, position, options, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = tab .. "_" .. name
    DropdownFrame.Size = UDim2.new(1, -8, 0, 40)
    DropdownFrame.Position = position
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Visible = tab == "Main"
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = ContentScroll
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -35, 0, 40)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. options[1]
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 12
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropdownFrame
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 0, 40)
    Arrow.Position = UDim2.new(1, -25, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    Arrow.TextSize = 12
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = DropdownFrame
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(1, 0, 0, 40)
    DropdownBtn.BackgroundTransparency = 1
    DropdownBtn.Text = ""
    DropdownBtn.Parent = DropdownFrame
    
    local expanded = false
    local selectedOption = options[1]
    
    DropdownBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        
        if expanded then
            DropdownFrame.Size = UDim2.new(1, -8, 0, 40 + (#options * 35))
            Arrow.Text = "▲"
        else
            DropdownFrame.Size = UDim2.new(1, -8, 0, 40)
            Arrow.Text = "▼"
        end
        
        UpdateCanvasSize()
    end)
    
    for i, option in ipairs(options) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Size = UDim2.new(1, -10, 0, 30)
        OptionBtn.Position = UDim2.new(0, 5, 0, 40 + ((i - 1) * 35))
        OptionBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        OptionBtn.Text = option
        OptionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionBtn.TextSize = 11
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.Parent = DropdownFrame
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 6)
        OptionCorner.Parent = OptionBtn
        
        OptionBtn.MouseButton1Click:Connect(function()
            selectedOption = option
            Label.Text = name .. ": " .. option
            callback(option)
            
            DropdownFrame.Size = UDim2.new(1, -8, 0, 40)
            Arrow.Text = "▼"
            expanded = false
            UpdateCanvasSize()
        end)
    end
    
    return DropdownFrame
end

-- MAIN TAB
local yPos = 4

CreateToggle("🚀 Auto Farm Mobs", "Main", UDim2.new(0, 4, 0, yPos), function(enabled)
    AutoFarmEnabled = enabled
end)
yPos = yPos + 46

CreateDropdown("🎯 Select Mob", "Main", UDim2.new(0, 4, 0, yPos), {"All", "Weak", "Medium", "Strong"}, function(selected)
    SelectedMob = selected
end)
yPos = yPos + 46

CreateSlider("📏 Farm Distance", "Main", UDim2.new(0, 4, 0, yPos), 5, 50, 15, function(value)
    FarmDistance = value
end)
yPos = yPos + 61

CreateToggle("💰 Auto Collect Yen", "Main", UDim2.new(0, 4, 0, yPos), function(enabled)
    AutoCollectYenEnabled = enabled
end)
yPos = yPos + 46

CreateToggle("🎭 Auto Collect Masks", "Main", UDim2.new(0, 4, 0, yPos), function(enabled)
    AutoCollectMaskEnabled = enabled
end)
yPos = yPos + 46

CreateToggle("🛡️ Anti-Ban", "Main", UDim2.new(0, 4, 0, yPos), function(enabled)
    AntiBanEnabled = enabled
end)

-- COMBAT TAB
yPos = 4

CreateToggle("⚔️ Kill Aura", "Combat", UDim2.new(0, 4, 0, yPos), function(enabled)
    KillAuraEnabled = enabled
end)
yPos = yPos + 46

CreateSlider("🏃 Walk Speed", "Combat", UDim2.new(0, 4, 0, yPos), 16, 200, 50, function(value)
    WalkSpeedValue = value
end)
yPos = yPos + 61

CreateToggle("💨 Enable Walk Speed", "Combat", UDim2.new(0, 4, 0, yPos), function(enabled)
    WalkSpeedEnabled = enabled
end)
yPos = yPos + 46

CreateSlider("🦘 Jump Power", "Combat", UDim2.new(0, 4, 0, yPos), 50, 300, 100, function(value)
    JumpPowerValue = value
end)
yPos = yPos + 61

CreateToggle("⬆️ Enable Jump Power", "Combat", UDim2.new(0, 4, 0, yPos), function(enabled)
    JumpPowerEnabled = enabled
end)
yPos = yPos + 46

CreateToggle("♾️ Infinite Stamina", "Combat", UDim2.new(0, 4, 0, yPos), function(enabled)
    InfiniteStaminaEnabled = enabled
end)

-- VISUALS TAB
yPos = 4

CreateToggle("👁️ ESP Players", "Visuals", UDim2.new(0, 4, 0, yPos), function(enabled)
    ESPEnabled = enabled
end)
yPos = yPos + 46

CreateToggle("💡 Full Bright", "Visuals", UDim2.new(0, 4, 0, yPos), function(enabled)
    FullBrightEnabled = enabled
    if enabled then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end)

-- STATS TAB
yPos = 4

CreateToggle("📊 Auto Train Stats", "Stats", UDim2.new(0, 4, 0, yPos), function(enabled)
    AutoStatEnabled = enabled
end)
yPos = yPos + 46

CreateDropdown("💪 Select Stat", "Stats", UDim2.new(0, 4, 0, yPos), {"Strength", "Speed", "Durability", "Kagune"}, function(selected)
    SelectedStat = selected
end)

-- Button Functions
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    AutoFarmEnabled = false
    AutoStatEnabled = false
    ESPEnabled = false
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedBox.Visible = true
end)

MinimizedBox.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinimizedBox.Visible = false
end)

UpdateCanvasSize()

-- Auto Farm Loop
spawn(function()
    while wait(0.1) do
        if AutoFarmEnabled then
            pcall(function()
                local mob = GetClosestMob()
                if mob and mob:FindFirstChild("HumanoidRootPart") then
                    local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                    
                    if distance > FarmDistance then
                        TeleportTo(mob.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
                    end
                    
                    AttackMob(mob)
                end
            end)
        end
    end
end)

-- Kill Aura Loop
spawn(function()
    while wait(0.1) do
        if KillAuraEnabled then
            pcall(function()
                for _, mob in pairs(GetMobs()) do
                    if mob and mob:FindFirstChild("HumanoidRootPart") then
                        local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                        if distance <= 20 then
                            AttackMob(mob)
                        end
                    end
                end
            end)
        end
    end
end)

-- Walk Speed Loop
spawn(function()
    while wait(0.1) do
        if WalkSpeedEnabled and Humanoid then
            Humanoid.WalkSpeed = WalkSpeedValue
        end
    end
end)

-- Jump Power Loop
spawn(function()
    while wait(0.1) do
        if JumpPowerEnabled and Humanoid then
            Humanoid.JumpPower = JumpPowerValue
        end
    end
end)

-- Infinite Stamina Loop
spawn(function()
    while wait(0.1) do
        if InfiniteStaminaEnabled then
            pcall(function()
                local stamina = Player:FindFirstChild("Stamina")
                if stamina then
                    stamina.Value = 100
                end
            end)
        end
    end
end)

-- Auto Collect Yen
spawn(function()
    while wait(0.5) do
        if AutoCollectYenEnabled then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name == "Yen" or v.Name == "Money" then
                        if v:IsA("BasePart") then
                            v.CFrame = HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Collect Masks
spawn(function()
    while wait(0.5) do
        if AutoCollectMaskEnabled then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("mask") then
                        if v:IsA("BasePart") then
                            v.CFrame = HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
        end
    end
end)

-- ESP Loop
spawn(function()
    while wait(1) do
        if ESPEnabled then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if not player.Character.HumanoidRootPart:FindFirstChild("ESP") then
                            local esp = Instance.new("BillboardGui")
                            esp.Name = "ESP"
                            esp.Size = UDim2.new(0, 100, 0, 50)
                            esp.StudsOffset = Vector3.new(0, 3, 0)
                            esp.AlwaysOnTop = true
                            esp.Parent = player.Character.HumanoidRootPart
                            
                            local name = Instance.new("TextLabel")
                            name.Size = UDim2.new(1, 0, 1, 0)
                            name.BackgroundTransparency = 1
                            name.Text = player.Name
                            name.TextColor3 = Color3.fromRGB(255, 50, 100)
                            name.TextSize = 14
                            name.Font = Enum.Font.GothamBold
                            name.Parent = esp
                        end
                    end
                end
            end)
        else
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local esp = player.Character.HumanoidRootPart:FindFirstChild("ESP")
                        if esp then
                            esp:Destroy()
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Train Stats
spawn(function()
    while wait(0.5) do
        if AutoStatEnabled then
            pcall(function()
                local args = {
                    [1] = "TrainStat",
                    [2] = SelectedStat
                }
                game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
            end)
        end
    end
end)

-- Character Update
Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end)

print("✅ Ro-Ghoul Ultimate Script loaded!")
print("🎮 Game: Ro-Ghoul")
print("👻 Made by Claude AI")
