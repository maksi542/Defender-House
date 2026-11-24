-- language: Lua (Luau), file: degrade_ultimate_v250.lua, target: DEGRADE, executor: Solara / Delta / Fluxus
-- CREATOR SMOKExR'S | DEGRADE Ultimate Build v250 (by Lokeii)
-- FIXED: Safe TP (Ragdoll State + CFrame Snap), Removed Raycast Bypass

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
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
            t.Text = "DEGRADE v250 — FALLBACK MODE"
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
sub.Text = "ULTIMATE v250  •  loading"
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
        {"scanning logic...", 0.5},
        {"hooking modules...", 0.75},
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
        Enabled = false, Box = false, Name = false, Distance = false, 
        MaxDistance = 2000, TeamCheck = true, RainbowBox = false, RainbowName = false, 
        RainbowDist = false, RainbowSpeed = 1, BoxColor = Color3.fromRGB(255, 50, 50),
        NameColor = Color3.fromRGB(255, 255, 255), DistColor = Color3.fromRGB(200, 200, 200),
        Thickness = 1, TextSize = 16, TextOutline = true,
    },
    Mod = { Enabled = false, Alert = false, ShowList = true, Color = Color3.fromRGB(255, 50, 50) },
    BaseScan = { Enabled = false, MaxDistance = 800, CupboardColor = Color3.fromRGB(0, 255, 0), XRay = false },
    ChestScan = { Enabled = false, MaxDistance = 500, Color = Color3.fromRGB(255, 150, 0) },
    OreESP = { Enabled = false, MaxDistance = 400, Color = Color3.fromRGB(255, 255, 255) },
    Movement = { Noclip = false, SafeTP = false },
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
    if on_screen and screen.X > 0 and screen.Y > 0 and screen.X < Camera.ViewportSize.X and screen.Y < Camera.ViewportSize.Y then
        return Vector2.new(screen.X, screen.Y)
    end
    return nil
end

-- ============================================================
-- MOVEMENT (Noclip & Safe TP v7 - Ragdoll Snap)
-- ============================================================
local noclip_conn = nil
local function toggle_noclip(state)
    Config.Movement.Noclip = state
    if state then
        noclip_conn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclip_conn then noclip_conn:Disconnect(); noclip_conn = nil end
    end
end

local is_tping = false
local function safe_tp()
    if is_tping then return end
    local char, hum, hrp = get_character()
    if not hrp or not hum then return end
    
    -- 1. Рейкаст вперед
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local rayOrigin = Camera.CFrame.Position
    local rayDirection = Camera.CFrame.LookVector * 30
    local hit = Workspace:Raycast(rayOrigin, rayDirection, rayParams)
    if not hit then return end
    
    -- 2. Точка за стеной + проверка пола
    local targetPos = hit.Position + (Camera.CFrame.LookVector * 5) + Vector3.new(0, 3, 0)
    local floorHit = Workspace:Raycast(targetPos + Vector3.new(0, 5, 0), Vector3.new(0, -20, 0), rayParams)
    if not floorHit then return end
    
    targetPos = floorHit.Position + Vector3.new(0, 3.5, 0)
    is_tping = true

    -- 3. Сохраняем коллизии
    local old_collides = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            old_collides[part] = part.CanCollide
            part.CanCollide = false
        end
    end
    
    -- 4. Заставляем Humanoid думать, что мы в состоянии физики (Ragdoll)
    local old_state = hum:GetState()
    hum:ChangeState(Enum.HumanoidStateType.Physics)
    
    -- 5. Анкорим и переносим
    local old_anchor = hrp.Anchored
    hrp.Anchored = true
    hrp.CFrame = CFrame.new(targetPos) * Camera.CFrame.Rotation
    
    -- 6. Ждем (сервер должен синхронизировать позицию в состоянии Physics)
    task.wait(0.15)
    
    -- 7. Возвращаем всё обратно
    if char and char.Parent and hrp then
        hrp.Anchored = old_anchor
        hum:ChangeState(old_state)
        for part, can_col in pairs(old_collides) do
            if part and part.Parent then
                part.CanCollide = can_col
            end
        end
    end
    is_tping = false
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 and Config.Movement.SafeTP then
        safe_tp()
    end
