
-- MERCURY | LUXURY EDITION 2.0
-- Visual UI prototype for Roblox Studio

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("MercuryLuxury")
if old then old:Destroy() end

local C = {
    bg = Color3.fromRGB(12, 12, 15),
    panel = Color3.fromRGB(20, 20, 24),
    card = Color3.fromRGB(27, 27, 32),
    gold = Color3.fromRGB(218, 177, 92),
    gold2 = Color3.fromRGB(255, 220, 145),
    white = Color3.fromRGB(240, 237, 229),
    muted = Color3.fromRGB(130, 127, 120),
    green = Color3.fromRGB(125, 190, 135)
}

local gui = Instance.new("ScreenGui")
gui.Name = "MercuryLuxury"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius or 10)
    }, parent)
end

local function stroke(parent, color, transparency)
    make("UIStroke", {
        Color = color or C.gold,
        Transparency = transparency or 0.5,
        Thickness = 1
    }, parent)
end

local function tween(obj, info, props)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(690, 440),
    Position = UDim2.new(0.5, -345, 0.5, -220),
    BackgroundColor3 = C.bg,
    BackgroundTransparency = 0.04,
    BorderSizePixel = 0
}, gui)
corner(main, 16)
stroke(main, C.gold, 0.25)

local scale = make("UIScale", {Scale = 0.85}, main)
local camera = workspace.CurrentCamera

local function updateScale()
    local viewport = camera.ViewportSize
    scale.Scale = math.clamp(
        math.min(viewport.X / 850, viewport.Y / 570),
        0.55, 1
    )
end

updateScale()
camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

-- Header
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 72),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0
}, main)
corner(header, 16)

make("Frame", {
    Position = UDim2.new(0, 0, 1, -2),
    Size = UDim2.new(1, 0, 0, 2),
    BackgroundColor3 = C.gold,
    BorderSizePixel = 0
}, header)

local logo = make("TextLabel", {
    Position = UDim2.fromOffset(22, 10),
    Size = UDim2.fromOffset(220, 30),
    BackgroundTransparency = 1,
    Text = "M E R C U R Y",
    TextColor3 = C.gold2,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

make("TextLabel", {
    Position = UDim2.fromOffset(24, 40),
    Size = UDim2.fromOffset(220, 18),
    BackgroundTransparency = 1,
    Text = "L U X U R Y   E D I T I O N",
    TextColor3 = C.muted,
    Font = Enum.Font.Gotham,
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local close = make("TextButton", {
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.new(1, -48, 0, 18),
    BackgroundColor3 = C.card,
    Text = "×",
    TextColor3 = C.gold2,
    Font = Enum.Font.Gotham,
    TextSize = 25,
    AutoButtonColor = false
}, header)
corner(close, 9)

local minimize = make("TextButton", {
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.new(1, -90, 0, 18),
    BackgroundColor3 = C.card,
    Text = "—",
    TextColor3 = C.gold2,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    AutoButtonColor = false
}, header)
corner(minimize, 9)

-- Sidebar
local sidebar = make("Frame", {
    Position = UDim2.fromOffset(14, 88),
    Size = UDim2.new(0, 155, 1, -104),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0
}, main)
corner(sidebar, 12)

make("TextLabel", {
    Position = UDim2.fromOffset(15, 14),
    Size = UDim2.new(1, -25, 0, 20),
    BackgroundTransparency = 1,
    Text = "NAVIGATION",
    TextColor3 = C.muted,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left
}, sidebar)

local nav = make("Frame", {
    Position = UDim2.fromOffset(8, 43),
    Size = UDim2.new(1, -16, 1, -52),
    BackgroundTransparency = 1
}, sidebar)

local navLayout = make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder
}, nav)

local content = make("Frame", {
    Position = UDim2.fromOffset(183, 88),
    Size = UDim2.new(1, -197, 1, -104),
    BackgroundTransparency = 1
}, main)

local pages = {}
local currentPage
local navButtons = {}

local function notify(message)
    local toast = make("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -15, 0, 85),
        Size = UDim2.fromOffset(225, 48),
        BackgroundColor3 = C.card,
        BackgroundTransparency = 0.05
    }, main)
    corner(toast, 10)
    stroke(toast, C.gold, 0.3)

    make("Frame", {
        Size = UDim2.new(0, 3, 1, -14),
        Position = UDim2.fromOffset(0, 7),
        BackgroundColor3 = C.gold,
        BorderSizePixel = 0
    }, toast)

    make("TextLabel", {
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -20, 1, 0),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = C.white,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, toast)

    toast.Position = UDim2.new(1, 240, 0, 85)
    tween(toast, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -15, 0, 85)
    })

    task.delay(2.2, function()
        if toast.Parent then
            tween(toast, TweenInfo.new(0.25), {
                BackgroundTransparency = 1
            })
            task.wait(0.3)
            toast:Destroy()
        end
    end)
end

