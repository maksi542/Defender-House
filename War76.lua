-- language: Lua (Luau), file: smokexr_ultimate_v21.lua, target: Voxel Wars, executor: Solara
-- CREATOR SMOKExR'S | ULTIMATE v21 | Final Fixes

task.wait(1.5)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ============================================================
-- 10 СЕКУНДНАЯ МАТРИЦА (LOADING SCREEN)
-- ============================================================
local load_gui = Instance.new("ScreenGui")
load_gui.Name = "SmokeLoader" load_gui.ResetOnSpawn = false load_gui.Parent = game.CoreGui

local load_bg = Instance.new("Frame")
load_bg.Size = UDim2.new(1, 0, 1, 0) load_bg.BackgroundColor3 = Color3.fromRGB(0, 5, 0) load_bg.BorderSizePixel = 0 load_bg.Parent = load_gui

local load_text = Instance.new("TextLabel")
load_text.Size = UDim2.new(1, 0, 0, 50) load_text.Position = UDim2.new(0, 0, 0.4, 0)
load_text.BackgroundTransparency = 1 load_text.Text = "SMOKExR'S ULTIMATE"
load_text.TextColor3 = Color3.fromRGB(0, 255, 0) load_text.Font = Enum.Font.Code load_text.TextSize = 40
load_text.Parent = load_bg

local load_sub = Instance.new("TextLabel")
load_sub.Size = UDim2.new(1, 0, 0, 30) load_sub.Position = UDim2.new(0, 0, 0.48, 0)
load_sub.BackgroundTransparency = 1 load_sub.Text = "INITIALIZING HOOKS..."
load_sub.TextColor3 = Color3.fromRGB(150, 255, 150) load_sub.Font = Enum.Font.Code load_sub.TextSize = 16
load_sub.Parent = load_bg

local load_bar_bg = Instance.new("Frame")
load_bar_bg.Size = UDim2.new(0, 400, 0, 4) load_bar_bg.Position = UDim2.new(0.5, -200, 0.55, 0)
load_bar_bg.BackgroundColor3 = Color3.fromRGB(0, 50, 0) load_bar_bg.BorderSizePixel = 0 load_bar_bg.Parent = load_bg

local load_bar = Instance.new("Frame")
load_bar.Size = UDim2.new(0, 0, 1, 0) load_bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0) load_bar.BorderSizePixel = 0 load_bar.Parent = load_bar_bg

task.spawn(function()
    for i = 1, 30 do
        load_text.Position = UDim2.new(0, math.random(-20, 20), 0.4, math.random(-10, 10))
        load_sub.Text = string.format("INITIALIZING... %d%%", math.floor(i/30*100))
        task.wait(0.05)
    end
    load_text.Position = UDim2.new(0, 0, 0.4, 0)
    load_sub.Text = "SYSTEM ONLINE"
end)

TweenService:Create(load_bar, TweenInfo.new(9.5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)}):Play()

task.delay(10, function()
    if load_gui then
        TweenService:Create(load_bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        for _, v in ipairs(load_bg:GetDescendants()) do
            if v:IsA("TextLabel") or v:IsA("Frame") then
                pcall(function() TweenService:Create(v, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1}):Play() end)
            end
        end
        task.wait(0.5)
        load_gui:Destroy()
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Config = {
    Aimbot = { Enabled = false, FOV = 150, Smoothness = 0.05, WallCheck = true, TeamCheck = true, Part = "Head", NoRecoil = true, Prediction = 0.15 },
    SilentAim = { Enabled = false, TeamCheck = true, Part = "Head", FOV = 500 },
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
    Chams = { Enabled = false, Rainbow = false, Color = Color3.fromRGB(255, 0, 255), Transparency = 0.5 },
    Skeleton = { Enabled = false, Rainbow = false, Color = Color3.fromRGB(255, 255, 255), Thickness = 1 },
    VehicleESP = { Enabled = false, Color = Color3.fromRGB(255, 100, 0) },
    Utility = { SpeedEnabled = false, SpeedValue = 60 },
    Crosshair = { Enabled = false, Color = Color3.fromRGB(0, 255, 0), Size = 10, Thickness = 2, Gap = 4 }
}

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
-- WATERMARK (ЗЕЛЕНЫЙ FPS/PING)
-- ============================================================
local wm_gui = Instance.new("ScreenGui")
wm_gui.Name = "SmokeWatermark" wm_gui.ResetOnSpawn = false wm_gui.Parent = game.CoreGui
local wm_frame = Instance.new("Frame")
wm_frame.Size = UDim2.new(0, 280, 0, 140) wm_frame.Position = UDim2.new(0, 20, 0, 20)
wm_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12) wm_frame.BackgroundTransparency = 0.3
wm_frame.BorderSizePixel = 0 wm_frame.Parent = wm_gui
Instance.new("UICorner", wm_frame).CornerRadius = UDim.new(0, 6)
local wm_stroke = Instance.new("UIStroke") wm_stroke.Thickness = 2 wm_stroke.Parent = wm_frame
wm_frame.ClipsDescendants = true

