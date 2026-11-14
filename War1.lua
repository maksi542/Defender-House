-- ==========================================
-- == CREATOR SMOKExR'S | HARD AIM + NO RECOIL + OFFSET ==
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
    AimEnabled = true, 
    AimPart = "Head",
    AimFOV = 250,
    ShowFOV = true,
    NoRecoil = true,
    AimOffset = -0.3 -- СМЕЩЕНИЕ: -0.3 = чуть ниже головы. Если пули летят ниже, сделай 0.3 (без минуса)
}

-- Цвета
local ColorEnemy = Color3.fromRGB(255, 50, 50)
local ColorAlly = Color3.fromRGB(50, 150, 255)
local ColorSkeleton = Color3.fromRGB(0, 255, 0)
local ColorWeapon = Color3.fromRGB(255, 255, 0) 
local ColorDead = Color3.fromRGB(150, 150, 150) 
local ColorDanger = Color3.fromRGB(255, 0, 0)
local ColorFOV = Color3.fromRGB(255, 255, 255)
local ColorTheme = Color3.fromRGB(0, 255, 255)

-- ==========================================
-- == ФУНКЦИЯ NO RECOIL ==
-- ==========================================
local function RemoveCameraShake()
    if not Config.NoRecoil then return end
    for _, v in pairs(Camera:GetChildren()) do
        if v:IsA("BindableEvent") or v:IsA("ModuleScript") or v.Name:lower():find("shake") or v.Name:lower():find("recoil") then
            pcall(function() v:Destroy() end)
        end
    end
end
RunService.RenderStepped:Connect(RemoveCameraShake)

-- Заставка
local SplashTitle = Drawing.new("Text")
SplashTitle.Visible = true; SplashTitle.Center = true; SplashTitle.Outline = true; SplashTitle.Size = 45
SplashTitle.Color = ColorTheme; SplashTitle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 - 20)
SplashTitle.Text = "CREATOR SMOKExR'S"
local SplashSub = Drawing.new("Text")
SplashSub.Visible = true; SplashSub.Center = true; SplashSub.Outline = true; SplashSub.Size = 20
SplashSub.Color = Color3.fromRGB(255, 255, 255); SplashSub.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2 + 20)
SplashSub.Text = "Hard Aim & No Recoil"
local splashTimer = tick() + 5

-- Меню Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S",
    LoadingTitle = "SMOKExR'S HUB",
    LoadingSubtitle = "Hard Aim Edition",
    Theme = "Ocean",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main ESP", 4483362458)
local VisualTab = Window:CreateTab("Visuals", 4483362458)
local AimTab = Window:CreateTab("Aimbot", 4483362458)

MainTab:CreateSection("Основные функции")
MainTab:CreateToggle({ Name = "Включить ESP", CurrentValue = true, Callback = function(v) Config.Enabled = v end })
MainTab:CreateToggle({ Name = "Боксы", CurrentValue = true, Callback = function(v) Config.ShowBox = v end })
MainTab:CreateToggle({ Name = "Скелеты", CurrentValue = true, Callback = function(v) Config.ShowSkeleton = v end })
MainTab:CreateToggle({ Name = "Трассеры", CurrentValue = true, Callback = function(v) Config.ShowTracer = v end })
MainTab:CreateToggle({ Name = "Имена", CurrentValue = true, Callback = function(v) Config.ShowName = v end })
MainTab:CreateToggle({ Name = "Здоровье", CurrentValue = true, Callback = function(v) Config.ShowHealth = v end })
MainTab:CreateToggle({ Name = "Оружие", CurrentValue = true, Callback = function(v) Config.ShowWeapon = v end })

VisualTab:CreateSection("Дополнительно")
VisualTab:CreateToggle({ Name = "Счетчик Врагов", CurrentValue = true, Callback = function(v) Config.ShowCounter = v end })
VisualTab:CreateToggle({ Name = "Радар", CurrentValue = true, Callback = function(v) Config.ShowRadar = v end })
VisualTab:CreateToggle({ Name = "Опасная Зона", CurrentValue = true, Callback = function(v) Config.ShowDanger = v end })
VisualTab:CreateToggle({ Name = "Перезарядка", CurrentValue = true, Callback = function(v) Config.ShowReload = v end })
VisualTab:CreateToggle({ Name = "Тимейты", CurrentValue = true, Callback = function(v) Config.ShowTeammates = v end })

AimTab:CreateSection("Настройки Аимбота (Зажми ПКМ)")
AimTab:CreateToggle({ Name = "Включить Hard Aim", CurrentValue = true, Callback = function(v) Config.AimEnabled = v end })
AimTab:CreateToggle({ Name = "No Recoil", CurrentValue = true, Callback = function(v) Config.NoRecoil = v end })
AimTab:CreateDropdown({ Name = "Часть тела", Options = {"Head", "Torso"}, CurrentOption = {"Head"}, MultipleOptions = false, Callback = function(o) Config.AimPart = o[1] end })
AimTab:CreateSlider({ Name = "Радиус (FOV)", Range = {50, 500}, Increment = 10, CurrentValue = 250, Callback = function(v) Config.AimFOV = v end })

