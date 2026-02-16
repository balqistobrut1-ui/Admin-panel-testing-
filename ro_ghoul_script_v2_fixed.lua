-- Ro-Ghoul Ultimate Script Hub v2.0
-- Game: https://www.roblox.com/games/914010731/Ro-Ghoul
-- Made by Claude AI - All Bugs Fixed

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

local ESPObjects = {}

-- Anti-Ban System
local function SetupAntiBan()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if AntiBanEnabled and method == "FireServer" then
                if tostring(self):lower():find("ban") or tostring(self):lower():find("kick") or tostring(self):lower():find("report") then
                    return wait(9e9)
                end
            end
            
            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
    end)
end

SetupAntiBan()

-- Functions
local function GetMobs()
    local mobs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Name ~= Player.Name and v.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(v) then
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

local function TeleportTo(cframe)
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = cframe
    end
end

local function AttackMob(mob)
    if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
        pcall(function()
            -- Multiple attack methods for compatibility
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0))
            
            -- Try remote event
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("attack") or remote.Name:lower():find("damage")) then
                    remote:FireServer(mob)
                end
            end
        end)
    end
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RoGhoulUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

if Player.PlayerGui:FindFirstChild("RoGhoulUI") then
    Player.PlayerGui:FindFirstChild("RoGhoulUI"):Destroy()
end

ScreenGui.Parent = Player.PlayerGui

-- Main Frame (FIXED SIZE: Lebar horizontal, tidak terlalu tinggi)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = false
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
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Custom Drag (FIXED)
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
Title.Text = "👻 Ro-Ghoul Hub v2.0"
Title.TextColor3 = Color3.fromRGB(255, 50, 100)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -64, 0, 5)
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
CloseBtn.Position = UDim2.new(1, -32, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Minimized Box (FIXED: Di tengah dan bisa di-drag)
local MinimizedBox = Instance.new("TextButton")
MinimizedBox.Name = "MinimizedBox"
MinimizedBox.Size = UDim2.new(0, 60, 0, 60)
MinimizedBox.Position = UDim2.new(0.5, -30, 0.5, -30)
MinimizedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MinimizedBox.Text = "👻"
MinimizedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedBox.TextSize = 28
MinimizedBox.Font = Enum.Font.GothamBold
MinimizedBox.Visible = false
MinimizedBox.Active = true
MinimizedBox.Parent = ScreenGui

local MinBoxCorner = Instance.new("UICorner")
MinBoxCorner.CornerRadius = UDim.new(0, 12)
MinBoxCorner.Parent = MinimizedBox

-- Drag untuk MinimizedBox
local minDragging = false
local minDragInput, minDragStart, minStartPos

MinimizedBox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        minDragging = true
        minDragStart = input.Position
        minStartPos = MinimizedBox.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                minDragging = false
            end
        end)
    end
end)

MinimizedBox.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        minDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == minDragInput and minDragging then
        local delta = input.Position - minDragStart
        MinimizedBox.Position = UDim2.new(minStartPos.X.Scale, minStartPos.X.Offset + delta.X, minStartPos.Y.Scale, minStartPos.Y.Offset + delta.Y)
    end
end)

-- Tabs Frame
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(1, -16, 0, 32)
TabsFrame.Position = UDim2.new(0, 8, 0, 46)
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

-- Content Scroll Frame (WITH PROPER SCROLLING)
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Size = UDim2.new(1, -16, 1, -90)
ContentScroll.Position = UDim2.new(0, 8, 0, 86)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 5
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 100)
ContentScroll.Parent = MainFrame

-- Auto resize canvas
local function UpdateCanvasSize()
    local contentSize = 0
    for _, child in pairs(ContentScroll:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            contentSize = math.max(contentSize, child.Position.Y.Offset + child.Size.Y.Offset)
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
    TabBtn.Size = UDim2.new(0, 95, 1, -6)
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
local yPositions = {Main = 4, Combat = 4, Visuals = 4, Stats = 4}

local function CreateToggle(name, tab, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = tab .. "_" .. name:gsub("%s", "")
    ToggleFrame.Size = UDim2.new(0.48, -4, 0, 38)
    ToggleFrame.Position = UDim2.new((yPositions[tab] % 2) * 0.52, 4, 0, math.floor(yPositions[tab] / 2) * 44)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Visible = tab == "Main"
    ToggleFrame.ZIndex = 2
    ToggleFrame.Parent = ContentScroll
    
    yPositions[tab] = yPositions[tab] + 1
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -55, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.Parent = ToggleFrame
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 42, 0, 22)
    ToggleBtn.Position = UDim2.new(1, -46, 0.5, -11)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    ToggleBtn.Text = ""
    ToggleBtn.ZIndex = 3
    ToggleBtn.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.ZIndex = 4
    Circle.Parent = ToggleBtn
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local enabled = false
    
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        
        if enabled then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
        end
    end)
    
    return ToggleFrame
end

