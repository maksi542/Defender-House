
--// MERCURY LUXURY 3.0
--// Animated visual interface for Roblox Studio
--// UI prototype only. No exploit functionality.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("MercuryLuxury")
if old then old:Destroy() end

local GOLD = Color3.fromRGB(226, 183, 100)
local LIGHT_GOLD = Color3.fromRGB(255, 225, 160)
local DARK = Color3.fromRGB(10, 10, 13)
local PANEL = Color3.fromRGB(19, 19, 23)
local CARD = Color3.fromRGB(27, 27, 32)
local WHITE = Color3.fromRGB(240, 238, 230)
local MUTED = Color3.fromRGB(135, 131, 122)

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    new("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function outline(obj, color, transparency)
    return new("UIStroke", {
        Color = color or GOLD,
        Transparency = transparency or 0.3,
        Thickness = 1
    }, obj)
end

local function animate(obj, duration, props, style)
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

local gui = new("ScreenGui", {
    Name = "MercuryLuxury",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

--// Background particles
local particleLayer = new("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1
}, gui)

local random = Random.new()

for i = 1, 24 do
    local size = random:NextInteger(2, 5)

    local particle = new("Frame", {
        Size = UDim2.fromOffset(size, size),
        Position = UDim2.fromScale(
            random:NextNumber(),
            random:NextNumber()
        ),
        BackgroundColor3 = GOLD,
        BackgroundTransparency = random:NextNumber(0.35, 0.75),
        BorderSizePixel = 0,
        ZIndex = 1
    }, particleLayer)

    round(particle, 10)

    task.spawn(function()
        while particle.Parent do
            local target = UDim2.fromScale(
                random:NextNumber(),
                random:NextNumber()
            )

            animate(particle, random:NextNumber(4, 9), {
                Position = target,
                BackgroundTransparency = random:NextNumber(0.3, 0.85)
            })

            task.wait(random:NextNumber(4, 9))
        end
    end)
end

--// Loading screen
local loading = new("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0,
    ZIndex = 20
}, gui)

local loadingLogo = new("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.43),
    Size = UDim2.fromOffset(400, 70),
    BackgroundTransparency = 1,
    Text = "M E R C U R Y",
    TextColor3 = LIGHT_GOLD,
    Font = Enum.Font.GothamBold,
    TextSize = 34,
    ZIndex = 21
}, loading)

local loadingSub = new("TextLabel", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.51),
    Size = UDim2.fromOffset(300, 25),
    BackgroundTransparency = 1,
    Text = "L U X U R Y   E D I T I O N",
    TextColor3 = MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    ZIndex = 21
}, loading)

local barBack = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.59),
    Size = UDim2.fromOffset(230, 4),
    BackgroundColor3 = CARD,
    BorderSizePixel = 0,
    ZIndex = 21
}, loading)
round(barBack, 5)

local bar = new("Frame", {
    Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = GOLD,
    BorderSizePixel = 0,
    ZIndex = 22
}, barBack)
round(bar, 5)

animate(bar, 2.0, {Size = UDim2.fromScale(1, 1)})

--// Main window
local main = new("Frame", {
    Name = "Main",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(700, 460),
    BackgroundColor3 = DARK,
    BackgroundTransparency = 0.03,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 3
}, gui)
round(main, 16)

local mainStroke = outline(main, GOLD, 0.15)
mainStroke.Thickness = 1.4

-- Moving gradient on the outline
local borderGradient = new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, GOLD),
        ColorSequenceKeypoint.new(0.5, LIGHT_GOLD),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 73, 37))
    }),
    Rotation = 0
}, mainStroke)

task.spawn(function()
    while main.Parent do
        animate(borderGradient, 3, {Rotation = 360}, Enum.EasingStyle.Linear)
        task.wait(3)
    end
end)

local uiScale = new("UIScale", {Scale = 1}, main)

local function resize()
    local cam = workspace.CurrentCamera
    if not cam then return end

    local v = cam.ViewportSize
    uiScale.Scale = math.clamp(
        math.min(v.X / 850, v.Y / 600),
        0.52,
        1
    )
