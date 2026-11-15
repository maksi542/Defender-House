-- language: Lua (Luau), file: smokexr_premium_v14.lua, target: Voxel Wars, executor: Xeno
-- CREATOR SMOKExR'S | PREMIUM v14 | Async UI Render

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
-- 1. GLITCH LOADING SCREEN
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
-- 3. EVENT LOG SYSTEM
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
    
    for _, child in ipairs(log_frame:GetChildren()) do
        if child ~= lbl and child:IsA("TextLabel") then
            TweenService:Create(child, TweenInfo.new(0.2), {Position = child.Position - UDim2.new(0, 0, 0, 22)}):Play()
        end
    end
    
    task.delay(3, function()
        local tween = TweenService:Create(lbl, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
        tween:Play()
        tween.Completed:Connect(function() lbl:Destroy() end)
    end)
end

log_event("Cheat Loaded Successfully", Color3.fromRGB(0, 255, 120))

-- ============================================================
-- 4. CROSSHAIR
-- ============================================================
local ch_gui = Instance.new("ScreenGui")
ch_gui.Name = "SmokeCrosshair" ch_gui.ResetOnSpawn = false ch_gui.IgnoreGuiInset = true ch_gui.Parent = game.CoreGui

local ch_lines = {}
for i = 1, 4 do
    local line = Instance.new("Frame")
    line.BackgroundColor3 = Config.Crosshair.Color
    line.BorderSizePixel = 0
    line.Parent = ch_gui
    table.insert(ch_lines, line)
end

RunService.RenderStepped:Connect(function()
    if not Config.Crosshair.Enabled then
        for _, l in ipairs(ch_lines) do l.Visible = false end
        return
    end
    for _, l in ipairs(ch_lines) do l.Visible = true end
    
    local center = Camera.ViewportSize / 2
    local s = Config.Crosshair.Size
    local g = Config.Crosshair.Gap
    local t = Config.Crosshair.Thickness
    
    ch_lines[1].Size = UDim2.new(0, t, 0, s)
    ch_lines[1].Position = UDim2.new(0, center.X - t/2, 0, center.Y - g - s)
    
    ch_lines[2].Size = UDim2.new(0, t, 0, s)
    ch_lines[2].Position = UDim2.new(0, center.X - t/2, 0, center.Y + g)
    
    ch_lines[3].Size = UDim2.new(0, s, 0, t)
    ch_lines[3].Position = UDim2.new(0, center.X - g - s, 0, center.Y - t/2)
    
    ch_lines[4].Size = UDim2.new(0, s, 0, t)
    ch_lines[4].Position = UDim2.new(0, center.X + g, 0, center.Y - t/2)
end)

-- ============================================================
-- 5. FOV CIRCLE & ESP
-- ============================================================
local fov_gui = Instance.new("ScreenGui")
fov_gui.Name = "SmokeFOV" fov_gui.ResetOnSpawn = false fov_gui.Parent = game.CoreGui
local fov_circle = Instance.new("Frame")
fov_circle.AnchorPoint = Vector2.new(0.5, 0.5) fov_circle.Position = UDim2.new(0.5, 0, 0.5, 0)
fov_circle.BackgroundTransparency = 1 fov_circle.Parent = fov_gui
local fov_stroke = Instance.new("UIStroke") fov_stroke.Thickness = 1.5 fov_stroke.Transparency = 0.4 fov_stroke.Parent = fov_circle
Instance.new("UICorner", fov_circle).CornerRadius = UDim.new(1, 0)

RunService.RenderStepped:Connect(function()
    if not Config.Aimbot.Enabled then fov_circle.Visible = false return end
    fov_circle.Visible = true
    fov_circle.Size = UDim2.new(0, Config.Aimbot.FOV * 2, 0, Config.Aimbot.FOV * 2)
    fov_stroke.Color = Config.FOV.Rainbow and get_rainbow_color(2) or Config.FOV.Color
end)

local esp_cache = {}
local function create_esp(plr)
    if plr == LocalPlayer then return end
    local box = Drawing.new("Square") box.Visible = false
    local name = Drawing.new("Text") name.Center = true name.Outline = true name.Visible = false
    local dist = Drawing.new("Text") dist.Center = true dist.Outline = true dist.Visible = false
    local hp_bg = Drawing.new("Square") hp_bg.Filled = true hp_bg.Color = Color3.fromRGB(0,0,0) hp_bg.Visible = false
    local hp_bar = Drawing.new("Square") hp_bar.Filled = true hp_bar.Visible = false
    local tracer = Drawing.new("Line") tracer.Visible = false
    local name_bg = Drawing.new("Square") name_bg.Filled = true name_bg.Color = Color3.fromRGB(0, 0, 0) name_bg.Visible = false
    
    esp_cache[plr] = { box = box, name = name, dist = dist, hp_bg = hp_bg, hp_bar = hp_bar, tracer = tracer, name_bg = name_bg }
end
for _, plr in ipairs(Players:GetPlayers()) do create_esp(plr) end
Players.PlayerAdded:Connect(create_esp)
Players.PlayerRemoving:Connect(function(plr)
    local e = esp_cache[plr]
    if e then for _, v in pairs(e) do v:Remove() end esp_cache[plr] = nil end
end)

RunService.RenderStepped:Connect(function()
    local rb_col = get_rainbow_color(Config.ESP.RainbowSpeed)
    for plr, e in pairs(esp_cache) do
        if not Config.ESP.Enabled or not is_alive(plr) or (Config.ESP.TeamCheck and is_teammate(plr)) then
            e.box.Visible = false e.name.Visible = false e.dist.Visible = false
            e.hp_bg.Visible = false e.hp_bar.Visible = false e.tracer.Visible = false e.name_bg.Visible = false
            continue
        end
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not head or not hum then continue end
        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
        if distance > Config.ESP.MaxDistance then continue end
        local head_screen = world_to_screen(head.Position + Vector3.new(0, 0.5, 0))
        local foot_screen = world_to_screen(hrp.Position - Vector3.new(0, 3, 0))
        if not head_screen or not foot_screen then
            e.box.Visible = false e.name.Visible = false e.dist.Visible = false
            e.hp_bg.Visible = false e.hp_bar.Visible = false e.tracer.Visible = false e.name_bg.Visible = false
            continue
        end
        local height = math.abs(head_screen.Y - foot_screen.Y)
        local width = height * 0.5
        local x = head_screen.X - width / 2
        local y = head_screen.Y
        
        local final_box_col = Config.ESP.RainbowBox and rb_col or Config.ESP.BoxColor
        local final_name_col = Config.ESP.RainbowName and rb_col or Config.ESP.NameColor
        local final_dist_col = Config.ESP.RainbowDist and rb_col or Config.ESP.DistColor
        
        e.box.Visible = Config.ESP.Box
        e.box.Size = Vector2.new(width, height)
        e.box.Position = Vector2.new(x, y)
        e.box.Color = final_box_col
        e.box.Thickness = Config.ESP.Thickness
        
        e.name.Text = plr.Name
        e.name.Size = Config.ESP.TextSize
        e.name.Position = Vector2.new(head_screen.X, y - Config.ESP.TextSize - 6)
        e.name.Visible = Config.ESP.Name
        e.name.Color = final_name_col
        e.name.Outline = Config.ESP.TextOutline
        
        e.dist.Text = string.format("[%dm]", math.floor(distance))
        e.dist.Size = Config.ESP.TextSize - 2
        e.dist.Position = Vector2.new(head_screen.X, y + height + 4)
        e.dist.Visible = Config.ESP.Distance
        e.dist.Color = final_dist_col
        e.dist.Outline = Config.ESP.TextOutline
        
        if Config.ESP.ShowBg and Config.ESP.Name then
            e.name_bg.Visible = true
            local bg_width = (e.name.Text:len() * Config.ESP.TextSize) * 0.55
            local bg_height = Config.ESP.TextSize + 4
            e.name_bg.Size = Vector2.new(bg_width, bg_height)
            e.name_bg.Position = Vector2.new(head_screen.X - bg_width/2, y - Config.ESP.TextSize - 8)
            e.name_bg.Color = Color3.fromRGB(0, 0, 0)
            e.name_bg.Transparency = 0.5
        else
            e.name_bg.Visible = false
        end
        
        if Config.ESP.Health then
            local hp_pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            e.hp_bg.Visible = true e.hp_bg.Size = Vector2.new(4, height) e.hp_bg.Position = Vector2.new(x - 8, y)
            e.hp_bar.Visible = true e.hp_bar.Size = Vector2.new(4, height * hp_pct) e.hp_bar.Position = Vector2.new(x - 8, y + height * (1 - hp_pct))
            e.hp_bar.Color = Color3.fromRGB(255 * (1 - hp_pct), 255 * hp_pct, 0)
        else
            e.hp_bg.Visible = false e.hp_bar.Visible = false
        end
        
        e.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        e.tracer.To = Vector2.new(head_screen.X, y + height)
        e.tracer.Visible = Config.ESP.Tracer
        e.tracer.Color = final_box_col
    end
end)

-- ============================================================
-- 6. AIMBOT & UTILITY
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
            if Workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, params) then continue end
        end
        local screen = world_to_screen(part.Position)
        if not screen then continue end
        local dist = (screen - center).Magnitude
        if dist < best_dist then best, best_dist = part, dist end
    end
    if best then
        local predicted_pos = best.Position + (best.AssemblyLinearVelocity or Vector3.zero) * Config.Aimbot.Prediction
        local target_cf = CFrame.new(Camera.CFrame.Position, predicted_pos)
        if Config.Aimbot.NoRecoil then target_cf = target_cf * CFrame.Angles(math.rad(-1.5), 0, 0) end
        Camera.CFrame = Camera.CFrame:Lerp(target_cf, Config.Aimbot.Smoothness)
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Config.Utility.SpeedEnabled then
            local _, hum = get_character()
            if hum and hum.WalkSpeed ~= Config.Utility.SpeedValue then hum.WalkSpeed = Config.Utility.SpeedValue end
        end
    end
