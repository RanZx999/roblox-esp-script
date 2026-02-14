--[[

Enhanced ESP Script
Modified by AI Assistant
Based on original by !vcsk0#1516

New Features:
- Advanced ESP Box with outlines
- Distance Indicator
- Health Bar Display
- Enhanced Name Tags
- Team Colors
- Customizable Colors

]]

local CoreGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local function isNumber(str)
  if tonumber(str) ~= nil or str == 'inf' then
    return true
  end
end

-- Hitbox Settings
getgenv().HitboxSize = 15
getgenv().HitboxTransparency = 0.9
getgenv().HitboxStatus = false
getgenv().TeamCheck = false

-- Player Settings
getgenv().Walkspeed = game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed
getgenv().Jumppower = game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower
getgenv().TPSpeed = 3
getgenv().TPWalk = false

-- ESP Settings
getgenv().ESPEnabled = false
getgenv().ESPBoxes = true
getgenv().ESPNames = true
getgenv().ESPDistance = true
getgenv().ESPHealth = true
getgenv().ESPTeamColor = true
getgenv().ESPBoxColor = Color3.fromRGB(255, 255, 255)
getgenv().ESPTextColor = Color3.fromRGB(255, 255, 255)
getgenv().MaxESPDistance = 1000

--// Enhanced ESP System
local ESPObjects = {}

local function createESP(player)
    if player == Players.LocalPlayer then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = "ESP_" .. player.Name
    espFolder.Parent = CoreGui
    
    -- Box Drawing
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = ESPBoxColor
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    
    -- Name Tag
    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Color = ESPTextColor
    nameTag.Size = 16
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameTag.Font = 2
    
    -- Distance Text
    local distanceTag = Drawing.new("Text")
    distanceTag.Visible = false
    distanceTag.Color = ESPTextColor
    distanceTag.Size = 14
    distanceTag.Center = true
    distanceTag.Outline = true
    distanceTag.OutlineColor = Color3.fromRGB(0, 0, 0)
    distanceTag.Font = 2
    
    -- Health Bar Background
    local healthBarBG = Drawing.new("Square")
    healthBarBG.Visible = false
    healthBarBG.Color = Color3.fromRGB(0, 0, 0)
    healthBarBG.Thickness = 1
    healthBarBG.Transparency = 0.5
    healthBarBG.Filled = true
    
    -- Health Bar
    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Thickness = 1
    healthBar.Transparency = 1
    healthBar.Filled = true
    
    -- Health Text
    local healthText = Drawing.new("Text")
    healthText.Visible = false
    healthText.Color = Color3.fromRGB(255, 255, 255)
    healthText.Size = 12
    healthText.Center = true
    healthText.Outline = true
    healthText.OutlineColor = Color3.fromRGB(0, 0, 0)
    healthText.Font = 2
    
    ESPObjects[player] = {
        Box = box,
        Name = nameTag,
        Distance = distanceTag,
        HealthBarBG = healthBarBG,
        HealthBar = healthBar,
        HealthText = healthText,
        Folder = espFolder
    }
end

