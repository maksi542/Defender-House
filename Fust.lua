-- ==========================================
-- == CREATOR SMOKExR'S | FUST SURVIVAL (STEALTH) ==
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local MAX_PLAYERS = 20 
local MAX_OBJECTS = 40 

local Config = {
    Enabled = true, 
    ShowPlayerBox = true, 
    ShowPlayerName = true, 
    ShowPlayerHealth = true,
    ShowResources = true, 
    ShowLoot = true,
    AntiMod = true,      -- Авто-скрытие при слежке
    PanicMode = false    -- Ручное скрытие всего
}

local isModWatching = false

-- Цвета
local ColorEnemy = Color3.fromRGB(255, 50, 50)
local ColorResource = Color3.fromRGB(0, 255, 0) 
local ColorLoot = Color3.fromRGB(255, 215, 0)   
local ColorTheme = Color3.fromRGB(0, 200, 255) 

-- ==========================================
-- == WATERMARK + FPS + СТАТУС ЗАЩИТЫ ==
-- ==========================================
local WatermarkText = Drawing.new("Text")
WatermarkText.Visible = true; WatermarkText.Outline = true; WatermarkText.Size = 16
WatermarkText.Color = Color3.fromRGB(255, 255, 255); WatermarkText.Position = Vector2.new(15, 15)

local WatermarkAccent = Drawing.new("Square")
WatermarkAccent.Visible = true; WatermarkAccent.Filled = true; WatermarkAccent.Color = ColorTheme
WatermarkAccent.Size = Vector2.new(4, 70); WatermarkAccent.Position = Vector2.new(10, 15)

local startTime = tick()
local fps = 0; local frameCount = 0; local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        fps = frameCount; frameCount = 0; lastTime = tick()
        local uptime = math.floor(tick() - startTime)
        local minutes = math.floor(uptime / 60)
        local seconds = uptime % 60
        
        local status = "UNDETECTED"
        local statusColor = Color3.fromRGB(0, 255, 0)
        
        if isModWatching then
            status = "MOD WATCHING! HIDDEN"
            statusColor = Color3.fromRGB(255, 0, 0)
        elseif Config.PanicMode then
            status = "PANIC MODE (HIDDEN)"
            statusColor = Color3.fromRGB(255, 165, 0)
        end
        
        WatermarkText.Text = "CREATOR SMOKExR'S\nUser: " .. LocalPlayer.Name .. "\nGame: Fust Survival\nStatus: " .. status .. "\nFPS: " .. fps .. " | Time: " .. minutes .. "m " .. seconds .. "s"
        WatermarkAccent.Color = statusColor
    end
end)

-- ==========================================
-- == ANTI-MOD PROTECTION ==
-- ==========================================
RunService.Heartbeat:Connect(function()
    if not Config.AntiMod then 
        isModWatching = false
        return 
    end
    
    isModWatching = false
    
    -- 1. Проверка через CameraSubject (кто-то смотрит на нас)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.CameraSubject then
            if player.CameraSubject == LocalPlayer.Character then
                isModWatching = true
                break
            end
        end
    end
    
    -- 2. Проверка на наличие GUI с названием "spectate" или "record" (админские скрипты)
    for _, obj in pairs(game:GetService("CoreGui"):GetChildren()) do
        local name = obj.Name:lower()
        if string.find(name, "spectate") or string.find(name, "record") or string.find(name, "stream") or string.find(name, "admin") then
            isModWatching = true
            break
        end
    end
end)

-- ==========================================
-- == PANIC MODE (ПРАВЫЙ SHIFT) ==
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Config.PanicMode = not Config.PanicMode
        if not Config.PanicMode then
            -- Показать меню обратно
            Rayfield:Notify({ Title = "CREATOR SMOKExR'S", Content = "Panic Mode Disabled. Safe to play.", Duration = 3 })
        end
    end
end)

-- Заставка
local SplashTitle = Drawing.new("Text")
SplashTitle.Visible = true; SplashTitle.Center = true; SplashTitle.Outline = true; SplashTitle.Size = 45
SplashTitle.Color = ColorTheme; SplashTitle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 20)
SplashTitle.Text = "CREATOR SMOKExR'S"
local SplashSub = Drawing.new("Text")
SplashSub.Visible = true; SplashSub.Center = true; SplashSub.Outline = true; SplashSub.Size = 20
SplashSub.Color = Color3.fromRGB(255, 255, 255); SplashSub.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 + 20)
SplashSub.Text = "STEALTH EDITION"
local splashTimer = tick() + 4

