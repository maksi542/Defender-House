-- language: Lua (Luau), file: degrade_ore_v120_fixed.lua, target: DEGRADE, executor: Solara / Delta / Fluxus
-- CREATOR SMOKExR'S | DEGRADE Ore & Base Scanner (built by Lokeii)
-- FIXED: Scanners, Cache, Aimbot + ADDED: Full Rayfield Menu

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
            t.Text = "DEGRADE v120 — FALLBACK MODE"
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
sub.Text = "ORE & BASE SCANNER v120  •  loading"
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
        {"scanning ores...", 0.5},
        {"loading bases...", 0.75},
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
local IsPanic = false

local Config = {
    Aimbot = { Enabled = false, FOV = 120, Smoothness = 0.08, WallCheck = true, TeamCheck = true, AimPart = "Head", AlwaysOn = false },
    ESP = {
        Enabled = false, Box = false, Name = false, Distance = false, Health = false, 
        MaxDistance = 2000, TeamCheck = true, RainbowBox = false, RainbowName = false, 
        RainbowDist = false, RainbowSpeed = 1, BoxColor = Color3.fromRGB(255, 50, 50),
        NameColor = Color3.fromRGB(255, 255, 255), DistColor = Color3.fromRGB(200, 200, 200),
        Thickness = 1, TextSize = 16, TextOutline = true,
    },
    Mod = { Enabled = false, Alert = false, ShowList = true, Color = Color3.fromRGB(255, 50, 50) },
    BaseScan = { 
        Enabled = false, MaxDistance = 500, 
        ShowCupboards = true, ShowChests = true, ShowStashes = true,
        CupboardColor = Color3.fromRGB(0, 255, 0),
        ChestColor = Color3.fromRGB(255, 150, 0),
        StashColor = Color3.fromRGB(255, 255, 0)
    },
    OreESP = {
        Enabled = false, MaxDistance = 300,
        ShowSulfur = true, ShowMetal = true, ShowStone = true,
        SulfurColor = Color3.fromRGB(255, 255, 0),
        MetalColor = Color3.fromRGB(180, 180, 180),
        StoneColor = Color3.fromRGB(130, 130, 130)
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

local function world_to_screen(pos)
    local screen, on_screen = Camera:WorldToViewportPoint(pos)
    if on_screen and screen.X > 0 and screen.Y > 0
       and screen.X < Camera.ViewportSize.X and screen.Y < Camera.ViewportSize.Y then
        return Vector2.new(screen.X, screen.Y)
    end
    return nil
end

-- ============================================================
-- ORE SCANNER (Real Nodes only) — FIXED
-- ============================================================
local ore_cache = {}
local ORE_KEYWORDS = {"ore", "node", "resource", "sulfur", "metal", "stone", "руда", "сера", "камень"}
local IGNORE_KEYWORDS = {"door", "wall", "floor", "foundation", "cupboard", "furnace", "chest", "box", "base", "дверь", "стена", "пол", "фундамент", "печь", "шкаф", "сундук", "hitbox", "collision", "asphalt", "road", "slab", "firstperson"}

local function is_real_ore(obj)
    if not (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("MeshPart")) then return false end
    local lname = obj.Name:lower()
    local pname = obj.Parent and obj.Parent.Name:lower() or ""
    
    for _, ignore in ipairs(IGNORE_KEYWORDS) do
        if lname:find(ignore, 1, true) or pname:find(ignore, 1, true) then return false end
    end
    
    local size = Vector3.zero
    if obj:IsA("BasePart") then
        size = obj.Size
    elseif obj:IsA("Model") then
        local ok, extents = pcall(function() return obj:GetExtentsSize() end)
        if ok then size = extents end
    end
    if size.Magnitude < 5 then return false end
    
    for _, kw in ipairs(ORE_KEYWORDS) do
        if lname:find(kw) then return true end
    end
    
    return false
end

local function get_ore_type(obj)
    local lname = obj.Name:lower()
    if lname:find("sulfur") or lname:find("сера") then return "SULFUR", Config.OreESP.SulfurColor end
    if lname:find("metal") or lname:find("iron") or lname:find("железо") or lname:find("металл") then return "METAL", Config.OreESP.MetalColor end
    if lname:find("stone") or lname:find("rock") or lname:find("камень") then return "STONE", Config.OreESP.StoneColor end
    return "ORE", Config.OreESP.StoneColor
end

local function scan_ores()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if is_real_ore(obj) then
            local o_type, o_color = get_ore_type(obj)
            local enabled = false
            if o_type == "SULFUR" and Config.OreESP.ShowSulfur then enabled = true end
            if o_type == "METAL" and Config.OreESP.ShowMetal then enabled = true end
            if o_type == "STONE" and Config.OreESP.ShowStone then enabled = true end
            if o_type == "ORE" and Config.OreESP.ShowStone then enabled = true end
            
            if enabled and not ore_cache[obj] then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if not primary and obj:IsA("BasePart") then primary = obj end
                
                if primary then
                    local bb = Instance.new("BillboardGui")
                    bb.Name = "LokeiiOreBB"
                    bb.Adornee = primary
                    bb.Size = UDim2.new(0, 100, 0, 30)
                    bb.StudsOffsetWorldSpace = primary.CFrame.UpVector * (primary.Size.Y / 2 + 1)
                    bb.AlwaysOnTop = true
                    bb.Parent = primary

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = o_type
                    label.TextColor3 = o_color
                    label.TextStrokeTransparency = 0
                    label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                    label.Font = Enum.Font.GothamBold
                    label.TextSize = 14
                    label.Parent = bb

                    ore_cache[obj] = {gui = bb, text = label, primary = primary, type = o_type}
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(2) do
        if IsPanic or not Config.OreESP.Enabled then continue end
        scan_ores()
        for obj, data in pairs(ore_cache) do
            if not obj.Parent or not data.primary or not data.primary:IsDescendantOf(Workspace) then
                if data.gui then data.gui:Destroy() end
                ore_cache[obj] = nil
            else
                local dist = (data.primary.Position - Camera.CFrame.Position).Magnitude
                if dist > Config.OreESP.MaxDistance then
                    data.gui.Enabled = false
                else
                    data.gui.Enabled = true
                    if data.type == "SULFUR" then data.text.TextColor3 = Config.OreESP.SulfurColor end
                    if data.type == "METAL" then data.text.TextColor3 = Config.OreESP.MetalColor end
                    if data.type == "STONE" then data.text.TextColor3 = Config.OreESP.StoneColor end
                end
            end
        end
    end
end)

-- ============================================================
-- BASE SCANNER — FIXED
-- ============================================================
local base_cache = {}
local CUPBOARD_KEYWORDS = {"cupboard", "tool cupboard", "шкаф"}
local CHEST_KEYWORDS = {"chest", "crate", "сундук", "ящик", "loot"}
local STASH_KEYWORDS = {"stash", "cache", "buried", "hidden", "схрон", "тайник"}

local function get_base_type(obj)
    local lname = obj.Name:lower()
    local pname = obj.Parent and obj.Parent.Name:lower() or ""
    
    for _, ignore in ipairs(IGNORE_KEYWORDS) do
        if lname:find(ignore, 1, true) or pname:find(ignore, 1, true) then return nil, nil end
    end
    
    for _, kw in ipairs(CUPBOARD_KEYWORDS) do if lname:find(kw) then return "CUPBOARD", Config.BaseScan.CupboardColor end end
    for _, kw in ipairs(CHEST_KEYWORDS) do if lname:find(kw) then return "CHEST", Config.BaseScan.ChestColor end end
    for _, kw in ipairs(STASH_KEYWORDS) do if lname:find(kw) then return "STASH", Config.BaseScan.StashColor end end
    return nil
end

local function scan_base()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if (obj:IsA("Model") or obj:IsA("BasePart")) then
            local b_type, b_color = get_base_type(obj)
            if b_type then
                local enabled = false
                if b_type == "CUPBOARD" and Config.BaseScan.ShowCupboards then enabled = true end
                if b_type == "CHEST" and Config.BaseScan.ShowChests then enabled = true end
                if b_type == "STASH" and Config.BaseScan.ShowStashes then enabled = true end
                if enabled and not base_cache[obj] then
                    local primary = obj:FindFirstChildWhichIsA("BasePart")
                    if not primary and obj:IsA("BasePart") then primary = obj end
                    if primary then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "LokeiiBaseBB"
                        bb.Adornee = primary
                        bb.Size = UDim2.new(0, 150, 0, 40)
                        bb.StudsOffsetWorldSpace = primary.CFrame.UpVector * (primary.Size.Y / 2 + 1)
                        bb.AlwaysOnTop = true
                        bb.Parent = primary
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = b_type
                        label.TextColor3 = b_color
                        label.TextStrokeTransparency = 0
                        label.TextStrokeColor3 = Color3.fromRGB(0,0,0)
                        label.Font = Enum.Font.GothamBold
                        label.TextSize = 16
                        label.Parent = bb
                        base_cache[obj] = {gui = bb, text = label, primary = primary, type = b_type}
                    end
                end
            end
        end
    end
end

task.spawn(function()
    while task.wait(2) do
        if IsPanic or not Config.BaseScan.Enabled then continue end
        scan_base()
        for obj, data in pairs(base_cache) do
            if not obj.Parent or not data.primary or not data.primary:IsDescendantOf(Workspace) then
                if data.gui then data.gui:Destroy() end
                base_cache[obj] = nil
            else
                local dist = (data.primary.Position - Camera.CFrame.Position).Magnitude
                if dist > Config.BaseScan.MaxDistance then data.gui.Enabled = false
                else
                    data.gui.Enabled = true
                    if data.type == "CUPBOARD" then data.text.TextColor3 = Config.BaseScan.CupboardColor end
                    if data.type == "CHEST" then data.text.TextColor3 = Config.BaseScan.ChestColor end
                    if data.type == "STASH" then data.text.TextColor3 = Config.BaseScan.StashColor end
                end
            end
        end
    end
end)

-- ============================================================
-- AIMBOT
-- ============================================================
local function get_closest_player()
    local char, hum, my_hrp = get_character()
    if not my_hrp then return nil end
    local closest, min_dist = nil, Config.Aimbot.FOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or (Config.Aimbot.TeamCheck and is_teammate(plr)) then continue end
        if is_alive(plr) then
            local part = plr.Character:FindFirstChild(Config.Aimbot.AimPart)
            if part then
                local screen_pos = world_to_screen(part.Position)
                if screen_pos then
                    local mouse = UserInputService:GetMouseLocation()
                    local dist = (screen_pos - mouse).Magnitude
                    if dist < min_dist then
                        min_dist, closest = dist, part
                    end
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
            local target_cf = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(target_cf, Config.Aimbot.Smoothness)
        end
    end
end)

