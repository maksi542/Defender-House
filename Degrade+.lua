
--==================================================
-- MERCURY GUI | PC + MOBILE
-- Version 1.0
-- Place: StarterPlayer > StarterPlayerScripts
--==================================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Theme = {
    Background = Color3.fromRGB(12, 13, 21),
    Panel = Color3.fromRGB(19, 21, 32),
    Card = Color3.fromRGB(26, 29, 43),
    Accent = Color3.fromRGB(126, 92, 255),
    Blue = Color3.fromRGB(65, 175, 255),
    White = Color3.fromRGB(240, 241, 250),
    Gray = Color3.fromRGB(145, 149, 169),
    Green = Color3.fromRGB(80, 220, 155)
}

local function Create(class, props, parent)
    local obj = Instance.new(class)

    for key, value in pairs(props or {}) do
        obj[key] = value
    end

    obj.Parent = parent
    return obj
end

local function Corner(parent, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, parent)
end

local function Stroke(parent, color, transparency)
    return Create("UIStroke", {
        Color = color,
        Transparency = transparency or 0,
        Thickness = 1
    }, parent)
end

local function Tween(obj, properties, duration)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out),
        properties
    )
    t:Play()
    return t
end

-- CLEAN OLD GUI

local old = PlayerGui:FindFirstChild("MERCURY")
if old then
    old:Destroy()
end

local GUI = Create("ScreenGui", {
    Name = "MERCURY",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

-- MAIN WINDOW

local Main = Create("Frame", {
    Name = "Main",
    Size = UDim2.fromScale(0.82, 0.78),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, GUI)

Corner(Main, 18)
Stroke(Main, Theme.Accent, 0.35)

Create("UISizeConstraint", {
    MinSize = Vector2.new(290, 300),
    MaxSize = Vector2.new(950, 680)
}, Main)

-- TOP BAR

local Top = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 62),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
}, Main)

local Logo = Create("TextLabel", {
    Position = UDim2.fromOffset(20, 0),
    Size = UDim2.new(0, 190, 1, 0),
    BackgroundTransparency = 1,
    Text = "MERCURY",
    TextColor3 = Theme.White,
    TextSize = 23,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Top)

local Version = Create("TextLabel", {
    Position = UDim2.new(0, 21, 0, 39),
    Size = UDim2.new(0, 150, 0, 15),
    BackgroundTransparency = 1,
    Text = "PREMIUM INTERFACE",
    TextColor3 = Theme.Accent,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Top)

local Close = Create("TextButton", {
    Size = UDim2.fromOffset(36, 36),
    Position = UDim2.new(1, -48, 0, 13),
    BackgroundColor3 = Theme.Card,
    Text = "×",
    TextColor3 = Theme.White,
    TextSize = 24,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, Top)
Corner(Close, 10)

local Minimize = Create("TextButton", {
    Size = UDim2.fromOffset(36, 36),
    Position = UDim2.new(1, -92, 0, 13),
    BackgroundColor3 = Theme.Card,
    Text = "−",
    TextColor3 = Theme.White,
    TextSize = 23,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, Top)
Corner(Minimize, 10)

-- NAVIGATION

local Sidebar = Create("Frame", {
    Position = UDim2.fromOffset(0, 62),
    Size = UDim2.new(0, 165, 1, -62),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
}, Main)

local NavLayout = Create("UIListLayout", {
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder
}, Sidebar)

Create("UIPadding", {
    PaddingTop = UDim.new(0, 18),
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12)
}, Sidebar)

-- CONTENT

local Content = Create("Frame", {
    Position = UDim2.new(0, 165, 0, 62),
    Size = UDim2.new(1, -165, 1, -62),
    BackgroundTransparency = 1
}, Main)

local Pages = {}
local Navigation = {}
local currentPage = "Home"

local function CreatePage(name)
    local Page = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, Content)

    Create("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, Page)

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 18),
        PaddingRight = UDim.new(0, 18),
        PaddingBottom = UDim.new(0, 20)
    }, Page)

    Pages[name] = Page
    return Page
end

local function ShowPage(name)
    if not Pages[name] then return end

    currentPage = name

    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name
    end

    for navName, button in pairs(Navigation) do
        Tween(button, {
            BackgroundColor3 = navName == name
                and Theme.Accent
                or Theme.Card
        })
    end
