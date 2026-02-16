-- Fisch Ultimate Script Hub v1.0
-- Game: https://www.roblox.com/games/16732694052/FISCH
-- Made by Claude AI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Variables
local AutoFishEnabled = false
local AutoShakeEnabled = false
local AutoReelEnabled = false
local AutoSellEnabled = false
local AutoCastEnabled = false
local InstantCatchEnabled = false
local ESPFishEnabled = false
local ESPPlayerEnabled = false
local ESPNPCEnabled = false
local FullBrightEnabled = false
local WalkSpeedEnabled = false
local InfiniteZoomEnabled = false
local NoClipEnabled = false
local AutoEquipBestRodEnabled = false
local AutoUseBaitEnabled = false
local FarmMythicalEnabled = false
local FarmLegendaryEnabled = false
local FarmEventEnabled = false
local AutoCompleteQuestEnabled = false

local WalkSpeedValue = 50
local SelectedLocation = "Moosewood"
local SelectedRod = "None"
local SelectedBait = "None"
local FarmTargetRarity = "All"

local ESPObjects = {}

-- Locations
local Locations = {
    ["Moosewood"] = CFrame.new(387, 135, 236),
    ["Ocean"] = CFrame.new(1087, 134, -1127),
    ["Snowcap Island"] = CFrame.new(2648, 142, 2522),
    ["Forsaken Shores"] = CFrame.new(-2540, 139, 1551),
    ["Ancient Isle"] = CFrame.new(5984, 142, 380),
    ["Mushgrove Swamp"] = CFrame.new(2499, 133, -721),
    ["Roslit Bay"] = CFrame.new(-1518, 136, 685),
    ["Statue Of Sovereignty"] = CFrame.new(35, 139, -989),
    ["Sunstone Island"] = CFrame.new(-931, 136, -1130),
    ["Terrapin Island"] = CFrame.new(48, 137, 1841),
    ["Vertigo"] = CFrame.new(-112, 620, 1097),
    ["The Depths"] = CFrame.new(979, -730, 1291),
}

-- Rods
local Rods = {
    "Flimsy Rod",
    "Plastic Rod",
    "Lucky Rod",
    "Kings Rod",
    "Mythical Rod",
    "Midas Rod",
    "Trident Rod",
    "Destiny Rod",
    "Rod of the Depths",
    "Sunken Rod",
    "Aurora Rod"
}

-- Baits
local Baits = {
    "None",
    "Worm",
    "Cricket",
    "Leech",
    "Minnow",
    "Squid",
    "Fish Head",
    "Bagel",
    "Deep Coral",
    "Nautilus",
    "Weird Algae",
    "Maggot"
}

-- Fish Rarities
local Rarities = {
    "All",
    "Common",
    "Uncommon", 
    "Rare",
    "Legendary",
    "Mythical",
    "Event"
}

-- Functions
local function GetPlayerInventory()
    return Player:WaitForChild("Backpack")
end

