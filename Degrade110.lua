-- language: Lua (Luau), file: degrade_v150.lua, target: DEGRADE
-- CREATOR SMOKExR'S | Fully Fixed & Rebuilt by Lokeii
-- Loader + Rayfield UI + Player ESP + Aimbot + Ore/Base Scanner (Dump-optimized)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- 1. КОНФИГ
-- ============================================================
local Config = {
    Aimbot = { Enabled = false, FOV = 120, Smoothness = 0.08, WallCheck = true, TeamCheck = true, AimPart = "Head" },
    PlayerESP = { Enabled = false, Name = true, Distance = true, Health = true, TeamCheck = true, MaxDistance = 2000, NameColor = Color3.fromRGB(255, 255, 255) },
    OreESP = { Enabled = false, MaxDistance = 500, ShowSulfur = true, ShowMetal = true, ShowStone = true, ColorSulfur = Color3.fromRGB(255, 255, 0), ColorMetal = Color3.fromRGB(180, 180, 180), ColorStone = Color3.fromRGB(130, 130, 130) },
    BaseScan = { Enabled = false, MaxDistance = 500, ShowCupboards = true, ShowChests = true, ShowStashes = true, ColorCupboard = Color3.fromRGB(0, 255, 0), ColorChest = Color3.fromRGB(255, 150, 0), ColorStash = Color3.fromRGB(255, 255, 0) },
    AntiAFK = true
}
local IsPanic = false

-- ============================================================
-- 2. FAST LOADER (Заставка)
-- ============================================================
local load_gui = Instance.new("ScreenGui")
load_gui.Name = "DegradeLoader"
load_gui.ResetOnSpawn = false
load_gui.IgnoreGuiInset = true
load_gui.Parent = CoreGui

local load_bg = Instance.new("Frame", load_gui)
load_bg.Size = UDim2.new(1, 0, 1, 0)
load_bg.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
load_bg.BorderSizePixel = 0

local logo = Instance.new("TextLabel", load_bg)
logo.Size = UDim2.new(1, 0, 0, 80)
logo.Position = UDim2.new(0, 0, 0.38, 0)
logo.BackgroundTransparency = 1
logo.Text = "DEGRADE"
logo.TextColor3 = Color3.fromRGB(255, 0, 0)
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 48
logo.TextTransparency = 1
TweenService:Create(logo, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

local sub = Instance.new("TextLabel", load_bg)
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0.48, 0)
sub.BackgroundTransparency = 1
sub.Text = "ORE & BASE SCANNER v150  •  loading"
sub.TextColor3 = Color3.fromRGB(150, 150, 150)
sub.Font = Enum.Font.Gotham
sub.TextSize = 14
sub.TextTransparency = 1
TweenService:Create(sub, TweenInfo.new(0.8), {TextTransparency = 0}):Play()

local bar_bg = Instance.new("Frame", load_bg)
bar_bg.Size = UDim2.new(0, 300, 0, 4)
bar_bg.Position = UDim2.new(0.5, -150, 0.55, 0)
bar_bg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
bar_bg.BorderSizePixel = 0
Instance.new("UICorner", bar_bg).CornerRadius = UDim.new(1, 0)

local bar_fill = Instance.new("Frame", bar_bg)
bar_fill.Size = UDim2.new(0, 0, 1, 0)
bar_fill.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
bar_fill.BorderSizePixel = 0
Instance.new("UICorner", bar_fill).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    local steps = {{"initializing...", 0.25}, {"scanning environment...", 0.5}, {"loading modules...", 0.75}, {"system online", 1.0}}
    for _, step in ipairs(steps) do
        TweenService:Create(bar_fill, TweenInfo.new(0.7), {Size = UDim2.new(step[2], 0, 1, 0)}):Play()
        task.wait(0.7)
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
-- 3. УТИЛИТЫ И ФИЛЬТРЫ (Из твоего дампа)
-- ============================================================
local FORCE_IGNORE = {"hitbox", "collision", "firstpersonlegs", "asphalt", "slab", "road", "trigger", "invisible", "preview", "ghost", "template", "engine switch", "outpostchristmastree", "camera", "tabviewsheet", "fence", "wall", "floor", "foundation", "door", "window"}

local function is_forced_ignore(n, p)
    n, p = n:lower(), (p or ""):lower()
    for _, w in ipairs(FORCE_IGNORE) do if n:find(w, 1, true) or p:find(w, 1, true) then return true end end
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
    if obj:IsA("Model") then return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart") end
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
-- 4. КЛАССИФИКАТОРЫ
-- ============================================================
local BASE_EXACT = { cupboard = "CUPBOARD", toolcupboard = "CUPBOARD", tool_cupboard = "CUPBOARD", tc = "CUPBOARD", шкаф = "CUPBOARD", chest = "CHEST", crate = "CHEST", сундук = "CHEST", ящик = "CHEST", stash = "STASH", cache = "STASH", тайник = "STASH", схрон = "STASH" }

