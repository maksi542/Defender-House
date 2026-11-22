-- language: Lua (Luau), file: degrade_v140.lua, target: DEGRADE (KnightsInteractive)
-- CREATOR SMOKExR'S | Built by Lokeii
-- Full monolith: Loader + UI + Player ESP + Aimbot + Ore/Base Scanner + Watermark

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- 1. КОНФИГ
-- ============================================================
local Config = {
    OreESP = {
        Enabled = false, MaxDistance = 500, TextSize = 14,
        ShowSulfur = true, ShowMetal = true, ShowStone = true,
        ColorSulfur = Color3.fromRGB(255, 255, 0),
        ColorMetal = Color3.fromRGB(180, 180, 180),
        ColorStone = Color3.fromRGB(130, 130, 130),
    },
    BaseScan = {
        Enabled = false, MaxDistance = 500, TextSize = 16,
        ShowCupboards = true, ShowChests = true, ShowStashes = true,
        ColorCupboard = Color3.fromRGB(0, 255, 0),
        ColorChest = Color3.fromRGB(255, 150, 0),
        ColorStash = Color3.fromRGB(255, 255, 0),
    },
    PlayerESP = {
        Enabled = false, Box = false, Name = true, Health = true, Distance = true,
        MaxDistance = 2000, TeamCheck = true,
        BoxColor = Color3.fromRGB(255, 50, 50), NameColor = Color3.fromRGB(255, 255, 255),
    },
    Aimbot = {
        Enabled = false, FOV = 120, Smoothness = 0.15, TeamCheck = true,
        AimPart = "Head", Key = Enum.UserInputType.MouseButton2
    },
    Notifications = { Enabled = true },
    Watermark = { Enabled = true },
    AntiAFK = true
}

local IsPanic = false

-- ============================================================
-- 2. УТИЛИТЫ И ЖЕСТКИЕ ИСКЛЮЧЕНИЯ (из дампа)
-- ============================================================
local FORCE_IGNORE = {
    "hitbox", "collision", "firstpersonlegs", "asphalt", "slab", "road",
    "trigger", "invisible", "preview", "ghost", "template", "engine switch",
    "outpostchristmastree", "firstperson", "camera", "tabviewsheet",
    "fence", "wall", "floor", "foundation", "door", "window"
}

local function is_forced_ignore(obj_name, parent_name)
    local ln = obj_name:lower()
    local lp = (parent_name or ""):lower()
    for _, w in ipairs(FORCE_IGNORE) do
        if ln:find(w, 1, true) or lp:find(w, 1, true) then return true end
    end
    return false
end

local function is_valid_target(primary)
    if not primary or not primary:IsDescendantOf(Workspace) then return false end
    if primary.Transparency >= 0.95 then return false end
    if primary.Size.Magnitude < 1 then return false end
    return true
end