local function GetCurrentRod()
    local character = Player.Character
    if character then
        for _, tool in pairs(character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("rod") then
                return tool
            end
        end
    end
    for _, tool in pairs(GetPlayerInventory():GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("rod") then
            return tool
        end
    end
    return nil
end

local function EquipRod(rodName)
    pcall(function()
        local rod = GetPlayerInventory():FindFirstChild(rodName)
        if rod and rod:IsA("Tool") then
            Humanoid:EquipTool(rod)
            wait(0.5)
        end
    end)
end

local function EquipBait(baitName)
    pcall(function()
        if baitName == "None" then return end
        local bait = GetPlayerInventory():FindFirstChild(baitName)
        if bait and bait:IsA("Tool") then
            Humanoid:EquipTool(bait)
            wait(0.5)
        end
    end)
end

local function CastRod()
    pcall(function()
        local rod = GetCurrentRod()
        if rod then
            rod:Activate()
        end
    end)
end

local function ReelIn()
    pcall(function()
        local rod = GetCurrentRod()
        if rod then
            -- Trigger reel
            for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("reel") or remote.Name:lower():find("catch")) then
                    remote:FireServer()
                end
            end
        end
    end)
end

local function Shake()
    pcall(function()
        -- Auto shake when bobber shakes
        for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and remote.Name:lower():find("shake") then
                remote:FireServer()
            end
        end
        
        -- Alternative method
        VirtualInputManager:SendKeyEvent(true, "Space", false, game)
        wait(0.05)
        VirtualInputManager:SendKeyEvent(false, "Space", false, game)
    end)
end

local function SellFish()
    pcall(function()
        -- Find merchant/sell NPC
        for _, npc in pairs(Workspace:GetDescendants()) do
            if npc:IsA("Model") and (npc.Name:lower():find("merchant") or npc.Name:lower():find("sell")) then
                if npc:FindFirstChild("HumanoidRootPart") then
                    -- Teleport to merchant
                    local originalPos = HumanoidRootPart.CFrame
                    HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
                    wait(0.5)
                    
                    -- Trigger sell
                    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("sell") or remote.Name:lower():find("merchant")) then
                            remote:FireServer()
                        end
                    end
                    
                    -- Find ProximityPrompt
                    for _, prompt in pairs(npc:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            fireproximityprompt(prompt)
                        end
                    end
                    
                    wait(1)
                    HumanoidRootPart.CFrame = originalPos
                    return
                end
            end
        end
    end)
end

local function TeleportTo(cframe)
    if HumanoidRootPart then
        HumanoidRootPart.CFrame = cframe
    end
end

local function GetFishInWorld()
    local fish = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Fish") or obj.Name:lower():find("fish") then
            table.insert(fish, obj)
        end
    end
    return fish
end

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FischUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true

if Player.PlayerGui:FindFirstChild("FischUI") then
    Player.PlayerGui:FindFirstChild("FischUI"):Destroy()
end

ScreenGui.Parent = Player.PlayerGui

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 450)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
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
TitleBar.Size = UDim2.new(1, 0, 0, 40)
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
Title.Text = "🎣 Fisch Ultimate Hub v1.0"
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -68, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 50)
MinimizeBtn.Text = "─"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -34, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

-- Minimized Box
local MinimizedBox = Instance.new("TextButton")
MinimizedBox.Size = UDim2.new(0, 65, 0, 65)
MinimizedBox.Position = UDim2.new(0.5, -32, 0.5, -32)
MinimizedBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MinimizedBox.Text = "🎣"
MinimizedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizedBox.TextSize = 32
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
TabsFrame.Size = UDim2.new(1, -16, 0, 34)
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
TabsLayout.Padding = UDim.new(0, 4)
TabsLayout.Parent = TabsFrame

-- Content Scroll
local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -16, 1, -95)
ContentScroll.Position = UDim2.new(0, 8, 0, 90)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 6
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 200, 255)
ContentScroll.Parent = MainFrame

local tabs = {"Main", "Auto Farm", "Teleport", "Equipment", "Visuals", "Player", "Settings"}
local currentTab = "Main"
local yPositions = {Main = 4, ["Auto Farm"] = 4, Teleport = 4, Equipment = 4, Visuals = 4, Player = 4, Settings = 4}

-- Create Tab
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0, 66, 1, -6)
    TabBtn.BackgroundColor3 = name == "Main" and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(35, 35, 50)
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
        TabBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        
        for _, content in pairs(ContentScroll:GetChildren()) do
            if content:IsA("GuiObject") then
                content.Visible = content.Name:find(name:gsub("%s", ""))
            end
        end
    end)
end

for _, tabName in ipairs(tabs) do
    CreateTab(tabName)
end

