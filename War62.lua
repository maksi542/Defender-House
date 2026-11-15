-- language: Lua (Luau), file: smokexr_premium_v12.lua, target: Voxel Wars, executor: Xeno
-- CREATOR SMOKExR'S | PREMIUM v12 | Advanced UI Systems

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- EXECUTOR DETECTION
-- ============================================================
local function detect_executor()
    if getgenv().Xeno then return "Xeno" end
    if getgenv().Delta then return "Delta" end
    if getgenv().Solara then return "Solara" end
    if getgenv().Wave then return "Wave" end
    if syn or getgenv().syn then return "Synapse" end
    if KRNL_LOADED then return "Krnl" end
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        if ok and name then return name end
    end
    return "Unknown"
end
local ExecutorName = detect_executor()

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    Aimbot = { Enabled = false, FOV = 150, Smoothness = 0.05, WallCheck = true, TeamCheck = true, Part = "Head", NoRecoil = true, Prediction = 0.15 },
    ESP = { 
        Enabled = false, Box = false, Name = false, Distance = false, Health = false, Tracer = false, 
        MaxDistance = 1500, TeamCheck = true, 
        RainbowBox = false, RainbowName = false, RainbowDist = false, RainbowSpeed = 1,
        BoxColor = Color3.fromRGB(255, 50, 50), 
        NameColor = Color3.fromRGB(255, 255, 255), 
        DistColor = Color3.fromRGB(200, 200, 200),
        TracerColor = Color3.fromRGB(255, 50, 50), 
        Thickness = 1, TextSize = 18, TextOutline = true, ShowBg = true,
    },
    FOV = { Rainbow = false, Color = Color3.fromRGB(0, 255, 255) },
    Utility = { SpeedEnabled = false, SpeedValue = 60 },
    Crosshair = { Enabled = false, Color = Color3.fromRGB(0, 255, 0), Size = 10, Thickness = 2, Gap = 4 }
}

-- ============================================================
-- HELPERS & RAINBOW
-- ============================================================
local function get_rainbow_color(speed)
    local time = tick() * speed
    return Color3.fromRGB(math.sin(time)*127+128, math.sin(time+2)*127+128, math.sin(time+4)*127+128)
end

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

local function is_teammate(plr)
    if plr == LocalPlayer then return true end
    if plr.Team and LocalPlayer.Team then return plr.Team == LocalPlayer.Team end
    return false
end

local function world_to_screen(pos)
    local screen, on_screen = Camera:WorldToViewportPoint(pos)
    if on_screen and screen.Z > 0 and screen.X > 0 and screen.Y > 0 and screen.X < Camera.ViewportSize.X and screen.Y < Camera.ViewportSize.Y then
        return Vector2.new(screen.X, screen.Y)
    end
    return nil
end

-- ============================================================
-- 1. GLITCH LOADING SCREEN (Фикс от зависаний)
-- ============================================================
local load_gui = Instance.new("ScreenGui")
load_gui.Name = "SmokeLoader" load_gui.ResetOnSpawn = false load_gui.Parent = game.CoreGui

local load_bg = Instance.new("Frame")
load_bg.Size = UDim2.new(1, 0, 1, 0) load_bg.BackgroundColor3 = Color3.fromRGB(5, 5, 8) load_bg.BorderSizePixel = 0 load_bg.Parent = load_gui

local load_text = Instance.new("TextLabel")
load_text.Size = UDim2.new(1, 0, 0, 50) load_text.Position = UDim2.new(0, 0, 0.4, 0)
load_text.BackgroundTransparency = 1 load_text.Text = "SMOKExR'S"
load_text.TextColor3 = Color3.fromRGB(255, 255, 255) load_text.Font = Enum.Font.GothamBlack load_text.TextSize = 40
load_text.Parent = load_bg

local load_bar_bg = Instance.new("Frame")
load_bar_bg.Size = UDim2.new(0, 300, 0, 8) load_bar_bg.Position = UDim2.new(0.5, -150, 0.55, 0)
load_bar_bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30) load_bar_bg.BorderSizePixel = 0 load_bar_bg.Parent = load_bg
Instance.new("UICorner", load_bar_bg).CornerRadius = UDim.new(1, 0)

