-- language: Lua (Luau), file: smokexr_voxel_radar.lua, target: Voxel Wars, executor: Xeno
-- CREATOR SMOKExR'S | Top Radar | Hard Aimbot | Custom ESP

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- CONFIG
-- ============================================================
local Config = {
    Aimbot = {
        Enabled = true,
        Key = Enum.KeyCode.Q,
        FOV = 150,
        Smoothness = 0.05, -- Жёсткий лок
        WallCheck = true,
        TeamCheck = true,
        Part = "Head",
        NoRecoil = true,
        Prediction = 0.15, -- Предсказание движения цели
    },
    ESP = {
        Enabled = true,
        Box = true,
        Name = true,
        Distance = true,
        Tracer = true,
        MaxDistance = 1000,
        TeamCheck = true,
        BoxColor = Color3.fromRGB(255, 50, 50),
        NameColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 50, 50),
        Thickness = 1,
        BoxStyle = "Квадрат",
    },
    Radar = {
        Enabled = true,
        Radius = 80,
        Size = 150,
        Color = Color3.fromRGB(255, 50, 50),
        Position = UDim2.new(0.5, -75, 0, 50), -- Сверху по центру
    }
}

-- ============================================================
-- FPS COUNTER & SPLASH
-- ============================================================
local SplashGui = Instance.new("ScreenGui")
SplashGui.Name = "SmokeSplash"
SplashGui.ResetOnSpawn = false
SplashGui.Parent = game.CoreGui

local SplashFrame = Instance.new("Frame")
SplashFrame.Size = UDim2.new(0, 500, 0, 180)
SplashFrame.Position = UDim2.new(0.5, -250, 0.5, -90)
SplashFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
SplashFrame.BorderSizePixel = 0
SplashFrame.Parent = SplashGui
Instance.new("UICorner", SplashFrame).CornerRadius = UDim.new(0, 12)
local SplashGlow = Instance.new("UIStroke")
SplashGlow.Color = Color3.fromRGB(200, 100, 255)
SplashGlow.Thickness = 2
SplashGlow.Transparency = 0.3
SplashGlow.Parent = SplashFrame

local SplashTitle = Instance.new("TextLabel")
SplashTitle.Size = UDim2.new(1, 0, 0, 60)
SplashTitle.Position = UDim2.new(0, 0, 0, 20)
SplashTitle.BackgroundTransparency = 1
SplashTitle.Text = "CREATOR SMOKExR'S"
SplashTitle.TextColor3 = Color3.fromRGB(200, 100, 255)
SplashTitle.Font = Enum.Font.GothamBlack
SplashTitle.TextSize = 28
SplashTitle.Parent = SplashFrame

local SplashSub = Instance.new("TextLabel")
SplashSub.Size = UDim2.new(1, 0, 0, 30)
SplashSub.Position = UDim2.new(0, 0, 0, 75)
SplashSub.BackgroundTransparency = 1
SplashSub.Text = "Voxel Wars | Aggressive Hub"
SplashSub.TextColor3 = Color3.fromRGB(180, 180, 180)
SplashSub.Font = Enum.Font.Gotham
SplashSub.TextSize = 14
SplashSub.Parent = SplashFrame

local SplashFPS = Instance.new("TextLabel")
SplashFPS.Size = UDim2.new(1, 0, 0, 25)
SplashFPS.Position = UDim2.new(0, 0, 0, 115)
SplashFPS.BackgroundTransparency = 1
SplashFPS.Text = "FPS: 0"
SplashFPS.TextColor3 = Color3.fromRGB(0, 255, 120)
SplashFPS.Font = Enum.Font.GothamBold
SplashFPS.TextSize = 14
SplashFPS.Parent = SplashFrame

local fps_frames, fps_last, fps_value = 0, tick(), 0
RunService.RenderStepped:Connect(function()
    fps_frames = fps_frames + 1
    if tick() - fps_last >= 1 then
        fps_value = fps_frames
        fps_frames = 0
        fps_last = tick()
        SplashFPS.Text = string.format("FPS: %d", fps_value)
    end
end)

