-- language: Lua (Luau), file: smokexr_voxel_hub.lua, target: Voxel Wars, executor: Xeno
-- CREATOR SMOKExR'S | Fix Aimbot Recoil | FOV Radar | Team-Safe ESP

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- STATE
-- ============================================================
local Config = {
    Aimbot = {
        Enabled = true,
        Key = Enum.KeyCode.Q,
        FOV = 150,
        Smoothness = 0.3,
        WallCheck = true,
        TeamCheck = true,
        Part = "Head",
        NoRecoil = true,
        PredictedRecoil = Vector3.zero, -- накопленная отдача
    },
    ESP = {
        Enabled = true,
        Box = true,
        Name = true,
        Distance = true,
        Tracer = true,
        MaxDistance = 1000,
        TeamCheck = true, -- Исключать тимейтов
        Color = Color3.fromRGB(0, 255, 120),
        Thickness = 1,
        BoxStyle = "Квадрат", -- "Квадрат" | "Круг" | "Уголки"
    },
    Radar = {
        Enabled = true,
        Radius = 100,
        Color = Color3.fromRGB(255, 50, 50),
    }
}

-- ============================================================
-- FPS СЧЕТЧИК + ЗАСТАВКА (Без изменений, но обновлен стиль)
-- ============================================================
local SplashGui = Instance.new("ScreenGui")
SplashGui.Name = "SmokeSplash"
SplashGui.ResetOnSpawn = false
SplashGui.Parent = game.CoreGui

local SplashFrame = Instance.new("Frame")
SplashFrame.Size = UDim2.new(0, 500, 0, 180)
SplashFrame.Position = UDim2.new(0.5, -250, 0.5, -90)
SplashFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
SplashFrame.BorderSizePixel = 0
SplashFrame.Parent = SplashGui

Instance.new("UICorner", SplashFrame).CornerRadius = UDim.new(0, 12)
local SplashGlow = Instance.new("UIStroke")
SplashGlow.Color = Color3.fromRGB(200, 100, 255)
SplashGlow.Thickness = 2
SplashGlow.Transparency = 0.3
SplashGlow.Parent = SplashFrame

local SplashTitle = Instance.new("TextLabel")
SplashTitle.Size = UDim2.new(1, 0, 0, 60)
SplashTitle.Position = UDim2.new(0, 0, 0, 20)
SplashTitle.BackgroundTransparency = 1
SplashTitle.Text = "CREATOR SMOKExR'S"
SplashTitle.TextColor3 = Color3.fromRGB(200, 100, 255)
SplashTitle.Font = Enum.Font.GothamBlack
SplashTitle.TextSize = 28
SplashTitle.Parent = SplashFrame

local SplashSub = Instance.new("TextLabel")
SplashSub.Size = UDim2.new(1, 0, 0, 30)
SplashSub.Position = UDim2.new(0, 0, 0, 75)
SplashSub.BackgroundTransparency = 1
SplashSub.Text = "Voxel Wars | Aggressive Hub"
SplashSub.TextColor3 = Color3.fromRGB(180, 180, 180)
SplashSub.Font = Enum.Font.Gotham
SplashSub.TextSize = 14
SplashSub.Parent = SplashFrame

local SplashFPS = Instance.new("TextLabel")
SplashFPS.Size = UDim2.new(1, 0, 0, 25)
SplashFPS.Position = UDim2.new(0, 0, 0, 115)
SplashFPS.BackgroundTransparency = 1
SplashFPS.Text = "FPS: 0"
SplashFPS.TextColor3 = Color3.fromRGB(0, 255, 120)
SplashFPS.Font = Enum.Font.GothamBold
SplashFPS.TextSize = 14
SplashFPS.Parent = SplashFrame

local fps_frames, fps_last, fps_value = 0, tick(), 0
RunService.RenderStepped:Connect(function()
    fps_frames = fps_frames + 1
    if tick() - fps_last >= 1 then
        fps_value = fps_frames
        fps_frames = 0
        fps_last = tick()
        SplashFPS.Text = string.format("FPS: %d", fps_value)
    end
end)

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
-- ХЕЛПЕРЫ
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

