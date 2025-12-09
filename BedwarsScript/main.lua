-- ===================================
-- 🛏️ BEDWARS SCRIPT MAIN v1.0
-- ===================================
-- Главный файл скрипта для Bedwars
-- ===================================

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Глобальные переменные
_G.BedwarsScript = _G.BedwarsScript or {
    Version = "1.0.0",
    Loaded = false,
    Settings = {},
    Modules = {},
    GUI = nil
}

-- Проверка на повторную загрузку
if _G.BedwarsScript.Loaded then
    warn("⚠️ Bedwars Script уже загружен!")
    return
end

print("🛏️ Загружаем Bedwars Script v" .. _G.BedwarsScript.Version)

-- Настройки по умолчанию
_G.BedwarsScript.Settings = {
    -- Combat
    KillAura = false,
    AutoClicker = false,
    Reach = false,
    Velocity = false,
    
    -- Movement
    Speed = false,
    Sprint = false,
    Fly = false,
    NoFall = false,
    
    -- Render
    ESP = false,
    Tracers = false,
    ChestESP = false,
    BedESP = false,
    
    -- Utility
    AutoBuy = false,
    ChestStealer = false,
    Scaffold = false,
    AutoBreak = false,
    
    -- Настройки
    KillAuraRange = 20,
    SpeedValue = 23,
    ReachValue = 18,
}

-- Загружаем GUI
print("📱 Загружаем интерфейс...")
local GuiSuccess, GuiError = pcall(function()
    loadfile("BedwarsScript/gui/simple_gui.lua")()
end)

if not GuiSuccess then
    warn("❌ Ошибка загрузки GUI: " .. tostring(GuiError))
end

-- Загружаем модули
print("⚙️ Загружаем модули...")
local ModulesSuccess, ModulesError = pcall(function()
    -- Загружаем модули боя
    loadfile("BedwarsScript/modules/combat.lua")()
    
    -- Загружаем модули движения
    loadfile("BedwarsScript/modules/movement.lua")()
    
    -- Загружаем модули рендера
    loadfile("BedwarsScript/modules/render.lua")()
    
    -- Загружаем утилиты
    loadfile("BedwarsScript/modules/utility.lua")()
end)

if not ModulesSuccess then
    warn("❌ Ошибка загрузки модулей: " .. tostring(ModulesError))
end

_G.BedwarsScript.Loaded = true
print("✅ Bedwars Script v" .. _G.BedwarsScript.Version .. " успешно загружен!")
print("📱 Нажмите RightShift для открытия меню")

-- Уведомление
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Bedwars Script";
    Text = "Загружен! Нажмите RightShift";
    Duration = 5;
})