local eq_container = Instance.new("Frame")
eq_container.Size = UDim2.new(0, 40, 0, 20) eq_container.Position = UDim2.new(1, -50, 0, 5)
eq_container.BackgroundTransparency = 1 eq_container.Parent = wm_frame
local eq_bars = {}
for i = 1, 5 do
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 4, 0, 5) bar.Position = UDim2.new(0, (i-1)*7, 1, 0)
    bar.AnchorPoint = Vector2.new(0, 1) bar.BackgroundColor3 = get_rainbow_color(2)
    bar.BorderSizePixel = 0 bar.Parent = eq_container
    table.insert(eq_bars, bar)
end
RunService.RenderStepped:Connect(function()
    for _, bar in ipairs(eq_bars) do
        TweenService:Create(bar, TweenInfo.new(0.1), {Size = UDim2.new(0, 4, 0, math.random(2, 18))}):Play()
    end
end)

local wm_title = Instance.new("TextLabel")
wm_title.Size = UDim2.new(1, -50, 0, 20) wm_title.Position = UDim2.new(0, 5, 0, 5)
wm_title.BackgroundTransparency = 1 wm_title.Text = "SMOKExR'S | FPS: 0"
wm_title.TextColor3 = Color3.fromRGB(255, 255, 255) wm_title.Font = Enum.Font.GothamBold
wm_title.TextSize = 12 wm_title.TextXAlignment = Enum.TextXAlignment.Left wm_title.RichText = true wm_title.Parent = wm_frame

local wm_stats = Instance.new("TextLabel")
wm_stats.Size = UDim2.new(1, -10, 0, 20) wm_stats.Position = UDim2.new(0, 5, 0, 25)
wm_stats.BackgroundTransparency = 1 wm_stats.Text = "Alive: 0 | Dead: 0"
wm_stats.TextColor3 = Color3.fromRGB(0, 255, 120) wm_stats.Font = Enum.Font.GothamBold
wm_stats.TextSize = 11 wm_stats.TextXAlignment = Enum.TextXAlignment.Left wm_stats.Parent = wm_frame

local wm_credits = Instance.new("TextLabel")
wm_credits.Size = UDim2.new(1, -10, 0, 30) wm_credits.Position = UDim2.new(0, 5, 0, 45)
wm_credits.BackgroundTransparency = 1 wm_credits.Text = "CREATOR: SMOKExR'S\nTESTER: TROLLxTT"
wm_credits.TextColor3 = get_rainbow_color(1.5) wm_credits.Font = Enum.Font.GothamBold
wm_credits.TextSize = 11 wm_credits.TextXAlignment = Enum.TextXAlignment.Left wm_credits.Parent = wm_frame

local wm_info = Instance.new("TextLabel")
wm_info.Size = UDim2.new(1, -10, 0, 25) wm_info.Position = UDim2.new(0, 5, 0, 110)
wm_info.BackgroundTransparency = 1 wm_info.Text = string.format("User: %s | Exec: Solara", LocalPlayer.Name)
wm_info.TextColor3 = Color3.fromRGB(180, 180, 180) wm_info.Font = Enum.Font.Gotham
wm_info.TextSize = 10 wm_info.TextXAlignment = Enum.TextXAlignment.Left wm_info.Parent = wm_frame

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
        wm_title.Text = string.format("SMOKExR'S | <font color='#00FF00'>FPS: %d | PING: %dms</font>", fps_val, ping)
        wm_stats.Text = string.format("Alive: %d | Dead: %d", alive, dead)
        wm_credits.TextColor3 = get_rainbow_color(1.5)
    end
