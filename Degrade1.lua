-- ==========================================
-- == CREATOR SMOKExR'S | DEGRADE SNIPER ==
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local MAX_PLAYERS = 30 
local MAX_OBJECTS = 40 
local MAX_DISTANCE = 1500 -- Лимит дистанции для ESP (в метрах)

local Config = {
    Enabled = true, 
    ShowPlayerBox = true, 
    ShowPlayerName = true, 
    ShowPlayerHealth = true,
    ShowResources = true, 
    ShowLoot = true,
    
    -- АИМ (Сделали пожёстче)
    AimEnabled = false, 
    AimPart = "Head",
    AimFOV = 150,
    AimSmooth = 4, -- Было 8, теперь 4 (наводится быстрее)
    
    MenuVisible = false 
}

local isModWatching = false

-- Цвета
local ColorEnemy = Color3.fromRGB(255, 50, 50)
local ColorResource = Color3.fromRGB(0, 255, 0) 
local ColorLoot = Color3.fromRGB(255, 215, 0)   
local ColorTheme = Color3.fromRGB(0, 200, 255) 
local ColorFOV = Color3.fromRGB(255, 255, 255)
local ColorMenuBg = Color3.fromRGB(15, 15, 15)
local ColorMenuLine = Color3.fromRGB(50, 50, 50)

-- ==========================================
-- == WATERMARK + FPS ==
-- ==========================================
local Watermark = Drawing.new("Text")
Watermark.Visible = true; Watermark.Outline = true; Watermark.Size = 14
Watermark.Color = Color3.fromRGB(255, 255, 255); Watermark.Position = Vector2.new(10, 10)
Watermark.Text = "SMOKExR'S SNIPER | Mod: Safe | FPS: 60"

local startTime = tick()
local fps = 0; local frameCount = 0; local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        fps = frameCount; frameCount = 0; lastTime = tick()
        local status = isModWatching and "WATCHED" or "SAFE"
        Watermark.Text = "SMOKExR'S SNIPER | Mod: " .. status .. " | FPS: " .. fps
        Watermark.Color = isModWatching and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 255)
    end
end)

-- ==========================================
-- == ANTI-MOD ==
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
-- == СТИЛЬНОЕ DRAWING-МЕНЮ ==
-- ==========================================
local MenuBG = Drawing.new("Square")
MenuBG.Visible = false; MenuBG.Filled = true; MenuBG.Color = ColorMenuBg; MenuBG.Transparency = 0.4
MenuBG.Size = Vector2.new(260, 250); MenuBG.Position = Vector2.new(10, 10)

local MenuLine = Drawing.new("Square")
MenuLine.Visible = false; MenuLine.Filled = true; MenuLine.Color = ColorTheme
MenuLine.Size = Vector2.new(4, 250); MenuLine.Position = Vector2.new(10, 10)

local MenuTitle = Drawing.new("Text")
MenuTitle.Visible = false; MenuTitle.Text = "SNIPER MENU (RightShift)"; MenuTitle.Size = 16
MenuTitle.Color = ColorTheme; MenuTitle.Position = Vector2.new(20, 15); MenuTitle.Outline = true

local Btn1 = Drawing.new("Text")
Btn1.Visible = false; Btn1.Text = "[F1] Player ESP"; Btn1.Size = 14
Btn1.Color = Color3.fromRGB(0, 255, 0); Btn1.Position = Vector2.new(20, 50); Btn1.Outline = true

local Btn2 = Drawing.new("Text")
Btn2.Visible = false; Btn2.Text = "[F2] Resources"; Btn2.Size = 14
Btn2.Color = Color3.fromRGB(0, 255, 0); Btn2.Position = Vector2.new(20, 80); Btn2.Outline = true

local Btn3 = Drawing.new("Text")
Btn3.Visible = false; Btn3.Text = "[F3] Loot"; Btn3.Size = 14
Btn3.Color = Color3.fromRGB(0, 255, 0); Btn3.Position = Vector2.new(20, 110); Btn3.Outline = true

local Btn4 = Drawing.new("Text")
Btn4.Visible = false; Btn4.Text = "[F4] Legit Aim"; Btn4.Size = 14
Btn4.Color = Color3.fromRGB(255, 0, 0); Btn4.Position = Vector2.new(20, 140); Btn4.Outline = true