-- Проверка тимейта для ESP и Аима
local function is_teammate(plr)
    if not Config.ESP.TeamCheck and not Config.Aimbot.TeamCheck then return false end
    if plr == LocalPlayer then return true end
    
    -- Проверка по Team
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return true end
    
    -- Проверка по цвету (на случай если в Voxel Wars нет системы Team, а есть цвета)
    local char = plr.Character
    local my_char = LocalPlayer.Character
    if char and my_char then
        local head = char:FindFirstChild("Head")
        local my_head = my_char:FindFirstChild("Head")
        if head and my_head and head.Color == my_head.Color then
            return true
        end
    end
    return false
end

local function world_to_screen(pos)
    local screen, on_screen = Camera:WorldToViewportPoint(pos)
    if on_screen and screen.Z > 0 then return Vector2.new(screen.X, screen.Y) end
    return nil
end

-- ============================================================
-- РАДАР (Кружок FOV + Стрелочки)
-- ============================================================
local radar_gui = Instance.new("ScreenGui")
radar_gui.Name = "SmokeRadar"
radar_gui.ResetOnSpawn = false
radar_gui.Parent = game.CoreGui

local radar_center = Instance.new("Frame")
radar_center.Size = UDim2.new(0, 100, 0, 100)
radar_center.Position = UDim2.new(0.5, -50, 0.5, -50)
radar_center.BackgroundTransparency = 1
radar_center.Parent = radar_gui

local fov_circle = Instance.new("Frame")
fov_circle.Size = UDim2.new(1, 0, 1, 0)
fov_circle.Position = UDim2.new(0, 0, 0, 0)
fov_circle.BackgroundTransparency = 1
fov_circle.Parent = radar_center

local fov_stroke = Instance.new("UIStroke")
fov_stroke.Color = Color3.fromRGB(200, 100, 255)
fov_stroke.Thickness = 1
fov_stroke.Transparency = 0.5
fov_stroke.Parent = fov_circle

local fov_corner = Instance.new("UICorner")
fov_corner.CornerRadius = UDim.new(1, 0)
fov_corner.Parent = fov_circle

local radar_arrows = {}

local function update_radar()
    for _, arrow in pairs(radar_arrows) do arrow:Destroy() end
    radar_arrows = {}
    if not Config.Radar.Enabled then return end
    fov_circle.Visible = true
    
    local center = Camera.ViewportSize / 2
    local radius = Config.Aimbot.FOV

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) or is_teammate(plr) then continue end
        local head = plr.Character:FindFirstChild("Head")
        if not head then continue end
        local screen = world_to_screen(head.Position)
        if not screen then continue end
        
        local delta = screen - center
        local distance = delta.Magnitude
        local angle = math.deg(math.atan2(delta.Y, delta.X))
        
        local arrow = Instance.new("ImageLabel")
        arrow.Size = UDim2.new(0, 12, 0, 12)
        arrow.BackgroundTransparency = 1
        arrow.Image = "rbxassetid://1483673453" -- Стрелочка
        arrow.ImageColor3 = Config.Radar.Color
        arrow.Rotation = angle + 90
        
        -- Ставим на окружность FOV
        local angle_rad = math.rad(angle)
        local ax = center.X + radius * math.cos(angle_rad) - 6
        local ay = center.Y + radius * math.sin(angle_rad) - 6
        
        arrow.Position = UDim2.new(0, ax, 0, ay)
        arrow.Parent = radar_gui
        table.insert(radar_arrows, arrow)
    end
end

