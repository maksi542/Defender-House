-- language: Lua (Luau), file: smokexr_premium.lua, target: Voxel Wars, executor: Xeno
-- CREATOR SMOKExR'S | PREMIUM EDITION | FOV Circle | 360 Compass Radar | HP Bars | Full Team Fix

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    Aimbot = {
        Enabled = true,
        Key = Enum.KeyCode.Q,
        FOV = 150,
        Smoothness = 0.05,
        WallCheck = true,
        TeamCheck = true, -- Теперь проверяет корректно
        Part = "Head",
        NoRecoil = true,
        Prediction = 0.15,
    },
    ESP = {
        Enabled = true,
        Box = true,
        Name = true,
        Distance = true,
        Health = true, -- НОВОЕ
        Tracer = true,
        MaxDistance = 1000,
        TeamCheck = true, 
        BoxColor = Color3.fromRGB(255, 50, 50),
        NameColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 50, 50),
        Thickness = 1,
    },
    Radar = {
        Enabled = true,
        Size = 180,
        Color = Color3.fromRGB(255, 50, 50),
    }
}

-- ============================================================
-- PREMIUM SPLASH & UI (Фиолетово-черный стиль)
-- ============================================================
local SplashGui = Instance.new("ScreenGui")
SplashGui.Name = "SmokeSplash"
SplashGui.ResetOnSpawn = false
SplashGui.Parent = game.CoreGui

local SplashFrame = Instance.new("Frame")
SplashFrame.Size = UDim2.new(0, 500, 0, 200)
SplashFrame.Position = UDim2.new(0.5, -250, 0.5, -100)
SplashFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
SplashFrame.BorderSizePixel = 0
SplashFrame.Parent = SplashGui
Instance.new("UICorner", SplashFrame).CornerRadius = UDim.new(0, 12)
local SplashGlow = Instance.new("UIStroke")
SplashGlow.Color = Color3.fromRGB(200, 0, 255)
SplashGlow.Thickness = 2
SplashGlow.Transparency = 0.1
SplashGlow.Parent = SplashFrame

local SplashTitle = Instance.new("TextLabel")
SplashTitle.Size = UDim2.new(1, 0, 0, 60)
SplashTitle.Position = UDim2.new(0, 0, 0, 30)
SplashTitle.BackgroundTransparency = 1
SplashTitle.Text = "CREATOR SMOKExR'S"
SplashTitle.TextColor3 = Color3.fromRGB(200, 0, 255)
SplashTitle.Font = Enum.Font.GothamBlack
SplashTitle.TextSize = 32
SplashTitle.Parent = SplashFrame

local SplashSub = Instance.new("TextLabel")
SplashSub.Size = UDim2.new(1, 0, 0, 30)
SplashSub.Position = UDim2.new(0, 0, 0, 85)
SplashSub.BackgroundTransparency = 1
SplashSub.Text = "PREMIUM EDITION | Voxel Wars"
SplashSub.TextColor3 = Color3.fromRGB(180, 180, 180)
SplashSub.Font = Enum.Font.Gotham
SplashSub.TextSize = 14
SplashSub.Parent = SplashFrame