end)

-- ============================================================
-- BASE & CHEST SCANNER
-- ============================================================
local base_cache = {}
local chest_cache = {}
local name_cache = {}

local function update_name_async(uid, label_object)
    local uid_str = tostring(uid)
    if name_cache[uid_str] then
        label_object.Text = "Auth: " .. name_cache[uid_str]
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if tostring(p.UserId) == uid_str then 
            name_cache[uid_str] = p.Name
            label_object.Text = "Auth: " .. p.Name
            return 
        end
    end
    task.spawn(function()
        local ok, res = pcall(function()
            local url = "https://users.roblox.com/v1/users/" .. uid_str
            local raw = game:HttpGet(url)
            local data = HttpService:JSONDecode(raw)
            return data.displayName or data.name
        end)
        if ok and res then
            name_cache[uid_str] = res
            if label_object and label_object.Parent then
                label_object.Text = "Auth: " .. res
            end
        else
            if label_object and label_object.Parent then
                label_object.Text = "Auth: ID " .. uid_str
            end
        end
    end)
end

local function scan_cupboards()
    if not Config.BaseScan.Enabled then return end
    local buildings = Workspace:FindFirstChild("Buildings")
    if not buildings then return end

    for _, building in ipairs(buildings:GetChildren()) do
        local attrs = building:GetAttributes()
        if attrs["Type"] == "ToolCupboard" or attrs["HasTC"] then
            local cabinet = building:FindFirstChild("Cabinet", true)
            if cabinet and not base_cache[cabinet] then
                local auth_uids = {}
                if attrs["OwnerId"] then table.insert(auth_uids, tostring(attrs["OwnerId"])) end
                for k, v in pairs(attrs) do
                    if k:find("Auth_") and v == true then
                        table.insert(auth_uids, k:gsub("Auth_", ""))
                    end
                end
                
                local bb = Instance.new("BillboardGui")
                bb.Adornee = cabinet
                bb.Size = UDim2.new(0, 250, 0, 50)
                bb.StudsOffsetWorldSpace = cabinet.CFrame.UpVector * (cabinet.Size.Y / 2 + 2)
                bb.AlwaysOnTop = true
                bb.Parent = cabinet
                
                local l1 = Instance.new("TextLabel")
                l1.Size = UDim2.new(1, 0, 0.5, 0); l1.BackgroundTransparency = 1
                l1.Text = "CABINET"; l1.TextColor3 = Config.BaseScan.CupboardColor
                l1.Font = Enum.Font.GothamBold; l1.TextSize = 16; l1.Parent = bb
                
                local l3 = Instance.new("TextLabel")
                l3.Size = UDim2.new(1, 0, 0.5, 0); l3.Position = UDim2.new(0, 0, 0.5, 0)
                l3.BackgroundTransparency = 1; l3.Text = "Auth: Loading..."
                l3.TextColor3 = Color3.fromRGB(255, 255, 255); l3.TextSize = 12; l3.Parent = bb
                
                base_cache[cabinet] = {gui = bb, label = l3}
                
                task.spawn(function()
                    local names = {}
                    for _, uid in ipairs(auth_uids) do
                        update_name_async(uid, l3)
                        task.wait(0.05)
                    end
                    if l3 and l3.Parent then
                        local parts = {}
                        for uid, _ in pairs(auth_uids) do
                            table.insert(parts, name_cache[tostring(uid)] or ("ID:"..tostring(uid)))
                        end
                        l3.Text = "Auth: " .. (#parts > 0 and table.concat(parts, ", ") or "None")
                    end
                end)
            end
        end
    end
end

local function scan_chests()
    if not Config.ChestScan.Enabled then return end
    local deployables = Workspace:FindFirstChild("Deployables")
    if deployables then
        for _, obj in ipairs(deployables:GetChildren()) do
            local lname = obj.Name:lower()
            if (lname:find("box") or lname:find("chest")) and not chest_cache[obj] then
                local primary = obj:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local bb = Instance.new("BillboardGui")
                    bb.Adornee = primary
                    bb.Size = UDim2.new(0, 150, 0, 40)
                    bb.StudsOffsetWorldSpace = primary.CFrame.UpVector * (primary.Size.Y / 2 + 1)
                    bb.AlwaysOnTop = true
                    bb.Parent = primary
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 0.5, 0); label.BackgroundTransparency = 1
                    label.Text = "CHEST"; label.TextColor3 = Config.ChestScan.Color
                    label.Font = Enum.Font.GothamBold; label.TextSize = 16; label.Parent = bb
                    
                    local hp_lbl = Instance.new("TextLabel")
                    hp_lbl.Size = UDim2.new(1, 0, 0.5, 0); hp_lbl.Position = UDim2.new(0, 0, 0.5, 0)
                    hp_lbl.BackgroundTransparency = 1; hp_lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                    hp_lbl.TextSize = 12; hp_lbl.Parent = bb
                    
                    chest_cache[obj] = {gui = bb, hp = hp_lbl}
                end
            end
        end
    end