local AimSmoothText = Drawing.new("Text")
AimSmoothText.Visible = false; AimSmoothText.Text = "Aim Smooth: 4 (F5 - / F6 +)"; AimSmoothText.Size = 12
AimSmoothText.Color = Color3.fromRGB(200, 200, 200); AimSmoothText.Position = Vector2.new(20, 170); AimSmoothText.Outline = true

local MenuElements = {MenuBG, MenuLine, MenuTitle, Btn1, Btn2, Btn3, Btn4, AimSmoothText}

local function UpdateMenuUI()
    Btn1.Text = "[F1] Player ESP: " .. (Config.ShowPlayerBox and "ON" or "OFF")
    Btn1.Color = Config.ShowPlayerBox and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    Btn2.Text = "[F2] Resources: " .. (Config.ShowResources and "ON" or "OFF")
    Btn2.Color = Config.ShowResources and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    Btn3.Text = "[F3] Loot: " .. (Config.ShowLoot and "ON" or "OFF")
    Btn3.Color = Config.ShowLoot and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    Btn4.Text = "[F4] Legit Aim: " .. (Config.AimEnabled and "ON" or "OFF")
    Btn4.Color = Config.AimEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    AimSmoothText.Text = "Aim Smooth: " .. Config.AimSmooth .. " (F5 - / F6 +)"
end
UpdateMenuUI()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        Config.MenuVisible = not Config.MenuVisible
        for _, el in ipairs(MenuElements) do el.Visible = Config.MenuVisible end
    end
    
    if input.KeyCode == Enum.KeyCode.F1 then Config.ShowPlayerBox = not Config.ShowPlayerBox; UpdateMenuUI()
    elseif input.KeyCode == Enum.KeyCode.F2 then Config.ShowResources = not Config.ShowResources; UpdateMenuUI()
    elseif input.KeyCode == Enum.KeyCode.F3 then Config.ShowLoot = not Config.ShowLoot; UpdateMenuUI()
    elseif input.KeyCode == Enum.KeyCode.F4 then Config.AimEnabled = not Config.AimEnabled; UpdateMenuUI()
    elseif input.KeyCode == Enum.KeyCode.F5 then 
        if Config.AimSmooth > 1 then Config.AimSmooth = Config.AimSmooth - 1; UpdateMenuUI() end
    elseif input.KeyCode == Enum.KeyCode.F6 then 
        if Config.AimSmooth < 15 then Config.AimSmooth = Config.AimSmooth + 1; UpdateMenuUI() end
    end
end)