task.spawn(function()
    task.wait(4)
    TweenService:Create(SplashFrame, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
    for _, c in ipairs(SplashFrame:GetDescendants()) do
        if c:IsA("TextLabel") then TweenService:Create(c, TweenInfo.new(0.6), { TextTransparency = 1 }):Play() end
    end
    TweenService:Create(SplashGlow, TweenInfo.new(0.6), { Transparency = 1 }):Play()
    task.wait(0.7)
    SplashGui:Destroy()
end)

-- ============================================================
-- HELPERS
-- ============================================================
local function get_character()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hum and hrp and hum.Health > 0 then return char, hum, hrp end
    return nil
end

local function is_alive(plr)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function world_to_screen(pos)
    local screen, on_screen = Camera:WorldToViewportPoint(pos)
    if on_screen and screen.Z > 0 then return Vector2.new(screen.X, screen.Y) end
    return nil
end

-- ИСПРАВЛЕННАЯ ПРОВЕРКА ТИМЕЙТОВ
local function is_teammate(plr)
    if not Config.ESP.TeamCheck then return false end -- Если выключено, светим всех
    if plr == LocalPlayer then return true end
    
    -- Если у игрока есть Team, проверяем Team. Если нет — проверяем цвет.
    if plr.Team and LocalPlayer.Team then
        return plr.Team == LocalPlayer.Team
    end
    
    -- Цветовой фолбэк
    local char = plr.Character
    local my_char = LocalPlayer.Character
    if char and my_char then
        local head = char:FindFirstChild("Head")
        local my_head = my_char:FindFirstChild("Head")
        if head and my_head then
            -- Сравниваем по RGB, с допуском
            local c1 = head.Color
            local c2 = my_head.Color
            if math.abs(c1.R - c2.R) < 0.1 and math.abs(c1.G - c2.G) < 0.1 and math.abs(c1.B - c2.B) < 0.1 then
                return true
            end
        end
    end
    return false
end

-- ============================================================
-- 1. FOV CIRCLE (Центр экрана)
-- ============================================================
local fov_gui = Instance.new("ScreenGui")
fov_gui.Name = "SmokeFOV"
fov_gui.ResetOnSpawn = false
fov_gui.Parent = game.CoreGui

local fov_circle = Instance.new("Frame")
fov_circle.Size = UDim2.new(0, 0, 0, 0) -- Обновляется в цикле
fov_circle.Position = UDim2.new(0.5, 0, 0.5, 0)
fov_circle.AnchorPoint = Vector2.new(0.5, 0.5) -- Центрируем
fov_circle.BackgroundTransparency = 1
fov_circle.Parent = fov_gui

local fov_stroke = Instance.new("UIStroke")
fov_stroke.Color = Color3.fromRGB(200, 0, 255)
fov_stroke.Thickness = 1
fov_stroke.Transparency = 0.5
fov_stroke.Parent = fov_circle

Instance.new("UICorner", fov_circle).CornerRadius = UDim.new(1, 0)

RunService.RenderStepped:Connect(function()
    if not Config.Aimbot.Enabled then
        fov_circle.Visible = false
        return
    end
    fov_circle.Visible = true
    fov_circle.Size = UDim2.new(0, Config.Aimbot.FOV * 2, 0, Config.Aimbot.FOV * 2)
end)

-- ============================================================
-- 2. 360 COMPASS RADAR (Компас над FOV)
-- ============================================================
local radar_gui = Instance.new("ScreenGui")
radar_gui.Name = "SmokeRadar"
radar_gui.ResetOnSpawn = false
radar_gui.Parent = game.CoreGui

local radar_frame = Instance.new("Frame")
radar_frame.Size = UDim2.new(0, Config.Radar.Size, 0, Config.Radar.Size)
radar_frame.Position = UDim2.new(0.5, -Config.Radar.Size/2, 0, 100)
radar_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
radar_frame.BackgroundTransparency = 0.6
radar_frame.BorderSizePixel = 0
radar_frame.Parent = radar_gui
Instance.new("UICorner", radar_frame).CornerRadius = UDim.new(1, 0)
local radar_stroke = Instance.new("UIStroke")
radar_stroke.Color = Color3.fromRGB(200, 0, 255)
radar_stroke.Thickness = 2
radar_stroke.Parent = radar_frame

local radar_player_arrow = Instance.new("ImageLabel")
radar_player_arrow.Size = UDim2.new(0, 16, 0, 16)
radar_player_arrow.Position = UDim2.new(0.5, -8, 0.5, -8)
radar_player_arrow.BackgroundTransparency = 1
radar_player_arrow.Image = "rbxassetid://1483673453"
radar_player_arrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
radar_player_arrow.Parent = radar_frame

local radar_blips = {}

RunService.RenderStepped:Connect(function()
    for _, b in ipairs(radar_blips) do b:Destroy() end
    radar_blips = {}
    if not Config.Radar.Enabled then
        radar_frame.Visible = false
        return
    end
    radar_frame.Visible = true
    radar_frame.Size = UDim2.new(0, Config.Radar.Size, 0, Config.Radar.Size)
    radar_frame.Position = UDim2.new(0.5, -Config.Radar.Size/2, 0, 100)
    
    local my_char, my_hum, my_hrp = get_character()
    if not my_char then return end
    
    -- Вращаем центральную стрелку по камере
    local cam_look = Camera.CFrame.LookVector
    local cam_angle = math.deg(math.atan2(cam_look.X, cam_look.Z))
    radar_player_arrow.Rotation = cam_angle
    
    local center = Vector2.new(Config.Radar.Size / 2, Config.Radar.Size / 2)
    local radius = Config.Radar.Size / 2 - 15
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) then continue end
        if Config.ESP.TeamCheck and is_teammate(plr) then continue end -- Фильтр
        
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local dist = (hrp.Position - my_hrp.Position).Magnitude
        if dist > Config.ESP.MaxDistance then continue end
        
        local relative_pos = Camera.CFrame:PointToObjectSpace(hrp.Position)
        local angle = math.atan2(relative_pos.X, relative_pos.Z)
        
        local r_dist = math.min(dist / Config.ESP.MaxDistance * radius, radius)
        local rx = center.X + math.sin(angle) * r_dist
        local ry = center.Y - math.cos(angle) * r_dist
        
        local blip = Instance.new("Frame")
        blip.Size = UDim2.new(0, 6, 0, 6)
        blip.Position = UDim2.new(0, rx - 3, 0, ry - 3)
        blip.BackgroundColor3 = Config.Radar.Color
        blip.BorderSizePixel = 0
        blip.Parent = radar_frame
        Instance.new("UICorner", blip).CornerRadius = UDim.new(1, 0)
        
        table.insert(radar_blips, blip)
    end
end)

