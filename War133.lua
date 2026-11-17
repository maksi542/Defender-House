-- language: Lua (Luau), file: smokexr_legit_v51.lua, target: Voxel Wars, executor: Solara / Delta / Fluxus
-- CREATOR SMOKExR'S | LEGIT v51 (fixed by Lokeii)
-- Fixed: FOV center alignment, Vehicle ESP for Voxel Wars (VehicleHulls/Helicopters), fast loader.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- FPS UNLOCKER
-- ============================================================
pcall(function() if setfpscap then setfpscap(240) end end)

-- ============================================================
-- RAYFIELD (with fallback)
-- ============================================================
local Rayfield
local ok_rf, err_rf = pcall(function()
    local src = game:HttpGet('https://sirius.menu/rayfield')
    Rayfield = loadstring(src)()
end)
if not ok_rf or not Rayfield then
    warn("[SMOKE] Rayfield failed: " .. tostring(err_rf) .. " — fallback mode")
    Rayfield = {
        CreateWindow = function(self, opts)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(0, 420, 0, 60)
            f.Position = UDim2.new(0.5, -210, 0, 20)
            f.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
            f.BorderSizePixel = 0
            f.Parent = game:GetService("CoreGui")
            Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, -20, 1, -20)
            t.Position = UDim2.new(0, 10, 0, 10)
            t.BackgroundTransparency = 1
            t.Text = "SMOKExR v51 — FALLBACK (Rayfield unavailable)"
            t.TextColor3 = Color3.fromRGB(0, 255, 255)
            t.Font = Enum.Font.GothamBold
            t.TextSize = 14
            t.Parent = f
            local stub = function() return {
                CreateSection = function() end, CreateToggle = function() end,
                CreateSlider = function() end, CreateButton = function() end,
                CreateColorPicker = function() end, CreateDropdown = function() end,
                CreateLabel = function() end,
            } end
            return {CreateTab = stub}
        end
    }
end

-- ============================================================
-- FAST LOADER (3 sec)
-- ============================================================
local load_gui = Instance.new("ScreenGui")
load_gui.Name = "SmokeLoader"
load_gui.ResetOnSpawn = false
load_gui.IgnoreGuiInset = true
load_gui.Parent = game.CoreGui