local function removeESP(player)
    if ESPObjects[player] then
        ESPObjects[player].Box:Remove()
        ESPObjects[player].Name:Remove()
        ESPObjects[player].Distance:Remove()
        ESPObjects[player].HealthBarBG:Remove()
        ESPObjects[player].HealthBar:Remove()
        ESPObjects[player].HealthText:Remove()
        ESPObjects[player].Folder:Destroy()
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
            espData.HealthText.Visible = false
            continue
        end
        
        -- Team Check
        if TeamCheck and player.Team == Players.LocalPlayer.Team then
            espData.Box.Visible = false
            espData.Name.Visible = false
            espData.Distance.Visible = false
            espData.HealthBarBG.Visible = false
            espData.HealthBar.Visible = false
            espData.HealthText.Visible = false
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
            espData.HealthText.Visible = false
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
            espData.HealthText.Visible = false
            continue
        end
        
        -- Calculate Box Size
        local scaleFactor = 1 / (distance / 10)
        local boxSize = Vector2.new(2000 / distance, 2500 / distance)
        
        -- Set Box Color (Team Color or Custom)
        local boxColor = ESPBoxColor
        if ESPTeamColor and player.Team then
            boxColor = player.Team.TeamColor.Color
        end
        
        -- Update Box
        if ESPBoxes then
            espData.Box.Size = boxSize
            espData.Box.Position = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y - boxSize.Y / 2)
            espData.Box.Color = boxColor
            espData.Box.Visible = true
        else
            espData.Box.Visible = false
        end
        
        -- Update Name Tag
        if ESPNames then
            espData.Name.Text = player.Name
            espData.Name.Position = Vector2.new(headPos.X, headPos.Y - 30)
            espData.Name.Color = ESPTeamColor and player.Team and player.Team.TeamColor.Color or ESPTextColor
            espData.Name.Visible = true
        else
            espData.Name.Visible = false
        end
        
        -- Update Distance
        if ESPDistance then
            espData.Distance.Text = string.format("[%.0f studs]", distance)
            espData.Distance.Position = Vector2.new(headPos.X, headPos.Y - 45)
            espData.Distance.Color = ESPTextColor
            espData.Distance.Visible = true
        else
            espData.Distance.Visible = false
        end
        
        -- Update Health Bar
        if ESPHealth and humanoid then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local barWidth = boxSize.X
            local barHeight = 4
            
            -- Background
            espData.HealthBarBG.Size = Vector2.new(barWidth, barHeight)
            espData.HealthBarBG.Position = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y + boxSize.Y / 2 + 2)
            espData.HealthBarBG.Visible = true
            
            -- Health Bar (changes color based on health)
            local healthColor = Color3.fromRGB(
                math.floor(255 * (1 - healthPercent)),
                math.floor(255 * healthPercent),
                0
            )
            espData.HealthBar.Size = Vector2.new(barWidth * healthPercent, barHeight)
            espData.HealthBar.Position = Vector2.new(rootPos.X - boxSize.X / 2, rootPos.Y + boxSize.Y / 2 + 2)
            espData.HealthBar.Color = healthColor
            espData.HealthBar.Visible = true
            
            -- Health Text
            espData.HealthText.Text = string.format("%d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
            espData.HealthText.Position = Vector2.new(rootPos.X, rootPos.Y + boxSize.Y / 2 + 10)
            espData.HealthText.Visible = true
        else
            espData.HealthBarBG.Visible = false
            espData.HealthBar.Visible = false
            espData.HealthText.Visible = false
        end
    end
end

-- Player Added/Removed Events
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        createESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

--// UI Library

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/UI-Library/main/Source/MyUILib(Unamed).lua"))();
local Window = Library:Create("Enhanced ESP Hub")

local ToggleGui = Instance.new("ScreenGui")
local Toggle = Instance.new("TextButton")

ToggleGui.Name = "ToggleGui_HE"
ToggleGui.Parent = game.CoreGui

Toggle.Name = "Toggle"
Toggle.Parent = ToggleGui
Toggle.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Toggle.BackgroundTransparency = 0.660
Toggle.Position = UDim2.new(0, 0, 0.454706937, 0)
Toggle.Size = UDim2.new(0.0650164187, 0, 0.0888099447, 0)
Toggle.Font = Enum.Font.SourceSans
Toggle.Text = "Toggle"
Toggle.TextScaled = true
Toggle.TextColor3 = Color3.fromRGB(40, 40, 40)
Toggle.TextSize = 24.000
Toggle.TextXAlignment = Enum.TextXAlignment.Left
Toggle.Active = true
Toggle.Draggable = true
Toggle.MouseButton1Click:connect(function()
    Library:ToggleUI()
end)

local HomeTab = Window:Tab("Home","rbxassetid://10888331510")
local PlayerTab = Window:Tab("Players","rbxassetid://12296135476")
local VisualTab = Window:Tab("ESP Visuals","rbxassetid://12308581351")

HomeTab:InfoLabel("Enhanced ESP Hub v2.0")

HomeTab:Section("Hitbox Settings")

HomeTab:TextBox("Hitbox Size", function(value)
    getgenv().HitboxSize = value
end)

HomeTab:TextBox("Hitbox Transparency", function(number)
    getgenv().HitboxTransparency = number
end)

HomeTab:Section("Main")

HomeTab:Toggle("Hitbox Status", function(state)
	getgenv().HitboxStatus = state
    game:GetService('RunService').RenderStepped:connect(function()
		if HitboxStatus == true and TeamCheck == false then
			for i,v in next, game:GetService('Players'):GetPlayers() do
				if v.Name ~= game:GetService('Players').LocalPlayer.Name then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
						v.Character.HumanoidRootPart.Transparency = HitboxTransparency
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
						v.Character.HumanoidRootPart.Material = "Neon"
						v.Character.HumanoidRootPart.CanCollide = false
					end)
				end
			end
		elseif HitboxStatus == true and TeamCheck == true then
			for i,v in next, game:GetService('Players'):GetPlayers() do
				if game:GetService('Players').LocalPlayer.Team ~= v.Team then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
						v.Character.HumanoidRootPart.Transparency = HitboxTransparency
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really black")
						v.Character.HumanoidRootPart.Material = "Neon"
						v.Character.HumanoidRootPart.CanCollide = false
					end)
				end
			end
		else
		    for i,v in next, game:GetService('Players'):GetPlayers() do
				if v.Name ~= game:GetService('Players').LocalPlayer.Name then
					pcall(function()
						v.Character.HumanoidRootPart.Size = Vector3.new(2,2,1)
						v.Character.HumanoidRootPart.Transparency = 1
						v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Medium stone grey")
						v.Character.HumanoidRootPart.Material = "Plastic"
						v.Character.HumanoidRootPart.CanCollide = false
					end)
				end
			end
		end
	end)
end)

HomeTab:Toggle("Team Check", function(state)
    getgenv().TeamCheck = state
end)

HomeTab:Keybind("Toggle UI", Enum.KeyCode.F, function()
    Library:ToggleUI()
end)