local function get_primary(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    end
    return nil
end

local function get_char_hrp()
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hrp and hum and hum.Health > 0 then return char, hrp, hum end
    return nil
end

-- ============================================================
-- 3. КЛАССИФИКАТОРЫ (Оре/Базы)
-- ============================================================
local function classify_ore(name_str)
    local n = name_str:lower()
    if n:find("sulfur") or n:find("sulphur") or n:find("сера") then return "SULFUR" end
    if n:find("metal") or n:find("iron") or n:find("железо") or n:find("металл") then return "METAL" end
    if n:find("stone") or n:find("rock") or n:find("камень") then return "STONE" end
    if n:find("ore") or n:find("руда") or n:find("node") then return "ORE" end
    return nil
end

local BASE_EXACT = {
    cupboard = "CUPBOARD", toolcupboard = "CUPBOARD", tool_cupboard = "CUPBOARD", tc = "CUPBOARD", шкаф = "CUPBOARD",
    chest = "CHEST", crate = "CHEST", сундук = "CHEST", ящик = "CHEST",
    stash = "STASH", cache = "STASH", тайник = "STASH", схрон = "STASH"
}

local function classify_base(name_str)
    local n = name_str:lower()
    for key, b_type in pairs(BASE_EXACT) do
        if n == key or n:match("^" .. key .. "[_%-]") or n:match("[_%-]" .. key .. "$") or n:match("[_%-]" .. key .. "[_%-]") then
            return b_type
        end
    end
    return nil
end

-- ============================================================
-- 4. NOTIFICATIONS
-- ============================================================
local notif_gui = Instance.new("ScreenGui")
notif_gui.Name = "DegradeNotifs"
notif_gui.ResetOnSpawn = false
notif_gui.Parent = CoreGui

local notif_frame = Instance.new("Frame")
notif_frame.Size = UDim2.new(0, 300, 0, 400)
notif_frame.Position = UDim2.new(1, -320, 1, -420)
notif_frame.BackgroundTransparency = 1
notif_frame.Parent = notif_gui

local notif_layout = Instance.new("UIListLayout")
notif_layout.Padding = UDim.new(0, 5)
notif_layout.SortOrder = Enum.SortOrder.LayoutOrder
notif_layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notif_layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notif_layout.Parent = notif_frame

local notif_order = 0
local function send_notif(title, text, color)
    if IsPanic or not Config.Notifications.Enabled then return end
    notif_order = notif_order + 1
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 0, 50)
    box.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    box.BackgroundTransparency = 0.1
    box.LayoutOrder = notif_order
    box.Parent = notif_frame
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
    
    local stroke = Instance.new("UIStroke", box)
    stroke.Color = color or Color3.fromRGB(255, 50, 50)

    local t_lbl = Instance.new("TextLabel", box)
    t_lbl.Size = UDim2.new(1, -10, 0, 20)
    t_lbl.Position = UDim2.new(0, 5, 0, 4)
    t_lbl.BackgroundTransparency = 1
    t_lbl.Text = title
    t_lbl.TextColor3 = color or Color3.fromRGB(255, 50, 50)
    t_lbl.Font = Enum.Font.GothamBold
    t_lbl.TextSize = 13
    t_lbl.TextXAlignment = Enum.TextXAlignment.Left

    local d_lbl = Instance.new("TextLabel", box)
    d_lbl.Size = UDim2.new(1, -10, 0, 24)
    d_lbl.Position = UDim2.new(0, 5, 0, 22)
    d_lbl.BackgroundTransparency = 1
    d_lbl.Text = text
    d_lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    d_lbl.Font = Enum.Font.Gotham
    d_lbl.TextSize = 12
    d_lbl.TextWrapped = true
    d_lbl.TextXAlignment = Enum.TextXAlignment.Left

    task.delay(4, function()
        TweenService:Create(box, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(t_lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(d_lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.3)
        box:Destroy()
    end)
end

-- ============================================================
-- 5. ДВИЖОК ОТРИСОВКИ (Billboard)
-- ============================================================
local ore_cache = {}
local base_cache = {}

local function create_billboard(primary, text, color, text_size)
    local bb = Instance.new("BillboardGui")
    bb.Name = "LokeiiESP"
    bb.Adornee = primary
    bb.Size = UDim2.new(0, 100, 0, 30)
    bb.AlwaysOnTop = true
    bb.StudsOffsetWorldSpace = primary.CFrame.UpVector * (primary.Size.Y / 2 + 1)
    bb.Parent = primary

    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = text_size or 14

    return { gui = bb, label = lbl, primary = primary }
end

-- ============================================================
-- 6. СКАНЕРЫ
-- ============================================================
local function scan_ores()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if not (obj:IsA("Model") or obj:IsA("BasePart")) then continue end
        if ore_cache[obj] then continue end
        local primary = get_primary(obj)
        if not primary or not is_valid_target(primary) then continue end
        if is_forced_ignore(obj.Name, primary.Name) then continue end
        
        local o_type = classify_ore(obj.Name .. "_" .. primary.Name)
        if not o_type then continue end
        if o_type == "SULFUR" and not Config.OreESP.ShowSulfur then continue end
        if o_type == "METAL" and not Config.OreESP.ShowMetal then continue end
        if o_type == "STONE" and not Config.OreESP.ShowStone then continue end
        if o_type == "ORE" and not Config.OreESP.ShowStone then continue end
        
        local color = Config.OreESP.ColorStone
        if o_type == "SULFUR" then color = Config.OreESP.ColorSulfur end
        if o_type == "METAL" then color = Config.OreESP.ColorMetal end
        
        ore_cache[obj] = create_billboard(primary, o_type, color, Config.OreESP.TextSize)
    end
end

local function scan_bases()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if not (obj:IsA("Model") or obj:IsA("BasePart")) then continue end
        if base_cache[obj] then continue end
        local primary = get_primary(obj)
        if not primary or not is_valid_target(primary) then continue end
        if is_forced_ignore(obj.Name, primary.Name) then continue end
        
        local b_type = classify_base(obj.Name .. "_" .. primary.Name)
        if not b_type then continue end
        if b_type == "CUPBOARD" and not Config.BaseScan.ShowCupboards then continue end
        if b_type == "CHEST" and not Config.BaseScan.ShowChests then continue end
        if b_type == "STASH" and not Config.BaseScan.ShowStashes then continue end
        
        local color = Config.BaseScan.ColorStash
        if b_type == "CUPBOARD" then color = Config.BaseScan.ColorCupboard end
        if b_type == "CHEST" then color = Config.BaseScan.ColorChest end
        
        base_cache[obj] = create_billboard(primary, b_type, color, Config.BaseScan.TextSize)
    end
end

-- ============================================================
-- 7. PLAYER ESP & AIMBOT
-- ============================================================
local player_esp_cache = {}
local player_esp_gui = Instance.new("ScreenGui")
player_esp_gui.Name = "DegradePlayerESP"
player_esp_gui.ResetOnSpawn = false
player_esp_gui.Parent = CoreGui

local function create_player_esp(plr)
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = plr.Name .. "_ESP"
    bb.Adornee = hrp
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.AlwaysOnTop = true
    bb.Parent = hrp
    
    local name_lbl = Instance.new("TextLabel", bb)
    name_lbl.Size = UDim2.new(1, 0, 0, 15)
    name_lbl.Position = UDim2.new(0, 0, 0, 0)
    name_lbl.BackgroundTransparency = 1
    name_lbl.Text = plr.Name
    name_lbl.TextColor3 = Config.PlayerESP.NameColor
    name_lbl.TextStrokeTransparency = 0
    name_lbl.Font = Enum.Font.GothamBold
    name_lbl.TextSize = 12

    local dist_lbl = Instance.new("TextLabel", bb)
    dist_lbl.Size = UDim2.new(1, 0, 0, 15)
    dist_lbl.Position = UDim2.new(0, 0, 0, 16)
    dist_lbl.BackgroundTransparency = 1
    dist_lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    dist_lbl.TextStrokeTransparency = 0
    dist_lbl.Font = Enum.Font.Gotham
    dist_lbl.TextSize = 11

    player_esp_cache[plr] = { bb = bb, name_lbl = name_lbl, dist_lbl = dist_lbl, hrp = hrp }
end

local function update_player_esp()
    if not Config.PlayerESP.Enabled then
        for plr, data in pairs(player_esp_cache) do data.bb.Enabled = false end
        return
    end

    local char, my_hrp = get_char_hrp()
    if not my_hrp then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if Config.PlayerESP.TeamCheck and plr.Team == LocalPlayer.Team then continue end
        
        if not player_esp_cache[plr] then create_player_esp(plr) end
        
        local data = player_esp_cache[plr]
        if data and data.bb and data.bb.Parent then
            local p_hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
            if p_hrp then
                local dist = (p_hrp.Position - my_hrp.Position).Magnitude
                if dist <= Config.PlayerESP.MaxDistance then
                    data.bb.Enabled = true
                    data.name_lbl.Visible = Config.PlayerESP.Name
                    data.dist_lbl.Visible = Config.PlayerESP.Distance
                    if Config.PlayerESP.Distance then
                        data.dist_lbl.Text = string.format("[%d studs]", dist)
                    end
                else
                    data.bb.Enabled = false
                end
            end
        end
    end
end

local function get_closest_player()
    local char, my_hrp = get_char_hrp()
    if not my_hrp then return nil end
    
    local closest, min_dist = nil, Config.Aimbot.FOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if Config.Aimbot.TeamCheck and plr.Team == LocalPlayer.Team then continue end
        local p_char = plr.Character
        if p_char then
            local part = p_char:FindFirstChild(Config.Aimbot.AimPart)
            if part then
                local pos, on_screen = Camera:WorldToViewportPoint(part.Position)
                if on_screen then
                    local mouse = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if dist < min_dist then
                        min_dist = dist
                        closest = part
                    end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Config.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Config.Aimbot.Key) then
        local target = get_closest_player()
        if target then
            local target_cf = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(target_cf, Config.Aimbot.Smoothness)
        end
    end
end)