task.spawn(function()
    task.wait(4)
    TweenService:Create(SplashFrame, TweenInfo.new(0.6), { BackgroundTransparency = 1 }):Play()
    for _, c in ipairs(SplashFrame:GetDescendants()) do
        if c:IsA("TextLabel") then TweenService:Create(c, TweenInfo.new(0.6), { TextTransparency = 1 }):Play() end
    end
    TweenService:Create(SplashGlow, TweenInfo.new(0.6), { Transparency = 1 }):Play()
    task.wait(0.7)
    SplashGui:Destroy()
end)

-- ============================================================
-- INFO PANEL (СВОЯ ФИШКА)
-- ============================================================
local InfoGui = Instance.new("ScreenGui")
InfoGui.Name = "SmokeInfo"
InfoGui.ResetOnSpawn = false
InfoGui.Parent = game.CoreGui

local InfoFrame = Instance.new("Frame")
InfoFrame.Size = UDim2.new(0, 200, 0, 60)
InfoFrame.Position = UDim2.new(1, -220, 0, 20)
InfoFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
InfoFrame.BackgroundTransparency = 0.3
InfoFrame.BorderSizePixel = 0
InfoFrame.Parent = InfoGui
Instance.new("UICorner", InfoFrame).CornerRadius = UDim.new(0, 8)

local InfoName = Instance.new("TextLabel")
InfoName.Size = UDim2.new(1, 0, 0, 25)
InfoName.Position = UDim2.new(0, 0, 0, 5)
InfoName.BackgroundTransparency = 1
InfoName.Text = "SMOKExR'S | " .. LocalPlayer.Name
InfoName.TextColor3 = Color3.fromRGB(200, 100, 255)
InfoName.Font = Enum.Font.GothamBold
InfoName.TextSize = 12
InfoName.Parent = InfoFrame

local InfoFPS = Instance.new("TextLabel")
InfoFPS.Size = UDim2.new(1, 0, 0, 20)
InfoFPS.Position = UDim2.new(0, 0, 0, 30)
InfoFPS.BackgroundTransparency = 1
InfoFPS.Text = "FPS: 0 | Alive: 0"
InfoFPS.TextColor3 = Color3.fromRGB(0, 255, 120)
InfoFPS.Font = Enum.Font.Gotham
InfoFPS.TextSize = 11
InfoFPS.Parent = InfoFrame

RunService.RenderStepped:Connect(function()
    local alive = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
            alive = alive + 1
        end
    end
    InfoFPS.Text = string.format("FPS: %d | Alive: %d", fps_value, alive)
end)

-- ============================================================
-- HELPERS
-- ============================================================
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
    if not Config.ESP.TeamCheck then return false end
    if plr == LocalPlayer then return true end
    if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team then return true end
    -- Color check
    local char = plr.Character
    local my_char = LocalPlayer.Character
    if char and my_char then
        local head = char:FindFirstChild("Head")
        local my_head = my_char:FindFirstChild("Head")
        if head and my_head and head.Color == my_head.Color then return true end
    end
    return false
end

local function world_to_screen(pos)
    local screen, on_screen = Camera:WorldToViewportPoint(pos)
    if on_screen and screen.Z > 0 then return Vector2.new(screen.X, screen.Y) end
    return nil
end

-- ============================================================
-- RADAR OVER FOV (Круговой радар над FOV)
-- ============================================================
local radar_gui = Instance.new("ScreenGui")
radar_gui.Name = "SmokeRadar"
radar_gui.ResetOnSpawn = false
radar_gui.Parent = game.CoreGui

local radar_frame = Instance.new("Frame")
radar_frame.Size = UDim2.new(0, Config.Radar.Size, 0, Config.Radar.Size)
radar_frame.Position = Config.Radar.Position
radar_frame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
radar_frame.BackgroundTransparency = 0.5
radar_frame.BorderSizePixel = 0
radar_frame.Parent = radar_gui

local radar_corner = Instance.new("UICorner")
radar_corner.CornerRadius = UDim.new(1, 0)
radar_corner.Parent = radar_frame

local radar_stroke = Instance.new("UIStroke")
radar_stroke.Color = Color3.fromRGB(200, 100, 255)
radar_stroke.Thickness = 2
radar_stroke.Transparency = 0.3
radar_stroke.Parent = radar_frame

local radar_arrows = {}