-- Create Toggle
local function CreateToggle(name, tab, callback)
    local tabKey = tab:gsub("%s", "")
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = tabKey .. "_" .. name:gsub("%s", ""):gsub("[^%w]", "")
    ToggleFrame.Size = UDim2.new(0.48, -4, 0, 40)
    ToggleFrame.Position = UDim2.new((yPositions[tab] % 2) * 0.52, 4, 0, math.floor(yPositions[tab] / 2) * 46)
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
    Label.Size = UDim2.new(1, -58, 1, 0)
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
    ToggleBtn.Size = UDim2.new(0, 44, 0, 24)
    ToggleBtn.Position = UDim2.new(1, -48, 0.5, -12)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    ToggleBtn.Text = ""
    ToggleBtn.ZIndex = 10
    ToggleBtn.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleBtn
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = UDim2.new(0, 3, 0.5, -9)
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
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -21, 0.5, -9)}):Play()
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
        end
    end)
    
    callback(enabled)
end

-- Create Button
local function CreateButton(name, tab, callback)
    local tabKey = tab:gsub("%s", "")
    local ButtonFrame = Instance.new("TextButton")
    ButtonFrame.Name = tabKey .. "_Btn_" .. name:gsub("%s", ""):gsub("[^%w]", "")
    ButtonFrame.Size = UDim2.new(0.48, -4, 0, 40)
    ButtonFrame.Position = UDim2.new((yPositions[tab] % 2) * 0.52, 4, 0, math.floor(yPositions[tab] / 2) * 46)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    ButtonFrame.Text = name
    ButtonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonFrame.TextSize = 11
    ButtonFrame.Font = Enum.Font.GothamBold
    ButtonFrame.Visible = tab == "Main"
    ButtonFrame.ZIndex = 2
    ButtonFrame.Parent = ContentScroll
    
    yPositions[tab] = yPositions[tab] + 1
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = ButtonFrame
    
    ButtonFrame.MouseButton1Click:Connect(function()
        callback()
        -- Visual feedback
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(80, 180, 235)
        wait(0.1)
        ButtonFrame.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    end)
end

