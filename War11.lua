-- language: Lua (Luau), target: Voxel Wars (Roblox), executor: Xeno
-- CREATOR SMOKExR'S | Rayfield UI | Aggressive Aimbot | ESP | FPS Counter

-- ============================================================
-- RAYFIELD LOAD
-- ============================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- FPS COUNTER + CUSTOM SPLASH
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

-- FPS counter logic
local fps_frames = 0
local fps_last = tick()
local fps_value = 0

RunService.RenderStepped:Connect(function()
    fps_frames = fps_frames + 1
    local now = tick()
    if now - fps_last >= 1 then
        fps_value = fps_frames
        fps_frames = 0
        fps_last = now
    end
    SplashFPS.Text = string.format("FPS: %d", fps_value)
end)

-- fade out splash after 4 seconds
task.spawn(function()
    task.wait(4)
    local tween = game:GetService("TweenService"):Create(
        SplashFrame,
        TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { BackgroundTransparency = 1 }
    )
    tween:Play()
    for _, child in ipairs(SplashFrame:GetDescendants()) do
        if child:IsA("TextLabel") then
            child.TextTransparency = 1
        end
    end
    SplashGlow.Transparency = 1
    tween.Completed:Connect(function()
        SplashGui:Destroy()
    end)
end)

-- ============================================================
-- RAYFIELD WINDOW
-- ============================================================
local Window = Rayfield:CreateWindow({
    Name = "CREATOR SMOKExR'S | Voxel Wars",
    LoadingTitle = "CREATOR SMOKExR'S",
    LoadingSubtitle = "Aggressive Hub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SmokeHub",
        FileName = "VoxelWars",
    },
    KeySystem = false,
})

-- ============================================================
-- STATE
-- ============================================================
local Config = {
    Aimbot = {
        Enabled = true,
        Key = Enum.KeyCode.Q,
        FOV = 150,
        Smoothness = 0.25,
        WallCheck = true,
        TeamCheck = true,
        Part = "Head",
    },
    ESP = {
        Enabled = true,
        Box = true,
        Name = true,
        Distance = true,
        Tracer = true,
        MaxDistance = 800,
        Color = Color3.fromRGB(0, 255, 120),
    },
}

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

local function world_to_screen(pos)
    local screen, on_screen = Camera:WorldToViewportPoint(pos)
    if on_screen and screen.Z > 0 then return Vector2.new(screen.X, screen.Y) end
    return nil
end

local function wall_check(part)
    if not Config.Aimbot.WallCheck then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, part.Parent}
    local origin = Camera.CFrame.Position
    local result = Workspace:Raycast(origin, part.Position - origin, params)
    return result == nil
end

local function team_check(plr)
    if not Config.Aimbot.TeamCheck then return true end
    return plr.Team ~= LocalPlayer.Team
end

-- ============================================================
-- AGGRESSIVE AIMBOT
-- ============================================================
local function get_closest_target()
    local char, hum, hrp = get_character()
    if not char then return nil end
    local best, best_dist = nil, Config.Aimbot.FOV
    local center = Camera.ViewportSize / 2
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not is_alive(plr) or not team_check(plr) then continue end
        local part = plr.Character:FindFirstChild(Config.Aimbot.Part) or plr.Character:FindFirstChild("HumanoidRootPart")
        if not part then continue end
        local screen = world_to_screen(part.Position)
        if not screen then continue end
        local dist = (screen - center).Magnitude
        if dist < best_dist and wall_check(part) then
            best, best_dist = part, dist
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if not Config.Aimbot.Enabled then return end
    if not UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
    local target = get_closest_target()
    if target then
        local target_cf = CFrame.new(Camera.CFrame.Position, target.Position)
        Camera.CFrame = Camera.CFrame:Lerp(target_cf, Config.Aimbot.Smoothness)
    end
end)

-- ============================================================
-- ESP (Drawing)
-- ============================================================
local esp_cache = {}

local function create_esp(plr)
    if plr == LocalPlayer then return end
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Transparency = 1
    box.Color = Config.ESP.Color
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 14
    name.Center = true
    name.Outline = true
    name.Color = Color3.fromRGB(255, 255, 255)
    name.Visible = false

    local dist = Drawing.new("Text")
    dist.Size = 12
    dist.Center = true
    dist.Outline = true
    dist.Color = Color3.fromRGB(200, 200, 200)
    dist.Visible = false

    local tracer = Drawing.new("Line")
    tracer.Thickness = 1
    tracer.Transparency = 1
    tracer.Color = Config.ESP.Color
    tracer.Visible = false

    esp_cache[plr] = { box = box, name = name, dist = dist, tracer = tracer }
end