end

local function AddNavigation(name, icon)
    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 43),
        BackgroundColor3 = Theme.Card,
        Text = icon .. "   " .. name,
        TextColor3 = Theme.White,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false
    }, Sidebar)

    Corner(Button, 10)

    Button.MouseButton1Click:Connect(function()
        ShowPage(name)
    end)

    Navigation[name] = Button
end

-- COMPONENTS

local function AddTitle(page, text)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.White,
        TextSize = 21,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, page)
end

local function AddDescription(page, text)
    return Create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.Gray,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    }, page)
end

local function AddButton(page, title, callback)
    local Button = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = Theme.Card,
        Text = title,
        TextColor3 = Theme.White,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        AutoButtonColor = false
    }, page)

    Corner(Button, 10)
    Stroke(Button, Theme.Accent, 0.8)

    Button.MouseEnter:Connect(function()
        Tween(Button, {BackgroundColor3 = Theme.Accent})
    end)

    Button.MouseLeave:Connect(function()
        Tween(Button, {BackgroundColor3 = Theme.Card})
    end)

    Button.Activated:Connect(function()
        if callback then callback() end
    end)

    return Button
end

local function AddToggle(page, title, callback)
    local Enabled = false

    local Holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0
    }, page)
    Corner(Holder, 10)

    Create("TextLabel", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -80, 1, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.White,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Holder)

    local Toggle = Create("TextButton", {
        Size = UDim2.fromOffset(42, 24),
        Position = UDim2.new(1, -55, 0.5, -12),
        BackgroundColor3 = Theme.Gray,
        Text = "",
        AutoButtonColor = false
    }, Holder)
    Corner(Toggle, 20)

    local Circle = Create("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0
    }, Toggle)
    Corner(Circle, 20)

    Toggle.Activated:Connect(function()
        Enabled = not Enabled

        Tween(Toggle, {
            BackgroundColor3 = Enabled
                and Theme.Accent
                or Theme.Gray
        })

        Tween(Circle, {
            Position = Enabled
                and UDim2.new(1, -21, 0, 3)
                or UDim2.fromOffset(3, 3)
        })

        if callback then
            callback(Enabled)
        end
    end)

    return Holder
end

local function AddSlider(page, title, callback)
    local Value = 50

    local Holder = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0
    }, page)
    Corner(Holder, 10)

    local Label = Create("TextLabel", {
        Position = UDim2.fromOffset(13, 7),
        Size = UDim2.new(1, -26, 0, 24),
        BackgroundTransparency = 1,
        Text = title .. "  " .. Value .. "%",
        TextColor3 = Theme.White,
        TextSize = 12,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, Holder)

    local Bar = Create("Frame", {
        Position = UDim2.new(0, 13, 0, 43),
        Size = UDim2.new(1, -26, 0, 7),
        BackgroundColor3 = Theme.Background,
        BorderSizePixel = 0
    }, Holder)
    Corner(Bar, 10)

    local Fill = Create("Frame", {
        Size = UDim2.fromScale(0.5, 1),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0
    }, Bar)
    Corner(Fill, 10)

    local dragging = false

    local function Update(input)
        local percent = math.clamp(
            (input.Position.X - Bar.AbsolutePosition.X)
            / Bar.AbsoluteSize.X, 0, 1
        )

        Value = math.floor(percent * 100)
        Fill.Size = UDim2.fromScale(percent, 1)
        Label.Text = title .. "  " .. Value .. "%"

        if callback then callback(Value) end
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(input)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
        ) then
            Update(input)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

-- CREATE PAGES

local Home = CreatePage("Home")
local Visual = CreatePage("Visual")
local Settings = CreatePage("Settings")
local About = CreatePage("About")

AddNavigation("Home", "◆")
AddNavigation("Visual", "◈")
AddNavigation("Settings", "⚙")
AddNavigation("About", "ⓘ")

-- HOME

AddTitle(Home, "Dashboard")
AddDescription(Home, "Welcome to MERCURY interface.")

AddButton(Home, "SYSTEM STATUS  •  ONLINE", function()
    print("MERCURY: System online")
end)

AddToggle(Home, "Interface effects", function(value)
    print("Effects:", value)
end)

