--[[

Enhanced ESP Script V2.5
Created by RanZx999
Based on Vcsk's scripts

Features:
- Clean & Simple UI
- Modular ESP (toggle each feature separately)
- Line Tracers
- Auto Team Detection for Highlights
- Hitbox Expander
- Optimized Performance

]]

local CoreGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local function isNumber(str)
  if tonumber(str) ~= nil or str == 'inf' then
    return true
  end
end

-- ESP Settings
getgenv().ESPEnabled = false
getgenv().ESPBoxes = false
getgenv().ESPNames = false
getgenv().ESPDistance = false
getgenv().ESPHealth = false
getgenv().ESPTracers = false
getgenv().ESPTeamCheck = true
getgenv().MaxESPDistance = 2000

-- Hitbox Settings
getgenv().HitboxEnabled = false
getgenv().HitboxSize = 10
getgenv().HitboxTransparency = 0.7
getgenv().HitboxTeamCheck = true

-- Highlight Settings
getgenv().HighlightEnabled = false
getgenv().HighlightTeamCheck = true

-- Colors
local TeamColor = Color3.fromRGB(0, 255, 0)      -- Friendly (Green)
local EnemyColor = Color3.fromRGB(255, 0, 0)     -- Enemy (Red)
local NeutralColor = Color3.fromRGB(255, 255, 255) -- Neutral (White)

--// ESP System
local ESPObjects = {}

local function isTeammate(player)
    if not ESPTeamCheck then return false end
    if not LocalPlayer.Team then return false end
    if not player.Team then return false end
    return player.Team == LocalPlayer.Team
end

local function getPlayerColor(player)
    if isTeammate(player) then
        return TeamColor
    else
        return EnemyColor
    end
end

local function createESP(player)
    if player == LocalPlayer then return end
    
    -- Box
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = NeutralColor
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    
    -- Name Tag
    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = NeutralColor
    nameTag.Size = 15
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameTag.Font = 2
    
    -- Distance Text
    local distanceTag = Drawing.new("Text")
    distanceTag.Visible = false
    distanceTag.Color = NeutralColor
    distanceTag.Size = 13
    distanceTag.Center = true
    distanceTag.Outline = true
    distanceTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    distanceTag.Font = 2
    
    -- Health Bar Background
    local healthBarBG = Drawing.new("Square")
    healthBarBG.Visible = false
    healthBarBG.Color = Color3.fromRGB(20, 20, 20)
    healthBarBG.Thickness = 1
    healthBarBG.Transparency = 0.8
    healthBarBG.Filled = true
    
    -- Health Bar
    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Thickness = 1
    healthBar.Transparency = 1
    healthBar.Filled = true
    
    -- Tracer Line
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = NeutralColor
    tracer.Thickness = 1
    tracer.Transparency = 1
    
    ESPObjects[player] = {
        Box = box,
        Name = nameTag,
        Distance = distanceTag,
        HealthBarBG = healthBarBG,
        HealthBar = healthBar,
        Tracer = tracer
    }
end

local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Name:Remove()
        ESPObjects[player].Distance:Remove()
        ESPObjects[player].HealthBarBG:Remove()
        ESPObjects[player].HealthBar:Remove()
        ESPObjects[player].Tracer:Remove()
        ESPObjects[player] = nil
    end
end

