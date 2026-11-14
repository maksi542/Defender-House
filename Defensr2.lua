-- ==========================================
-- == МЕГА ESP + AIMBOT ОТ SMOKExR'S (RAYFIELD) ==
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Настройки
local Config = {
    Enabled = true, ShowBox = true, ShowHealth = true, ShowTracer = true, ShowName = true, 
    ShowSkeleton = true, ShowWeapon = true, ShowTeammates = true, ShowCounter = true, 
    ShowRadar = true, ShowDanger = true, ShowReload = true,
    -- Настройки Аимбота
    AimEnabled = false,
    AimPart = "Head",
    AimFOV = 150,
    AimSmooth = 5,
    ShowFOV = true
}

-- Цвета
local ColorEnemy = Color3.fromRGB(255, 50, 50)
local ColorAlly = Color3.fromRGB(50, 150, 255)
local ColorSkeleton = Color3.fromRGB(0, 255, 0)
local ColorWeapon = Color3.fromRGB(255, 255, 0) 
local ColorDead = Color3.fromRGB(150, 150, 150) 
local ColorDanger = Color3.fromRGB(255, 0, 0)
local ColorFOV = Color3.fromRGB(255, 255, 255)

-- ==========================================
-- == ЗАГРУЗКА RAYFIELD UI ==
-- ==========================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SMOKExR'S HUB",
    LoadingTitle = "Загрузка...",
    LoadingSubtitle = "by SMOKExR",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main ESP", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local AimTab = Window:CreateTab("Aimbot", 4483362458)

-- ==========================================
-- == МЕНЮ: ВКЛАДКА MAIN ESP ==
-- ==========================================
MainTab:CreateSection("Основные функции")
MainTab:CreateToggle({ Name = "Включить ESP", CurrentValue = true, Flag = "Enabled", Callback = function(Value) Config.Enabled = Value end })
MainTab:CreateToggle({ Name = "Боксы (Box)", CurrentValue = true, Flag = "ShowBox", Callback = function(Value) Config.ShowBox = Value end })
MainTab:CreateToggle({ Name = "Скелеты (Skeleton)", CurrentValue = true, Flag = "ShowSkeleton", Callback = function(Value) Config.ShowSkeleton = Value end })
MainTab:CreateToggle({ Name = "Трассеры (Tracers)", CurrentValue = true, Flag = "ShowTracer", Callback = function(Value) Config.ShowTracer = Value end })
MainTab:CreateToggle({ Name = "Имена", CurrentValue = true, Flag = "ShowName", Callback = function(Value) Config.ShowName = Value end })
MainTab:CreateToggle({ Name = "Здоровье", CurrentValue = true, Flag = "ShowHealth", Callback = function(Value) Config.ShowHealth = Value end })
MainTab:CreateToggle({ Name = "Оружие", CurrentValue = true, Flag = "ShowWeapon", Callback = function(Value) Config.ShowWeapon = Value end })

-- ==========================================
-- == МЕНЮ: ВКЛАДКА VISUALS ==
-- ==========================================
VisualTab:CreateSection("Дополнительно")
VisualTab:CreateToggle({ Name = "Счетчик Врагов", CurrentValue = true, Flag = "ShowCounter", Callback = function(Value) Config.ShowCounter = Value end })
VisualTab:CreateToggle({ Name = "Радар", CurrentValue = true, Flag = "ShowRadar", Callback = function(Value) Config.ShowRadar = Value end })
VisualTab:CreateToggle({ Name = "Опасная Зона", CurrentValue = true, Flag = "ShowDanger", Callback = function(Value) Config.ShowDanger = Value end })
VisualTab:CreateToggle({ Name = "Индикатор Перезарядки", CurrentValue = true, Flag = "ShowReload", Callback = function(Value) Config.ShowReload = Value end })
VisualTab:CreateToggle({ Name = "Показывать Тимейтов", CurrentValue = true, Flag = "ShowTeammates", Callback = function(Value) Config.ShowTeammates = Value end })