local load_bg = Instance.new("Frame")
load_bg.Size = UDim2.new(1, 0, 1, 0)
load_bg.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
load_bg.BorderSizePixel = 0
load_bg.Parent = load_gui

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, 0, 0, 80)
logo.Position = UDim2.new(0, 0, 0.38, 0)
logo.BackgroundTransparency = 1
logo.Text = "SMOKExR'S"
logo.TextColor3 = Color3.fromRGB(0, 255, 255)
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 48
logo.TextTransparency = 1
logo.Parent = load_bg
TweenService:Create(logo, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0.48, 0)
sub.BackgroundTransparency = 1
sub.Text = "LEGIT v51  •  loading"
sub.TextColor3 = Color3.fromRGB(120, 120, 130)
sub.Font = Enum.Font.Gotham
sub.TextSize = 14
sub.TextTransparency = 1
sub.Parent = load_bg
TweenService:Create(sub, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

local bar_bg = Instance.new("Frame")
bar_bg.Size = UDim2.new(0, 300, 0, 4)
bar_bg.Position = UDim2.new(0.5, -150, 0.55, 0)
bar_bg.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
bar_bg.BorderSizePixel = 0
bar_bg.Parent = load_bg
Instance.new("UICorner", bar_bg).CornerRadius = UDim.new(1, 0)

local bar_fill = Instance.new("Frame")
bar_fill.Size = UDim2.new(0, 0, 1, 0)
bar_fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
bar_fill.BorderSizePixel = 0
bar_fill.Parent = bar_bg
Instance.new("UICorner", bar_fill).CornerRadius = UDim.new(1, 0)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 18)
status.Position = UDim2.new(0, 0, 0.58, 0)
status.BackgroundTransparency = 1
status.Text = "initializing..."
status.TextColor3 = Color3.fromRGB(0, 200, 200)
status.Font = Enum.Font.Code
status.TextSize = 12
status.TextTransparency = 1
status.Parent = load_bg
TweenService:Create(status, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

task.spawn(function()
    local steps = {
        {"initializing...", 0.25},
        {"loading modules...", 0.5},
        {"hooking ui...", 0.75},
        {"system online", 1.0},
    }
    for _, step in ipairs(steps) do
        status.Text = step[1]
        TweenService:Create(bar_fill, TweenInfo.new(0.7), {Size = UDim2.new(step[2], 0, 1, 0)}):Play()
        task.wait(0.75)
    end
    task.wait(0.3)
    TweenService:Create(load_bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(bar_bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(bar_fill, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(status, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    task.wait(0.7)
    load_gui:Destroy()
end)

-- ============================================================
-- CONFIG
-- ============================================================
local ThemeColor = Color3.fromRGB(0, 255, 255)
local RainbowUI = false
local RainbowSpeedUI = 1.5
local IsPanic = false

local Config = {
    Aimbot = {
        Enabled = false, FOV = 150, Smoothness = 0.15,
        WallCheck = true, TeamCheck = true, NoRecoil = true,
        AimPart = "Head", AlwaysOn = false
    },
    Hitbox = { Enabled = false, Size = 3 },
    ESP = {
        Enabled = false, Box = false, Name = false, Distance = false,
        Health = false, Tracer = false, MaxDistance = 1500, TeamCheck = true,
        RainbowBox = false, RainbowName = false, RainbowDist = false, RainbowSpeed = 1,
        BoxColor = Color3.fromRGB(255, 50, 50),
        NameColor = Color3.fromRGB(255, 255, 255),
        DistColor = Color3.fromRGB(200, 200, 200),
        TracerColor = Color3.fromRGB(255, 50, 50),
        Thickness = 1, TextSize = 18, TextOutline = true, ShowBg = true,
    },
    FOV = { Rainbow = false, Color = Color3.fromRGB(0, 255, 255) },
    Chams = { Enabled = false, Rainbow = false, Color = Color3.fromRGB(255, 0, 255), Transparency = 0.5 },
    Skeleton = { Enabled = false, Rainbow = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1 },
    VehicleESP = { Enabled = false, Color = Color3.fromRGB(255, 100, 0) },
    Crosshair = { Enabled = false, Color = Color3.fromRGB(0, 255, 0), Size = 10, Thickness = 2, Gap = 4 },
    AntiAFK = false, FPSBoost = false
}

local function get_rainbow_color(speed)
    local t = tick() * speed
    return Color3.fromRGB(math.sin(t)*127+128, math.sin(t+2)*127+128, math.sin(t+4)*127+128)
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
    if on_screen and screen.X > 0 and screen.Y > 0
       and screen.X < Camera.ViewportSize.X and screen.Y < Camera.ViewportSize.Y then
        return Vector2.new(screen.X, screen.Y)
    end
    return nil
end

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
local notif_gui = Instance.new("ScreenGui")
notif_gui.Name = "SmokeNotifs"
notif_gui.ResetOnSpawn = false
notif_gui.IgnoreGuiInset = true
notif_gui.Parent = game.CoreGui

local notif_frame = Instance.new("Frame")
notif_frame.Size = UDim2.new(0, 320, 0, 400)
notif_frame.Position = UDim2.new(1, -340, 1, -420)
notif_frame.BackgroundTransparency = 1
notif_frame.Parent = notif_gui

local notif_layout = Instance.new("UIListLayout")
notif_layout.Padding = UDim.new(0, 4)
notif_layout.SortOrder = Enum.SortOrder.LayoutOrder
notif_layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notif_layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notif_layout.Parent = notif_frame

local notif_order = 0
local function send_notif(title, text, color, is_dangerous)
    if IsPanic then return end
    notif_order = notif_order + 1
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 44)
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    box.BackgroundTransparency = 0.2
    box.LayoutOrder = notif_order
    box.Parent = notif_frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or ThemeColor
    stroke.Thickness = 1
    stroke.Parent = box
    local title_lbl = Instance.new("TextLabel")
    title_lbl.Size = UDim2.new(1, -10, 0, 15)
    title_lbl.Position = UDim2.new(0, 5, 0, 2)
    title_lbl.BackgroundTransparency = 1
    title_lbl.Text = title
    title_lbl.TextColor3 = color or ThemeColor
    title_lbl.Font = Enum.Font.GothamBold
    title_lbl.TextSize = 12
    title_lbl.TextXAlignment = Enum.TextXAlignment.Left
    title_lbl.Parent = box
    local desc_lbl = Instance.new("TextLabel")
    desc_lbl.Size = UDim2.new(1, -10, 0, 22)
    desc_lbl.Position = UDim2.new(0, 5, 0, 18)
    desc_lbl.BackgroundTransparency = 1
    desc_lbl.TextWrapped = true
    desc_lbl.Text = is_dangerous and (text .. " (WARNING: high ban risk)") or text
    desc_lbl.TextColor3 = is_dangerous and Color3.fromRGB(255, 100, 100) or Color3.fromRGB(200, 200, 200)
    desc_lbl.Font = Enum.Font.Gotham
    desc_lbl.TextSize = 11
    desc_lbl.TextXAlignment = Enum.TextXAlignment.Left
    desc_lbl.Parent = box
    task.delay(4, function()
        TweenService:Create(box, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(title_lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(desc_lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.35)
        box:Destroy()
    end)
end

-- ============================================================
-- FPS BOOST
-- ============================================================
local fps_boosted = false
local function ToggleFPSBoost()
    if fps_boosted == Config.FPSBoost then return end
    if Config.FPSBoost then
        pcall(function() Lighting.ShadowSoftness = 0 end)
        pcall(function() Lighting.GlobalShadows = false end)
        pcall(function() Lighting.FogEnd = 10000 end)
        for _, v in ipairs(Lighting:GetChildren()) do
            pcall(function() if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then v.Enabled = false end end)
        end
        for _, v in ipairs(Workspace:GetDescendants()) do
            pcall(function() if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = false end end)
        end
        fps_boosted = true
        send_notif("FPS BOOST", "Optimization enabled.", Color3.fromRGB(0, 255, 0))
    else
        pcall(function() Lighting.ShadowSoftness = 1 end)
        pcall(function() Lighting.GlobalShadows = true end)
        pcall(function() Lighting.FogEnd = 1000 end)
        for _, v in ipairs(Lighting:GetChildren()) do
            pcall(function() if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") then v.Enabled = true end end)
        end
        for _, v in ipairs(Workspace:GetDescendants()) do
            pcall(function() if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then v.Enabled = true end end)
        end
        fps_boosted = false
        send_notif("FPS BOOST", "Optimization disabled.", Color3.fromRGB(255, 0, 0))
    end
end

-- ============================================================
-- ANTI-AFK
-- ============================================================
local vu = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end
end)

-- ============================================================
-- WATERMARK
-- ============================================================
local wm_gui = Instance.new("ScreenGui")
wm_gui.Name = "SmokeWatermark"
wm_gui.ResetOnSpawn = false
wm_gui.Parent = game.CoreGui

local wm_frame = Instance.new("Frame")
wm_frame.Size = UDim2.new(0, 280, 0, 140)
wm_frame.Position = UDim2.new(0, 20, 0, 20)
wm_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
wm_frame.BackgroundTransparency = 0.3
wm_frame.BorderSizePixel = 0
wm_frame.Active = true
wm_frame.Draggable = true
wm_frame.Parent = wm_gui
Instance.new("UICorner", wm_frame).CornerRadius = UDim.new(0, 6)
local wm_stroke = Instance.new("UIStroke")
wm_stroke.Thickness = 2
wm_stroke.Parent = wm_frame
wm_frame.ClipsDescendants = true

local wm_title = Instance.new("TextLabel")
wm_title.Size = UDim2.new(1, -50, 0, 20)
wm_title.Position = UDim2.new(0, 5, 0, 5)
wm_title.BackgroundTransparency = 1
wm_title.Text = "SMOKExR'S | FPS: 0"
wm_title.TextColor3 = Color3.fromRGB(255, 255, 255)
wm_title.Font = Enum.Font.GothamBold
wm_title.TextSize = 12
wm_title.TextXAlignment = Enum.TextXAlignment.Left
wm_title.RichText = true
wm_title.Parent = wm_frame

local wm_stats = Instance.new("TextLabel")
wm_stats.Size = UDim2.new(1, -10, 0, 20)
wm_stats.Position = UDim2.new(0, 5, 0, 25)
wm_stats.BackgroundTransparency = 1
wm_stats.Text = "Alive: 0 | Dead: 0"
wm_stats.TextColor3 = Color3.fromRGB(0, 255, 120)
wm_stats.Font = Enum.Font.GothamBold
wm_stats.TextSize = 11
wm_stats.TextXAlignment = Enum.TextXAlignment.Left
wm_stats.Parent = wm_frame

local wm_credits = Instance.new("TextLabel")
wm_credits.Size = UDim2.new(1, -10, 0, 30)
wm_credits.Position = UDim2.new(0, 5, 0, 45)
wm_credits.BackgroundTransparency = 1
wm_credits.Text = "CREATOR: SMOKExR'S\nTESTER: SMOKExR'S"
wm_credits.TextColor3 = get_rainbow_color(1.5)
wm_credits.Font = Enum.Font.GothamBold
wm_credits.TextSize = 11
wm_credits.TextXAlignment = Enum.TextXAlignment.Left
wm_credits.Parent = wm_frame

local wm_info = Instance.new("TextLabel")
wm_info.Size = UDim2.new(1, -10, 0, 25)
wm_info.Position = UDim2.new(0, 5, 0, 110)
wm_info.BackgroundTransparency = 1
wm_info.Text = string.format("User: %s | Exec: PC", LocalPlayer.Name)
wm_info.TextColor3 = Color3.fromRGB(180, 180, 180)
wm_info.Font = Enum.Font.Gotham
wm_info.TextSize = 10
wm_info.TextXAlignment = Enum.TextXAlignment.Left
wm_info.Parent = wm_frame

local fps_frames, fps_last, fps_val = 0, tick(), 0
RunService.RenderStepped:Connect(function()
    if IsPanic then return end
    fps_frames = fps_frames + 1
    if tick() - fps_last >= 1 then
        fps_val = fps_frames; fps_frames = 0; fps_last = tick()
    end
    if RainbowUI then
        local rc = get_rainbow_color(RainbowSpeedUI)
        wm_stroke.Color = rc; wm_credits.TextColor3 = rc
    else
        wm_stroke.Color = ThemeColor; wm_credits.TextColor3 = ThemeColor
    end
end)

task.spawn(function()
    while wm_gui and wm_gui.Parent do
        task.wait(1)
        if not IsPanic then
            local ping = 0
            pcall(function()
                local item = Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"]
                if item then ping = math.floor(item:GetValue()) end
            end)
            local alive, dead = 0, 0
            for _, plr in ipairs(Players:GetPlayers()) do
                if is_alive(plr) then alive = alive + 1 else dead = dead + 1 end
            end
            wm_title.Text = string.format("SMOKExR'S | <font color='#00FF00'>FPS: %d | PING: %dms</font>", fps_val, ping)
            wm_stats.Text = string.format("Alive: %d | Dead: %d", alive, dead)
        end
    end
end)

-- ============================================================
-- HITBOX EXPANDER (memory-safe)
-- ============================================================
local original_sizes = {}
RunService.RenderStepped:Connect(function()
    if IsPanic then return end
    for part, saved in pairs(original_sizes) do
        if not part or not part.Parent or not part:IsDescendantOf(workspace) then
            original_sizes[part] = nil
        end
    end
    if Config.Hitbox.Enabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and is_alive(plr) and plr.Character
               and not (Config.ESP.TeamCheck and is_teammate(plr)) then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart")
                       and (part.Name == "HumanoidRootPart"
                            or part.Name:find("Torso")
                            or part.Name == "Head") then
                        if not original_sizes[part] then
                            original_sizes[part] = {size = part.Size, transparency = part.Transparency}
                        end
                        part.Size = Vector3.new(Config.Hitbox.Size, Config.Hitbox.Size, Config.Hitbox.Size)
                        part.Transparency = 1
                    end
                end
            end
        end
    else
        for part, saved in pairs(original_sizes) do
            if part and part.Parent then
                part.Size = saved.size
                part.Transparency = saved.transparency
            end
            original_sizes[part] = nil
        end
    end
end)

-- ============================================================
-- VEHICLE ESP (BillboardGui Text над техникой)
-- ============================================================
local veh_cache = {}
local veh_scanned = {}

local VEHICLE_FOLDERS = {"VehicleHulls", "Helicopters"}

-- Функция определения типа техники по имени
local function get_vehicle_label(name)
    local lname = name:lower()
    if lname:find("heli") or lname:find("верт") then return "Вертолет" end
    if lname:find("tank") or lname:find("танк") then return "Танк" end
    if lname:find("bmp") or lname:find("btr") or lname:find("бтр") then return "БТР" end
    if lname:find("car") or lname:find("vehicle") or lname:find("машин") then return "Машина" end
    -- Если не распознали по имени, смотрим на папку
    if lname:find("hull") then return "Наземный транспорт" end
    return "Техника"
end

local function create_vehicle_billboard(model, primary)
    -- Если уже есть — обновляем только цвет текста и позицию
    if veh_cache[model] then
        veh_cache[model].text.TextColor3 = Config.VehicleESP.Color
        return
    end

    -- Создаем BillboardGui над SolidRoot
    local bb = Instance.new("BillboardGui")
    bb.Name = "LokeiiVehBB"
    bb.Adornee = primary
    bb.Size = UDim2.new(0, 150, 0, 40)
    bb.StudsOffset = Vector3.new(0, primary.Size.Y / 2 + 2, 0) -- Чуть выше модели
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.Parent = model

    -- Текст
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = get_vehicle_label(model.Name)
    label.TextColor3 = Config.VehicleESP.Color
    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextScaled = false
    label.Parent = bb

    veh_cache[model] = {gui = bb, text = label}
end

task.spawn(function()
    while task.wait(1.0) do
        if IsPanic then continue end
        
        if Config.VehicleESP.Enabled then
            for _, folder_name in ipairs(VEHICLE_FOLDERS) do
                local folder = Workspace:FindFirstChild(folder_name)
                if folder then
                    for _, obj in ipairs(folder:GetChildren()) do
                        -- Проверяем только те, где есть SolidRoot
                        local primary = obj.PrimaryPart or obj:FindFirstChild("SolidRoot", true)
                        if primary and primary:IsA("BasePart") then
                            if not veh_scanned[obj] then
                                veh_scanned[obj] = true
                                create_vehicle_billboard(obj, primary)
                            elseif veh_cache[obj] then
                                -- Обновляем цвет на лету
                                veh_cache[obj].text.TextColor3 = Config.VehicleESP.Color
                            end
                        end
                    end
                end
            end
            
            -- Очистка, если машина исчезла/взорвалась
            for model, data in pairs(veh_cache) do
                if not model.Parent then
                    data.gui:Destroy()
                    veh_cache[model] = nil
                    veh_scanned[model] = nil
                end
            end
        else
            -- Выключили — удаляем все Billboard
            for model, data in pairs(veh_cache) do
                data.gui:Destroy()
            end
            veh_cache = {}
            veh_scanned = {}
        end
    end
end)
-- ============================================================
-- CHAMS
-- ============================================================
local chams_cache = {}
local function update_chams()
    if IsPanic then
        for _, hl in pairs(chams_cache) do hl:Destroy() end
        chams_cache = {}
        return
    end
    local rb_col = get_rainbow_color(1.5)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char or not is_alive(plr) or (Config.ESP.TeamCheck and is_teammate(plr)) then
            if chams_cache[plr] then chams_cache[plr]:Destroy(); chams_cache[plr] = nil end
            continue
        end
        if Config.Chams.Enabled then
            local color = Config.Chams.Rainbow and rb_col or Config.Chams.Color
            if not chams_cache[plr] then
                local hl = Instance.new("Highlight")
                hl.Parent = char
                hl.FillColor = color
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = Config.Chams.Transparency
                chams_cache[plr] = hl
            else
                chams_cache[plr].FillColor = color
                chams_cache[plr].FillTransparency = Config.Chams.Transparency
            end
        else
            if chams_cache[plr] then chams_cache[plr]:Destroy(); chams_cache[plr] = nil end
        end
    end
end

-- ============================================================
-- SKELETON
-- ============================================================
local HAS_DRAWING = (typeof(Drawing) == "table" and Drawing.new ~= nil)
local skel_cache = {}
local function create_skel(plr)
    if not HAS_DRAWING then return end
    local lines = {}
    for i = 1, 15 do
        local ok, l = pcall(function() return Drawing.new("Line") end)
        if not ok or not l then
            for _, old in ipairs(lines) do pcall(function() old:Remove() end) end
            return
        end
        l.Visible = false
        l.Thickness = Config.Skeleton.Thickness
        table.insert(lines, l)
    end
    skel_cache[plr] = lines
end
for _, plr in ipairs(Players:GetPlayers()) do create_skel(plr) end
Players.PlayerAdded:Connect(create_skel)
Players.PlayerRemoving:Connect(function(plr)
    if skel_cache[plr] then
        for _, l in ipairs(skel_cache[plr]) do pcall(function() l:Remove() end) end
        skel_cache[plr] = nil
    end
end)

local function draw_skeleton(plr, e_lines)
    if not e_lines then return end
    if not Config.Skeleton.Enabled or IsPanic then
        for _, l in ipairs(e_lines) do l.Visible = false end
        return
    end
    local rb_col = get_rainbow_color(1.5)
    local final_col = Config.Skeleton.Rainbow and rb_col or Config.Skeleton.Color
    for _, l in ipairs(e_lines) do l.Color = final_col end
    local char = plr.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local l_arm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
    local r_arm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
    local l_leg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
    local r_leg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
    if not head or not torso then
        for _, l in ipairs(e_lines) do l.Visible = false end
        return
    end
    local h_pos = world_to_screen(head.Position)
    local t_pos = world_to_screen(torso.Position)
    if not h_pos or not t_pos then
        for _, l in ipairs(e_lines) do l.Visible = false end
        return
    end
    local points = {h_pos, t_pos}
    for _, p in ipairs({l_arm, r_arm, l_leg, r_leg}) do
        if p then
            local s_pos = world_to_screen(p.Position)
            if s_pos then table.insert(points, s_pos) end
        end
    end
    local idx = 1
    e_lines[idx].From = h_pos; e_lines[idx].To = t_pos; e_lines[idx].Visible = true; idx = idx + 1
    for i = 3, #points do
        if idx > #e_lines then break end
        e_lines[idx].From = t_pos; e_lines[idx].To = points[i]; e_lines[idx].Visible = true; idx = idx + 1
    end
    for i = idx, #e_lines do e_lines[i].Visible = false end
end

-- ============================================================
-- FOV CIRCLE (FIXED CENTERING)
-- ============================================================
local fov_gui = Instance.new("ScreenGui")
fov_gui.Name = "SmokeFOV"
fov_gui.ResetOnSpawn = false
fov_gui.IgnoreGuiInset = true -- Игнорируем TopBar, чтобы круг был ровно по центру
fov_gui.Parent = game.CoreGui

local fov_circle = Instance.new("Frame")
fov_circle.AnchorPoint = Vector2.new(0.5, 0.5)
-- Позиция ровно по центру экрана
fov_circle.Position = UDim2.new(0.5, 0, 0.5, 0)
fov_circle.BackgroundTransparency = 1
fov_circle.Parent = fov_gui
local fov_stroke = Instance.new("UIStroke")
fov_stroke.Thickness = 1.5
fov_stroke.Transparency = 0.4
fov_stroke.Parent = fov_circle
Instance.new("UICorner", fov_circle).CornerRadius = UDim.new(1, 0)

RunService.RenderStepped:Connect(function()
    if not Config.Aimbot.Enabled or IsPanic then fov_circle.Visible = false return end
    fov_circle.Visible = true
    fov_circle.Size = UDim2.new(0, Config.Aimbot.FOV * 2, 0, Config.Aimbot.FOV * 2)
    
    -- Пересчитываем позицию каждый кадр (на случай ресайза окна)
    local viewport = Camera.ViewportSize
    fov_circle.Position = UDim2.new(0.5, 0, 0.5, 0) -- Если IgnoreGuiInset=true, то 0.5/0.5 идеальный центр
    
    if RainbowUI then
        fov_stroke.Color = get_rainbow_color(RainbowSpeedUI)
    else
        fov_stroke.Color = Config.FOV.Rainbow and get_rainbow_color(2) or Config.FOV.Color
    end
end)

-- ============================================================
-- ESP
-- ============================================================
local esp_cache = {}
local function create_esp(plr)
    if plr == LocalPlayer or not HAS_DRAWING then return end
    local ok, objs = pcall(function()
        local box = Drawing.new("Square"); box.Visible = false; box.Filled = false
        local name = Drawing.new("Text"); name.Center = true; name.Outline = true; name.Visible = false
        local dist = Drawing.new("Text"); dist.Center = true; dist.Outline = true; dist.Visible = false
        local hp_bg = Drawing.new("Square"); hp_bg.Filled = true; hp_bg.Color = Color3.fromRGB(0,0,0); hp_bg.Visible = false
        local hp_bar = Drawing.new("Square"); hp_bar.Filled = true; hp_bar.Visible = false
        local tracer = Drawing.new("Line"); tracer.Visible = false
        local name_bg = Drawing.new("Square"); name_bg.Filled = true; name_bg.Color = Color3.fromRGB(0,0,0); name_bg.Visible = false
        return {box=box, name=name, dist=dist, hp_bg=hp_bg, hp_bar=hp_bar, tracer=tracer, name_bg=name_bg}
    end)
    if ok and objs then esp_cache[plr] = objs end
end
for _, plr in ipairs(Players:GetPlayers()) do create_esp(plr) end
Players.PlayerAdded:Connect(create_esp)
Players.PlayerRemoving:Connect(function(plr)
    local e = esp_cache[plr]
    if e then
        for _, v in pairs(e) do pcall(function() v:Remove() end) end
        esp_cache[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    if IsPanic then
        for plr, e in pairs(esp_cache) do
            for _, v in pairs(e) do v.Visible = false end
            if skel_cache[plr] then for _, l in ipairs(skel_cache[plr]) do l.Visible = false end end
        end
        return
    end
    local rb_col = get_rainbow_color(Config.ESP.RainbowSpeed)
    update_chams()
    for plr, e in pairs(esp_cache) do
        if not Config.ESP.Enabled or not is_alive(plr) or (Config.ESP.TeamCheck and is_teammate(plr)) then
            for _, v in pairs(e) do v.Visible = false end
            if skel_cache[plr] then for _, l in ipairs(skel_cache[plr]) do l.Visible = false end end
            continue
        end
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not head or not hum then
            for _, v in pairs(e) do v.Visible = false end
            continue
        end
        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
        if distance > Config.ESP.MaxDistance then
            for _, v in pairs(e) do v.Visible = false end
            continue
        end
        local head_screen = world_to_screen(head.Position + Vector3.new(0, 0.5, 0))
        local foot_screen = world_to_screen(hrp.Position - Vector3.new(0, 3, 0))
        if not head_screen or not foot_screen then
            for _, v in pairs(e) do v.Visible = false end
            if skel_cache[plr] then for _, l in ipairs(skel_cache[plr]) do l.Visible = false end end
            continue
        end
        if skel_cache[plr] then draw_skeleton(plr, skel_cache[plr]) end
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
            e.name_bg.Position = Vector2.new(head_screen.X - bg_width / 2, y - Config.ESP.TextSize - 8)
            e.name_bg.Color = Color3.fromRGB(0, 0, 0)
            e.name_bg.Transparency = 0.5
        else
            e.name_bg.Visible = false
        end
        local tool = char:FindFirstChildWhichIsA("Tool")
        if tool and Config.ESP.Name then
            e.dist.Text = string.format("[%dm] | %s", math.floor(distance), tool.Name)
        end
        if Config.ESP.Health then
            local hp_pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            e.hp_bg.Visible = true
            e.hp_bg.Size = Vector2.new(4, height)
            e.hp_bg.Position = Vector2.new(x - 8, y)
            e.hp_bar.Visible = true
            e.hp_bar.Size = Vector2.new(4, height * hp_pct)
            e.hp_bar.Position = Vector2.new(x - 8, y + height * (1 - hp_pct))
            e.hp_bar.Color = Color3.fromRGB(255 * (1 - hp_pct), 255 * hp_pct, 0)
        else
            e.hp_bg.Visible = false
            e.hp_bar.Visible = false
        end
        e.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        e.tracer.To = Vector2.new(head_screen.X, y + height)
        e.tracer.Visible = Config.ESP.Tracer
        e.tracer.Color = final_box_col
    end
end)

-- ============================================================
-- AIMBOT
-- ============================================================
RunService.RenderStepped:Connect(function()
    if not Config.Aimbot.Enabled or IsPanic then return end
    if not Config.Aimbot.AlwaysOn then
        if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    end
    local char = get_character()
    if not char then return end
    local best, best_dist = nil, Config.Aimbot.FOV
    local center = Camera.ViewportSize / 2
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) then continue end
        if Config.Aimbot.TeamCheck and is_teammate(plr) then continue end
        local target_part = nil
        if Config.Aimbot.AimPart == "Head" then
            target_part = plr.Character:FindFirstChild("Head")
        elseif Config.Aimbot.AimPart == "Body" then
            target_part = plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("HumanoidRootPart")
        elseif Config.Aimbot.AimPart == "Legs" then
            target_part = plr.Character:FindFirstChild("LeftUpperLeg") or plr.Character:FindFirstChild("Left Leg") or plr.Character:FindFirstChild("HumanoidRootPart")
        end
        if not target_part then continue end
        local target_pos = target_part.Position
        if Config.Aimbot.WallCheck then
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {LocalPlayer.Character}
            params.IgnoreWater = true
            local dir = target_pos - Camera.CFrame.Position
            local hit = Workspace:Raycast(Camera.CFrame.Position, dir, params)
            if hit and (hit.Position - Camera.CFrame.Position).Magnitude < dir.Magnitude - 1 then continue end
        end
        local screen = world_to_screen(target_pos)
        if not screen then continue end
        local dist = (screen - center).Magnitude
        if dist < best_dist then best, best_dist = target_pos, dist end
    end
    if best then
        local current_pos = Camera.CFrame.Position
        local desired_rot = CFrame.lookAt(current_pos, best).Rotation
        local new_rot = Camera.CFrame.Rotation:Lerp(desired_rot, Config.Aimbot.Smoothness)
        Camera.CFrame = CFrame.new(current_pos) * new_rot
    end
end)

-- ============================================================
-- PANIC
-- ============================================================
local function toggle_panic()
    IsPanic = not IsPanic
    if IsPanic then
        wm_gui.Enabled = false
        notif_gui.Enabled = false
        fov_gui.Enabled = false
        for plr, e in pairs(esp_cache) do
            for _, v in pairs(e) do v.Visible = false end
            if skel_cache[plr] then for _, l in ipairs(skel_cache[plr]) do l.Visible = false end end
        end
        for _, hl in pairs(chams_cache) do hl:Destroy() end
        chams_cache = {}
        for part, saved in pairs(original_sizes) do
            if part and part.Parent then
                part.Size = saved.size
                part.Transparency = saved.transparency
            end
            original_sizes[part] = nil
        end
    else
        wm_gui.Enabled = true
        notif_gui.Enabled = true
        fov_gui.Enabled = true
        send_notif("PANIC", "Panic deactivated.", Color3.fromRGB(0, 255, 0))
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then toggle_panic() end
end)

-- ============================================================
-- CONFIG SAVE/LOAD
-- ============================================================
local function SaveConfig()
    local ok, err = pcall(function()
        writefile("SmokeConfig.json", HttpService:JSONEncode(Config))
    end)
    if ok then send_notif("CONFIG", "Saved.", Color3.fromRGB(0, 255, 0))
    else send_notif("CONFIG", "Save error: " .. tostring(err), Color3.fromRGB(255, 0, 0)) end
end
local function LoadConfig()
    local ok = pcall(function()
        if isfile("SmokeConfig.json") then
            local decoded = HttpService:JSONDecode(readfile("SmokeConfig.json"))
            for k, v in pairs(decoded) do
                if Config[k] then
                    if type(v) == "table" then
                        for k2, v2 in pairs(v) do
                            if type(v2) ~= "table" then Config[k][k2] = v2 end
                        end
                    else Config[k] = v end
                end
            end
            send_notif("CONFIG", "Loaded.", Color3.fromRGB(0, 255, 0))
        else send_notif("CONFIG", "No config.", Color3.fromRGB(255, 255, 0)) end
    end)
    if not ok then send_notif("CONFIG", "Load error.", Color3.fromRGB(255, 0, 0)) end
end

-- ============================================================
-- CROSSHAIR
-- ============================================================
local ch_gui = Instance.new("ScreenGui")
ch_gui.Name = "SmokeCrosshair"
ch_gui.ResetOnSpawn = false
ch_gui.IgnoreGuiInset = true
ch_gui.Parent = game.CoreGui
local ch_lines = {}
for i = 1, 4 do
    local l = Instance.new("Frame")
    l.AnchorPoint = Vector2.new(0.5, 0.5)
    l.Position = UDim2.new(0.5, 0, 0.5, 0)
    l.BorderSizePixel = 0
    l.Visible = false
    l.Parent = ch_gui
    ch_lines[i] = l
end
RunService.RenderStepped:Connect(function()
    local cfg = Config.Crosshair
    if not cfg.Enabled or IsPanic then
        for _, l in ipairs(ch_lines) do l.Visible = false end
        return
    end
    for _, l in ipairs(ch_lines) do l.Visible = true; l.BackgroundColor3 = cfg.Color end
    local s, t, g = cfg.Size, cfg.Thickness, cfg.Gap
    ch_lines[1].Size = UDim2.new(0, t, 0, s); ch_lines[1].Position = UDim2.new(0.5, 0, 0.5, -(g + s/2))
    ch_lines[2].Size = UDim2.new(0, t, 0, s); ch_lines[2].Position = UDim2.new(0.5, 0, 0.5,  (g + s/2))
    ch_lines[3].Size = UDim2.new(0, s, 0, t); ch_lines[3].Position = UDim2.new(0.5, -(g + s/2), 0.5, 0)
    ch_lines[4].Size = UDim2.new(0, s, 0, t); ch_lines[4].Position = UDim2.new(0.5,  (g + s/2), 0.5, 0)
end)

-- ============================================================
-- UI (Rayfield)
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "SMOKExR'S | LEGIT v51",
    LoadingTitle = "SMOKExR'S",
    LoadingSubtitle = "Bulletproof FPS Boost",
    ConfigurationSaving = { Enabled = false, FolderName = "SmokePremium", FileName = "VoxelV51" },
    KeySystem = false,
})

local ThemesTab = Window:CreateTab("Themes")
ThemesTab:CreateSection("UI Color")
ThemesTab:CreateButton({Name="Cyan (Default)", Callback=function() RainbowUI=false ThemeColor=Color3.fromRGB(0,255,255) Config.FOV.Color=ThemeColor send_notif("THEME","Cyan applied.",ThemeColor) end})
ThemesTab:CreateButton({Name="Purple", Callback=function() RainbowUI=false ThemeColor=Color3.fromRGB(150,0,255) Config.FOV.Color=ThemeColor send_notif("THEME","Purple applied.",ThemeColor) end})
ThemesTab:CreateButton({Name="Red", Callback=function() RainbowUI=false ThemeColor=Color3.fromRGB(255,0,0) Config.FOV.Color=ThemeColor send_notif("THEME","Red applied.",ThemeColor) end})
ThemesTab:CreateButton({Name="Green", Callback=function() RainbowUI=false ThemeColor=Color3.fromRGB(0,255,0) Config.FOV.Color=ThemeColor send_notif("THEME","Green applied.",ThemeColor) end})
ThemesTab:CreateButton({Name="Rainbow", Callback=function() RainbowUI=true send_notif("THEME","Rainbow applied.",Color3.fromRGB(255,255,255)) end})

local CombatTab = Window:CreateTab("Combat")
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({Name="Enable Aimbot", CurrentValue=false, Flag="aim_on", Callback=function(v) Config.Aimbot.Enabled=v send_notif("AIMBOT", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0), true) end})
CombatTab:CreateToggle({Name="Always-On (mobile)", CurrentValue=false, Flag="aim_always", Callback=function(v) Config.Aimbot.AlwaysOn=v end})
CombatTab:CreateToggle({Name="Ignore Teammates", CurrentValue=true, Flag="aim_team", Callback=function(v) Config.Aimbot.TeamCheck=v end})
CombatTab:CreateDropdown({Name="Aim Part", Options={"Head","Body","Legs"}, CurrentOption={"Head"}, Flag="aim_part", Callback=function(o) Config.Aimbot.AimPart=o[1] or o end})
CombatTab:CreateDropdown({Name="Preset", Options={"Hard (Rage)","Medium (Default)","Low (Legit)"}, CurrentOption={"Medium (Default)"}, Flag="aim_preset", Callback=function(o)
    local m = o[1] or o
    if m == "Hard (Rage)" then Config.Aimbot.Smoothness=1 Config.Aimbot.FOV=300
    elseif m == "Medium (Default)" then Config.Aimbot.Smoothness=0.15 Config.Aimbot.FOV=150
    elseif m == "Low (Legit)" then Config.Aimbot.Smoothness=0.05 Config.Aimbot.FOV=80 end
    send_notif("PRESET","Aim: "..m,Color3.fromRGB(255,150,0))
end})
CombatTab:CreateSlider({Name="FOV Radius", Range={50,500}, Increment=10, CurrentValue=150, Flag="aim_fov", Callback=function(v) Config.Aimbot.FOV=v end})
CombatTab:CreateSlider({Name="Smoothness", Range={0.01,1}, Increment=0.01, CurrentValue=0.15, Flag="aim_sm", Callback=function(v) Config.Aimbot.Smoothness=v end})
CombatTab:CreateToggle({Name="Wall Check", CurrentValue=true, Flag="aim_wall", Callback=function(v) Config.Aimbot.WallCheck=v end})

CombatTab:CreateSection("Hitbox Expander")
CombatTab:CreateToggle({Name="Enable Hitbox", CurrentValue=false, Flag="hitbox_on", Callback=function(v) Config.Hitbox.Enabled=v send_notif("HITBOX", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0), true) end})
CombatTab:CreateSlider({Name="Hitbox Size (legit 2-4)", Range={1,8}, Increment=1, CurrentValue=3, Flag="hitbox_size", Callback=function(v) Config.Hitbox.Size=v end})

local VisualTab = Window:CreateTab("Visuals")
VisualTab:CreateSection("ESP Master")
VisualTab:CreateToggle({Name="Enable ESP", CurrentValue=false, Flag="esp_on", Callback=function(v) Config.ESP.Enabled=v send_notif("ESP", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)) end})
VisualTab:CreateToggle({Name="Ignore Teammates", CurrentValue=true, Flag="esp_team", Callback=function(v) Config.ESP.TeamCheck=v end})
VisualTab:CreateToggle({Name="Box", CurrentValue=false, Flag="esp_box", Callback=function(v) Config.ESP.Box=v end})
VisualTab:CreateToggle({Name="Name", CurrentValue=false, Flag="esp_name", Callback=function(v) Config.ESP.Name=v end})
VisualTab:CreateToggle({Name="Health Bar", CurrentValue=false, Flag="esp_hp", Callback=function(v) Config.ESP.Health=v end})
VisualTab:CreateToggle({Name="Distance", CurrentValue=false, Flag="esp_dist", Callback=function(v) Config.ESP.Distance=v end})
VisualTab:CreateToggle({Name="Tracer", CurrentValue=false, Flag="esp_tracer", Callback=function(v) Config.ESP.Tracer=v end})
VisualTab:CreateSlider({Name="Max Distance", Range={100,5000}, Increment=100, CurrentValue=1500, Flag="esp_dist_max", Callback=function(v) Config.ESP.MaxDistance=v end})

