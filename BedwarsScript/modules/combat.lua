-- ===================================
-- ⚔️ COMBAT MODULE
-- ===================================
-- Модуль боевых функций для Bedwars
-- ===================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

print("⚔️ Загружаем Combat модуль...")

-- Kill Aura
local KillAuraConnection
local function ToggleKillAura(enabled)
    if enabled then
        KillAuraConnection = RunService.Heartbeat:Connect(function()
            if not _G.BedwarsScript.Settings.KillAura then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local rootPart = character:FindFirstChild("HumanoidRootPart")
            if not rootPart then return end
            
            -- Ищем ближайшего врага
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    local enemyHumanoid = player.Character:FindFirstChild("Humanoid")
                    
                    if enemyRoot and enemyHumanoid and enemyHumanoid.Health > 0 then
                        local distance = (rootPart.Position - enemyRoot.Position).Magnitude
                        
                        if distance <= _G.BedwarsScript.Settings.KillAuraRange then
                            -- Атакуем
                            local args = {
                                [1] = {
                                    ["entityInstance"] = player.Character,
                                    ["validate"] = {
                                        ["raycast"] = {
                                            ["cameraPosition"] = rootPart.Position,
                                            ["cursorDirection"] = (enemyRoot.Position - rootPart.Position).Unit
                                        }
                                    }
                                }
                            }
                            
                            pcall(function()
                                ReplicatedStorage:FindFirstChild("rbxts_include"):FindFirstChild("node_modules"):FindFirstChild("@rbxts"):FindFirstChild("net"):FindFirstChild("out"):FindFirstChild("_NetManaged"):FindFirstChild("SwordHit"):FireServer(unpack(args))
                            end)
                        end
                    end
                end
            end
        end)
    else
        if KillAuraConnection then
            KillAuraConnection:Disconnect()
            KillAuraConnection = nil
        end
    end
end

-- Auto Clicker
local AutoClickerConnection
local function ToggleAutoClicker(enabled)
    if enabled then
        AutoClickerConnection = RunService.Heartbeat:Connect(function()
            if not _G.BedwarsScript.Settings.AutoClicker then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            -- Кликаем
            pcall(function()
                local tool = character:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end)
        end)
    else
        if AutoClickerConnection then
            AutoClickerConnection:Disconnect()
            AutoClickerConnection = nil
        end
    end
end

-- Следим за изменениями настроек
local oldKillAura = _G.BedwarsScript.Settings.KillAura
local oldAutoClicker = _G.BedwarsScript.Settings.AutoClicker

RunService.Heartbeat:Connect(function()
    -- Kill Aura
    if _G.BedwarsScript.Settings.KillAura ~= oldKillAura then
        oldKillAura = _G.BedwarsScript.Settings.KillAura
        ToggleKillAura(oldKillAura)
    end
    
    -- Auto Clicker
    if _G.BedwarsScript.Settings.AutoClicker ~= oldAutoClicker then
        oldAutoClicker = _G.BedwarsScript.Settings.AutoClicker
        ToggleAutoClicker(oldAutoClicker)
    end
end)

print("✅ Combat модуль загружен")