end)

-- ============================================================
-- TRUE SILENT AIM (Hook на Raycast)
-- ============================================================
local function get_silent_target()
    local char, hum, hrp = get_character()
    if not char then return nil end
    local best, best_dist = nil, Config.SilentAim.FOV
    local center = Camera.ViewportSize / 2
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) then continue end
        if Config.SilentAim.TeamCheck and is_teammate(plr) then continue end
        local part = plr.Character:FindFirstChild(Config.SilentAim.Part) or plr.Character:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        local screen = world_to_screen(part.Position)
        if screen then
            local dist = (screen - center).Magnitude
            if dist < best_dist then best, best_dist = part, dist end
        end
    end
    return best
end

local old_raycast
if hookmetamethod then
    old_raycast = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and Config.SilentAim.Enabled then
            -- Перехватываем Raycast
            if method == "Raycast" then
                local target = get_silent_target()
                if target then
                    local args = {...}
                    -- Аргументы Raycast: (origin, direction, params)
                    if typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                        local origin = args[1]
                        local dir = (target.Position - origin).Unit * (args[2] - origin).Magnitude
                        args[2] = dir
                    end
                    return old_raycast(self, unpack(args))
                end
            -- Перехватываем FireServer на случай, если это оружие
            elseif method == "FireServer" then
                local target = get_silent_target()
                if target then
                    local args = {...}
                    for i, v in pairs(args) do
                        if typeof(v) == "CFrame" then
                            args[i] = CFrame.new(Camera.CFrame.Position, target.Position)
                        elseif typeof(v) == "Vector3" then
                            args[i] = target.Position
                        end
                    end
                    return old_raycast(self, unpack(args))
                end
            end
        end
        return old_raycast(self, ...)
    end)
end

-- ============================================================
-- TELEPORT (Исправленный бинд)
-- ============================================================
local tp_key = Enum.KeyCode.T
local function teleport_to_enemy()
    local char, hum, hrp = get_character()
    if not char then return end
    local best, best_dist = nil, 9999
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) then continue end
        if Config.ESP.TeamCheck and is_teammate(plr) then continue end
        local e_hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if e_hrp then
            local d = (e_hrp.Position - hrp.Position).Magnitude
            if d < best_dist then best, best_dist = e_hrp, d end
        end
    end
    if best then hrp.CFrame = best.CFrame + Vector3.new(0, 3, 0) end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == tp_key then
            teleport_to_enemy()
        end
    end
end)

-- ============================================================
-- VEHICLE ESP (Вынесено в цикл task.wait(1) чтобы не лагало)
-- ============================================================
local veh_cache = {}
task.spawn(function()
    while task.wait(1) do
        if Config.VehicleESP.Enabled then
            -- Сканируем ВСЕ модели в Workspace
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") then
                    local hasSeat = obj:FindFirstChildWhichIsA("VehicleSeat") or obj:FindFirstChildWhichIsA("Seat")
                    -- Voxel Wars: техника обычно имеет Humanoid или Motor6D
                    local isVehicle = hasSeat or obj:FindFirstChild("Humanoid") or obj:FindFirstChild("Motor6D")
                    
                    if isVehicle and not veh_cache[obj] and not Players:GetPlayerFromCharacter(obj) then
                        -- Исключаем игроков (у них Highlight уже есть или будет)
                        local hl = Instance.new("Highlight")
                        hl.Parent = obj
                        hl.FillColor = Config.VehicleESP.Color
                        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                        hl.FillTransparency = 0.5
                        veh_cache[obj] = hl
                    end
                end
            end
            -- Очистка старых
            for model, hl in pairs(veh_cache) do
                if not model.Parent then
                    hl:Destroy()
                    veh_cache[model] = nil
                end
            end
        else
            for model, hl in pairs(veh_cache) do
                hl:Destroy()
                veh_cache[model] = nil
            end
        end
    end
end)