AddToggle(Home, "Notifications", function(value)
    print("Notifications:", value)
end)

AddTitle(Home, "Quick controls")
AddButton(Home, "Reset interface settings", function()
    print("Settings reset requested")
end)

-- VISUAL

AddTitle(Visual, "Visual settings")
AddDescription(Visual, "Customize your interface.")

AddToggle(Visual, "Show interface animations", function(value)
    print("Animations:", value)
end)

AddToggle(Visual, "Compact mode", function(value)
    print("Compact mode:", value)
end)

AddSlider(Visual, "UI Scale", function(value)
    print("UI Scale:", value)
end)

AddSlider(Visual, "Animation speed", function(value)
    print("Animation speed:", value)
end)

-- SETTINGS

AddTitle(Settings, "Settings")
AddDescription(Settings, "Personalize your experience.")

AddToggle(Settings, "Sound effects", function(value)
    print("Sound:", value)
end)

AddToggle(Settings, "Dark theme", function(value)
    print("Dark theme:", value)
end)

AddButton(Settings, "Close menu", function()
    Main.Visible = false
end)

-- ABOUT

AddTitle(About, "About MERCURY")
AddDescription(About, "A modern cross-platform interface.")
AddButton(About, "MERCURY  •  VERSION 1.0", function()
    print("MERCURY v1.0")
end)

ShowPage("Home")

-- RESPONSIVE LAYOUT

local function UpdateLayout()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local viewport = camera.ViewportSize
    local mobile = viewport.X < 650

    if mobile then
        Main.Size = UDim2.fromScale(0.94, 0.82)

        Sidebar.Position = UDim2.new(0, 0, 1, -58)
        Sidebar.Size = UDim2.new(1, 0, 0, 58)

        Content.Position = UDim2.fromOffset(0, 62)
        Content.Size = UDim2.new(1, 0, 1, -120)

        NavLayout.FillDirection = Enum.FillDirection.Horizontal
        NavLayout.Padding = UDim.new(0, 5)

        for _, button in pairs(Navigation) do
            button.Size = UDim2.new(0.25, -4, 0, 40)
            button.TextSize = 10
        end

        Version.Visible = false
        Logo.TextSize = 20
    else
        Main.Size = UDim2.fromScale(0.82, 0.78)

        Sidebar.Position = UDim2.fromOffset(0, 62)
        Sidebar.Size = UDim2.new(0, 165, 1, -62)

        Content.Position = UDim2.fromOffset(165, 62)
        Content.Size = UDim2.new(1, -165, 1, -62)

        NavLayout.FillDirection = Enum.FillDirection.Vertical
        NavLayout.Padding = UDim.new(0, 9)

        for _, button in pairs(Navigation) do
            button.Size = UDim2.new(1, 0, 0, 43)
            button.TextSize = 13
        end

        Version.Visible = true
        Logo.TextSize = 23
    end
end

UpdateLayout()

workspace.CurrentCamera:GetPropertyChangedSignal(
    "ViewportSize"
):Connect(UpdateLayout)

-- DRAG WINDOW: MOUSE + TOUCH

local dragging = false
local dragStart
local startPosition

Top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart

        Main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- FLOATING ICON

local Floating = Create("TextButton", {
    Name = "FloatingIcon",
    Size = UDim2.fromOffset(54, 54),
    Position = UDim2.new(1, -75, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundColor3 = Theme.Panel,
    Text = "M",
    TextColor3 = Theme.White,
    TextSize = 24,
    Font = Enum.Font.GothamBold,
    Visible = false,
    AutoButtonColor = false
}, GUI)

Corner(Floating, 17)
Stroke(Floating, Theme.Accent, 0.1)

Floating.Activated:Connect(function()
    Main.Visible = true
    Floating.Visible = false

    Main.Size = UDim2.fromScale(0.75, 0.7)
    UpdateLayout()
end)

Minimize.Activated:Connect(function()
    Main.Visible = false
    Floating.Visible = true
end)

Close.Activated:Connect(function()
    Tween(Main, {
        Size = UDim2.fromScale(0, 0),
        BackgroundTransparency = 1
    }, 0.2)

    task.wait(0.2)
    GUI:Destroy()
end)

print("MERCURY GUI successfully loaded")