local function updateESP()
    for player, espData in pairs(ESPObjects) do
        if not player or not player.Parent or not player.Character then
            removeESP(player)
            continue
        end
        
        local character = player.Character
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")
        local head = character:FindFirstChild("Head")
        
        if not rootPart or not humanoid or not head then
            espData.Box.Visible = false
            espData.Name.Visible = false
            espData.Distance.Visible = false
            espData.HealthBarBG.Visible = false
            espData.HealthBar.Visible = false
            espData.Tracer.Visible = false
            continue
        end
        
        -- Team Check for ESP
        if ESPTeamCheck and isTeammate(player) then
            espData.Box.Visible = false
            espData.Name.Visible = false
            espData.Distance.Visible = false
            espData.HealthBarBG.Visible = false
            espData.HealthBar.Visible = false
            espData.Tracer.Visible = false
            continue
        end
        
        local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude
        
        -- Distance Check
        if distance > MaxESPDistance then
            espData.Box.Visible = false
            espData.Name.Visible = false
            espData.Distance.Visible = false
            espData.HealthBarBG.Visible = false
            espData.HealthBar.Visible = false
            espData.Tracer.Visible = false
            continue
        end
        
        -- Get Screen Position
        local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
        local rootPos = Camera:WorldToViewportPoint(rootPart.Position)
        
        if not onScreen or not ESPEnabled then
            espData.Box.Visible = false
            espData.Name.Visible = false
            espData.Distance.Visible = false
            espData.HealthBarBG.Visible = false
            espData.HealthBar.Visible = false
            espData.Tracer.Visible = false
            continue
        end
        
        -- Calculate Box Size
        local boxSize = Vector2.new(2000 / distance, 2500 / distance)
        
        -- Get Color
        local playerColor = getPlayerColor(player)
        
        -- Update Box
        if ESPBoxes then
            espData.Box.Size = boxSize
            espData.Box.Position = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
            espData.Box.Color = playerColor
            espData.Box.Visible = true
        else
            espData.Box.Visible = false
        end
        
        -- Update Name Tag
        if ESPNames then
            espData.Name.Text = player.Name
            espData.Name.Position = Vector2.new(headPos.X, headPos.Y - 35)
            espData.Name.Color = playerColor
            espData.Name.Visible = true
        else
            espData.Name.Visible = false
        end
        
        -- Update Distance
        if ESPDistance then
            espData.Distance.Text = string.format("[%.0fm]", distance)
            espData.Distance.Position = Vector2.new(rootPos.X, rootPos.Y + boxSize.Y / 2 + 20)
            espData.Distance.Color = Color3.fromRGB(200, 200, 200)
            espData.Distance.Visible = true
        else
            espData.Distance.Visible = false
        end
        
        -- Update Health Bar
        if ESPHealth and humanoid then
            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            local barWidth = 3
            local barHeight = boxSize.Y
            
            -- Background
            espData.HealthBarBG.Size = Vector2.new(barWidth, barHeight)
            espData.HealthBarBG.Position = Vector2.new(rootPos.X - boxSize.X / 2 - 5, rootPos.Y - boxSize.Y / 2)
            espData.HealthBarBG.Visible = true
            
            -- Health Bar (Green to Red gradient)
            local healthColor = Color3.fromRGB(
                math.floor(255 * (1 - healthPercent)),
                math.floor(255 * healthPercent),
                0
            )
            espData.HealthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
            espData.HealthBar.Position = Vector2.new(
                rootPos.X - boxSize.X / 2 - 5,
                rootPos.Y - boxSize.Y / 2 + barHeight * (1 - healthPercent)
            )
            espData.HealthBar.Color = healthColor
            espData.HealthBar.Visible = true
        else
            espData.HealthBarBG.Visible = false
            espData.HealthBar.Visible = false
        end
        
        -- Update Tracer
        if ESPTracers then
            local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            espData.Tracer.From = screenCenter
            espData.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
            espData.Tracer.Color = playerColor
            espData.Tracer.Visible = true
        else
            espData.Tracer.Visible = false
        end
    end
end

-- Player Events
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

--// Hitbox System
local function updateHitboxes()
    if not HitboxEnabled then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Team Check
                if HitboxTeamCheck and isTeammate(player) then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Material = "Plastic"
                else
                    hrp.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    hrp.Transparency = HitboxTransparency
                    hrp.Material = "Neon"
                    hrp.BrickColor = BrickColor.new("Bright red")
                    hrp.CanCollide = false
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if HitboxEnabled then
        updateHitboxes()
    end
end)

--// Highlight System
local Highlights = {}

local function createHighlight(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.Adornee = player.Character
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    
    -- Team-based colors
    if HighlightTeamCheck then
        if isTeammate(player) then
            highlight.FillColor = TeamColor
            highlight.OutlineColor = TeamColor
        else
            highlight.FillColor = EnemyColor
            highlight.OutlineColor = EnemyColor
        end
    else
        highlight.FillColor = NeutralColor
        highlight.OutlineColor = NeutralColor
    end
    
    Highlights[player] = highlight
end

local function removeHighlight(player)
    if Highlights[player] then
        Highlights[player]:Destroy()
        Highlights[player] = nil
    end
end

local function updateHighlights()
    for player, highlight in pairs(Highlights) do
        if not player or not player.Parent or not player.Character then
            removeHighlight(player)
            continue
        end
        
        if HighlightTeamCheck then
            if isTeammate(player) then
                highlight.FillColor = TeamColor
                highlight.OutlineColor = TeamColor
            else
                highlight.FillColor = EnemyColor
                highlight.OutlineColor = EnemyColor
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if HighlightEnabled then
        updateHighlights()
    end
end)

--// UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/UI-Library/main/Source/MyUILib(Unamed).lua"))();
local Window = Library:Create("RanZx999 ESP Hub")

local ToggleGui = Instance.new("ScreenGui")
local Toggle = Instance.new("TextButton")

ToggleGui.Name = "ToggleGui_RanZx"
ToggleGui.Parent = game.CoreGui

