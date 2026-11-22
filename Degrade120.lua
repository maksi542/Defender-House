-- language: Lua (Luau), file: degrade_v170.lua
-- CREATOR SMOKExR'S | Fixed & Expanded by Lokeii
-- Full UI + All Features + Fixed Scanners

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ============================================================
-- 1. ГЛОБАЛЬНЫЙ КОНФИГ
-- ============================================================
local Config = {
    Aimbot = { 
        Enabled = false, FOV = 120, Smoothness = 0.08, WallCheck = true, 
        TeamCheck = true, AimPart = "Head", AlwaysOn = false 
    },
    PlayerESP = {
        Enabled = false, Box = false, Name = true, Distance = true, 
        Health = false, TeamCheck = true, MaxDistance = 2000,
        NameColor = Color3.fromRGB(255, 255, 255)
    },
    Mod = { Enabled = false, Alert = false, ShowList = true, Color = Color3.fromRGB(255, 50, 50) },
    OreESP = {
        Enabled = false, MaxDistance = 500,
        ShowSulfur = true, ShowMetal = true, ShowStone = true,
        ColorSulfur = Color3.fromRGB(255, 255, 0),
        ColorMetal = Color3.fromRGB(180, 180, 180),
        ColorStone = Color3.fromRGB(130, 130, 130)
    },
    BaseScan = { 
        Enabled = false, MaxDistance = 500, 
        ShowCupboards = true, ShowChests = true, ShowStashes = true,
        ColorCupboard = Color3.fromRGB(0, 255, 0),
        ColorChest = Color3.fromRGB(255, 150, 0),
        ColorStash = Color3.fromRGB(255, 255, 0)
    },
    AntiAFK = true, FPSBoost = false
}

local IsPanic = false
local ThemeColor = Color3.fromRGB(255, 50, 50)

-- ============================================================
-- 2. УТИЛИТЫ, ФИЛЬТРЫ И ХЕЛПЕРЫ
-- ============================================================
local FORCE_IGNORE = {
    "hitbox", "collision", "firstpersonlegs", "asphalt", "slab", "road",
    "trigger", "invisible", "preview", "ghost", "template", "engine switch",
    "outpostchristmastree", "camera", "tabviewsheet", "fence", "wall", 
    "floor", "foundation", "door", "window"
}

local function is_forced_ignore(obj_name, parent_name)
    local ln = tostring(obj_name):lower()
    local lp = tostring(parent_name or ""):lower()
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

local function is_teammate(plr)
    if plr == LocalPlayer then return true end
    if plr.Team and LocalPlayer.Team then return plr.Team == LocalPlayer.Team end
    return false
end

local function world_to_screen(pos)
    local screen, on_screen = Camera:WorldToViewportPoint(pos)
    if on_screen and screen.X > 0 and screen.Y > 0 and screen.X < Camera.ViewportSize.X and screen.Y < Camera.ViewportSize.Y then
        return Vector2.new(screen.X, screen.Y)
    end
    return nil
end

local function get_rainbow_color(speed)
    local t = tick() * speed
    return Color3.fromRGB(math.sin(t)*127+128, math.sin(t+2)*127+128, math.sin(t+4)*127+128)
end

-- ============================================================
-- 3. КЛАССИФИКАТОРЫ (Ore & Base)
-- ============================================================
local function classify_ore(name_str)
    local n = tostring(name_str):lower()
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
    local n = tostring(name_str):lower()
    for k, v in pairs(BASE_EXACT) do
        if n == k or n:match("^" .. k .. "[_%-]") or n:match("[_%-]" .. k .. "$") or n:match("[_%-]" .. k .. "[_%-]") then return v end
    end
    return nil
end

-- ============================================================
-- 4. ДВИЖОК ОТРИСОВКИ (Ore, Base, Player)
-- ============================================================
local ore_cache = {}
local base_cache = {}
local player_esp_cache = {}

local function create_billboard(primary, text, color, text_size)
    local bb = Instance.new("BillboardGui")
    bb.Name = "LokeiiESP_" .. text
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
-- 5. СКАНЕРЫ
-- ============================================================
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
        
        local color = Config.OreESP.ColorStone
        if o_type == "SULFUR" then color = Config.OreESP.ColorSulfur end
        if o_type == "METAL" then color = Config.OreESP.ColorMetal end
        
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
        
        local color = Config.BaseScan.ColorStash
        if b_type == "CUPBOARD" then color = Config.BaseScan.ColorCupboard end
        if b_type == "CHEST" then color = Config.BaseScan.ColorChest end
        
        base_cache[obj] = create_billboard(primary, b_type, color, 16)
    end
end