-- ============================================================
-- 3. ULTIMATE ESP (Box, Name, HP, Dist, Tracer)
-- ============================================================
local esp_cache = {}

local function create_esp(plr)
    if plr == LocalPlayer then return end
    
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = Color3.fromRGB(255, 50, 50)
    box.Filled = false
    box.Visible = false
    
    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Visible = false
    
    local dist = Drawing.new("Text")
    dist.Size = 12
    dist.Center = true
    dist.Outline = true
    dist.Color = Color3.fromRGB(200, 200, 200)
    dist.Visible = false

    local hp_bg = Drawing.new("Square")
    hp_bg.Thickness = 0
    hp_bg.Filled = true
    hp_bg.Color = Color3.fromRGB(0, 0, 0)
    hp_bg.Visible = false

    local hp_bar = Drawing.new("Square")
    hp_bar.Thickness = 0
    hp_bar.Filled = true
    hp_bar.Color = Color3.fromRGB(0, 255, 0)
    hp_bar.Visible = false
    
    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Color = Color3.fromRGB(255, 50, 50)
    tracer.Visible = false

    esp_cache[plr] = { box = box, name = name, dist = dist, hp_bg = hp_bg, hp_bar = hp_bar, tracer = tracer }
end

for _, plr in ipairs(Players:GetPlayers()) do create_esp(plr) end
Players.PlayerAdded:Connect(create_esp)
Players.PlayerRemoving:Connect(function(plr)
    local e = esp_cache[plr]
    if e then
        for _, v in pairs(e) do v:Remove() end
        esp_cache[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for plr, e in pairs(esp_cache) do
        -- ФИКС: Если TeamCheck выключен, светим ВСЕХ.
        if not Config.ESP.Enabled or not is_alive(plr) or (Config.ESP.TeamCheck and is_teammate(plr)) then
            e.box.Visible = false e.name.Visible = false e.dist.Visible = false
            e.hp_bg.Visible = false e.hp_bar.Visible = false e.tracer.Visible = false
            continue
        end
        
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not hrp or not head or not hum then
            e.box.Visible = false e.name.Visible = false e.dist.Visible = false
            e.hp_bg.Visible = false e.hp_bar.Visible = false e.tracer.Visible = false
            continue
        end
        
        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
        if distance > Config.ESP.MaxDistance then
            e.box.Visible = false e.name.Visible = false e.dist.Visible = false
            e.hp_bg.Visible = false e.hp_bar.Visible = false e.tracer.Visible = false
            continue
        end
        
        local head_screen = world_to_screen(head.Position + Vector3.new(0, 0.5, 0))
        local foot_screen = world_to_screen(hrp.Position - Vector3.new(0, 3, 0))
        if not head_screen or not foot_screen then
            e.box.Visible = false e.name.Visible = false e.dist.Visible = false
            e.hp_bg.Visible = false e.hp_bar.Visible = false e.tracer.Visible = false
            continue
        end
        
        local height = math.abs(head_screen.Y - foot_screen.Y)
        local width = height * 0.5
        local x = head_screen.X - width / 2
        local y = head_screen.Y
        
        e.box.Visible = Config.ESP.Box
        e.box.Size = Vector2.new(width, height)
        e.box.Position = Vector2.new(x, y)
        e.box.Color = Config.ESP.BoxColor
        e.box.Thickness = Config.ESP.Thickness
        
        e.name.Text = plr.Name
        e.name.Position = Vector2.new(head_screen.X, y - 20) -- Чуть выше для HP бара
        e.name.Visible = Config.ESP.Name
        e.name.Color = Config.ESP.NameColor
        
        e.dist.Text = string.format("%dm", math.floor(distance))
        e.dist.Position = Vector2.new(head_screen.X, y + height + 2)
        e.dist.Visible = Config.ESP.Distance
        
        -- HP BAR (Слева от бокса)
        if Config.ESP.Health then
            local hp_pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            local bar_h = height
            local bar_w = 4
            local bar_x = x - 8
            local bar_y = y
            
            e.hp_bg.Visible = true
            e.hp_bg.Size = Vector2.new(bar_w, bar_h)
            e.hp_bg.Position = Vector2.new(bar_x, bar_y)
            
            e.hp_bar.Visible = true
            e.hp_bar.Size = Vector2.new(bar_w, bar_h * hp_pct)
            e.hp_bar.Position = Vector2.new(bar_x, bar_y + bar_h * (1 - hp_pct)) -- Заполняется снизу вверх
            -- Цвет от красного к зеленому
            e.hp_bar.Color = Color3.fromRGB(255 * (1 - hp_pct), 255 * hp_pct, 0)
        else
            e.hp_bg.Visible = false
            e.hp_bar.Visible = false
        end
        
        e.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        e.tracer.To = Vector2.new(head_screen.X, y + height)
        e.tracer.Visible = Config.ESP.Tracer
        e.tracer.Color = Config.ESP.TracerColor
    end
end)

-- ============================================================
-- 4. AIMBOT (No Recoil, Prediction)
-- ============================================================
RunService.RenderStepped:Connect(function()
    if not Config.Aimbot.Enabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    
    local char, hum, hrp = get_character()
    if not char then return end
    
    local best, best_dist = nil, Config.Aimbot.FOV
    local center = Camera.ViewportSize / 2
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) then continue end
        if Config.Aimbot.TeamCheck and is_teammate(plr) then continue end
        
        local part = plr.Character:FindFirstChild(Config.Aimbot.Part) or plr.Character:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        
        if Config.Aimbot.WallCheck then
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
            local result = Workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, params)
            if result then continue end
        end
        
        local screen = world_to_screen(part.Position)
        if not screen then continue end
        local dist = (screen - center).Magnitude
        if dist < best_dist then
            best, best_dist = part, dist
        end
    end
    
    if best then
        local velocity = best.AssemblyLinearVelocity or Vector3.zero
        local predicted_pos = best.Position + velocity * Config.Aimbot.Prediction
        local target_cf = CFrame.new(Camera.CFrame.Position, predicted_pos)
        
        if Config.Aimbot.NoRecoil then
            target_cf = target_cf * CFrame.Angles(math.rad(-1.5), 0, 0) -- Компенсация отдачи
        end
        
        Camera.CFrame = Camera.CFrame:Lerp(target_cf, Config.Aimbot.Smoothness)
    end
