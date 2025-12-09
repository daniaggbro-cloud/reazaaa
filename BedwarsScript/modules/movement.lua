-- ===================================
-- 🏃 MOVEMENT MODULE
-- ===================================
-- Модуль функций движения для Bedwars
-- ===================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

print("🏃 Загружаем Movement модуль...")

-- Speed
local SpeedConnection
local function ToggleSpeed(enabled)
    if enabled then
        SpeedConnection = RunService.Heartbeat:Connect(function()
            if not _G.BedwarsScript.Settings.Speed then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = _G.BedwarsScript.Settings.SpeedValue
            end
        end)
    else
        if SpeedConnection then
            SpeedConnection:Disconnect()
            SpeedConnection = nil
        end
        
        -- Восстанавливаем нормальную скорость
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
    end
end

-- Fly
local FlyConnection
local flying = false
local flySpeed = 50
local function ToggleFly(enabled)
    if enabled then
        flying = true
        
        local character = LocalPlayer.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = rootPart
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 9e4
        bodyGyro.Parent = rootPart
        
        FlyConnection = RunService.Heartbeat:Connect(function()
            if not _G.BedwarsScript.Settings.Fly or not flying then
                bodyVelocity:Destroy()
                bodyGyro:Destroy()
                return
            end
            
            local camera = workspace.CurrentCamera
            local moveDirection = Vector3.new(0, 0, 0)
            
            -- Управление полетом
            local userInput = game:GetService("UserInputService")
            if userInput:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + camera.CFrame.LookVector
            end
            if userInput:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - camera.CFrame.LookVector
            end
            if userInput:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - camera.CFrame.RightVector
            end
            if userInput:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + camera.CFrame.RightVector
            end
            if userInput:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            bodyVelocity.Velocity = moveDirection * flySpeed
            bodyGyro.CFrame = camera.CFrame
        end)
    else
        flying = false
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
    end
end

-- No Fall Damage
local NoFallConnection
local function ToggleNoFall(enabled)
    if enabled then
        NoFallConnection = RunService.Heartbeat:Connect(function()
            if not _G.BedwarsScript.Settings.NoFall then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                -- Предотвращаем урон от падения
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            end
        end)
    else
        if NoFallConnection then
            NoFallConnection:Disconnect()
            NoFallConnection = nil
        end
    end
end

-- Следим за изменениями настроек
local oldSpeed = _G.BedwarsScript.Settings.Speed
local oldFly = _G.BedwarsScript.Settings.Fly
local oldNoFall = _G.BedwarsScript.Settings.NoFall

RunService.Heartbeat:Connect(function()
    -- Speed
    if _G.BedwarsScript.Settings.Speed ~= oldSpeed then
        oldSpeed = _G.BedwarsScript.Settings.Speed
        ToggleSpeed(oldSpeed)
    end
    
    -- Fly
    if _G.BedwarsScript.Settings.Fly ~= oldFly then
        oldFly = _G.BedwarsScript.Settings.Fly
        ToggleFly(oldFly)
    end
    
    -- No Fall
    if _G.BedwarsScript.Settings.NoFall ~= oldNoFall then
        oldNoFall = _G.BedwarsScript.Settings.NoFall
        ToggleNoFall(oldNoFall)
    end
end)

print("✅ Movement модуль загружен")
