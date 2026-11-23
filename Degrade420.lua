
--==================================================
-- MERCURY LUXURY 5.0
-- Roblox Studio | LocalScript
-- Place in StarterPlayer > StarterPlayerScripts
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local DEMO_KEY = "MERCURY-GOLD-2026"

local C = {
    BG = Color3.fromRGB(12, 12, 17),
    PANEL = Color3.fromRGB(20, 20, 27),
    CARD = Color3.fromRGB(29, 29, 38),
    GOLD = Color3.fromRGB(225, 180, 85),
    LIGHT = Color3.fromRGB(255, 220, 145),
    WHITE = Color3.fromRGB(240, 240, 245),
    MUTED = Color3.fromRGB(135, 135, 150),
    RED = Color3.fromRGB(255, 90, 90),
    GREEN = Color3.fromRGB(110, 220, 150)
}

local unlocked = false
local menuOpen = false
local activeTab = "Home"

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    new("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function border(obj, color, thickness)
    new("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = 0.15
    }, obj)
end

local function animate(obj, duration, props)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        props
    )
    t:Play()
    return t
end

local gui = new("ScreenGui", {
    Name = "MercuryLuxury5",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 100
}, playerGui)

-- Background
local shade = new("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
    Visible = true
}, gui)

-- Main window
local main = new("Frame", {
    Size = UDim2.fromOffset(650, 420),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = C.BG,
    BorderSizePixel = 0,
    Visible = false
}, gui)
corner(main, 14)
border(main, C.GOLD, 1.5)

-- Top bar
local top = new("Frame", {
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundColor3 = C.PANEL,
    BorderSizePixel = 0
}, main)
corner(top, 14)

new("TextLabel", {
    Position = UDim2.fromOffset(20, 7),
    Size = UDim2.fromOffset(260, 28),
    BackgroundTransparency = 1,
    Text = "MERCURY",
    TextColor3 = C.LIGHT,
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

new("TextLabel", {
    Position = UDim2.fromOffset(21, 34),
    Size = UDim2.fromOffset(250, 15),
    BackgroundTransparency = 1,
    Text = "L U X U R Y   E D I T I O N",
    TextColor3 = C.MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, top)

local close = new("TextButton", {
    Size = UDim2.fromOffset(36, 36),
    Position = UDim2.new(1, -48, 0, 12),
    BackgroundColor3 = C.CARD,
    Text = "×",
    TextColor3 = C.LIGHT,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    BorderSizePixel = 0
}, top)
corner(close, 9)

-- Sidebar
local sidebar = new("Frame", {
    Position = UDim2.fromOffset(15, 75),
    Size = UDim2.fromOffset(145, 330),
    BackgroundColor3 = C.PANEL,
    BorderSizePixel = 0
}, main)
corner(sidebar, 10)

new("TextLabel", {
    Position = UDim2.fromOffset(13, 12),
    Size = UDim2.new(1, -20, 0, 20),
    BackgroundTransparency = 1,
    Text = "NAVIGATION",
    TextColor3 = C.MUTED,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
}, sidebar)

-- Content
local content = new("Frame", {
    Position = UDim2.fromOffset(175, 75),
    Size = UDim2.fromOffset(460, 330),
    BackgroundTransparency = 1
}, main)

local pages = {}
local tabButtons = {}

local function createPage(name)
    local page = new("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.GOLD,
        CanvasSize = UDim2.fromOffset(0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, content)

    new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    new("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 5),
        PaddingRight = UDim.new(0, 8)
    }, page)

    pages[name] = page
    return page
end

local function switchTab(name)
    activeTab = name

    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end

    for buttonName, button in pairs(tabButtons) do
        animate(button, 0.18, {
            BackgroundColor3 = buttonName == name and C.CARD or C.PANEL,
            TextColor3 = buttonName == name and C.LIGHT or C.MUTED
        })
    end
end

local function addTab(name, order)
    local button = new("TextButton", {
        Position = UDim2.fromOffset(8, 42 + (order - 1) * 43),
        Size = UDim2.fromOffset(129, 35),
        BackgroundColor3 = C.PANEL,
        Text = "   " .. name,
        TextColor3 = C.MUTED,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        BorderSizePixel = 0
    }, sidebar)
    corner(button, 8)

    tabButtons[name] = button
    button.MouseButton1Click:Connect(function()
        switchTab(name)
    end)
end

local function heading(parent, title, subtitle)
    local holder = new("Frame", {
        Size = UDim2.new(1, 0, 0, 52),
        BackgroundTransparency = 1
    }, parent)

    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 27),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.LIGHT,
        Font = Enum.Font.GothamBold,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left
    }, holder)

    new("TextLabel", {
        Position = UDim2.fromOffset(0, 28),
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = C.MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }, holder)
end