local function update_player_esp()
    if not Config.PlayerESP.Enabled then
        for _, data in pairs(player_esp_cache) do if data.bb then data.bb.Enabled = false end end
        return
    end
    local char, my_hrp = get_char_hrp()
    if not my_hrp then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or (Config.PlayerESP.TeamCheck and is_teammate(plr)) then continue end
        local p_char = plr.Character
        if p_char then
            local p_hrp = p_char:FindFirstChild("HumanoidRootPart")
            if p_hrp then
                if not player_esp_cache[plr] then
                    local bb = Instance.new("BillboardGui", p_hrp)
                    bb.Name = "PlayerESP_" .. plr.Name
                    bb.Adornee = p_hrp
                    bb.Size = UDim2.new(0, 200, 0, 40)
                    bb.AlwaysOnTop = true
                    
                    local n_lbl = Instance.new("TextLabel", bb)
                    n_lbl.Size = UDim2.new(1, 0, 0, 15)
                    n_lbl.BackgroundTransparency = 1
                    n_lbl.Text = plr.Name
                    n_lbl.TextColor3 = Config.PlayerESP.NameColor
                    n_lbl.TextStrokeTransparency = 0
                    n_lbl.Font = Enum.Font.GothamBold
                    n_lbl.TextSize = 12
                    
                    local d_lbl = Instance.new("TextLabel", bb)
                    d_lbl.Size = UDim2.new(1, 0, 0, 15)
                    d_lbl.Position = UDim2.new(0, 0, 0, 16)
                    d_lbl.BackgroundTransparency = 1
                    d_lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
                    d_lbl.TextStrokeTransparency = 0
                    d_lbl.Font = Enum.Font.Gotham
                    d_lbl.TextSize = 11
                    
                    player_esp_cache[plr] = { bb = bb, name_lbl = n_lbl, dist_lbl = d_lbl }
                end
                
                local data = player_esp_cache[plr]
                if data and data.bb and data.bb.Parent then
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
end

-- ============================================================
-- 6. AIMBOT
-- ============================================================
local function get_closest_player()
    local char, my_hrp = get_char_hrp()
    if not my_hrp then return nil end
    local closest, min_dist = nil, Config.Aimbot.FOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or (Config.Aimbot.TeamCheck and is_teammate(plr)) then continue end
        local p_char = plr.Character
        if p_char then
            local part = p_char:FindFirstChild(Config.Aimbot.AimPart)
            if part then
                local screen_pos = world_to_screen(part.Position)
                if screen_pos then
                    local mouse = UserInputService:GetMouseLocation()
                    local dist = (screen_pos - mouse).Magnitude
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
    if Config.Aimbot.Enabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = get_closest_player()
        if target then
            local target_cf = CFrame.new(Camera.CFrame.Position, target.Position)
            Camera.CFrame = Camera.CFrame:Lerp(target_cf, Config.Aimbot.Smoothness)
        end
    end
end)

-- ============================================================
-- 7. UI LOADER (RAYFIELD С ЗАЩИТОЙ)
-- ============================================================
local Rayfield
local ok_ui = pcall(function()
    local src = game:HttpGet('https://sirius.menu/rayfield')
    Rayfield = loadstring(src)()
end)

if not ok_ui or not Rayfield then
    warn("[DEGRADE] Rayfield failed. Fallback mode.")
    Rayfield = { 
        CreateWindow = function() return { 
            CreateTab = function() return { 
                CreateSection = function() return { 
                    CreateToggle = function() end, CreateSlider = function() end, 
                    CreateButton = function() end, CreateColorPicker = function() end,
                    CreateDropdown = function() end 
                } end 
            } end 
        } end 
    }
end

local Window = Rayfield:CreateWindow({
    Name = "DEGRADE | v170",
    LoadingTitle = "Loading DEGRADE...",
    LoadingSubtitle = "by SMOKExR & Lokeii",
    ConfigurationSaving = { Enabled = true, FolderName = "Degrade", FileName = "Config_v170" },
    KeySystem = false
})

-- ВКЛАДКА MAIN
local TabMain = Window:CreateTab("Main", 4483362458)
local SecMain = TabMain:CreateSection("Game Tweaks")
TabMain:CreateToggle({ Name = "Anti-AFK", CurrentValue = true, Flag = "AntiAFK", Callback = function(v) Config.AntiAFK = v end })
TabMain:CreateToggle({ Name = "FPS Boost", CurrentValue = false, Flag = "FPSBoost", Callback = function(v) Config.FPSBoost = v end })

-- ВКЛАДКА VISUALS
local TabVisuals = Window:CreateTab("Visuals", 4483362458)

-- Секция: Ore ESP
local SecOre = TabVisuals:CreateSection("Ore Scanner")
TabVisuals:CreateToggle({ Name = "Enable Ore ESP", CurrentValue = false, Flag = "OreESP", Callback = function(v) Config.OreESP.Enabled = v end })
TabVisuals:CreateSlider({ Name = "Ore Max Distance", Range = {50, 2000}, Increment = 50, Suffix = " studs", CurrentValue = 500, Flag = "OreDist", Callback = function(v) Config.OreESP.MaxDistance = v end })
TabVisuals:CreateColorPicker({ Name = "Sulfur Color", Color = Config.OreESP.ColorSulfur, Flag = "ColSulfur", Callback = function(v) Config.OreESP.ColorSulfur = v end })
TabVisuals:CreateColorPicker({ Name = "Metal Color", Color = Config.OreESP.ColorMetal, Flag = "ColMetal", Callback = function(v) Config.OreESP.ColorMetal = v end })
TabVisuals:CreateColorPicker({ Name = "Stone Color", Color = Config.OreESP.ColorStone, Flag = "ColStone", Callback = function(v) Config.OreESP.ColorStone = v end })

