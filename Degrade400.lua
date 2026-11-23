
--==================================================
-- MERCURY LUXURY 4.0 | GODLIKE EDITION
-- Roblox Studio | LocalScript
-- Visual UI prototype. No exploit functionality.
--==================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("MercuryGodlike")
if old then old:Destroy() end

local GOLD = Color3.fromRGB(225, 181, 95)
local PALE = Color3.fromRGB(255, 225, 163)
local BG = Color3.fromRGB(10, 10, 13)
local PANEL = Color3.fromRGB(19, 19, 24)
local CARD = Color3.fromRGB(28, 28, 34)
local WHITE = Color3.fromRGB(240, 237, 229)
local MUTED = Color3.fromRGB(135, 132, 124)

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function outline(obj, color, transparency)
    return make("UIStroke", {
        Color = color or GOLD,
        Transparency = transparency or 0.4,
        Thickness = 1
    }, obj)
end

local function tw(obj, duration, props, style)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration,
            style or Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

local gui = make("ScreenGui", {
    Name = "MercuryGodlike",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

--==================================================
-- LOADING SCREEN
--==================================================

local loading = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = BG,
    ZIndex = 100
}, gui)

local loadingTitle = make("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.43),
    Size = UDim2.fromOffset(430, 65),
    BackgroundTransparency = 1,
    Text = "M E R C U R Y",
    TextColor3 = PALE,
    Font = Enum.Font.GothamBold,
    TextSize = 34,
    ZIndex = 101
}, loading)

local loadingDesc = make("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.51),
    Size = UDim2.fromOffset(300, 25),
    BackgroundTransparency = 1,
    Text = "G O D L I K E   E D I T I O N",
    TextColor3 = MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    ZIndex = 101
}, loading)

local barBack = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.59),
    Size = UDim2.fromOffset(230, 5),
    BackgroundColor3 = CARD,
    ZIndex = 101
}, loading)
corner(barBack, 5)

local bar = make("Frame", {
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = GOLD,
    ZIndex = 102
}, barBack)
corner(bar, 5)

local percent = make("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.64),
    Size = UDim2.fromOffset(100, 20),
    BackgroundTransparency = 1,
    Text = "0%",
    TextColor3 = GOLD,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    ZIndex = 101
}, loading)

--==================================================
-- BACKGROUND PARTICLES
--==================================================

local particleLayer = make("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ZIndex = 1
}, gui)

local rng = Random.new()

for i = 1, 28 do
    local size = rng:NextInteger(2, 4)

    local p = make("Frame", {
        Size = UDim2.fromOffset(size, size),
        Position = UDim2.fromScale(
            rng:NextNumber(),
            rng:NextNumber()
        ),
        BackgroundColor3 = GOLD,
        BackgroundTransparency = rng:NextNumber(0.35, 0.8),
        BorderSizePixel = 0,
        ZIndex = 1
    }, particleLayer)

    corner(p, 10)

    task.spawn(function()
        while p.Parent do
            local target = UDim2.fromScale(
                rng:NextNumber(),
                rng:NextNumber()
            )

            tw(p, rng:NextNumber(5, 10), {
                Position = target,
                BackgroundTransparency = rng:NextNumber(0.3, 0.85)
            }, Enum.EasingStyle.Sine)

            task.wait(rng:NextNumber(5, 10))
        end
    end)
end

--==================================================
-- MAIN WINDOW
--==================================================

local main = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(730, 480),
    BackgroundColor3 = BG,
    BackgroundTransparency = 0.04,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 5
}, gui)

corner(main, 17)

local mainStroke = outline(main, GOLD, 0.15)
mainStroke.Thickness = 1.5

local gradient = make("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, GOLD),
        ColorSequenceKeypoint.new(0.5, PALE),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(105, 73, 33))
    }),
    Rotation = 0
}, mainStroke)

local alive = true

task.spawn(function()
    while alive and main.Parent do
        tw(gradient, 3, {Rotation = 360}, Enum.EasingStyle.Linear)
        task.wait(3)
    end
end)

