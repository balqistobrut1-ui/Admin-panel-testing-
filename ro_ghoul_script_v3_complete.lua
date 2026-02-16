-- Ro-Ghoul Ultimate Script Hub v3.0
-- Game: https://www.roblox.com/games/914010731/Ro-Ghoul
-- Made by Claude AI - Complete Rebuild

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Variables
local AutoFarmEnabled = false
local AutoFarmBossEnabled = false
local AutoSkillEnabled = false
local AutoStatEnabled = false
local ESPEnabled = false
local FullBrightEnabled = false
local InfiniteStaminaEnabled = false
local WalkSpeedEnabled = false
local JumpPowerEnabled = false
local AutoCollectYenEnabled = false
local AutoGyasatsuEnabled = false
local AntiBanEnabled = true

local WalkSpeedValue = 50
local JumpPowerValue = 100
local FarmDistance = 15
local BossFarmDistance = 30
local SelectedFaction = "Ghoul" -- Ghoul or Quinque
local ESPObjects = {}

-- Detect player faction
local function DetectFaction()
    pcall(function()
        local playerData = Player:FindFirstChild("PlayerData") or Player:FindFirstChild("Data")
        if playerData then
            local faction = playerData:FindFirstChild("Faction") or playerData:FindFirstChild("Race")
            if faction and faction.Value then
                SelectedFaction = faction.Value
            end
        end
        
        -- Detect from inventory/skills
        if Player.Backpack:FindFirstChild("Kagune") or Player.Character:FindFirstChild("Kagune") then
            SelectedFaction = "Ghoul"
        elseif Player.Backpack:FindFirstChild("Quinque") or Player.Character:FindFirstChild("Quinque") then
            SelectedFaction = "Quinque"
        end
    end)
end

DetectFaction()

-- Functions
local function GetNPCs()
    local npcs = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Name ~= Player.Name and v.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(v) then
                -- Filter hanya NPC (bukan player)
                if v:FindFirstChild("NPC") or not v:FindFirstChild("Head") or v.Parent.Name == "NPCs" then
                    table.insert(npcs, v)
                end
            end
        end
    end
    return npcs
end

local function GetBosses()
    local bosses = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            -- Boss biasanya punya health lebih dari 1000
            if v.Humanoid.MaxHealth > 1000 or v.Name:lower():find("boss") or v.Name:lower():find("yamori") or v.Name:lower():find("noro") then
                table.insert(bosses, v)
            end
        end
    end
    return bosses
end

local function GetClosestNPC()
    local closest = nil
    local closestDistance = math.huge
    
    for _, npc in pairs(GetNPCs()) do
        if npc and npc:FindFirstChild("HumanoidRootPart") then
            local distance = (HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closest = npc
                closestDistance = distance
            end
        end
    end
    
    return closest
end

local function GetClosestBoss()
    local closest = nil
    local closestDistance = math.huge
    
    for _, boss in pairs(GetBosses()) do
        if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") then
            if boss.Humanoid.Health > 0 then
                local distance = (HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closest = boss
                    closestDistance = distance
                end
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

local function UseSkill(skillName)
    pcall(function()
        -- Cari skill di backpack atau character
        local skill = Player.Backpack:FindFirstChild(skillName) or Player.Character:FindFirstChild(skillName)
        if skill and skill:IsA("Tool") then
            Humanoid:EquipTool(skill)
            wait(0.1)
            skill:Activate()
        end
        
        -- Method alternatif via Remote
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and (remote.Name:lower():find("skill") or remote.Name:lower():find("kagune") or remote.Name:lower():find("quinque")) then
                remote:FireServer(skillName)
            end
        end
    end)
end

local function AttackTarget(target)
    if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
        pcall(function()
            -- Auto Attack
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
            
            -- Click attack
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            wait(0.05)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            
            -- Remote attack
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("attack") or remote.Name:lower():find("damage") or remote.Name:lower():find("combat")) then
                    remote:FireServer(target)
                end
            end
        end)
    end
end

-- Auto Skill System
local function AutoUseSkills()
    pcall(function()
        -- Skill keys: Q, E, R, F, C
        local skills = {"Q", "E", "R", "F", "C"}
        
        for _, key in ipairs(skills) do
            VirtualInputManager:SendKeyEvent(true, key, false, game)
            wait(0.05)
            VirtualInputManager:SendKeyEvent(false, key, false, game)
            wait(0.1)
        end
    end)
end

-- Train Stats
local function TrainStat(statName)
    pcall(function()
        -- Method 1: Remote events
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and remote.Name:lower():find("stat") then
                remote:FireServer(statName)
            end
            if remote:IsA("RemoteFunction") and remote.Name:lower():find("stat") then
                remote:InvokeServer(statName)
            end
        end
        
        -- Method 2: Gym interaction
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
                if obj.Parent.Name:lower():find(statName:lower()) or obj.Parent.Name:lower():find("gym") then
                    if obj:IsA("ClickDetector") then
                        fireclickdetector(obj)
                    else
                        fireproximityprompt(obj)
                    end
                end
            end
        end
    end)
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

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 340)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

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

