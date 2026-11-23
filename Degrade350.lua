
--================================================
--       MERCURY X | NEBULA EDITION v4.0
--       Roblox Studio / LocalScript
--================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local C = {
    BG = Color3.fromRGB(9, 8, 16),
    Panel = Color3.fromRGB(17, 15, 27),
    Card = Color3.fromRGB(25, 22, 39),
    Purple = Color3.fromRGB(157, 91, 255),
    Violet = Color3.fromRGB(91, 48, 166),
    White = Color3.fromRGB(248, 245, 255),
    Gray = Color3.fromRGB(139, 131, 157),
    Green = Color3.fromRGB(93, 225, 157)
}

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function Corner(obj, radius)
    New("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function Stroke(obj, color, transparency)
    return New("UIStroke", {
        Color = color,
        Transparency = transparency or 0.3,
        Thickness = 1
    }, obj)
end

local function Animate(obj, props, duration)
    local t = TweenService:Create(
        obj,
        TweenInfo.new(
            duration or 0.25,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        props
    )
    t:Play()
    return t
end

-- SCREEN
local GUI = New("ScreenGui", {
    Name = "MercuryNebula",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, Player:WaitForChild("PlayerGui"))

-- MAIN
local Main = New("Frame", {
    Size = UDim2.fromOffset(750, 480),
    Position = UDim2.new(0.5, -375, 0.5, -240),
    BackgroundColor3 = C.BG,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, GUI)

Corner(Main, 17)
Stroke(Main, C.Purple, 0.15)

New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(
            0, Color3.fromRGB(31, 17, 52)
        ),
        ColorSequenceKeypoint.new(
            0.55, C.BG
        ),
        ColorSequenceKeypoint.new(
            1, Color3.fromRGB(18, 12, 34)
        )
    }),
    Rotation = 35
}, Main)

-- OPEN ANIMATION
Main.Size = UDim2.fromOffset(600, 390)
Animate(Main, {
    Size = UDim2.fromOffset(750, 480)
}, 0.45)

-- HEADER
local Header = New("Frame", {
    Size = UDim2.new(1, 0, 0, 72),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0
}, Main)

local Logo = New("Frame", {
    Size = UDim2.fromOffset(45, 45),
    Position = UDim2.fromOffset(17, 13),
    BackgroundColor3 = C.Purple
}, Header)

Corner(Logo, 12)

New("UIGradient", {
    Color = ColorSequence.new(C.Purple, C.Violet),
    Rotation = 45
}, Logo)

New("TextLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Text = "M",
    TextColor3 = C.White,
    TextSize = 29,
    Font = Enum.Font.GothamBlack
}, Logo)