end)

-- ============================================================
-- 5. RAYFIELD UI (Premium Settings)
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S | PREMIUM",
    LoadingTitle = "SMOKExR'S",
    LoadingSubtitle = "Premium Hub",
    ConfigurationSaving = { Enabled = true, FolderName = "SmokePremium", FileName = "Voxel" },
    KeySystem = false,
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visual ESP", 4483362458)
local RadarTab = Window:CreateTab("Radar & FOV", 4483362458)

-- Combat
CombatTab:CreateToggle({ Name = "Aimbot Master", CurrentValue = true, Flag = "aim_on", Callback = function(v) Config.Aimbot.Enabled = v end })
CombatTab:CreateSlider({ Name = "FOV Radius", Range = { 50, 500 }, Increment = 10, Suffix = "px", CurrentValue = 150, Flag = "aim_fov", Callback = function(v) Config.Aimbot.FOV = v end })
CombatTab:CreateSlider({ Name = "Smoothness (Lower=Snappier)", Range = { 0.01, 1 }, Increment = 0.01, CurrentValue = 0.05, Flag = "aim_sm", Callback = function(v) Config.Aimbot.Smoothness = v end })
CombatTab:CreateSlider({ Name = "Prediction", Range = { 0, 0.5 }, Increment = 0.01, Suffix = "s", CurrentValue = 0.15, Flag = "aim_pred", Callback = function(v) Config.Aimbot.Prediction = v end })
CombatTab:CreateToggle({ Name = "No Recoil (Fix)", CurrentValue = true, Flag = "aim_rec", Callback = function(v) Config.Aimbot.NoRecoil = v end })
CombatTab:CreateToggle({ Name = "Wall Check", CurrentValue = true, Flag = "aim_wall", Callback = function(v) Config.Aimbot.WallCheck = v end })