RunService.RenderStepped:Connect(function()
    for _, a in ipairs(radar_arrows) do a:Destroy() end
    radar_arrows = {}
    if not Config.Radar.Enabled then
        radar_frame.Visible = false
        return
    end
    radar_frame.Visible = true
    radar_frame.Size = UDim2.new(0, Config.Radar.Size, 0, Config.Radar.Size)

    local my_char, my_hum, my_hrp = get_character()
    if not my_char then return end
    
    local center = Vector2.new(Config.Radar.Size / 2, Config.Radar.Size / 2)
    local radius = Config.Radar.Size / 2 - 10
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) or is_teammate(plr) then continue end
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end
        
        local dist = (hrp.Position - my_hrp.Position).Magnitude
        if dist > Config.ESP.MaxDistance then continue end
        
        -- Calculate relative angle
        local relative_pos = Camera.CFrame:PointToObjectSpace(hrp.Position)
        local angle = math.atan2(relative_pos.X, relative_pos.Z)
        
        -- Map to radar
        local r_dist = math.min(dist / Config.ESP.MaxDistance * radius, radius)
        local rx = center.X + math.sin(angle) * r_dist
        local ry = center.Y - math.cos(angle) * r_dist
        
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(0, rx - 3, 0, ry - 3)
        dot.BackgroundColor3 = Config.Radar.Color
        dot.BorderSizePixel = 0
        dot.Parent = radar_frame
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        
        table.insert(radar_arrows, dot)
    end
end)

-- ============================================================
-- CUSTOM ESP (Custom Colors & Thickness)
-- ============================================================
local esp_cache = {}

local function create_esp(plr)
    if plr == LocalPlayer then return end
    
    local box = Drawing.new("Square")
    box.Thickness = Config.ESP.Thickness
    box.Filled = false
    box.Transparency = 1
    box.Color = Config.ESP.BoxColor
    box.Visible = false
    
    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Color = Config.ESP.NameColor
    name.Visible = false
    
    local dist = Drawing.new("Text")
    dist.Size = 12
    dist.Center = true
    dist.Outline = true
    dist.Color = Color3.fromRGB(200, 200, 200)
    dist.Visible = false
    
    local tracer = Drawing.new("Line")
    tracer.Thickness = Config.ESP.Thickness
    tracer.Transparency = 1
    tracer.Color = Config.ESP.TracerColor
    tracer.Visible = false

    esp_cache[plr] = { box = box, name = name, dist = dist, tracer = tracer }
end

for _, plr in ipairs(Players:GetPlayers()) do create_esp(plr) end
Players.PlayerAdded:Connect(create_esp)
Players.PlayerRemoving:Connect(function(plr)
    local e = esp_cache[plr]
    if e then
        for _, v in pairs(e) do v:Remove() end
        esp_cache[plr] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    for plr, e in pairs(esp_cache) do
        if not Config.ESP.Enabled or not is_alive(plr) or (Config.ESP.TeamCheck and is_teammate(plr)) then
            e.box.Visible = false
            e.name.Visible = false
            e.dist.Visible = false
            e.tracer.Visible = false
            continue
        end
        
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local head = char and char:FindFirstChild("Head")
        if not hrp or not head then
            e.box.Visible = false
            e.name.Visible = false
            e.dist.Visible = false
            e.tracer.Visible = false
            continue
        end
        
        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
        if distance > Config.ESP.MaxDistance then
            e.box.Visible = false
            e.name.Visible = false
            e.dist.Visible = false
            e.tracer.Visible = false
            continue
        end
        
        local head_screen = world_to_screen(head.Position + Vector3.new(0, 0.5, 0))
        local foot_screen = world_to_screen(hrp.Position - Vector3.new(0, 3, 0))
        if not head_screen or not foot_screen then
            e.box.Visible = false
            e.name.Visible = false
            e.dist.Visible = false
            e.tracer.Visible = false
            continue
        end
        
        local height = math.abs(head_screen.Y - foot_screen.Y)
        local width = height * 0.5
        local x = head_screen.X - width / 2
        local y = head_screen.Y
        
        -- Update Box
        e.box.Visible = Config.ESP.Box
        e.box.Size = Vector2.new(width, height)
        e.box.Position = Vector2.new(x, y)
        e.box.Color = Config.ESP.BoxColor
        e.box.Thickness = Config.ESP.Thickness
        
        -- Update Name
        e.name.Text = plr.Name
        e.name.Position = Vector2.new(head_screen.X, y - 16)
        e.name.Visible = Config.ESP.Name
        e.name.Color = Config.ESP.NameColor
        
        -- Update Distance
        e.dist.Text = string.format("%dm", math.floor(distance))
        e.dist.Position = Vector2.new(head_screen.X, y + height + 2)
        e.dist.Visible = Config.ESP.Distance
        
        -- Update Tracer
        e.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        e.tracer.To = Vector2.new(head_screen.X, y + height)
        e.tracer.Visible = Config.ESP.Tracer
        e.tracer.Color = Config.ESP.TracerColor
        e.tracer.Thickness = Config.ESP.Thickness
    end
end)

