-- ===================================
-- 🔧 UTILITY MODULE
-- ===================================
-- Модуль утилит для Bedwars
-- ===================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

print("🔧 Загружаем Utility модуль...")

-- Chest Stealer
local ChestStealerConnection
local function ToggleChestStealer(enabled)
    if enabled then
        ChestStealerConnection = RunService.Heartbeat:Connect(function()
            if not _G.BedwarsScript.Settings.ChestStealer then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            -- Ищем открытые сундуки и забираем предметы
            pcall(function()
                local inventory = LocalPlayer.PlayerGui:FindFirstChild("InventoryGui")
                if inventory and inventory.Enabled then
                    -- Логика кражи из сундука
                    -- Здесь будет специфичная логика для Bedwars
                end
            end)
        end)
    else
        if ChestStealerConnection then
            ChestStealerConnection:Disconnect()
            ChestStealerConnection = nil
        end
    end
end

-- Auto Buy
local AutoBuyConnection
local function ToggleAutoBuy(enabled)
    if enabled then
        AutoBuyConnection = RunService.Heartbeat:Connect(function()
            if not _G.BedwarsScript.Settings.AutoBuy then return end
            
            -- Логика автопокупки
            -- Здесь будет специфичная логика для Bedwars магазинов
        end)
    else
        if AutoBuyConnection then
            AutoBuyConnection:Disconnect()
            AutoBuyConnection = nil
        end
    end
end

-- Scaffold (автоматическая постройка блоков под собой)
local ScaffoldConnection
local function ToggleScaffold(enabled)
    if enabled then
        ScaffoldConnection = RunService.Heartbeat:Connect(function()
            if not _G.BedwarsScript.Settings.Scaffold then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            -- Проверяем есть ли блоки под ногами
            local rayOrigin = rootPart.Position
            local rayDirection = Vector3.new(0, -5, 0)
            
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            
            local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            
            if not rayResult then
                -- Нет блока под ногами, пытаемся поставить
                pcall(function()
                    -- Логика размещения блока
                    -- Специфична для Bedwars
                end)
            end
        end)
    else
        if ScaffoldConnection then
            ScaffoldConnection:Disconnect()
            ScaffoldConnection = nil
        end
    end
end

-- Auto Break (автоматическая ломка кроватей)
local AutoBreakConnection
local function ToggleAutoBreak(enabled)
    if enabled then
        AutoBreakConnection = RunService.Heartbeat:Connect(function()
            if not _G.BedwarsScript.Settings.AutoBreak then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            -- Ищем ближайшую вражескую кровать
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("bed") and obj:IsA("Model") then
                    local bedPart = obj:FindFirstChildWhichIsA("BasePart")
                    if bedPart then
                        local distance = (rootPart.Position - bedPart.Position).Magnitude
                        
                        if distance <= 20 then
                            -- Пытаемся сломать кровать
                            pcall(function()
                                local tool = character:FindFirstChildOfClass("Tool")
                                if tool then
                                    tool:Activate()
                                end
                            end)
                        end
                    end
                end
            end
        end)
    else
        if AutoBreakConnection then
            AutoBreakConnection:Disconnect()
            AutoBreakConnection = nil
        end
    end
end

-- Следим за изменениями настроек
local oldChestStealer = _G.BedwarsScript.Settings.ChestStealer
local oldAutoBuy = _G.BedwarsScript.Settings.AutoBuy
local oldScaffold = _G.BedwarsScript.Settings.Scaffold
local oldAutoBreak = _G.BedwarsScript.Settings.AutoBreak

RunService.Heartbeat:Connect(function()
    -- Chest Stealer
    if _G.BedwarsScript.Settings.ChestStealer ~= oldChestStealer then
        oldChestStealer = _G.BedwarsScript.Settings.ChestStealer
        ToggleChestStealer(oldChestStealer)
    end
    
    -- Auto Buy
    if _G.BedwarsScript.Settings.AutoBuy ~= oldAutoBuy then
        oldAutoBuy = _G.BedwarsScript.Settings.AutoBuy
        ToggleAutoBuy(oldAutoBuy)
    end
    
    -- Scaffold
    if _G.BedwarsScript.Settings.Scaffold ~= oldScaffold then
        oldScaffold = _G.BedwarsScript.Settings.Scaffold
        ToggleScaffold(oldScaffold)
    end
    
    -- Auto Break
    if _G.BedwarsScript.Settings.AutoBreak ~= oldAutoBreak then
        oldAutoBreak = _G.BedwarsScript.Settings.AutoBreak
        ToggleAutoBreak(oldAutoBreak)
    end
end)

print("✅ Utility модуль загружен")