-- Секция: Base Scan
local SecBase = TabVisuals:CreateSection("Base Scanner")
TabVisuals:CreateToggle({ Name = "Enable Base Scan", CurrentValue = false, Flag = "BaseScan", Callback = function(v) Config.BaseScan.Enabled = v end })
TabVisuals:CreateSlider({ Name = "Base Max Distance", Range = {50, 2000}, Increment = 50, Suffix = " studs", CurrentValue = 500, Flag = "BaseDist", Callback = function(v) Config.BaseScan.MaxDistance = v end })
TabVisuals:CreateColorPicker({ Name = "Cupboard Color", Color = Config.BaseScan.ColorCupboard, Flag = "ColCup", Callback = function(v) Config.BaseScan.ColorCupboard = v end })
TabVisuals:CreateColorPicker({ Name = "Chest Color", Color = Config.BaseScan.ColorChest, Flag = "ColChest", Callback = function(v) Config.BaseScan.ColorChest = v end })

-- Секция: Player ESP
local SecPESP = TabVisuals:CreateSection("Player ESP")
TabVisuals:CreateToggle({ Name = "Enable Player ESP", CurrentValue = false, Flag = "PESP", Callback = function(v) Config.PlayerESP.Enabled = v end })
TabVisuals:CreateToggle({ Name = "Show Names", CurrentValue = true, Flag = "PName", Callback = function(v) Config.PlayerESP.Name = v end })
TabVisuals:CreateToggle({ Name = "Show Distance", CurrentValue = true, Flag = "PDist", Callback = function(v) Config.PlayerESP.Distance = v end })
TabVisuals:CreateSlider({ Name = "Player ESP Max Distance", Range = {50, 5000}, Increment = 100, Suffix = " studs", CurrentValue = 2000, Flag = "PDistMax", Callback = function(v) Config.PlayerESP.MaxDistance = v end })

-- ВКЛАДКА COMBAT
local TabCombat = Window:CreateTab("Combat", 4483362458)
local SecAim = TabCombat:CreateSection("Aimbot")
TabCombat:CreateToggle({ Name = "Enable Aimbot (Hold RMB)", CurrentValue = false, Flag = "Aimbot", Callback = function(v) Config.Aimbot.Enabled = v end })
TabCombat:CreateSlider({ Name = "FOV", Range = {10, 500}, Increment = 10, Suffix = "px", CurrentValue = 120, Flag = "FOV", Callback = function(v) Config.Aimbot.FOV = v end })
TabCombat:CreateSlider({ Name = "Smoothness", Range = {0.01, 1}, Increment = 0.01, CurrentValue = 0.08, Flag = "Smooth", Callback = function(v) Config.Aimbot.Smoothness = v end })
TabCombat:CreateDropdown({ Name = "Aim Part", Options = {"Head", "HumanoidRootPart", "UpperTorso"}, CurrentOption = "Head", Flag = "AimPart", Callback = function(v) Config.Aimbot.AimPart = v end })
TabCombat:CreateToggle({ Name = "Team Check", CurrentValue = true, Flag = "AimTeam", Callback = function(v) Config.Aimbot.TeamCheck = v end })

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
    
    local cam_pos = Camera.CFrame.Position
    for obj, data in pairs(ore_cache) do
        if not obj.Parent or not data.primary:IsDescendantOf(Workspace) then
            data.gui:Destroy()
            ore_cache[obj] = nil
        else
            data.gui.Enabled = Config.OreESP.Enabled and (data.primary.Position - cam_pos).Magnitude <= Config.OreESP.MaxDistance
        end
    end
    for obj, data in pairs(base_cache) do
        if not obj.Parent or not data.primary:IsDescendantOf(Workspace) then
            data.gui:Destroy()
            base_cache[obj] = nil
        else
            data.gui.Enabled = Config.BaseScan.Enabled and (data.primary.Position - cam_pos).Magnitude <= Config.BaseScan.MaxDistance
        end
    end
    
    if Config.PlayerESP.Enabled then update_player_esp() end
end)

-- ============================================================
-- 9. АНТИ-АФК
-- ============================================================
task.spawn(function()
    while task.wait(60) do
        if Config.AntiAFK and not IsPanic then
            local _, hrp = get_char_hrp()
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(-15, 15)), 0)
            end
        end
    end
end)

print("[DEGRADE] v170 loaded successfully. Full UI is ready.")