local function addToggle(parent, title, description)
    local row = new("Frame", {
        Size = UDim2.new(1, 0, 0, 57),
        BackgroundColor3 = C.CARD,
        BorderSizePixel = 0
    }, parent)
    corner(row, 9)

    new("TextLabel", {
        Position = UDim2.fromOffset(13, 7),
        Size = UDim2.new(1, -75, 0, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.WHITE,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    new("TextLabel", {
        Position = UDim2.fromOffset(13, 29),
        Size = UDim2.new(1, -75, 0, 17),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = C.MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left
    }, row)

    local button = new("TextButton", {
        Position = UDim2.new(1, -58, 0.5, -12),
        Size = UDim2.fromOffset(45, 24),
        BackgroundColor3 = C.PANEL,
        Text = "",
        BorderSizePixel = 0
    }, row)
    corner(button, 12)

    local knob = new("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = C.MUTED,
        BorderSizePixel = 0
    }, button)
    corner(knob, 10)

    local enabled = false

    button.MouseButton1Click:Connect(function()
        enabled = not enabled

        animate(button, 0.2, {
            BackgroundColor3 = enabled and C.GOLD or C.PANEL
        })

        animate(knob, 0.2, {
            Position = enabled and UDim2.fromOffset(24, 3)
                or UDim2.fromOffset(3, 3),
            BackgroundColor3 = enabled and C.BG or C.MUTED
        })
    end)
end

-- Build pages
local home = createPage("Home")
local visual = createPage("Visual")
local settings = createPage("Settings")
local about = createPage("About")

addTab("Home", 1)
addTab("Visual", 2)
addTab("Settings", 3)
addTab("About", 4)

heading(home, "Dashboard", "Welcome to Mercury Luxury")
addToggle(home, "Interface Effects", "Demo visual setting")
addToggle(home, "Notifications", "Demo notification setting")
addToggle(home, "Smooth Animations", "Interface transitions")

heading(visual, "Visual Settings", "Customize your interface")
addToggle(visual, "Golden Theme", "Gold visual theme")
addToggle(visual, "Particles", "Decorative visual setting")
addToggle(visual, "Compact Mode", "Demo layout setting")

heading(settings, "Settings", "Personalize your experience")
addToggle(settings, "Show Profile", "Display profile setting")
addToggle(settings, "Sound Effects", "Demo sound setting")
addToggle(settings, "Remember Layout", "Demo preference")

heading(about, "About Mercury", "Luxury interface edition")

local aboutCard = new("Frame", {
    Size = UDim2.new(1, 0, 0, 100),
    BackgroundColor3 = C.CARD,
    BorderSizePixel = 0
}, about)
corner(aboutCard, 10)

new("TextLabel", {
    Position = UDim2.fromOffset(15, 12),
    Size = UDim2.new(1, -30, 0, 25),
    BackgroundTransparency = 1,
    Text = "MERCURY LUXURY 5.0",
    TextColor3 = C.LIGHT,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
}, aboutCard)

new("TextLabel", {
    Position = UDim2.fromOffset(15, 42),
    Size = UDim2.new(1, -30, 0, 40),
    BackgroundTransparency = 1,
    Text = "Custom visual interface demo.\nMade for Roblox Studio projects.",
    TextColor3 = C.MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
}, aboutCard)

switchTab("Home")

-- Dragging
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

-- Floating M button
local reopen = new("TextButton", {
    Size = UDim2.fromOffset(54, 54),
    Position = UDim2.new(0, 20, 0.5, -27),
    BackgroundColor3 = C.PANEL,
    Text = "M",
    TextColor3 = C.LIGHT,
    Font = Enum.Font.GothamBlack,
    TextSize = 23,
    BorderSizePixel = 0,
    Visible = false
}, gui)
corner(reopen, 18)
border(reopen, C.GOLD, 1.5)

local function setMenu(open)
    if not unlocked then return end

    menuOpen = open

    if open then
        main.Visible = true
        reopen.Visible = false
        shade.Visible = true
        main.Size = UDim2.fromOffset(0, 0)

        animate(main, 0.3, {
            Size = UDim2.fromOffset(650, 420)
        })

        animate(shade, 0.25, {
            BackgroundTransparency = 0.35
        })
    else
        animate(main, 0.2, {
            Size = UDim2.fromOffset(0, 0)
        })

        task.delay(0.2, function()
            if not menuOpen then
                main.Visible = false
                main.Size = UDim2.fromOffset(650, 420)
                shade.Visible = false
                reopen.Visible = true
            end
        end)
    end
end

close.MouseButton1Click:Connect(function()
    setMenu(false)
end)

reopen.MouseButton1Click:Connect(function()
    setMenu(true)
end)

-- K key toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if UserInputService:GetFocusedTextBox() then return end

    if input.KeyCode == Enum.KeyCode.K and unlocked then
        setMenu(not menuOpen)
    end
end)

--==================================================
-- KEY SYSTEM SCREEN
--==================================================

local keyScreen = new("Frame", {
    Size = UDim2.fromOffset(370, 270),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = C.PANEL,
    BorderSizePixel = 0
}, gui)
corner(keyScreen, 15)
border(keyScreen, C.GOLD, 1.5)

new("TextLabel", {
    Position = UDim2.fromOffset(0, 20),
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundTransparency = 1,
    Text = "MERCURY",
    TextColor3 = C.LIGHT,
    Font = Enum.Font.GothamBlack,
    TextSize = 26
}, keyScreen)

new("TextLabel", {
    Position = UDim2.fromOffset(0, 57),
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "LUXURY ACCESS SYSTEM",
    TextColor3 = C.MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 10
}, keyScreen)

local keyBox = new("TextBox", {
    Position = UDim2.fromOffset(30, 100),
    Size = UDim2.fromOffset(310, 43),
    BackgroundColor3 = C.CARD,
    Text = "",
    PlaceholderText = "Enter your demo key...",
    PlaceholderColor3 = C.MUTED,
    TextColor3 = C.WHITE,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    ClearTextOnFocus = false,
    BorderSizePixel = 0
}, keyScreen)
corner(keyBox, 8)
border(keyBox, C.GOLD, 1)

local status = new("TextLabel", {
    Position = UDim2.fromOffset(20, 150),
    Size = UDim2.new(1, -40, 0, 22),
    BackgroundTransparency = 1,
    Text = "Enter the demo key to continue",
    TextColor3 = C.MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 10
}, keyScreen)

local unlock = new("TextButton", {
    Position = UDim2.fromOffset(30, 190),
    Size = UDim2.fromOffset(310, 40),
    BackgroundColor3 = C.GOLD,
    Text = "UNLOCK MERCURY",
    TextColor3 = C.BG,
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    BorderSizePixel = 0
}, keyScreen)
corner(unlock, 8)

local function checkKey()
    if unlocked then return end

    if keyBox.Text == DEMO_KEY then
        unlocked = true
        status.Text = "Access granted!"
        status.TextColor3 = C.GREEN
        unlock.Text = "ACCESS GRANTED"

        task.wait(0.45)

        animate(keyScreen, 0.3, {
            BackgroundTransparency = 1
        })

        keyScreen.Visible = false
        shade.Visible = false

        setMenu(true)
    else
        status.Text = "Incorrect key. Try again."
        status.TextColor3 = C.RED

        local original = keyScreen.Position

        animate(keyScreen, 0.06, {
            Position = original + UDim2.fromOffset(7, 0)
        })

        task.wait(0.07)

        animate(keyScreen, 0.06, {
            Position = original
        })
    end
end

unlock.MouseButton1Click:Connect(checkKey)

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkKey()
    end
end)

-- Initial animation
main.Visible = false
reopen.Visible = false
shade.Visible = true
keyScreen.Size = UDim2.fromOffset(0, 0)

animate(keyScreen, 0.45, {
    Size = UDim2.fromOffset(370, 270)
})

-- DEMO KEY: MERCURY-GOLD-2026
