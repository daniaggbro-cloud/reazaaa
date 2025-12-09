-- ===================================
-- 🛏️ BEDWARS SCRIPT STANDALONE v1.0
-- ===================================
-- Все в одном файле для быстрого запуска
-- Просто скопируйте и вставьте в Executor
-- ===================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Проверка на Bedwars
local PlaceId = game.PlaceId
if PlaceId ~= 6872265039 and PlaceId ~= 6872274481 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Bedwars Script";
        Text = "Этот скрипт работает только в Bedwars!";
        Duration = 5;
    })
    return
end

-- Настройки
local Settings = {
    KillAura = false,
    AutoClicker = false,
    Speed = false,
    Fly = false,
    ESP = false,
    
    KillAuraRange = 20,
    SpeedValue = 23,
}

-- Удаляем старое GUI
if CoreGui:FindFirstChild("BedwarsGUI") then
    CoreGui:FindFirstChild("BedwarsGUI"):Destroy()
end

print("🛏️ Загружаем Bedwars Script...")

-- Цвета
local Colors = {
    Background = Color3.fromRGB(20, 20, 25),
    Surface = Color3.fromRGB(30, 30, 35),
    Primary = Color3.fromRGB(88, 101, 242),
    Success = Color3.fromRGB(67, 181, 129),
    Danger = Color3.fromRGB(240, 71, 71),
    Text = Color3.fromRGB(255, 255, 255),
}

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BedwarsGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 350)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Заголовок
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Colors.Surface
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "🛏️ BEDWARS SCRIPT v1.0"
Title.TextColor3 = Colors.Text
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -45, 0, 7.5)
CloseButton.BackgroundColor3 = Colors.Danger
CloseButton.BorderSizePixel = 0
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Colors.Text
CloseButton.TextSize = 16
CloseButton.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Контент
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -70)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Padding = UDim.new(0, 8)
ListLayout.Parent = Content

-- Функция создания переключателя
local function CreateToggle(name, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, -10, 0, 35)
    Toggle.BackgroundColor3 = Colors.Surface
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Content
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Font = Enum.Font.Gotham
    Label.Text = name
    Label.TextColor3 = Colors.Text
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Toggle
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 45, 0, 20)
    Button.Position = UDim2.new(1, -52, 0.5, -10)
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    Button.BorderSizePixel = 0
    Button.Text = ""
    Button.Parent = Toggle
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(1, 0)
    BtnCorner.Parent = Button
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Colors.Text
    Circle.BorderSizePixel = 0
    Circle.Parent = Button
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local enabled = false
    
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Colors.Success or Color3.fromRGB(60, 60, 65)
        }):Play()
        
        TweenService:Create(Circle, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        if callback then callback(enabled) end
    end)
end

-- Создаем переключатели
CreateToggle("⚔️ Kill Aura", function(enabled)
    Settings.KillAura = enabled
end)

CreateToggle("🖱️ Auto Clicker", function(enabled)
    Settings.AutoClicker = enabled
end)

CreateToggle("⚡ Speed", function(enabled)
    Settings.Speed = enabled
end)

CreateToggle("🕊️ Fly", function(enabled)
    Settings.Fly = enabled
end)

CreateToggle("👁️ ESP", function(enabled)
    Settings.ESP = enabled
end)

-- Перетаскивание
local dragging, dragInput, dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Горячая клавиша
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Kill Aura
RunService.Heartbeat:Connect(function()
    if Settings.KillAura then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if enemyRoot then
                        local distance = (char.HumanoidRootPart.Position - enemyRoot.Position).Magnitude
                        if distance <= Settings.KillAuraRange then
                            pcall(function()
                                local tool = char:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                            end)
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Clicker
RunService.Heartbeat:Connect(function()
    if Settings.AutoClicker then
        local char = LocalPlayer.Character
        if char then
            pcall(function()
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end)
        end
    end
end)

-- Speed
RunService.Heartbeat:Connect(function()
    if Settings.Speed then
        local char = LocalPlayer.Character
        if char then
            local humanoid = char:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Settings.SpeedValue
            end
        end
    end
end)

-- Fly (простая версия)
local flying = false
local flyVelocity, flyGyro

RunService.Heartbeat:Connect(function()
    if Settings.Fly and not flying then
        flying = true
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            
            flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            flyVelocity.Parent = root
        end
    elseif not Settings.Fly and flying then
        flying = false
        if flyVelocity then flyVelocity:Destroy() end
        if flyGyro then flyGyro:Destroy() end
    end
    
    if flying and flyVelocity then
        local moveDir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        flyVelocity.Velocity = moveDir * 50
    end
end)

print("✅ Bedwars Script загружен!")
print("📱 Нажмите RightShift для открытия меню")

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Bedwars Script";
    Text = "Загружен! Нажмите RightShift";
    Duration = 5;
})
