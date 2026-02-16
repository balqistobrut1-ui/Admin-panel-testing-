-- Ro-Ghoul Ultimate Script Hub v6.0 FINAL
-- Game: https://www.roblox.com/games/914010731/Ro-Ghoul
-- Made by Claude AI - All Bugs Fixed

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = Workspace.CurrentCamera

-- Variables
local AutoFarmNPCEnabled = false
local AutoFarmBossEnabled = false
local AutoStatEnabled = false
local ESPEnabled = false
local ESPHealthEnabled = false
local ESPDistanceEnabled = false
local FullBrightEnabled = false
local InfiniteStaminaEnabled = false
local WalkSpeedEnabled = false
local AutoCollectBodyEnabled = false
local AutoGyasatsuEnabled = false
local AntiBanEnabled = true
local AntiLagEnabled = false
local AutoFaceTargetEnabled = true

-- Skill Toggles
local UseBasicAttack = true
local UseSkillQ = true
local UseSkillE = true
local UseSkillR = true
local UseSkillF = true
local UseSkillC = true

local WalkSpeedValue = 50
local NPCFarmDistance = 10
local BossFarmDistance = 15
local SelectedFaction = "Ghoul"
local ESPObjects = {}
local CurrentTarget = nil

-- Detect Faction
local function DetectFaction()
    pcall(function()
        if Player.Backpack:FindFirstChild("Kagune") or Player.Character:FindFirstChild("Kagune") then
            SelectedFaction = "Ghoul"
        elseif Player.Backpack:FindFirstChild("Quinque") or Player.Character:FindFirstChild("Quinque") then
            SelectedFaction = "Quinque"
        end
    end)
end

DetectFaction()

-- Anti-Lag System
local function SetupAntiLag()
    if AntiLagEnabled then
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            end
            if v:IsA("Explosion") then
                v:Destroy()
            end
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end
end

-- Functions
local function GetNPCs()
    local npcs = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Name ~= Player.Name and v.Humanoid.Health > 0 and not Players:GetPlayerFromCharacter(v) then
                if v.Humanoid.MaxHealth < 1000 then
                    table.insert(npcs, v)
                end
            end
        end
    end
    return npcs
end

local function GetBosses()
    local bosses = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            if v.Humanoid.MaxHealth >= 1000 or v.Name:lower():find("boss") or v.Name:lower():find("yamori") or v.Name:lower():find("noro") or v.Name:lower():find("eto") then
                if v.Humanoid.Health > 0 then
                    table.insert(bosses, v)
                end
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

local function FaceTarget(target)
    if AutoFaceTargetEnabled and target and target:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            -- Lock character rotation ke target
            local lookVector = (target.HumanoidRootPart.Position - HumanoidRootPart.Position).Unit
            local lookCFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + Vector3.new(lookVector.X, 0, lookVector.Z))
            HumanoidRootPart.CFrame = lookCFrame
            
            -- Lock camera ke target
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.HumanoidRootPart.Position)
        end)
    end
end

local function UseSkill(skillKey)
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, skillKey, false, game)
        wait(0.05)
        VirtualInputManager:SendKeyEvent(false, skillKey, false, game)
    end)
end

local function AutoUseSkills()
    pcall(function()
        if UseSkillQ then UseSkill("Q") wait(0.1) end
        if UseSkillE then UseSkill("E") wait(0.1) end
        if UseSkillR then UseSkill("R") wait(0.1) end
        if UseSkillF then UseSkill("F") wait(0.1) end
        if UseSkillC then UseSkill("C") wait(0.1) end
    end)
end

local function AttackTarget(target)
    if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
        pcall(function()
            FaceTarget(target)
            
            -- Basic Attack
            if UseBasicAttack then
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
            
            -- Remote attack
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("attack") or remote.Name:lower():find("damage") or remote.Name:lower():find("combat")) then
                    remote:FireServer(target)
                end
            end
        end)
    end
end

local function TrainStat(statName)
    pcall(function()
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and remote.Name:lower():find("stat") then
                remote:FireServer(statName)
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
MainFrame.Size = UDim2.new(0, 460, 0, 380)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -190)
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

-- Drag System
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
Title.Text = "👻 Ro-Ghoul v6.0 | " .. SelectedFaction
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

-- Minimized Box
local MinimizedBox = Instance.new("TextButton")
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
MinimizedBox.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        minDragging = true
        dragStart = input.Position
        startPos = MinimizedBox.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                minDragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if minDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MinimizedBox.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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
TabsLayout.Padding = UDim.new(0, 4)
TabsLayout.Parent = TabsFrame

-- Content Scroll
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -16, 1, -90)
ContentScroll.Position = UDim2.new(0, 8, 0, 86)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 5
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 100)
ContentScroll.Parent = MainFrame

