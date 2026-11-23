
--==================================================
--              MERCURY X ELITE
--                  VERSION 3.0
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(10, 9, 17),
    Sidebar = Color3.fromRGB(16, 14, 25),
    Card = Color3.fromRGB(25, 22, 38),
    Purple = Color3.fromRGB(151, 83, 255),
    Violet = Color3.fromRGB(95, 48, 180),
    White = Color3.fromRGB(248, 245, 255),
    Gray = Color3.fromRGB(140, 132, 158),
    Green = Color3.fromRGB(100, 230, 170)
}

local function New(class, properties, parent)
    local object = Instance.new(class)

    for key, value in pairs(properties) do
        object[key] = value
    end

    object.Parent = parent
    return object
end

local function Round(object, radius)
    New("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, object)
end

local function Outline(object, color, transparency)
    return New("UIStroke", {
        Color = color,
        Thickness = 1,
        Transparency = transparency or 0.3
    }, object)
end

local function Tween(object, properties, duration)
    local animation = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.25,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    )

    animation:Play()
    return animation
end

-- SCREEN GUI
local GUI = New("ScreenGui", {
    Name = "MercuryXElite",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, Player:WaitForChild("PlayerGui"))

-- MAIN WINDOW
local Main = New("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(700, 450),
    Position = UDim2.new(0.5, -350, 0.5, -225),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, GUI)

Round(Main, 18)
Outline(Main, Theme.Purple, 0.15)

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0, Color3.fromRGB(31, 19, 48)
        ),
        ColorSequenceKeypoint.new(
            0.5, Theme.Background
        ),
        ColorSequenceKeypoint.new(
            1, Color3.fromRGB(17, 13, 30)
        )
    }),
    Rotation = 35
}, Main)

-- OPENING ANIMATION
Main.Size = UDim2.fromOffset(580, 370)

Tween(Main, {
    Size = UDim2.fromOffset(700, 450)
}, 0.5)

-- HEADER
local Header = New("Frame", {
    Size = UDim2.new(1, 0, 0, 75),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0
}, Main)

local Logo = New("Frame", {
    Position = UDim2.fromOffset(20, 14),
    Size = UDim2.fromOffset(46, 46),
    BackgroundColor3 = Theme.Purple
}, Header)

Round(Logo, 13)

New("UIGradient", {
    Color = ColorSequence.new(
        Theme.Purple,
        Theme.Violet
    ),
    Rotation = 45
}, Logo)

New("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "M",
    TextColor3 = Theme.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 29
}, Logo)