end

local xray_parts = {}
local function apply_xray(state)
    local buildings = Workspace:FindFirstChild("Buildings")
    if not buildings then return end
    if state then
        for _, part in ipairs(buildings:GetDescendants()) do
            if part:IsA("BasePart") and not part.Name:find("Cabinet") then
                if not xray_parts[part] then
                    xray_parts[part] = part.LocalTransparencyModifier
                end
                part.LocalTransparencyModifier = 0.8
            end
        end
        for part in pairs(xray_parts) do
            if not part.Parent then xray_parts[part] = nil end
        end
    else
        for part, trans in pairs(xray_parts) do
            if part and part.Parent then
                part.LocalTransparencyModifier = trans
            end
        end
        xray_parts = {}
    end
end

-- ============================================================
-- ORE SCANNER
-- ============================================================
local ore_cache = {}
local function scan_ores()
    if not Config.OreESP.Enabled then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.Name == "Boulder" and obj:IsA("Model") then
            local rock = obj:FindFirstChild("Rock")
            if rock and rock:IsA("MeshPart") and not ore_cache[obj] then
                local bb = Instance.new("BillboardGui")
                bb.Adornee = rock
                bb.Size = UDim2.new(0, 100, 0, 30)
                bb.StudsOffsetWorldSpace = rock.CFrame.UpVector * (rock.Size.Y / 2 + 1)
                bb.AlwaysOnTop = true
                bb.Parent = rock
                
                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "ROCK"
                label.TextColor3 = Config.OreESP.Color
                label.Font = Enum.Font.GothamBold
                label.TextSize = 14
                label.Parent = bb
                
                ore_cache[obj] = {gui = bb, rock = rock}
            end
        end
    end
end
task.spawn(function()
    while task.wait(2) do
        if IsPanic or not Config.OreESP.Enabled then continue end
        scan_ores()
        for obj, data in pairs(ore_cache) do
            if not obj.Parent or not data.rock.Parent then
                data.gui:Destroy()
                ore_cache[obj] = nil
            else
                local dist = (data.rock.Position - Camera.CFrame.Position).Magnitude
                data.gui.Enabled = dist <= Config.OreESP.MaxDistance
            end
        end
    end
end)
local function clear_ores()
    for obj, data in pairs(ore_cache) do if data.gui then data.gui:Destroy() end end
    ore_cache = {}
end

-- ============================================================
-- МАСТЕР-ЦИКЛ СКАНИРОВАНИЯ
-- ============================================================
task.spawn(function()
    while task.wait(2) do
        if IsPanic then continue end
        scan_cupboards()
        scan_chests()
        if Config.BaseScan.XRay then apply_xray(true) else apply_xray(false) end
        
        for obj, data in pairs(base_cache) do
            if not obj.Parent then
                data.gui:Destroy()
                base_cache[obj] = nil
            else
                local dist = (obj.Position - Camera.CFrame.Position).Magnitude
                data.gui.Enabled = Config.BaseScan.Enabled and dist <= Config.BaseScan.MaxDistance
            end
        end

        for obj, data in pairs(chest_cache) do
            if not obj.Parent then
                data.gui:Destroy()
                chest_cache[obj] = nil
            else
                local primary = data.gui.Adornee
                if primary then
                    local dist = (primary.Position - Camera.CFrame.Position).Magnitude
                    data.gui.Enabled = Config.ChestScan.Enabled and dist <= Config.ChestScan.MaxDistance
                    if data.gui.Enabled then
                        local attrs = obj:GetAttributes()
                        local hp = attrs["ThingHealth"] and math.floor(attrs["ThingHealth"]) or "?"
                        data.hp.Text = "HP: " .. tostring(hp)
                    end
                end
            end
        end
    end
end)