-- ==========================================
-- == МЕНЮ: ВКЛАДКА AIMBOT ==
-- ==========================================
AimTab:CreateSection("Настройки Аимбота (Зажми ПКМ)")

AimTab:CreateToggle({
    Name = "Включить Aim Assist (ПКМ)",
    CurrentValue = false,
    Flag = "AimEnabled",
    Callback = function(Value) Config.AimEnabled = Value end,
})

AimTab:CreateDropdown({
    Name = "Часть тела (Target Part)",
    Options = {"Head", "Torso"},
    CurrentOption = {"Head"},
    MultipleOptions = false,
    Flag = "AimPart",
    Callback = function(Options) Config.AimPart = Options[1] end,
})

AimTab:CreateSlider({
    Name = "Радиус (FOV)",
    Range = {50, 400}, Increment = 10, Suffix = "px", CurrentValue = 150, Flag = "AimFOV",
    Callback = function(Value) Config.AimFOV = Value end,
})

AimTab:CreateSlider({
    Name = "Плавность (Smooth)",
    Range = {1, 15}, Increment = 1, Suffix = "", CurrentValue = 5, Flag = "AimSmooth",
    Callback = function(Value) Config.AimSmooth = Value end,
})

AimTab:CreateToggle({
    Name = "Показывать круг FOV",
    CurrentValue = true, Flag = "ShowFOV",
    Callback = function(Value) Config.ShowFOV = Value end,
})

Rayfield:Notify({ Title = "SMOKExR'S HUB", Content = "Скрипт с Аимботом загружен!", Duration = 5 })

-- ==========================================
-- == ПУЛЫ ОБЪЕКТОВ ДЛЯ ESP ==
-- ==========================================
local PoolSize = 50 
local Boxes, Tracers, HealthBars, HealthBacks, NameTags, WeaponTags, ReloadTags = {}, {}, {}, {}, {}, {}, {}

for i = 1, PoolSize do
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false; table.insert(Boxes, box)
    local tr = Drawing.new("Line"); tr.Thickness = 1; tr.Visible = false; table.insert(Tracers, tr)
    local hback = Drawing.new("Square"); hback.Thickness = 1; hback.Filled = true; hback.Color = Color3.fromRGB(20, 20, 20); hback.ZIndex = 1; hback.Visible = false; table.insert(HealthBacks, hback)
    local hb = Drawing.new("Square"); hb.Thickness = 1; hb.Filled = true; hb.ZIndex = 2; hb.Visible = false; table.insert(HealthBars, hb)
    local nt = Drawing.new("Text"); nt.Center = true; nt.Outline = true; nt.Size = 14; nt.Visible = false; table.insert(NameTags, nt)
    local wt = Drawing.new("Text"); wt.Center = true; wt.Outline = true; wt.Size = 12; wt.Color = ColorWeapon; wt.Visible = false; table.insert(WeaponTags, wt)
    local rt = Drawing.new("Text"); rt.Center = true; rt.Outline = true; rt.Size = 14; rt.Color = Color3.fromRGB(255, 100, 0); rt.Visible = false; table.insert(ReloadTags, rt)
end

local function CreateSkeleton()
    local s = { head = Drawing.new("Line"), arms = Drawing.new("Line"), lLeg = Drawing.new("Line"), rLeg = Drawing.new("Line") }
    s.head.Thickness = 1; s.head.Color = ColorSkeleton; s.head.Visible = false
    s.arms.Thickness = 1; s.arms.Color = ColorSkeleton; s.arms.Visible = false
    s.lLeg.Thickness = 1; s.lLeg.Color = ColorSkeleton; s.lLeg.Visible = false
    s.rLeg.Thickness = 1; s.rLeg.Color = ColorSkeleton; s.rLeg.Visible = false
    return s
end
local S1, S2, S3, S4, S5, S6, S7, S8, S9, S10 = CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton()
local S11, S12, S13, S14, S15, S16, S17, S18, S19, S20 = CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton(), CreateSkeleton()
local SkeletonsList = {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15, S16, S17, S18, S19, S20}

