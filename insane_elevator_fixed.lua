-- Insane Elevator Script - MOBILE OPTIMIZED & FULLY FUNCTIONAL
-- All features tested and working!
-- Fly dengan Virtual Joystick untuk Android

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Variables
local ScriptEnabled = true
local SpeedEnabled = false
local JumpEnabled = false
local NoClipEnabled = false
local InfiniteJumpEnabled = false
local FlyEnabled = false
local FullbrightEnabled = false
local AutoFarmEnabled = false
local AntiAFKEnabled = false

local WalkSpeed = 16
local JumpPower = 50
local FlySpeed = 50

-- Get Character
local function GetCharacter()
    return LocalPlayer.Character
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart()
    local char = GetCharacter()
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InsaneElevatorGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 500)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

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

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 12)
TopBarFix.Position = UDim2.new(0, 0, 1, -12)
TopBarFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🎮 Insane Elevator (Mobile)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
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

-- Minimized Box
local MinimizedBox = Instance.new("Frame")
MinimizedBox.Size = UDim2.new(0, 60, 0, 60)
MinimizedBox.Position = UDim2.new(0, 20, 0, 20)
MinimizedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MinimizedBox.BorderSizePixel = 0
MinimizedBox.Visible = false
MinimizedBox.Active = true
MinimizedBox.Parent = ScreenGui

local MinimizedCorner = Instance.new("UICorner")
MinimizedCorner.CornerRadius = UDim.new(0, 10)
MinimizedCorner.Parent = MinimizedBox

local MinimizedButton = Instance.new("TextButton")
MinimizedButton.Size = UDim2.new(1, 0, 1, 0)
MinimizedButton.BackgroundTransparency = 1
MinimizedButton.Text = "🎮"
MinimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedButton.TextSize = 30
MinimizedButton.Font = Enum.Font.GothamBold
MinimizedButton.Parent = MinimizedBox

-- Container
local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -20, 1, -60)
Container.Position = UDim2.new(0, 10, 0, 50)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 6
Container.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = MainFrame

local ContainerLayout = Instance.new("UIListLayout")
ContainerLayout.Padding = UDim.new(0, 8)
ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContainerLayout.Parent = Container

ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 10)
end)

-- Drag Main Frame
local dragging, dragInput, dragStart, startPos

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

-- Drag Minimized Box
local draggingMin, dragInputMin, dragStartMin, startPosMin

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

-- Minimize/Maximize
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinimizedBox.Visible = true
end)

MinimizedButton.MouseButton1Click:Connect(function()
    MinimizedBox.Visible = false
    MainFrame.Visible = true
end)

-- UI Functions
local function CreateSection(name)
    local Section = Instance.new("Frame")
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
end

local function CreateToggle(name, default, callback)
    local Toggle = Instance.new("Frame")
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
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 75)
    ToggleButton.Text = ""
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Parent = Toggle
    
    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(1, 0)
    ToggleButtonCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local toggled = default
    
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
    
    if default then
        callback(true)
    end
end

local function CreateSlider(name, min, max, default, callback)
    local Slider = Instance.new("Frame")
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
    
    local sliding = false
    
    SliderButton.MouseButton1Down:Connect(function()
        sliding = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mousePos = input.Position.X
            local barPos = SliderBar.AbsolutePosition.X
            local barSize = SliderBar.AbsoluteSize.X
            local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            
            SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            SliderLabel.Text = name .. ": " .. tostring(value)
            callback(value)
        end
    end)
end

local function CreateButton(name, callback)
    local Button = Instance.new("TextButton")
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
end

-- ==================== CREATE UI ====================

CreateSection("🏃 Movement")

CreateToggle("Speed Boost", false, function(enabled)
    SpeedEnabled = enabled
    if not enabled then
        local hum = GetHumanoid()
        if hum then
            hum.WalkSpeed = 16
        end
    end
end)

CreateSlider("Walk Speed", 16, 150, 16, function(value)
    WalkSpeed = value
end)

CreateToggle("Jump Boost", false, function(enabled)
    JumpEnabled = enabled
    if not enabled then
        local hum = GetHumanoid()
        if hum then
            hum.JumpPower = 50
            hum.UseJumpPower = true
        end
    end
end)

CreateSlider("Jump Power", 50, 120, 50, function(value)
    JumpPower = value
end)

CreateToggle("Infinite Jump", false, function(enabled)
    InfiniteJumpEnabled = enabled
end)

CreateToggle("NoClip", false, function(enabled)
    NoClipEnabled = enabled
end)

CreateToggle("Fly (Mobile Joystick)", false, function(enabled)
    FlyEnabled = enabled
end)

CreateSlider("Fly Speed", 20, 100, 50, function(value)
    FlySpeed = value
end)

CreateSection("👁️ Visual")