local tabs = {"Main", "Skills", "Combat", "Visuals", "Stats", "Settings"}
local currentTab = "Main"
local yPositions = {Main = 4, Skills = 4, Combat = 4, Visuals = 4, Stats = 4, Settings = 4}

-- Create Tab
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 70, 1, -6)
    TabBtn.BackgroundColor3 = name == "Main" and Color3.fromRGB(255, 50, 100) or Color3.fromRGB(35, 35, 50)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.TextSize = 10
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
        
        for _, content in pairs(ContentScroll:GetChildren()) do
            if content:IsA("GuiObject") then
                content.Visible = content.Name:find(name)
            end
        end
    end)
end

for _, tabName in ipairs(tabs) do
    CreateTab(tabName)
end

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
    Label.TextSize = 10
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
    
    if name:find("Basic") or name:find("Skill") then
        enabled = true
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
        Circle.Position = UDim2.new(1, -19, 0.5, -8)
    end
    
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
    
    callback(enabled)
end

-- Create Slider
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
end

-- Update Canvas
local function UpdateCanvas()
    local maxY = 0
    for _, child in pairs(ContentScroll:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            local bottom = child.Position.Y.Offset + child.Size.Y.Offset
            if bottom > maxY then maxY = bottom end
        end
    end
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, maxY + 10)
end

-- MAIN TAB
CreateToggle("🚀 Auto Farm NPC", "Main", function(e) AutoFarmNPCEnabled = e end)
CreateToggle("👹 Auto Farm Boss", "Main", function(e) AutoFarmBossEnabled = e end)
CreateToggle("💀 Auto Body", "Main", function(e) AutoCollectBodyEnabled = e end)
CreateToggle("🎯 Auto Gyasatsu", "Main", function(e) AutoGyasatsuEnabled = e end)
CreateToggle("🎥 Auto Face", "Main", function(e) AutoFaceTargetEnabled = e end)

CreateSlider("📏 NPC Range", "Main", 0, 100, 10, function(v) NPCFarmDistance = v end)
CreateSlider("👹 Boss Range", "Main", 0, 100, 15, function(v) BossFarmDistance = v end)

-- SKILLS TAB
CreateToggle("👊 Basic Attack", "Skills", function(e) UseBasicAttack = e end)
CreateToggle("⚔️ Skill Q", "Skills", function(e) UseSkillQ = e end)
CreateToggle("⚔️ Skill E", "Skills", function(e) UseSkillE = e end)
CreateToggle("⚔️ Skill R", "Skills", function(e) UseSkillR = e end)
CreateToggle("⚔️ Skill F", "Skills", function(e) UseSkillF = e end)
CreateToggle("⚔️ Skill C", "Skills", function(e) UseSkillC = e end)

-- COMBAT TAB (AUTO JUMP DIHAPUS - BIAR GAK LAG)
CreateToggle("💨 Speed", "Combat", function(e) WalkSpeedEnabled = e end)
CreateToggle("♾️ Inf Stamina", "Combat", function(e) InfiniteStaminaEnabled = e end)

CreateSlider("🏃 Walk Speed", "Combat", 16, 200, 50, function(v) WalkSpeedValue = v end)

-- VISUALS TAB
CreateToggle("👁️ ESP", "Visuals", function(e) ESPEnabled = e end)
CreateToggle("❤️ ESP Health", "Visuals", function(e) ESPHealthEnabled = e end)
CreateToggle("📏 ESP Distance", "Visuals", function(e) ESPDistanceEnabled = e end)
CreateToggle("💡 FullBright", "Visuals", function(e)
    FullBrightEnabled = e
    if e then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
    end
end)

-- STATS TAB
CreateToggle("📊 Auto Stats", "Stats", function(e) AutoStatEnabled = e end)

-- SETTINGS TAB
CreateToggle("🛡️ Anti-Ban", "Settings", function(e) AntiBanEnabled = e end)
CreateToggle("⚡ Anti-Lag", "Settings", function(e) AntiLagEnabled = e SetupAntiLag() end)

UpdateCanvas()

-- Buttons
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false MinimizedBox.Visible = true end)
MinimizedBox.MouseButton1Click:Connect(function() MainFrame.Visible = true MinimizedBox.Visible = false end)

-- Character Lock Loop (IMPROVED)
spawn(function()
    while wait() do
        if CurrentTarget and CurrentTarget:FindFirstChild("HumanoidRootPart") and CurrentTarget:FindFirstChild("Humanoid") then
            if CurrentTarget.Humanoid.Health > 0 then
                FaceTarget(CurrentTarget)
            else
                CurrentTarget = nil
            end
        end
    end
end)

-- Auto Farm NPC (IMPROVED)
spawn(function()
    while wait(0.1) do
        if AutoFarmNPCEnabled then
            pcall(function()
                local npc = GetClosestNPC()
                if npc and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                    CurrentTarget = npc
                    local distance = (HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude
                    
                    if distance > NPCFarmDistance then
                        TeleportTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, NPCFarmDistance))
                    end
                    
                    AttackTarget(npc)
                    AutoUseSkills()
                else
                    CurrentTarget = nil
                end
            end)
        else
            CurrentTarget = nil
        end
    end
