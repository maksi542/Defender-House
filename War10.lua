-- ==========================================
-- == CREATOR SMOKExR'S | AESTHETIC AIM V4 ==
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local MAX_PLAYERS = 30 
local MAX_DISTANCE = 2000 

local Config = {
    Enabled = true, 
    ShowPlayerBox = true, 
    ShowPlayerName = true, 
    ShowPlayerHealth = true,
    ShowTracers = true,
    
    -- НОВЫЙ МЕГА-АИМ
    AimEnabled = false, 
    AimPart = "Head",
    AimFOV = 200,
    AimSmooth = 1.5, 
    AimPrediction = 0.15 
}

local isModWatching = false
local currentTarget = nil

-- Цвета (Неоновые)
local ColorEnemy = Color3.fromRGB(255, 50, 50)
local ColorTheme = Color3.fromRGB(0, 200, 255) 
local ColorFOV = Color3.fromRGB(0, 255, 255) -- Неоновый голубой
local ColorTarget = Color3.fromRGB(255, 0, 0) -- Красный для захвата

-- ==========================================
-- == WATERMARK + FPS ==
-- ==========================================
local WatermarkBG = Drawing.new("Square")
WatermarkBG.Visible = true; WatermarkBG.Filled = true; WatermarkBG.Color = Color3.fromRGB(15, 15, 15); WatermarkBG.Transparency = 0.4
WatermarkBG.Size = Vector2.new(220, 80); WatermarkBG.Position = Vector2.new(10, 10)

local WatermarkAccent = Drawing.new("Square")
WatermarkAccent.Visible = true; WatermarkAccent.Filled = true; WatermarkAccent.Color = ColorTheme
WatermarkAccent.Size = Vector2.new(4, 80); WatermarkAccent.Position = Vector2.new(10, 10)

local WatermarkText = Drawing.new("Text")
WatermarkText.Visible = true; WatermarkText.Outline = true; WatermarkText.Size = 14
WatermarkText.Color = Color3.fromRGB(255, 255, 255); WatermarkText.Position = Vector2.new(20, 15)

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
        
        WatermarkText.Text = "CREATOR SMOKExR'S\nStatus: " .. status .. "\nFPS: " .. fps .. "\nUptime: " .. minutes .. "m " .. seconds .. "s"
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
-- == МЕНЮ RAYFIELD ==
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S",
    LoadingTitle = "Инициализация...",
    LoadingSubtitle = "Aesthetic Aim V4",
    Theme = "Ocean", 
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main ESP", 4483362458)
local AimTab = Window:CreateTab("Aimbot", 4483362458)

MainTab:CreateSection("Visual Settings")
MainTab:CreateToggle({ Name = "Enable ESP", CurrentValue = true, Callback = function(v) Config.Enabled = v end })
MainTab:CreateToggle({ Name = "Player Boxes", CurrentValue = true, Callback = function(v) Config.ShowPlayerBox = v end })
MainTab:CreateToggle({ Name = "Player Names", CurrentValue = true, Callback = function(v) Config.ShowPlayerName = v end })
MainTab:CreateToggle({ Name = "Player Health", CurrentValue = true, Callback = function(v) Config.ShowPlayerHealth = v end })
MainTab:CreateToggle({ Name = "Snaplines", CurrentValue = true, Callback = function(v) Config.ShowTracers = v end })

AimTab:CreateSection("Aesthetic Aim (RMB)")
AimTab:CreateToggle({ Name = "Enable Hard Aim", CurrentValue = false, Callback = function(v) Config.AimEnabled = v end })
AimTab:CreateDropdown({ Name = "Target Part", Options = {"Head", "Torso"}, CurrentOption = {"Head"}, MultipleOptions = false, Callback = function(o) Config.AimPart = o[1] end })
AimTab:CreateSlider({ Name = "FOV Radius", Range = {50, 500}, Increment = 10, CurrentValue = 200, Callback = function(v) Config.AimFOV = v end })
AimTab:CreateSlider({ Name = "Smoothness", Range = {1, 10}, Increment = 0.1, CurrentValue = 1.5, Callback = function(v) Config.AimSmooth = v end })
AimTab:CreateSlider({ Name = "Prediction", Range = {0, 0.5}, Increment = 0.05, CurrentValue = 0.15, Callback = function(v) Config.AimPrediction = v end })

Rayfield:Notify({ Title = "CREATOR SMOKExR'S", Content = "Aesthetic Aim V4 Loaded!", Duration = 5 })

-- ==========================================
-- == ПУЛЫ ОБЪЕКТОВ ДЛЯ КРАСОТЫ ==
-- ==========================================
local PlayerBoxes, PlayerNames, PlayerHealths, PlayerHealthBacks, Tracers = {}, {}, {}, {}, {}

for i = 1, MAX_PLAYERS do
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false; table.insert(PlayerBoxes, box)
    local nt = Drawing.new("Text"); nt.Center = true; nt.Outline = true; nt.Size = 14; nt.Visible = false; table.insert(PlayerNames, nt)
    local hback = Drawing.new("Square"); hback.Thickness = 1; hback.Filled = true; hback.Color = Color3.fromRGB(20, 20, 20); hback.Visible = false; table.insert(PlayerHealthBacks, hback)
    local hb = Drawing.new("Square"); hb.Thickness = 1; hb.Filled = true; hb.Visible = false; table.insert(PlayerHealths, hb)
    local tr = Drawing.new("Line"); tr.Thickness = 1; tr.Color = ColorEnemy; tr.Visible = false; table.insert(Tracers, tr)
