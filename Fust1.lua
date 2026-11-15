-- ==========================================
-- == CREATOR SMOKExR'S | ULTRA STEALTH ESP ==
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local MAX_PLAYERS = 20 
local MAX_OBJECTS = 30 

local Config = {
    Enabled = true, 
    ShowPlayerBox = true, 
    ShowPlayerName = true, 
    ShowPlayerHealth = true,
    ShowResources = true, 
    ShowLoot = true,
    MenuVisible = false -- По умолчанию меню СКРЫТО (включается на RightShift)
}

local isModWatching = false

-- Цвета
local ColorEnemy = Color3.fromRGB(255, 50, 50)
local ColorResource = Color3.fromRGB(0, 255, 0) 
local ColorLoot = Color3.fromRGB(255, 215, 0)   
local ColorTheme = Color3.fromRGB(0, 200, 255) 

-- ==========================================
-- == WATERMARK (Только текст, без GUI) ==
-- ==========================================
local Watermark = Drawing.new("Text")
Watermark.Visible = true; Watermark.Outline = true; Watermark.Size = 14
Watermark.Color = Color3.fromRGB(255, 255, 255); Watermark.Position = Vector2.new(10, 10)
Watermark.Text = "SMOKExR'S STEALTH | Mod: Safe | FPS: 60"

local startTime = tick()
local fps = 0; local frameCount = 0; local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        fps = frameCount; frameCount = 0; lastTime = tick()
        local status = isModWatching and "WATCHED" or "SAFE"
        Watermark.Text = "SMOKExR'S STEALTH | Mod: " .. status .. " | FPS: " .. fps
        Watermark.Color = isModWatching and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
    end
end)

-- ==========================================
-- == ANTI-MOD (Защита от слежки) ==
-- ==========================================
RunService.Heartbeat:Connect(function()
    isModWatching = false
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.CameraSubject == LocalPlayer.Character then
            isModWatching = true
            break
        end
    end
end)

-- ==========================================
-- == DRAWING-МЕНЮ (СКРЫТОЕ) ==
-- ==========================================
local MenuBG = Drawing.new("Square")
MenuBG.Visible = false; MenuBG.Filled = true; MenuBG.Color = Color3.fromRGB(15, 15, 15)
MenuBG.Size = Vector2.new(220, 200); MenuBG.Position = Vector2.new(10, 10)

local MenuTitle = Drawing.new("Text")
MenuTitle.Visible = false; MenuTitle.Text = "STEALTH MENU (RightShift)"; MenuTitle.Size = 16
MenuTitle.Color = ColorTheme; MenuTitle.Position = Vector2.new(15, 15); MenuTitle.Outline = true

local Btn1 = Drawing.new("Text")
Btn1.Visible = false; Btn1.Text = "[F1] Player ESP: ON"; Btn1.Size = 14
Btn1.Color = Color3.fromRGB(0, 255, 0); Btn1.Position = Vector2.new(15, 50); Btn1.Outline = true

local Btn2 = Drawing.new("Text")
Btn2.Visible = false; Btn2.Text = "[F2] Resources: ON"; Btn2.Size = 14
Btn2.Color = Color3.fromRGB(0, 255, 0); Btn2.Position = Vector2.new(15, 80); Btn2.Outline = true

local Btn3 = Drawing.new("Text")
Btn3.Visible = false; Btn3.Text = "[F3] Loot: ON"; Btn3.Size = 14
Btn3.Color = Color3.fromRGB(0, 255, 0); Btn3.Position = Vector2.new(15, 110); Btn3.Outline = true

local MenuElements = {MenuBG, MenuTitle, Btn1, Btn2, Btn3}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Открытие/Закрытие меню (RightShift)
    if input.KeyCode == Enum.KeyCode.RightShift then
        Config.MenuVisible = not Config.MenuVisible
        for _, el in ipairs(MenuElements) do el.Visible = Config.MenuVisible end
    end
    
    -- Управление функциями
    if input.KeyCode == Enum.KeyCode.F1 then
        Config.ShowPlayerBox = not Config.ShowPlayerBox
        Btn1.Text = "[F1] Player ESP: " .. (Config.ShowPlayerBox and "ON" or "OFF")
        Btn1.Color = Config.ShowPlayerBox and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.F2 then
        Config.ShowResources = not Config.ShowResources
        Btn2.Text = "[F2] Resources: " .. (Config.ShowResources and "ON" or "OFF")
        Btn2.Color = Config.ShowResources and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.F3 then
        Config.ShowLoot = not Config.ShowLoot
        Btn3.Text = "[F3] Loot: " .. (Config.ShowLoot and "ON" or "OFF")
        Btn3.Color = Config.ShowLoot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    end
end)

-- ==========================================
-- == ПУЛЫ ОБЪЕКТОВ ДЛЯ ESP ==
-- ==========================================
local PlayerBoxes, PlayerNames, PlayerHealths = {}, {}, {}
local ResourceBoxes, LootBoxes = {}, {}