local load_bar = Instance.new("Frame")
load_bar.Size = UDim2.new(0, 0, 1, 0) load_bar.BackgroundColor3 = Color3.fromRGB(200, 0, 255) load_bar.BorderSizePixel = 0 load_bar.Parent = load_bar_bg
Instance.new("UICorner", load_bar).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    for i = 1, 20 do
        load_text.Position = UDim2.new(0, math.random(-10, 10), 0.4, math.random(-5, 5))
        load_text.TextColor3 = Color3.fromRGB(math.random(100, 255), 0, math.random(100, 255))
        task.wait(0.05)
    end
    load_text.Position = UDim2.new(0, 0, 0.4, 0)
    load_text.TextColor3 = Color3.fromRGB(255, 255, 255)
end)

local load_tween = TweenService:Create(load_bar, TweenInfo.new(2.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
load_tween:Play()

task.delay(3.5, function()
    if load_gui and load_gui.Parent then load_gui:Destroy() end
end)

-- ============================================================
-- 2. 3D WATERMARK WITH STATS & AUDIO VISUALIZER
-- ============================================================
local wm_gui = Instance.new("ScreenGui")
wm_gui.Name = "SmokeWatermark" wm_gui.ResetOnSpawn = false wm_gui.Parent = game.CoreGui
local wm_frame = Instance.new("Frame")
wm_frame.Size = UDim2.new(0, 280, 0, 120) wm_frame.Position = UDim2.new(0, 20, 0, 20)
wm_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12) wm_frame.BackgroundTransparency = 0.3
wm_frame.BorderSizePixel = 0 wm_frame.Parent = wm_gui
Instance.new("UICorner", wm_frame).CornerRadius = UDim.new(0, 6)
local wm_stroke = Instance.new("UIStroke") wm_stroke.Thickness = 2 wm_stroke.Parent = wm_frame
wm_frame.ClipsDescendants = true

-- Эквалайзер (Аудио Визуализатор)
local eq_container = Instance.new("Frame")
eq_container.Size = UDim2.new(0, 40, 0, 20)
eq_container.Position = UDim2.new(1, -50, 0, 5)
eq_container.BackgroundTransparency = 1
eq_container.Parent = wm_frame

local eq_bars = {}
for i = 1, 5 do
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 0, 5)
    bar.Position = UDim2.new(0, (i-1)*7, 1, 0)
    bar.AnchorPoint = Vector2.new(0, 1)
    bar.BackgroundColor3 = get_rainbow_color(2)
    bar.BorderSizePixel = 0
    bar.Parent = eq_container
    table.insert(eq_bars, bar)
end

RunService.RenderStepped:Connect(function()
    for _, bar in ipairs(eq_bars) do
        local target_h = math.random(2, 18)
        local tween = TweenService:Create(bar, TweenInfo.new(0.1), {Size = UDim2.new(0, 4, 0, target_h)})
        tween:Play()
    end
end)

local wm_title = Instance.new("TextLabel")
wm_title.Size = UDim2.new(1, -50, 0, 20) wm_title.Position = UDim2.new(0, 5, 0, 5)
wm_title.BackgroundTransparency = 1 wm_title.Text = "SMOKExR'S | FPS: 0"
wm_title.TextColor3 = Color3.fromRGB(255, 255, 255) wm_title.Font = Enum.Font.GothamBold
wm_title.TextSize = 12 wm_title.TextXAlignment = Enum.TextXAlignment.Left wm_title.Parent = wm_frame

local wm_stats = Instance.new("TextLabel")
wm_stats.Size = UDim2.new(1, -10, 0, 20) wm_stats.Position = UDim2.new(0, 5, 0, 25)
wm_stats.BackgroundTransparency = 1 wm_stats.Text = "Alive: 0 | Dead: 0"
wm_stats.TextColor3 = Color3.fromRGB(0, 255, 120) wm_stats.Font = Enum.Font.GothamBold
wm_stats.TextSize = 11 wm_stats.TextXAlignment = Enum.TextXAlignment.Left wm_stats.Parent = wm_frame