New("TextLabel", {
    Position = UDim2.fromOffset(75, 12),
    Size = UDim2.fromOffset(250, 27),
    BackgroundTransparency = 1,
    Text = "MERCURY X",
    TextColor3 = C.White,
    TextSize = 22,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

New("TextLabel", {
    Position = UDim2.fromOffset(77, 40),
    Size = UDim2.fromOffset(250, 15),
    BackgroundTransparency = 1,
    Text = "NEBULA EDITION  /  V4.0",
    TextColor3 = C.Gray,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Header)

-- STATUS
local Status = New("Frame", {
    Size = UDim2.fromOffset(90, 29),
    Position = UDim2.new(1, -150, 0, 21),
    BackgroundColor3 = Color3.fromRGB(23, 46, 37)
}, Header)

Corner(Status, 15)

local Dot = New("Frame", {
    Size = UDim2.fromOffset(7, 7),
    Position = UDim2.fromOffset(11, 11),
    BackgroundColor3 = C.Green
}, Status)
Corner(Dot, 10)

New("TextLabel", {
    Position = UDim2.fromOffset(24, 0),
    Size = UDim2.fromOffset(60, 29),
    BackgroundTransparency = 1,
    Text = "ONLINE",
    TextColor3 = C.Green,
    TextSize = 10,
    Font = Enum.Font.GothamBold
}, Status)

-- CLOSE
local Close = New("TextButton", {
    Size = UDim2.fromOffset(35, 35),
    Position = UDim2.new(1, -46, 0, 18),
    BackgroundColor3 = Color3.fromRGB(70, 35, 80),
    Text = "×",
    TextColor3 = C.White,
    TextSize = 24,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, Header)

Corner(Close, 9)

-- FLOATING BUTTON
local Floating = New("TextButton", {
    Size = UDim2.fromOffset(55, 55),
    Position = UDim2.new(0, 20, 0.5, -27),
    BackgroundColor3 = C.Purple,
    Text = "M",
    TextColor3 = C.White,
    TextSize = 27,
    Font = Enum.Font.GothamBlack,
    Visible = false
}, GUI)

Corner(Floating, 17)
Stroke(Floating, C.White, 0.55)

local function Minimize()
    Main.Visible = false
    Floating.Visible = true
end

Floating.MouseButton1Click:Connect(function()
    Floating.Visible = false
    Main.Visible = true
    Main.Size = UDim2.fromOffset(650, 420)
    Animate(Main, {
        Size = UDim2.fromOffset(750, 480)
    }, 0.3)
end)

Close.MouseButton1Click:Connect(function()
    Animate(Main, {
        Size = UDim2.fromOffset(0, 0)
    }, 0.25)
    task.wait(0.3)
    GUI:Destroy()
end)

-- MINIMIZE BUTTON
local Min = New("TextButton", {
    Size = UDim2.fromOffset(35, 35),
    Position = UDim2.new(1, -88, 0, 18),
    BackgroundColor3 = C.Card,
    Text = "−",
    TextColor3 = C.White,
    TextSize = 23,
    Font = Enum.Font.GothamBold
}, Header)

Corner(Min, 9)
Min.MouseButton1Click:Connect(Minimize)

-- SIDEBAR
local Sidebar = New("Frame", {
    Position = UDim2.fromOffset(0, 72),
    Size = UDim2.new(0, 165, 1, -72),
    BackgroundColor3 = C.Panel,
    BorderSizePixel = 0
}, Main)

New("TextLabel", {
    Position = UDim2.fromOffset(18, 16),
    Size = UDim2.fromOffset(130, 20),
    BackgroundTransparency = 1,
    Text = "WORKSPACE",
    TextColor3 = C.Gray,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, Sidebar)

-- CONTENT
local Content = New("Frame", {
    Position = UDim2.fromOffset(180, 87),
    Size = UDim2.new(1, -195, 1, -105),
    BackgroundTransparency = 1
}, Main)

local Pages = {}
local Tabs = {}

local function Page(name)
    local p = New("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.Purple,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false
    }, Content)

    New("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, p)

    Pages[name] = p
    return p
end

local function Switch(name)
    for n,p in pairs(Pages) do
        p.Visible = n == name
    end

    for n,b in pairs(Tabs) do
        Animate(b, {
            BackgroundColor3 =
                n == name and C.Purple or C.Card,
            TextColor3 =
                n == name and C.White or C.Gray
        })
    end
end

local function Tab(name, icon, index)
    local b = New("TextButton", {
        Position = UDim2.fromOffset(12, 48 + (index-1)*52),
        Size = UDim2.fromOffset(140, 42),
        BackgroundColor3 = C.Card,
        Text = icon .. "    " .. name,
        TextColor3 = C.Gray,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    }, Sidebar)

    Corner(b, 10)
    Tabs[name] = b

    b.MouseButton1Click:Connect(function()
        Switch(name)
    end)
end

local Home = Page("Home")
local Visuals = Page("Visuals")
local Tools = Page("Tools")
local Settings = Page("Settings")

Tab("Home", "⌂", 1)
Tab("Visuals", "◈", 2)
Tab("Tools", "⚙", 3)
Tab("Settings", "☷", 4)

Switch("Home")

-- NOTIFICATION
local function Notify(title, message)
    local box = New("Frame", {
        Size = UDim2.fromOffset(270, 75),
        Position = UDim2.new(1, 290, 1, -100),
        BackgroundColor3 = C.Card,
        BorderSizePixel = 0
    }, GUI)

    Corner(box, 12)
    Stroke(box, C.Purple, 0.25)

    New("TextLabel", {
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.new(1, -25, 0, 23),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.White,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, box)

    New("TextLabel", {
        Position = UDim2.fromOffset(14, 38),
        Size = UDim2.new(1, -25, 0, 20),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = C.Gray,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, box)

    Animate(box, {
        Position = UDim2.new(1, -290, 1, -100)
    }, 0.35)

    task.delay(3, function()
        if box.Parent then
            Animate(box, {
                Position = UDim2.new(1, 290, 1, -100)
            }, 0.3)
            task.wait(0.35)
            box:Destroy()
        end
    end)
end

-- CARDS
local function Card(page, title, description, height)
    local card = New("Frame", {
        Size = UDim2.new(1, -5, 0, height or 85),
        BackgroundColor3 = C.Card,
        BorderSizePixel = 0
    }, page)

    Corner(card, 13)
    Stroke(card, C.Purple, 0.82)

    New("TextLabel", {
        Position = UDim2.fromOffset(17, 13),
        Size = UDim2.new(1, -34, 0, 24),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.White,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    New("TextLabel", {
        Position = UDim2.fromOffset(17, 42),
        Size = UDim2.new(1, -34, 0, 22),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = C.Gray,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    return card
end

-- TOGGLE
local function Toggle(page, title, description)
    local card = Card(page, title, description)

    local switch = New("TextButton", {
        Size = UDim2.fromOffset(45, 24),
        Position = UDim2.new(1, -60, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(53, 48, 68),
        Text = "",
        AutoButtonColor = false
    }, card)

    Corner(switch, 20)

    local knob = New("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = C.White,
        BorderSizePixel = 0
    }, switch)

    Corner(knob, 20)

    local enabled = false

    switch.MouseButton1Click:Connect(function()
        enabled = not enabled

        Animate(switch, {
            BackgroundColor3 = enabled and C.Purple
                or Color3.fromRGB(53, 48, 68)
        })

        Animate(knob, {
            Position = enabled
                and UDim2.fromOffset(24, 3)
                or UDim2.fromOffset(3, 3)
        })

        Notify(title, enabled and "Enabled" or "Disabled")
        print(title, enabled)
    end)
end

-- HOME
Card(Home,
    "WELCOME TO NEBULA",
    "Welcome to your personal Mercury workspace.",
    105
)

Card(Home,
    "ELITE EDITION",
    "Premium futuristic interface.",
    85
)

Card(Home,
    "SYSTEM STATUS",
    "All interface modules loaded.",
    85
)

-- VISUALS
Toggle(Visuals, "Visual Option 01",
    "Example visual setting.")

Toggle(Visuals, "Visual Option 02",
    "Example display setting.")

Toggle(Visuals, "Visual Option 03",
    "Example interface setting.")

-- TOOLS
Card(Tools,
    "CUSTOM WORKSPACE",
    "Add your own game tools here."
)

Toggle(Tools,
    "Interface Effects",
    "Example interface effect.")

-- SETTINGS
Toggle(Settings,
    "Animations",
    "Interface animation setting.")

Toggle(Settings,
    "Notifications",
    "Enable interface notifications.")

Card(Settings,
    "CURRENT THEME",
    "NEBULA / ELECTRIC PURPLE."
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

Notify("MERCURY X", "Nebula Edition loaded!")

print("MERCURY X NEBULA v4.0 LOADED")