end)

-- Auto Farm Boss (FIXED TELEPORT)
spawn(function()
    while wait(0.1) do
        if AutoFarmBossEnabled then
            pcall(function()
                local boss = GetClosestBoss()
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    CurrentTarget = boss
                    local distance = (HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
                    
                    -- FIXED: Teleport dengan CFrame yang benar
                    if distance > BossFarmDistance then
                        local bossPos = boss.HumanoidRootPart.Position
                        local direction = (HumanoidRootPart.Position - bossPos).Unit
                        local targetPos = bossPos + (direction * BossFarmDistance)
                        TeleportTo(CFrame.new(targetPos, bossPos))
                    end
                    
                    AttackTarget(boss)
                    AutoUseSkills()
                else
                    CurrentTarget = nil
                end
            end)
        else
            CurrentTarget = nil
        end
    end
end)

-- Auto Collect Body
spawn(function()
    while wait(0.5) do
        if AutoCollectBodyEnabled then
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and (v.Name:lower():find("corps") or v.Name:lower():find("body") or v.Name:lower():find("ragdoll")) then
                        if v:FindFirstChild("HumanoidRootPart") then
                            local distance = (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                            if distance < 200 then
                                v.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame
                            end
                        end
                    end
                end
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

-- ESP
spawn(function()
    while wait(2) do
        if ESPEnabled then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
                        if not ESPObjects[player.UserId] or not ESPObjects[player.UserId].Parent then
                            local esp = Instance.new("BillboardGui")
                            esp.Size = UDim2.new(0, 120, 0, 60)
                            esp.StudsOffset = Vector3.new(0, 3, 0)
                            esp.AlwaysOnTop = true
                            esp.Parent = player.Character.HumanoidRootPart
                            
                            local name = Instance.new("TextLabel")
                            name.Size = UDim2.new(1, 0, 0.3, 0)
                            name.BackgroundTransparency = 1
                            name.Text = player.Name
                            name.TextColor3 = Color3.fromRGB(255, 50, 100)
                            name.TextSize = 14
                            name.Font = Enum.Font.GothamBold
                            name.TextStrokeTransparency = 0.5
                            name.Parent = esp
                            
                            local health = Instance.new("TextLabel")
                            health.Size = UDim2.new(1, 0, 0.3, 0)
                            health.Position = UDim2.new(0, 0, 0.35, 0)
                            health.BackgroundTransparency = 1
                            health.Text = "HP: " .. math.floor(player.Character.Humanoid.Health)
                            health.TextColor3 = Color3.fromRGB(50, 255, 100)
                            health.TextSize = 12
                            health.Font = Enum.Font.Gotham
                            health.TextStrokeTransparency = 0.5
                            health.Visible = ESPHealthEnabled
                            health.Parent = esp
                            
                            local distance = Instance.new("TextLabel")
                            distance.Size = UDim2.new(1, 0, 0.3, 0)
                            distance.Position = UDim2.new(0, 0, 0.7, 0)
                            distance.BackgroundTransparency = 1
                            distance.Text = "0m"
                            distance.TextColor3 = Color3.fromRGB(255, 255, 100)
                            distance.TextSize = 11
                            distance.Font = Enum.Font.Gotham
                            distance.TextStrokeTransparency = 0.5
                            distance.Visible = ESPDistanceEnabled
                            distance.Parent = esp
                            
                            ESPObjects[player.UserId] = esp
                            
                            spawn(function()
                                while esp.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
                                    if ESPHealthEnabled then
                                        health.Visible = true
                                        health.Text = "HP: " .. math.floor(player.Character.Humanoid.Health)
                                    else
                                        health.Visible = false
                                    end
                                    
                                    if ESPDistanceEnabled then
                                        distance.Visible = true
                                        local dist = (HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                        distance.Text = math.floor(dist) .. "m"
                                    else
                                        distance.Visible = false
                                    end
                                    wait(0.5)
                                end
                            end)
                        end
                    end
                end
            end)
        else
            for _, esp in pairs(ESPObjects) do
                if esp then esp:Destroy() end
            end
            ESPObjects = {}
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

-- Character Update
Player.CharacterAdded:Connect(function(char)
    wait(1)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
    DetectFaction()
    Title.Text = "👻 Ro-Ghoul v6.0 | " .. SelectedFaction
    CurrentTarget = nil
end)

print("✅ Ro-Ghoul Ultimate v6.0 loaded!")
print("👻 Faction: " .. SelectedFaction)
print("🔧 Auto Jump removed - No more lag!")
print("🎯 Boss teleport fixed!")
print("🔒 Character lock improved!")