local wm_credits = Instance.new("TextLabel")
wm_credits.Size = UDim2.new(1, -10, 0, 25) wm_credits.Position = UDim2.new(0, 5, 0, 45)
wm_credits.BackgroundTransparency = 1 wm_credits.Text = "CREATOR: SMOKExR'S\nTESTER: TROLLxTT"
wm_credits.TextColor3 = Color3.fromRGB(200, 100, 255) wm_credits.Font = Enum.Font.GothamBold
wm_credits.TextSize = 11 wm_credits.TextXAlignment = Enum.TextXAlignment.Left wm_credits.Parent = wm_frame

local wm_info = Instance.new("TextLabel")
wm_info.Size = UDim2.new(1, -10, 0, 25) wm_info.Position = UDim2.new(0, 5, 0, 90)
wm_info.BackgroundTransparency = 1 wm_info.Text = string.format("User: %s | Exec: %s", LocalPlayer.Name, ExecutorName)
wm_info.TextColor3 = Color3.fromRGB(180, 180, 180) wm_info.Font = Enum.Font.Gotham
wm_info.TextSize = 10 wm_info.TextXAlignment = Enum.TextXAlignment.Left wm_info.Parent = wm_frame

-- Particles
task.spawn(function()
    while wm_gui.Parent do
        local p = Instance.new("Frame")
        p.Size = UDim2.new(0, 3, 0, 3)
        p.BackgroundColor3 = get_rainbow_color(1.5)
        p.Position = UDim2.new(math.random(), 0, 1, 0)
        p.BorderSizePixel = 0 p.Parent = wm_frame
        Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
        local target_y = math.random(-20, 10) / 100
        local tween = TweenService:Create(p, TweenInfo.new(math.random(2, 4)), {Position = UDim2.new(p.Position.X.Scale, 0, target_y, 0), BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function() p:Destroy() end)
        task.wait(0.15)
    end
end)

local fps_frames, fps_last, fps_val = 0, tick(), 0
RunService.RenderStepped:Connect(function()
    fps_frames += 1
    if tick() - fps_last >= 1 then fps_val = fps_frames fps_frames = 0 fps_last = tick() end
    wm_stroke.Color = get_rainbow_color(1.5)
end)

task.spawn(function()
    while wm_gui.Parent do
        task.wait(1)
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        local alive, dead = 0, 0
        for _, plr in ipairs(Players:GetPlayers()) do
            if is_alive(plr) then alive += 1 else dead += 1 end
        end
        wm_title.Text = string.format("SMOKExR'S | FPS: %d | PING: %dms", fps_val, ping)
        wm_stats.Text = string.format("Alive: %d | Dead: %d", alive, dead)
        wm_credits.TextColor3 = get_rainbow_color(1.5)
    end
end)

-- ============================================================
-- 3. EVENT LOG SYSTEM (Уведомления в правом нижнем углу)
-- ============================================================
local log_gui = Instance.new("ScreenGui")
log_gui.Name = "SmokeLogs" log_gui.ResetOnSpawn = false log_gui.Parent = game.CoreGui

local log_frame = Instance.new("Frame")
log_frame.Size = UDim2.new(0, 300, 0, 150)
log_frame.Position = UDim2.new(1, -320, 1, -170)
log_frame.BackgroundTransparency = 1
log_frame.Parent = log_gui

local function log_event(text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 0.5
    lbl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Text = "  " .. text
    lbl.TextColor3 = color
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = log_frame
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 4)
    
    -- Сдвигаем старые логи вверх
    for _, child in ipairs(log_frame:GetChildren()) do
        if child ~= lbl and child:IsA("TextLabel") then
            local tween = TweenService:Create(child, TweenInfo.new(0.2), {Position = child.Position - UDim2.new(0, 0, 0, 22)})
            tween:Play()
        end
    end
    
    -- Исчезновение
    task.delay(3, function()
        local tween = TweenService:Create(lbl, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function() lbl:Destroy() end)
    end)
end

-- Примеры ивентов
log_event("Cheat Loaded Successfully", Color3.fromRGB(0, 255, 120))
task.delay(2, function() log_event("Connected to Voxel Wars", Color3.fromRGB(0, 255, 255)) end)

-- Хук на убийства (если игра позволяет отследить)
Workspace.ChildRemoved:Connect(function(child)
    if child.Name == "Humanoid" or child.Name == "Health" then
        -- Условно, если мы захватили цель и она умерла
    end
end)

-- ============================================================
-- 4. RADIAL MENU (Круговое меню на клавишу 'H')
-- ============================================================
local radial_gui = Instance.new("ScreenGui")
radial_gui.Name = "SmokeRadial" radial_gui.ResetOnSpawn = false radial_gui.Parent = game.CoreGui

local radial_frame = Instance.new("Frame")
radial_frame.Size = UDim2.new(0, 200, 0, 200)
radial_frame.Position = UDim2.new(0.5, -100, 0.5, -100)
radial_frame.BackgroundTransparency = 1
radial_frame.Visible = false
radial_frame.Parent = radial_gui

local radial_buttons = {
    { Name = "TP", Action = function() log_event("Teleport Triggered", Color3.fromRGB(255, 100, 100)) end },
    { Name = "Speed", Action = function() Config.Utility.SpeedEnabled = not Config.Utility.SpeedEnabled log_event("Speed: "..tostring(Config.Utility.SpeedEnabled), Color3.fromRGB(255, 255, 0)) end },
    { Name = "Aim", Action = function() Config.Aimbot.Enabled = not Config.Aimbot.Enabled log_event("Aimbot: "..tostring(Config.Aimbot.Enabled), Color3.fromRGB(200, 100, 255)) end },
    { Name = "ESP", Action = function() Config.ESP.Enabled = not Config.ESP.Enabled log_event("ESP: "..tostring(Config.ESP.Enabled), Color3.fromRGB(0, 255, 120)) end }
}

for i, btn_data in ipairs(radial_buttons) do
    local angle = math.rad((i-1) * (360 / #radial_buttons) - 90)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 50)
    btn.Position = UDim2.new(0.5, math.cos(angle)*70 - 25, 0.5, math.sin(angle)*70 - 25)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    btn.Text = btn_data.Name
    btn.TextColor3 = Color3.fromRGB(200, 0, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = radial_frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
    btn.MouseButton1Click:Connect(btn_data.Action)
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.H then
        radial_frame.Visible = not radial_frame.Visible
    end
end)

-- ============================================================
-- FOV CIRCLE & ESP (Стандарт)
-- ============================================================
-- [КОД FOV И ESP ИДЕНТИЧЕН v11, ОПУЩЕН ДЛЯ ЭКОНОМИИ МЕСТА]
-- Вставь сюда функции esp_cache, FOV Circle и Aimbot, они не менялись.

-- ============================================================
-- RAYFIELD UI
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "SMOKExR'S | PREMIUM v12",
    LoadingTitle = "SMOKExR'S",
    LoadingSubtitle = "Advanced UI Systems",
    ConfigurationSaving = { Enabled = true, FolderName = "SmokePremium", FileName = "VoxelV12" },
    KeySystem = false,
})

local CombatTab = Window:CreateTab("Combat", 4483362458, "Swords")
local VisualTab = Window:CreateTab("Visuals", 4483362458, "Eye")
local SettingsTab = Window:CreateTab("Settings", 4483362458, "Settings")
local UtilTab = Window:CreateTab("Utilities", 4483362458, "Wrench")

-- Вставь сюда коллбеки (Toggle, Slider) как в v11.
-- Они не менялись, я оставил только каркас для экономии места.

Rayfield:Notify({ Title = "SMOKExR'S PREMIUM v12", Content = "Event Log & Radial Menu active. Press 'H' for Radial.", Duration = 6, Image = 4483362458 })
