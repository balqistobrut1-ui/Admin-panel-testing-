-- Universal Obby Script Hub by Claude
-- Loadstring: loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Variables
local UIEnabled = true
local AutoNextEnabled = false
local TeleportSpeed = 0.5
local Checkpoints = {}
local CurrentCheckpoint = 1
local AutoFinishEnabled = false
local Minimized = false

-- Fungsi untuk mencari checkpoints
local function FindCheckpoints()
    Checkpoints = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (
            obj.Name:lower():find("checkpoint") or 
            obj.Name:lower():find("stage") or
            obj.Name:lower():find("spawn") or
            (obj:FindFirstChild("TouchInterest") and obj.Name:match("%d+"))
        ) then
            table.insert(Checkpoints, obj)
        end
    end
    
    -- Sort berdasarkan posisi atau nama
    table.sort(Checkpoints, function(a, b)
        local numA = tonumber(a.Name:match("%d+")) or 0
        local numB = tonumber(b.Name:match("%d+")) or 0
        if numA ~= numB then
            return numA < numB
        end
        return a.Position.Z < b.Position.Z
    end)
    
    return #Checkpoints
end

-- Fungsi teleport dengan tween
local function TeleportToCheckpoint(checkpoint)
    if checkpoint and HumanoidRootPart then
        local targetPos = checkpoint.Position + Vector3.new(0, 5, 0)
        local distance = (HumanoidRootPart.Position - targetPos).Magnitude
        local duration = distance / (50 / TeleportSpeed)
        
        local tweenInfo = TweenInfo.new(
            duration,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut
        )
        
        local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(targetPos)})
        tween:Play()
        tween.Completed:Wait()
        wait(0.1)
    end
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ObbyScriptUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Cek apakah UI sudah ada
if Player.PlayerGui:FindFirstChild("ObbyScriptUI") then
    Player.PlayerGui:FindFirstChild("ObbyScriptUI"):Destroy()
end

ScreenGui.Parent = Player.PlayerGui

-- Main Frame (UKURAN DIPERKECIL)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Rounded corners
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Shadow effect
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 20, 1, 20)
Shadow.Position = UDim2.new(0, -10, 0, -10)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.7
Shadow.ZIndex = 0
Shadow.Parent = MainFrame

-- Title Bar (DRAGGABLE AREA)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 38)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

-- DRAG LOGIC (CUSTOM)
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

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -75, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "🎮 Obby Hub"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 15
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -68, 0, 4)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local MinBtnCorner = Instance.new("UICorner")
MinBtnCorner.CornerRadius = UDim.new(0, 6)
MinBtnCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 6)
CloseBtnCorner.Parent = CloseBtn

-- Minimized Button (kotak kecil)
local MinimizedBox = Instance.new("TextButton")
MinimizedBox.Name = "MinimizedBox"
MinimizedBox.Size = UDim2.new(0, 45, 0, 45)
MinimizedBox.Position = UDim2.new(0, 10, 0, 10)
MinimizedBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
MinimizedBox.Text = "🎮"
MinimizedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedBox.TextSize = 20
MinimizedBox.Font = Enum.Font.GothamBold
MinimizedBox.Visible = false
MinimizedBox.Parent = ScreenGui

local MinBoxCorner = Instance.new("UICorner")
MinBoxCorner.CornerRadius = UDim.new(0, 8)
MinBoxCorner.Parent = MinimizedBox

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -16, 1, -46)
ContentFrame.Position = UDim2.new(0, 8, 0, 42)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 4
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 460)
ContentFrame.Parent = MainFrame

-- Info Label
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -8, 0, 26)
InfoLabel.Position = UDim2.new(0, 4, 0, 4)
InfoLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
InfoLabel.Text = "📍 Checkpoints: 0"
InfoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Parent = ContentFrame

local InfoCorner = Instance.new("UICorner")
InfoCorner.CornerRadius = UDim.new(0, 6)
InfoCorner.Parent = InfoLabel

-- Fungsi untuk membuat toggle button
local function CreateToggleButton(name, position, callback)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(1, -8, 0, 38)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    Button.Text = ""
    Button.Parent = ContentFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(0, 42, 1, 0)
    Status.Position = UDim2.new(1, -46, 0, 0)
    Status.BackgroundTransparency = 1
    Status.Text = "OFF"
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.TextSize = 12
    Status.Font = Enum.Font.GothamBold
    Status.Parent = Button
    
    local isEnabled = false
    
    Button.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        if isEnabled then
            Button.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
            Status.Text = "ON"
        else
            Button.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            Status.Text = "OFF"
        end
        callback(isEnabled)
    end)
    
    return Button
end

-- Auto Next Checkpoint Toggle
CreateToggleButton("⚡ Auto Next", UDim2.new(0, 4, 0, 36), function(enabled)
    AutoNextEnabled = enabled
end)

-- Speed Slider (FIX SLIDER DRAG)
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(1, -8, 0, 60)
SliderFrame.Position = UDim2.new(0, 4, 0, 82)
SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
SliderFrame.Parent = ContentFrame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 6)
SliderCorner.Parent = SliderFrame

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, -8, 0, 22)
SliderLabel.Position = UDim2.new(0, 4, 0, 4)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "🚀 Speed: 0.5x"
SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SliderLabel.TextSize = 12
SliderLabel.Font = Enum.Font.GothamBold
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = SliderFrame

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(1, -16, 0, 6)
SliderBar.Position = UDim2.new(0, 8, 0, 34)
SliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SliderBar.Parent = SliderFrame