-- ============================================================
-- NOTIFS
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

task.spawn(function()
    while task.wait(1) do
        local stats_fps = Stats.RenderStats and math.floor(Stats.RenderStats.FramesPerSecond) or 60
        wm_title.Text = string.format("DEGRADE | FPS: %d", stats_fps)
    end
end)

-- ============================================================
-- МЕНЮ RAYFIELD (ДОБАВЛЕНО)
-- ============================================================
if Rayfield and type(Rayfield.CreateWindow) == "function" then
    local Window = Rayfield:CreateWindow({
        Name = "DEGRADE v120",
        LoadingTitle = "Loading Degrade...",
        LoadingSubtitle = "Ore & Base Scanner",
        ConfigurationSaving = { Enabled = true, FolderName = "Degrade", FileName = "Config" },
        KeySystem = false
    })

    -- Вкладка Main
    local TabMain = Window:CreateTab("Main", 4483362458)
    local SecMain = TabMain:CreateSection("General")
    TabMain:CreateToggle({ Name = "Anti-AFK", CurrentValue = Config.AntiAFK, Flag = "AntiAFK", Callback = function(v) Config.AntiAFK = v end })
    TabMain:CreateToggle({ Name = "FPS Boost", CurrentValue = Config.FPSBoost, Flag = "FPSBoost", Callback = function(v) Config.FPSBoost = v end })
    TabMain:CreateButton({ Name = "Clear Ores", Callback = function() clear_ores() end })
    TabMain:CreateButton({ Name = "Clear Bases", Callback = function() clear_base_cache() end })

    -- Вкладка Visuals
    local TabVisuals = Window:CreateTab("Visuals", 4483362458)
    
    -- Ore ESP
    local SecOre = TabVisuals:CreateSection("Ore ESP")
    TabVisuals:CreateToggle({ Name = "Enable Ore ESP", CurrentValue = Config.OreESP.Enabled, Flag = "OreESP", Callback = function(v) Config.OreESP.Enabled = v end })
    TabVisuals:CreateSlider({ Name = "Ore Distance", Range = {50, 2000}, Increment = 50, Suffix = " studs", CurrentValue = Config.OreESP.MaxDistance, Flag = "OreDist", Callback = function(v) Config.OreESP.MaxDistance = v end })
    TabVisuals:CreateToggle({ Name = "Show Sulfur", CurrentValue = Config.OreESP.ShowSulfur, Flag = "ShowSulfur", Callback = function(v) Config.OreESP.ShowSulfur = v end })
    TabVisuals:CreateToggle({ Name = "Show Metal", CurrentValue = Config.OreESP.ShowMetal, Flag = "ShowMetal", Callback = function(v) Config.OreESP.ShowMetal = v end })
    TabVisuals:CreateToggle({ Name = "Show Stone", CurrentValue = Config.OreESP.ShowStone, Flag = "ShowStone", Callback = function(v) Config.OreESP.ShowStone = v end })
    TabVisuals:CreateColorPicker({ Name = "Sulfur Color", Color = Config.OreESP.SulfurColor, Flag = "ColSulfur", Callback = function(v) Config.OreESP.SulfurColor = v end })
    TabVisuals:CreateColorPicker({ Name = "Metal Color", Color = Config.OreESP.MetalColor, Flag = "ColMetal", Callback = function(v) Config.OreESP.MetalColor = v end })
    TabVisuals:CreateColorPicker({ Name = "Stone Color", Color = Config.OreESP.StoneColor, Flag = "ColStone", Callback = function(v) Config.OreESP.StoneColor = v end })

    -- Base Scan
    local SecBase = TabVisuals:CreateSection("Base Scanner")
    TabVisuals:CreateToggle({ Name = "Enable Base Scan", CurrentValue = Config.BaseScan.Enabled, Flag = "BaseScan", Callback = function(v) Config.BaseScan.Enabled = v end })
    TabVisuals:CreateSlider({ Name = "Base Distance", Range = {50, 2000}, Increment = 50, Suffix = " studs", CurrentValue = Config.BaseScan.MaxDistance, Flag = "BaseDist", Callback = function(v) Config.BaseScan.MaxDistance = v end })
    TabVisuals:CreateToggle({ Name = "Show Cupboards", CurrentValue = Config.BaseScan.ShowCupboards, Flag = "ShowCup", Callback = function(v) Config.BaseScan.ShowCupboards = v end })
    TabVisuals:CreateToggle({ Name = "Show Chests", CurrentValue = Config.BaseScan.ShowChests, Flag = "ShowChest", Callback = function(v) Config.BaseScan.ShowChests = v end })
    TabVisuals:CreateToggle({ Name = "Show Stashes", CurrentValue = Config.BaseScan.ShowStashes, Flag = "ShowStash", Callback = function(v) Config.BaseScan.ShowStashes = v end })
    TabVisuals:CreateColorPicker({ Name = "Cupboard Color", Color = Config.BaseScan.CupboardColor, Flag = "ColCup", Callback = function(v) Config.BaseScan.CupboardColor = v end })
    TabVisuals:CreateColorPicker({ Name = "Chest Color", Color = Config.BaseScan.ChestColor, Flag = "ColChest", Callback = function(v) Config.BaseScan.ChestColor = v end })

    -- Вкладка Combat
    local TabCombat = Window:CreateTab("Combat", 4483362458)
    local SecAim = TabCombat:CreateSection("Aimbot")
    TabCombat:CreateToggle({ Name = "Enable Aimbot (RMB)", CurrentValue = Config.Aimbot.Enabled, Flag = "Aimbot", Callback = function(v) Config.Aimbot.Enabled = v end })
    TabCombat:CreateSlider({ Name = "FOV", Range = {10, 500}, Increment = 10, Suffix = "px", CurrentValue = Config.Aimbot.FOV, Flag = "AimFOV", Callback = function(v) Config.Aimbot.FOV = v end })
    TabCombat:CreateSlider({ Name = "Smoothness", Range = {0.01, 1}, Increment = 0.01, CurrentValue = Config.Aimbot.Smoothness, Flag = "AimSmooth", Callback = function(v) Config.Aimbot.Smoothness = v end })
    TabCombat:CreateToggle({ Name = "Team Check", CurrentValue = Config.Aimbot.TeamCheck, Flag = "AimTeam", Callback = function(v) Config.Aimbot.TeamCheck = v end })
    TabCombat:CreateDropdown({ Name = "Aim Part", Options = {"Head", "HumanoidRootPart", "UpperTorso"}, CurrentOption = "Head", Flag = "AimPart", Callback = function(v) Config.Aimbot.AimPart = v end })
end

print("[DEGRADE] v120 Fixed Loaded successfully with menu.")