VisualTab:CreateSection("Text")
VisualTab:CreateSlider({Name="Text Size", Range={12,32}, Increment=1, CurrentValue=18, Flag="esp_text_size", Callback=function(v) Config.ESP.TextSize=v end})
VisualTab:CreateToggle({Name="Text Outline", CurrentValue=true, Flag="esp_text_out", Callback=function(v) Config.ESP.TextOutline=v end})
VisualTab:CreateToggle({Name="Text Background", CurrentValue=true, Flag="esp_text_bg", Callback=function(v) Config.ESP.ShowBg=v end})

VisualTab:CreateSection("Skeleton")
VisualTab:CreateToggle({Name="Enable Skeleton", CurrentValue=false, Flag="skel_on", Callback=function(v) Config.Skeleton.Enabled=v send_notif("SKELETON", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0), true) end})
VisualTab:CreateToggle({Name="Rainbow Skeleton", CurrentValue=false, Flag="skel_rb", Callback=function(v) Config.Skeleton.Rainbow=v end})
VisualTab:CreateColorPicker({Name="Skeleton Color", Color=Config.Skeleton.Color, Flag="skel_col", Callback=function(c) Config.Skeleton.Color=c end})

VisualTab:CreateSection("Chams")
VisualTab:CreateToggle({Name="Enable Chams", CurrentValue=false, Flag="chams_on", Callback=function(v) Config.Chams.Enabled=v send_notif("CHAMS", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0), true) end})
VisualTab:CreateToggle({Name="Rainbow Chams", CurrentValue=false, Flag="chams_rb", Callback=function(v) Config.Chams.Rainbow=v end})
VisualTab:CreateColorPicker({Name="Chams Color", Color=Config.Chams.Color, Flag="chams_col", Callback=function(c) Config.Chams.Color=c end})
VisualTab:CreateSlider({Name="Chams Transparency", Range={0,1}, Increment=0.1, CurrentValue=0.5, Flag="chams_tr", Callback=function(v) Config.Chams.Transparency=v end})