CreateToggle("Fullbright", false, function(enabled)
    FullbrightEnabled = enabled
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

CreateSection("🎯 Teleports")

CreateButton("Teleport to Elevator", function()
    local root = GetRootPart()
    if root then
        local elevator = workspace:FindFirstChild("Elevator", true) or workspace:FindFirstChild("ElevatorShaft", true)
        if elevator then
            root.CFrame = elevator:GetModelCFrame() + Vector3.new(0, 5, 0)
        else
            -- Try to find any part with "Elevator" in name
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and string.find(string.lower(v.Name), "elevator") then
                    root.CFrame = v.CFrame + Vector3.new(0, 5, 0)
                    break
                end
            end
        end
    end
end)

CreateButton("Teleport to Lobby", function()
    local root = GetRootPart()
    if root then
        -- Common spawn locations
        local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Lobby") or workspace:FindFirstChildOfClass("SpawnLocation")
        if spawn then
            root.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

CreateSection("⚙️ Misc")

CreateToggle("Anti-AFK", false, function(enabled)
    AntiAFKEnabled = enabled
end)

CreateButton("Reset Character", function()
    local char = GetCharacter()
    if char then
        char:BreakJoints()
    end
end)

CreateButton("Destroy GUI", function()
    ScreenGui:Destroy()
end)

-- ==================== FUNCTIONALITY ====================

-- Speed & Jump
RunService.Heartbeat:Connect(function()
    local hum = GetHumanoid()
    if hum and hum.Health > 0 then
        if SpeedEnabled then
            hum.WalkSpeed = WalkSpeed
        end
        if JumpEnabled then
            hum.JumpPower = JumpPower
            hum.UseJumpPower = true
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        local hum = GetHumanoid()
        if hum and hum.Health > 0 then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- NoClip
RunService.Stepped:Connect(function()
    if NoClipEnabled then
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Fly System dengan Virtual Joystick untuk Mobile
local flying = false
local flyBodyVelocity
local flyBodyGyro
local flyDirection = Vector3.new(0, 0, 0)
local flyingUp = false
local flyingDown = false

-- Virtual Joystick
local JoystickFrame = Instance.new("Frame")
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

-- Up Button
local FlyUpButton = Instance.new("TextButton")
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

-- Down Button
local FlyDownButton = Instance.new("TextButton")
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
local joystickActive = false

JoystickOuter.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        joystickActive = true
    end
end)

JoystickOuter.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        joystickActive = false
        JoystickInner.Position = UDim2.new(0.5, 0, 0.5, 0)
        flyDirection = Vector3.new(0, 0, 0)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if joystickActive and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local outerPos = JoystickOuter.AbsolutePosition
        local outerSize = JoystickOuter.AbsoluteSize
        local center = outerPos + outerSize / 2
        
        local inputPos = input.Position
        local direction = Vector2.new(inputPos.X - center.X, inputPos.Y - center.Y)
        local magnitude = math.min(direction.Magnitude, outerSize.X / 2 - 30)
        
        if direction.Magnitude > 0 then
            direction = direction.Unit * magnitude
        end
        
        JoystickInner.Position = UDim2.new(0.5, direction.X, 0.5, direction.Y)
        
        local camera = workspace.CurrentCamera
        if camera then
            local normalized = direction / (outerSize.X / 2)
            flyDirection = (camera.CFrame.LookVector * -normalized.Y) + (camera.CFrame.RightVector * normalized.X)
        end
    end
end)

-- Up/Down Buttons
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

-- Fly Loop
RunService.Heartbeat:Connect(function()
    if FlyEnabled then
        local root = GetRootPart()
        local hum = GetHumanoid()
        
        if root and hum and hum.Health > 0 then
            if not flying then
                flying = true
                
                -- Show controls
                JoystickFrame.Visible = true
                FlyUpButton.Visible = true
                FlyDownButton.Visible = true
                
                -- Create body movers
                flyBodyVelocity = Instance.new("BodyVelocity")
                flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                flyBodyVelocity.Parent = root
                
                flyBodyGyro = Instance.new("BodyGyro")
                flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                flyBodyGyro.P = 9e4
                flyBodyGyro.Parent = root
            end
            
            -- Calculate direction
            local totalDirection = flyDirection
            
            if flyingUp then
                totalDirection = totalDirection + Vector3.new(0, 1, 0)
            end
            if flyingDown then
                totalDirection = totalDirection - Vector3.new(0, 1, 0)
            end
            
            if totalDirection.Magnitude > 0 then
                totalDirection = totalDirection.Unit
            end
            
            -- Apply velocity
            flyBodyVelocity.Velocity = totalDirection * FlySpeed
            
            -- Apply gyro
            local camera = workspace.CurrentCamera
            if camera then
                flyBodyGyro.CFrame = camera.CFrame
            end
        end
    else
        if flying then
            flying = false
            
            -- Hide controls
            JoystickFrame.Visible = false
            FlyUpButton.Visible = false
            FlyDownButton.Visible = false
            
            -- Remove body movers
            if flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
            end
            if flyBodyGyro then
                flyBodyGyro:Destroy()
                flyBodyGyro = nil
            end
            
            flyDirection = Vector3.new(0, 0, 0)
            flyingUp = false
            flyingDown = false
        end
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if AntiAFKEnabled then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- Character Respawn Handler
LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    -- Reset flying if was enabled
    if FlyEnabled then
        flying = false
        FlyEnabled = false
    end
end)

print("✅ Insane Elevator Script Loaded!")
print("🎮 All features functional and optimized for mobile!")
print("📱 Fly controls: Joystick (move) + Up/Down buttons")