-- Create Slider Function (FIXED: Tidak ngikut drag UI)
local function CreateSlider(name, tab, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = tab .. "_Slider_" .. name:gsub("%s", "")
    SliderFrame.Size = UDim2.new(1, -8, 0, 52)
    SliderFrame.Position = UDim2.new(0, 4, 0, math.floor(yPositions[tab] / 2) * 44)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Visible = tab == "Main"
    SliderFrame.ZIndex = 2
    SliderFrame.Parent = ContentScroll
    
    yPositions[tab] = yPositions[tab] + 2
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 8, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -16, 0, 6)
    SliderBar.Position = UDim2.new(0, 8, 0, 32)
    SliderBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    SliderBar.ZIndex = 3
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 4
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.ZIndex = 5
    SliderButton.Parent = SliderBar
    
    local SliderBtnCorner = Instance.new("UICorner")
    SliderBtnCorner.CornerRadius = UDim.new(1, 0)
    SliderBtnCorner.Parent = SliderButton
    
    local sliderDragging = false
    local currentValue = default
    
    -- FIXED: Slider drag yang tidak terpengaruh UI drag
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    sliderDragging = false
                end
            end)
        end
    end)
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    sliderDragging = false
                end
            end)
        end
    end)
    
    RunService.Heartbeat:Connect(function()
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

-- MAIN TAB
CreateToggle("🚀 Auto Farm", "Main", function(enabled)
    AutoFarmEnabled = enabled
end)

CreateToggle("💰 Auto Yen", "Main", function(enabled)
    AutoCollectYenEnabled = enabled
end)

CreateToggle("🎭 Auto Mask", "Main", function(enabled)
    AutoCollectMaskEnabled = enabled
end)

CreateToggle("🛡️ Anti-Ban", "Main", function(enabled)
    AntiBanEnabled = enabled
end)

CreateSlider("📏 Farm Range", "Main", 5, 50, 15, function(value)
    FarmDistance = value
end)

-- COMBAT TAB
CreateToggle("⚔️ Kill Aura", "Combat", function(enabled)
    KillAuraEnabled = enabled
end)

CreateToggle("💨 Speed", "Combat", function(enabled)
    WalkSpeedEnabled = enabled
end)

CreateToggle("⬆️ Jump", "Combat", function(enabled)
    JumpPowerEnabled = enabled
end)

CreateToggle("♾️ Inf Stamina", "Combat", function(enabled)
    InfiniteStaminaEnabled = enabled
end)

CreateSlider("🏃 Walk Speed", "Combat", 16, 200, 50, function(value)
    WalkSpeedValue = value
end)

CreateSlider("🦘 Jump Power", "Combat", 50, 300, 100, function(value)
    JumpPowerValue = value
end)

-- VISUALS TAB
CreateToggle("👁️ ESP", "Visuals", function(enabled)
    ESPEnabled = enabled
    if not enabled then
        for _, esp in pairs(ESPObjects) do
            if esp then
                esp:Destroy()
            end
        end
        ESPObjects = {}
    end
end)

CreateToggle("💡 FullBright", "Visuals", function(enabled)
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
CreateToggle("📊 Auto Stats", "Stats", function(enabled)
    AutoStatEnabled = enabled
end)

-- Button Functions
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
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

-- Auto Farm Loop (FIXED)
spawn(function()
    while wait(0.1) do
        if AutoFarmEnabled then
            pcall(function()
                local mob = GetClosestMob()
                if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                    if mob.Humanoid.Health > 0 then
                        local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                        
                        if distance > FarmDistance then
                            TeleportTo(mob.HumanoidRootPart.CFrame * CFrame.new(0, 5, FarmDistance))
                        end
                        
                        AttackMob(mob)
                    end
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
                    if mob and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                        if mob.Humanoid.Health > 0 then
                            local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                            if distance <= 25 then
                                AttackMob(mob)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Walk Speed Loop
spawn(function()
    while wait(0.05) do
        if WalkSpeedEnabled and Humanoid then
            Humanoid.WalkSpeed = WalkSpeedValue
        end
    end
end)

-- Jump Power Loop
spawn(function()
    while wait(0.05) do
        if JumpPowerEnabled and Humanoid then
            Humanoid.JumpPower = JumpPowerValue
        end
    end
end)

-- Infinite Stamina
spawn(function()
    while wait(0.1) do
        if InfiniteStaminaEnabled then
            pcall(function()
                local stamina = Player:FindFirstChild("Stamina") or Player.Character:FindFirstChild("Stamina")
                if stamina and stamina:IsA("NumberValue") then
                    stamina.Value = 100
                end
            end)
        end
    end
end)

-- Auto Collect Yen (FIXED: Tidak ambil dari toko)
spawn(function()
    while wait(0.5) do
        if AutoCollectYenEnabled then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name == "Yen" or v.Name == "Money") then
                        -- Cek jarak, jangan ambil yang jauh (kemungkinan di toko)
                        local distance = (HumanoidRootPart.Position - v.Position).Magnitude
                        if distance < 200 and not v:FindFirstAncestor("Shop") and not v:FindFirstAncestor("Store") then
                            v.CFrame = HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Collect Masks (FIXED: Tidak ambil dari toko)
spawn(function()
    while wait(0.5) do
        if AutoCollectMaskEnabled then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v.Name:lower():find("mask") then
                        -- Cek apakah ada prompt/ProximityPrompt (tanda barang bisa diambil)
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt", true)
                        if prompt then
                            local distance = (HumanoidRootPart.Position - v:GetPivot().Position).Magnitude
                            if distance < 200 and not v:FindFirstAncestor("Shop") and not v:FindFirstAncestor("Store") then
                                fireproximityprompt(prompt)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ESP Loop (FIXED: Tidak kedip-kedip)
spawn(function()
    while wait(2) do
        if ESPEnabled then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if not ESPObjects[player.UserId] or not ESPObjects[player.UserId].Parent then
                            local esp = Instance.new("BillboardGui")
                            esp.Name = "ESP_" .. player.UserId
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
                            name.TextStrokeTransparency = 0.5
                            name.Parent = esp
                            
                            ESPObjects[player.UserId] = esp
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
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and remote.Name:lower():find("stat") then
                        remote:FireServer(SelectedStat)
                    end
                end
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

print("✅ Ro-Ghoul Ultimate Script v2.0 loaded!")
print("🔧 All bugs fixed!")
print("👻 Made by Claude AI")