-- Drag System (FIXED: Tidak mempengaruhi slider)
local dragging = false
local dragStart, startPos

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

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "👻 Ro-Ghoul v3.0 | " .. SelectedFaction
Title.TextColor3 = Color3.fromRGB(255, 50, 100)
Title.TextSize = 14
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

-- Minimized Box (Di tengah, bisa di-drag)
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

-- Drag MinimizedBox
local minDragging = false
local minDragStart, minStartPos

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

UserInputService.InputChanged:Connect(function(input)
    if minDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - minDragStart
        MinimizedBox.Position = UDim2.new(minStartPos.X.Scale, minStartPos.X.Offset + delta.X, minStartPos.Y.Scale, minStartPos.Y.Offset + delta.Y)
    end
end)

-- Content Scroll
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Name = "ContentScroll"
ContentScroll.Size = UDim2.new(1, -16, 1, -50)
ContentScroll.Position = UDim2.new(0, 8, 0, 46)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 5
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 100)
ContentScroll.Parent = MainFrame

local yPositions = {Main = 4, Combat = 4, Visuals = 4, Stats = 4}

-- Create Toggle
local function CreateToggle(name, tab, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = tab .. "_" .. name:gsub("%s", ""):gsub("[^%w]", "")
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
    ToggleBtn.ZIndex = 10
    ToggleBtn.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 3, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.ZIndex = 11
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

-- Create Slider (FIXED COMPLETELY)
local function CreateSlider(name, tab, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = tab .. "_Slider_" .. name:gsub("%s", ""):gsub("[^%w]", "")
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
    SliderBar.ZIndex = 8
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 100)
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 9
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.ZIndex = 10
    SliderButton.Active = true
    SliderButton.Parent = SliderBar
    
    local SliderBtnCorner = Instance.new("UICorner")
    SliderBtnCorner.CornerRadius = UDim.new(1, 0)
    SliderBtnCorner.Parent = SliderButton
    
    local sliderDragging = false
    local currentValue = default
    
    -- COMPLETELY FIXED SLIDER
    local function updateSlider(input)
        local mousePos = input.Position
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
    
    SliderButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    sliderDragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            updateSlider(input)
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    sliderDragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    SliderBar.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    SliderButton.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    return SliderFrame
end

-- Auto resize canvas
local function UpdateCanvasSize()
    local maxY = 0
    for _, child in pairs(ContentScroll:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            local childBottom = child.Position.Y.Offset + child.Size.Y.Offset
            if childBottom > maxY then
                maxY = childBottom
            end
        end
    end
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, maxY + 10)
end

-- MAIN TAB
CreateToggle("🚀 Auto Farm NPC", "Main", function(enabled)
    AutoFarmEnabled = enabled
end)

CreateToggle("👹 Auto Farm Boss", "Main", function(enabled)
    AutoFarmBossEnabled = enabled
end)

CreateToggle("⚔️ Auto Skill", "Main", function(enabled)
    AutoSkillEnabled = enabled
end)

CreateToggle("💰 Auto Yen", "Main", function(enabled)
    AutoCollectYenEnabled = enabled
end)

CreateToggle("🎯 Auto Gyasatsu", "Main", function(enabled)
    AutoGyasatsuEnabled = enabled
end)

CreateToggle("🛡️ Anti-Ban", "Main", function(enabled)
    AntiBanEnabled = enabled
end)

CreateSlider("📏 NPC Range", "Main", 5, 50, 15, function(value)
    FarmDistance = value
end)

CreateSlider("👹 Boss Range", "Main", 10, 100, 30, function(value)
    BossFarmDistance = value
end)

-- COMBAT TAB
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
            if esp then esp:Destroy() end
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

UpdateCanvasSize()

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

-- Auto Farm NPC
spawn(function()
    while wait(0.1) do
        if AutoFarmEnabled then
            pcall(function()
                local npc = GetClosestNPC()
                if npc and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    local distance = (HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                    
                    if distance > FarmDistance then
                        TeleportTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, FarmDistance))
                    end
                    
                    AttackTarget(npc)
                    
                    if AutoSkillEnabled then
                        AutoUseSkills()
                    end
                end
            end)
        end
    end
end)