-- Visual ESP
VisualTab:CreateSection("Player ESP")
VisualTab:CreateToggle({ Name = "Enable ESP", CurrentValue = true, Flag = "esp_on", Callback = function(v) Config.ESP.Enabled = v end })
VisualTab:CreateToggle({ Name = "Ignore Teammates (OFF = Show All)", CurrentValue = false, Flag = "esp_team", Callback = function(v) Config.ESP.TeamCheck = v end }) -- По дефолту выключено, чтобы светить всех
VisualTab:CreateToggle({ Name = "Box", CurrentValue = true, Flag = "esp_box", Callback = function(v) Config.ESP.Box = v end })
VisualTab:CreateColorPicker({ Name = "Box Color", Color = Config.ESP.BoxColor, Flag = "esp_box_col", Callback = function(c) Config.ESP.BoxColor = c end })
VisualTab:CreateToggle({ Name = "Health Bar (HP)", CurrentValue = true, Flag = "esp_hp", Callback = function(v) Config.ESP.Health = v end })
VisualTab:CreateToggle({ Name = "Name", CurrentValue = true, Flag = "esp_name", Callback = function(v) Config.ESP.Name = v end })
VisualTab:CreateColorPicker({ Name = "Name Color", Color = Config.ESP.NameColor, Flag = "esp_name_col", Callback = function(c) Config.ESP.NameColor = c end })
VisualTab:CreateToggle({ Name = "Distance", CurrentValue = true, Flag = "esp_dist", Callback = function(v) Config.ESP.Distance = v end })
VisualTab:CreateToggle({ Name = "Tracer", CurrentValue = true, Flag = "esp_tracer", Callback = function(v) Config.ESP.Tracer = v end })
VisualTab:CreateColorPicker({ Name = "Tracer Color", Color = Config.ESP.TracerColor, Flag = "esp_tracer_col", Callback = function(c) Config.ESP.TracerColor = c end })
VisualTab:CreateSlider({ Name = "Thickness", Range = { 1, 5 }, Increment = 1, Suffix = "px", CurrentValue = 1, Flag = "esp_thick", Callback = function(v) Config.ESP.Thickness = v end })
VisualTab:CreateSlider({ Name = "Max Distance", Range = { 100, 5000 }, Increment = 100, Suffix = " studs", CurrentValue = 1000, Flag = "esp_dist_max", Callback = function(v) Config.ESP.MaxDistance = v end })

-- Radar & FOV Tab
RadarTab:CreateSection("Radar Settings")
RadarTab:CreateToggle({ Name = "Enable Compass Radar", CurrentValue = true, Flag = "radar_on", Callback = function(v) Config.Radar.Enabled = v end })
RadarTab:CreateSlider({ Name = "Radar Size", Range = { 100, 300 }, Increment = 10, Suffix = "px", CurrentValue = 180, Flag = "radar_sz", Callback = function(v) Config.Radar.Size = v end })
RadarTab:CreateColorPicker({ Name = "Radar Blip Color", Color = Config.Radar.Color, Flag = "radar_col", Callback = function(c) Config.Radar.Color = c end })

Rayfield:Notify({
    Title = "SMOKExR'S PREMIUM",
    Content = "Loaded. HP ESP active. Radar online. FOV fixed.",
    Duration = 6,
    Image = 4483362458,
})