-- Меню
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Stealth Edition",
    Theme = "Midnight", 
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main ESP", 4483362458)
local ProtectTab = Window:CreateTab("Protection", 4483362458)

MainTab:CreateSection("Player Visuals")
MainTab:CreateToggle({ Name = "Enable ESP", CurrentValue = true, Callback = function(v) Config.Enabled = v end })
MainTab:CreateToggle({ Name = "Player Boxes", CurrentValue = true, Callback = function(v) Config.ShowPlayerBox = v end })
MainTab:CreateToggle({ Name = "Player Names", CurrentValue = true, Callback = function(v) Config.ShowPlayerName = v end })
MainTab:CreateToggle({ Name = "Player Health", CurrentValue = true, Callback = function(v) Config.ShowPlayerHealth = v end })

MainTab:CreateSection("World Objects")
MainTab:CreateToggle({ Name = "Resource ESP (Trees/Ores)", CurrentValue = true, Callback = function(v) Config.ShowResources = v end })
MainTab:CreateToggle({ Name = "Loot ESP (Bags/Boxes)", CurrentValue = true, Callback = function(v) Config.ShowLoot = v end })

ProtectTab:CreateSection("Moderator Protection")
ProtectTab:CreateToggle({ Name = "Anti-Mod (Auto Hide when Watched)", CurrentValue = true, Callback = function(v) Config.AntiMod = v end })
ProtectTab:CreateParagraph({ Title = "Panic Key", Content = "Press [Right Shift] to instantly hide all cheats and menu if a moderator is nearby." })

Rayfield:Notify({ Title = "CREATOR SMOKExR'S", Content = "Stealth Loaded! RightShift = Panic", Duration = 5 })

-- ==========================================
-- == ПУЛЫ ОБЪЕКТОВ ==
-- ==========================================
local PlayerBoxes, PlayerNames, PlayerHealths, PlayerHealthBacks = {}, {}, {}, {}
local ResourceBoxes, ResourceNames = {}, {}
local LootBoxes, LootNames = {}, {}

for i = 1, MAX_PLAYERS do
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false; table.insert(PlayerBoxes, box)
    local nt = Drawing.new("Text"); nt.Center = true; nt.Outline = true; nt.Size = 14; nt.Visible = false; table.insert(PlayerNames, nt)
    local hback = Drawing.new("Square"); hback.Thickness = 1; hback.Filled = true; hback.Color = Color3.fromRGB(20, 20, 20); hback.ZIndex = 1; hback.Visible = false; table.insert(PlayerHealthBacks, hback)
    local hb = Drawing.new("Square"); hb.Thickness = 1; hb.Filled = true; hb.ZIndex = 2; hb.Visible = false; table.insert(PlayerHealths, hb)
end

for i = 1, MAX_OBJECTS do
    local rbox = Drawing.new("Square"); rbox.Thickness = 1; rbox.Filled = false; rbox.Color = ColorResource; rbox.Visible = false; table.insert(ResourceBoxes, rbox)
    local rname = Drawing.new("Text"); rname.Center = true; rname.Outline = true; rname.Size = 12; rname.Color = ColorResource; rname.Visible = false; table.insert(ResourceNames, rname)
    
    local lbox = Drawing.new("Square"); lbox.Thickness = 1; lbox.Filled = false; lbox.Color = ColorLoot; lbox.Visible = false; table.insert(LootBoxes, lbox)
    local lname = Drawing.new("Text"); lname.Center = true; lname.Outline = true; lname.Size = 12; lname.Color = ColorLoot; lname.Visible = false; table.insert(LootNames, lname)
end

