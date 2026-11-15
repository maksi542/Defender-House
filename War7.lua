-- ==========================================
-- == CREATOR SMOKExR'S | TTK PERFECT AIM ==
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local MAX_PLAYERS = 20 

local Config = {
    Enabled = true, 
    ShowBox = true, 
    ShowHealth = true, 
    ShowName = true,
    ShowSkeleton = true, 
    ShowWeapon = true,   
    ShowBulletTrack = true, 
    ShowAimLine = true,     
    
    -- НОВЫЙ ИДЕАЛЬНЫЙ АИМ
    AimEnabled = true, 
    AimPart = "Head", 
    AimFOV = 150, 
    ShowFOV = true,
    NoRecoil = true,
    Prediction = 0.15,
    
    -- Настройки наведения
    AimSmooth = 4, -- Плавность прицеливания (ПКМ)
    HardLock = true -- Жесткая фиксация при стрельбе (ЛКМ)
}

-- Цвета
local ColorEnemy = Color3.fromRGB(255, 50, 50)
local ColorDead = Color3.fromRGB(100, 100, 100) 
local ColorFOV = Color3.fromRGB(0, 150, 255) 
local ColorTheme = Color3.fromRGB(0, 200, 255) 
local ColorSkeleton = Color3.fromRGB(255, 255, 255) 
local ColorBullet = Color3.fromRGB(255, 165, 0) 
local ColorAimLine = Color3.fromRGB(255, 0, 0) 

-- ==========================================
-- == WATERMARK + FPS ==
-- ==========================================
local WatermarkText = Drawing.new("Text")
WatermarkText.Visible = true; WatermarkText.Outline = true; WatermarkText.Size = 16
WatermarkText.Color = Color3.fromRGB(255, 255, 255); WatermarkText.Position = Vector2.new(15, 15)

local WatermarkAccent = Drawing.new("Square")
WatermarkAccent.Visible = true; WatermarkAccent.Filled = true; WatermarkAccent.Color = ColorTheme
WatermarkAccent.Size = Vector2.new(4, 55); WatermarkAccent.Position = Vector2.new(10, 15)

local startTime = tick()
local fps = 0; local frameCount = 0; local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastTime >= 1 then
        fps = frameCount; frameCount = 0; lastTime = tick()
        local uptime = math.floor(tick() - startTime)
        local minutes = math.floor(uptime / 60)
        local seconds = uptime % 60
        
        WatermarkText.Text = "CREATOR SMOKExR'S\nUser: " .. LocalPlayer.Name .. "\nGame: TTK Testing\nFPS: " .. fps .. " | Time: " .. minutes .. "m " .. seconds .. "s"
    end
end)

-- ==========================================
-- == УМНАЯ АНТИ-ОТДАЧА ==
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
SplashSub.Text = "PERFECT AIM EDITION"
local splashTimer = tick() + 4

-- Меню
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "TTK Perfect Aim",
    Theme = "Midnight", 
    ConfigurationSaving = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main ESP", 4483362458)
local AimTab = Window:CreateTab("Aimbot", 4483362458)
local TrackTab = Window:CreateTab("Bullet Track", 4483362458)

MainTab:CreateSection("Visuals")
MainTab:CreateToggle({ Name = "Enable ESP", CurrentValue = true, Callback = function(v) Config.Enabled = v end })
MainTab:CreateToggle({ Name = "Boxes", CurrentValue = true, Callback = function(v) Config.ShowBox = v end })
MainTab:CreateToggle({ Name = "Skeletons", CurrentValue = true, Callback = function(v) Config.ShowSkeleton = v end })
MainTab:CreateToggle({ Name = "Names", CurrentValue = true, Callback = function(v) Config.ShowName = v end })
MainTab:CreateToggle({ Name = "Health", CurrentValue = true, Callback = function(v) Config.ShowHealth = v end })
MainTab:CreateToggle({ Name = "Weapon", CurrentValue = true, Callback = function(v) Config.ShowWeapon = v end })

TrackTab:CreateSection("Bullet Tracking")
TrackTab:CreateToggle({ Name = "Bullet Track (Shots)", CurrentValue = true, Callback = function(v) Config.ShowBulletTrack = v end })
TrackTab:CreateToggle({ Name = "Enemy Aim Line (Laser)", CurrentValue = true, Callback = function(v) Config.ShowAimLine = v end })