New("TextLabel", {
    Position = UDim2.fromOffset(80, 13),
    Size = UDim2.fromOffset(250, 29),
    BackgroundTransparency = 1,
    Text = "MERCURY X",
    TextColor3 = Theme.White,
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

New("TextLabel", {
    Position = UDim2.fromOffset(82, 42),
    Size = UDim2.fromOffset(250, 16),
    BackgroundTransparency = 1,
    Text = "ELITE INTERFACE  /  V3.0",
    TextColor3 = Theme.Gray,
    Font = Enum.Font.GothamBold,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

-- STATUS
local Status = New("Frame", {
    Size = UDim2.fromOffset(88, 29),
    Position = UDim2.new(1, -150, 0, 23),
    BackgroundColor3 = Color3.fromRGB(24, 48, 38)
}, Header)

Round(Status, 15)

local Dot = New("Frame", {
    Size = UDim2.fromOffset(7, 7),
    Position = UDim2.fromOffset(12, 11),
    BackgroundColor3 = Theme.Green
}, Status)

Round(Dot, 10)

New("TextLabel", {
    Position = UDim2.fromOffset(25, 0),
    Size = UDim2.fromOffset(55, 29),
    BackgroundTransparency = 1,
    Text = "READY",
    TextColor3 = Theme.Green,
    Font = Enum.Font.GothamBold,
    TextSize = 10
}, Status)

-- CLOSE
local Close = New("TextButton", {
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.new(1, -47, 0, 20),
    BackgroundColor3 = Color3.fromRGB(60, 32, 72),
    Text = "×",
    TextColor3 = Theme.White,
    Font = Enum.Font.GothamBold,
    TextSize = 23,
    AutoButtonColor = false
}, Header)

Round(Close, 10)

Close.MouseButton1Click:Connect(function()
    Tween(Main, {
        Size = UDim2.fromOffset(0, 0)
    }, 0.25)

    task.wait(0.3)
    GUI:Destroy()
end)

-- SIDEBAR
local Sidebar = New("Frame", {
    Position = UDim2.fromOffset(0, 75),
    Size = UDim2.new(0, 165, 1, -75),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0
}, Main)

New("TextLabel", {
    Position = UDim2.fromOffset(19, 17),
    Size = UDim2.fromOffset(130, 20),
    BackgroundTransparency = 1,
    Text = "MAIN MENU",
    TextColor3 = Theme.Gray,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
}, Sidebar)

local Content = New("Frame", {
    Position = UDim2.fromOffset(180, 90),
    Size = UDim2.new(1, -195, 1, -110),
    BackgroundTransparency = 1
}, Main)

-- PAGES
local Pages = {}
local Tabs = {}

local function CreatePage(name)
    local page = New("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Purple,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false
    }, Content)

    New("UIListLayout", {
        Padding = UDim.new(0, 13),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    Pages[name] = page
    return page
end

local function SwitchPage(name)
    for n, page in pairs(Pages) do
        page.Visible = n == name
    end

    for n, button in pairs(Tabs) do
        Tween(button, {
            BackgroundColor3 =
                n == name and Theme.Purple or Theme.Card,
            TextColor3 =
                n == name and Theme.White or Theme.Gray
        }, 0.2)
    end
end

local function CreateTab(name, icon, index)
    local button = New("TextButton", {
        Position = UDim2.fromOffset(12, 48 + (index-1)*53),
        Size = UDim2.fromOffset(140, 43),
        BackgroundColor3 = Theme.Card,
        Text = icon .. "     " .. name,
        TextColor3 = Theme.Gray,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        AutoButtonColor = false
    }, Sidebar)

    Round(button, 10)
    Tabs[name] = button

    button.MouseButton1Click:Connect(function()
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

-- CARD SYSTEM
local function Card(page, title, subtitle, height)
    local card = New("Frame", {
        Size = UDim2.new(1, -5, 0, height or 88),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0
    }, page)

    Round(card, 13)
    Outline(card, Theme.Purple, 0.82)

    New("TextLabel", {
        Position = UDim2.fromOffset(17, 14),
        Size = UDim2.new(1, -34, 0, 25),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.White,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    New("TextLabel", {
        Position = UDim2.fromOffset(17, 43),
        Size = UDim2.new(1, -34, 0, 22),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = Theme.Gray,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    return card
end

-- TOGGLE SYSTEM
local function Toggle(page, title, description, callback)
    local card = Card(page, title, description, 83)

    local switch = New("TextButton", {
        Size = UDim2.fromOffset(46, 25),
        Position = UDim2.new(1, -63, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(54, 49, 68),
        Text = "",
        AutoButtonColor = false
    }, card)

    Round(switch, 20)

    local knob = New("Frame", {
        Size = UDim2.fromOffset(19, 19),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = Theme.White,
        BorderSizePixel = 0
    }, switch)

    Round(knob, 20)

    local enabled = false

    switch.MouseButton1Click:Connect(function()
        enabled = not enabled

        Tween(switch, {
            BackgroundColor3 = enabled and Theme.Purple
                or Color3.fromRGB(54, 49, 68)
        })

        Tween(knob, {
            Position = enabled
                and UDim2.fromOffset(24, 3)
                or UDim2.fromOffset(3, 3)
        })

        if callback then
            callback(enabled)
        end
    end)

    return switch
end

-- HOME
Card(Home,
    "WELCOME TO MERCURY X",
    "Your personal futuristic gaming interface.",
    105
)

Card(Home,
    "ELITE EDITION",
    "Premium visual design / Purple collection.",
    88
)

Card(Home,
    "SYSTEM STATUS",
    "All interface components are ready.",
    88
)

-- VISUALS
Toggle(Visuals,
    "Visual Option 01",
    "Demonstration visual setting."
)

Toggle(Visuals,
    "Visual Option 02",
    "Demonstration display setting."
)

-- TOOLS
Card(Tools,
    "CUSTOM TOOLS",
    "Your own game tools can be added here."
)

Toggle(Tools,
    "Interface Effects",
    "Example interface option."
)

-- SETTINGS
Toggle(Settings,
    "Animations",
    "Enable interface animations."
)

Toggle(Settings,
    "Notifications",
    "Example notification setting."
)

Card(Settings,
    "CURRENT THEME",
    "Mercury Purple / Dark Edition."
)

-- DRAG SUPPORT
local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true
        DragStart = input.Position
        StartPosition = Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if Dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then

        local delta = input.Position - DragStart

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = false
    end
end)

print("MERCURY X ELITE LOADED")