for i = 1, MAX_PLAYERS do
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false; table.insert(PlayerBoxes, box)
    local nt = Drawing.new("Text"); nt.Center = true; nt.Outline = true; nt.Size = 14; nt.Visible = false; table.insert(PlayerNames, nt)
    local hb = Drawing.new("Square"); hb.Thickness = 2; hb.Filled = true; hb.Visible = false; table.insert(PlayerHealths, hb)
end

for i = 1, MAX_OBJECTS do
    local rbox = Drawing.new("Square"); rbox.Thickness = 1; rbox.Filled = false; rbox.Color = ColorResource; rbox.Visible = false; table.insert(ResourceBoxes, rbox)
    local lbox = Drawing.new("Square"); lbox.Thickness = 1; lbox.Filled = false; lbox.Color = ColorLoot; lbox.Visible = false; table.insert(LootBoxes, lbox)
end

-- ==========================================
-- == ГЛАВНЫЙ ЦИКЛ ==
-- ==========================================
RunService.RenderStepped:Connect(function()
    -- Если за нами следят, прячем ВСЁ ESP
    local hideAll = isModWatching

    for i = 1, MAX_PLAYERS do
        PlayerBoxes[i].Visible = false; PlayerNames[i].Visible = false; PlayerHealths[i].Visible = false
    end
    for i = 1, MAX_OBJECTS do
        ResourceBoxes[i].Visible = false; LootBoxes[i].Visible = false
    end

    if not Config.Enabled or hideAll then return end

    -- 1. ESP ИГРОКОВ
    if Config.ShowPlayerBox then
        local pIndex = 1
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and pIndex <= MAX_PLAYERS then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                
                if hrp and hum and hum.Health > 0 then
                    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local head = char:FindFirstChild("Head") or hrp
                        local headPos = Camera:WorldToViewportPoint(head.Position)
                        local height = math.abs(hrpPos.Y - headPos.Y) * 2.5; local width = height / 2

                        PlayerBoxes[pIndex].Size = Vector2.new(width, height)
                        PlayerBoxes[pIndex].Position = Vector2.new(hrpPos.X - width/2, hrpPos.Y - height/2)
                        PlayerBoxes[pIndex].Color = ColorEnemy
                        PlayerBoxes[pIndex].Visible = true
                        
                        if Config.ShowPlayerHealth then
                            local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            PlayerHealths[pIndex].Size = Vector2.new(2, height * hpPct)
                            PlayerHealths[pIndex].Position = Vector2.new((hrpPos.X - width/2) - 5, (hrpPos.Y + height/2) - (height * hpPct))
                            PlayerHealths[pIndex].Color = Color3.fromRGB(0, 255, 0)
                            PlayerHealths[pIndex].Visible = true
                        end

                        if Config.ShowPlayerName then
                            PlayerNames[pIndex].Text = player.Name .. " [" .. math.floor((Camera.CFrame.Position - hrp.Position).Magnitude) .. "m]"
                            PlayerNames[pIndex].Color = ColorEnemy
                            PlayerNames[pIndex].Position = Vector2.new(hrpPos.X, (hrpPos.Y - height/2) - 18)
                            PlayerNames[pIndex].Visible = true
                        end
                        pIndex = pIndex + 1
                    end
                end
            end
        end
    end

    -- 2. РЕСУРСЫ И ЛУТ
    local rIndex = 1
    local lIndex = 1

    for _, obj in ipairs(workspace:GetChildren()) do
        if Config.ShowResources and (obj:IsA("Model") or obj:IsA("BasePart")) and rIndex <= MAX_OBJECTS then
            local name = obj.Name:lower()
            if string.find(name, "tree") or string.find(name, "rock") or string.find(name, "ore") or string.find(name, "stone") then
                local pos, onScreen = Camera:WorldToViewportPoint(obj:GetPivot().Position)
                if onScreen then
                    ResourceBoxes[rIndex].Size = Vector2.new(10, 10)
                    ResourceBoxes[rIndex].Position = Vector2.new(pos.X - 5, pos.Y - 5)
                    ResourceBoxes[rIndex].Visible = true
                    rIndex = rIndex + 1
                end
            end
        end

        if Config.ShowLoot and (obj:IsA("Model") or obj:IsA("BasePart")) and lIndex <= MAX_OBJECTS then
            local name = obj.Name:lower()
            if string.find(name, "loot") or string.find(name, "bag") or string.find(name, "crate") or string.find(name, "box") then
                local pos, onScreen = Camera:WorldToViewportPoint(obj:GetPivot().Position)
                if onScreen then
                    LootBoxes[lIndex].Size = Vector2.new(10, 10)
                    LootBoxes[lIndex].Position = Vector2.new(pos.X - 5, pos.Y - 5)
                    LootBoxes[lIndex].Visible = true
                    lIndex = lIndex + 1
                end
            end
        end
    end
end)