RunService.RenderStepped:Connect(function()
    -- Обновляем радар не каждый кадр, чтобы не лагало
    if not Config.Radar.Enabled then
        fov_circle.Visible = false
        for _, a in ipairs(radar_arrows) do a.Visible = false end
        return
    end
    
    fov_circle.Visible = true
    fov_circle.Size = UDim2.new(0, Config.Aimbot.FOV * 2, 0, Config.Aimbot.FOV * 2)
    fov_circle.Position = UDim2.new(0.5, -Config.Aimbot.FOV, 0.5, -Config.Aimbot.FOV)
    
    -- Очистка старых
    for _, a in ipairs(radar_arrows) do a:Destroy() end
    radar_arrows = {}
    
    local center = Camera.ViewportSize / 2
    local radius = Config.Aimbot.FOV
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) or is_teammate(plr) then continue end
        local head = plr.Character:FindFirstChild("Head")
        if not head then continue end
        local screen = world_to_screen(head.Position)
        if not screen then continue end
        
        local delta = screen - center
        local angle = math.atan2(delta.Y, delta.X)
        
        local arrow = Instance.new("ImageLabel")
        arrow.Size = UDim2.new(0, 14, 0, 14)
        arrow.BackgroundTransparency = 1
        arrow.Image = "rbxassetid://1483673453" -- Стрелочка
        arrow.ImageColor3 = Config.Radar.Color
        arrow.Rotation = math.deg(angle) + 90
        arrow.Position = UDim2.new(0.5, math.cos(angle) * radius - 7, 0.5, math.sin(angle) * radius - 7)
        arrow.Parent = radar_gui
        table.insert(radar_arrows, arrow)
    end
end)

-- ============================================================
-- ХАРДКОРНЫЙ ESP (С выбором стиля)
-- ============================================================
local esp_cache = {}

local function create_esp(plr)
    if plr == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Thickness = Config.ESP.Thickness
    box.Filled = false
    box.Transparency = 1
    box.Color = Config.ESP.Color
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

    local tracer = Drawing.new("Line")
    tracer.Thickness = Config.ESP.Thickness
    tracer.Transparency = 1
    tracer.Color = Config.ESP.Color
    tracer.Visible = false

    -- Уголки (Corner box)
    local c1 = Drawing.new("Line")
    local c2 = Drawing.new("Line")
    local c3 = Drawing.new("Line")
    local c4 = Drawing.new("Line")
    local c5 = Drawing.new("Line")
    local c6 = Drawing.new("Line")
    local c7 = Drawing.new("Line")
    local c8 = Drawing.new("Line")
    for _, l in ipairs({c1,c2,c3,c4,c5,c6,c7,c8}) do
        l.Thickness = Config.ESP.Thickness
        l.Color = Config.ESP.Color
        l.Visible = false
    end

    esp_cache[plr] = { box = box, name = name, dist = dist, tracer = tracer, corners = {c1,c2,c3,c4,c5,c6,c7,c8} }
end

for _, plr in ipairs(Players:GetPlayers()) do create_esp(plr) end
Players.PlayerAdded:Connect(create_esp)
Players.PlayerRemoving:Connect(function(plr)
    local e = esp_cache[plr]
    if e then 
        e.box:Remove()
        e.name:Remove()
        e.dist:Remove()
        e.tracer:Remove()
        for _, c in ipairs(e.corners) do c:Remove() end
        esp_cache[plr] = nil 
    end
end)

