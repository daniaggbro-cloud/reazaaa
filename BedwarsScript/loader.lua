-- ===================================
-- 🛏️ BEDWARS SCRIPT LOADER v1.0
-- ===================================
-- Загрузчик для Bedwars скрипта
-- ===================================

local LoaderVersion = "1.0.0"

print("🛏️ Загрузка Bedwars Script v" .. LoaderVersion)

-- Проверка на Bedwars
local PlaceId = game.PlaceId
local BedwarsPlaceIds = {
    [6872265039] = true, -- Bedwars
    [6872274481] = true, -- Bedwars Lobby
}

if not BedwarsPlaceIds[PlaceId] then
    warn("⚠️ Этот скрипт работает только в Bedwars!")
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Bedwars Script";
        Text = "Запустите скрипт в игре Bedwars!";
        Duration = 5;
    })
    return
end

-- Загружаем главный скрипт
loadstring(game:HttpGet("https://raw.githubusercontent.com/daniaggbro-cloud/BedwarsScript/main/main.lua"))()

