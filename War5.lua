-- ==========================================
-- == CREATOR SMOKExR'S | JJK ULTIMATE ==
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local MAX_PLAYERS = 25 

local Config = {
    Enabled = true, 
    ShowBox = true, 
    ShowHealth = true, 
    ShowName = true, 
    ShowTeammates = true,
    ShowBlackFlash = true, 
    ShowCooldowns = true, 
    ShowArrows = true,      -- НОВОЕ: Индикатор движения
    HitboxExpander = false, -- НОВОЕ: Увеличение хитбокса
    
    AimEnabled = true, 
    AimPart = "Head", 
    AimFOV = 200, 
    ShowFOV = true,
    NoRecoil = true,
    Prediction = 0.15
}

local ColorEnemy = Color3.fromRGB(255, 50, 50)
local ColorAlly = Color3.fromRGB(0, 255, 255) 
local ColorDead = Color3.fromRGB(100, 100, 100) 
local ColorFOV = Color3.fromRGB(0, 150, 255) 
local ColorTheme = Color3.fromRGB(0, 200, 255) 
local ColorBlackFlash = Color3.fromRGB(255, 0, 0) 
local ColorCooldown = Color3.fromRGB(255, 165, 0) 
local ColorArrow = Color3.fromRGB(255, 255, 0) -- Желтый для стрелок

-- ==========================================
-- == WATERMARK + FPS ==
-- ==========================================
local WatermarkText = Drawing.new("Text")
WatermarkText.Visible = true; WatermarkText.Outline = true; WatermarkText.Size = 16
WatermarkText.Color = Color3.fromRGB(255, 255, 255); WatermarkText.Position = Vector2.new(15, 15)

local WatermarkAccent = Drawing.new("Square")
WatermarkAccent.Visible = true; WatermarkAccent.Filled = true; WatermarkAccent.Color = ColorTheme
WatermarkAccent.Size = Vector2.new(4, 40); WatermarkAccent.Position = Vector2.new(10, 15)

local fps = 0; local frameCount = 0; local lastTime = tick()
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        fps = frameCount; frameCount = 0; lastTime = tick()
        WatermarkText.Text = "CREATOR SMOKExR'S\nUser: " .. LocalPlayer.Name .. "\nGame: JJK Shenanigans\nFPS: " .. fps
    end
end)

-- ==========================================
-- == АНТИ-ОТДАЧА ==
-- ==========================================
local lastLookVector = Camera.CFrame.LookVector
local isShooting = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then isShooting = true end
end)
UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then isShooting = false end
end)
RunService.RenderStepped:Connect(function()
    if not Config.NoRecoil then lastLookVector = Camera.CFrame.LookVector; return end
    if isShooting then
        local currentLookVector = Camera.CFrame.LookVector
        if currentLookVector.Y > lastLookVector.Y + 0.0005 then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + lastLookVector)
        else
            lastLookVector = Camera.CFrame.LookVector
        end
    else
        lastLookVector = Camera.CFrame.LookVector
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
SplashSub.Text = "JJK ULTIMATE"
local splashTimer = tick() + 4

-- Меню
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "JJK Ultimate",
    Theme = "Midnight", 
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main ESP", 4483362458)
local AimTab = Window:CreateTab("Aimbot", 4483362458)
local JJKTab = Window:CreateTab("JJK Features", 4483362458)

MainTab:CreateSection("Визуал")
MainTab:CreateToggle({ Name = "Включить ESP", CurrentValue = true, Callback = function(v) Config.Enabled = v end })
MainTab:CreateToggle({ Name = "Боксы", CurrentValue = true, Callback = function(v) Config.ShowBox = v end })
MainTab:CreateToggle({ Name = "Имена", CurrentValue = true, Callback = function(v) Config.ShowName = v end })
MainTab:CreateToggle({ Name = "Здоровье", CurrentValue = true, Callback = function(v) Config.ShowHealth = v end })
MainTab:CreateToggle({ Name = "Тимейты", CurrentValue = true, Callback = function(v) Config.ShowTeammates = v end })

JJKTab:CreateSection("Jujutsu Features")
JJKTab:CreateToggle({ Name = "Black Flash Indicator", CurrentValue = true, Callback = function(v) Config.ShowBlackFlash = v end })
JJKTab:CreateToggle({ Name = "Cooldown Tracker", CurrentValue = true, Callback = function(v) Config.ShowCooldowns = v end })
JJKTab:CreateToggle({ Name = "Direction Arrows", CurrentValue = true, Callback = function(v) Config.ShowArrows = v end })
JJKTab:CreateToggle({ Name = "Hitbox Expander", CurrentValue = false, Callback = function(v) 
    Config.HitboxExpander = v 
    -- Сразу применяем ко всем игрокам
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Size = v and Vector3.new(6, 6, 6) or Vector3.new(2, 2, 1) -- Увеличиваем хитбокс
                hrp.Transparency = v and 0.5 or 1 -- Делаем его полупрозрачным, чтобы видеть
            end
        end
    end
end })