local scale = make("UIScale", {Scale = 1}, main)

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then return end

    local v = camera.ViewportSize
    scale.Scale = math.clamp(
        math.min(v.X / 880, v.Y / 650),
        0.48,
        1
    )
end

updateScale()

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    updateScale()
    local camera = workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end
end)

--==================================================
-- HEADER
--==================================================

local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 78),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    ZIndex = 6
}, main)
corner(header, 17)

make("Frame", {
    Position = UDim2.new(0, 0, 1, -2),
    Size = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = GOLD,
    BorderSizePixel = 0,
    ZIndex = 7
}, header)

local logo = make("TextLabel", {
    Position = UDim2.fromOffset(23, 10),
    Size = UDim2.fromOffset(290, 35),
    BackgroundTransparency = 1,
    Text = "M E R C U R Y",
    TextColor3 = PALE,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 8
}, header)

make("TextLabel", {
    Position = UDim2.fromOffset(25, 45),
    Size = UDim2.fromOffset(280, 16),
    BackgroundTransparency = 1,
    Text = "GODLIKE EDITION  /  V4.0",
    TextColor3 = MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 8
}, header)

task.spawn(function()
    while alive and logo.Parent do
        tw(logo, 1.5, {TextColor3 = PALE})
        task.wait(1.5)
        tw(logo, 1.5, {TextColor3 = GOLD})
        task.wait(1.5)
    end
end)

local function headerButton(text, x)
    local b = make("TextButton", {
        Position = UDim2.new(1, x, 0, 21),
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = CARD,
        Text = text,
        TextColor3 = PALE,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        AutoButtonColor = false,
        ZIndex = 9
    }, header)

    corner(b, 9)

    b.MouseEnter:Connect(function()
        tw(b, 0.15, {
            BackgroundColor3 = GOLD,
            TextColor3 = BG
        })
    end)

    b.MouseLeave:Connect(function()
        tw(b, 0.15, {
            BackgroundColor3 = CARD,
            TextColor3 = PALE
        })
    end)

    return b
end

local minimize = headerButton("—", -91)
local close = headerButton("×", -47)

--==================================================
-- SIDEBAR
--==================================================

local sidebar = make("Frame", {
    Position = UDim2.fromOffset(14, 93),
    Size = UDim2.new(0, 165, 1, -107),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    ZIndex = 6
}, main)
corner(sidebar, 12)

make("TextLabel", {
    Position = UDim2.fromOffset(15, 13),
    Size = UDim2.new(1, -20, 0, 20),
    BackgroundTransparency = 1,
    Text = "NAVIGATION",
    TextColor3 = MUTED,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 7
}, sidebar)

-- Profile
local profile = make("Frame", {
    Position = UDim2.fromOffset(9, 42),
    Size = UDim2.new(1, -18, 0, 75),
    BackgroundColor3 = CARD,
    ZIndex = 7
}, sidebar)
corner(profile, 10)
outline(profile, GOLD, 0.8)

local avatar = make("ImageLabel", {
    Position = UDim2.fromOffset(9, 10),
    Size = UDim2.fromOffset(47, 47),
    BackgroundColor3 = PANEL,
    Image = "",
    ZIndex = 8
}, profile)
corner(avatar, 24)
outline(avatar, GOLD, 0.3)

task.spawn(function()
    local success, image = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)

    if success and avatar.Parent then
        avatar.Image = image
    end
end)

make("TextLabel", {
    Position = UDim2.fromOffset(64, 15),
    Size = UDim2.new(1, -70, 0, 19),
    BackgroundTransparency = 1,
    Text = player.DisplayName,
    TextColor3 = WHITE,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    ZIndex = 8
}, profile)

make("TextLabel", {
    Position = UDim2.fromOffset(64, 36),
    Size = UDim2.new(1, -70, 0, 15),
    BackgroundTransparency = 1,
    Text = "PLAYER",
    TextColor3 = GOLD,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 8
}, profile)

local nav = make("Frame", {
    Position = UDim2.fromOffset(8, 128),
    Size = UDim2.new(1, -16, 1, -138),
    BackgroundTransparency = 1,
    ZIndex = 7
}, sidebar)

make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, nav)

--==================================================
-- CONTENT
--==================================================