end

-- Красивый FOV (Круг + Перекрестие)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false; FOVCircle.Thickness = 1.5; FOVCircle.Color = ColorFOV; FOVCircle.Filled = false

local FOVCrossH = Drawing.new("Line"); FOVCrossH.Thickness = 1; FOVCrossH.Color = ColorFOV; FOVCrossH.Visible = false
local FOVCrossV = Drawing.new("Line"); FOVCrossV.Thickness = 1; FOVCrossV.Color = ColorFOV; FOVCrossV.Visible = false

-- Рамка захвата цели (Target Lock)
local TargetBox = Drawing.new("Square")
TargetBox.Thickness = 2; TargetBox.Filled = false; TargetBox.Color = ColorTarget; TargetBox.Visible = false

-- ==========================================
-- == ФУНКЦИЯ МЕГА-АИМА ==
-- ==========================================
local function GetClosestTarget()
    local closest = nil
    local closestPlayer = nil
    local shortestDist = Config.AimFOV
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local targetPart = player.Character:FindFirstChild(Config.AimPart) or player.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    local velocity = targetPart.AssemblyLinearVelocity or Vector3.new(0,0,0)
                    local predictedPos = targetPart.Position + (velocity * Config.AimPrediction)
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
                    if onScreen then
                        local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if distToCenter < shortestDist then
                            shortestDist = distToCenter
                            closest = predictedPos
                            closestPlayer = player
                        end
                    end
                end
            end
        end
    end
    return closest, closestPlayer
end

-- ==========================================
-- == ГЛАВНЫЙ ЦИКЛ ==
-- ==========================================
RunService.RenderStepped:Connect(function()
    local hideAll = isModWatching
    local cx, cy = Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2

    -- 1. ОТРИСОВКА КРАСИВОГО FOV
    if Config.AimEnabled and not hideAll then
        FOVCircle.Visible = true; FOVCircle.Radius = Config.AimFOV; FOVCircle.Position = Vector2.new(cx, cy)
        
        -- Пульсация круга
        FOVCircle.Color = Color3.fromRGB(0, 200 + math.sin(tick() * 5) * 55, 255)
        
        FOVCrossH.Visible = true; FOVCrossH.From = Vector2.new(cx - 10, cy); FOVCrossH.To = Vector2.new(cx + 10, cy)
        FOVCrossV.Visible = true; FOVCrossV.From = Vector2.new(cx, cy - 10); FOVCrossV.To = Vector2.new(cx, cy + 10)
    else
        FOVCircle.Visible = false; FOVCrossH.Visible = false; FOVCrossV.Visible = false
    end

    -- 2. ЛОГИКА АИМА И ЗАХВАТА
    TargetBox.Visible = false
    if Config.AimEnabled and not hideAll then
        local isRMBPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        local targetPos, targetPlayer = GetClosestTarget()

        if targetPos then
            -- Отрисовка рамки захвата (Даже если ПКМ не зажата, показываем, что цель найдена)
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
            if onScreen then
                TargetBox.Size = Vector2.new(40, 40)
                TargetBox.Position = Vector2.new(screenPos.X - 20, screenPos.Y - 20)
                -- Вращение рамки для красоты
                TargetBox.Visible = true
            end

            -- Само наведение
            if isRMBPressed then
                local aimCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
                -- Плавное притяжение
                Camera.CFrame = Camera.CFrame:Lerp(aimCFrame, 1 / Config.AimSmooth)
            end
        end
    end

    -- 3. ОЧИСТКА ESP
    for i = 1, MAX_PLAYERS do
        PlayerBoxes[i].Visible = false; PlayerNames[i].Visible = false
        PlayerHealths[i].Visible = false; PlayerHealthBacks[i].Visible = false; Tracers[i].Visible = false
    end

    if not Config.Enabled or hideAll then return end

    -- 4. ОТРИСОВКА ИГРОКОВ
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

                        if Config.ShowPlayerBox then
                            PlayerBoxes[pIndex].Size = Vector2.new(width, height)
                            PlayerBoxes[pIndex].Position = Vector2.new(hrpPos.X - width/2, hrpPos.Y - height/2)
                            -- Если на этого игрока нацелен Аим, красим бокс в желтый
                            PlayerBoxes[pIndex].Color = (currentTarget == player) and Color3.fromRGB(255, 255, 0) or ColorEnemy
                            PlayerBoxes[pIndex].Visible = true
                        end
                        
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

                        if Config.ShowTracers then
                            Tracers[pIndex].From = Vector2.new(cx, Camera.ViewportSize.Y)
                            Tracers[pIndex].To = Vector2.new(hrpPos.X, hrpPos.Y + height/2)
                            Tracers[pIndex].Visible = true
                        end
                        
                        pIndex = pIndex + 1
                    end
                end
            end
        end
    end
end)