-- ============================================================
-- CHAMS & SKELETON
-- ============================================================
local chams_cache = {}
local function update_chams()
    local rb_col = get_rainbow_color(1.5)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char or not is_alive(plr) or (Config.ESP.TeamCheck and is_teammate(plr)) then
            if chams_cache[plr] then chams_cache[plr]:Destroy() chams_cache[plr] = nil end
            continue
        end
        if Config.Chams.Enabled then
            if not chams_cache[plr] then
                local hl = Instance.new("Highlight") hl.Parent = char
                hl.FillColor = Config.Chams.Rainbow and rb_col or Config.Chams.Color
                hl.OutlineColor = Color3.fromRGB(255, 255, 255) hl.FillTransparency = Config.Chams.Transparency
                chams_cache[plr] = hl
            else
                chams_cache[plr].FillColor = Config.Chams.Rainbow and rb_col or Config.Chams.Color
                chams_cache[plr].FillTransparency = Config.Chams.Transparency
            end
        else
            if chams_cache[plr] then chams_cache[plr]:Destroy() chams_cache[plr] = nil end
        end
    end
end

local skel_cache = {}
local function create_skel(plr)
    local lines = {}
    for i = 1, 15 do
        local l = Drawing.new("Line") l.Visible = false l.Thickness = Config.Skeleton.Thickness
        table.insert(lines, l)
    end
    skel_cache[plr] = lines
end
for _, plr in ipairs(Players:GetPlayers()) do create_skel(plr) end
Players.PlayerAdded:Connect(create_skel)
Players.PlayerRemoving:Connect(function(plr)
    if skel_cache[plr] then for _, l in ipairs(skel_cache[plr]) do l:Remove() end skel_cache[plr] = nil end
end)

local function draw_skeleton(plr, e_lines)
    if not Config.Skeleton.Enabled then for _, l in ipairs(e_lines) do l.Visible = false end return end
    local rb_col = get_rainbow_color(1.5) local final_col = Config.Skeleton.Rainbow and rb_col or Config.Skeleton.Color
    for _, l in ipairs(e_lines) do l.Color = final_col end
    local char = plr.Character
    local head = char:FindFirstChild("Head") local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    local l_arm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm") local r_arm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
    local l_leg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg") local r_leg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
    if not head or not torso then for _, l in ipairs(e_lines) do l.Visible = false end return end
    local h_pos = world_to_screen(head.Position) local t_pos = world_to_screen(torso.Position)
    if not h_pos or not t_pos then for _, l in ipairs(e_lines) do l.Visible = false end return end
    local points = {h_pos, t_pos}
    for _, p in ipairs({l_arm, r_arm, l_leg, r_leg}) do if p then local s_pos = world_to_screen(p.Position) if s_pos then table.insert(points, s_pos) end end end
    local idx = 1
    e_lines[idx].From = h_pos e_lines[idx].To = t_pos e_lines[idx].Visible = true idx = idx + 1
    for i = 3, #points do e_lines[idx].From = t_pos e_lines[idx].To = points[i] e_lines[idx].Visible = true idx = idx + 1 end
    for i = idx, #e_lines do e_lines[i].Visible = false end
end

-- ============================================================
-- MAIN ESP & AIMBOT
-- ============================================================
local fov_gui = Instance.new("ScreenGui")
fov_gui.Name = "SmokeFOV" fov_gui.ResetOnSpawn = false fov_gui.Parent = game.CoreGui
local fov_circle = Instance.new("Frame") fov_circle.AnchorPoint = Vector2.new(0.5, 0.5) fov_circle.Position = UDim2.new(0.5, 0, 0.5, 0)
fov_circle.BackgroundTransparency = 1 fov_circle.Parent = fov_gui
local fov_stroke = Instance.new("UIStroke") fov_stroke.Thickness = 1.5 fov_stroke.Transparency = 0.4 fov_stroke.Parent = fov_circle
Instance.new("UICorner", fov_circle).CornerRadius = UDim.new(1, 0)

RunService.RenderStepped:Connect(function()
    if not Config.Aimbot.Enabled then fov_circle.Visible = false return end
    fov_circle.Visible = true fov_circle.Size = UDim2.new(0, Config.Aimbot.FOV * 2, 0, Config.Aimbot.FOV * 2)
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
    local e = esp_cache[plr] if e then for _, v in pairs(e) do v:Remove() end esp_cache[plr] = nil end
end)

