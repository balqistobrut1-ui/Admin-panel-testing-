-- Rainbow Friends Auto Collect Script
-- Modern UI with Minimize Feature

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local autoCollectEnabled = false
local isRunning = false

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RainbowFriendsAuto"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main Frame (Square 1:1)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 280)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -140)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Corner for MainFrame
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Shadow Effect
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.7
shadow.ZIndex = 0
shadow.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 12)
headerFix.Position = UDim2.new(0, 0, 1, -12)
headerFix.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🌈 Rainbow Friends"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -45, 0.5, -17.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
minimizeBtn.Text = "➖"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = header

local minBtnCorner = Instance.new("UICorner")
minBtnCorner.CornerRadius = UDim.new(0, 8)
minBtnCorner.Parent = minimizeBtn

-- Content Container
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -20, 1, -70)
content.Position = UDim2.new(0, 10, 0, 60)
content.BackgroundTransparency = 1
content.Parent = mainFrame

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 10)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "📊 Status: Disabled"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = content

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"
toggleBtn.Size = UDim2.new(1, 0, 0, 50)
toggleBtn.Position = UDim2.new(0, 0, 0, 50)
toggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
toggleBtn.Text = "⭕ OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 18
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = content

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 10)
toggleCorner.Parent = toggleBtn

-- Info Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(1, 0, 0, 80)
infoLabel.Position = UDim2.new(0, 0, 0, 115)
infoLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
infoLabel.Text = "ℹ️ Auto Collect Info:\n\n✅ Teleport ke item\n✅ Auto collect\n✅ Kembali ke drop-off"
infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
infoLabel.TextSize = 12
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextYAlignment = Enum.TextYAlignment.Top
infoLabel.BorderSizePixel = 0
infoLabel.Parent = content

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoLabel

local infoPadding = Instance.new("UIPadding")
infoPadding.PaddingTop = UDim.new(0, 8)
infoPadding.PaddingLeft = UDim.new(0, 10)
infoPadding.PaddingRight = UDim.new(0, 10)
infoPadding.Parent = infoLabel

-- Minimized Box (Square 1:1)
local miniBox = Instance.new("Frame")
miniBox.Name = "MiniBox"
miniBox.Size = UDim2.new(0, 60, 0, 60)
miniBox.Position = UDim2.new(0, 20, 0, 20)
miniBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
miniBox.BorderSizePixel = 0
miniBox.Active = true
miniBox.Visible = false
miniBox.Parent = screenGui

local miniCorner = Instance.new("UICorner")
miniCorner.CornerRadius = UDim.new(0, 12)
miniCorner.Parent = miniBox

local miniButton = Instance.new("TextButton")
miniButton.Size = UDim2.new(1, 0, 1, 0)
miniButton.BackgroundTransparency = 1
miniButton.Text = "🌈"
miniButton.TextColor3 = Color3.fromRGB(255, 255, 255)
miniButton.TextSize = 28
miniButton.Font = Enum.Font.GothamBold
miniButton.Parent = miniBox

-- Functions
local function updateStatus(text, color)
    statusLabel.Text = "📊 Status: " .. text
    statusLabel.TextColor3 = color
end

local function tweenButton(button, color, text)
    button.BackgroundColor3 = color
    button.Text = text
end

-- Touch Drag System for Mobile (Android/iOS)
local UserInputService = game:GetService("UserInputService")

local function makeDraggable(frame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    frame.InputBegan:Connect(function(input)
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

    frame.InputChanged:Connect(function(input)
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

-- Apply dragging to main UI and mini box
makeDraggable(mainFrame)
makeDraggable(miniBox)

-- Minimize/Maximize Functions
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniBox.Visible = true
end)

miniButton.MouseButton1Click:Connect(function()
    miniBox.Visible = false
    mainFrame.Visible = true
end)

-- Auto Collect Logic
local function teleportTo(position)
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
        wait(0.15)
    end
end

local function autoCollectItems()
    isRunning = true
    updateStatus("Running...", Color3.fromRGB(100, 200, 100))
    
    -- Konfigurasi (sesuaikan dengan game)
    local itemNames = {"Block", "Fuse", "Battery", "Food"} -- Nama item yang mau diambil
    local dropOffLocation = Vector3.new(0, 5, 0) -- Koordinat tempat pengumpulan
    local collectDelay = 0.3
    
    local items = {}
    
    -- Cari semua item
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            for _, itemName in pairs(itemNames) do
                if string.find(obj.Name:lower(), itemName:lower()) then
                    table.insert(items, obj)
                    break
                end
            end
        end
    end
    
    updateStatus("Found " .. #items .. " items", Color3.fromRGB(100, 150, 255))
    wait(1)
    
    -- Collect items
    for i, item in pairs(items) do
        if not autoCollectEnabled then break end
        
        if item and item.Parent then
            teleportTo(item.Position)
            updateStatus("Collecting " .. i .. "/" .. #items, Color3.fromRGB(255, 200, 100))
            wait(collectDelay)
        end
    end
    
    -- Kembali ke drop-off
    if autoCollectEnabled then
        wait(0.5)
        teleportTo(dropOffLocation)
        updateStatus("Complete! ✅", Color3.fromRGB(100, 255, 100))
        wait(2)
    end
    
    isRunning = false
    if autoCollectEnabled then
        updateStatus("Enabled (Idle)", Color3.fromRGB(100, 200, 255))
    else
        updateStatus("Disabled", Color3.fromRGB(200, 200, 200))
    end
end

-- Toggle Button Click
toggleBtn.MouseButton1Click:Connect(function()
    autoCollectEnabled = not autoCollectEnabled
    
    if autoCollectEnabled then
        tweenButton(toggleBtn, Color3.fromRGB(50, 200, 50), "✅ ON")
        updateStatus("Enabled", Color3.fromRGB(100, 255, 100))
        
        -- Start auto collect loop
        spawn(function()
            while autoCollectEnabled do
                if not isRunning then
                    autoCollectItems()
                end
                wait(5) -- Delay sebelum collect lagi
            end
        end)
    else
        tweenButton(toggleBtn, Color3.fromRGB(220, 50, 50), "⭕ OFF")
        updateStatus("Disabled", Color3.fromRGB(200, 200, 200))
    end
end)

-- Hover Effects
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(
            math.min(button.BackgroundColor3.R * 255 + 20, 255),
            math.min(button.BackgroundColor3.G * 255 + 20, 255),
            math.min(button.BackgroundColor3.B * 255 + 20, 255)
        )
    end)
    
    button.MouseLeave:Connect(function()
        if autoCollectEnabled then
            button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            button.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
        end
    end)
end

addHoverEffect(toggleBtn)

-- Welcome Message
updateStatus("Ready!", Color3.fromRGB(100, 200, 255))
wait(1)
updateStatus("Disabled", Color3.fromRGB(200, 200, 200))

print("🌈 Rainbow Friends Auto Collect loaded!")
print("✅ UI is draggable")
print("➖ Click minimize to shrink UI")
print("🎯 Click mini box to restore UI")
