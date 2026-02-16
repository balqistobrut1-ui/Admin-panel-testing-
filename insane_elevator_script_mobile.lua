-- Insane Elevator Script with Advanced UI (MOBILE OPTIMIZED)
-- Features: Draggable UI, Minimize/Maximize, Auto Farm, ESP, Speed, Jump, and more
-- MOBILE FLY CONTROLS:
--   • Virtual Joystick (kiri bawah) - Gerak maju/mundur/kiri/kanan
--   • Button UP (▲) - Naik
--   • Button DOWN (▼) - Turun
-- Optimized untuk Android dengan performance tinggi!

local Library = {}

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables
local ScriptEnabled = true
local AutoFarmEnabled = false
local ESPEnabled = false
local SpeedEnabled = false
local JumpEnabled = false
local NoClipEnabled = false
local InfiniteJumpEnabled = false
local FlyEnabled = false
local WalkSpeed = 16
local JumpPower = 50
local FlySpeed = 50

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaneElevatorGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protection
if syn then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
else
    ScreenGui.Parent = CoreGui
end

-- Main Frame (UI Utama)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

-- Rounded corners untuk Main Frame
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 12)
TopBarCorner.Parent = TopBar

-- Fix bottom corners of TopBar
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 12)
TopBarFix.Position = UDim2.new(0, 0, 1, -12)
TopBarFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎮 Insane Elevator Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -35, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Parent = TopBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 6)
MinimizeCorner.Parent = MinimizeButton

-- Minimized Box (Kotak 1:1 saat diminimize)
local MinimizedBox = Instance.new("Frame")
MinimizedBox.Name = "MinimizedBox"
MinimizedBox.Size = UDim2.new(0, 60, 0, 60)
MinimizedBox.Position = UDim2.new(0, 20, 0, 20)
MinimizedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MinimizedBox.BorderSizePixel = 0
MinimizedBox.Visible = false
MinimizedBox.Active = true
MinimizedBox.Draggable = false
MinimizedBox.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(0, 10)
MinimizedCorner.Parent = MinimizedBox

-- Minimized Box Button (untuk buka UI kembali)
local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Name = "MinimizedButton"
MinimizedButton.Size = UDim2.new(1, 0, 1, 0)
MinimizedButton.BackgroundTransparency = 1
MinimizedButton.Text = "🎮"
MinimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedButton.TextSize = 30
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.Parent = MinimizedBox

-- Shadow untuk Minimized Box
local MinimizedShadow = Instance.new("ImageLabel")
MinimizedShadow.Name = "Shadow"
MinimizedShadow.Size = UDim2.new(1, 20, 1, 20)
MinimizedShadow.Position = UDim2.new(0, -10, 0, -10)
MinimizedShadow.BackgroundTransparency = 1
MinimizedShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
MinimizedShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MinimizedShadow.ImageTransparency = 0.5
MinimizedShadow.ZIndex = 0
MinimizedShadow.Parent = MinimizedBox

-- Container untuk konten
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 6
Container.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = MainFrame

local ContainerLayout = Instance.new("UIListLayout")
ContainerLayout.Padding = UDim.new(0, 8)
ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContainerLayout.Parent = Container

-- Auto-resize canvas
ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 10)
end)

-- Function untuk membuat Section
function Library:CreateSection(name)
    local Section = Instance.new("Frame")
    Section.Name = name
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    Section.BorderSizePixel = 0
    Section.Parent = Container
    
    local SectionCorner = Instance.new("UICorner")
    SectionCorner.CornerRadius = UDim.new(0, 6)
    SectionCorner.Parent = Section
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Size = UDim2.new(1, -15, 1, 0)
    SectionLabel.Position = UDim2.new(0, 15, 0, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = name
    SectionLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
    SectionLabel.TextSize = 14
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
    SectionLabel.Parent = Section
    
    return Section
end

-- Function untuk membuat Toggle Button
function Library:CreateToggle(name, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Name = name
    Toggle.Size = UDim2.new(1, 0, 0, 35)
    Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Container
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = Toggle
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    ToggleLabel.TextSize = 13
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = Toggle
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 40, 0, 20)
    ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = Toggle
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = false
    
    ToggleButton.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        if toggled then
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
            TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(1, -18, 0.5, -8)}):Play()
        else
            TweenService:Create(ToggleButton, tweenInfo, {BackgroundColor3 = Color3.fromRGB(60, 60, 75)}):Play()
            TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(0, 2, 0.5, -8)}):Play()
        end
        
        callback(toggled)
    end)
    
    return Toggle
end