VisualTab:CreateSection("Vehicle ESP")
VisualTab:CreateToggle({Name="Enable Vehicle ESP", CurrentValue=false, Flag="veh_on", Callback=function(v) Config.VehicleESP.Enabled=v send_notif("VEHICLE ESP", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)) end})
VisualTab:CreateColorPicker({Name="Vehicle Color", Color=Config.VehicleESP.Color, Flag="veh_col", Callback=function(c) Config.VehicleESP.Color=c end})

VisualTab:CreateSection("Colors")
VisualTab:CreateColorPicker({Name="Box Color", Color=Config.ESP.BoxColor, Flag="esp_box_col", Callback=function(c) Config.ESP.BoxColor=c end})
VisualTab:CreateToggle({Name="Rainbow Box", CurrentValue=false, Flag="esp_rb_box", Callback=function(v) Config.ESP.RainbowBox=v end})
VisualTab:CreateColorPicker({Name="Name Color", Color=Config.ESP.NameColor, Flag="esp_name_col", Callback=function(c) Config.ESP.NameColor=c end})
VisualTab:CreateToggle({Name="Rainbow Name", CurrentValue=false, Flag="esp_rb_name", Callback=function(v) Config.ESP.RainbowName=v end})
VisualTab:CreateColorPicker({Name="Dist Color", Color=Config.ESP.DistColor, Flag="esp_dist_col", Callback=function(c) Config.ESP.DistColor=c end})
VisualTab:CreateToggle({Name="Rainbow Dist", CurrentValue=false, Flag="esp_rb_dist", Callback=function(v) Config.ESP.RainbowDist=v end})
VisualTab:CreateSlider({Name="Rainbow Speed", Range={0.1,5}, Increment=0.1, CurrentValue=1, Flag="esp_rb_speed", Callback=function(v) Config.ESP.RainbowSpeed=v end})
VisualTab:CreateSlider({Name="Line Thickness", Range={1,5}, Increment=1, CurrentValue=1, Flag="esp_thick", Callback=function(v) Config.ESP.Thickness=v end})