-- ============================================================
-- HARD AGGRESSIVE AIMBOT (No Recoil, Prediction)
-- ============================================================
local last_cam_cf = Camera.CFrame

local function get_aim_target()
    local char, hum, hrp = get_character()
    if not char then return nil end
    
    local best, best_dist = nil, Config.Aimbot.FOV
    local center = Camera.ViewportSize / 2
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) then continue end
        if Config.Aimbot.TeamCheck and is_teammate(plr) then continue end
        
        local part = plr.Character:FindFirstChild(Config.Aimbot.Part) or plr.Character:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        
        -- Wall check
        if Config.Aimbot.WallCheck then
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
            local result = Workspace:Raycast(Camera.CFrame.Position, part.Position - Camera.CFrame.Position, params)
            if result then continue end
        end
        
        local screen = world_to_screen(part.Position)
        if not screen then continue end
        local dist = (screen - center).Magnitude
        
        if dist < best_dist then
            best = part
            best_dist = dist
        end
    end
    
    return best
end

RunService.RenderStepped:Connect(function()
    if not Config.Aimbot.Enabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    
    local target = get_aim_target()
    if target then
        -- Prediction logic
        local velocity = target.AssemblyLinearVelocity or Vector3.zero
        local predicted_pos = target.Position + velocity * Config.Aimbot.Prediction
        
        local target_cf = CFrame.new(Camera.CFrame.Position, predicted_pos)
        
        -- No Recoil compensation
        if Config.Aimbot.NoRecoil then
            -- In some games, recoil is added as a rotation offset.
            -- We smooth the camera aggressively to keep it locked.
            target_cf = target_cf * CFrame.Angles(math.rad(-1), 0, 0) -- slight downward bias to counter kick
        end
        
        Camera.CFrame = Camera.CFrame:Lerp(target_cf, Config.Aimbot.Smoothness)
    end
end)

-- ============================================================
-- RAYFIELD UI
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S | Voxel Wars",
    LoadingTitle = "CREATOR SMOKExR'S",
    LoadingSubtitle = "Aggressive Hub",
    ConfigurationSaving = { Enabled = true, FolderName = "SmokeHub", FileName = "VoxelWars" },
    KeySystem = false,
})

local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)
local RadarTab = Window:CreateTab("Radar", 4483362458)

-- Combat Tab
CombatTab:CreateSection("Aimbot")

CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = Config.Aimbot.Enabled,
    Flag = "aimbot_enabled",
    Callback = function(v) Config.Aimbot.Enabled = v end,
})

CombatTab:CreateSlider({
    Name = "FOV",
    Range = { 10, 500 }, Increment = 10, Suffix = "°",
    CurrentValue = Config.Aimbot.FOV,
    Flag = "aimbot_fov",
    Callback = function(v) Config.Aimbot.FOV = v end,
})

CombatTab:CreateSlider({
    Name = "Smoothness (Lower = Faster)",
    Range = { 0.01, 1 }, Increment = 0.01, Suffix = "",
    CurrentValue = Config.Aimbot.Smoothness,
    Flag = "aimbot_smooth",
    Callback = function(v) Config.Aimbot.Smoothness = v end,
})