-- Function untuk membuat Slider
function Library:CreateSlider(name, min, max, default, callback)
    local Slider = Instance.new("Frame")
    Slider.Name = name
    Slider.Size = UDim2.new(1, 0, 0, 50)
    Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    Slider.BorderSizePixel = 0
    Slider.Parent = Container
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 6)
    SliderCorner.Parent = Slider
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Size = UDim2.new(1, -30, 0, 20)
    SliderLabel.Position = UDim2.new(0, 15, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = name .. ": " .. tostring(default)
    SliderLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    SliderLabel.TextSize = 13
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = Slider
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -30, 0, 6)
    SliderBar.Position = UDim2.new(0, 15, 1, -15)
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    SliderBar.BorderSizePixel = 0
    SliderBar.Parent = Slider
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
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
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            SliderLabel.Text = name .. ": " .. tostring(value)
            callback(value)
        end
    end)
    
    return Slider
end

-- Function untuk membuat Button
function Library:CreateButton(name, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.Font = Enum.Font.GothamBold
    Button.BorderSizePixel = 0
    Button.Parent = Container
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(Button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 100, 180)}):Play()
        wait(0.1)
        TweenService:Create(Button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 120, 215)}):Play()
        callback()
    end)
    
    return Button
end

-- Drag functionality untuk Main Frame
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
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

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Drag functionality untuk Minimized Box
local draggingMin
local dragInputMin
local dragStartMin
local startPosMin

local function updateMin(input)
    local delta = input.Position - dragStartMin
    MinimizedBox.Position = UDim2.new(startPosMin.X.Scale, startPosMin.X.Offset + delta.X, startPosMin.Y.Scale, startPosMin.Y.Offset + delta.Y)
end

MinimizedBox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMin = true
        dragStartMin = input.Position
        startPosMin = MinimizedBox.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingMin = false
            end
        end)
    end
end)

MinimizedBox.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInputMin = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInputMin and draggingMin then
        updateMin(input)
    end
end)

-- Minimize/Maximize functionality
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedBox.Visible = true
end)

MinimizedButton.MouseButton1Click:Connect(function()
    MinimizedBox.Visible = false
    MainFrame.Visible = true
end)

-- ==================== UI ELEMENTS ====================

Library:CreateSection("📊 Main Features")

Library:CreateToggle("Auto Farm Coins", function(enabled)
    AutoFarmEnabled = enabled
    print("Auto Farm:", enabled)
end)

Library:CreateToggle("Auto Survive Floors", function(enabled)
    print("Auto Survive:", enabled)
end)

Library:CreateToggle("Auto Complete Floors", function(enabled)
    print("Auto Complete:", enabled)
end)

Library:CreateSection("👁️ Visual Features")

Library:CreateToggle("Player ESP", function(enabled)
    ESPEnabled = enabled
    print("ESP:", enabled)
end)

Library:CreateToggle("Coin ESP", function(enabled)
    print("Coin ESP:", enabled)
end)

Library:CreateToggle("Item ESP", function(enabled)
    print("Item ESP:", enabled)
end)