Toggle.Name = "Toggle"
Toggle.Parent = ToggleGui
Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Toggle.BackgroundTransparency = 0.3
Toggle.BorderSizePixel = 0
Toggle.Position = UDim2.new(0, 10, 0.5, -25)
Toggle.Size = UDim2.new(0, 100, 0, 50)
Toggle.Font = Enum.Font.GothamBold
Toggle.Text = "RanZx999\nESP"
Toggle.TextColor3 = Color3.fromRGB(255, 50, 50)
Toggle.TextSize = 14
Toggle.Active = true
Toggle.Draggable = true

-- Add corner rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = Toggle

Toggle.MouseButton1Click:connect(function()
    Library:ToggleUI()
end)

local ESPTab = Window:Tab("ESP","rbxassetid://12308581351")
local HitboxTab = Window:Tab("Hitbox","rbxassetid://10888331510")
local SettingsTab = Window:Tab("Settings","rbxassetid://12296135476")

-- ESP Tab
ESPTab:InfoLabel("by RanZx999 | Simple & Clean")
ESPTab:Section("Main Controls")

ESPTab:Toggle("Enable ESP", function(state)
    getgenv().ESPEnabled = state
    
    if state then
        -- Create ESP for existing players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESP(player)
            end
        end
        
        -- Start update loop
        RunService.RenderStepped:Connect(function()
            if ESPEnabled then
                updateESP()
            end
        end)
    else
        -- Remove all ESP
        for player, _ in pairs(ESPObjects) do
            removeESP(player)
        end
    end
end)

ESPTab:Section("ESP Features")

ESPTab:Toggle("Boxes", function(state)
    getgenv().ESPBoxes = state
end)

ESPTab:Toggle("Names", function(state)
    getgenv().ESPNames = state
end)

ESPTab:Toggle("Distance", function(state)
    getgenv().ESPDistance = state
end)

ESPTab:Toggle("Health Bars", function(state)
    getgenv().ESPHealth = state
end)

ESPTab:Toggle("Tracers (Lines)", function(state)
    getgenv().ESPTracers = state
end)

ESPTab:Section("ESP Settings")

ESPTab:Toggle("Team Check (Hide Teammates)", function(state)
    getgenv().ESPTeamCheck = state
end)

ESPTab:Slider("Max Distance", 500, 5000, function(value)
    getgenv().MaxESPDistance = value
end)

-- Hitbox Tab
HitboxTab:InfoLabel("Hitbox Expander")
HitboxTab:Section("Main Controls")

HitboxTab:Toggle("Enable Hitbox", function(state)
    getgenv().HitboxEnabled = state
    
    if not state then
        -- Reset all hitboxes
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.Material = "Plastic"
                end
            end
        end
    end
end)

HitboxTab:Section("Hitbox Settings")

HitboxTab:Slider("Hitbox Size", 1, 30, function(value)
    getgenv().HitboxSize = value
end)

HitboxTab:Slider("Transparency", 0, 1, function(value)
    getgenv().HitboxTransparency = value
end)

HitboxTab:Toggle("Team Check (Skip Teammates)", function(state)
    getgenv().HitboxTeamCheck = state
end)

-- Settings Tab
SettingsTab:InfoLabel("Highlight & Other Settings")
SettingsTab:Section("Character Highlight")

SettingsTab:Toggle("Enable Highlight", function(state)
    getgenv().HighlightEnabled = state
    
    if state then
        -- Create highlights for existing players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createHighlight(player)
            end
        end
        
        -- Handle new players
        Players.PlayerAdded:Connect(function(player)
            if HighlightEnabled then
                repeat wait() until player.Character
                createHighlight(player)
            end
        end)
        
        -- Handle character respawn
        for _, player in pairs(Players:GetPlayers()) do
            player.CharacterAdded:Connect(function()
                if HighlightEnabled then
                    wait(0.5)
                    createHighlight(player)
                end
            end)
        end
    else
        -- Remove all highlights
        for player, _ in pairs(Highlights) do
            removeHighlight(player)
        end
    end
end)

SettingsTab:Toggle("Auto Team Colors", function(state)
    getgenv().HighlightTeamCheck = state
end)

SettingsTab:InfoLabel("Green = Teammate | Red = Enemy")

SettingsTab:Section("UI Controls")

SettingsTab:Keybind("Toggle UI", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)

SettingsTab:Button("Destroy GUI", function()
    game.CoreGui:FindFirstChild("ToggleGui_RanZx"):Destroy()
    Library:DestroyUI()
end)

-- Startup message
print("=================================")
print("RanZx999 ESP Hub Loaded!")
print("Press F to toggle UI")
print("=================================")
print("Features:")
print("- Modular ESP (boxes, names, distance, health, tracers)")
print("- Hitbox Expander")
print("- Auto Team Detection Highlights")
print("- Clean & Simple UI")
print("=================================")
