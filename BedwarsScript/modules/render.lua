-- ===================================
-- 👁️ RENDER MODULE
-- ===================================
-- Модуль визуальных функций для Bedwars
-- ===================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

print("👁️ Загружаем Render модуль...")

-- Хранилище ESP объектов
local ESPObjects = {}

-- Функция создания ESP для игрока
local function CreateESP(player)
    if ESPObjects[player] then return end
    if player == LocalPlayer then return end
    
    local espFolder = Instance.new("Folder")
    espFolder.Name = player.Name .. "_ESP"
    
    -- Box ESP
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(4, 5, 4)
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Transparency = 0.7
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Visible = false
    box.Parent = espFolder
    
    -- Name ESP
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = espFolder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = billboard
    
    ESPObjects[player] = {
        Folder = espFolder,
        Box = box,
        Billboard = billboard,
        NameLabel = nameLabel
    }
end

-- Функция удаления ESP
local function RemoveESP(player)
    if ESPObjects[player] then
        ESPObjects[player].Folder:Destroy()
        ESPObjects[player] = nil
    end
end

-- Функция обновления ESP
local function UpdateESP()
    for player, esp in pairs(ESPObjects) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            
            -- Обновляем Box
            esp.Box.Adornee = rootPart
            esp.Box.Visible = _G.BedwarsScript.Settings.ESP
            
            -- Обновляем Billboard
            esp.Billboard.Adornee = rootPart
            esp.Billboard.Enabled = _G.BedwarsScript.Settings.ESP
            
            -- Обновляем дистанцию
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
            esp.NameLabel.Text = player.Name .. "\n[" .. math.floor(distance) .. " studs]"
        else
            esp.Box.Visible = false
            esp.Billboard.Enabled = false
        end
    end
end

-- ESP Connection
local ESPConnection
local function ToggleESP(enabled)
    if enabled then
        -- Создаем ESP для всех игроков
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
        
        -- Следим за новыми игроками
        Players.PlayerAdded:Connect(function(player)
            CreateESP(player)
        end)
        
        Players.PlayerRemoving:Connect(function(player)
            RemoveESP(player)
        end)
        
        -- Обновляем ESP каждый кадр
        ESPConnection = RunService.RenderStepped:Connect(function()
            if _G.BedwarsScript.Settings.ESP then
                UpdateESP()
            end
        end)
    else
        -- Удаляем все ESP
        for player, _ in pairs(ESPObjects) do
            RemoveESP(player)
        end
        
        if ESPConnection then
            ESPConnection:Disconnect()
            ESPConnection = nil
        end
    end
end

-- Tracers
local TracersConnection
local TracersFolder = Instance.new("Folder")
TracersFolder.Name = "Tracers"
TracersFolder.Parent = Camera

local function UpdateTracers()
    -- Очищаем старые трейсеры
    TracersFolder:ClearAllChildren()
    
    if not _G.BedwarsScript.Settings.Tracers then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            
            local tracer = Instance.new("Part")
            tracer.Anchored = true
            tracer.CanCollide = false
            tracer.Size = Vector3.new(0.1, 0.1, (Camera.CFrame.Position - rootPart.Position).Magnitude)
            tracer.CFrame = CFrame.new(Camera.CFrame.Position, rootPart.Position) * CFrame.new(0, 0, -tracer.Size.Z / 2)
            tracer.Color = Color3.fromRGB(255, 0, 0)
            tracer.Material = Enum.Material.Neon
            tracer.Transparency = 0.5
            tracer.Parent = TracersFolder
        end
    end
end

local function ToggleTracers(enabled)
    if enabled then
        TracersConnection = RunService.RenderStepped:Connect(function()
            UpdateTracers()
        end)
    else
        TracersFolder:ClearAllChildren()
        if TracersConnection then
            TracersConnection:Disconnect()
            TracersConnection = nil
        end
    end
end

-- Chest ESP
local ChestESPObjects = {}
local function CreateChestESP()
    -- Ищем сундуки в игре
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name:lower():find("chest") and obj:IsA("Model") then
            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(0, 100, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 2, 0)
            billboard.AlwaysOnTop = true
            billboard.Adornee = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChildWhichIsA("BasePart")
            billboard.Parent = obj
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "Chest"
            label.TextColor3 = Color3.fromRGB(255, 255, 0)
            label.TextStrokeTransparency = 0
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.Parent = billboard
            
            table.insert(ChestESPObjects, billboard)
        end
    end
end

local function ToggleChestESP(enabled)
    if enabled then
        CreateChestESP()
    else
        for _, billboard in pairs(ChestESPObjects) do
            if billboard and billboard.Parent then
                billboard:Destroy()
            end
        end
        ChestESPObjects = {}
    end
end

-- Следим за изменениями настроек
local oldESP = _G.BedwarsScript.Settings.ESP
local oldTracers = _G.BedwarsScript.Settings.Tracers
local oldChestESP = _G.BedwarsScript.Settings.ChestESP

RunService.Heartbeat:Connect(function()
    -- ESP
    if _G.BedwarsScript.Settings.ESP ~= oldESP then
        oldESP = _G.BedwarsScript.Settings.ESP
        ToggleESP(oldESP)
    end
    
    -- Tracers
    if _G.BedwarsScript.Settings.Tracers ~= oldTracers then
        oldTracers = _G.BedwarsScript.Settings.Tracers
        ToggleTracers(oldTracers)
    end
    
    -- Chest ESP
    if _G.BedwarsScript.Settings.ChestESP ~= oldChestESP then
        oldChestESP = _G.BedwarsScript.Settings.ChestESP
        ToggleChestESP(oldChestESP)
    end
end)

print("✅ Render модуль загружен")