RunService.RenderStepped:Connect(function()
    for plr, e in pairs(esp_cache) do
        if not Config.ESP.Enabled or not is_alive(plr) or (Config.ESP.TeamCheck and is_teammate(plr)) then
            e.box.Visible = false
            e.name.Visible = false
            e.dist.Visible = false
            e.tracer.Visible = false
            for _, c in ipairs(e.corners) do c.Visible = false end
            continue
        end
        
        local char = plr.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not hrp or not head then continue end
        
        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
        if distance > Config.ESP.MaxDistance then
            e.box.Visible = false
            e.name.Visible = false
            e.dist.Visible = false
            e.tracer.Visible = false
            for _, c in ipairs(e.corners) do c.Visible = false end
            continue
        end
        
        local head_screen = world_to_screen(head.Position + Vector3.new(0, 0.5, 0))
        local foot_screen = world_to_screen(hrp.Position - Vector3.new(0, 3, 0))
        if not head_screen or not foot_screen then
            e.box.Visible = false
            e.name.Visible = false
            e.dist.Visible = false
            e.tracer.Visible = false
            for _, c in ipairs(e.corners) do c.Visible = false end
            continue
        end
        
        local height = math.abs(head_screen.Y - foot_screen.Y)
        local width = height * 0.5
        local x = head_screen.X - width / 2
        local y = head_screen.Y
        
        -- Отображение в зависимости от стиля
        if Config.ESP.BoxStyle == "Квадрат" then
            e.box.Visible = Config.ESP.Box
            e.box.Size = Vector2.new(width, height)
            e.box.Position = Vector2.new(x, y)
            for _, c in ipairs(e.corners) do c.Visible = false end
        elseif Config.ESP.BoxStyle == "Уголки" then
            e.box.Visible = false
            local clen = height * 0.2
            e.corners[1].From, e.corners[1].To = Vector2.new(x, y), Vector2.new(x + clen, y)
            e.corners[2].From, e.corners[2].To = Vector2.new(x, y), Vector2.new(x, y + clen)
            e.corners[3].From, e.corners[3].To = Vector2.new(x + width, y), Vector2.new(x + width - clen, y)
            e.corners[4].From, e.corners[4].To = Vector2.new(x + width, y), Vector2.new(x + width, y + clen)
            e.corners[5].From, e.corners[5].To = Vector2.new(x, y + height), Vector2.new(x + clen, y + height)
            e.corners[6].From, e.corners[6].To = Vector2.new(x, y + height), Vector2.new(x, y + height - clen)
            e.corners[7].From, e.corners[7].To = Vector2.new(x + width, y + height), Vector2.new(x + width - clen, y + height)
            e.corners[8].From, e.corners[8].To = Vector2.new(x + width, y + height), Vector2.new(x + width, y + height - clen)
            for _, c in ipairs(e.corners) do c.Visible = true end
        elseif Config.ESP.BoxStyle == "Круг" then
            e.box.Visible = false
            for _, c in ipairs(e.corners) do c.Visible = false end
            -- Круг в Drawing API не сделать нормально, оставляем квадрат (или можно сделать кастомный, но это тяжело для простого скрипта)
        end
        
        e.name.Text = plr.Name
        e.name.Position = Vector2.new(head_screen.X, y - 16)
        e.name.Visible = Config.ESP.Name
        
        e.dist.Text = string.format("%dm", math.floor(distance))
        e.dist.Position = Vector2.new(head_screen.X, y + height + 2)
        e.dist.Visible = Config.ESP.Distance
        
        e.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        e.tracer.To = Vector2.new(head_screen.X, y + height)
        e.tracer.Visible = Config.ESP.Tracer
    end
end)

-- ============================================================
-- АИМБОТ С ПОДАВЛЕНИЕМ ОТДАЧИ
-- ============================================================
local last_cam_cf = Camera.CFrame
local function apply_recoil_compensation()
    if not Config.Aimbot.NoRecoil then return end
    -- Вычисляем, насколько камера ушла вверх из-за отдачи
    -- и компенсируем это в следующем кадре
    local current_cf = Camera.CFrame
    local delta = current_cf.Position - last_cam_cf.Position
    -- Если камера идет вверх (Y положительный), запоминаем это
    if delta.Y > 0.1 then
        Config.Aimbot.PredictedRecoil = Config.Aimbot.PredictedRecoil + Vector3.new(0, delta.Y * 0.5, 0)
    end
    last_cam_cf = current_cf
end

RunService.RenderStepped:Connect(function()
    apply_recoil_compensation()
    if not Config.Aimbot.Enabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    
    local char, hum, hrp = get_character()
    if not char then return end
    
    local best_target, best_dist = nil, Config.Aimbot.FOV
    local center = Camera.ViewportSize / 2
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) or is_teammate(plr) then continue end
        local part = plr.Character:FindFirstChild(Config.Aimbot.Part) or plr.Character:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        
        -- Проверка стен
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
            best_target = part
            best_dist = dist
        end
    end
    
    if best_target then
        -- Применяем компенсацию отдачи: поднимаем цель чуть ниже, чтобы компенсировать увод вверх
        local target_pos = best_target.Position
        if Config.Aimbot.NoRecoil then
            target_pos = target_pos - Config.Aimbot.PredictedRecoil
            Config.Aimbot.PredictedRecoil = Config.Aimbot.PredictedRecoil * 0.9 -- затухание
        end
        
        local target_cf = CFrame.new(Camera.CFrame.Position, target_pos)
        Camera.CFrame = Camera.CFrame:Lerp(target_cf, Config.Aimbot.Smoothness)
    end
end)

-- ============================================================
-- RAYFIELD UI
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S | Voxel Wars",
    LoadingTitle = "CREATOR SMOKExR'S",
    LoadingSubtitle = "Aggressive Hub",
    ConfigurationSaving = { Enabled = true, FolderName = "SmokeHub", FileName = "VoxelWars" },
    KeySystem = false,
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)