RunService.RenderStepped:Connect(function()
    local rb_col = get_rainbow_color(Config.ESP.RainbowSpeed)
    update_chams()
    for plr, e in pairs(esp_cache) do
        if not Config.ESP.Enabled or not is_alive(plr) or (Config.ESP.TeamCheck and is_teammate(plr)) then
            e.box.Visible = false e.name.Visible = false e.dist.Visible = false e.hp_bg.Visible = false e.hp_bar.Visible = false e.tracer.Visible = false e.name_bg.Visible = false
            if skel_cache[plr] then for _, l in ipairs(skel_cache[plr]) do l.Visible = false end end
            continue
        end
        local char = plr.Character local hrp = char and char:FindFirstChild("HumanoidRootPart") local head = char and char:FindFirstChild("Head") local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not head or not hum then continue end
        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
        if distance > Config.ESP.MaxDistance then continue end
        local head_screen = world_to_screen(head.Position + Vector3.new(0, 0.5, 0)) local foot_screen = world_to_screen(hrp.Position - Vector3.new(0, 3, 0))
        if not head_screen or not foot_screen then
            e.box.Visible = false e.name.Visible = false e.dist.Visible = false e.hp_bg.Visible = false e.hp_bar.Visible = false e.tracer.Visible = false e.name_bg.Visible = false
            if skel_cache[plr] then for _, l in ipairs(skel_cache[plr]) do l.Visible = false end end
            continue
        end
        if skel_cache[plr] then draw_skeleton(plr, skel_cache[plr]) end
        local height = math.abs(head_screen.Y - foot_screen.Y) local width = height * 0.5
        local x = head_screen.X - width / 2 local y = head_screen.Y
        local final_box_col = Config.ESP.RainbowBox and rb_col or Config.ESP.BoxColor
        local final_name_col = Config.ESP.RainbowName and rb_col or Config.ESP.NameColor
        local final_dist_col = Config.ESP.RainbowDist and rb_col or Config.ESP.DistColor
        
        e.box.Visible = Config.ESP.Box e.box.Size = Vector2.new(width, height) e.box.Position = Vector2.new(x, y) e.box.Color = final_box_col e.box.Thickness = Config.ESP.Thickness
        e.name.Text = plr.Name e.name.Size = Config.ESP.TextSize e.name.Position = Vector2.new(head_screen.X, y - Config.ESP.TextSize - 6) e.name.Visible = Config.ESP.Name e.name.Color = final_name_col e.name.Outline = Config.ESP.TextOutline
        e.dist.Text = string.format("[%dm]", math.floor(distance)) e.dist.Size = Config.ESP.TextSize - 2 e.dist.Position = Vector2.new(head_screen.X, y + height + 4) e.dist.Visible = Config.ESP.Distance e.dist.Color = final_dist_col e.dist.Outline = Config.ESP.TextOutline
        
        if Config.ESP.ShowBg and Config.ESP.Name then
            e.name_bg.Visible = true
            local bg_width = (e.name.Text:len() * Config.ESP.TextSize) * 0.55 local bg_height = Config.ESP.TextSize + 4
            e.name_bg.Size = Vector2.new(bg_width, bg_height) e.name_bg.Position = Vector2.new(head_screen.X - bg_width/2, y - Config.ESP.TextSize - 8)
            e.name_bg.Color = Color3.fromRGB(0, 0, 0) e.name_bg.Transparency = 0.5
        else e.name_bg.Visible = false end
        
        if Config.ESP.Health then
            local hp_pct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            e.hp_bg.Visible = true e.hp_bg.Size = Vector2.new(4, height) e.hp_bg.Position = Vector2.new(x - 8, y)
            e.hp_bar.Visible = true e.hp_bar.Size = Vector2.new(4, height * hp_pct) e.hp_bar.Position = Vector2.new(x - 8, y + height * (1 - hp_pct))
            e.hp_bar.Color = Color3.fromRGB(255 * (1 - hp_pct), 255 * hp_pct, 0)
        else e.hp_bg.Visible = false e.hp_bar.Visible = false end
        
        e.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) e.tracer.To = Vector2.new(head_screen.X, y + height) e.tracer.Visible = Config.ESP.Tracer e.tracer.Color = final_box_col
    end
end)