end

resize()
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(resize)

if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
end

--// Header
local header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 76),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    ZIndex = 4
}, main)
round(header, 16)

new("Frame", {
    Position = UDim2.new(0, 0, 1, -2),
    Size = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = GOLD,
    BorderSizePixel = 0,
    ZIndex = 5
}, header)

local logo = new("TextLabel", {
    Position = UDim2.fromOffset(23, 12),
    Size = UDim2.fromOffset(270, 32),
    BackgroundTransparency = 1,
    Text = "M E R C U R Y",
    TextColor3 = LIGHT_GOLD,
    Font = Enum.Font.GothamBold,
    TextSize = 23,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5
}, header)

new("TextLabel", {
    Position = UDim2.fromOffset(25, 44),
    Size = UDim2.fromOffset(260, 16),
    BackgroundTransparency = 1,
    Text = "ULTRA ANIMATED  /  VERSION 3.0",
    TextColor3 = MUTED,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5
}, header)

-- Logo pulse
task.spawn(function()
    while logo.Parent do
        animate(logo, 1.2, {TextColor3 = LIGHT_GOLD})
        task.wait(1.2)
        animate(logo, 1.2, {TextColor3 = GOLD})
        task.wait(1.2)
    end
end)

local function headerButton(text, x)
    local b = new("TextButton", {
        Position = UDim2.new(1, x, 0, 19),
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = CARD,
        Text = text,
        TextColor3 = LIGHT_GOLD,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        AutoButtonColor = false,
        ZIndex = 6
    }, header)

    round(b, 9)

    b.MouseEnter:Connect(function()
        animate(b, 0.15, {
            BackgroundColor3 = GOLD,
            TextColor3 = DARK
        })
    end)

    b.MouseLeave:Connect(function()
        animate(b, 0.15, {
            BackgroundColor3 = CARD,
            TextColor3 = LIGHT_GOLD
        })
    end)

    return b
end

local minimize = headerButton("—", -88)
local close = headerButton("×", -46)

--// Sidebar
local sidebar = new("Frame", {
    Position = UDim2.fromOffset(14, 91),
    Size = UDim2.new(0, 158, 1, -105),
    BackgroundColor3 = PANEL,
    BorderSizePixel = 0,
    ZIndex = 4
}, main)
round(sidebar, 12)

new("TextLabel", {
    Position = UDim2.fromOffset(15, 14),
    Size = UDim2.new(1, -20, 0, 20),
    BackgroundTransparency = 1,
    Text = "MENU",
    TextColor3 = MUTED,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 5
}, sidebar)

local nav = new("Frame", {
    Position = UDim2.fromOffset(8, 44),
    Size = UDim2.new(1, -16, 1, -52),
    BackgroundTransparency = 1,
    ZIndex = 5
}, sidebar)

new("UIListLayout", {
    Padding = UDim.new(0, 8),
    SortOrder = Enum.SortOrder.LayoutOrder
}, nav)

--// Content
local content = new("Frame", {
    Position = UDim2.fromOffset(185, 91),
    Size = UDim2.new(1, -199, 1, -105),
    BackgroundTransparency = 1,
    ZIndex = 4
}, main)

local pages = {}
local navButtons = {}
local currentPage

local function notify(message)
    local toast = new("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 15, 0, 85),
        Size = UDim2.fromOffset(230, 48),
        BackgroundColor3 = CARD,
        ZIndex = 15
    }, main)
    round(toast, 10)
    outline(toast, GOLD, 0.25)

    new("TextLabel", {
        Position = UDim2.fromOffset(12, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = WHITE,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 16
    }, toast)

    animate(toast, 0.35, {
        Position = UDim2.new(1, -12, 0, 85)
    }, Enum.EasingStyle.Back)

    task.delay(2.5, function()
        if toast.Parent then
            animate(toast, 0.25, {
                Position = UDim2.new(1, 15, 0, 85),
                BackgroundTransparency = 1
            })
            task.wait(0.3)
            toast:Destroy()
        end
    end)
end

local function createPage(name, description)
    local page = new("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = GOLD,
        CanvasSize = UDim2.new(),
        Visible = false,
        ZIndex = 4
    }, content)

    local layout = new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 15)
    end)

    new("TextLabel", {
        Size = UDim2.new(1, -8, 0, 35),
        BackgroundTransparency = 1,
        Text = name:upper(),
        TextColor3 = LIGHT_GOLD,
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5
    }, page)

    new("TextLabel", {
        Size = UDim2.new(1, -8, 0, 22),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5
    }, page)

    pages[name] = page
    return page