-- Auto Farm Boss
spawn(function()
    while wait(0.1) do
        if AutoFarmBossEnabled then
            pcall(function()
                local boss = GetClosestBoss()
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    local distance = (HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
                    
                    if distance > BossFarmDistance then
                        TeleportTo(boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, BossFarmDistance))
                    end
                    
                    AttackTarget(boss)
                    
                    if AutoSkillEnabled then
                        AutoUseSkills()
                    end
                end
            end)
        end
    end
end)

-- Auto Skill (standalone)
spawn(function()
    while wait(0.3) do
        if AutoSkillEnabled then
            pcall(function()
                AutoUseSkills()
            end)
        end
    end
end)

-- Auto Stats
spawn(function()
    while wait(0.5) do
        if AutoStatEnabled then
            pcall(function()
                if SelectedFaction == "Ghoul" then
                    TrainStat("Kagune")
                    TrainStat("Durability")
                else
                    TrainStat("Quinque")
                    TrainStat("Durability")
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
                    if v:IsA("BasePart") and (v.Name == "Yen" or v.Name == "Money" or v.Name:lower():find("yen")) then
                        local distance = (HumanoidRootPart.Position - v.Position).Magnitude
                        if distance < 200 and distance > 5 then
                            v.CFrame = HumanoidRootPart.CFrame
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto Gyasatsu
spawn(function()
    while wait(0.5) do
        if AutoGyasatsuEnabled then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v.Name:lower():find("gyasatsu") or v.Name:lower():find("aogiri") then
                        if v:IsA("BasePart") then
                            local distance = (HumanoidRootPart.Position - v.Position).Magnitude
                            if distance < 300 then
                                TeleportTo(v.CFrame)
                                wait(0.5)
                            end
                        end
                        
                        if v:IsA("ProximityPrompt") then
                            fireproximityprompt(v)
                        end
                    end
                end
            end)
        end
    end
end)

-- Walk Speed
spawn(function()
    while wait(0.05) do
        if WalkSpeedEnabled and Humanoid then
            Humanoid.WalkSpeed = WalkSpeedValue
        end
    end
end)

-- Jump Power
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
                for _, v in pairs(Player:GetDescendants()) do
                    if v:IsA("NumberValue") and v.Name:lower():find("stamina") then
                        v.Value = 100
                    end
                end
            end)
        end
    end
end)

-- ESP
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

-- Character Update
Player.CharacterAdded:Connect(function(char)
    wait(1)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    DetectFaction()
    Title.Text = "👻 Ro-Ghoul v3.0 | " .. SelectedFaction
end)

print("✅ Ro-Ghoul Ultimate v3.0 loaded!")
print("👻 Faction: " .. SelectedFaction)
print("🔧 All features working!")