-- ============================================================
-- 8. АНТИ-АФК
-- ============================================================
task.spawn(function()
    while task.wait(60) do
        if Config.AntiAFK and not IsPanic then
            local _, hrp, hum = get_char_hrp()
            if hrp and hum then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(-15, 15)), 0)
            end
        end
    end
end)

-- ============================================================
-- 9. ГЛАВНЫЙ ЦИКЛ
-- ============================================================
local last_scan = 0
RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - last_scan > 2.0 then
        last_scan = now
        if Config.OreESP.Enabled then scan_ores() end
        if Config.BaseScan.Enabled then scan_bases() end
    end
    
    -- Очистка кэша
    local cam_pos = Camera.CFrame.Position
    for obj, data in pairs(ore_cache) do
        if not obj.Parent or not data.primary:IsDescendantOf(Workspace) then
            data.gui:Destroy(); ore_cache[obj] = nil
        else
            data.gui.Enabled = Config.OreESP.Enabled and (data.primary.Position - cam_pos).Magnitude <= Config.OreESP.MaxDistance
        end
    end
    for obj, data in pairs(base_cache) do
        if not obj.Parent or not data.primary:IsDescendantOf(Workspace) then
            data.gui:Destroy(); base_cache[obj] = nil
        else
            data.gui.Enabled = Config.BaseScan.Enabled and (data.primary.Position - cam_pos).Magnitude <= Config.BaseScan.MaxDistance
        end
    end
    
    if Config.PlayerESP.Enabled then update_player_esp() end
