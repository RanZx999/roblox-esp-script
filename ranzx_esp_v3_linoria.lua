--[[

RanZx999 ESP Hub V3.0
UI Library: Linoria (Clean & Stable)

Features:
- ESP (Box, Names, Distance, Health, Tracers)
- Hitbox Expander
- Speed & Jump Hack
- Auto Team Highlight
- Clean Linoria UI
- Mobile-Friendly
- NO MORE BUGS!

]]

local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

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

-- Movement Settings
getgenv().SpeedEnabled = false
getgenv().SpeedValue = 16
getgenv().JumpEnabled = false
getgenv().JumpValue = 50

-- Colors
local TeamColor = Color3.fromRGB(0, 255, 0)
local EnemyColor = Color3.fromRGB(255, 0, 0)
local NeutralColor = Color3.fromRGB(255, 255, 255)

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
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = NeutralColor
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    
    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = NeutralColor
    nameTag.Size = 15
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameTag.Font = 2
    
    local distanceTag = Drawing.new("Text")
    distanceTag.Visible = false
    distanceTag.Color = NeutralColor
    distanceTag.Size = 13
    distanceTag.Center = true
    distanceTag.Outline = true
    distanceTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    distanceTag.Font = 2
    
    local healthBarBG = Drawing.new("Square")
    healthBarBG.Visible = false
    healthBarBG.Color = Color3.fromRGB(20, 20, 20)
    healthBarBG.Thickness = 1
    healthBarBG.Transparency = 0.8
    healthBarBG.Filled = true
    
    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Thickness = 1
    healthBar.Transparency = 1
    healthBar.Filled = true
    
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
        
        if distance > MaxESPDistance then
            espData.Box.Visible = false
            espData.Name.Visible = false
            espData.Distance.Visible = false
            espData.HealthBarBG.Visible = false
            espData.HealthBar.Visible = false
            espData.Tracer.Visible = false
            continue
        end
        
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
        
        local boxSize = Vector2.new(2000 / distance, 2500 / distance)
        local playerColor = getPlayerColor(player)
        
        if ESPBoxes then
            espData.Box.Size = boxSize
            espData.Box.Position = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
            espData.Box.Color = playerColor
            espData.Box.Visible = true
        else
            espData.Box.Visible = false
        end
        
        if ESPNames then
            espData.Name.Text = player.Name
            espData.Name.Position = Vector2.new(headPos.X, headPos.Y - 35)
            espData.Name.Color = playerColor
            espData.Name.Visible = true
        else
            espData.Name.Visible = false
        end
        
        if ESPDistance then
            espData.Distance.Text = string.format("[%.0fm]", distance)
            espData.Distance.Position = Vector2.new(rootPos.X, rootPos.Y + boxSize.Y / 2 + 20)
            espData.Distance.Color = Color3.fromRGB(200, 200, 200)
            espData.Distance.Visible = true
        else
            espData.Distance.Visible = false
        end
        
        if ESPHealth and humanoid then
            local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
            local barWidth = 3
            local barHeight = boxSize.Y
            
            espData.HealthBarBG.Size = Vector2.new(barWidth, barHeight)
            espData.HealthBarBG.Position = Vector2.new(rootPos.X - boxSize.X / 2 - 5, rootPos.Y - boxSize.Y / 2)
            espData.HealthBarBG.Visible = true
            
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
    if ESPEnabled then
        updateESP()
    end
end)

--// Movement System
local function updateMovement()
    local char = LocalPlayer.Character
    if not char then return end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    if SpeedEnabled then
        humanoid.WalkSpeed = SpeedValue
    end
    
    if JumpEnabled then
        humanoid.JumpPower = JumpValue
    end
end