RunService.RenderStepped:Connect(function()
    if not Config.Aimbot.Enabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    local char, hum, hrp = get_character() if not char then return end
    local best, best_dist = nil, Config.Aimbot.FOV local center = Camera.ViewportSize / 2
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) then continue end
        if Config.Aimbot.TeamCheck and is_teammate(plr) then continue end
        local part = plr.Character:FindFirstChild(Config.Aimbot.Part) or plr.Character:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        if Config.Aimbot.WallCheck then
            local params = RaycastParams.new() params.FilterType = Enum.RaycastFilterType.Exclude params.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
            if Workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, params) then continue end
        end
        local screen = world_to_screen(part.Position) if not screen then continue end
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

-- ============================================================
-- PHYSICS SPEED (BODYVELOCITY)
-- ============================================================
local speed_bv = nil
task.spawn(function()
    while task.wait(0.1) do
        if Config.Utility.SpeedEnabled then
            local char, hum, hrp = get_character()
            if char and hrp then
                if not speed_bv or not speed_bv.Parent then
                    speed_bv = Instance.new("BodyVelocity")
                    speed_bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    speed_bv.Parent = hrp
                end
                local move_dir = hum.MoveDirection
                if move_dir.Magnitude > 0 then
                    speed_bv.Velocity = move_dir * Config.Utility.SpeedValue
                else
                    speed_bv.Velocity = Vector3.zero
                end
            end
        else
            if speed_bv then speed_bv:Destroy() speed_bv = nil end
        end
    end
end)

-- ============================================================
-- UI
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "SMOKExR'S | ULTIMATE v21",
    LoadingTitle = "SMOKExR'S",
    LoadingSubtitle = "Final Fixes",
    ConfigurationSaving = { Enabled = false, FolderName = "SmokePremium", FileName = "VoxelV21" },
    KeySystem = false,
})

local CombatTab = Window:CreateTab("Combat")
CombatTab:CreateSection("Silent Aim")
CombatTab:CreateToggle({ Name = "Enable Silent Aim", CurrentValue = false, Flag = "saim_on", Callback = function(v) Config.SilentAim.Enabled = v end })
CombatTab:CreateToggle({ Name = "Ignore Teammates", CurrentValue = true, Flag = "saim_team", Callback = function(v) Config.SilentAim.TeamCheck = v end })
CombatTab:CreateSlider({ Name = "Silent FOV", Range = { 50, 1000 }, Increment = 10, CurrentValue = 500, Flag = "saim_fov", Callback = function(v) Config.SilentAim.FOV = v end })

CombatTab:CreateSection("Regular Aimbot")
CombatTab:CreateToggle({ Name = "Enable Aimbot", CurrentValue = false, Flag = "aim_on", Callback = function(v) Config.Aimbot.Enabled = v end })
CombatTab:CreateToggle({ Name = "Ignore Teammates", CurrentValue = true, Flag = "aim_team", Callback = function(v) Config.Aimbot.TeamCheck = v end })
CombatTab:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head", "HumanoidRootPart", "UpperTorso"},
    CurrentOption = {"Head"},
    Flag = "aim_part",
    Callback = function(option)
        Config.Aimbot.Part = option[1] or option
        Config.SilentAim.Part = option[1] or option
    end,
})
CombatTab:CreateSlider({ Name = "FOV Radius", Range = { 50, 500 }, Increment = 10, CurrentValue = 150, Flag = "aim_fov", Callback = function(v) Config.Aimbot.FOV = v end })
CombatTab:CreateSlider({ Name = "Smoothness", Range = { 0.01, 1 }, Increment = 0.01, CurrentValue = 0.05, Flag = "aim_sm", Callback = function(v) Config.Aimbot.Smoothness = v end })
CombatTab:CreateSlider({ Name = "Prediction", Range = { 0, 0.5 }, Increment = 0.01, CurrentValue = 0.15, Flag = "aim_pred", Callback = function(v) Config.Aimbot.Prediction = v end })
CombatTab:CreateToggle({ Name = "No Recoil", CurrentValue = true, Flag = "aim_rec", Callback = function(v) Config.Aimbot.NoRecoil = v end })
CombatTab:CreateToggle({ Name = "Wall Check", CurrentValue = true, Flag = "aim_wall", Callback = function(v) Config.Aimbot.WallCheck = v end })