end)

-- ============================================================
-- 7. RAYFIELD UI (Асинхронная сборка)
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "SMOKExR'S | PREMIUM v14",
    LoadingTitle = "SMOKExR'S",
    LoadingSubtitle = "Async Render Fix",
    ConfigurationSaving = { Enabled = true, FolderName = "SmokePremium", FileName = "VoxelV14" },
    KeySystem = false,
})

-- Асинхронное создание вкладок и элементов (фикс пустого меню)
task.spawn(function()
    local CombatTab = Window:CreateTab("Combat", nil, "Swords")
    task.wait(0.1)
    local VisualTab = Window:CreateTab("Visuals", nil, "Eye")
    task.wait(0.1)
    local SettingsTab = Window:CreateTab("Settings", nil, "Settings")
    task.wait(0.1)
    local RadarTab = Window:CreateTab("FOV", nil, "Crosshair")
    task.wait(0.1)
    local UtilTab = Window:CreateTab("Utilities", nil, "Wrench")
    task.wait(0.1)

    -- Settings
    SettingsTab:CreateSection("Crosshair")
    task.wait(0.1)
    SettingsTab:CreateToggle({ Name = "Enable Crosshair", CurrentValue = false, Flag = "ch_on", Callback = function(v) Config.Crosshair.Enabled = v end })
    task.wait(0.1)
    SettingsTab:CreateColorPicker({ Name = "Crosshair Color", Color = Config.Crosshair.Color, Flag = "ch_color", Callback = function(c) Config.Crosshair.Color = c for _, l in ipairs(ch_lines) do l.BackgroundColor3 = c end end })
    task.wait(0.1)
    SettingsTab:CreateSlider({ Name = "Size", Range = { 2, 20 }, Increment = 1, CurrentValue = 10, Flag = "ch_size", Callback = function(v) Config.Crosshair.Size = v end })
    task.wait(0.1)
    SettingsTab:CreateSlider({ Name = "Gap", Range = { 0, 15 }, Increment = 1, CurrentValue = 4, Flag = "ch_gap", Callback = function(v) Config.Crosshair.Gap = v end })
    task.wait(0.1)
    SettingsTab:CreateSlider({ Name = "Thickness", Range = { 1, 4 }, Increment = 1, CurrentValue = 2, Flag = "ch_thick", Callback = function(v) Config.Crosshair.Thickness = v end })
    task.wait(0.1)

    -- Combat
    CombatTab:CreateToggle({ Name = "Aimbot Master", CurrentValue = false, Flag = "aim_on", Callback = function(v) Config.Aimbot.Enabled = v end })
    task.wait(0.1)
    CombatTab:CreateToggle({ Name = "Ignore Teammates", CurrentValue = true, Flag = "aim_team", Callback = function(v) Config.Aimbot.TeamCheck = v end })
    task.wait(0.1)
    CombatTab:CreateSlider({ Name = "FOV Radius", Range = { 50, 500 }, Increment = 10, CurrentValue = 150, Flag = "aim_fov", Callback = function(v) Config.Aimbot.FOV = v end })
    task.wait(0.1)
    CombatTab:CreateSlider({ Name = "Smoothness", Range = { 0.01, 1 }, Increment = 0.01, CurrentValue = 0.05, Flag = "aim_sm", Callback = function(v) Config.Aimbot.Smoothness = v end })
    task.wait(0.1)
    CombatTab:CreateSlider({ Name = "Prediction", Range = { 0, 0.5 }, Increment = 0.01, CurrentValue = 0.15, Flag = "aim_pred", Callback = function(v) Config.Aimbot.Prediction = v end })
    task.wait(0.1)
    CombatTab:CreateToggle({ Name = "No Recoil", CurrentValue = true, Flag = "aim_rec", Callback = function(v) Config.Aimbot.NoRecoil = v end })
    task.wait(0.1)
    CombatTab:CreateToggle({ Name = "Wall Check", CurrentValue = true, Flag = "aim_wall", Callback = function(v) Config.Aimbot.WallCheck = v end })
    task.wait(0.1)

    -- Visuals
    VisualTab:CreateSection("ESP Master")
    task.wait(0.1)
    VisualTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Flag = "esp_on", Callback = function(v) Config.ESP.Enabled = v end })
    task.wait(0.1)
    VisualTab:CreateToggle({ Name = "Ignore Teammates", CurrentValue = true, Flag = "esp_team", Callback = function(v) Config.ESP.TeamCheck = v end })
    task.wait(0.1)
    VisualTab:CreateToggle({ Name = "Box", CurrentValue = false, Flag = "esp_box", Callback = function(v) Config.ESP.Box = v end })
    task.wait(0.1)
    VisualTab:CreateToggle({ Name = "Health Bar", CurrentValue = false, Flag = "esp_hp", Callback = function(v) Config.ESP.Health = v end })
    task.wait(0.1)
    VisualTab:CreateToggle({ Name = "Name", CurrentValue = false, Flag = "esp_name", Callback = function(v) Config.ESP.Name = v end })
    task.wait(0.1)
    VisualTab:CreateToggle({ Name = "Distance", CurrentValue = false, Flag = "esp_dist", Callback = function
