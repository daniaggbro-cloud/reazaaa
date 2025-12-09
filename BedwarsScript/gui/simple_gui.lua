-- ===================================
-- 🎨 BEDWARS SIMPLE GUI
-- ===================================
-- Простой и красивый интерфейс
-- ===================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Удаляем старое GUI если есть
if CoreGui:FindFirstChild("BedwarsGUI") then
    CoreGui:FindFirstChild("BedwarsGUI"):Destroy()
end

-- Цветовая схема
local Colors = {
    Background = Color3.fromRGB(20, 20, 25),
    Surface = Color3.fromRGB(30, 30, 35),
    Primary = Color3.fromRGB(88, 101, 242), -- Discord Blue
    PrimaryHover = Color3.fromRGB(108, 121, 255),
    Success = Color3.fromRGB(67, 181, 129),
    Danger = Color3.fromRGB(240, 71, 71),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 190),
}

-- Создаем главное GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BedwarsGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Главная рамка
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Заголовок
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Colors.Surface
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Заголовок текст
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "🛏️ BEDWARS SCRIPT"
Title.TextColor3 = Colors.Text
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Кнопка закрытия
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

-- Контейнер для вкладок
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 120, 1, -60)
TabContainer.Position = UDim2.new(0, 10, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

-- Контейнер для содержимого
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -140, 1, -70)
ContentContainer.Position = UDim2.new(0, 130, 0, 60)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Функция создания вкладки
local CurrentTab = nil
local function CreateTab(name, icon, order)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Position = UDim2.new(0, 0, 0, (order - 1) * 45)
    TabButton.BackgroundColor3 = Colors.Surface
    TabButton.BorderSizePixel = 0
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = icon .. " " .. name
    TabButton.TextColor3 = Colors.TextSecondary
    TabButton.TextSize = 13
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.TextXOffset = 10
    TabButton.Parent = TabContainer
    
    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 8)
    TabCorner.Parent = TabButton
    
    -- Контент вкладки
    local TabContent = Instance.new("ScrollingFrame")
    TabContent.Name = name .. "Content"
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.Position = UDim2.new(0, 0, 0, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.BorderSizePixel = 0
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Colors.Primary
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.Parent = ContentContainer
    
    -- UIListLayout для автоматического размещения
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 8)
    ListLayout.Parent = TabContent
    
    -- Обновляем CanvasSize при изменении
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Обработка клика
    TabButton.MouseButton1Click:Connect(function()
        -- Скрываем все вкладки
        for _, child in pairs(ContentContainer:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = false
            end
        end
        
        -- Сбрасываем цвета всех кнопок
        for _, child in pairs(TabContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Colors.Surface
                child.TextColor3 = Colors.TextSecondary
            end
        end
        
        -- Показываем выбранную вкладку
        TabContent.Visible = true
        TabButton.BackgroundColor3 = Colors.Primary
        TabButton.TextColor3 = Colors.Text
        CurrentTab = TabContent
    end)
    
    -- Эффект наведения
    TabButton.MouseEnter:Connect(function()
        if CurrentTab ~= TabContent then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            }):Play()
        end
    end)
    
    TabButton.MouseLeave:Connect(function()
        if CurrentTab ~= TabContent then
            TweenService:Create(TabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Colors.Surface
            }):Play()
        end
    end)
    
    return TabContent
end

-- Функция создания переключателя
local function CreateToggle(parent, text, defaultValue, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = text .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, -10, 0, 35)
    ToggleFrame.BackgroundColor3 = Colors.Surface
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Colors.Text
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 45, 0, 20)
    ToggleButton.Position = UDim2.new(1, -52, 0.5, -10)
    ToggleButton.BackgroundColor3 = defaultValue and Colors.Success or Color3.fromRGB(60, 60, 65)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
    ToggleBtnCorner.Parent = ToggleButton
    
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Size = UDim2.new(0, 16, 0, 16)
    ToggleCircle.Position = defaultValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    ToggleCircle.BackgroundColor3 = Colors.Text
    ToggleCircle.BorderSizePixel = 0
    ToggleCircle.Parent = ToggleButton
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = ToggleCircle
    
    local enabled = defaultValue
    
    ToggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and Colors.Success or Color3.fromRGB(60, 60, 65)
        }):Play()
        
        TweenService:Create(ToggleCircle, TweenInfo.new(0.2), {
            Position = enabled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }):Play()
        
        if callback then
            callback(enabled)
        end
    end)
    
    return ToggleFrame