for _, plr in ipairs(Players:GetPlayers()) do create_esp(plr) end
Players.PlayerAdded:Connect(create_esp)
Players.PlayerRemoving:Connect(function(plr)
    local e = esp_cache[plr]
    if e then for _, v in pairs(e) do v:Remove() end esp_cache[plr] = nil end
end)

RunService.RenderStepped:Connect(function()
    for plr, e in pairs(esp_cache) do
        if not Config.ESP.Enabled or not is_alive(plr) then
            for _, v in pairs(e) do v.Visible = false end
            continue
        end
        local char = plr.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        if not hrp or not hum or not head then continue end
        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
        if distance > Config.ESP.MaxDistance then
            for _, v in pairs(e) do v.Visible = false end
            continue
        end
        local head_screen = world_to_screen(head.Position + Vector3.new(0, 0.5, 0))
        local foot_screen = world_to_screen(hrp.Position - Vector3.new(0, 3, 0))
        if not head_screen or not foot_screen then
            for _, v in pairs(e) do v.Visible = false end
            continue
        end
        local height = math.abs(head_screen.Y - foot_screen.Y)
        local width = height * 0.5
        local x = head_screen.X - width / 2
        local y = head_screen.Y
        e.box.Size = Vector2.new(width, height)
        e.box.Position = Vector2.new(x, y)
        e.box.Visible = Config.ESP.Box
        e.name.Text = plr.Name
        e.name.Position = Vector2.new(head_screen.X, y - 16)
        e.name.Visible = Config.ESP.Name
        e.dist.Text = string.format("%dm", math.floor(distance))
        e.dist.Position = Vector2.new(head_screen.X, y + height + 2)
        e.dist.Visible = Config.ESP.Distance
        e.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        e.tracer.To = Vector2.new(head_screen.X, y + height)
        e.tracer.Visible = Config.ESP.Tracer
    end
end)

-- ============================================================
-- RAYFIELD UI TABS
-- ============================================================
local CombatTab = Window:CreateTab("Combat", 4483362458)
local VisualTab = Window:CreateTab("Visual", 4483362458)

-- Combat section
CombatTab:CreateSection("Aimbot")

CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = Config.Aimbot.Enabled,
    Flag = "aimbot_enabled",
    Callback = function(v) Config.Aimbot.Enabled = v end,
})

CombatTab:CreateSlider({
    Name = "FOV",
    Range = { 10, 360 },
    Increment = 10,
    Suffix = "°",
    CurrentValue = Config.Aimbot.FOV,
    Flag = "aimbot_fov",
    Callback = function(v) Config.Aimbot.FOV = v end,
})

CombatTab:CreateSlider({
    Name = "Smoothness",
    Range = { 0.05, 1 },
    Increment = 0.05,
    Suffix = "",
    CurrentValue = Config.Aimbot.Smoothness,
    Flag = "aimbot_smooth",
    Callback = function(v) Config.Aimbot.Smoothness = v end,
})

CombatTab:CreateToggle({
    Name = "Wall Check",
    CurrentValue = Config.Aimbot.WallCheck,
    Flag = "aimbot_wall",
    Callback = function(v) Config.Aimbot.WallCheck = v end,
})

CombatTab:CreateToggle({
    Name = "Team Check",
    CurrentValue = Config.Aimbot.TeamCheck,
    Flag = "aimbot_team",
    Callback = function(v) Config.Aimbot.TeamCheck = v end,
})

-- Visual section
VisualTab:CreateSection("ESP")

VisualTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = Config.ESP.Enabled,
    Flag = "esp_enabled",
    Callback = function(v) Config.ESP.Enabled = v end,
})

VisualTab:CreateToggle({
    Name = "Box",
    CurrentValue = Config.ESP.Box,
    Flag = "esp_box",
    Callback = function(v) Config.ESP.Box = v end,
})

VisualTab:CreateToggle({
    Name = "Name",
    CurrentValue = Config.ESP.Name,
    Flag = "esp_name",
    Callback = function(v) Config.ESP.Name = v end,
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

VisualTab:CreateSlider({
    Name = "Max Distance",
    Range = { 100, 2000 },
    Increment = 100,
    Suffix = " studs",
    CurrentValue = Config.ESP.MaxDistance,
    Flag = "esp_maxdist",
    Callback = function(v) Config.ESP.MaxDistance = v end,
})

-- Notify on load
Rayfield:Notify({
    Title = "CREATOR SMOKExR'S",
    Content = "Voxel Wars Hub loaded. Hold RMB for aimbot.",
    Duration = 6,
    Image = 4483362458,
})

print("[SmokeHub] Loaded. FPS counter active. Press Q to toggle aimbot keybind if needed.")
