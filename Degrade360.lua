
--====================================================
-- MERCURY X // INFINITY EDITION
-- Roblox Lua UI shell
--====================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Theme = {
    Background = Color3.fromRGB(8, 7, 15),
    Panel = Color3.fromRGB(17, 14, 28),
    Card = Color3.fromRGB(27, 21, 42),
    Purple = Color3.fromRGB(155, 83, 255),
    Pink = Color3.fromRGB(224, 104, 255),
    White = Color3.fromRGB(250, 246, 255),
    Gray = Color3.fromRGB(143, 132, 162),
    Green = Color3.fromRGB(95, 245, 174)
}

local function New(class, parent, properties)
    local object = Instance.new(class)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function Round(object, radius)
    New("UICorner", object, {
        CornerRadius = UDim.new(0, radius)
    })
end

local function Outline(object, color, transparency)
    return New("UIStroke", object, {
        Color = color,
        Transparency = transparency or 0.2,
        Thickness = 1
    })
end

local function Animate(object, properties, duration)
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

local Screen = New("ScreenGui", PlayerGui, {
    Name = "MercuryXInfinity",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999
})

-- MAIN WINDOW

local Main = New("Frame", Screen, {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(820, 530),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true
})

Round(Main, 20)
Outline(Main, Theme.Purple, 0.15)

New("UIGradient", Main, {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 17, 49)),
        ColorSequenceKeypoint.new(0.5, Theme.Background),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 10, 30))
    }),
    Rotation = 35
})

-- HEADER

local Header = New("Frame", Main, {
    Size = UDim2.new(1, 0, 0, 75),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
})

local Logo = New("Frame", Header, {
    Position = UDim2.fromOffset(18, 13),
    Size = UDim2.fromOffset(48, 48),
    BackgroundColor3 = Theme.Purple
})

Round(Logo, 14)

New("UIGradient", Logo, {
    Color = ColorSequence.new(Theme.Pink, Theme.Purple),
    Rotation = 45
})

New("TextLabel", Logo, {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "M",
    TextColor3 = Theme.White,
    TextSize = 31,
    Font = Enum.Font.GothamBlack
})

New("TextLabel", Header, {
    Position = UDim2.fromOffset(80, 12),
    Size = UDim2.fromOffset(240, 30),
    BackgroundTransparency = 1,
    Text = "MERCURY X",
    TextColor3 = Theme.White,
    TextSize = 23,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left
})