local content = make("Frame", {
    Position = UDim2.fromOffset(192, 93),
    Size = UDim2.new(1, -206, 1, -107),
    BackgroundTransparency = 1,
    ZIndex = 6
}, main)

local pages = {}
local tabs = {}
local currentPage
local indicator

local function createPage(name, description)
    local page = make("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = GOLD,
        CanvasSize = UDim2.new(),
        Visible = false,
        ZIndex = 6
    }, content)

    local layout = make("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(
            0, 0, 0,
            layout.AbsoluteContentSize.Y + 15
        )
    end)

    make("TextLabel", {
        Size = UDim2.new(1, -8, 0, 35),
        BackgroundTransparency = 1,
        Text = name:upper(),
        TextColor3 = PALE,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7
    }, page)

    make("TextLabel", {
        Size = UDim2.new(1, -8, 0, 22),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7
    }, page)

    pages[name] = page
    return page
end

local function notify(message)
    local toast = make("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 15, 0, 88),
        Size = UDim2.fromOffset(235, 49),
        BackgroundColor3 = CARD,
        ZIndex = 30
    }, main)
    corner(toast, 10)
    outline(toast, GOLD, 0.3)

    make("Frame", {
        Size = UDim2.new(0, 3, 1, -14),
        Position = UDim2.fromOffset(0, 7),
        BackgroundColor3 = GOLD,
        BorderSizePixel = 0,
        ZIndex = 31
    }, toast)

    make("TextLabel", {
        Position = UDim2.fromOffset(13, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = WHITE,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 31
    }, toast)

    tw(toast, 0.35, {
        Position = UDim2.new(1, -12, 0, 88)
    }, Enum.EasingStyle.Back)

    task.delay(2.5, function()
        if toast.Parent then
            tw(toast, 0.25, {
                Position = UDim2.new(1, 15, 0, 88),
                BackgroundTransparency = 1
            })
            task.wait(0.3)
            toast:Destroy()
        end
    end)
end

local function addCard(page, title, desc)
    local card = make("Frame", {
        Size = UDim2.new(1, -8, 0, 70),
        BackgroundColor3 = CARD,
        BorderSizePixel = 0,
        ZIndex = 7
    }, page)

    corner(card, 10)
    local edge = outline(card, GOLD, 0.85)

    make("TextLabel", {
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.new(1, -110, 0, 21),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    }, card)

    make("TextLabel", {
        Position = UDim2.fromOffset(14, 35),
        Size = UDim2.new(1, -110, 0, 17),
        BackgroundTransparency = 1,
        Text = desc,
        TextColor3 = MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 8
    }, card)

    card.MouseEnter:Connect(function()
        tw(card, 0.18, {
            BackgroundColor3 = Color3.fromRGB(39, 35, 28)
        })
        tw(edge, 0.18, {Transparency = 0.35})
    end)

    card.MouseLeave:Connect(function()
        tw(card, 0.18, {BackgroundColor3 = CARD})
        tw(edge, 0.18, {Transparency = 0.85})
    end)

    return card
end

local function addToggle(page, title, desc)
    local card = addCard(page, title, desc)

    local switch = make("TextButton", {
        Position = UDim2.new(1, -58, 0.5, -12),
        Size = UDim2.fromOffset(43, 24),
        BackgroundColor3 = Color3.fromRGB(55, 53, 49),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 9
    }, card)
    corner(switch, 15)

    local knob = make("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = WHITE,
        ZIndex = 10
    }, switch)
    corner(knob, 15)

    local enabled = false

    switch.MouseButton1Click:Connect(function()
        enabled = not enabled

        tw(switch, 0.2, {
            BackgroundColor3 = enabled and GOLD
                or Color3.fromRGB(55, 53, 49)
        })

        tw(knob, 0.2, {
            Position = enabled and UDim2.fromOffset(22, 3)
                or UDim2.fromOffset(3, 3)
        }, Enum.EasingStyle.Back)

        notify(title .. (enabled and " ON" or " OFF"))
    end)

    return switch
end