end)

-- ============================================================
-- 10. WATERMARK (HUD)
-- ============================================================
local wm_gui = Instance.new("ScreenGui")
wm_gui.Name = "Degrade_WM"
wm_gui.ResetOnSpawn = false
wm_gui.Parent = CoreGui

local wm_frame = Instance.new("Frame")
wm_frame.Size = UDim2.new(0, 220, 0, 60)
wm_frame.Position = UDim2.new(0, 20, 0, 20)
wm_frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
wm_frame.BackgroundTransparency = 0.3
wm_frame.BorderSizePixel = 0
wm_frame.Active = true
wm_frame.Draggable = true
wm_frame.Parent = wm_gui
Instance.new("UICorner", wm_frame).CornerRadius = UDim.new(0, 6)
local wm_stroke = Instance.new("UIStroke", wm_frame)
wm_stroke.Color = Color3.fromRGB(255, 50, 50)

local wm_title = Instance.new("TextLabel", wm_frame)
wm_title.Size = UDim2.new(1, -10, 0, 20)
wm_title.Position = UDim2.new(0, 5, 0, 5)
wm_title.BackgroundTransparency = 1
wm_title.Text = "DEGRADE | v140"
wm_title.TextColor3 = Color3.fromRGB(255, 255, 255)
wm_title.Font = Enum.Font.GothamBold
wm_title.TextSize = 14
wm_title.TextXAlignment = Enum.TextXAlignment.Left

local wm_stats = Instance.new("TextLabel", wm_frame)
wm_stats.Size = UDim2.new(1, -10, 0, 15)
wm_stats.Position = UDim2.new(0, 5, 0, 25)
wm_stats.BackgroundTransparency = 1
wm_stats.TextColor3 = Color3.fromRGB(180, 180, 180)
wm_stats.Font = Enum.Font.Gotham
wm_stats.TextSize = 11
wm_stats.TextXAlignment = Enum.TextXAlignment.Left

local wm_keys = Instance.new("TextLabel", wm_frame)
wm_keys.Size = UDim2.new(1, -10, 0, 15)
wm_keys.Position = UDim2.new(0, 5, 0, 40)
wm_keys.BackgroundTransparency = 1
wm_keys.Text = "F1: Ore | F2: Base | F3: Plr | F4: Aim"
wm_keys.TextColor3 = Color3.fromRGB(255, 100, 100)
wm_keys.Font = Enum.Font.Gotham
wm_keys.TextSize = 10
wm_keys.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while task.wait(1) do
        local o, b = 0, 0
        for _ in pairs(ore_cache) do o = o + 1 end
        for _ in pairs(base_cache) do b = b + 1 end
        wm_stats.Text = string.format("Ores: %d | Bases: %d", o, b)
    end
end)

-- ============================================================
-- 11. ХОТКЕИ
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        Config.OreESP.Enabled = not Config.OreESP.Enabled
        send_notif("Ore ESP", Config.OreESP.Enabled and "ON" or "OFF", Color3.fromRGB(0, 255, 0))
    elseif input.KeyCode == Enum.KeyCode.F2 then
        Config.BaseScan.Enabled = not Config.BaseScan.Enabled
        send_notif("Base Scan", Config.BaseScan.Enabled and "ON" or "OFF", Color3.fromRGB(0, 255, 0))
    elseif input.KeyCode == Enum.KeyCode.F3 then
        Config.PlayerESP.Enabled = not Config.PlayerESP.Enabled
        send_notif("Player ESP", Config.PlayerESP.Enabled and "ON" or "OFF", Color3.fromRGB(0, 255, 0))
    elseif input.KeyCode == Enum.KeyCode.F4 then
        Config.Aimbot.Enabled = not Config.Aimbot.Enabled
        send_notif("Aimbot", Config.Aimbot.Enabled and "ON" or "OFF", Color3.fromRGB(0, 255, 0))
    end
end)

send_notif("DEGRADE v140", "Loaded successfully.", Color3.fromRGB(255, 50, 50))
print("[DEGRADE] v140 loaded. F1-F4 toggles.")