local function classify_ore(n)
    n = n:lower()
    if n:find("sulfur") or n:find("sulphur") or n:find("сера") then return "SULFUR" end
    if n:find("metal") or n:find("iron") or n:find("железо") or n:find("металл") then return "METAL" end
    if n:find("stone") or n:find("rock") or n:find("камень") then return "STONE" end
    if n:find("ore") or n:find("руда") or n:find("node") then return "ORE" end
    return nil
end

local function classify_base(n)
    n = n:lower()
    for k, v in pairs(BASE_EXACT) do
        if n == k or n:match("^" .. k .. "[_%-]") or n:match("[_%-]" .. k .. "$") or n:match("[_%-]" .. k .. "[_%-]") then return v end
    end
    return nil
end

-- ============================================================
-- 5. ДВИЖОК ОТРИСОВКИ (Ore & Base)
-- ============================================================
local ore_cache, base_cache = {}, {}

local function create_billboard(primary, text, color, t_size)
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
    lbl.TextSize = t_size or 14
    return { gui = bb, label = lbl, primary = primary }
end

local function scan_ores()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if not (obj:IsA("Model") or obj:IsA("BasePart")) or ore_cache[obj] then continue end
        local primary = get_primary(obj)
        if not primary or not is_valid_target(primary) or is_forced_ignore(obj.Name, primary.Name) then continue end
        
        local o_type = classify_ore(obj.Name .. "_" .. primary.Name)
        if not o_type then continue end
        if o_type == "SULFUR" and not Config.OreESP.ShowSulfur then continue end
        if o_type == "METAL" and not Config.OreESP.ShowMetal then continue end
        if o_type == "STONE" and not Config.OreESP.ShowStone then continue end
        
        local color = o_type == "SULFUR" and Config.OreESP.ColorSulfur or (o_type == "METAL" and Config.OreESP.ColorMetal or Config.OreESP.ColorStone)
        ore_cache[obj] = create_billboard(primary, o_type, color, 14)
    end
end

local function scan_bases()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if not (obj:IsA("Model") or obj:IsA("BasePart")) or base_cache[obj] then continue end
        local primary = get_primary(obj)
        if not primary or not is_valid_target(primary) or is_forced_ignore(obj.Name, primary.Name) then continue end
        
        local b_type = classify_base(obj.Name .. "_" .. primary.Name)
        if not b_type then continue end
        if b_type == "CUPBOARD" and not Config.BaseScan.ShowCupboards then continue end
        if b_type == "CHEST" and not Config.BaseScan.ShowChests then continue end
        if b_type == "STASH" and not Config.BaseScan.ShowStashes then continue end
        
        local color = b_type == "CUPBOARD" and Config.BaseScan.ColorCupboard or (b_type == "CHEST" and Config.BaseScan.ColorChest or Config.BaseScan.ColorStash)
        base_cache[obj] = create_billboard(primary, b_type, color, 16)
    end
end

-- ============================================================
-- 6. PLAYER ESP & AIMBOT
-- ============================================================
local player_esp_cache = {}

local function create_player_esp(plr)
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local bb = Instance.new("BillboardGui", hrp)
    bb.Name = plr.Name .. "_ESP"
    bb.Adornee = hrp
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.AlwaysOnTop = true
    
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

    player_esp_cache[plr] = { bb = bb, name_lbl = name_lbl, dist_lbl = dist_lbl }
end

local function update_player_esp()
    if not Config.PlayerESP.Enabled then
        for _, data in pairs(player_esp_cache) do data.bb.Enabled = false end
        return
    end
    local char, my_hrp = get_char_hrp()
    if not my_hrp then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or (Config.PlayerESP.TeamCheck and plr.Team == LocalPlayer.Team) then continue end
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
                    if Config.PlayerESP.Distance then data.dist_lbl.Text = string.format("[%d studs]", dist) end
                else data.bb.Enabled = false end
            end
        end
    end
end

local function get_closest_player()
    local char, my_hrp = get_char_hrp()
    if not my_hrp then return nil end
    local closest, min_dist = nil, Config.Aimbot.FOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or (Config.Aimbot.TeamCheck and plr.Team == LocalPlayer.Team) then continue end
        local p_char = plr.Character
        if p_char then
            local part = p_char:FindFirstChild(Config.Aimbot.AimPart)
            if part then
                local pos, on_screen = Workspace.CurrentCamera:WorldToViewportPoint(part.Position)
                if on_screen then
                    local mouse = UserInputService:GetMouseLocation()
                    local dist = (Vector2.new(pos.X, pos.Y) - mouse).Magnitude
                    if dist < min_dist then min_dist, closest = dist, part end
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if Config.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = get_closest_player()
        if target then
            local target_cf = CFrame.new(Workspace.CurrentCamera.CFrame.Position, target.Position)
            Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame:Lerp(target_cf, Config.Aimbot.Smoothness)
        end
    end
end)

-- ============================================================
-- 7. МЕНЮ RAYFIELD
-- ============================================================
local Rayfield
local ok_rf, err_rf = pcall(function()
    local src = game:HttpGet('https://sirius.menu/rayfield')
    Rayfield = loadstring(src)()
end)