local function clear_base_cache()
    for obj, data in pairs(base_cache) do if data.gui then data.gui:Destroy() end end
    base_cache = {}
    for obj, data in pairs(chest_cache) do if data.gui then data.gui:Destroy() end end
    chest_cache = {}
    apply_xray(false)
end

-- ============================================================
-- ESP / NOTIFS / WATERMARK / SUSPECTS / AIMBOT
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

local mod_list_gui = Instance.new("ScreenGui")
mod_list_gui.Name = "DegradeSuspectList"
mod_list_gui.ResetOnSpawn = false
mod_list_gui.IgnoreGuiInset = true
mod_list_gui.Parent = game.CoreGui
local mod_frame = Instance.new("Frame")
mod_frame.Size = UDim2.new(0, 220, 0, 30)
mod_frame.Position = UDim2.new(1, -240, 0, 60)
mod_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mod_frame.BackgroundTransparency = 0.3
mod_frame.BorderSizePixel = 0
mod_frame.Parent = mod_list_gui
Instance.new("UICorner", mod_frame).CornerRadius = UDim.new(0, 4)
local mod_title = Instance.new("TextLabel")
mod_title.Size = UDim2.new(1, 0, 0, 20)
mod_title.Position = UDim2.new(0, 5, 0, 5)
mod_title.BackgroundTransparency = 1
mod_title.Text = "Suspects: 0"
mod_title.TextColor3 = Color3.fromRGB(255, 50, 50)
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

local suspects = {}
local function is_behavior_suspect(plr)
    if not is_alive(plr) or not plr.Character then return false end
    local char = plr.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return false end
    local my_char = LocalPlayer.Character
    local my_hrp = my_char and my_char:FindFirstChild("HumanoidRootPart")
    if not my_hrp then return false end
    if hrp.Position.Y > my_hrp.Position.Y + 20 then return true end
    if hum.WalkSpeed > 50 then return true end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {char}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local ray = Workspace:Raycast(hrp.Position, Vector3.new(0, -100, 0), rayParams)
    if not ray and hrp.Position.Y > 10 then return true end
    return false