-- Player Tab
PlayerTab:TextBox("WalkSpeed", function(value)
    getgenv().Walkspeed = value
    pcall(function()
        game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = value
    end)
end)

PlayerTab:Toggle("Loop WalkSpeed", function(state)
    getgenv().loopW = state
    game:GetService("RunService").Heartbeat:Connect(function()
        if loopW == true then
            pcall(function()
                game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = Walkspeed
            end)
        end
    end)
end)

PlayerTab:TextBox("JumpPower", function(value)
    getgenv().Jumppower = value
    pcall(function()
        game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = value
    end)
end)

PlayerTab:Toggle("Loop JumpPower", function(state)
    getgenv().loopJ = state
    game:GetService("RunService").Heartbeat:Connect(function()
        if loopJ == true then
            pcall(function()
                game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = Jumppower
            end)
        end
    end)
end)

PlayerTab:TextBox("TP Speed", function(value)
    getgenv().TPSpeed = value
end)

PlayerTab:Toggle("TP Walk", function(s)
    getgenv().TPWalk = s
    local hb = game:GetService("RunService").Heartbeat
    local player = game:GetService("Players")
    local lplr = player.LocalPlayer
    local chr = lplr.Character
    local hum = chr and chr:FindFirstChildWhichIsA("Humanoid")
    while getgenv().TPWalk and hb:Wait() and chr and hum and hum.Parent do
        if hum.MoveDirection.Magnitude > 0 then
            if getgenv().TPSpeed and isNumber(getgenv().TPSpeed) then
                chr:TranslateBy(hum.MoveDirection * tonumber(getgenv().TPSpeed))
            else
                chr:TranslateBy(hum.MoveDirection)
            end
        end
    end
end)

PlayerTab:Slider("FOV", game.Workspace.CurrentCamera.FieldOfView, 120, function(v)
    game.Workspace.CurrentCamera.FieldOfView = v
end)

PlayerTab:Toggle("Noclip", function(s)
    getgenv().Noclip = s
    game:GetService("RunService").Heartbeat:Connect(function()
        if Noclip == true then
            game:GetService("RunService").Stepped:wait()
            game.Players.LocalPlayer.Character.Head.CanCollide = false
            game.Players.LocalPlayer.Character.Torso.CanCollide = false
        end
    end)
end)

PlayerTab:Toggle("Infinite Jump", function(s)
    getgenv().InfJ = s
    game:GetService("UserInputService").JumpRequest:connect(function()
        if InfJ == true then
            game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
        end
    end)
end)

PlayerTab:Button("Rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end)

-- ESP Visual Tab
VisualTab:InfoLabel("Advanced ESP System")

VisualTab:Section("Main ESP")

VisualTab:Toggle("Enable ESP", function(state)
    getgenv().ESPEnabled = state
    
    if state then
        -- Create ESP for all existing players
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer then
                createESP(player)
            end
        end
        
        -- Start ESP Update Loop
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

VisualTab:Section("ESP Features")

VisualTab:Toggle("Show Boxes", function(state)
    getgenv().ESPBoxes = state
end)

VisualTab:Toggle("Show Names", function(state)
    getgenv().ESPNames = state
end)

VisualTab:Toggle("Show Distance", function(state)
    getgenv().ESPDistance = state
end)

VisualTab:Toggle("Show Health Bar", function(state)
    getgenv().ESPHealth = state
end)

VisualTab:Toggle("Use Team Colors", function(state)
    getgenv().ESPTeamColor = state
end)

VisualTab:Section("ESP Settings")

VisualTab:Slider("Max ESP Distance", 100, 5000, function(value)
    getgenv().MaxESPDistance = value
end)

VisualTab:InfoLabel("Note: ESP works best with Drawing API")

-- Old ESP Fallback
VisualTab:Section("Fallback ESP (Highlight)")

VisualTab:Toggle("Character Highlight", function(state)
    getgenv().enabled = state
    getgenv().filluseteamcolor = true
    getgenv().outlineuseteamcolor = true
    getgenv().fillcolor = Color3.new(0, 0, 0)
    getgenv().outlinecolor = Color3.new(1, 1, 1)
    getgenv().filltrans = 0.5
    getgenv().outlinetrans = 0.5

    loadstring(game:HttpGet("https://raw.githubusercontent.com/Vcsk/RobloxScripts/main/Highlight-ESP.lua"))()
end)

-- Game-Specific Features
if game.PlaceId == 3082002798 then
    local GamesTab = Window:Tab("Games","rbxassetid://15426471035")
	GamesTab:InfoLabel("Game: "..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
	GamesTab:Button("No Cooldown", function()
	    for i, v in pairs(game:GetService('ReplicatedStorage')['Shared_Modules'].Tools:GetDescendants()) do
		    if v:IsA('ModuleScript') then
			    local Module = require(v)
				Module.DEBOUNCE = 0
			end
		end
	end)
end

print("Enhanced ESP Script Loaded Successfully!")
print("Press F to toggle UI")
print("Features: Box ESP, Distance, Health Bar, Name Tags")