-- ==========================================
-- == ОСТАЛЬНОЙ ИНТЕРФЕЙС ==
-- ==========================================
local EnemyCounter = Drawing.new("Text")
EnemyCounter.Visible = true; EnemyCounter.Outline = true; EnemyCounter.Size = 16
EnemyCounter.Color = Color3.fromRGB(255, 50, 50); EnemyCounter.Position = Vector2.new(10, 10); EnemyCounter.Text = "Врагов: 0"

local RadarBG = Drawing.new("Circle")
RadarBG.Visible = true; RadarBG.Thickness = 1; RadarBG.Color = Color3.fromRGB(50, 50, 50); RadarBG.Filled = true; RadarBG.Transparency = 0.5
RadarBG.Position = Vector2.new(Camera.ViewportSize.X - 100, Camera.ViewportSize.Y - 100); RadarBG.Radius = 80

local RadarBlips = {}
for i = 1, 30 do
    local blip = Drawing.new("Circle")
    blip.Visible = false; blip.Thickness = 1; blip.Filled = true; blip.Radius = 3
    table.insert(RadarBlips, blip)
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false; FOVCircle.Thickness = 1; FOVCircle.Color = ColorFOV; FOVCircle.Filled = false

local SplashText = Drawing.new("Text")
SplashText.Visible = true; SplashText.Center = true; SplashText.Outline = true; SplashText.Size = 36
SplashText.Color = Color3.fromRGB(0, 255, 255); SplashText.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
SplashText.Text = "Создатель: SMOKExR'S"
local splashTimer = tick() + 3.5

local function IsAlly(player)
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