local SliderBarCorner = Instance.new("UICorner")
SliderBarCorner.CornerRadius = UDim.new(1, 0)
SliderBarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

local SliderFillCorner = Instance.new("UICorner")
SliderFillCorner.CornerRadius = UDim.new(1, 0)
SliderFillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 18, 0, 18)
SliderButton.Position = UDim2.new(0.5, -9, 0.5, -9)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Text = ""
SliderButton.Parent = SliderBar

local SliderBtnCorner = Instance.new("UICorner")
SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderButton

-- SLIDER LOGIC (FIX: TIDAK TERPENGARUH DRAG UI)
local sliderDragging = false

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

RunService.RenderStepped:Connect(function()
    if sliderDragging then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = SliderBar.AbsolutePosition
        local sliderSize = SliderBar.AbsoluteSize
        
        local relativePos = math.clamp(mousePos.X - sliderPos.X, 0, sliderSize.X)
        local percentage = relativePos / sliderSize.X
        
        SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        SliderButton.Position = UDim2.new(percentage, -9, 0.5, -9)
        
        TeleportSpeed = 0.1 + (percentage * 1.9)
        SliderLabel.Text = string.format("🚀 Speed: %.1fx", TeleportSpeed)
    end
end)

-- Auto Finish Toggle
CreateToggleButton("🏁 Auto Finish", UDim2.new(0, 4, 0, 150), function(enabled)
    AutoFinishEnabled = enabled
    if enabled and #Checkpoints > 0 then
        spawn(function()
            for i = CurrentCheckpoint, #Checkpoints do
                if not AutoFinishEnabled then break end
                TeleportToCheckpoint(Checkpoints[i])
                CurrentCheckpoint = i
            end
        end)
    end
end)

-- Back to Start Button
local BackToStartBtn = Instance.new("TextButton")
BackToStartBtn.Size = UDim2.new(1, -8, 0, 38)
BackToStartBtn.Position = UDim2.new(0, 4, 0, 196)
BackToStartBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 220)
BackToStartBtn.Text = "⏮️ Back to Start"
BackToStartBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackToStartBtn.TextSize = 13
BackToStartBtn.Font = Enum.Font.GothamBold
BackToStartBtn.Parent = ContentFrame

local BackBtnCorner = Instance.new("UICorner")
BackBtnCorner.CornerRadius = UDim.new(0, 6)
BackBtnCorner.Parent = BackToStartBtn

BackToStartBtn.MouseButton1Click:Connect(function()
    if #Checkpoints > 0 then
        TeleportToCheckpoint(Checkpoints[1])
        CurrentCheckpoint = 1
    end
end)

-- Reset/Respawn Button
local ResetBtn = Instance.new("TextButton")
ResetBtn.Size = UDim2.new(1, -8, 0, 38)
ResetBtn.Position = UDim2.new(0, 4, 0, 242)
ResetBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 50)
ResetBtn.Text = "🔄 Reset Character"
ResetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetBtn.TextSize = 13
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.Parent = ContentFrame

local ResetBtnCorner = Instance.new("UICorner")
ResetBtnCorner.CornerRadius = UDim.new(0, 6)
ResetBtnCorner.Parent = ResetBtn

ResetBtn.MouseButton1Click:Connect(function()
    if Character and Character:FindFirstChild("Humanoid") then
        Character.Humanoid.Health = 0
    end
end)

-- Refresh Checkpoints Button
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(1, -8, 0, 38)
RefreshBtn.Position = UDim2.new(0, 4, 0, 288)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
RefreshBtn.Text = "🔍 Refresh Checkpoints"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 13
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.Parent = ContentFrame

local RefreshBtnCorner = Instance.new("UICorner")
RefreshBtnCorner.CornerRadius = UDim.new(0, 6)
RefreshBtnCorner.Parent = RefreshBtn

RefreshBtn.MouseButton1Click:Connect(function()
    local count = FindCheckpoints()
    InfoLabel.Text = "📍 Checkpoints: " .. count
end)

-- Credits
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(1, -8, 0, 36)
Credits.Position = UDim2.new(0, 4, 0, 334)
Credits.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
Credits.Text = "Made with ❤️ by Claude\nUniversal Obby Hub"
Credits.TextColor3 = Color3.fromRGB(200, 200, 200)
Credits.TextSize = 10
Credits.Font = Enum.Font.Gotham
Credits.Parent = ContentFrame

local CreditsCorner = Instance.new("UICorner")
CreditsCorner.CornerRadius = UDim.new(0, 6)
CreditsCorner.Parent = Credits

-- Button Functions
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    AutoNextEnabled = false
    AutoFinishEnabled = false
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    MainFrame.Visible = not Minimized
    MinimizedBox.Visible = Minimized
end)

MinimizedBox.MouseButton1Click:Connect(function()
    Minimized = false
    MainFrame.Visible = true
    MinimizedBox.Visible = false
end)

-- Auto Next Checkpoint Loop
spawn(function()
    while wait(0.5) do
        if AutoNextEnabled and #Checkpoints > 0 and CurrentCheckpoint < #Checkpoints then
            CurrentCheckpoint = CurrentCheckpoint + 1
            TeleportToCheckpoint(Checkpoints[CurrentCheckpoint])
        end
    end
end)

-- Character Update
Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    wait(1)
    FindCheckpoints()
end)

-- Initial Setup
local initialCount = FindCheckpoints()
InfoLabel.Text = "📍 Checkpoints: " .. initialCount

print("✅ Universal Obby Script loaded!")
print("📍 Found " .. initialCount .. " checkpoints")