-- НОВЫЙ ПОЛЗУНОК: Смещение прицела (Калибровка)
AimTab:CreateSlider({ 
    Name = "Смещение прицела (Offset)", 
    Range = {-1, 1}, 
    Increment = 0.1, 
    CurrentValue = -0.3, 
    Callback = function(v) Config.AimOffset = v end 
})

AimTab:CreateToggle({ Name = "Показывать FOV", CurrentValue = true, Callback = function(v) Config.ShowFOV = v end })

Rayfield:Notify({ Title = "CREATOR SMOKExR'S", Content = "Скрипт обновлен! Настрой смещение в меню.", Duration = 5 })

-- ==========================================
-- == ПУЛЫ ОБЪЕКТОВ ==
-- ==========================================
local MAX_PLAYERS = 60 
local MAX_SKELETONS = 25 
local MAX_RADAR = 40 

local Boxes, Tracers, HealthBars, HealthBacks, NameTags, WeaponTags, ReloadTags = {}, {}, {}, {}, {}, {}, {}

for i = 1, MAX_PLAYERS do
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

local SkeletonsList = {}
for i = 1, MAX_SKELETONS do table.insert(SkeletonsList, CreateSkeleton()) end

local EnemyCounter = Drawing.new("Text")
EnemyCounter.Visible = true; EnemyCounter.Outline = true; EnemyCounter.Size = 16
EnemyCounter.Color = Color3.fromRGB(255, 50, 50); EnemyCounter.Position = Vector2.new(10, 10); EnemyCounter.Text = "Врагов: 0"

local RadarBG = Drawing.new("Circle")
RadarBG.Visible = true; RadarBG.Thickness = 2; RadarBG.Color = ColorTheme; RadarBG.Filled = false
RadarBG.Position = Vector2.new(Camera.ViewportSize.X - 100, Camera.ViewportSize.Y - 100); RadarBG.Radius = 80

local RadarGrid = Drawing.new("Circle")
RadarGrid.Visible = true; RadarGrid.Thickness = 1; RadarGrid.Color = Color3.fromRGB(100, 100, 100); RadarGrid.Filled = false
RadarGrid.Position = Vector2.new(Camera.ViewportSize.X - 100, Camera.ViewportSize.Y - 100); RadarGrid.Radius = 40

local RadarBlips = {}
for i = 1, MAX_RADAR do
    local blip = Drawing.new("Circle")
    blip.Visible = false; blip.Thickness = 1; blip.Filled = true; blip.Radius = 3
    table.insert(RadarBlips, blip)
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false; FOVCircle.Thickness = 2; FOVCircle.Color = ColorFOV; FOVCircle.Filled = false

local function IsAlly(player)
    if not player.Team or not LocalPlayer.Team then return false end
    return player.Team == LocalPlayer.Team
end