CombatTab:CreateSection("Actions")
CombatTab:CreateButton({ Name = "Teleport to Enemy (Press T)", Callback = function() teleport_to_enemy() end })
CombatTab:CreateKeybind({
    Name = "Teleport Keybind",
    CurrentKeybind = "T",
    HoldToInteract = false,
    Flag = "tp_key",
    Callback = function(key) 
        tp_key = key
    end
})

local VisualTab = Window:CreateTab("Visuals")
VisualTab:CreateSection("ESP Master")
VisualTab:CreateToggle({ Name = "Enable ESP", CurrentValue = false, Flag = "esp_on", Callback = function(v) Config.ESP.Enabled = v end })
VisualTab:CreateToggle({ Name = "Ignore Teammates", CurrentValue = true, Flag = "esp_team", Callback = function(v) Config.ESP.TeamCheck = v end })
VisualTab:CreateToggle({ Name = "Box", CurrentValue = false, Flag = "esp_box", Callback = function(v) Config.ESP.Box = v end })
VisualTab:CreateToggle({ Name = "Health Bar", CurrentValue = false, Flag = "esp_hp", Callback = function(v) Config.ESP.Health = v end })
VisualTab:CreateToggle({ Name = "Name", CurrentValue = false, Flag = "esp_name", Callback = function(v) Config.ESP.Name = v end })
VisualTab:CreateToggle({ Name = "Distance", CurrentValue = false, Flag = "esp_dist", Callback = function(v) Config.ESP.Distance = v end })
VisualTab:CreateToggle({ Name = "Tracer", CurrentValue = false, Flag = "esp_tracer", Callback = function(v) Config.ESP.Tracer = v end })
VisualTab:CreateSlider({ Name = "Max Distance", Range = { 100, 5000 }, Increment = 100, CurrentValue = 1500, Flag = "esp_dist_max", Callback = function(v) Config.ESP.MaxDistance = v end })

VisualTab:CreateSection("Text Style")
VisualTab:CreateSlider({ Name = "Text Size", Range = { 12, 32 }, Increment = 1, CurrentValue = 18, Flag = "esp_text_size", Callback = function(v) Config.ESP.TextSize = v end })
VisualTab:CreateToggle({ Name = "Text Outline", CurrentValue = true, Flag = "esp_text_out", Callback = function(v) Config.ESP.TextOutline = v end })
VisualTab:CreateToggle({ Name = "Text Background", CurrentValue = true, Flag = "esp_text_bg", Callback = function(v) Config.ESP.ShowBg = v end })

VisualTab:CreateSection("Skeleton ESP")
VisualTab:CreateToggle({ Name = "Enable Skeleton", CurrentValue = false, Flag = "skel_on", Callback = function(v) Config.Skeleton.Enabled = v end })
VisualTab:CreateToggle({ Name = "Rainbow Skeleton", CurrentValue = false, Flag = "skel_rb", Callback = function(v) Config.Skeleton.Rainbow = v end })
VisualTab:CreateColorPicker({ Name = "Skeleton Color", Color = Config.Skeleton.Color, Flag = "skel_col", Callback = function(c) Config.Skeleton.Color = c end })

VisualTab:CreateSection("Chams (Glow)")
VisualTab:CreateToggle({ Name = "Enable Chams", CurrentValue = false, Flag = "chams_on", Callback = function(v) Config.Chams.Enabled = v end })
VisualTab:CreateToggle({ Name = "Rainbow Chams", CurrentValue = false, Flag = "chams_rb", Callback = function(v) Config.Chams.Rainbow = v end })
VisualTab:CreateColorPicker({ Name = "Chams Color", Color = Config.Chams.Color, Flag = "chams_col", Callback = function(c) Config.Chams.Color = c end })
VisualTab:CreateSlider({ Name = "Chams Transparency", Range = { 0, 1 }, Increment = 0.1, CurrentValue = 0.5, Flag = "chams_tr", Callback = function(v) Config.Chams.Transparency = v end })

VisualTab:CreateSection("Vehicle ESP")
VisualTab:CreateToggle({ Name = "Enable Vehicle ESP", CurrentValue = false, Flag = "veh_on", Callback = function(v) Config.VehicleESP.Enabled = v end })
VisualTab:CreateColorPicker({ Name = "Vehicle Color", Color = Config.VehicleESP.Color, Flag = "veh_col", Callback = function(c) Config.VehicleESP.Color = c end })