Library:CreateToggle("Fullbright", function(enabled)
    local Lighting = game:GetService("Lighting")
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

Library:CreateSection("🏃 Movement")

Library:CreateToggle("Speed Boost", function(enabled)
    SpeedEnabled = enabled
    if not enabled then
        Humanoid.WalkSpeed = 16
    end
end)

Library:CreateSlider("Walk Speed", 16, 200, 16, function(value)
    WalkSpeed = value
    if SpeedEnabled then
        Humanoid.WalkSpeed = value
    end
end)

Library:CreateToggle("Jump Boost", function(enabled)
    JumpEnabled = enabled
    if not enabled then
        if Humanoid then
            Humanoid.JumpPower = 50
            Humanoid.UseJumpPower = true
        end
    else
        if Humanoid then
            Humanoid.UseJumpPower = true
        end
    end
end)

Library:CreateSlider("Jump Power", 50, 150, 50, function(value)
    JumpPower = value
    if JumpEnabled and Humanoid then
        Humanoid.JumpPower = value
    end
end)

Library:CreateToggle("Infinite Jump", function(enabled)
    InfiniteJumpEnabled = enabled
end)

-- NoClip (Optimized)
local noclipConnection
Library:CreateToggle("NoClip", function(enabled)
    NoClipEnabled = enabled
    
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
        end
        if Character then
            for _, part in pairs(Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

Library:CreateToggle("Fly", function(enabled)
    FlyEnabled = enabled
    if enabled then
        startFlying()
    else
        stopFlying()
    end
end)

Library:CreateSlider("Fly Speed", 20, 150, 50, function(value)
    FlySpeed = value
end)

Library:CreateSection("🎯 Teleports")

Library:CreateButton("Teleport to Elevator", function()
    local elevator = workspace:FindFirstChild("Elevator")
    if elevator then
        RootPart.CFrame = elevator.CFrame + Vector3.new(0, 5, 0)
    end
end)

Library:CreateButton("Teleport to Lobby", function()
    local lobby = workspace:FindFirstChild("Lobby")
    if lobby then
        RootPart.CFrame = lobby.CFrame + Vector3.new(0, 5, 0)
    end
end)

Library:CreateSection("⚙️ Misc")

Library:CreateToggle("Anti-AFK", function(enabled)
    if enabled then
        local VirtualUser = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

Library:CreateButton("Reset Character", function()
    LocalPlayer.Character:BreakJoints()
end)

Library:CreateButton("Destroy GUI", function()
    ScreenGui:Destroy()
end)

-- ==================== FUNCTIONALITY ====================

-- Speed & Jump Loop (Optimized untuk Android)
RunService.Heartbeat:Connect(function()
    if SpeedEnabled and Humanoid and Humanoid.Health > 0 then
        Humanoid.WalkSpeed = WalkSpeed
    end
    if JumpEnabled and Humanoid and Humanoid.Health > 0 then
        Humanoid.JumpPower = JumpPower
        Humanoid.UseJumpPower = true
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and Humanoid and Humanoid.Health > 0 then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Fly (Mobile-Friendly dengan Virtual Joystick)
local flying = false
local flyingBV
local flyingBG
local flyDirection = Vector3.new(0, 0, 0)

-- Virtual Joystick untuk Mobile Fly
local JoystickFrame = Instance.new("Frame")
JoystickFrame.Name = "JoystickFrame"
JoystickFrame.Size = UDim2.new(0, 150, 0, 150)
JoystickFrame.Position = UDim2.new(0, 20, 1, -170)
JoystickFrame.BackgroundTransparency = 1
JoystickFrame.Visible = false
JoystickFrame.Parent = ScreenGui

local JoystickOuter = Instance.new("Frame")
JoystickOuter.Size = UDim2.new(1, 0, 1, 0)
JoystickOuter.Position = UDim2.new(0.5, 0, 0.5, 0)
JoystickOuter.AnchorPoint = Vector2.new(0.5, 0.5)
JoystickOuter.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
JoystickOuter.BackgroundTransparency = 0.5
JoystickOuter.BorderSizePixel = 0
JoystickOuter.Parent = JoystickFrame

local JoystickOuterCorner = Instance.new("UICorner")
JoystickOuterCorner.CornerRadius = UDim.new(1, 0)
JoystickOuterCorner.Parent = JoystickOuter

local JoystickInner = Instance.new("Frame")
JoystickInner.Size = UDim2.new(0, 60, 0, 60)
JoystickInner.Position = UDim2.new(0.5, 0, 0.5, 0)
JoystickInner.AnchorPoint = Vector2.new(0.5, 0.5)
JoystickInner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
JoystickInner.BackgroundTransparency = 0.3
JoystickInner.BorderSizePixel = 0
JoystickInner.Parent = JoystickOuter

local JoystickInnerCorner = Instance.new("UICorner")
JoystickInnerCorner.CornerRadius = UDim.new(1, 0)
JoystickInnerCorner.Parent = JoystickInner

-- Up/Down Buttons untuk Fly
local FlyUpButton = Instance.new("TextButton")
FlyUpButton.Name = "FlyUpButton"
FlyUpButton.Size = UDim2.new(0, 60, 0, 60)
FlyUpButton.Position = UDim2.new(1, -80, 1, -170)
FlyUpButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
FlyUpButton.BackgroundTransparency = 0.3
FlyUpButton.Text = "▲"
FlyUpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyUpButton.TextSize = 24
FlyUpButton.Font = Enum.Font.GothamBold
FlyUpButton.BorderSizePixel = 0
FlyUpButton.Visible = false
FlyUpButton.Parent = ScreenGui

local FlyUpCorner = Instance.new("UICorner")
FlyUpCorner.CornerRadius = UDim.new(1, 0)
FlyUpCorner.Parent = FlyUpButton

local FlyDownButton = Instance.new("TextButton")
FlyDownButton.Name = "FlyDownButton"
FlyDownButton.Size = UDim2.new(0, 60, 0, 60)
FlyDownButton.Position = UDim2.new(1, -80, 1, -100)
FlyDownButton.BackgroundColor3 = Color3.fromRGB(200, 0, 100)
FlyDownButton.BackgroundTransparency = 0.3
FlyDownButton.Text = "▼"
FlyDownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyDownButton.TextSize = 24
FlyDownButton.Font = Enum.Font.GothamBold
FlyDownButton.BorderSizePixel = 0
FlyDownButton.Visible = false
FlyDownButton.Parent = ScreenGui

local FlyDownCorner = Instance.new("UICorner")
FlyDownCorner.CornerRadius = UDim.new(1, 0)
FlyDownCorner.Parent = FlyDownButton

-- Joystick Logic
local joystickDragging = false
local joystickInput

JoystickOuter.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        joystickDragging = true
        joystickInput = input
    end
end)

JoystickOuter.InputEnded:Connect(function(input)
    if input == joystickInput then
        joystickDragging = false
        JoystickInner.Position = UDim2.new(0.5, 0, 0.5, 0)
        flyDirection = Vector3.new(flyDirection.X, flyDirection.Y, flyDirection.Z) * 0
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if joystickDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local outerPos = JoystickOuter.AbsolutePosition
        local outerSize = JoystickOuter.AbsoluteSize
        local center = outerPos + outerSize / 2
        
        local mousePos = input.Position
        local direction = Vector2.new(mousePos.X - center.X, mousePos.Y - center.Y)
        local magnitude = math.min(direction.Magnitude, outerSize.X / 2 - 30)
        
        if direction.Magnitude > 0 then
            direction = direction.Unit * magnitude
        end
        
        JoystickInner.Position = UDim2.new(0.5, direction.X, 0.5, direction.Y)
        
        -- Convert joystick input ke fly direction
        local camera = workspace.CurrentCamera
        local normalized = direction / (outerSize.X / 2)
        
        flyDirection = (camera.CFrame.LookVector * -normalized.Y) + (camera.CFrame.RightVector * normalized.X)
    end
end)

-- Up/Down Button Logic
local flyingUp = false
local flyingDown = false

FlyUpButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyingUp = true
    end
end)

FlyUpButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyingUp = false
    end
end)

FlyDownButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyingDown = true
    end
end)

FlyDownButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        flyingDown = false
    end
end)