-- ==========================================
-- == ФУНКЦИЯ АИМБОТА ==
-- ==========================================
local function GetClosestEnemy()
    local closest = nil
    local shortestDist = Config.AimFOV
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and not IsAlly(player) then
            local hum = player.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local targetPart = player.Character:FindFirstChild(Config.AimPart)
                if targetPart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if distToCenter < shortestDist then
                            shortestDist = distToCenter
                            closest = targetPart
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
    if SplashText.Visible and tick() > splashTimer then SplashText.Visible = false end

    -- Логика Аимбота (Только если зажата ПКМ)
    FOVCircle.Visible = Config.ShowFOV
    FOVCircle.Radius = Config.AimFOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    local isRMBPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)

    if Config.AimEnabled and isRMBPressed then
        local target = GetClosestEnemy()
        if target then
            local targetPos = target.Position
            local aimCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(aimCFrame, 1 / Config.AimSmooth)
        end
    end

    -- Отрисовка ESP
    for i = 1, PoolSize do
        Boxes[i].Visible = false; Tracers[i].Visible = false
        HealthBars[i].Visible = false; HealthBacks[i].Visible = false
        NameTags[i].Visible = false; WeaponTags[i].Visible = false; ReloadTags[i].Visible = false
    end
    for i = 1, #SkeletonsList do
        SkeletonsList[i].head.Visible = false; SkeletonsList[i].arms.Visible = false
        SkeletonsList[i].lLeg.Visible = false; SkeletonsList[i].rLeg.Visible = false
    end
    for i = 1, #RadarBlips do RadarBlips[i].Visible = false end
    
    RadarBG.Visible = Config.ShowRadar
    EnemyCounter.Visible = Config.ShowCounter

    if not Config.Enabled then return end
    local index = 1
    local skelIndex = 1
    local blipIndex = 1
    local enemiesAlive = 0

    local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
    local localLook = Camera.CFrame.LookVector

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and index <= PoolSize then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            
            local isAlly = IsAlly(player)
            local isDead = not hum or hum.Health <= 0
            
            if not isAlly and not isDead then enemiesAlive = enemiesAlive + 1 end

            if Config.ShowRadar and hrp and not isAlly and not isDead and blipIndex <= #RadarBlips then
                local relPos = hrp.Position - localPos
                local angle = math.atan2(relPos.X, relPos.Z) - math.atan2(localLook.X, localLook.Z)
                local dist = math.sqrt(relPos.X^2 + relPos.Z^2)
                if dist < 150 then
                    local radX = math.sin(angle) * (dist / 150 * 75)
                    local radY = math.cos(angle) * (dist / 150 * 75)
                    local blip = RadarBlips[blipIndex]
                    blip.Position = Vector2.new(RadarBG.Position.X + radX, RadarBG.Position.Y - radY)
                    blip.Color = ColorEnemy
                    blip.Visible = true
                    blipIndex = blipIndex + 1
                end
            end

            if not (isAlly and not Config.ShowTeammates) then
                if hrp and hum and head then
                    local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                        local currentColor = isAlly and ColorAlly or ColorEnemy
                        
                        if isDead then currentColor = ColorDead end
                        if Config.ShowDanger and not isAlly and not isDead and dist < 15 then
                            if tick() % 0.5 < 0.25 then currentColor = ColorDanger else currentColor = Color3.fromRGB(255, 255, 255) end
                        end

                        local headPos = Camera:WorldToViewportPoint(head.Position)
                        local height = math.abs(hrpPos.Y - headPos.Y) * 2.5
                        local width = height / 2

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
                            local nameText = player.Name .. " [" .. math.floor(dist) .. "m]"
                            if isDead then nameText = player.Name .. " [МЕРТВ]"; NameTags[index].Color = ColorDead else NameTags[index].Color = currentColor end
                            NameTags[index].Text = nameText; NameTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y - height/2) - 18); NameTags[index].Visible = true
                        end

                        if Config.ShowReload and not isDead then
                            local isReloading = false
                            local animator = hum:FindFirstChild("Animator")
                            if animator then
                                for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                    if string.find(track.Animation.Name:lower(), "reload") then isReloading = true; break end
                                end
                            end
                            if isReloading then
                                ReloadTags[index].Text = "[RELOAD]"; ReloadTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y - height/2) - 35); ReloadTags[index].Visible = true
                            end
                        end

                        if Config.ShowWeapon and not isDead then
                            local weaponName = nil
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then weaponName = tool.Name
                            else
                                local rightArm = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
                                if rightArm then
                                    for _, child in pairs(rightArm:GetChildren()) do
                                        if (child:IsA("Model") or child:IsA("Part") or child:IsA("MeshPart")) and not child.Name:match("Hand") and not child.Name:match("Arm") then weaponName = child.Name; break end
                                    end
                                end
                            end
                            if weaponName then
                                WeaponTags[index].Text = "[" .. weaponName .. "]"; WeaponTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y + height/2) + 5); WeaponTags[index].Visible = true
                            end
                        end

                        if Config.ShowTracer then
                            Tracers[index].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); Tracers[index].To = Vector2.new(hrpPos.X, hrpPos.Y + height/2)
                            Tracers[index].Color = currentColor; Tracers[index].Visible = true
                        end

                        if Config.ShowSkeleton and not isDead and skelIndex <= #SkeletonsList then
                            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                            local lArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                            local rArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                            local lLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                            local rLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                            
                            if head and torso then
                                local function GetPos(part)
                                    local p, onS = Camera:WorldToViewportPoint(part.Position)
                                    return Vector2.new(p.X, p.Y), onS
                                end
                                local hP, hOn = GetPos(head); local tP, tOn = GetPos(torso)
                                local currentSkel = SkeletonsList[skelIndex]
                                if hOn and tOn then
                                    currentSkel.head.From = hP; currentSkel.head.To = tP; currentSkel.head.Visible = true
                                    if lArm and rArm then
                                        local laP, laOn = GetPos(lArm); local raP, raOn = GetPos(rArm)
                                        if laOn and raOn then currentSkel.arms.From = laP; currentSkel.arms.To = raP; currentSkel.arms.Visible = true end
                                    end
                                   