VisualTab:CreateSection("Colors & Rainbow")
VisualTab:CreateColorPicker({ Name = "Box Color", Color = Config.ESP.BoxColor, Flag = "esp_box_col", Callback = function(c) Config.ESP.BoxColor = c end })
VisualTab:CreateToggle({ Name = "Rainbow Box", CurrentValue = false, Flag = "esp_rb_box", Callback = function(v) Config.ESP.RainbowBox = v end })
VisualTab:CreateColorPicker({ Name = "Name Color", Color = Config.ESP.NameColor, Flag = "esp_name_col", Callback = function(c) Config.ESP.NameColor = c end })
VisualTab:CreateToggle({ Name = "Rainbow Name", CurrentValue = false, Flag = "esp_rb_name", Callback = function(v) Config.ESP.RainbowName = v end })
VisualTab:CreateColorPicker({ Name = "Distance Color", Color = Config.ESP.DistColor, Flag = "esp_dist_col", Callback = function(c) Config.ESP.DistColor = c end })
VisualTab:CreateToggle({ Name = "Rainbow Distance", CurrentValue = false, Flag = "esp_rb_dist", Callback = function(v) Config.ESP.RainbowDist = v end })
VisualTab:CreateColorPicker({ Name = "Tracer Color", Color = Config.ESP.TracerColor, Flag = "esp_tracer_col", Callback = function(c) Config.ESP.TracerColor = c end })
VisualTab:CreateSlider({ Name = "Rainbow Speed", Range = { 0.1, 5 }, Increment = 0.1, CurrentValue = 1, Flag = "esp_rb_speed", Callback = function(v) Config.ESP.RainbowSpeed = v end })
VisualTab:CreateSlider({ Name = "Line Thickness", Range = { 1, 5 }, Increment = 1, CurrentValue = 1, Flag = "esp_thick", Callback = function(v) Config.ESP.Thickness = v end })

local SettingsTab = Window:CreateTab("Settings")
SettingsTab:CreateSection("Crosshair")
SettingsTab:CreateToggle({ Name = "Enable Crosshair", CurrentValue = false, Flag = "ch_on", Callback = function(v) Config.Crosshair.Enabled = v end })
SettingsTab:CreateColorPicker({ Name = "Crosshair Color", Color = Config.Crosshair.Color, Flag = "ch_color", Callback = function(c) Config.Crosshair.Color = c end })
SettingsTab:CreateSlider({ Name = "Size", Range = { 2, 20 }, Increment = 1, CurrentValue = 10, Flag = "ch_size", Callback = function(v) Config.Crosshair.Size = v end })
SettingsTab:CreateSlider({ Name = "Gap", Range = { 0, 15 }, Increment = 1, CurrentValue = 4, Flag = "ch_gap", Callback = function(v) Config.Crosshair.Gap = v end })
SettingsTab:CreateSlider({ Name = "Thickness", Range = { 1, 4 }, Increment = 1, CurrentValue = 2, Flag = "ch_thick", Callback = function(v) Config.Crosshair.Thickness = v end })

local RadarTab = Window:CreateTab("FOV")
RadarTab:CreateSection("FOV Circle")
RadarTab:CreateToggle({ Name = "Rainbow FOV", CurrentValue = false, Flag = "fov_rainbow", Callback = function(v) Config.FOV.Rainbow = v end })
RadarTab:CreateColorPicker({ Name = "FOV Color", Color = Config.FOV.Color, Flag = "fov_col", Callback = function(c) Config.FOV.Color = c end })

local UtilTab = Window:CreateTab("Utilities")
UtilTab:CreateSection("Movement")
UtilTab:CreateToggle({ Name = "Speed Hack (Physics)", CurrentValue = false, Flag = "util_speed_on", Callback = function(v) Config.Utility.SpeedEnabled = v end })
UtilTab:CreateSlider({ Name = "Speed Value", Range = { 16, 150 }, Increment = 1, CurrentValue = 60, Flag = "util_speed_val", Callback = function(v) Config.Utility.SpeedValue = v end })