local function createPage(name, subtitle)
    local page = make("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.gold,
        CanvasSize = UDim2.new()
    }, content)

    make("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    make("TextLabel", {
        Size = UDim2.new(1, -5, 0, 35),
        BackgroundTransparency = 1,
        Text = name:upper(),
        TextColor3 = C.gold2,
        Font = Enum.Font.GothamBold,
        TextSize = 19,
        TextXAlignment = Enum.TextXAlignment.Left
    }, page)

    make("TextLabel", {
        Size = UDim2.new(1, -5, 0, 23),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = C.muted,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, page)

    pages[name] = page
    return page
end

local function addCard(page, title, description)
    local card = make("Frame", {
        Size = UDim2.new(1, -8, 0, 66),
        BackgroundColor3 = C.card,
        BorderSizePixel = 0
    }, page)
    corner(card, 10)
    stroke(card, C.gold, 0.85)

    make("TextLabel", {
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.new(1, -100, 0, 20),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.white,
        Font = Enum.Font.GothamSemibold,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    make("TextLabel", {
        Position = UDim2.fromOffset(14, 33),
        Size = UDim2.new(1, -100, 0, 18),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = C.muted,
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    return card
end

local function addToggle(page, title, description)
    local card = addCard(page, title, description)

    local toggle = make("TextButton", {
        Size = UDim2.fromOffset(42, 23),
        Position = UDim2.new(1, -56, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(55, 54, 52),
        Text = "",
        AutoButtonColor = false
    }, card)
    corner(toggle, 12)

    local dot = make("Frame", {
        Size = UDim2.fromOffset(17, 17),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = C.white,
        BorderSizePixel = 0
    }, toggle)
    corner(dot, 20)

    local enabled = false
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled

        tween(toggle, TweenInfo.new(0.2), {
            BackgroundColor3 = enabled and C.gold or Color3.fromRGB(55, 54, 52)
        })

        tween(dot, TweenInfo.new(0.2), {
            Position = enabled and UDim2.fromOffset(22, 3)
                or UDim2.fromOffset(3, 3)
        })

        notify(title .. (enabled and " enabled" or " disabled"))
    end)
end

local function addButton(page, title, description, action)
    local card = addCard(page, title, description)
    local btn = make("TextButton", {
        Size = UDim2.fromOffset(72, 27),
        Position = UDim2.new(1, -85, 0.5, -13),
        BackgroundColor3 = C.gold,
        Text = "OPEN",
        TextColor3 = C.bg,
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        AutoButtonColor = false
    }, card)
    corner(btn, 7)

    btn.MouseButton1Click:Connect(action)
end

local function showPage(name)
    currentPage = name

    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end

    for pageName, button in pairs(navButtons) do
        local selected = pageName == name
        tween(button, TweenInfo.new(0.18), {
            BackgroundColor3 = selected and C.gold or C.card,
            TextColor3 = selected and C.bg or C.muted
        })
    end
end

local function addTab(name, symbol)
    local button = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = C.card,
        Text = "   " .. symbol .. "    " .. name,
        TextColor3 = C.muted,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, nav)
    corner(button, 8)

    navButtons[name] = button
    button.MouseButton1Click:Connect(function()
        showPage(name)
    end)
end

-- Pages
local home = createPage("Home", "Welcome to your personal control center.")
local visual = createPage("Appearance", "Customize the interface experience.")
local movement = createPage("Movement", "Visual demo preferences.")
local settings = createPage("Settings", "Personal interface settings.")

addTab("Home", "◆")
addTab("Appearance", "✧")
addTab("Movement", "◇")
addTab("Settings", "⚙")

-- Home content
local welcome = addCard(home, "Welcome to MERCURY", "Luxury interface • Version 2.0")
welcome.Size = UDim2.new(1, -8, 0, 85)

local status = addCard(home, "SYSTEM STATUS", "Interface is running normally")
status.Size = UDim2.new(1, -8, 0, 66)

addButton(home, "Quick notification", "Test the notification system", function()
    notify("MERCURY interface is ready")
end)

-- Appearance
addToggle(visual, "Gold accents", "Demo visual preference")
addToggle(visual, "Soft animations", "Demo animation preference")
addToggle(visual, "Compact layout", "Demo layout preference")

-- Movement: harmless UI-only demo settings
addToggle(movement, "Show movement panel", "Visual preference only")
addToggle(movement, "Show status labels", "Visual preference only")

-- Settings
addToggle(settings, "Interface sounds", "Demo preference")
addToggle(settings, "Remember selected tab", "Demo preference")

addButton(settings, "Reset interface", "Restore the Home tab", function()
    showPage("Home")
    notify("Interface reset")
end)

showPage("Home")

-- Dragging
local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Floating reopen button
local reopen = make("TextButton", {
    Size = UDim2.fromOffset(52, 52),
    Position = UDim2.new(0, 20, 0.5, -26),
    BackgroundColor3 = C.panel,
    Text = "M",
    TextColor3 = C.gold2,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    Visible = false,
    AutoButtonColor = false
}, gui)
corner(reopen, 16)
stroke(reopen, C.gold, 0.2)

minimize.MouseButton1Click:Connect(function()
    main.Visible = false
    reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
    main.Visible = true
    reopen.Visible = false
    main.Size = UDim2.fromOffset(650, 410)
    tween(main, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
        Size = UDim2.fromOffset(690, 440)
    })
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Intro animation
main.Size = UDim2.fromOffset(620, 390)
main.BackgroundTransparency = 1

tween(main, TweenInfo.new(0.45, Enum.EasingStyle.Back), {
    Size = UDim2.fromOffset(690, 440),
    BackgroundTransparency = 0.04
})

notify("MERCURY LUXURY EDITION loaded")