-- ==========================================
-- == ГЛАВНЫЙ ЦИКЛ ==
-- ==========================================
RunService.RenderStepped:Connect(function()
    -- Если модератор смотрит ИЛИ включен паник-режим — скрываем ВСЁ
    local hideEverything = isModWatching or Config.PanicMode
    
    if SplashTitle.Visible then
        if tick() > splashTimer then SplashTitle.Visible = false; SplashSub.Visible = false
        else SplashTitle.Size = 45 + math.sin(tick() * 5) * 3; SplashSub.Size = 20 + math.cos(tick() * 5) * 2 end
    end

    -- Очистка
    for i = 1, MAX_PLAYERS do
        PlayerBoxes[i].Visible = false; PlayerNames[i].Visible = false
        PlayerHealths[i].Visible = false; PlayerHealthBacks[i].Visible = false
    end
    for i = 1, MAX_OBJECTS do
        ResourceBoxes[i].Visible = false; ResourceNames[i].Visible = false
        LootBoxes[i].Visible = false; LootNames[i].Visible = false
    end

    if not Config.Enabled or hideEverything then return end

    -- 1. ОТРИСОВКА ИГРОКОВ
    local pIndex = 1
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and pIndex <= MAX_PLAYERS then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head") or hrp
            
            if hrp and hum and head and hum.Health > 0 then
                local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                    
                    local headPos = Camera:WorldToViewportPoint(head.Position)
                    local height = math.abs(hrpPos.Y - headPos.Y) * 2.5; local width = height / 2

                    if Config.ShowPlayerBox then
                        PlayerBoxes[pIndex].Size = Vector2.new(width, height); PlayerBoxes[pIndex].Position = Vector2.new(hrpPos.X - width/2, hrpPos.Y - height/2)
                        PlayerBoxes[pIndex].Color = ColorEnemy; PlayerBoxes[pIndex].Visible = true
                    end
                    if Config.ShowPlayerHealth then
                        local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        PlayerHealthBacks[pIndex].Size = Vector2.new(3, height); PlayerHealthBacks[pIndex].Position = Vector2.new((hrpPos.X - width/2) - 6, hrpPos.Y - height/2); PlayerHealthBacks[pIndex].Visible = true
                        PlayerHealths[pIndex].Size = Vector2.new(3, height * hpPct); PlayerHealths[pIndex].Position = Vector2.new((hrpPos.X - width/2) - 6, (hrpPos.Y + height/2) - (height * hpPct))
                        PlayerHealths[pIndex].Color = Color3.fromRGB(0, 255, 0); PlayerHealths[pIndex].Visible = true
                    end
                    if Config.ShowPlayerName then
                        PlayerNames[pIndex].Text = player.Name .. " [" .. math.floor(dist) .. "m]"
                        PlayerNames[pIndex].Color = ColorEnemy
                        PlayerNames[pIndex].Position = Vector2.new(hrpPos.X, (hrpPos.Y - height/2) - 18); PlayerNames[pIndex].Visible = true
                    end
                    pIndex = pIndex + 1
                end
            end
        end
    end

    -- 2. ОТРИСОВКА РЕСУРСОВ И ЛУТА
    local rIndex = 1
    local lIndex = 1

    for _, obj in ipairs(workspace:GetChildren()) do
        if Config.ShowResources and (obj:IsA("Model") or obj:IsA("BasePart")) and rIndex <= MAX_OBJECTS then
            local name = obj.Name:lower()
            if string.find(name, "tree") or string.find(name, "rock") or string.find(name, "ore") or string.find(name, "stone") or string.find(name, "wood") then
                local pos, onScreen = Camera:WorldToViewportPoint(obj:GetPivot().Position)
                if onScreen then
                    ResourceBoxes[rIndex].Size = Vector2.new(15, 15)
                    ResourceBoxes[rIndex].Position = Vector2.new(pos.X - 7.5, pos.Y - 7.5)
                    ResourceBoxes[rIndex].Visible = true
                    
                    ResourceNames[rIndex].Text = obj.Name
                    ResourceNames[rIndex].Position = Vector2.new(pos.X, pos.Y - 15)
                    ResourceNames[rIndex].Visible = true
                    rIndex = rIndex + 1
                end
            end
        end

        if Config.ShowLoot and (obj:IsA("Model") or obj:IsA("BasePart")) and lIndex <= MAX_OBJECTS then
            local name = obj.Name:lower()
            if string.find(name, "loot") or string.find(name, "bag") or string.find(name, "crate") or string.find(name, "box") or string.find(name, "corpse") then
                local pos, onScreen = Camera:WorldToViewportPoint(obj:GetPivot().Position)
                if onScreen then
                    LootBoxes[lIndex].Size = Vector2.new(15, 15)
                    LootBoxes[lIndex].Position = Vector2.new(pos.X - 7.5, pos.Y - 7.5)
                    LootBoxes[lIndex].Visible = true
                    
                    LootNames[lIndex].Text = "LOOT"
                    LootNames[lIndex].Position = Vector2.new(pos.X, pos.Y - 15)
                    LootNames[lIndex].Visible = true
                    lIndex = lIndex + 1
                end
            end
        end
    end
end)