-- ==========================================
-- == ФУНКЦИЯ АИМБОТА (С УЧЕТОМ СМЕЩЕНИЯ) ==
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
                    -- БЕРЕМ ПОЗИЦИЮ И ДОБАВЛЯЕМ СМЕЩЕНИЕ (Offset)
                    local aimPosition = targetPart.Position + Vector3.new(0, Config.AimOffset, 0)
                    
                    local screenPos, onScreen = Camera:WorldToViewportPoint(aimPosition)
                    if onScreen then
                        local distToCenter = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if distToCenter < shortestDist then
                            local ray = Ray.new(Camera.CFrame.Position, (aimPosition - Camera.CFrame.Position).Unit * 500)
                            local hit, _ = workspace:FindPartOnRay(ray, LocalPlayer.Character)
                            
                            if hit and hit:IsDescendantOf(player.Character) then
                                shortestDist = distToCenter
                                closest = aimPosition -- Возвращаем позицию со смещением
                            end
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

    local isRMBPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    if Config.AimEnabled and isRMBPressed then
        local targetPos = GetClosestEnemy()
        if targetPos then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end

    -- Отрисовка ESP
    for i = 1, MAX_PLAYERS do
        Boxes[i].Visible = false; Tracers[i].Visible = false
        HealthBars[i].Visible = false; HealthBacks[i].Visible = false
        NameTags[i].Visible = false; WeaponTags[i].Visible = false; ReloadTags[i].Visible = false
    end
    for i = 1, #SkeletonsList do
        SkeletonsList[i].head.Visible = false; SkeletonsList[i].arms.Visible = false
        SkeletonsList[i].lLeg.Visible = false; SkeletonsList[i].rLeg.Visible = false
    end
    for i = 1, MAX_RADAR do RadarBlips[i].Visible = false end
    
    RadarBG.Visible = Config.ShowRadar
    RadarGrid.Visible = Config.ShowRadar
    EnemyCounter.Visible = Config.ShowCounter

    if not Config.Enabled then return end
    local index = 1; local skelIndex = 1; local blipIndex = 1; local enemiesAlive = 0
    local localPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
    local localLook = Camera.CFrame.LookVector

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and index <= MAX_PLAYERS then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            local isAlly = IsAlly(player)
            local isDead = not hum or hum.Health <= 0
            if not isAlly and not isDead then enemiesAlive = enemiesAlive + 1 end

            if Config.ShowRadar and hrp and not isAlly and not isDead and blipIndex <= MAX_RADAR then
                local relPos = hrp.Position - localPos
                local angle = math.atan2(relPos.X, relPos.Z) - math.atan2(localLook.X, localLook.Z)
                local dist = math.sqrt(relPos.X^2 + relPos.Z^2)
                if dist < 200 then
                    local radX = math.sin(angle) * (dist / 200 * 75); local radY = math.cos(angle) * (dist / 200 * 75)
                    local blip = RadarBlips[blipIndex]
                    blip.Position = Vector2.new(RadarBG.Position.X + radX, RadarBG.Position.Y - radY)
                    blip.Color = ColorEnemy; blip.Visible = true; blipIndex = blipIndex + 1
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
                            local nameText = player.Name .. " [" .. math.floor(dist) .. "m]"
                            if isDead then nameText = player.Name .. " [МЕРТВ]"; NameTags[index].Color = ColorDead else NameTags[index].Color = currentColor end
                            NameTags[index].Text = nameText; NameTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y - height/2) - 18); NameTags[index].Visible = true
                        end
                        if Config.ShowReload and not isDead then
                            local isReloading = false; local animator = hum:FindFirstChild("Animator")
                            if animator then for _, track in pairs(animator:GetPlayingAnimationTracks()) do if string.find(track.Animation.Name:lower(), "reload") then isReloading = true; break end end end
                            if isReloading then ReloadTags[index].Text = "[RELOAD]"; ReloadTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y - height/2) - 35); ReloadTags[index].Visible = true end
                        end
                        if Config.ShowWeapon and not isDead then
                            local weaponName = nil; local tool = char:FindFirstChildOfClass("Tool")
                            if tool then weaponName = tool.Name else
                                local rightArm = char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm")
                                if rightArm then for _, child in pairs(rightArm:GetChildren()) do if (child:IsA("Model") or child:IsA("Part") or child:IsA("MeshPart")) and not child.Name:match("Hand") and not child.Name:match("Arm") then weaponName = child.Name; break end end end
                            end
                            if weaponName then WeaponTags[index].Text = "[" .. weaponName .. "]"; WeaponTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y + height/2) + 5); WeaponTags[index].Visible = true end
                        end
                        if Config.ShowTracer then
                            Tracers[index].From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y); Tracers[index].To = Vector2.new(hrpPos.X, hrpPos.Y + height/2)
                            Tracers[index].Color = currentColor; Tracers[index].Visible = true
                        end
                        if Config.ShowSkeleton and not isDead and skelIndex <= MAX_SKELETONS then
                            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                            local lArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                            local rArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                            local lLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                            local rLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                            if head and torso then
                                local function GetPos(part) local p, onS = Camera:WorldToViewportPoint(part.Position) return Vector2.new(p.X, p.Y), onS end
                                local hP, hOn = GetPos(head); local tP, tOn = GetPos(torso)
                                local currentSkel = SkeletonsList[skelIndex]
                                if hOn and tOn then
                                    currentSkel.head.From = hP; currentSkel.head.To = tP; currentSkel.head.Visible = true
                                    if lArm and rArm then
                                        local laP, laOn = GetPos(lArm); local raP, raOn = GetPos(rArm)
                                        if laOn and raOn then currentSkel.arms.From = laP; currentSkel.arms.To = raP; currentSkel.arms.Visible = true end
                                    end
                                    if lLeg and rLeg then
                                        local llP, llOn = GetPos(lLeg); local rlP, rlOn = GetPos(rLeg)
                                        if llOn and rlOn then
                                            currentSkel.lLeg.From = tP; currentSkel.lLeg.To = llP; currentSkel.lLeg.Visible = true
                                            currentSkel.rLeg.From = tP; currentSkel.rLeg.To = rlP; currentSkel.rLeg.Visible = true
                                        end
                                    end
                                end
                            end
                            skelIndex = skelIndex + 1
                        end
                        index = index + 1
                    end
                end
            end
        end
    end
    if Config.ShowCounter then EnemyCounter.Text = "Живых врагов: " .. enemiesAlive end
end)