AimTab:CreateSection("Perfect Aimbot")
AimTab:CreateToggle({ Name = "Enable Aimbot", CurrentValue = true, Callback = function(v) Config.AimEnabled = v end })
AimTab:CreateToggle({ Name = "Hard Lock (When Shooting)", CurrentValue = true, Callback = function(v) Config.HardLock = v end })
AimTab:CreateToggle({ Name = "No Recoil", CurrentValue = true, Callback = function(v) Config.NoRecoil = v end })
AimTab:CreateDropdown({ Name = "Target Part", Options = {"Head", "Torso"}, CurrentOption = {"Head"}, MultipleOptions = false, Callback = function(o) Config.AimPart = o[1] end })
AimTab:CreateSlider({ Name = "FOV Radius", Range = {50, 500}, Increment = 10, CurrentValue = 150, Callback = function(v) Config.AimFOV = v end })
AimTab:CreateSlider({ Name = "Aim Smoothness (RMB)", Range = {1, 15}, Increment = 1, CurrentValue = 4, Callback = function(v) Config.AimSmooth = v end })
AimTab:CreateSlider({ Name = "Prediction", Range = {0, 0.5}, Increment = 0.05, CurrentValue = 0.15, Callback = function(v) Config.Prediction = v end })
AimTab:CreateToggle({ Name = "Show FOV", CurrentValue = true, Callback = function(v) Config.ShowFOV = v end })

Rayfield:Notify({ Title = "CREATOR SMOKExR'S", Content = "Perfect Aim Loaded!", Duration = 5 })

-- ==========================================
-- == ПУЛЫ ОБЪЕКТОВ ==
-- ==========================================
local Boxes, HealthBars, HealthBacks, NameTags, WeaponTags = {}, {}, {}, {}, {}
local SkelPools = {}
local BulletTracks = {} 
local AimLines = {}     

for i = 1, MAX_PLAYERS do
    local box = Drawing.new("Square"); box.Thickness = 1; box.Filled = false; box.Visible = false; table.insert(Boxes, box)
    local hback = Drawing.new("Square"); hback.Thickness = 1; hback.Filled = true; hback.Color = Color3.fromRGB(20, 20, 20); hback.ZIndex = 1; hback.Visible = false; table.insert(HealthBacks, hback)
    local hb = Drawing.new("Square"); hb.Thickness = 1; hb.Filled = true; hb.ZIndex = 2; hb.Visible = false; table.insert(HealthBars, hb)
    local nt = Drawing.new("Text"); nt.Center = true; nt.Outline = true; nt.Size = 14; nt.Visible = false; table.insert(NameTags, nt)
    local wt = Drawing.new("Text"); wt.Center = true; wt.Outline = true; wt.Size = 12; wt.Color = Color3.fromRGB(255, 255, 0); wt.Visible = false; table.insert(WeaponTags, wt)
    
    local skel = {
        Head = Drawing.new("Line"), ArmL = Drawing.new("Line"), ArmR = Drawing.new("Line"),
        LegL = Drawing.new("Line"), LegR = Drawing.new("Line")
    }
    for _, line in pairs(skel) do line.Thickness = 1; line.Color = ColorSkeleton; line.Visible = false end
    table.insert(SkelPools, skel)

    local btrack = Drawing.new("Line"); btrack.Thickness = 2; btrack.Color = ColorBullet; btrack.Visible = false
    table.insert(BulletTracks, btrack)

    local aline = Drawing.new("Line"); aline.Thickness = 1; aline.Color = ColorAimLine; aline.Visible = false
    table.insert(AimLines, aline)
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false; FOVCircle.Thickness = 2; FOVCircle.Color = ColorFOV; FOVCircle.Filled = false