AimTab:CreateSection("Aimbot (ПКМ)")
AimTab:CreateToggle({ Name = "Включить Hard Aim", CurrentValue = true, Callback = function(v) Config.AimEnabled = v end })
AimTab:CreateToggle({ Name = "No Recoil", CurrentValue = true, Callback = function(v) Config.NoRecoil = v end })
AimTab:CreateDropdown({ Name = "Часть тела", Options = {"Head", "Torso"}, CurrentOption = {"Head"}, MultipleOptions = false, Callback = function(o) Config.AimPart = o[1] end })
AimTab:CreateSlider({ Name = "Радиус (FOV)", Range = {50, 500}, Increment = 10, CurrentValue = 200, Callback = function(v) Config.AimFOV = v end })
AimTab:CreateSlider({ Name = "Предсказание (Prediction)", Range = {0, 0.5}, Increment = 0.05, CurrentValue = 0.15, Callback = function(v) Config.Prediction = v end })
AimTab:CreateToggle({ Name = "Показывать FOV", CurrentValue = true, Callback = function(v) Config.ShowFOV = v end })

Rayfield:Notify({ Title = "CREATOR SMOKExR'S", Content = "JJK Ultimate загружен!", Duration = 5 })

-- ==========================================
-- == ПУЛЫ ОБЪЕКТОВ ==
-- ==========================================
local Boxes, HealthBars, HealthBacks, NameTags, BlackFlashTags, CooldownTags, ArrowLines = {}, {}, {}, {}, {}, {}, {}

for i = 1, MAX_PLAYERS do
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false; table.insert(Boxes, box)
    local hback = Drawing.new("Square"); hback.Thickness = 1; hback.Filled = true; hback.Color = Color3.fromRGB(20, 20, 20); hback.ZIndex = 1; hback.Visible = false; table.insert(HealthBacks, hback)
    local hb = Drawing.new("Square"); hb.Thickness = 1; hb.Filled = true; hb.ZIndex = 2; hb.Visible = false; table.insert(HealthBars, hb)
    local nt = Drawing.new("Text"); nt.Center = true; nt.Outline = true; nt.Size = 14; nt.Visible = false; table.insert(NameTags, nt)
    
    local bft = Drawing.new("Text"); bft.Center = true; bft.Outline = true; bft.Size = 14; bft.Color = ColorBlackFlash; bft.Visible = false; table.insert(BlackFlashTags, bft)
    local ct = Drawing.new("Text"); ct.Center = true; ct.Outline = true; ct.Size = 12; ct.Color = ColorCooldown; ct.Visible = false; table.insert(CooldownTags, ct)
    
    -- Линия для стрелки направления
    local arrow = Drawing.new("Line"); arrow.Thickness = 2; arrow.Color = ColorArrow; arrow.Visible = false; table.insert(ArrowLines, arrow)
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false; FOVCircle.Thickness = 2; FOVCircle.Color = ColorFOV; FOVCircle.Filled = false

local function IsAlly(player)
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

