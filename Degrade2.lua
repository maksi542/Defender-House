-- ==========================================
-- == CREATOR SMOKExR'S | DEGRADE GOD TIER ==
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local MAX_PLAYERS = 30 
local MAX_OBJECTS = 50 
local MAX_DISTANCE = 2000 -- Увеличили лимит до 2км

local Config = {
    Enabled = true, 
    ShowPlayerBox = true, 
    ShowPlayerName = true, 
    ShowPlayerHealth = true,
    ShowResources = true, 
    ShowLoot = true,
    ShowCorpses = true, -- НОВОЕ: Отображение трупов
    
    -- СУПЕР-ЖЕСТКИЙ АИМ
    AimEnabled = false, 
    AimPart = "Head",
    AimFOV = 200,
    AimSmooth = 2, -- Стало еще жестче (почти мгновенно)
    AimPrediction = 0.15 -- Предсказание движения
}

local isModWatching = false

-- Цвета (Киберспортивный неон)
local ColorEnemy = Color3.fromRGB(255, 50, 50)
local ColorResource = Color3.fromRGB(0, 255, 0) 
local ColorLoot = Color3.fromRGB(255, 215, 0)   
local ColorCorpse = Color3.fromRGB(255, 100, 0) -- Оранжевый для трупов
local ColorTheme = Color3.fromRGB(0, 200, 255) 
local ColorFOV = Color3.fromRGB(255, 255, 255)

-- ==========================================
-- == УЛУЧШЕННЫЙ WATERMARK (С АНИМАЦИЕЙ) ==
-- ==========================================
local WatermarkText = Drawing.new("Text")
WatermarkText.Visible = true; WatermarkText.Outline = true; WatermarkText.Size = 16
WatermarkText.Color = Color3.fromRGB(255, 255, 255); WatermarkText.Position = Vector2.new(15, 15)

local WatermarkAccent = Drawing.new("Square")
WatermarkAccent.Visible = true; WatermarkAccent.Filled = true; WatermarkAccent.Color = ColorTheme
WatermarkAccent.Size = Vector2.new(4, 60); WatermarkAccent.Position = Vector2.new(10, 15)

local startTime = tick()
local fps = 0; local frameCount = 0; local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        fps = frameCount; frameCount = 0; lastTime = tick()
        local uptime = math.floor(tick() - startTime)
        local minutes = math.floor(uptime / 60)
        local seconds = uptime % 60
        local status = isModWatching and "WATCHED" or "UNDETECTED"
        
        WatermarkText.Text = "CREATOR SMOKExR'S\nUser: " .. LocalPlayer.Name .. "\nStatus: " .. status .. "\nFPS: " .. fps .. " | Time: " .. minutes .. "m " .. seconds .. "s"
        WatermarkAccent.Color = isModWatching and Color3.fromRGB(255, 0, 0) or ColorTheme
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
-- == МЕНЮ RAYFIELD (КРАСИВОЕ) ==
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S",
    LoadingTitle = "Загрузка God Tier...",
    LoadingSubtitle = "by SMOKExR",
    Theme = "Ocean", -- Красивая синяя тема
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main ESP", 4483362458)
local AimTab = Window:CreateTab("Aimbot", 4483362458)

MainTab:CreateSection("Player Visuals")
MainTab:CreateToggle({ Name = "Enable ESP", CurrentValue = true, Callback = function(v) Config.Enabled = v end })
MainTab:CreateToggle({ Name = "Player Boxes", CurrentValue = true, Callback = function(v) Config.ShowPlayerBox = v end })
MainTab:CreateToggle({ Name = "Player Names", CurrentValue = true, Callback = function(v) Config.ShowPlayerName = v end })
MainTab:CreateToggle({ Name = "Player Health", CurrentValue = true, Callback = function(v) Config.ShowPlayerHealth = v end })

MainTab:CreateSection("World Objects")
MainTab:CreateToggle({ Name = "Resource ESP (Trees/Ores)", CurrentValue = true, Callback = function(v) Config.ShowResources = v end })
MainTab:CreateToggle({ Name = "Loot ESP (Bags/Boxes)", CurrentValue = true, Callback = function(v) Config.ShowLoot = v end })
-- НОВАЯ ФУНКЦИЯ
MainTab:CreateToggle({ Name = "Corpse ESP (Dead Bodies)", CurrentValue = true, Callback = function(v) Config.ShowCorpses = v end })