local FOVTab = Window:CreateTab("FOV")
FOVTab:CreateSection("FOV Circle")
FOVTab:CreateToggle({Name="Rainbow FOV", CurrentValue=false, Flag="fov_rainbow", Callback=function(v) Config.FOV.Rainbow=v end})
FOVTab:CreateColorPicker({Name="FOV Color", Color=Config.FOV.Color, Flag="fov_col", Callback=function(c) Config.FOV.Color=c end})

local SettingsTab = Window:CreateTab("Settings")
SettingsTab:CreateSection("Performance")
SettingsTab:CreateToggle({Name="FPS Boost", CurrentValue=false, Flag="fps_boost", Callback=function(v) Config.FPSBoost=v ToggleFPSBoost() end})

SettingsTab:CreateSection("Crosshair")
SettingsTab:CreateToggle({Name="Enable Crosshair", CurrentValue=false, Flag="ch_on", Callback=function(v) Config.Crosshair.Enabled=v send_notif("CROSSHAIR", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)) end})
SettingsTab:CreateColorPicker({Name="Crosshair Color", Color=Config.Crosshair.Color, Flag="ch_color", Callback=function(c) Config.Crosshair.Color=c end})
SettingsTab:CreateSlider({Name="Crosshair Size", Range={2,20}, Increment=1, CurrentValue=10, Flag="ch_size", Callback=function(v) Config.Crosshair.Size=v end})
SettingsTab:CreateSlider({Name="Crosshair Gap", Range={0,15}, Increment=1, CurrentValue=4, Flag="ch_gap", Callback=function(v) Config.Crosshair.Gap=v end})
SettingsTab:CreateSlider({Name="Crosshair Thickness", Range={1,4}, Increment=1, CurrentValue=2, Flag="ch_thick", Callback=function(v) Config.Crosshair.Thickness=v end})

SettingsTab:CreateSection("Config")
SettingsTab:CreateButton({Name="Save Config", Callback=SaveConfig})
SettingsTab:CreateButton({Name="Load Config", Callback=LoadConfig})

SettingsTab:CreateSection("Misc")
SettingsTab:CreateToggle({Name="Anti-AFK", CurrentValue=false, Flag="antiafk", Callback=function(v) Config.AntiAFK=v send_notif("ANTI-AFK", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)) end})
SettingsTab:CreateLabel("Panic Key: Right Shift")

task.delay(10, function()
    send_notif("SYSTEM", "SMOKExR'S LEGIT v51 Loaded.", Color3.fromRGB(0, 255, 100))
end)
