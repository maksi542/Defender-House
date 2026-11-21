-- language: Lua (Luau), file: degrade_antimod_v115.lua, target: DEGRADE, executor: Solara / Delta / Fluxus
-- CREATOR SMOKExR'S | DEGRADE Anti-Mod Build (built by Lokeii)
-- Features: Clean ESP, Soft Aimbot, Mod ESP, Mod Alert, Mod List.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local SoundService = game:GetService("SoundService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- FPS UNLOCKER & RAYFIELD
-- ============================================================
pcall(function() if setfpscap then setfpscap(240) end end)

local Rayfield
local ok_rf, err_rf = pcall(function()
    local src = game:HttpGet('https://sirius.menu/rayfield')
    Rayfield = loadstring(src)()
end)
if not ok_rf or not Rayfield then
    warn("[DEGRADE] Rayfield failed. Fallback mode.")
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
            t.Text = "DEGRADE v115 — FALLBACK MODE"
            t.TextColor3 = Color3.fromRGB(255, 50, 50)
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
-- FAST LOADER
-- ============================================================
local load_gui = Instance.new("ScreenGui")
load_gui.Name = "DegradeLoader"
load_gui.ResetOnSpawn = false
load_gui.IgnoreGuiInset = true
load_gui.Parent = game.CoreGui

local load_bg = Instance.new("Frame")
load_bg.Size = UDim2.new(1, 0, 1, 0)
load_bg.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
load_bg.BorderSizePixel = 0
load_bg.Parent = load_gui

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, 0, 0, 80)
logo.Position = UDim2.new(0, 0, 0.38, 0)
logo.BackgroundTransparency = 1
logo.Text = "DEGRADE"
logo.TextColor3 = Color3.fromRGB(255, 0, 0)
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 48
logo.TextTransparency = 1
logo.Parent = load_bg
TweenService:Create(logo, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0.48, 0)
sub.BackgroundTransparency = 1
sub.Text = "ANTI-MOD BUILD  •  loading"
sub.TextColor3 = Color3.fromRGB(150, 150, 150)
sub.Font = Enum.Font.Gotham
sub.TextSize = 14
sub.TextTransparency = 1
sub.Parent = load_bg
TweenService:Create(sub, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

local bar_bg = Instance.new("Frame")
bar_bg.Size = UDim2.new(0, 300, 0, 4)
bar_bg.Position = UDim2.new(0.5, -150, 0.55, 0)
bar_bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bar_bg.BorderSizePixel = 0
bar_bg.Parent = load_bg
Instance.new("UICorner", bar_bg).CornerRadius = UDim.new(1, 0)

local bar_fill = Instance.new("Frame")
bar_fill.Size = UDim2.new(0, 0, 1, 0)
bar_fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
bar_fill.BorderSizePixel = 0
bar_fill.Parent = bar_bg
Instance.new("UICorner", bar_fill).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    local steps = {
        {"initializing...", 0.25},
        {"hooking mod detector...", 0.5},
        {"loading esp...", 0.75},
        {"system online", 1.0},
    }
    for _, step in ipairs(steps) do
        TweenService:Create(bar_fill, TweenInfo.new(0.7), {Size = UDim2.new(step[2], 0, 1, 0)}):Play()
        task.wait(0.75)
    end
    task.wait(0.3)
    TweenService:Create(load_bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(logo, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(sub, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    TweenService:Create(bar_bg, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(bar_fill, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    task.wait(0.7)
    load_gui:Destroy()
end)

-- ============================================================
-- CONFIG
-- ============================================================
local ThemeColor = Color3.fromRGB(255, 50, 50)
local RainbowUI = false
local RainbowSpeedUI = 1.5
local IsPanic = false

local Config = {
    Aimbot = {
        Enabled = false, FOV = 120, Smoothness = 0.08,
        WallCheck = true, TeamCheck = true,
        AimPart = "Head", AlwaysOn = false
    },
    ESP = {
        Enabled = false, Box = false,
        Name = false, Distance = false, Health = false, 
        MaxDistance = 2000, TeamCheck = true,
        RainbowBox = false, RainbowName = false, 
        RainbowDist = false, RainbowSpeed = 1,
        BoxColor = Color3.fromRGB(255, 50, 50),
        NameColor = Color3.fromRGB(255, 255, 255),
        DistColor = Color3.fromRGB(200, 200, 200),
        Thickness = 1, TextSize = 16, TextOutline = true,
    },
    Mod = {
        Enabled = false, Alert = false, ShowList = true,
        Color = Color3.fromRGB(0, 255, 0)
    },
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

-- Проверка на модера (по тегу, имени или группе)
local function is_moderator(plr)
    local name = plr.Name:lower()
    local display = plr.DisplayName:lower()
    
    -- 1. Проверка тегов в имени
    if name:find("mod") or name:find("admin") or name:find("staff") or name:find("owner") then return true end
    if display:find("mod") or display:find("admin") or display:find("staff") then return true end
    
    -- 2. Проверка по группе (если игра использует группы Roblox для админов)
    local ok, rank = pcall(function() return plr:GetRankInGroup(game.CreatorId) end)
    if ok and rank and rank >= 200 then -- 200+ это обычно админы в группах
        return true
    end
    
    -- 3. Проверка кастомных атрибутов в персонаже (если игра выдает тег через атрибуты)
    local char = plr.Character
    if char then
        if char:GetAttribute("Moderator") or char:GetAttribute("Admin") or char:GetAttribute("Staff") then return true end
    end
    
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
notif_gui.Name = "DegradeNotifs"
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
local function send_notif(title, text, color)
    if IsPanic then return end
    notif_order = notif_order + 1
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 44)
    box.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
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
    desc_lbl.Text = text
    desc_lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
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
-- MOD LIST UI
-- ============================================================
local mod_list_gui = Instance.new("ScreenGui")
mod_list_gui.Name = "DegradeModList"
mod_list_gui.ResetOnSpawn = false
mod_list_gui.IgnoreGuiInset = true
mod_list_gui.Parent = game.CoreGui

local mod_frame = Instance.new("Frame")
mod_frame.Size = UDim2.new(0, 200, 0, 30)
mod_frame.Position = UDim2.new(1, -220, 0, 60)
mod_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mod_frame.BackgroundTransparency = 0.3
mod_frame.BorderSizePixel = 0
mod_frame.Parent = mod_list_gui
Instance.new("UICorner", mod_frame).CornerRadius = UDim.new(0, 4)

local mod_title = Instance.new("TextLabel")
mod_title.Size = UDim2.new(1, 0, 0, 20)
mod_title.Position = UDim2.new(0, 5, 0, 5)
mod_title.BackgroundTransparency = 1
mod_title.Text = "Moderators Online: 0"
mod_title.TextColor3 = Color3.fromRGB(0, 255, 0)
mod_title.Font = Enum.Font.GothamBold
mod_title.TextSize = 12
mod_title.TextXAlignment = Enum.TextXAlignment.Left
mod_title.Parent = mod_frame

local mod_names = Instance.new("TextLabel")
mod_names.Size = UDim2.new(1, -10, 0, 10)
mod_names.Position = UDim2.new(0, 5, 0, 20)
mod_names.BackgroundTransparency = 1
mod_names.Text = ""
mod_names.TextColor3 = Color3.fromRGB(255, 255, 255)
mod_names.Font = Enum.Font.Gotham
mod_names.TextSize = 10
mod_names.TextXAlignment = Enum.TextXAlignment.Left
mod_names.TextWrapped = true
mod_names.Parent = mod_frame

-- ============================================================
-- ANTI-MOD ALERT SOUND
-- ============================================================
local alert_sound = Instance.new("Sound")
alert_sound.SoundId = "rbxassetid://131961136" -- Звук сирены/пищалки
alert_sound.Volume = 2
alert_sound.Parent = SoundService

local alert_label = Instance.new("TextLabel")
alert_label.Size = UDim2.new(1, 0, 0, 60)
alert_label.Position = UDim2.new(0, 0, 0.2, 0)
alert_label.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
alert_label.BackgroundTransparency = 1
alert_label.Text = ""
alert_label.TextColor3 = Color3.fromRGB(255, 0, 0)
alert_label.Font = Enum.Font.GothamBlack
alert_label.TextSize = 40
alert_label.TextStrokeTransparency = 0
alert_label.Parent = mod_list_gui

-- ============================================================
-- FPS BOOST & ANTI-AFK
-- ============================================================
local fps_boosted = false
local function ToggleFPSBoost()
    if fps_boosted == Config.FPSBoost then return end
    if Config.FPSBoost then
        pcall(function() Lighting.ShadowSoftness = 0 end)
        pcall(function() Lighting.GlobalShadows = false end)
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
wm_gui.Name = "DegradeWatermark"
wm_gui.ResetOnSpawn = false
wm_gui.Parent = game.CoreGui

local wm_frame = Instance.new("Frame")
wm_frame.Size = UDim2.new(0, 240, 0, 60)
wm_frame.Position = UDim2.new(0, 20, 0, 20)
wm_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
wm_frame.BackgroundTransparency = 0.3
wm_frame.BorderSizePixel = 0
wm_frame.Active = true
wm_frame.Draggable = true
wm_frame.Parent = wm_gui
Instance.new("UICorner", wm_frame).CornerRadius = UDim.new(0, 4)
local wm_stroke = Instance.new("UIStroke")
wm_stroke.Thickness = 1
wm_stroke.Parent = wm_frame

local wm_title = Instance.new("TextLabel")
wm_title.Size = UDim2.new(1, -10, 0, 20)
wm_title.Position = UDim2.new(0, 5, 0, 5)
wm_title.BackgroundTransparency = 1
wm_title.Text = "DEGRADE | FPS: 0"
wm_title.TextColor3 = Color3.fromRGB(255, 255, 255)
wm_title.Font = Enum.Font.GothamBold
wm_title.TextSize = 12
wm_title.TextXAlignment = Enum.TextXAlignment.Left
wm_title.RichText = true
wm_title.Parent = wm_frame

local fps_frames, fps_last, fps_val = 0, tick(), 0
RunService.RenderStepped:Connect(function()
    if IsPanic then return end
    fps_frames = fps_frames + 1
    if tick() - fps_last >= 1 then
        fps_val = fps_frames; fps_frames = 0; fps_last = tick()
    end
end)

task.spawn(function()
    while wm_gui and wm_gui.Parent do
        task.wait(1)
        if not IsPanic then
            wm_title.Text = string.format("DEGRADE | <font color='#FF0000'>FPS: %d</font>", fps_val)
        end
    end
end)

-- ============================================================
-- ESP + MOD DETECTOR
-- ============================================================
local HAS_DRAWING = (typeof(Drawing) == "table" and Drawing.new ~= nil)
local esp_cache = {}
local function create_esp(plr)
    if plr == LocalPlayer or not HAS_DRAWING then return end
    local ok, objs = pcall(function()
        local box = Drawing.new("Square"); box.Visible = false; box.Filled = false
        local name = Drawing.new("Text"); name.Center = true; name.Outline = true; name.Visible = false
        local dist = Drawing.new("Text"); dist.Center = true; dist.Outline = true; dist.Visible = false
        local mod_tag = Drawing.new("Text"); mod_tag.Center = true; mod_tag.Outline = true; mod_tag.Visible = false
        
        return {box=box, name=name, dist=dist, mod_tag=mod_tag}
    end)
    if ok and objs then esp_cache[plr] = objs end
end

for _, plr in ipairs(Players:GetPlayers()) do create_esp(plr) end
Players.PlayerAdded:Connect(create_esp)
Players.PlayerRemoving:Connect(function(plr)
    local e = esp_cache[plr]
    if e then
        for k, v in pairs(e) do pcall(function() v:Remove() end) end
        esp_cache[plr] = nil
    end
end)

local function hide_esp(e)
    e.box.Visible = false
    e.name.Visible = false
    e.dist.Visible = false
    if e.mod_tag then e.mod_tag.Visible = false end
end

-- Логика обновления Mod List
task.spawn(function()
    while task.wait(3) do
        if IsPanic then continue end
        if Config.Mod.ShowList then
            local mods = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and is_moderator(plr) then
                    table.insert(mods, plr.Name)
                end
            end
            if #mods > 0 then
                mod_title.Text = "Moderators Online: " .. #mods
                mod_names.Text = table.concat(mods, ", ")
                mod_frame.Size = UDim2.new(0, 200, 0, 30 + (#mods * 15))
            else
                mod_title.Text = "Moderators Online: 0"
                mod_names.Text = ""
                mod_frame.Size = UDim2.new(0, 200, 0, 30)
            end
        else
            mod_frame.Visible = false
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if IsPanic then
        for plr, e in pairs(esp_cache) do hide_esp(e) end
        alert_label.Text = ""
        return
    end
    
    local rb_col = get_rainbow_color(Config.ESP.RainbowSpeed)
    local mod_nearby = false
    
    for plr, e in pairs(esp_cache) do
        if not is_alive(plr) or (Config.ESP.TeamCheck and is_teammate(plr)) then
            hide_esp(e)
            continue
        end
        
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not head or not hum then
            hide_esp(e)
            continue
        end
        
        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
        if distance > Config.ESP.MaxDistance then
            hide_esp(e)
            continue
        end
        
        local head_screen = world_to_screen(head.Position + Vector3.new(0, 0.5, 0))
        local foot_screen = world_to_screen(hrp.Position - Vector3.new(0, 3, 0))
        
        if not head_screen or not foot_screen then
            hide_esp(e)
            continue
        end
        
        -- Проверка на модера
        local plr_is_mod = is_moderator(plr)
        if plr_is_mod and distance < 200 then
            mod_nearby = true
        end
        
        -- Если модер, принудительно включаем ESP для него, даже если основной выключен
        local draw_esp = Config.ESP.Enabled or (plr_is_mod and Config.Mod.Enabled)
        
        if draw_esp then
            local height = math.abs(head_screen.Y - foot_screen.Y)
            local width = height * 0.5
            local x = head_screen.X - width / 2
            local y = head_screen.Y
            
            -- Цвет: Зеленый для модеров, обычный для остальных
            local final_box_col = plr_is_mod and Config.Mod.Color or (Config.ESP.RainbowBox and rb_col or Config.ESP.BoxColor)
            local final_name_col = plr_is_mod and Config.Mod.Color or (Config.ESP.RainbowName and rb_col or Config.ESP.NameColor)
            
            e.box.Visible = true
            e.box.Size = Vector2.new(width, height)
            e.box.Position = Vector2.new(x, y)
            e.box.Color = final_box_col
            e.box.Thickness = Config.ESP.Thickness
            
            e.name.Text = plr.Name
            e.name.Size = Config.ESP.TextSize
            e.name.Position = Vector2.new(head_screen.X, y - Config.ESP.TextSize - 6)
            e.name.Visible = true
            e.name.Color = final_name_col
            e.name.Outline = Config.ESP.TextOutline
            
            e.dist.Text = string.format("[%dm]", math.floor(distance))
            e.dist.Size = Config.ESP.TextSize - 2
            e.dist.Position = Vector2.new(head_screen.X, y + height + 4)
            e.dist.Visible = true
            e.dist.Color = Config.ESP.DistColor
            e.dist.Outline = Config.ESP.TextOutline
            
            -- Тег [MOD] над головой
            if plr_is_mod then
                e.mod_tag.Text = "MODERATOR"
                e.mod_tag.Size = Config.ESP.TextSize + 4
                e.mod_tag.Position = Vector2.new(head_screen.X, y - Config.ESP.TextSize - 25)
                e.mod_tag.Visible = true
                e.mod_tag.Color = Config.Mod.Color
                e.mod_tag.Outline = true
            else
                e.mod_tag.Visible = false
            end
        else
            hide_esp(e)
        end
    end
    
    -- Алерт при приближении модера
    if mod_nearby and Config.Mod.Alert then
        alert_label.Text = "⚠️ WARNING: MOD NEARBY ⚠️"
        if not alert_sound.Playing then alert_sound:Play() end
    else
        alert_label.Text = ""
        if alert_sound.Playing then alert_sound:Stop() end
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
        if is_moderator(plr) then continue end -- Игнорируем модеров в аимботе (чтобы не убить и не спалиться)
        
        local target_part = nil
        if Config.Aimbot.AimPart == "Head" then
            target_part = plr.Character:FindFirstChild("Head")
        elseif Config.Aimbot.AimPart == "Body" then
            target_part = plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("HumanoidRootPart")
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
        mod_list_gui.Enabled = false
        alert_label.Text = ""
        if alert_sound.Playing then alert_sound:Stop() end
        for plr, e in pairs(esp_cache) do hide_esp(e) end
    else
        wm_gui.Enabled = true
        notif_gui.Enabled = true
        mod_list_gui.Enabled = true
        send_notif("PANIC", "Panic deactivated.", Color3.fromRGB(0, 255, 0))
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then toggle_panic() end
end)

-- ============================================================
-- UI (Rayfield) - DEGRADE Anti-Mod Menu
-- ============================================================
local originalCreateWindow = Rayfield.CreateWindow
Rayfield.CreateWindow = function(self, opts)
    local win = originalCreateWindow(self, opts)
    if win and win.MainFrame then
        win.MainFrame.BackgroundTransparency = 1
        TweenService:Create(win.MainFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    end
    return win
end

local Window = Rayfield:CreateWindow({
    Name = "DEGRADE | ANTI-MOD EDITION",
    LoadingTitle = "DEGRADE",
    LoadingSubtitle = "Anti-Mod Build",
    ConfigurationSaving = { Enabled = false, FolderName = "DegradeBuild", FileName = "v115" },
    KeySystem = false,
})

local CombatTab = Window:CreateTab("Combat")
CombatTab:CreateSection("Aimbot (Soft)")
CombatTab:CreateToggle({Name="Enable Aimbot", CurrentValue=false, Flag="aim_on", Callback=function(v) Config.Aimbot.Enabled=v send_notif("AIMBOT", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)) end})
CombatTab:CreateToggle({Name="Always-On (mobile)", CurrentValue=false, Flag="aim_always", Callback=function(v) Config.Aimbot.AlwaysOn=v end})
CombatTab:CreateToggle({Name="Ignore Teammates", CurrentValue=true, Flag="aim_team", Callback=function(v) Config.Aimbot.TeamCheck=v end})
CombatTab:CreateDropdown({Name="Aim Part", Options={"Head","Body"}, CurrentOption={"Head"}, Flag="aim_part", Callback=function(o) Config.Aimbot.AimPart=o[1] or o end})
CombatTab:CreateSlider({Name="FOV Radius", Range={50,400}, Increment=10, CurrentValue=120, Flag="aim_fov", Callback=function(v) Config.Aimbot.FOV=v end})
CombatTab:CreateSlider({Name="Smoothness (0.01 = fast)", Range={0.01,1}, Increment=0.01, CurrentValue=0.08, Flag="aim_sm", Callback=function(v) Config.Aimbot.Smoothness=v end})
CombatTab:CreateToggle({Name="Wall Check", CurrentValue=true, Flag="aim_wall", Callback=function(v) Config.Aimbot.WallCheck=v end})

local VisualTab = Window:CreateTab("Visuals")
VisualTab:CreateSection("ESP Master")
VisualTab:CreateToggle({Name="Enable ESP", CurrentValue=false, Flag="esp_on", Callback=function(v) Config.ESP.Enabled=v send_notif("ESP", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)) end})
VisualTab:CreateToggle({Name="Ignore Teammates", CurrentValue=true, Flag="esp_team", Callback=function(v) Config.ESP.TeamCheck=v end})
VisualTab:CreateToggle({Name="Box", CurrentValue=false, Flag="esp_box", Callback=function(v) Config.ESP.Box=v end})
VisualTab:CreateToggle({Name="Name", CurrentValue=false, Flag="esp_name", Callback=function(v) Config.ESP.Name=v end})
VisualTab:CreateToggle({Name="Distance", CurrentValue=false, Flag="esp_dist", Callback=function(v) Config.ESP.Distance=v end})
VisualTab:CreateSlider({Name="Max Distance", Range={100,5000}, Increment=100, CurrentValue=2000, Flag="esp_dist_max", Callback=function(v) Config.ESP.MaxDistance=v end})

VisualTab:CreateSection("Text Style")
VisualTab:CreateSlider({Name="Text Size", Range={12,24}, Increment=1, CurrentValue=16, Flag="esp_text_size", Callback=function(v) Config.ESP.TextSize=v end})
VisualTab:CreateToggle({Name="Text Outline", CurrentValue=true, Flag="esp_text_out", Callback=function(v) Config.ESP.TextOutline=v end})

VisualTab:CreateSection("Colors")
VisualTab:CreateColorPicker({Name="Box Color", Color=Config.ESP.BoxColor, Flag="esp_box_col", Callback=function(c) Config.ESP.BoxColor=c end})
VisualTab:CreateToggle({Name="Rainbow Box", CurrentValue=false, Flag="esp_rb_box", Callback=function(v) Config.ESP.RainbowBox=v end})
VisualTab:CreateColorPicker({Name="Name Color", Color=Config.ESP.NameColor, Flag="esp_name_col", Callback=function(c) Config.ESP.NameColor=c end})
VisualTab:CreateToggle({Name="Rainbow Name", CurrentValue=false, Flag="esp_rb_name", Callback=function(v) Config.ESP.RainbowName=v end})
VisualTab:CreateColorPicker({Name="Dist Color", Color=Config.ESP.DistColor, Flag="esp_dist_col", Callback=function(c) Config.ESP.DistColor=c end})
VisualTab:CreateToggle({Name="Rainbow Dist", CurrentValue=false, Flag="esp_rb_dist", Callback=function(v) Config.ESP.RainbowDist=v end})
VisualTab:CreateSlider({Name="Line Thickness", Range={1,4}, Increment=1, CurrentValue=1, Flag="esp_thick", Callback=function(v) Config.ESP.Thickness=v end})

local ModTab = Window:CreateTab("Mods")
ModTab:CreateSection("Mod Detector")
ModTab:CreateToggle({Name="Mod ESP (Force Green Box)", CurrentValue=false, Flag="mod_esp", Callback=function(v) Config.Mod.Enabled=v send_notif("MOD ESP", v and "Enabled" or "Disabled", Color3.fromRGB(0,255,0)) end})
ModTab:CreateToggle({Name="Alert when Mod < 200m", CurrentValue=false, Flag="mod_alert", Callback=function(v) Config.Mod.Alert=v end})
ModTab:CreateToggle({Name="Show Mod List (Top Right)", CurrentValue=true, Flag="mod_list", Callback=function(v) Config.Mod.ShowList=v; mod_frame.Visible=v end})
ModTab:CreateColorPicker({Name="Mod Color", Color=Config.Mod.Color, Flag="mod_col", Callback=function(c) Config.Mod.Color=c end})

local SettingsTab = Window:CreateTab("Settings")
SettingsTab:CreateSection("Performance")
SettingsTab:CreateToggle({Name="FPS Boost (No shadows/effects)", CurrentValue=false, Flag="fps_boost", Callback=function(v) Config.FPSBoost=v ToggleFPSBoost() end})

SettingsTab:CreateSection("Misc")
SettingsTab:CreateToggle({Name="Anti-AFK", CurrentValue=false, Flag="antiafk", Callback=function(v) Config.AntiAFK=v end})
SettingsTab:CreateLabel("Panic Key: Right Shift (hides all)")

task.delay(10, function()
    send_notif("DEGRADE", "Anti-Mod Build Loaded.", Color3.fromRGB(255, 50, 50))
end)