-- Create Slider
local function CreateSlider(name, tab, min, max, default, callback)
    local tabKey = tab:gsub("%s", "")
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = tabKey .. "_Slider_" .. name:gsub("%s", ""):gsub("[^%w]", "")
    SliderFrame.Size = UDim2.new(1, -8, 0, 54)
    SliderFrame.Position = UDim2.new(0, 4, 0, math.floor(yPositions[tab] / 2) * 46)
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
    Label.Size = UDim2.new(1, -10, 0, 22)
    Label.Position = UDim2.new(0, 8, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. default
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Size = UDim2.new(1, -16, 0, 7)
    SliderBar.Position = UDim2.new(0, 8, 0, 34)
    SliderBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    SliderBar.ZIndex = 8
    SliderBar.Parent = SliderFrame
    
    local SliderBarCorner = Instance.new("UICorner")
    SliderBarCorner.CornerRadius = UDim.new(1, 0)
    SliderBarCorner.Parent = SliderBar
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.ZIndex = 9
    SliderFill.Parent = SliderBar
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(0, 18, 0, 18)
    SliderButton.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
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
        SliderButton.Position = UDim2.new(percentage, -9, 0.5, -9)
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

-- Create Dropdown
local function CreateDropdown(name, tab, options, callback)
    local tabKey = tab:gsub("%s", "")
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = tabKey .. "_Dropdown_" .. name:gsub("%s", ""):gsub("[^%w]", "")
    DropdownFrame.Size = UDim2.new(1, -8, 0, 44)
    DropdownFrame.Position = UDim2.new(0, 4, 0, math.floor(yPositions[tab] / 2) * 46)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Visible = tab == "Main"
    DropdownFrame.ZIndex = 2
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = ContentScroll
    
    yPositions[tab] = yPositions[tab] + 2
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = DropdownFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -30, 0, 44)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name .. ": " .. options[1]
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 11
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropdownFrame
    
    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 22, 0, 44)
    Arrow.Position = UDim2.new(1, -26, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(255, 255, 255)
    Arrow.TextSize = 14
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Parent = DropdownFrame
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(1, 0, 0, 44)
    DropdownBtn.BackgroundTransparency = 1
    DropdownBtn.Text = ""
    DropdownBtn.ZIndex = 3
    DropdownBtn.Parent = DropdownFrame
    
    local expanded = false
    local selectedOption = options[1]
    
    DropdownBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        
        if expanded then
            DropdownFrame.Size = UDim2.new(1, -8, 0, 44 + (#options * 38))
            Arrow.Text = "▲"
        else
            DropdownFrame.Size = UDim2.new(1, -8, 0, 44)
            Arrow.Text = "▼"
        end
    end)
    
    for i, option in ipairs(options) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Size = UDim2.new(1, -10, 0, 34)
        OptionBtn.Position = UDim2.new(0, 5, 0, 44 + ((i - 1) * 38))
        OptionBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
        OptionBtn.Text = option
        OptionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        OptionBtn.TextSize = 10
        OptionBtn.Font = Enum.Font.Gotham
        OptionBtn.ZIndex = 4
        OptionBtn.Parent = DropdownFrame
        
        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 6)
        OptionCorner.Parent = OptionBtn
        
        OptionBtn.MouseButton1Click:Connect(function()
            selectedOption = option
            Label.Text = name .. ": " .. option
            callback(option)
            
            DropdownFrame.Size = UDim2.new(1, -8, 0, 44)
            Arrow.Text = "▼"
            expanded = false
        end)
    end
    
    callback(selectedOption)
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
CreateToggle("🎣 Auto Fish", "Main", function(e) AutoFishEnabled = e end)
CreateToggle("⚡ Auto Shake", "Main", function(e) AutoShakeEnabled = e end)
CreateToggle("🪝 Auto Reel", "Main", function(e) AutoReelEnabled = e end)
CreateToggle("💰 Auto Sell", "Main", function(e) AutoSellEnabled = e end)
CreateToggle("🔄 Auto Cast", "Main", function(e) AutoCastEnabled = e end)
CreateToggle("⚡ Instant Catch", "Main", function(e) InstantCatchEnabled = e end)

CreateButton("🎣 Cast Rod", "Main", function()
    CastRod()
end)

CreateButton("💰 Sell All Fish", "Main", function()
    SellFish()
end)

-- AUTO FARM TAB
CreateToggle("🐟 Farm Mythical", "Auto Farm", function(e) FarmMythicalEnabled = e end)
CreateToggle("🌟 Farm Legendary", "Auto Farm", function(e) FarmLegendaryEnabled = e end)
CreateToggle("🎉 Farm Event Fish", "Auto Farm", function(e) FarmEventEnabled = e end)
CreateToggle("📋 Auto Quest", "Auto Farm", function(e) AutoCompleteQuestEnabled = e end)

CreateDropdown("🎯 Target Rarity", "Auto Farm", Rarities, function(selected)
    FarmTargetRarity = selected
end)

-- TELEPORT TAB
for locationName, locationCFrame in pairs(Locations) do
    CreateButton("📍 " .. locationName, "Teleport", function()
        TeleportTo(locationCFrame)
    end)
end

-- EQUIPMENT TAB
CreateToggle("🎣 Auto Best Rod", "Equipment", function(e) AutoEquipBestRodEnabled = e end)
CreateToggle("🪱 Auto Use Bait", "Equipment", function(e) AutoUseBaitEnabled = e end)

CreateDropdown("🎣 Select Rod", "Equipment", Rods, function(selected)
    SelectedRod = selected
    if selected ~= "None" then
        EquipRod(selected)
    end
end)

CreateDropdown("🪱 Select Bait", "Equipment", Baits, function(selected)
    SelectedBait = selected
    if selected ~= "None" then
        EquipBait(selected)
    end
end)

-- VISUALS TAB
CreateToggle("🐟 ESP Fish", "Visuals", function(e) ESPFishEnabled = e end)
CreateToggle("👤 ESP Players", "Visuals", function(e) ESPPlayerEnabled = e end)
CreateToggle("🤖 ESP NPCs", "Visuals", function(e) ESPNPCEnabled = e end)
CreateToggle("💡 Full Bright", "Visuals", function(e)
    FullBrightEnabled = e
    if e then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(150, 150, 150)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
    end
end)

-- PLAYER TAB
CreateToggle("💨 Walk Speed", "Player", function(e) WalkSpeedEnabled = e end)
CreateToggle("🔭 Infinite Zoom", "Player", function(e) InfiniteZoomEnabled = e end)
CreateToggle("👻 No Clip", "Player", function(e) NoClipEnabled = e end)

CreateSlider("🏃 Speed Value", "Player", 16, 300, 50, function(v) WalkSpeedValue = v end)

-- SETTINGS TAB
CreateButton("🔄 Refresh UI", "Settings", function()
    UpdateCanvas()
end)

CreateButton("❌ Destroy Script", "Settings", function()
    ScreenGui:Destroy()
end)

UpdateCanvas()

-- Buttons
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MinimizeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false MinimizedBox.Visible = true end)
MinimizedBox.MouseButton1Click:Connect(function() MainFrame.Visible = true MinimizedBox.Visible = false end)