New("TextLabel", Header, {
    Position = UDim2.fromOffset(82, 42),
    Size = UDim2.fromOffset(260, 16),
    BackgroundTransparency = 1,
    Text = "I N F I N I T Y   E D I T I O N",
    TextColor3 = Theme.Gray,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

local Status = New("TextLabel", Header, {
    Position = UDim2.new(1, -157, 0, 23),
    Size = UDim2.fromOffset(95, 28),
    BackgroundColor3 = Color3.fromRGB(22, 49, 40),
    Text = "● ONLINE",
    TextColor3 = Theme.Green,
    TextSize = 10,
    Font = Enum.Font.GothamBold
})

Round(Status, 14)

-- MINIMIZE

local Minimize = New("TextButton", Header, {
    Position = UDim2.new(1, -53, 0, 19),
    Size = UDim2.fromOffset(34, 34),
    BackgroundColor3 = Theme.Card,
    Text = "−",
    TextColor3 = Theme.White,
    TextSize = 23,
    Font = Enum.Font.GothamBold
})

Round(Minimize, 10)

-- FLOATING BUTTON

local Floating = New("TextButton", Screen, {
    Position = UDim2.new(0, 25, 0.5, -25),
    Size = UDim2.fromOffset(55, 55),
    BackgroundColor3 = Theme.Purple,
    Text = "M",
    TextColor3 = Theme.White,
    TextSize = 28,
    Font = Enum.Font.GothamBlack,
    Visible = false
})

Round(Floating, 17)
Outline(Floating, Theme.Pink, 0.15)

Minimize.MouseButton1Click:Connect(function()
    Main.Visible = false
    Floating.Visible = true
end)

Floating.MouseButton1Click:Connect(function()
    Floating.Visible = false
    Main.Visible = true
end)

-- SIDEBAR

local Sidebar = New("Frame", Main, {
    Position = UDim2.fromOffset(0, 75),
    Size = UDim2.new(0, 180, 1, -75),
    BackgroundColor3 = Color3.fromRGB(13, 11, 23),
    BorderSizePixel = 0
})

New("TextLabel", Sidebar, {
    Position = UDim2.fromOffset(20, 20),
    Size = UDim2.fromOffset(130, 20),
    BackgroundTransparency = 1,
    Text = "MAIN MENU",
    TextColor3 = Theme.Gray,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

-- CONTENT

local Content = New("Frame", Main, {
    Position = UDim2.fromOffset(200, 95),
    Size = UDim2.new(1, -220, 1, -115),
    BackgroundTransparency = 1
})

local Pages = {}
local Tabs = {}
local CurrentTab

local function CreatePage(name)
    local page = New("ScrollingFrame", Content, {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Purple,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Visible = false
    })

    New("UIListLayout", page, {
        Padding = UDim.new(0, 13),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    Pages[name] = page
    return page
end

local function ChangeTab(name)
    if CurrentTab == name then return end
    CurrentTab = name

    for pageName, page in pairs(Pages) do
        page.Visible = pageName == name

        if page.Visible then
            page.Position = UDim2.fromOffset(10, 0)
            Animate(page, {
                Position = UDim2.fromOffset(0, 0)
            }, 0.22)
        end
    end

    for tabName, button in pairs(Tabs) do
        local active = tabName == name

        Animate(button, {
            BackgroundColor3 = active
                and Color3.fromRGB(72, 42, 112)
                or Theme.Card,
            TextColor3 = active and Theme.White or Theme.Gray
        })
    end
end

local function CreateTab(name, symbol, index)
    local button = New("TextButton", Sidebar, {
        Position = UDim2.fromOffset(14, 52 + (index - 1) * 53),
        Size = UDim2.fromOffset(150, 42),
        BackgroundColor3 = Theme.Card,
        Text = "   " .. symbol .. "    " .. name,
        TextColor3 = Theme.Gray,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    })

    Round(button, 10)
    Tabs[name] = button

    button.MouseButton1Click:Connect(function()
        ChangeTab(name)
    end)
end

local Home = CreatePage("Home")
local Visuals = CreatePage("Visuals")
local Movement = CreatePage("Movement")
local Utility = CreatePage("Utility")
local Config = CreatePage("Config")

CreateTab("Home", "✦", 1)
CreateTab("Visuals", "◈", 2)
CreateTab("Movement", "↗", 3)
CreateTab("Utility", "⌘", 4)
CreateTab("Config", "⚙", 5)

-- NOTIFICATION

local function Notify(title, message)
    local toast = New("Frame", Screen, {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 320, 0, 20),
        Size = UDim2.fromOffset(290, 75),
        BackgroundColor3 = Theme.Card
    })

    Round(toast, 12)
    Outline(toast, Theme.Purple, 0.25)

    New("TextLabel", toast, {
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.new(1, -25, 0, 23),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.White,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", toast, {
        Position = UDim2.fromOffset(14, 39),
        Size = UDim2.new(1, -25, 0, 20),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = Theme.Gray,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    Animate(toast, {
        Position = UDim2.new(1, -20, 0, 20)
    }, 0.35)

    task.delay(2.5, function()
        if toast.Parent then
            Animate(toast, {
                Position = UDim2.new(1, 320, 0, 20)
            }, 0.25)

            task.wait(0.3)
            toast:Destroy()
        end
    end)
end

-- SECTION HEADING

local function Heading(page, title, subtitle)
    local holder = New("Frame", page, {
        Size = UDim2.new(1, -5, 0, 68),
        BackgroundTransparency = 1
    })

    New("TextLabel", holder, {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.White,
        TextSize = 24,
        Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", holder, {
        Position = UDim2.fromOffset(1, 38),
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = Theme.Gray,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })
end

-- CARD

local function Card(page, title, description, height)
    local card = New("Frame", page, {
        Size = UDim2.new(1, -5, 0, height or 95),
        BackgroundColor3 = Theme.Card,
        BorderSizePixel = 0
    })

    Round(card, 14)
    Outline(card, Theme.Purple, 0.78)

    New("UIGradient", card, {
        Color = ColorSequence.new(
            Color3.fromRGB(43, 27, 65),
            Theme.Card
        ),
        Rotation = 20
    })

    local accent = New("Frame", card, {
        Position = UDim2.fromOffset(0, 14),
        Size = UDim2.new(0, 3, 1, -28),
        BackgroundColor3 = Theme.Purple
    })
    Round(accent, 5)

    New("TextLabel", card, {
        Position = UDim2.fromOffset(17, 14),
        Size = UDim2.new(1, -34, 0, 25),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.White,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    New("TextLabel", card, {
        Position = UDim2.fromOffset(17, 43),
        Size = UDim2.new(1, -34, 0, 35),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Theme.Gray,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    })

    return card
end

-- TOGGLE

local function Toggle(page, title, description)
    local card = Card(page, title, description, 92)

    local switch = New("TextButton", card, {
        Position = UDim2.new(1, -64, 0.5, -13),
        Size = UDim2.fromOffset(46, 26),
        BackgroundColor3 = Color3.fromRGB(52, 44, 66),
        Text = "",
        AutoButtonColor = false
    })

    Round(switch, 20)

    local knob = New("Frame", switch, {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(20, 20),
        BackgroundColor3 = Theme.White
    })
    Round(knob, 20)

    local enabled = false

    switch.MouseButton1Click:Connect(function()
        enabled = not enabled

        Animate(switch, {
            BackgroundColor3 = enabled
                and Theme.Purple
                or Color3.fromRGB(52, 44, 66)
        })

        Animate(knob, {
            Position = enabled
                and UDim2.fromOffset(23, 3)
                or UDim2.fromOffset(3, 3)
        })

        Notify(title, enabled and "Enabled" or "Disabled")
    end)
end

-- BUTTON

local function ActionButton(page, title, description, action)
    local card = Card(page, title, description, 95)

    local button = New("TextButton", card, {
        Position = UDim2.new(1, -115, 0.5, -16),
        Size = UDim2.fromOffset(95, 32),
        BackgroundColor3 = Theme.Purple,
        Text = "OPEN",
        TextColor3 = Theme.White,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    })

    Round(button, 9)

    button.MouseButton1Click:Connect(function()
        Animate(button, {
            BackgroundColor3 = Theme.Pink
        }, 0.12)

        task.wait(0.12)

        Animate(button, {
            BackgroundColor3 = Theme.Purple
        }, 0.15)

        action()
    end)
end

-- HOME

Heading(Home, "INFINITY CORE", "Welcome to the next generation of Mercury.")

local Hero = Card(
    Home,
    "ASTRAL OVERDRIVE",
    "Your interface. Your atmosphere. Your experience.",
    125
)

local Core = New("Frame", Hero, {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -65, 0.5, 0),
    Size = UDim2.fromOffset(70, 70),
    BackgroundColor3 = Theme.Purple
})

Round(Core, 50)

New("UIGradient", Core, {
    Color = ColorSequence.new(Theme.Pink, Theme.Purple),
    Rotation = 45
})

local Ring = New("Frame", Hero, {
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -65, 0.5, 0),
    Size = UDim2.fromOffset(94, 94),
    BackgroundTransparency = 1
})

Round(Ring, 50)
Outline(Ring, Theme.Pink, 0.2)

New("TextLabel", Core, {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "M",
    TextColor3 = Theme.White,
    TextSize = 34,
    Font = Enum.Font.GothamBlack
})

Card(Home, "SYSTEM STATUS", "Mercury interface initialized successfully.", 85)
Card(Home, "VISUAL ENGINE", "Astral theme / Neon purple / Glass panels.", 85)

-- VISUALS

Heading(Visuals, "VISUAL ENGINE", "Customize the appearance of your workspace.")

Toggle(Visuals, "Ambient Glow", "Example visual setting.")
Toggle(Visuals, "Particle Effects", "Example particle setting.")
Toggle(Visuals, "Neon Borders", "Example interface setting.")

-- MOVEMENT

Heading(Movement, "CONTROL CENTER", "Interface and control preferences.")

Toggle(Movement, "Compact Interface", "Example layout preference.")
Toggle(Movement, "Touch Controls", "Example control preference.")

-- UTILITY

Heading(Utility, "UTILITY HUB", "Your custom interface tools.")

ActionButton(Utility, "REFRESH INTERFACE",
    "Demo action for the UI.", function()
        Notify("MERCURY X", "Interface refreshed.")
    end)

ActionButton(Utility, "SYSTEM MESSAGE",
    "Show a sample notification.", function()
        Notify("INFINITY", "Everything is running.")
    end)

-- CONFIG

Heading(Config, "CONFIGURATION", "Personalize your interface.")

Toggle(Config, "Smooth Animations", "Example animation preference.")
Toggle(Config, "Notifications", "Example notification preference.")

Card(Config, "CURRENT PRESET", "INFINITY / PURPLE NEBULA", 85)

-- CORE ANIMATION

local elapsed = 0

local connection = RunService.RenderStepped:Connect(function(dt)
    elapsed += dt
    Ring.Rotation = elapsed * 35

    local pulse = 1 + math.sin(elapsed * 2) * 0.04
    Core.Size = UDim2.fromOffset(70 * pulse, 70 * pulse)
end)

Screen.Destroying:Connect(function()
    connection:Disconnect()
end)

-- DRAG WINDOW

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

-- STARTUP

Main.Size = UDim2.fromOffset(0, 0)

Animate(Main, {
    Size = UDim2.fromOffset(820, 530)
}, 0.5)

ChangeTab("Home")
Notify("MERCURY X", "INFINITY EDITION INITIALIZED")

print("MERCURY X // INFINITY EDITION")