local function addButton(page, title, desc, label, callback)
    local card = addCard(page, title, desc)

    local button = make("TextButton", {
        Position = UDim2.new(1, -91, 0.5, -14),
        Size = UDim2.fromOffset(77, 28),
        BackgroundColor3 = GOLD,
        Text = label or "OPEN",
        TextColor3 = BG,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false,
        ZIndex = 9
    }, card)
    corner(button, 7)

    button.MouseEnter:Connect(function()
        tw(button, 0.15, {BackgroundColor3 = PALE})
    end)

    button.MouseLeave:Connect(function()
        tw(button, 0.15, {BackgroundColor3 = GOLD})
    end)

    button.MouseButton1Click:Connect(callback)
end

--==================================================
-- TABS AND SLIDING INDICATOR
--==================================================

indicator = make("Frame", {
    Size = UDim2.fromOffset(3, 38),
    Position = UDim2.fromOffset(0, 0),
    BackgroundColor3 = GOLD,
    BorderSizePixel = 0,
    ZIndex = 10
}, nav)
corner(indicator, 5)

local function addTab(name, symbol, order)
    local button = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = CARD,
        Text = "   " .. symbol .. "    " .. name,
        TextColor3 = MUTED,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        LayoutOrder = order,
        ZIndex = 8
    }, nav)
    corner(button, 8)

    tabs[name] = button

    button.MouseEnter:Connect(function()
        if currentPage ~= name then
            tw(button, 0.15, {TextColor3 = PALE})
        end
    end)

    button.MouseLeave:Connect(function()
        if currentPage ~= name then
            tw(button, 0.15, {TextColor3 = MUTED})
        end
    end)

    button.MouseButton1Click:Connect(function()
        if currentPage == name then return end

        currentPage = name

        for pageName, page in pairs(pages) do
            page.Visible = pageName == name
        end

        for pageName, tab in pairs(tabs) do
            local selected = pageName == name

            tw(tab, 0.18, {
                BackgroundColor3 = selected
                    and Color3.fromRGB(48, 39, 24) or CARD,
                TextColor3 = selected and PALE or MUTED
            })
        end

        tw(indicator, 0.22, {
            Position = UDim2.fromOffset(0, button.Position.Y.Offset)
        }, Enum.EasingStyle.Back)

        local page = pages[name]
        page.Position = UDim2.fromOffset(10, 0)
        tw(page, 0.25, {
            Position = UDim2.fromOffset(0, 0)
        })

        notify(name .. " opened")
    end)
end

--==================================================
-- BUILD PAGES
--==================================================

local home = createPage("Home", "Your personal luxury control center.")
local appearance = createPage("Appearance", "Customize your interface.")
local movement = createPage("Movement", "Visual preferences and demo settings.")
local settings = createPage("Settings", "Personal interface configuration.")

addTab("Home", "◆", 1)
addTab("Appearance", "✧", 2)
addTab("Movement", "◇", 3)
addTab("Settings", "⚙", 4)

-- Home
addCard(home, "MERCURY GODLIKE", "Premium interface • Version 4.0")
addCard(home, "PLAYER", "Welcome, " .. player.DisplayName)
addCard(home, "INTERFACE STATUS", "All visual systems operational")

addButton(home, "Notification test", "Preview the notification animation", "TEST", function()
    notify("MERCURY SYSTEM ONLINE")
end)

-- Appearance
addToggle(appearance, "Gold highlights", "Demo visual preference")
addToggle(appearance, "Particle effects", "Demo visual preference")
addToggle(appearance, "Smooth animations", "Demo visual preference")
addToggle(appearance, "Glowing borders", "Demo visual preference")

-- Movement
addToggle(movement, "Status indicators", "Visual preference only")
addToggle(movement, "Compact cards", "Visual preference only")
addToggle(movement, "Floating icon", "Visual preference only")

-- Settings
addToggle(settings, "Notifications", "Demo preference")
addToggle(settings, "Animated logo", "Demo preference")

-- Transparency slider
local transparencyCard = addCard(
    settings,
    "Window transparency",
    "Adjust the background appearance"
)
transparencyCard.Size = UDim2.new(1, -8, 0, 91)