end
task.spawn(function()
    while task.wait(2) do
        if IsPanic then continue end
        if Config.Mod.ShowList then
            local sus = {}
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and is_behavior_suspect(plr) then
                    table.insert(sus, plr.Name)
                    suspects[plr] = true
                else
                    suspects[plr] = false
                end
            end
            if #sus > 0 then
                mod_title.Text = "Suspects: " .. #sus
                mod_names.Text = table.concat(sus, ", ")
                mod_frame.Size = UDim2.new(0, 220, 0, 30 + (#sus * 15))
            else
                mod_title.Text = "Suspects: 0"
                mod_names.Text = ""
                mod_frame.Size = UDim2.new(0, 220, 0, 30)
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if IsPanic then
        for plr, e in pairs(esp_cache) do hide_esp(e) end
        return
    end
    local rb_col = get_rainbow_color(Config.ESP.RainbowSpeed)
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
        local plr_suspect = suspects[plr]
        if Config.ESP.Enabled or (plr_suspect and Config.Mod.Enabled) then
            local height = math.abs(head_screen.Y - foot_screen.Y)
            local width = height * 0.5
            local x = head_screen.X - width / 2
            local y = head_screen.Y
            local final_box_col = plr_suspect and Config.Mod.Color or (Config.ESP.RainbowBox and rb_col or Config.ESP.BoxColor)
            local final_name_col = plr_suspect and Config.Mod.Color or (Config.ESP.RainbowName and rb_col or Config.ESP.NameColor)
            e.box.Visible = Config.ESP.Box or plr_suspect
            e.box.Size = Vector2.new(width, height)
            e.box.Position = Vector2.new(x, y)
            e.box.Color = final_box_col
            e.box.Thickness = Config.ESP.Thickness
            e.name.Text = plr.Name
            e.name.Size = Config.ESP.TextSize
            e.name.Position = Vector2.new(head_screen.X, y - Config.ESP.TextSize - 6)
            e.name.Visible = Config.ESP.Name or plr_suspect
            e.name.Color = final_name_col
            e.name.Outline = Config.ESP.TextOutline
            e.dist.Text = string.format("[%dm]", math.floor(distance))
            e.dist.Size = Config.ESP.TextSize - 2
            e.dist.Position = Vector2.new(head_screen.X, y + height + 4)
            e.dist.Visible = Config.ESP.Distance or plr_suspect
            e.dist.Color = Config.ESP.DistColor
            e.dist.Outline = Config.ESP.TextOutline
            if plr_suspect then
                e.mod_tag.Text = "SUSPECT"
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
        if suspects[plr] then continue end
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
-- FPS BOOST & ANTI-AFK
-- ============================================================
local original_fps_settings = {}
local function ToggleFPSBoost()
    if Config.FPSBoost then
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") then
                original_fps_settings[v] = v.Enabled
                v.Enabled = false
            end
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    else
        for v, enabled in pairs(original_fps_settings) do
            if v and v.Parent then v.Enabled = enabled end
        end
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level10
        original_fps_settings = {}
    end
end

task.spawn(function()
    while task.wait(60) do
        if Config.AntiAFK and not IsPanic then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(math.random(-15, 15)), 0)
            end
        end
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
        for plr, e in pairs(esp_cache) do hide_esp(e) end
        clear_base_cache()
        clear_ores()
        toggle_noclip(false)
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
-- UI (Rayfield)
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
    Name = "DEGRADE | ULTIMATE v250",
    LoadingTitle = "DEGRADE",
    LoadingSubtitle = "Ultimate Scanner",
    ConfigurationSaving = { Enabled = false, FolderName = "DegradeBuild", FileName = "v250" },
    KeySystem = false,
})

local CombatTab = Window:CreateTab("Combat")
CombatTab:CreateSection("Aimbot (Soft)")
CombatTab:CreateToggle({Name="Enable Aimbot", CurrentValue=false, Flag="aim_on", Callback=function(v) Config.Aimbot.Enabled=v send_notif("AIMBOT", v and "Enabled" or "Disabled", v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)) end})
CombatTab:CreateToggle({Name="Always-On (mobile)", CurrentValue=false, Flag="aim_always", Callback=function(v) Config.Aimbot.AlwaysOn=v end})
CombatTab:CreateToggle({Name="Ignore Teammates", CurrentValue=true, Flag="aim_team", Callback=function(v) Config.Aimbot.TeamCheck=v end})
CombatTab:CreateDropdown({Name="Aim Part", Options={"Head","Body"}, CurrentOption={"Head"}, Flag="aim_part", Callback=function(o) Config.Aimbot.AimPart=o[1] or o end})
CombatTab:CreateSlider({Name="FOV Radius", Range={50,400}, Increment=10, CurrentValue=120, Flag="aim_fov", Callback=function(v) Config.Aimbot.FOV=v end})
CombatTab:CreateSlider({Name="Smoothness", Range={0.01,1}, Increment=0.01, CurrentValue=0.08, Flag="aim_sm", Callback=function(v) Config.Aimbot.Smoothness=v end})
CombatTab:CreateToggle({Name="Wall Check", CurrentValue=true, Flag="aim_wall", Callback=function(v) Config.Aimbot.WallCheck=v end})

local MovementTab = Window:CreateTab("Movement")
MovementTab:CreateSection("Safe Glitch")
MovementTab:CreateToggle({Name="Noclip (RISK)", CurrentValue=false, Flag="noclip", Callback=function(v) toggle_noclip(v) end})
MovementTab:CreateToggle({Name="Safe TP (Hold RMB)", CurrentValue=false, Flag="safetp", Callback=function(v) Config.Movement.SafeTP=v end})

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