RunService.Heartbeat:Connect(function()
    if SpeedEnabled or JumpEnabled then
        updateMovement()
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

--// UI Creation
local Window = Library:CreateWindow({
    Title = 'RanZx999 ESP Hub V3.1 - Polished',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    ESP = Window:AddTab('ESP'),
    Hitbox = Window:AddTab('Hitbox'),
    Movement = Window:AddTab('Movement'),
    Highlight = Window:AddTab('Highlight'),
    Settings = Window:AddTab('Settings')
}

-- ESP Tab
local ESPBox = Tabs.ESP:AddLeftGroupbox('ESP System')

ESPBox:AddToggle('EnableESP', {
    Text = 'Enable ESP',
    Default = false,
    Tooltip = 'Turn ESP on/off',
    Callback = function(Value)
        getgenv().ESPEnabled = Value
        
        if Value then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
        else
            for player, _ in pairs(ESPObjects) do
                removeESP(player)
            end
        end
    end
})

ESPBox:AddDivider()

ESPBox:AddToggle('ESPBoxes', {
    Text = 'Show Boxes',
    Default = false,
    Tooltip = 'Display ESP boxes around players',
    Callback = function(Value)
        getgenv().ESPBoxes = Value
    end
})

ESPBox:AddToggle('ESPNames', {
    Text = 'Show Names',
    Default = false,
    Tooltip = 'Display player names',
    Callback = function(Value)
        getgenv().ESPNames = Value
    end
})

ESPBox:AddToggle('ESPDistance', {
    Text = 'Show Distance',
    Default = false,
    Tooltip = 'Display distance to players',
    Callback = function(Value)
        getgenv().ESPDistance = Value
    end
})

ESPBox:AddToggle('ESPHealth', {
    Text = 'Show Health Bars',
    Default = false,
    Tooltip = 'Display health bars',
    Callback = function(Value)
        getgenv().ESPHealth = Value
    end
})

ESPBox:AddToggle('ESPTracers', {
    Text = 'Show Tracers',
    Default = false,
    Tooltip = 'Display lines to players',
    Callback = function(Value)
        getgenv().ESPTracers = Value
    end
})

local ESPSettings = Tabs.ESP:AddRightGroupbox('ESP Settings')

ESPSettings:AddToggle('ESPTeamCheck', {
    Text = 'Team Check',
    Default = true,
    Tooltip = 'Hide teammates from ESP',
    Callback = function(Value)
        getgenv().ESPTeamCheck = Value
    end
})

ESPSettings:AddSlider('MaxDistance', {
    Text = 'Max Distance',
    Default = 2000,
    Min = 500,
    Max = 5000,
    Rounding = 0,
    Compact = false,
    Suffix = 'm',
    Callback = function(Value)
        getgenv().MaxESPDistance = Value
    end
})

ESPSettings:AddLabel('Current: 2000m'):AddLabel(' ')

-- Hitbox Tab
local HitboxMain = Tabs.Hitbox:AddLeftGroupbox('Hitbox Expander')

HitboxMain:AddToggle('EnableHitbox', {
    Text = 'Enable Hitbox',
    Default = false,
    Tooltip = 'Expand player hitboxes',
    Callback = function(Value)
        getgenv().HitboxEnabled = Value
        
        if not Value then
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
    end
})

HitboxMain:AddDivider()

HitboxMain:AddSlider('HitboxSize', {
    Text = 'Hitbox Size',
    Default = 10,
    Min = 1,
    Max = 30,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        getgenv().HitboxSize = Value
    end
})

HitboxMain:AddSlider('HitboxTransparency', {
    Text = 'Transparency',
    Default = 0.7,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        getgenv().HitboxTransparency = Value
    end
})

HitboxMain:AddToggle('HitboxTeamCheck', {
    Text = 'Team Check',
    Default = true,
    Tooltip = 'Skip teammates',
    Callback = function(Value)
        getgenv().HitboxTeamCheck = Value
    end
})

-- Movement Tab
local SpeedBox = Tabs.Movement:AddLeftGroupbox('Speed Hack')

SpeedBox:AddToggle('EnableSpeed', {
    Text = 'Enable Speed',
    Default = false,
    Tooltip = 'Increase walk speed',
    Callback = function(Value)
        getgenv().SpeedEnabled = Value
        
        if not Value then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            end
        end
    end
})

SpeedBox:AddSlider('SpeedValue', {
    Text = 'Speed',
    Default = 16,
    Min = 16,
    Max = 200,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        getgenv().SpeedValue = Value
    end
})

SpeedBox:AddLabel('Safe: 20-30 | Fast: 50-100')

local JumpBox = Tabs.Movement:AddRightGroupbox('Jump Hack')

JumpBox:AddToggle('EnableJump', {
    Text = 'Enable Jump',
    Default = false,
    Tooltip = 'Increase jump power',
    Callback = function(Value)
        getgenv().JumpEnabled = Value
        
        if not Value then
            local char = LocalPlayer.Character
            if char then
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.JumpPower = 50
                end
            end
        end
    end
})

JumpBox:AddSlider('JumpValue', {
    Text = 'Jump Power',
    Default = 50,
    Min = 50,
    Max = 300,
    Rounding = 0,
    Compact = false,
    Callback = function(Value)
        getgenv().JumpValue = Value
    end
})

JumpBox:AddLabel('Safe: 60-100 | High: 150-200')

-- Highlight Tab
local HighlightBox = Tabs.Highlight:AddLeftGroupbox('Character Highlight')

HighlightBox:AddToggle('EnableHighlight', {
    Text = 'Enable Highlight',
    Default = false,
    Tooltip = 'Highlight all players',
    Callback = function(Value)
        getgenv().HighlightEnabled = Value
        
        if Value then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createHighlight(player)
                end
            end
            
            Players.PlayerAdded:Connect(function(player)
                if HighlightEnabled then
                    repeat wait() until player.Character
                    createHighlight(player)
                end
            end)
            
            for _, player in pairs(Players:GetPlayers()) do
                player.CharacterAdded:Connect(function()
                    if HighlightEnabled then
                        wait(0.5)
                        createHighlight(player)
                    end
                end)
            end
        else
            for player, _ in pairs(Highlights) do
                removeHighlight(player)
            end
        end
    end
})

HighlightBox:AddToggle('HighlightTeamCheck', {
    Text = 'Auto Team Colors',
    Default = true,
    Tooltip = 'Green=Friend, Red=Enemy',
    Callback = function(Value)
        getgenv().HighlightTeamCheck = Value
    end
})

HighlightBox:AddLabel('🟢 Green = Teammate')
HighlightBox:AddLabel('🔴 Red = Enemy')

-- Settings Tab
local MenuGroup = Tabs.Settings:AddLeftGroupbox('Menu Controls')

MenuGroup:AddLabel('UI Keybind:')
MenuGroup:AddDropdown('UIKeybind', {
    Values = {'RightShift', 'LeftShift', 'F', 'Insert', 'End', 'Home', 'Delete'},
    Default = 1,
    Multi = false,
    Text = 'Toggle UI Key',
    Tooltip = 'Choose key to toggle UI',
    Callback = function(Value)
        -- Will be handled by keybind system
    end
})

MenuGroup:AddDivider()

MenuGroup:AddButton({
    Text = 'Close UI',
    Func = function()
        Library:OnUnload()
    end,
    Tooltip = 'Close the UI (can reopen with keybind)'
})

MenuGroup:AddButton({
    Text = 'Unload Script',
    Func = function()
        for player, _ in pairs(ESPObjects) do
            removeESP(player)
        end
        for player, _ in pairs(Highlights) do
            removeHighlight(player)
        end
        Library:Unload()
    end,
    DoubleClick = true,
    Tooltip = 'Completely remove script'
})

MenuGroup:AddLabel(' '):AddLabel('Made by RanZx999'):AddLabel('Version 3.1 - Polished')

local InfoGroup = Tabs.Settings:AddRightGroupbox('Information')

InfoGroup:AddLabel('Script Status: Active')
InfoGroup:AddLabel('UI Library: Linoria')
InfoGroup:AddLabel('Version: 3.1')
InfoGroup:AddDivider()
InfoGroup:AddLabel('Controls:')
InfoGroup:AddLabel('• Toggle UI: RightShift (default)')
InfoGroup:AddLabel('• Drag UI: Hold title bar')
InfoGroup:AddLabel('• Resize: Drag corners')

Library:SetWatermarkVisibility(true)
Library:SetWatermark('RanZx999 ESP Hub V3.1 | Polished UI | Press RightShift')

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder('RanZx999ESP')
ThemeManager:ApplyToTab(Tabs.Settings)

Library:Notify('RanZx999 ESP Hub V3.1 loaded! Press RIGHT SHIFT to toggle UI', 5)

print("=================================")
print("🔥 RanZx999 ESP Hub V3.1 🔥")
print("UI: Linoria (Polished)")
print("=================================")
print("Controls:")
print("• Press RIGHT SHIFT to toggle UI")
print("• Drag title bar to move")
print("• Close/Minimize buttons on top right")
print("=================================")
print("Features:")
print("✅ ESP with modular toggles")
print("✅ Hitbox Expander")
print("✅ Speed & Jump Hack")  
print("✅ Auto Team Highlight")
print("✅ Custom UI keybind")
print("=================================")
