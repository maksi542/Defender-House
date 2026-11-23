
--// MERCURY ULTRA
--// Roblox Studio | LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(10, 10, 18),
    Sidebar = Color3.fromRGB(15, 14, 25),
    Card = Color3.fromRGB(24, 22, 38),
    Purple = Color3.fromRGB(151, 86, 255),
    Light = Color3.fromRGB(198, 155, 255),
    White = Color3.fromRGB(245, 242, 255),
    Gray = Color3.fromRGB(135, 130, 155),
    Green = Color3.fromRGB(100, 230, 170)
}

local function Create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function Round(obj, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function Animate(obj, props, duration)
    TweenService:Create(
        obj,
        TweenInfo.new(duration or 0.25,
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out),
        props
    ):Play()
end

-- GUI
local Gui = Create("ScreenGui", {
    Name = "MercuryUltra",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, Player:WaitForChild("PlayerGui"))

-- MAIN WINDOW
local Main = Create("Frame", {
    Size = UDim2.fromOffset(600, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, Gui)

Round(Main, 16)

Create("UIStroke", {
    Color = Theme.Purple,
    Transparency = 0.25,
    Thickness = 1.5
}, Main)

Create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,
            Color3.fromRGB(28, 18, 48)),
        ColorSequenceKeypoint.new(1,
            Theme.Background)
    }),
    Rotation = 35
}, Main)

-- HEADER
local Header = Create("Frame", {
    Size = UDim2.new(1, 0, 0, 65),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0
}, Main)

local Logo = Create("TextLabel", {
    Size = UDim2.fromOffset(42, 42),
    Position = UDim2.fromOffset(17, 11),
    BackgroundColor3 = Theme.Purple,
    Text = "M",
    TextColor3 = Theme.White,
    TextSize = 26,
    Font = Enum.Font.GothamBlack
}, Header)

Round(Logo, 11)

Create("TextLabel", {
    Position = UDim2.fromOffset(72, 10),
    Size = UDim2.fromOffset(200, 28),
    BackgroundTransparency = 1,
    Text = "MERCURY",
    TextColor3 = Theme.White,
    TextSize = 22,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

Create("TextLabel", {
    Position = UDim2.fromOffset(73, 37),
    Size = UDim2.fromOffset(200, 16),
    BackgroundTransparency = 1,
    Text = "ULTRA INTERFACE",
    TextColor3 = Theme.Gray,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

local Close = Create("TextButton", {
    Size = UDim2.fromOffset(35, 35),
    Position = UDim2.new(1, -48, 0, 15),
    BackgroundColor3 = Color3.fromRGB(65, 35, 80),
    Text = "×",
    TextColor3 = Theme.White,
    TextSize = 25,
    Font = Enum.Font.GothamBold
}, Header)

Round(Close, 9)

Close.MouseButton1Click:Connect(function()
    Animate(Main, {
        Size = UDim2.fromOffset(0, 0)
    }, 0.25)
    task.wait(0.3)
    Gui:Destroy()
end)

-- SIDEBAR
local Sidebar = Create("Frame", {
    Position = UDim2.fromOffset(0, 65),
    Size = UDim2.new(0, 150, 1, -65),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0
}, Main)

local Content = Create("Frame", {
    Position = UDim2.fromOffset(165, 80),
    Size = UDim2.new(1, -180, 1, -95),
    BackgroundTransparency = 1
}, Main)

local Pages = {}
local Tabs = {}

local function CreatePage(name)
    local page = Create("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Purple,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, Content)

    Create("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    Pages[name] = page
    return page
end

local function SwitchPage(name)
    for n, page in pairs(Pages) do
        page.Visible = n == name
    end

    for n, tab in pairs(Tabs) do
        Animate(tab, {
            BackgroundColor3 =
                n == name and Theme.Purple or Theme.Card,
            TextColor3 =
                n == name and Theme.White or Theme.Gray
        }, 0.2)
    end
end

local function CreateTab(name, icon, index)
    local tab = Create("TextButton", {
        Position = UDim2.fromOffset(10, 17 + (index-1)*52),
        Size = UDim2.fromOffset(130, 42),
        BackgroundColor3 = Theme.Card,
        Text = icon .. "   " .. name,
        TextColor3 = Theme.Gray,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    }, Sidebar)

    Round(tab, 9)
    Tabs[name] = tab

    tab.MouseButton1Click:Connect(function()
        SwitchPage(name)
    end)
end

local Home = CreatePage("Home")
local Visuals = CreatePage("Visuals")
local Tools = CreatePage("Tools")
local Settings = CreatePage("Settings")

CreateTab("Home", "⌂", 1)
CreateTab("Visuals", "◈", 2)
CreateTab("Tools", "⚙", 3)
CreateTab("Settings", "☷", 4)

SwitchPage("Home")

-- CARD
local function Card(page, title, description)
    local card = Create("Frame", {
        Size = UDim2.new(1, -5, 0, 82),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0
    }, page)

    Round(card, 12)

    Create("UIStroke", {
        Color = Theme.Purple,
        Transparency = 0.8,
        Thickness = 1
    }, card)

    Create("TextLabel", {
        Position = UDim2.fromOffset(15, 12),
        Size = UDim2.new(1, -30, 0, 23),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.White,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    Create("TextLabel", {
        Position = UDim2.fromOffset(15, 42),
        Size = UDim2.new(1, -30, 0, 22),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Theme.Gray,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    return card
end

-- TOGGLE
local function Toggle(page, title, description)
    local card = Card(page, title, description)

    local button = Create("TextButton", {
        Size = UDim2.fromOffset(44, 24),
        Position = UDim2.new(1, -58, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(55, 51, 68),
        Text = "",
        AutoButtonColor = false
    }, card)

    Round(button, 20)

    local knob = Create("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0
    }, button)

    Round(knob, 20)

    local enabled = false

    button.MouseButton1Click:Connect(function()
        enabled = not enabled

        Animate(button, {
            BackgroundColor3 = enabled and Theme.Purple
                or Color3.fromRGB(55, 51, 68)
        })

        Animate(knob, {
            Position = enabled
                and UDim2.fromOffset(23, 3)
                or UDim2.fromOffset(3, 3)
        })

        print(title, enabled)
    end)
end

-- HOME
Card(Home, "Welcome to Mercury",
    "Your futuristic gaming interface.")

Card(Home, "Interface Version",
    "ULTRA 2.0 | Purple Edition")

Card(Home, "System Status",
    "All interface components loaded.")

-- VISUALS
Toggle(Visuals, "Visual Option 01",
    "Example visual setting.")

Toggle(Visuals, "Visual Option 02",
    "Example display setting.")

-- TOOLS
Card(Tools, "Interface Tools",
    "Your custom tools will appear here.")

Toggle(Tools, "UI Effects",
    "Enable interface effects.")

-- SETTINGS
Toggle(Settings, "Animations",
    "Smooth interface transitions.")

Toggle(Settings, "Notifications",
    "Interface notifications.")

Card(Settings, "Theme",
    "Mercury Purple / Dark")

-- DRAG
local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)
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

print("MERCURY ULTRA LOADED")