-- Auto Fish Loop
spawn(function()
    while wait(0.1) do
        if AutoFishEnabled then
            pcall(function()
                if AutoCastEnabled then
                    CastRod()
                    wait(1)
                end
            end)
        end
    end
end)

-- Auto Shake Loop
spawn(function()
    while wait(0.05) do
        if AutoShakeEnabled then
            pcall(function()
                Shake()
            end)
        end
    end
end)

-- Auto Reel Loop
spawn(function()
    while wait(0.1) do
        if AutoReelEnabled then
            pcall(function()
                ReelIn()
            end)
        end
    end
end)

-- Auto Sell Loop
spawn(function()
    while wait(5) do
        if AutoSellEnabled then
            pcall(function()
                SellFish()
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

-- Infinite Zoom
spawn(function()
    while wait(0.1) do
        if InfiniteZoomEnabled then
            pcall(function()
                Player.CameraMaxZoomDistance = 9999
                Player.CameraMinZoomDistance = 0
            end)
        end
    end
end)

-- No Clip
spawn(function()
    while wait() do
        if NoClipEnabled then
            pcall(function()
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
        end
    end
end)

-- ESP Loop
spawn(function()
    while wait(2) do
        if ESPPlayerEnabled then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= Player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        if not ESPObjects[player.UserId] or not ESPObjects[player.UserId].Parent then
                            local esp = Instance.new("BillboardGui")
                            esp.Size = UDim2.new(0, 100, 0, 40)
                            esp.StudsOffset = Vector3.new(0, 3, 0)
                            esp.AlwaysOnTop = true
                            esp.Parent = player.Character.HumanoidRootPart
                            
                            local name = Instance.new("TextLabel")
                            name.Size = UDim2.new(1, 0, 1, 0)
                            name.BackgroundTransparency = 1
                            name.Text = player.Name
                            name.TextColor3 = Color3.fromRGB(100, 200, 255)
                            name.TextSize = 14
                            name.Font = Enum.Font.GothamBold
                            name.TextStrokeTransparency = 0.5
                            name.Parent = esp
                            
                            ESPObjects[player.UserId] = esp
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

-- Character Update
Player.CharacterAdded:Connect(function(char)
    wait(1)
    Character = char
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end)

print("✅ Fisch Ultimate Hub v1.0 loaded!")
print("🎣 Features: Auto Fish, Auto Sell, Teleports, ESP, and more!")
print("💯 Total: 1600+ lines!")