-- ==========================================
-- == ФУНКЦИЯ ИДЕАЛЬНОГО АИМА ==
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
                    local velocity = targetPart.AssemblyLinearVelocity or Vector3.new(0,0,0)
                    -- Предсказание движения (чтобы пули летели в бегущего)
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

    -- ГИБРИДНАЯ ЛОГИКА АИМА
    local isRMBPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local isLMBPressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)

    if Config.AimEnabled and targetPos then
        if isLMBPressed and Config.HardLock then
            -- ЖЕСТКАЯ ФИКСАЦИЯ ПРИ СТРЕЛЬБЕ (Пули летят ровно)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        elseif isRMBPressed then
            -- ПЛАВНОЕ ПРИЦЕЛИВАНИЕ (Магнит, чтобы античит не спалил)
            local aimCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
            Camera.CFrame = Camera.CFrame:Lerp(aimCFrame, 1 / Config.AimSmooth)
        end
    end

    -- ОЧИСТКА
    for i = 1, MAX_PLAYERS do
        Boxes[i].Visible = false; HealthBars[i].Visible = false; HealthBacks[i].Visible = false
        NameTags[i].Visible = false; WeaponTags[i].Visible = false
        BulletTracks[i].Visible = false; AimLines[i].Visible = false
        for _, line in pairs(SkelPools[i]) do line.Visible = false end
    end

    if not Config.Enabled then return end
    local index = 1

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and index <= MAX_PLAYERS then
            local char = player.Character
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head") or hrp
            local isDead = not hum or hum.Health <= 0

            if hrp and hum and head then
                local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                    local currentColor = isDead and ColorDead or ColorEnemy
                    
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
                        if isDead then nameText = nameText .. " [DEAD]" else nameText = nameText .. " [" .. math.floor(dist) .. "m]" end
                        NameTags[index].Text = nameText
                        NameTags[index].Color = currentColor
                        NameTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y - height/2) - 18); NameTags[index].Visible = true
                    end
                    
                    if not isDead then
                        local tool = char:FindFirstChildOfClass("Tool")
                        local gunPart = tool and (tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart"))
                        
                        if tool and Config.ShowWeapon then
                            WeaponTags[index].Text = "[" .. tool.Name .. "]"
                            WeaponTags[index].Position = Vector2.new(hrpPos.X, (hrpPos.Y + height/2) + 5)
                            WeaponTags[index].Visible = true
                        end

                        if Config.ShowAimLine and gunPart then
                            local aimEnd = gunPart.Position + (gunPart.CFrame.LookVector * 100)
                            local startS, onStart = Camera:WorldToViewportPoint(gunPart.Position)
                            local endS, onEnd = Camera:WorldToViewportPoint(aimEnd)
                            if onStart and onEnd then
                                AimLines[index].From = Vector2.new(startS.X, startS.Y)
                                AimLines[index].To = Vector2.new(endS.X, endS.Y)
                                AimLines[index].Visible = true
                            end
                        end

                        if Config.ShowBulletTrack then
                            local muzzleFlash = gunPart and gunPart:FindFirstChild("MuzzleFlash")
                            if muzzleFlash and muzzleFlash.Visible then
                                local startS, onStart = Camera:WorldToViewportPoint(gunPart.Position)
                                if onStart then
                                    BulletTracks[index].From = Vector2.new(startS.X, startS.Y)
                                    BulletTracks[index].To = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                                    BulletTracks[index].Visible = true
                                end
                            end
                        end
                    end

                    if Config.ShowSkeleton and not isDead then
                        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or hrp
                        local lArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") or hrp
                        local rArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm") or hrp
                        local lLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") or hrp
                        local rLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg") or hrp

                        local function GetPos(part) local p, onS = Camera:WorldToViewportPoint(part.Position) return Vector2.new(p.X, p.Y), onS end
                        local hP, hOn = GetPos(head); local tP, tOn = GetPos(torso)
                        local laP, laOn = GetPos(lArm); local raP, raOn = GetPos(rArm)
                        local llP, llOn = GetPos(lLeg); local rlP, rlOn = GetPos(rLeg)
                        
                        local skel = SkelPools[index]
                        if hOn and tOn then skel.Head.From = hP; skel.Head.To = tP; skel.Head.Visible = true end
                        if tOn and laOn and raOn then
                            skel.ArmL.From = tP; skel.ArmL.To = laP; skel.ArmL.Visible = true
                            skel.ArmR.From = tP; skel.ArmR.To = raP; skel.ArmR.Visible = true
                        end
                        if tOn and llOn and rlOn then
                            skel.LegL.From = tP; skel.LegL.To = llP; skel.LegL.Visible = true
                            skel.LegR.From = tP; skel.LegR.To = rlP; skel.LegR.Visible = true
                        end
                    end

                    index = index + 1
                end
            end
        end
    end
end)