AimTab:CreateSection("Super Hard Aimbot")
AimTab:CreateToggle({ Name = "Enable Hard Aim (LMB)", CurrentValue = false, Callback = function(v) Config.AimEnabled = v end })
AimTab:CreateDropdown({ Name = "Target Part", Options = {"Head", "Torso"}, CurrentOption = {"Head"}, MultipleOptions = false, Callback = function(o) Config.AimPart = o[1] end })
AimTab:CreateSlider({ Name = "FOV Radius", Range = {50, 500}, Increment = 10, CurrentValue = 200, Callback = function(v) Config.AimFOV = v end })
AimTab:CreateSlider({ Name = "Aim Smoothness", Range = {1, 10}, Increment = 0.5, CurrentValue = 2, Callback = function(v) Config.AimSmooth = v end })
AimTab:CreateSlider({ Name = "Prediction", Range = {0, 0.5}, Increment = 0.05, CurrentValue = 0.15, Callback = function(v) Config.AimPrediction = v end })

Rayfield:Notify({ Title = "CREATOR SMOKExR'S", Content = "God Tier Edition Loaded!", Duration = 5 })

-- ==========================================
-- == ПУЛЫ ОБЪЕКТОВ ==
-- ==========================================
local PlayerBoxes, PlayerNames, PlayerHealths, PlayerHealthBacks = {}, {}, {}, {}
local ResourceBoxes, LootBoxes, CorpseBoxes = {}, {}, {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false; FOVCircle.Thickness = 2; FOVCircle.Color = ColorFOV; FOVCircle.Filled = false

for i = 1, MAX_PLAYERS do
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false; table.insert(PlayerBoxes, box)
    local nt = Drawing.new("Text"); nt.Center = true; nt.Outline = true; nt.Size = 14; nt.Visible = false; table.insert(PlayerNames, nt)
    local hback = Drawing.new("Square"); hback.Thickness = 1; hback.Filled = true; hback.Color = Color3.fromRGB(20, 20, 20); hback.Visible = false; table.insert(PlayerHealthBacks, hback)
    local hb = Drawing.new("Square"); hb.Thickness = 1; hb.Filled = true; hb.Visible = false; table.insert(PlayerHealths, hb)
end

for i = 1, MAX_OBJECTS do
    local rbox = Drawing.new("Square"); rbox.Thickness = 1; rbox.Filled = false; rbox.Color = ColorResource; rbox.Visible = false; table.insert(ResourceBoxes, rbox)
    local lbox = Drawing.new("Square"); lbox.Thickness = 1; lbox.Filled = false; lbox.Color = ColorLoot; lbox.Visible = false; table.insert(LootBoxes, lbox)
    local cbox = Drawing.new("Square"); cbox.Thickness = 1; cbox.Filled = false; cbox.Color = ColorCorpse; cbox.Visible = false; table.insert(CorpseBoxes, cbox)
end

-- ==========================================
-- == ФУНКЦИЯ СУПЕР-АИМА (С ПРЕДСКАЗАНИЕМ) ==
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
                    -- Предсказание (для бегущих)
                    local velocity = targetPart.AssemblyLinearVelocity or Vector3.new(0,0,0)
                    local predictedPos = targetPart.Position + (velocity * Config.AimPrediction)
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
                    if onScreen then
                        local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if distToCenter < shortestDist then
                            shortestDist = distToCenter
                            closest = predictedPos
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

    -- ЖЕСТКИЙ АИМ
    if Config.AimEnabled and not hideAll then
        local isLMBPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
        if isLMBPressed then
            local targetPos = GetClosestTarget()
            if targetPos then
                -- Плавность 2 означает почти мгновенный поворот
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
        ResourceBoxes[i].Visible = false; LootBoxes[i].Visible = false; CorpseBoxes[i].Visible = false
    end

    if not Config.Enabled or hideAll then return end

    -- 1. ОТРИСОВКА ИГРОКОВ
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

    -- 2. РЕСУРСЫ, ЛУТ И ТРУПЫ (Сканирование)
    local rIndex = 1
    local lIndex = 1
    local cIndex = 1

    for _, obj in ipairs(workspace:GetChildren()) do
        local objPos = obj:GetPivot().Position
        local distToObj = (Camera.CFrame.Position - objPos).Magnitude
        
        if distToObj <= MAX_DISTANCE then
            -- Ресурсы
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

            -- Лут
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
            
            -- ТРУПЫ (Corpses)
            if Config.ShowCorpses and (obj:IsA("Model") or obj:IsA("BasePart")) and cIndex <= MAX_OBJECTS then
                local name = obj.Name:lower()
                if string.find(name, "corpse") or string.find(name, "body") or string.find(name, "dead") or string.find(name, "ragdoll") then
                    local pos, onScreen = Camera:WorldToViewportPoint(objPos)
                    if onScreen then
                        CorpseBoxes[cIndex].Size = Vector2.new(12, 12)
                        CorpseBoxes[cIndex].Position = Vector2.new(pos.X - 6, pos.Y - 6)
                        CorpseBoxes[cIndex].Visible = true
                        cIndex = cIndex + 1
                    end
                end
            end
        end
    end
end)
