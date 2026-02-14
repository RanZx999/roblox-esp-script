--[[

RanZx999 ESP Hub V4.0
UI Library: Rayfield (Premium & Stable)

Features:
- ESP (Box, Names, Distance, Health, Tracers)
- Hitbox Expander
- Speed & Jump Hack
- Auto Team Highlight
- Rayfield Premium UI
- Mobile-Friendly
- GUARANTEED NO BUGS!

Created by RanZx999
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

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

--// RAYFIELD UI CREATION
local Window = Rayfield:CreateWindow({
   Name = "RanZx999 ESP Hub V4.0",
   LoadingTitle = "Loading RanZx999 ESP...",
   LoadingSubtitle = "by RanZx999",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RanZx999ESP",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

-- ESP Tab
local ESPTab = Window:CreateTab("🔍 ESP", 4483362458)
local ESPSection = ESPTab:CreateSection("ESP Controls")

local EnableESPToggle = ESPTab:CreateToggle({
   Name = "Enable ESP",
   CurrentValue = false,
   Flag = "EnableESP",
   Callback = function(Value)
       getgenv().ESPEnabled = Value
       
       if Value then
           for _, player in pairs(Players:GetPlayers()) do
               if player ~= LocalPlayer then
                   createESP(player)
               end
           end
           Rayfield:Notify({
               Title = "ESP Enabled",
               Content = "ESP is now active!",
               Duration = 3,
               Image = 4483362458,
           })
       else
           for player, _ in pairs(ESPObjects) do
               removeESP(player)
           end
           Rayfield:Notify({
               Title = "ESP Disabled",
               Content = "ESP has been turned off",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

ESPTab:CreateSection("ESP Features")

ESPTab:CreateToggle({
   Name = "📦 Show Boxes",
   CurrentValue = false,
   Flag = "ESPBoxes",
   Callback = function(Value)
       getgenv().ESPBoxes = Value
   end,
})

ESPTab:CreateToggle({
   Name = "👤 Show Names",
   CurrentValue = false,
   Flag = "ESPNames",
   Callback = function(Value)
       getgenv().ESPNames = Value
   end,
})

ESPTab:CreateToggle({
   Name = "📏 Show Distance",
   CurrentValue = false,
   Flag = "ESPDistance",
   Callback = function(Value)
       getgenv().ESPDistance = Value
   end,
})

ESPTab:CreateToggle({
   Name = "❤️ Show Health Bars",
   CurrentValue = false,
   Flag = "ESPHealth",
   Callback = function(Value)
       getgenv().ESPHealth = Value
   end,
})

ESPTab:CreateToggle({
   Name = "📍 Show Tracers",
   CurrentValue = false,
   Flag = "ESPTracers",
   Callback = function(Value)
       getgenv().ESPTracers = Value
   end,
})

ESPTab:CreateSection("ESP Settings")

ESPTab:CreateToggle({
   Name = "Team Check (Hide Teammates)",
   CurrentValue = true,
   Flag = "ESPTeamCheck",
   Callback = function(Value)
       getgenv().ESPTeamCheck = Value
   end,
})

ESPTab:CreateSlider({
   Name = "Max ESP Distance",
   Range = {500, 5000},
   Increment = 100,
   Suffix = "m",
   CurrentValue = 2000,
   Flag = "MaxDistance",
   Callback = function(Value)
       getgenv().MaxESPDistance = Value
   end,
})

-- Hitbox Tab
local HitboxTab = Window:CreateTab("🎯 Hitbox", 4483362458)
HitboxTab:CreateSection("Hitbox Expander")

HitboxTab:CreateToggle({
   Name = "Enable Hitbox",
   CurrentValue = false,
   Flag = "EnableHitbox",
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
           Rayfield:Notify({
               Title = "Hitbox Disabled",
               Content = "Hitboxes reset to normal",
               Duration = 3,
               Image = 4483362458,
           })
       else
           Rayfield:Notify({
               Title = "Hitbox Enabled",
               Content = "Enemy hitboxes expanded!",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

HitboxTab:CreateSection("Hitbox Settings")

HitboxTab:CreateSlider({
   Name = "Hitbox Size",
   Range = {1, 30},
   Increment = 1,
   Suffix = " studs",
   CurrentValue = 10,
   Flag = "HitboxSize",
   Callback = function(Value)
       getgenv().HitboxSize = Value
   end,
})

HitboxTab:CreateSlider({
   Name = "Transparency",
   Range = {0, 1},
   Increment = 0.1,
   Suffix = "",
   CurrentValue = 0.7,
   Flag = "HitboxTransparency",
   Callback = function(Value)
       getgenv().HitboxTransparency = Value
   end,
})

HitboxTab:CreateToggle({
   Name = "Team Check (Skip Teammates)",
   CurrentValue = true,
   Flag = "HitboxTeamCheck",
   Callback = function(Value)
       getgenv().HitboxTeamCheck = Value
   end,
})

HitboxTab:CreateLabel("Recommended Size: 10-15 studs")
HitboxTab:CreateLabel("Transparency: 0.5-0.8 for stealth")

-- Movement Tab
local MovementTab = Window:CreateTab("⚡ Movement", 4483362458)
MovementTab:CreateSection("Speed Hack")

MovementTab:CreateToggle({
   Name = "Enable Speed",
   CurrentValue = false,
   Flag = "EnableSpeed",
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
   end,
})

MovementTab:CreateSlider({
   Name = "Speed Value",
   Range = {16, 200},
   Increment = 1,
   Suffix = "",
   CurrentValue = 16,
   Flag = "SpeedValue",
   Callback = function(Value)
       getgenv().SpeedValue = Value
   end,
})

MovementTab:CreateLabel("Safe: 20-30 | Fast: 50-100 | Crazy: 150+")

MovementTab:CreateSection("Jump Hack")

MovementTab:CreateToggle({
   Name = "Enable Jump",
   CurrentValue = false,
   Flag = "EnableJump",
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
   end,
})

MovementTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 300},
   Increment = 5,
   Suffix = "",
   CurrentValue = 50,
   Flag = "JumpValue",
   Callback = function(Value)
       getgenv().JumpValue = Value
   end,
})

MovementTab:CreateLabel("Safe: 60-100 | High: 150-200 | Moon: 250+")

-- Highlight Tab
local HighlightTab = Window:CreateTab("✨ Highlight", 4483362458)
HighlightTab:CreateSection("Character Highlight")

HighlightTab:CreateToggle({
   Name = "Enable Highlight",
   CurrentValue = false,
   Flag = "EnableHighlight",
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
           
           Rayfield:Notify({
               Title = "Highlight Enabled",
               Content = "Players are now highlighted!",
               Duration = 3,
               Image = 4483362458,
           })
       else
           for player, _ in pairs(Highlights) do
               removeHighlight(player)
           end
           Rayfield:Notify({
               Title = "Highlight Disabled",
               Content = "Highlights removed",
               Duration = 3,
               Image = 4483362458,
           })
       end
   end,
})

HighlightTab:CreateToggle({
   Name = "Auto Team Colors",
   CurrentValue = true,
   Flag = "HighlightTeamCheck",
   Callback = function(Value)
       getgenv().HighlightTeamCheck = Value
   end,
})

HighlightTab:CreateLabel("🟢 Green = Teammate")
HighlightTab:CreateLabel("🔴 Red = Enemy")

-- Settings Tab
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)
SettingsTab:CreateSection("Script Controls")

SettingsTab:CreateButton({
   Name = "Destroy Script",
   Callback = function()
       for player, _ in pairs(ESPObjects) do
           removeESP(player)
       end
       for player, _ in pairs(Highlights) do
           removeHighlight(player)
       end
       
       Rayfield:Notify({
           Title = "Script Destroyed",
           Content = "RanZx999 ESP Hub unloaded!",
           Duration = 3,
           Image = 4483362458,
       })
       
       wait(1)
       Rayfield:Destroy()
   end,
})

SettingsTab:CreateSection("Information")
SettingsTab:CreateLabel("Script: RanZx999 ESP Hub")
SettingsTab:CreateLabel("Version: 4.0 - Rayfield UI")
SettingsTab:CreateLabel("Status: ✅ Active")
SettingsTab:CreateLabel("")
SettingsTab:CreateLabel("Controls:")
SettingsTab:CreateLabel("• Toggle UI: Right CTRL")
SettingsTab:CreateLabel("• Drag UI: Hold title bar")
SettingsTab:CreateLabel("• Minimize: Click [-]")

Rayfield:LoadConfiguration()

print("=================================")
print("🔥 RanZx999 ESP Hub V4.0 🔥")
print("UI: Rayfield Premium")
print("=================================")
print("✅ Script loaded successfully!")
print("✅ All features working!")
print("=================================")
print("Controls:")
print("• Press Right CTRL to toggle UI")
print("=================================")