CombatTab:CreateSlider({
    Name = "Prediction (Movement)",
    Range = { 0, 0.5 }, Increment = 0.01, Suffix = "s",
    CurrentValue = Config.Aimbot.Prediction,
    Flag = "aimbot_pred",
    Callback = function(v) Config.Aimbot.Prediction = v end,
})

CombatTab:CreateToggle({
    Name = "No Recoil",
    CurrentValue = Config.Aimbot.NoRecoil,
    Flag = "aimbot_norecoil",
    Callback = function(v) Config.Aimbot.NoRecoil = v end,
})

CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = Config.Aimbot.WallCheck,
    Flag = "aimbot_wall",
    Callback = function(v) Config.Aimbot.WallCheck = v end,
})

-- Visual Tab
VisualTab:CreateSection("ESP")

VisualTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = Config.ESP.Enabled,
    Flag = "esp_enabled",
    Callback = function(v) Config.ESP.Enabled = v end,
})

VisualTab:CreateToggle({
    Name = "Ignore Teammates",
    CurrentValue = Config.ESP.TeamCheck,
    Flag = "esp_team",
    Callback = function(v) Config.ESP.TeamCheck = v end,
})

VisualTab:CreateToggle({
    Name = "Box",
    CurrentValue = Config.ESP.Box,
    Flag = "esp_box",
    Callback = function(v) Config.ESP.Box = v end,
})

VisualTab:CreateColorPicker({
    Name = "Box Color",
    Color = Config.ESP.BoxColor,
    Flag = "esp_box_color",
    Callback = function(color) Config.ESP.BoxColor = color end,
})

VisualTab:CreateToggle({
    Name = "Name",
    CurrentValue = Config.ESP.Name,
    Flag = "esp_name",
    Callback = function(v) Config.ESP.Name = v end,
})

VisualTab:CreateColorPicker({
    Name = "Name Color",
    Color = Config.ESP.NameColor,
    Flag = "esp_name_color",
    Callback = function(color) Config.ESP.NameColor = color end,
})

VisualTab:CreateToggle({
    Name = "Distance",
    CurrentValue = Config.ESP.Distance,
    Flag = "esp_dist",
    Callback = function(v) Config.ESP.Distance = v end,
})

VisualTab:CreateToggle({
    Name = "Tracer",
    CurrentValue = Config.ESP.Tracer,
    Flag = "esp_tracer",
    Callback = function(v) Config.ESP.Tracer = v end,
})

VisualTab:CreateColorPicker({
    Name = "Tracer Color",
    Color = Config.ESP.TracerColor,
    Flag = "esp_tracer_color",
    Callback = function(color) Config.ESP.TracerColor = color end,
})

VisualTab:CreateSlider({
    Name = "Thickness",
    Range = { 1, 5 }, Increment = 1, Suffix = "px",
    CurrentValue = Config.ESP.Thickness,
    Flag = "esp_thick",
    Callback = function(v) Config.ESP.Thickness = v end,
})

VisualTab:CreateSlider({
    Name = "Max Distance",
    Range = { 100, 5000 }, Increment = 100, Suffix = " studs",
    CurrentValue = Config.ESP.MaxDistance,
    Flag = "esp_maxdist",
    Callback = function(v) Config.ESP.MaxDistance = v end,
})

-- Radar Tab
RadarTab:CreateSection("Radar Over FOV")

RadarTab:CreateToggle({
    Name = "Enable Radar",
    CurrentValue = Config.Radar.Enabled,
    Flag = "radar_enabled",
    Callback = function(v) Config.Radar.Enabled = v end,
})

RadarTab:CreateSlider({
    Name = "Radar Size",
    Range = { 100, 300 }, Increment = 10, Suffix = "px",
    CurrentValue = Config.Radar.Size,
    Flag = "radar_size",
    Callback = function(v) 
        Config.Radar.Size = v 
        radar_frame.Size = UDim2.new(0, v, 0, v)
    end,
})

RadarTab:CreateColorPicker({
    Name = "Radar Color",
    Color = Config.Radar.Color,
    Flag = "radar_color",
    Callback = function(color) Config.Radar.Color = color end,
})

Rayfield:Notify({
    Title = "CREATOR SMOKExR'S",
    Content = "Voxel Wars Hub loaded. Radar over FOV active.",
    Duration = 6,
    Image = 4483362458,
})