end

-- Создаем вкладки
local CombatTab = CreateTab("Combat", "⚔️", 1)
local MovementTab = CreateTab("Movement", "🏃", 2)
local RenderTab = CreateTab("Render", "👁️", 3)
local UtilityTab = CreateTab("Utility", "🔧", 4)

-- Заполняем вкладку Combat
CreateToggle(CombatTab, "Kill Aura", false, function(enabled)
    _G.BedwarsScript.Settings.KillAura = enabled
    print("Kill Aura: " .. tostring(enabled))
end)

CreateToggle(CombatTab, "Auto Clicker", false, function(enabled)
    _G.BedwarsScript.Settings.AutoClicker = enabled
    print("Auto Clicker: " .. tostring(enabled))
end)

CreateToggle(CombatTab, "Reach", false, function(enabled)
    _G.BedwarsScript.Settings.Reach = enabled
    print("Reach: " .. tostring(enabled))
end)

CreateToggle(CombatTab, "Velocity", false, function(enabled)
    _G.BedwarsScript.Settings.Velocity = enabled
    print("Velocity: " .. tostring(enabled))
end)

-- Заполняем вкладку Movement
CreateToggle(MovementTab, "Speed", false, function(enabled)
    _G.BedwarsScript.Settings.Speed = enabled
    print("Speed: " .. tostring(enabled))
end)

CreateToggle(MovementTab, "Sprint", false, function(enabled)
    _G.BedwarsScript.Settings.Sprint = enabled
    print("Sprint: " .. tostring(enabled))
end)

CreateToggle(MovementTab, "Fly", false, function(enabled)
    _G.BedwarsScript.Settings.Fly = enabled
    print("Fly: " .. tostring(enabled))
end)

CreateToggle(MovementTab, "No Fall", false, function(enabled)
    _G.BedwarsScript.Settings.NoFall = enabled
    print("No Fall: " .. tostring(enabled))
end)

-- Заполняем вкладку Render
CreateToggle(RenderTab, "ESP", false, function(enabled)
    _G.BedwarsScript.Settings.ESP = enabled
    print("ESP: " .. tostring(enabled))
end)

CreateToggle(RenderTab, "Tracers", false, function(enabled)
    _G.BedwarsScript.Settings.Tracers = enabled
    print("Tracers: " .. tostring(enabled))
end)

CreateToggle(RenderTab, "Chest ESP", false, function(enabled)
    _G.BedwarsScript.Settings.ChestESP = enabled
    print("Chest ESP: " .. tostring(enabled))
end)

CreateToggle(RenderTab, "Bed ESP", false, function(enabled)
    _G.BedwarsScript.Settings.BedESP = enabled
    print("Bed ESP: " .. tostring(enabled))
end)

-- Заполняем вкладку Utility
CreateToggle(UtilityTab, "Auto Buy", false, function(enabled)
    _G.BedwarsScript.Settings.AutoBuy = enabled
    print("Auto Buy: " .. tostring(enabled))
end)

CreateToggle(UtilityTab, "Chest Stealer", false, function(enabled)
    _G.BedwarsScript.Settings.ChestStealer = enabled
    print("Chest Stealer: " .. tostring(enabled))
end)

CreateToggle(UtilityTab, "Scaffold", false, function(enabled)
    _G.BedwarsScript.Settings.Scaffold = enabled
    print("Scaffold: " .. tostring(enabled))
end)

CreateToggle(UtilityTab, "Auto Break", false, function(enabled)
    _G.BedwarsScript.Settings.AutoBreak = enabled
    print("Auto Break: " .. tostring(enabled))
end)

-- Показываем первую вкладку по умолчанию
CombatTab.Parent:FindFirstChild("CombatTab").BackgroundColor3 = Colors.Primary
CombatTab.Parent:FindFirstChild("CombatTab").TextColor3 = Colors.Text
CombatTab.Visible = true
CurrentTab = CombatTab

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

print("✅ GUI загружен успешно!")
_G.BedwarsScript.GUI = ScreenGui