-- ==========================================
-- == ФУНКЦИЯ АИМБОТА ==
-- ==========================================
local function GetClosestTarget()
    local closest = nil
    local shortestDist = Config.AimFOV
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not IsAlly(player) then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local targetPart = player.Character:FindFirstChild(Config.AimPart) or player.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    local velocity = targetPart.AssemblyLinearVelocity or Vector3.new(0,0,0)
                    local predictedPos = targetPart.Position + (velocity * Config.Prediction)
                    
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
    if SplashTitle.Visible then
        if tick() > splashTimer then SplashTitle.Visible = false; SplashSub.Visible = false
        else SplashTitle.Size = 45 + math.sin(tick() * 5) * 3; SplashSub.Size = 20 + math.cos(tick() * 5) * 2 end
    end

    FOVCircle.Visible = Config.ShowFOV
    FOVCircle.Radius = Config.AimFOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local targetPos = nil
    if Config.AimEnabled then
        targetPos = GetClosestTarget()
    end

    local isRMBPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    if Config.AimEnabled and isRMBPressed and targetPos then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    end

    -- ОТРИСОВКА ESP
    for i = 1, MAX_PLAYERS do
        Boxes[i].Visible = false; HealthBars[i].Visible = false; HealthBacks[i].Visible = false
        NameTags[i].Visible = false; BlackFlashTags[i].Visible = false; CooldownTags[i].Visible = false
        ArrowLines[i].Visible = false
    end

    if not Config.Enabled then return end
    local index = 1

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and index <= MAX_PLAYERS then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head") or hrp
            
            local isAlly = IsAlly(player)
            local isDead = not hum or hum.Health <= 0

            -- Применяем Hitbox Expander динамически
            if Config.HitboxExpander and hrp then
                hrp.Size = Vector3.new(6, 6, 6)
                hrp.Transparency = 0.5
            elseif hrp and not Config.HitboxExpander then
                hrp.Size = Vector3.new(2, 2, 1)
                hrp.Transparency = 1
            end

            if not (isAlly and not Config.ShowTeammates) then
                if hrp and hum and head then
                    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                        local currentColor = isAlly and ColorAlly or ColorEnemy
                        if isDead then currentColor = ColorDead end
                        
                        local headPos = Camera:WorldToViewportPoint(head.Position)
                        local height = math.abs(hrpPos.Y - headPos.Y) * 2.5; local width = height / 2

                        if Config.ShowBox then
                            Boxes[index].Size = Vector2.new(width, height); Boxes[index].Position = Vector2.new(hrpPos.X - width/2, hrpPos.Y - height/2)
                            Boxes[index].Color = currentColor; Boxes[index].Visible = true
                        end
                        if Config.ShowHealth then
                            local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            HealthBacks[index].Size = Vector2.new(3, height); HealthBacks[index].Position = Vector2.new((hrpPos.X - width/2) - 6, hrpPos.Y - height/2); HealthBacks[index].Visible = true
                            HealthBars[index].Size = Vector2.new(3, height * hpPct); HealthBars[index].Position = Vector2.new((hrpPos.X - width/2) - 6, (hrpPos.Y + height/2) - (height * hpPct))
                            HealthBars[index].Color = Color3.fromRGB(0, 255, 0); HealthBars[index].Visible = true
                        end
                        if Config.ShowName then
                            local nameText = player.Name
                            if isDead then nameText = nameText .. " [МЕРТВ]" else nameText = nameText .. " [" .. math.floor(dist) .. "m]" end
                            NameTags[index].Text = nameText
                            NameTags[index].Color = isDead and ColorDead or currentColor
                            NameTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y - height/2) - 18); NameTags[index].Visible = true
                        end

                        -- BLACK FLASH
                        if Config.ShowBlackFlash and not isDead then
                            local isUsingBlackFlash = false
                            local animator = hum:FindFirstChild("Animator")
                            if animator then
                                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                    local animName = track.Animation.Name:lower()
                                    if string.find(animName, "black") or string.find(animName, "flash") or string.find(animName, "impact") then
                                        isUsingBlackFlash = true
                                        break
                                    end
                                end
                            end
                            if isUsingBlackFlash then
                                BlackFlashTags[index].Text = "[BLACK FLASH!]"
                                BlackFlashTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y - height/2) - 35)
                                BlackFlashTags[index].Visible = true
                            end
                        end

                        -- COOLDOWNS
                        if Config.ShowCooldowns and not isDead then
                            local cdText = ""
                            for _, obj in pairs(char:GetChildren()) do
                                if obj:IsA("NumberValue") or obj:IsA("IntValue") then
                                    if string.find(obj.Name:lower(), "cd") or string.find(obj.Name:lower(), "cooldown") then
                                        if obj.Value > 0 then cdText = cdText .. "[" .. obj.Name .. ": " .. math.floor(obj.Value) .. "s] " end
                                    end
                                end
                            end
                            if cdText ~= "" then
                                CooldownTags[index].Text = cdText
                                CooldownTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y + height/2) + 5)
                                CooldownTags[index].Visible = true
                            end
                        end

                        -- СТРЕЛКИ НАПРАВЛЕНИЯ (Direction Arrows)
                        if Config.ShowArrows and not isDead then
                            local velocity = hrp.AssemblyLinearVelocity
                            if velocity.Magnitude > 2 then -- Если он реально бежит
                                local startPos = Camera:WorldToViewportPoint(hrp.Position)
                                local endPos = Camera:WorldToViewportPoint(hrp.Position + (velocity.Unit * 4)) -- Линия длиной 4 стада в сторону движения
                                
                                ArrowLines[index].From = Vector2.new(startPos.X, startPos.Y)
                                ArrowLines[index].To = Vector2.new(endPos.X, endPos.Y)
                                ArrowLines[index].Visible = true
                            end
                        end

                        index = index + 1
                    end
                end
            end
        end
    end
end)