local OreTab = Window:CreateTab("Ore ESP")
OreTab:CreateSection("Rocks (Boulders)")
OreTab:CreateToggle({Name="Enable Rock ESP", CurrentValue=false, Flag="ore_on", Callback=function(v) Config.OreESP.Enabled=v send_notif("ROCK ESP", v and "Enabled" or "Disabled", Color3.fromRGB(0,200,255)) end})
OreTab:CreateSlider({Name="Max Scan Distance", Range={50,1000}, Increment=50, CurrentValue=400, Flag="ore_dist", Callback=function(v) Config.OreESP.MaxDistance=v end})
OreTab:CreateColorPicker({Name="Rock Color", Color=Config.OreESP.Color, Flag="ore_col", Callback=function(c) Config.OreESP.Color=c end})

local BaseTab = Window:CreateTab("Base Scanner")
BaseTab:CreateSection("Cupboards")
BaseTab:CreateToggle({Name="Enable Cupboard Scanner", CurrentValue=false, Flag="base_on", Callback=function(v) Config.BaseScan.Enabled=v send_notif("BASE SCAN", v and "Enabled" or "Disabled", Color3.fromRGB(0,200,255)) end})
BaseTab:CreateSlider({Name="Max Scan Distance", Range={100,3000}, Increment=100, CurrentValue=800, Flag="base_dist", Callback=function(v) Config.BaseScan.MaxDistance=v end})
BaseTab:CreateColorPicker({Name="Cupboard Color", Color=Config.BaseScan.CupboardColor, Flag="base_tc_col", Callback=function(c) Config.BaseScan.CupboardColor=c end})
BaseTab:CreateToggle({Name="Base X-Ray", CurrentValue=false, Flag="base_xray", Callback=function(v) Config.BaseScan.XRay=v end})

BaseTab:CreateSection("Chests")
BaseTab:CreateToggle({Name="Enable Chest Scanner", CurrentValue=false, Flag="chest_on", Callback=function(v) Config.ChestScan.Enabled=v send_notif("CHEST SCAN", v and "Enabled" or "Disabled", Color3.fromRGB(255,150,0)) end})
BaseTab:CreateSlider({Name="Chest Max Dist", Range={100,2000}, Increment=100, CurrentValue=500, Flag="chest_dist", Callback=function(v) Config.ChestScan.MaxDistance=v end})
BaseTab:CreateColorPicker({Name="Chest Color", Color=Config.ChestScan.Color, Flag="chest_col", Callback=function(c) Config.ChestScan.Color=c end})

local ModTab = Window:CreateTab("Mods")
ModTab:CreateSection("Behavior Detector")
ModTab:CreateToggle({Name="Suspect ESP (Force Red Box)", CurrentValue=false, Flag="mod_esp", Callback=function(v) Config.Mod.Enabled=v send_notif("SUSPECT ESP", v and "Enabled" or "Disabled", Color3.fromRGB(255,50,50)) end})
ModTab:CreateToggle({Name="Alert when Suspect < 300m", CurrentValue=false, Flag="mod_alert", Callback=function(v) Config.Mod.Alert=v end})
ModTab:CreateToggle({Name="Show Suspect List (Top Right)", CurrentValue=true, Flag="mod_list", Callback=function(v) Config.Mod.ShowList=v; mod_frame.Visible=v end})
ModTab:CreateColorPicker({Name="Suspect Color", Color=Config.Mod.Color, Flag="mod_col", Callback=function(c) Config.Mod.Color=c end})

local SettingsTab = Window:CreateTab("Settings")
SettingsTab:CreateSection("Performance")
SettingsTab:CreateToggle({Name="FPS Boost", CurrentValue=false, Flag="fps_boost", Callback=function(v) Config.FPSBoost=v ToggleFPSBoost() end})

SettingsTab:CreateSection("Misc")
SettingsTab:CreateToggle({Name="Anti-AFK", CurrentValue=false, Flag="antiafk", Callback=function(v) Config.AntiAFK=v end})
SettingsTab:CreateLabel("Panic Key: Right Shift")

task.delay(10, function()
    send_notif("DEGRADE", "Ultimate Build v250 Loaded.", Color3.fromRGB(0, 200, 255))
end)

print("[DEGRADE] v250 loaded.")