local function startFlying()
    flying = true
    
    -- Show joystick dan buttons
    JoystickFrame.Visible = true
    FlyUpButton.Visible = true
    FlyDownButton.Visible = true
    
    flyingBV = Instance.new("BodyVelocity")
    flyingBV.Velocity = Vector3.new(0, 0, 0)
    flyingBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyingBV.Parent = RootPart
    
    flyingBG = Instance.new("BodyGyro")
    flyingBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyingBG.CFrame = RootPart.CFrame
    flyingBG.Parent = RootPart
    
    spawn(function()
        while flying and FlyEnabled do
            local camera = workspace.CurrentCamera
            local totalDirection = flyDirection
            
            -- Add vertical movement
            if flyingUp then
                totalDirection = totalDirection + Vector3.new(0, 1, 0)
            end
            if flyingDown then
                totalDirection = totalDirection - Vector3.new(0, 1, 0)
            end
            
            if totalDirection.Magnitude > 0 then
                totalDirection = totalDirection.Unit
            end
            
            flyingBV.Velocity = totalDirection * FlySpeed
            flyingBG.CFrame = camera.CFrame
            
            RunService.Heartbeat:Wait()
        end
    end)
end

local function stopFlying()
    flying = false
    
    -- Hide joystick dan buttons
    JoystickFrame.Visible = false
    FlyUpButton.Visible = false
    FlyDownButton.Visible = false
    
    if flyingBV then
        flyingBV:Destroy()
    end
    if flyingBG then
        flyingBG:Destroy()
    end
    
    flyDirection = Vector3.new(0, 0, 0)
end

-- Auto Farm Loop (Basic implementation)
spawn(function()
    while wait(1) do
        if AutoFarmEnabled then
            -- Cari coins di workspace
            for _, coin in pairs(workspace:GetDescendants()) do
                if coin.Name == "Coin" or coin.Name == "GoldCoin" then
                    if coin:IsA("BasePart") then
                        -- Teleport ke coin
                        RootPart.CFrame = coin.CFrame
                        wait(0.1)
                    end
                end
            end
        end
    end
end)

-- ESP System
local function createESP(player)
    if player ~= LocalPlayer and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        
        player.CharacterRemoving:Connect(function()
            highlight:Destroy()
        end)
    end
end

-- Apply ESP
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if ESPEnabled then
            wait(1)
            createESP(player)
        end
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player.Character and ESPEnabled then
        createESP(player)
    end
end

-- Character respawn handler
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end)

print("✅ Insane Elevator Script Loaded Successfully!")
print("🎮 Script by Claude AI")
print("📌 UI is draggable from the top bar")
print("➖ Click minimize button to minimize")
print("🔄 Click the minimized box to restore")