local sliderBack = make("Frame", {
    Position = UDim2.new(0, 14, 0, 62),
    Size = UDim2.new(1, -95, 0, 5),
    BackgroundColor3 = Color3.fromRGB(62, 58, 49),
    ZIndex = 9
}, transparencyCard)
corner(sliderBack, 5)

local sliderFill = make("Frame", {
    Size = UDim2.fromScale(0.04, 1),
    BackgroundColor3 = GOLD,
    ZIndex = 10
}, sliderBack)
corner(sliderFill, 5)

local sliderKnob = make("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.04, 0, 0.5, 0),
    Size = UDim2.fromOffset(13, 13),
    BackgroundColor3 = PALE,
    ZIndex = 11
}, sliderBack)
corner(sliderKnob, 10)

local transparencyValue = make("TextLabel", {
    Position = UDim2.new(1, -65, 0, 53),
    Size = UDim2.fromOffset(50, 22),
    BackgroundTransparency = 1,
    Text = "4%",
    TextColor3 = GOLD,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    ZIndex = 10
}, transparencyCard)

local sliderDragging = false

local function setTransparency(inputX)
    local width = sliderBack.AbsoluteSize.X
    local x = math.clamp(
        (inputX - sliderBack.AbsolutePosition.X) / width,
        0,
        1
    )

    sliderFill.Size = UDim2.fromScale(x, 1)
    sliderKnob.Position = UDim2.new(x, 0, 0.5, 0)

    local value = math.floor(x * 35)
    transparencyValue.Text = value .. "%"

    main.BackgroundTransparency = value / 100
end

sliderBack.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
        setTransparency(input.Position.X)
    end
end)

sliderKnob.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        setTransparency(input.Position.X)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)

addButton(settings, "Reset interface", "Return to the Home page", "RESET", function()
    tabs.Home:Activate()
    notify("Home page restored")
end)

--==================================================
-- DRAG WINDOW
--==================================================

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)
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

--==================================================
-- FLOATING BUTTON
--==================================================

local floating = make("TextButton", {
    Position = UDim2.new(0, 20, 0.5, -27),
    Size = UDim2.fromOffset(54, 54),
    BackgroundColor3 = PANEL,
    Text = "M",
    TextColor3 = PALE,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    Visible = false,
    AutoButtonColor = false,
    ZIndex = 40
}, gui)

corner(floating, 17)
outline(floating, GOLD, 0.15)

local floatScale = make("UIScale", {Scale = 1}, floating)

task.spawn(function()
    while alive and floating.Parent do
        tw(floatScale, 1, {Scale = 1.08}, Enum.EasingStyle.Sine)
        task.wait(1)
        tw(floatScale, 1, {Scale = 1}, Enum.EasingStyle.Sine)
        task.wait(1)
    end
end)

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    floating.Visible = true
end)

floating.MouseButton1Click:Connect(function()
    floating.Visible = false
    main.Visible = true
    main.Size = UDim2.fromOffset(650, 430)

    tw(main, 0.35, {
        Size = UDim2.fromOffset(730, 480)
    }, Enum.EasingStyle.Back)
end)

close.MouseButton1Click:Connect(function()
    alive = false
    gui:Destroy()
end)

--==================================================
-- STARTUP ANIMATION
--==================================================

task.spawn(function()
    for i = 1, 100 do
        if not gui.Parent then return end
        percent.Text = i .. "%"
        task.wait(0.018)
    end

    task.wait(0.2)

    main.Visible = true
    main.Size = UDim2.fromOffset(600, 400)
    main.BackgroundTransparency = 1

    tw(main, 0.5, {
        Size = UDim2.fromOffset(730, 480),
        BackgroundTransparency = 0.04
    }, Enum.EasingStyle.Back)

    tw(loadingTitle, 0.2, {TextTransparency = 1})
    tw(loadingDesc, 0.2, {TextTransparency = 1})
    tw(barBack, 0.2, {BackgroundTransparency = 1})
    tw(percent, 0.2, {TextTransparency = 1})

    task.wait(0.3)
    loading:Destroy()

    tabs.Home:Activate()
    notify("MERCURY GODLIKE EDITION READY")
end)