if not ok_rf or not Rayfield then
    warn("[DEGRADE] Rayfield failed. Fallback mode.")
    Rayfield = { CreateWindow = function() return { CreateTab = function() return { CreateSection = function() return { CreateToggle = function() end, CreateSlider = function() end, CreateButton = function() end, CreateDropdown = function() end } end } end } end }
end

local Window = Rayfield:CreateWindow({
    Name = "DEGRADE | v150",
    LoadingTitle = "Loading DEGRADE...",
    LoadingSubtitle = "by SMOKExR & Lokeii",
    ConfigurationSaving = { Enabled = true, FolderName = "Degrade", FileName = "Config_v150" },
    KeySystem = false
})

local TabMain = Window:CreateTab("Main", 4483362458)
local TabVisuals = Window:CreateTab("Visuals", 4483362458)
local TabCombat = Window:CreateTab("Combat", 4483362458)

-- ВКЛАДКА MAIN
local SecMain = TabMain:CreateSection("Game Tweaks")
local ToggleAntiAFK = TabMain:CreateToggle({ Name = "Anti-AFK", CurrentValue = true, Flag = "AntiAFK", Callback = function(v) Config.AntiAFK = v end })

-- ВКЛАДКА VISUALS
local SecVisuals = TabVisuals:CreateSection("Ore & Base Scanner")
local ToggleOre = TabVisuals:CreateToggle({ Name = "Enable Ore ESP", CurrentValue = false, Flag = "OreESP", Callback = function(v) Config.OreESP.Enabled = v end })
local SliderOreDist = TabVisuals:CreateSlider({ Name = "Ore Max Distance", Range = {50, 2000}, Increment = 50, Suffix = " studs", CurrentValue = 500, Flag = "OreDist", Callback = function(v) Config.OreESP.MaxDistance = v end })
local ToggleBase = TabVisuals:CreateToggle({ Name = "Enable Base Scan", CurrentValue = false, Flag = "BaseScan", Callback = function(v) Config.BaseScan.Enabled = v end })
local SliderBaseDist = TabVisuals:CreateSlider({ Name = "Base Max Distance", Range = {50, 2000}, Increment = 50, Suffix = " studs", CurrentValue = 500, Flag = "BaseDist", Callback = function(v) Config.BaseScan.MaxDistance = v end })

local SecPESP = TabVisuals:CreateSection("Player ESP")
local TogglePESP = TabVisuals:CreateToggle({ Name = "Enable Player ESP", CurrentValue = false, Flag = "PESP", Callback = function(v) Config.PlayerESP.Enabled = v end })
local TogglePName = TabVisuals:CreateToggle({ Name = "Show Names", CurrentValue = true, Flag = "PName", Callback = function(v) Config.PlayerESP.Name = v end })
local TogglePDist = TabVisuals:CreateToggle({ Name = "Show Distance", CurrentValue = true, Flag = "PDist", Callback = function(v) Config.PlayerESP.Distance = v end })

-- ВКЛАДКА COMBAT
local SecAim = TabCombat:CreateSection("Aimbot")
local ToggleAim = TabCombat:CreateToggle({ Name = "Enable Aimbot (Hold RMB)", CurrentValue = false, Flag = "Aimbot", Callback = function(v) Config.Aimbot.Enabled = v end })
local SliderFOV = TabCombat:CreateSlider({ Name = "FOV", Range = {10, 500}, Increment = 10, Suffix = "px", CurrentValue = 120, Flag = "FOV", Callback = function(v) Config.Aimbot.FOV = v end })
local SliderSmooth = TabCombat:CreateSlider({ Name = "Smoothness", Range = {0.01, 1}, Increment = 0.01, CurrentValue = 0.08, Flag = "Smooth", Callback = function(v) Config.Aimbot.Smoothness = v end })

-- ============================================================
-- 8. ГЛАВНЫЙ ЦИКЛ
-- ============================================================
local last_scan = 0
RunService.Heartbeat:Connect(function()
    local now = tick()
    if now - last_scan > 2.0 then
        last_scan = now
        if Config.OreESP.Enabled then scan_ores() end
        if Config.BaseScan.Enabled then scan_bases() end
    end
    
    local cam_pos = Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.Position or Vector3.zero
    for obj, data in pairs(ore_cache) do
        if not obj.Parent or not data.primary:IsDescendantOf(Workspace) then
            data.gui:Destroy(); ore_cache[obj] = nil
        else data.gui.Enabled = Config.OreESP.Enabled and (data.primary.Position - cam_pos).Magnitude <= Config.OreESP.MaxDistance end
    end
    for obj, data in pairs(base_cache) do
        if not obj.Parent or not data.primary:IsDescendantOf(Workspace) then
            data.gui:Destroy(); base_cache[obj] = nil
        else data.gui.Enabled = Config.BaseScan.Enabled and (data.primary.Position - cam_pos).Magnitude <= Config.BaseScan.MaxDistance end
    end
    
    if Config.PlayerESP.Enabled then update_player_esp() end
end)

-- Анти-АФК
task.spawn(function()
    while task.wait(60) do
        if Config.AntiAFK then
            local _, hrp, _ = get_char_hrp()
            if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(-15, 15)), 0) end
        end
    end
end)

print("[DEGRADE] v150 loaded. UI is ready.")
