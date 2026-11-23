
--==================================================
-- MERCURY LUXURY 4.0 | KEY SYSTEM
-- Visual-only GUI for Roblox Studio
-- Place as a LocalScript in StarterPlayerScripts
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local KEY = "MERCURY-GOLD-2026"

local GOLD = Color3.fromRGB(225, 180, 85)
local GOLD_LIGHT = Color3.fromRGB(255, 220, 145)
local BG = Color3.fromRGB(12, 12, 17)
local PANEL = Color3.fromRGB(20, 20, 27)
local CARD = Color3.fromRGB(28, 28, 36)
local WHITE = Color3.fromRGB(240, 240, 245)
local MUTED = Color3.fromRGB(135, 135, 150)

local gui = Instance.new("ScreenGui")
gui.Name = "MercuryLuxury"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function stroke(obj, color, thickness)
    create("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = 0.15
    }, obj)
end

local function tween(obj, duration, props)
    TweenService:Create(
        obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    ):Play()
end

-- Background
local background = create("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0
}, gui)

-- Main window
local main = create("Frame", {
    Size = UDim2.fromOffset(650, 420),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = BG,
    BorderSizePixel = 0,
    Visible = false
}, gui)
round(main, 14)
stroke(main, GOLD, 1.5)

-- Top bar
local top = create("Frame", {
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, main)
round(top, 14)

create("TextLabel", {
    Position = UDim2.fromOffset(20, 7),
    Size = UDim2.fromOffset(250, 25),
    BackgroundTransparency = 1,
    Text = "MERCURY",
    TextColor3 = GOLD_LIGHT,
    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

create("TextLabel", {
    Position = UDim2.fromOffset(21, 32),
    Size = UDim2.fromOffset(250, 15),
    BackgroundTransparency = 1,
    Text = "L U X U R Y   E D I T I O N",
    TextColor3 = MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local close = create("TextButton", {
    Size = UDim2.fromOffset(35, 35),
    Position = UDim2.new(1, -47, 0, 11),
    BackgroundColor3 = CARD,
    Text = "×",
    TextColor3 = GOLD_LIGHT,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    BorderSizePixel = 0
}, top)
round(close, 9)

-- Sidebar
local sidebar = create("Frame", {
    Position = UDim2.fromOffset(15, 75),
    Size = UDim2.fromOffset(145, 330),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, main)
round(sidebar, 10)

create("TextLabel", {
    Position = UDim2.fromOffset(13, 12),
    Size = UDim2.new(1, -20, 0, 20),
    BackgroundTransparency = 1,
    Text = "NAVIGATION",
    TextColor3 = MUTED,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
}, sidebar)

-- Content area
local content = create("Frame", {
    Position = UDim2.fromOffset(175, 75),
    Size = UDim2.fromOffset(460, 330),
    BackgroundTransparency = 1
}, main)

local pages = {}
local buttons = {}

local function makePage(name)
    local page = create("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = GOLD,
        CanvasSize = UDim2.fromOffset(0, 0),
        Visible = false
    }, content)

    create("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    create("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 8)
    }, page)

    pages[name] = page
    return page
end

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end

    for buttonName, button in pairs(buttons) do
        tween(button, 0.2, {
            BackgroundColor3 = buttonName == name and CARD or PANEL,
            TextColor3 = buttonName == name and GOLD_LIGHT or MUTED
        })
    end
end

local function addTab(name, order)
    local button = create("TextButton", {
        Position = UDim2.fromOffset(8, 42 + (order - 1) * 43),
        Size = UDim2.fromOffset(129, 35),
        BackgroundColor3 = PANEL,
        Text = "   " .. name,
        TextColor3 = MUTED,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0
    }, sidebar)
    round(button, 8)

    buttons[name] = button
    button.MouseButton1Click:Connect(function()
        showPage(name)
    end)
end

local function addHeading(parent, title, description)
    local holder = create("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1
    }, parent)

    create("TextLabel", {
        Size = UDim2.new(1, 0, 0, 27),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = GOLD_LIGHT,
        Font = Enum.Font.GothamBold,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left
    }, holder)

    create("TextLabel", {
        Position = UDim2.fromOffset(0, 28),
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }, holder)
end

local function addToggle(parent, title, description)
    local row = create("Frame", {
        Size = UDim2.new(1, 0, 0, 57),
        BackgroundColor3 = CARD,
        BorderSizePixel = 0
    }, parent)
    round(row, 9)

    create("TextLabel", {
        Position = UDim2.fromOffset(13, 7),
        Size = UDim2.new(1, -75, 0, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    create("TextLabel", {
        Position = UDim2.fromOffset(13, 29),
        Size = UDim2.new(1, -75, 0, 17),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local toggle = create("TextButton", {
        Position = UDim2.new(1, -58, 0.5, -12),
        Size = UDim2.fromOffset(45, 24),
        BackgroundColor3 = PANEL,
        Text = "",
        BorderSizePixel = 0
    }, row)
    round(toggle, 12)

    local knob = create("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = MUTED,
        BorderSizePixel = 0
    }, toggle)
    round(knob, 10)

    local enabled = false

    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled

        tween(toggle, 0.2, {
            BackgroundColor3 = enabled and GOLD or PANEL
        })

        tween(knob, 0.2, {
            Position = enabled and UDim2.fromOffset(24, 3) or UDim2.fromOffset(3, 3),
            BackgroundColor3 = enabled and Color3.fromRGB(30, 30, 35) or MUTED
        })
    end)
end

-- Pages and tabs
local home = makePage("Home")
local visual = makePage("Visual")
local settings = makePage("Settings")
local about = makePage("About")

addTab("Home", 1)
addTab("Visual", 2)
addTab("Settings", 3)
addTab("About", 4)

addHeading(home, "Dashboard", "Welcome to Mercury Luxury")
addToggle(home, "Interface Effects", "Demo toggle for your own game")
addToggle(home, "Notifications", "Show interface notifications")
addToggle(home, "Smooth Animations", "Enable visual transitions")

addHeading(visual, "Visual Settings", "Customize your interface")
addToggle(visual, "Golden Theme", "Use the gold color theme")
addToggle(visual, "Particles", "Visual-only decorative effect")
addToggle(visual, "Compact Mode", "Demo layout setting")

addHeading(settings, "Settings", "Personalize your experience")
addToggle(settings, "Show Profile", "Display player profile")
addToggle(settings, "Sound Effects", "Interface sound setting")
addToggle(settings, "Remember Layout", "Demo preference toggle")

addHeading(about, "About Mercury", "Luxury interface edition")

local info = create("Frame", {
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundColor3 = CARD,
    BorderSizePixel = 0
}, about)
round(info, 10)

create("TextLabel", {
    Position = UDim2.fromOffset(15, 12),
    Size = UDim2.new(1, -30, 0, 25),
    BackgroundTransparency = 1,
    Text = "MERCURY LUXURY 4.0",
    TextColor3 = GOLD_LIGHT,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
}, info)

create("TextLabel", {
    Position = UDim2.fromOffset(15, 42),
    Size = UDim2.new(1, -30, 0, 40),
    BackgroundTransparency = 1,
    Text = "A custom visual interface demo.\\nMade for Roblox Studio projects.",
    TextColor3 = MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
}, info)

showPage("Home")

-- Drag window
local dragging = false
local dragStart
local startPosition

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

close.MouseButton1Click:Connect(function()
    tween(main, 0.2, {
        Size = UDim2.fromOffset(0, 0)
    })
    task.wait(0.2)
    main.Visible = false
    main.Size = UDim2.fromOffset(650, 420)
end)

-- Floating reopen button
local reopen = create("TextButton", {
    Size = UDim2.fromOffset(55, 55),
    Position = UDim2.new(0, 20, 0.5, -27),
    BackgroundColor3 = PANEL,
    Text = "M",
    TextColor3 = GOLD_LIGHT,
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    BorderSizePixel = 0
}, gui)
round(reopen, 18)
stroke(reopen, GOLD, 1.5)

reopen.MouseButton1Click:Connect(function()
    main.Visible = true
    main.Size = UDim2.fromOffset(0, 0)
    tween(main, 0.35, {
        Size = UDim2.fromOffset(650, 420)
    })
end)

--==================================================
-- KEY SCREEN
--==================================================

local keyScreen = create("Frame", {
    Size = UDim2.fromOffset(370, 265),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0
}, gui)
round(keyScreen, 15)
stroke(keyScreen, GOLD, 1.5)

create("TextLabel", {
    Position = UDim2.fromOffset(0, 22),
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundTransparency = 1,
    Text = "MERCURY",
    TextColor3 = GOLD_LIGHT,
    Font = Enum.Font.GothamBlack,
    TextSize = 26
}, keyScreen)

create("TextLabel", {
    Position = UDim2.fromOffset(0, 58),
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "LUXURY ACCESS SYSTEM",
    TextColor3 = MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 10
}, keyScreen)

local keyBox = create("TextBox", {
    Position = UDim2.fromOffset(30, 105),
    Size = UDim2.fromOffset(310, 42),
    BackgroundColor3 = CARD,
    Text = "",
    PlaceholderText = "Enter your demo key...",
    PlaceholderColor3 = MUTED,
    TextColor3 = WHITE,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ClearTextOnFocus = false,
    BorderSizePixel = 0
}, keyScreen)
round(keyBox, 8)
stroke(keyBox, GOLD, 1)

local status = create("TextLabel", {
    Position = UDim2.fromOffset(20, 153),
    Size = UDim2.new(1, -40, 0, 20),
    BackgroundTransparency = 1,
    Text = "Enter the demo key to continue",
    TextColor3 = MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 10
}, keyScreen)

local unlock = create("TextButton", {
    Position = UDim2.fromOffset(30, 190),
    Size = UDim2.fromOffset(310, 40),
    BackgroundColor3 = GOLD,
    Text = "UNLOCK MERCURY",
    TextColor3 = BG,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    BorderSizePixel = 0
}, keyScreen)
round(unlock, 8)

unlock.MouseButton1Click:Connect(function()
    if keyBox.Text == KEY then
        status.Text = "Access granted!"
        status.TextColor3 = GOLD_LIGHT
        unlock.Text = "ACCESS GRANTED"

        task.wait(0.5)

        tween(keyScreen, 0.3, {
            BackgroundTransparency = 1
        })

        keyScreen.Visible = false
        background.Visible = false

        main.Visible = true
        main.Size = UDim2.fromOffset(0, 0)

        tween(main, 0.4, {
            Size = UDim2.fromOffset(650, 420)
        })
    else
        status.Text = "Incorrect key. Try again."
        status.TextColor3 = Color3.fromRGB(255, 90, 90)

        local oldPosition = keyScreen.Position

        tween(keyScreen, 0.06, {
            Position = oldPosition + UDim2.fromOffset(7, 0)
        })

        task.wait(0.07)

        tween(keyScreen, 0.06, {
            Position = oldPosition
        })
    end
end)

-- Entrance animation
main.Visible = false
reopen.Visible = false
keyScreen.Size = UDim2.fromOffset(0, 0)

tween(keyScreen, 0.45, {
    Size = UDim2.fromOffset(370, 265)
})

-- Demo key: MERCURY-GOLD-2026