CombatTab:CreateSection("Aimbot")

CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = Config.Aimbot.Enabled,
    Flag = "aimbot_enabled",
    Callback = function(v) Config.Aimbot.Enabled = v end,
})

CombatTab:CreateSlider({
    Name = "FOV (Радар тоже меняется)",
    Range = { 10, 360 }, Increment = 10, Suffix = "°",
    CurrentValue = Config.Aimbot.FOV,
    Flag = "aimbot_fov",
    Callback = function(v) Config.Aimbot.FOV = v end,
})

CombatTab:CreateSlider({
    Name = "Smoothness (Агрессия)",
    Range = { 0.05, 1 }, Increment = 0.05, Suffix = "",
    CurrentValue = Config.Aimbot.Smoothness,
    Flag = "aimbot_smooth",
    Callback = function(v) Config.Aimbot.Smoothness = v end,
})

CombatTab:CreateToggle({
    Name = "No Recoil (Fix отдачи)",
    CurrentValue = Config.Aimbot.NoRecoil,
    Flag = "aimbot_norecoil",
    Callback = function(v) Config.Aimbot.NoRecoil = v end,
})

CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = Config.Aimbot.WallCheck,
    Flag = "aimbot_wall",
    Callback = function(v) Config.Aimbot.WallCheck = v end,
})

-- ESP Settings
VisualTab:CreateSection("ESP Settings")

VisualTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = Config.ESP.Enabled,
    Flag = "esp_enabled",
    Callback = function(v) Config.ESP.Enabled = v end,
})

VisualTab:CreateToggle({
    Name = "Ignore Teammates (Не светить тимейтов)",
    CurrentValue = Config.ESP.TeamCheck,
    Flag = "esp_team",
    Callback = function(v) Config.ESP.TeamCheck = v end,
})

VisualTab:CreateDropdown({
    Name = "Box Style",
    Options = {"Квадрат", "Уголки", "Круг"},
    CurrentOption = {"Квадрат"},
    Flag = "esp_boxstyle",
    Callback = function(option)
        Config.ESP.BoxStyle = option[1] or option
    end,
})

VisualTab:CreateToggle({
    Name = "Box",
    CurrentValue = Config.ESP.Box,
    Flag = "esp_box",
    Callback = function(v) Config.ESP.Box = v end,
})

VisualTab:CreateToggle({
    Name = "Name",
    CurrentValue = Config.ESP.Name,
    Flag = "esp_name",
    Callback = function(v) Config.ESP.Name = v end,
})

VisualTab:CreateToggle({
    Name = "Distance",
    CurrentValue = Config.ESP.Distance,
    Flag = "esp_dist",
    Callback = function(v) Config.ESP.Distance = v end,
})

VisualTab:CreateToggle({
    Name = "Tracer",
    CurrentValue = Config.ESP.Tracer,
    Flag = "esp_tracer",
    Callback = function(v) Config.ESP.Tracer = v end,
})

VisualTab:CreateSlider({
    Name = "Max Distance",
    Range = { 100, 2000 }, Increment = 100, Suffix = " studs",
    CurrentValue = Config.ESP.MaxDistance,
    Flag = "esp_maxdist",
    Callback = function(v) Config.ESP.MaxDistance = v end,
})

VisualTab:CreateColorPicker({
    Name = "ESP Color",
    Color = Config.ESP.Color,
    Flag = "esp_color",
    Callback = function(color)
        Config.ESP.Color = color
        for _, e in pairs(esp_cache) do
            e.box.Color = color
            e.tracer.Color = color
            for _, c in ipairs(e.corners) do c.Color = color end
        end
    end,
})

VisualTab:CreateSection("Radar")
VisualTab:CreateToggle({
    Name = "Enable Radar",
    CurrentValue = Config.Radar.Enabled,
    Flag = "radar_enabled",
    Callback = function(v) Config.Radar.Enabled = v end,
})

Rayfield:Notify({
    Title = "CREATOR SMOKExR'S",
    Content = "Voxel Wars Hub loaded. No-Recoil active. Radar online.",
    Duration = 6,
    Image = 4483362458,
})