end

local function addCard(page, title, desc)
    local card = new("Frame", {
        Size = UDim2.new(1, -8, 0, 69),
        BackgroundColor3 = CARD,
        BorderSizePixel = 0,
        ZIndex = 5
    }, page)

    round(card, 10)
    local edge = outline(card, GOLD, 0.88)

    local titleLabel = new("TextLabel", {
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.new(1, -110, 0, 21),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = WHITE,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    }, card)

    new("TextLabel", {
        Position = UDim2.fromOffset(14, 35),
        Size = UDim2.new(1, -110, 0, 17),
        BackgroundTransparency = 1,
        Text = desc,
        TextColor3 = MUTED,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 6
    }, card)

    card.MouseEnter:Connect(function()
        animate(card, 0.18, {
            BackgroundColor3 = Color3.fromRGB(38, 35, 29)
        })
        animate(edge, 0.18, {Transparency = 0.35})
    end)

    card.MouseLeave:Connect(function()
        animate(card, 0.18, {BackgroundColor3 = CARD})
        animate(edge, 0.18, {Transparency = 0.88})
    end)

    return card
end

local function addToggle(page, title, desc)
    local card = addCard(page, title, desc)

    local switch = new("TextButton", {
        Position = UDim2.new(1, -58, 0.5, -12),
        Size = UDim2.fromOffset(43, 24),
        BackgroundColor3 = Color3.fromRGB(55, 53, 49),
        Text = "",
        AutoButtonColor = false,
        ZIndex = 7
    }, card)
    round(switch, 15)

    local knob = new("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = WHITE,
        ZIndex = 8
    }, switch)
    round(knob, 15)

    local enabled = false

    switch.MouseButton1Click:Connect(function()
        enabled = not enabled

        animate(switch, 0.2, {
            BackgroundColor3 = enabled and GOLD
                or Color3.fromRGB(55, 53, 49)
        })

        animate(knob, 0.2, {
            Position = enabled and UDim2.fromOffset(22, 3)
                or UDim2.fromOffset(3, 3)
        }, Enum.EasingStyle.Back)

        notify(title .. (enabled and " ON" or " OFF"))
    end)
end

local function addAction(page, title, desc, callback)
    local card = addCard(page, title, desc)

    local button = new("TextButton", {
        Position = UDim2.new(1, -87, 0.5, -14),
        Size = UDim2.fromOffset(73, 28),
        BackgroundColor3 = GOLD,
        Text = "OPEN",
        TextColor3 = DARK,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false,
        ZIndex = 7
    }, card)
    round(button, 7)

    button.MouseEnter:Connect(function()
        animate(button, 0.15, {
            BackgroundColor3 = LIGHT_GOLD
        })
    end)

    button.MouseLeave:Connect(function()
        animate(button, 0.15, {
            BackgroundColor3 = GOLD
        })
    end)

    button.MouseButton1Click:Connect(callback)
end

--// Animated page indicator
local indicator = new("Frame", {
    Size = UDim2.fromOffset(3, 38),
    BackgroundColor3 = GOLD,
    BorderSizePixel = 0,
    ZIndex = 8
}, nav)
round(indicator, 5)