-- ==========================================
-- == ПУЛЫ ОБЪЕКТОВ ==
-- ==========================================
local PlayerBoxes, PlayerNames, PlayerHealths, PlayerHealthBacks = {}, {}, {}, {}
local ResourceBoxes, LootBoxes = {}, {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false; FOVCircle.Thickness = 1; FOVCircle.Color = ColorFOV; FOVCircle.Filled = false

for i = 1, MAX_PLAYERS do
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false; table.insert(PlayerBoxes, box)
    local nt = Drawing.new("Text"); nt.Center = true; nt.Outline = true; nt.Size = 14; nt.Visible = false; table.insert(PlayerNames, nt)
    local hback = Drawing.new("Square"); hback.Thickness = 1; hback.Filled = true; hback.Color = Color3.fromRGB(20, 20, 20); hback.Visible = false; table.insert(PlayerHealthBacks, hback)
    local hb = Drawing.new("Square"); hb.Thickness = 1; hb.Filled = true; hb.Visible = false; table.insert(PlayerHealths, hb)
end

for i = 1, MAX_OBJECTS do
    local rbox = Drawing.new("Square"); rbox.Thickness = 1; rbox.Filled = false; rbox.Color = ColorResource; rbox.Visible = false; table.insert(ResourceBoxes, rbox)
    local lbox = Drawing.new("Square"); lbox.Thickness = 1; lbox.Filled = false; lbox.Color = ColorLoot; lbox.Visible = false; table.insert(LootBoxes, lbox)
end

-- ==========================================
-- == ФУНКЦИЯ ЛЕГИТНОГО АИМА ==
-- ==========================================
local function GetClosestTarget()
    local closest = nil
    local shortestDist = Config.AimFOV
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local targetPart = player.Character:FindFirstChild(Config.AimPart) or player.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if distToCenter < shortestDist then
                            shortestDist = distToCenter
                            closest = targetPart.Position
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- ==========================================
-- == ГЛАВНЫЙ ЦИКЛ ==
-- ==========================================
RunService.RenderStepped:Connect(function()
    local hideAll = isModWatching

    FOVCircle.Visible = Config.AimEnabled and not hideAll
    FOVCircle.Radius = Config.AimFOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    -- ЛОГИКА АИМА
    if Config.AimEnabled and not hideAll then
        local isRMBPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        if isRMBPressed then
            local targetPos = GetClosestTarget()
            if targetPos then
                local aimCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                Camera.CFrame = Camera.CFrame:Lerp(aimCFrame, 1 / Config.AimSmooth)
            end
        end
    end

    -- Очистка
    for i = 1, MAX_PLAYERS do
        PlayerBoxes[i].Visible = false; PlayerNames[i].Visible = false
        PlayerHealths[i].Visible = false; PlayerHealthBacks[i].Visible = false
    end
    for i = 1, MAX_OBJECTS do
        ResourceBoxes[i].Visible = false; LootBoxes[i].Visible = false
    end

    if not Config.Enabled or hideAll then return end

    -- 1. ОТРИСОВКА ИГРОКОВ (С ЛИМИТОМ ДИСТАНЦИИ 1500М)
    if Config.ShowPlayerBox then
        local pIndex = 1
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and pIndex <= MAX_PLAYERS then
                local char = player.Character
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChild("Humanoid")
                local head = char:FindFirstChild("Head") or hrp
                
                if hrp and hum and head and hum.Health > 0 then
                    local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                    
                    -- ПРОВЕРКА ДИСТАНЦИИ
                    if dist <= MAX_DISTANCE then
                        local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local headPos = Camera:WorldToViewportPoint(head.Position)
                            local height = math.abs(hrpPos.Y - headPos.Y) * 2.5
                            local width = height / 2
                            
                            if width < 3 then width = 3 end
                            if height < 6 then height = 6 end

                            PlayerBoxes[pIndex].Size = Vector2.new(width, height)
                            PlayerBoxes[pIndex].Position = Vector2.new(hrpPos.X - width/2, hrpPos.Y - height/2)
                            PlayerBoxes[pIndex].Color = ColorEnemy
                            PlayerBoxes[pIndex].Visible = true
                            
                            if Config.ShowPlayerHealth then
                                local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                                PlayerHealthBacks[pIndex].Size = Vector2.new(2, height)
                                PlayerHealthBacks[pIndex].Position = Vector2.new((hrpPos.X - width/2) - 5, hrpPos.Y - height/2)
                                PlayerHealthBacks[pIndex].Visible = true

                                PlayerHealths[pIndex].Size = Vector2.new(2, height * hpPct)
                                PlayerHealths[pIndex].Position = Vector2.new((hrpPos.X - width/2) - 5, (hrpPos.Y + height/2) - (height * hpPct))
                                PlayerHealths[pIndex].Color = Color3.fromRGB(0, 255, 0)
                                PlayerHealths[pIndex].Visible = true
                            end

                            if Config.ShowPlayerName then
                                PlayerNames[pIndex].Text = player.Name .. " [" .. math.floor(dist) .. "m]"
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
    end

    -- 2. РЕСУРСЫ И ЛУТ (Тоже с лимитом 1500м)
    local rIndex = 1
    local lIndex = 1

    for _, obj in ipairs(workspace:GetChildren()) do
        local objPos = obj:GetPivot().Position
        local distToObj = (Camera.CFrame.Position - objPos).Magnitude
        
        if distToObj <= MAX_DISTANCE then
            if Config.ShowResources and (obj:IsA("Model") or obj:IsA("BasePart")) and rIndex <= MAX_OBJECTS then
                local name = obj.Name:lower()
                if string.find(name, "tree") or string.find(name, "rock") or string.find(name, "ore") or string.find(name, "stone") then
                    local pos, onScreen = Camera:WorldToViewportPoint(objPos)
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
                    local pos, onScreen = Camera:WorldToViewportPoint(objPos)
                    if onScreen then
                        LootBoxes[lIndex].Size = Vector2.new(10, 10)
                        LootBoxes[lIndex].Position = Vector2.new(pos.X - 5, pos.Y - 5)
                        LootBoxes[lIndex].Visible = true
                        lIndex = lIndex + 1
                    end
                end
            end
        end
    end
end)