local function addTab(name, symbol, order)
    local button = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = CARD,
        Text = "   " .. symbol .. "    " .. name,
        TextColor3 = MUTED,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
        LayoutOrder = order,
        ZIndex = 6
    }, nav)
    round(button, 8)

    navButtons[name] = button

    button.MouseEnter:Connect(function()
        if currentPage ~= name then
            animate(button, 0.15, {
                TextColor3 = LIGHT_GOLD
            })
        end
    end)

    button.MouseLeave:Connect(function()
        if currentPage ~= name then
            animate(button, 0.15, {
                TextColor3 = MUTED
            })
        end
    end)

    button.MouseButton1Click:Connect(function()
        if currentPage == name then return end

        currentPage = name

        for pageName, page in pairs(pages) do
            page.Visible = pageName == name
        end

        for pageName, tab in pairs(navButtons) do
            animate(tab, 0.18, {
                BackgroundColor3 = pageName == name and
                    Color3.fromRGB(48, 39, 24) or CARD,
                TextColor3 = pageName == name and LIGHT_GOLD or MUTED
            })
        end

        indicator.Position = UDim2.fromOffset(
            0,
            button.Position.Y.Offset
        )

        local page = pages[name]
        page.Position = UDim2.fromOffset(12, 0)
        page.Visible = true

        animate(page, 0.25, {
            Position = UDim2.fromOffset(0, 0)
        })

        notify(name .. " opened")
    end)
end

--// Create pages
local home = createPage("Home", "Welcome to your luxury control center.")
local visual = createPage("Appearance", "Customize your interface.")
local movement = createPage("Movement", "Visual demonstration preferences.")
local settings = createPage("Settings", "Interface configuration.")

addTab("Home", "◆", 1)
addTab("Appearance", "✧", 2)
addTab("Movement", "◇", 3)
addTab("Settings", "⚙", 4)

-- Home
addCard(home, "MERCURY LUXURY", "Premium interface • Version 3.0")
addCard(home, "STATUS", "All interface systems operational")
addAction(home, "Test animation", "Preview a notification", function()
    notify("Animation system activated")
end)

-- Appearance
addToggle(visual, "Gold glow", "Demo interface preference")
addToggle(visual, "Particle effects", "Demo interface preference")
addToggle(visual, "Smooth transitions", "Demo interface preference")
addToggle(visual, "Compact cards", "Demo interface preference")

-- Movement: UI-only preferences
addToggle(movement, "Movement panel", "Visual preference only")
addToggle(movement, "Status indicators", "Visual preference only")

-- Settings
addToggle(settings, "Interface notifications", "Demo preference")
addToggle(settings, "Animated borders", "Demo preference")
addAction(settings, "Return Home", "Open the main page", function()
    navButtons.Home:Activate()
end)

--// Drag window
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

--// Floating reopen button
local reopen = new("TextButton", {
    Position = UDim2.new(0, 20, 0.5, -26),
    Size = UDim2.fromOffset(52, 52),
    BackgroundColor3 = PANEL,
    Text = "M",
    TextColor3 = LIGHT_GOLD,
    Font = Enum.Font.GothamBold,
    TextSize = 23,
    Visible = false,
    AutoButtonColor = false,
    ZIndex = 10
}, gui)
round(reopen, 16)
outline(reopen, GOLD, 0.15)

local function openMenu()
    main.Visible = true
    reopen.Visible = false
    main.Size = UDim2.fromOffset(620, 410)
    animate(main, 0.35, {
        Size = UDim2.fromOffset(700, 460)
    }, Enum.EasingStyle.Back)
end

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(openMenu)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

--// Loading finished
task.wait(2.1)

main.Visible = true
main.Size = UDim2.fromOffset(610, 400)
main.BackgroundTransparency = 1

animate(main, 0.45, {
    Size = UDim2.fromOffset(700, 460),
    BackgroundTransparency = 0.03
}, Enum.EasingStyle.Back)

animate(loadingLogo, 0.25, {
    TextTransparency = 1
})
animate(loadingSub, 0.25, {
    TextTransparency = 1
})
animate(barBack, 0.25, {
    BackgroundTransparency = 1
})

task.wait(0.3)
loading:Destroy()

navButtons.Home:Activate()
notify("MERCURY LUXURY 3.0 READY")
