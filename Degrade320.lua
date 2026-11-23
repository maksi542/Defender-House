
-- MERCURY GUI PRO v2
-- Roblox Studio | LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

local C = {
    bg = Color3.fromRGB(12, 11, 19),
    panel = Color3.fromRGB(20, 18, 31),
    card = Color3.fromRGB(29, 26, 43),
    purple = Color3.fromRGB(151, 88, 255),
    white = Color3.fromRGB(245, 240, 255),
    gray = Color3.fromRGB(145, 137, 160),
    green = Color3.fromRGB(100, 225, 165)
}

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(obj, radius)
    new("UICorner", {CornerRadius = UDim.new(0, radius)}, obj)
end

local function tween(obj, props, duration)
    TweenService:Create(obj,
        TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out), props):Play()
end

local gui = new("ScreenGui", {
    Name = "MercuryPro",
    ResetOnSpawn = false
}, Player:WaitForChild("PlayerGui"))

-- MAIN WINDOW
local main = new("Frame", {
    Size = UDim2.fromOffset(600, 400),
    Position = UDim2.new(0.5, -300, 0.5, -200),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, gui)
corner(main, 16)

local outline = new("UIStroke", {
    Color = C.purple,
    Transparency = 0.3,
    Thickness = 1.5
}, main)

main.Size = UDim2.fromOffset(520, 340)
tween(main, {Size = UDim2.fromOffset(600, 400)}, 0.45)

-- HEADER
local header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 65),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0
}, main)

local logo = new("TextLabel", {
    Size = UDim2.fromOffset(42, 42),
    Position = UDim2.fromOffset(16, 11),
    BackgroundColor3 = C.purple,
    Text = "M",
    TextColor3 = C.white,
    TextSize = 26,
    Font = Enum.Font.GothamBlack
}, header)
corner(logo, 11)

new("TextLabel", {
    Position = UDim2.fromOffset(70, 10),
    Size = UDim2.fromOffset(200, 28),
    BackgroundTransparency = 1,
    Text = "MERCURY",
    TextColor3 = C.white,
    TextSize = 21,
    Font = Enum.Font.GothamBlack,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

new("TextLabel", {
    Position = UDim2.fromOffset(71, 37),
    Size = UDim2.fromOffset(200, 15),
    BackgroundTransparency = 1,
    Text = "PREMIUM INTERFACE",
    TextColor3 = C.gray,
    TextSize = 9,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local close = new("TextButton", {
    Size = UDim2.fromOffset(35, 35),
    Position = UDim2.new(1, -48, 0, 15),
    BackgroundColor3 = Color3.fromRGB(65, 34, 76),
    Text = "×",
    TextColor3 = C.white,
    TextSize = 25,
    Font = Enum.Font.GothamBold
}, header)
corner(close, 9)

close.MouseButton1Click:Connect(function()
    tween(main, {Size = UDim2.fromOffset(0, 0)}, 0.25)
    task.wait(0.27)
    gui:Destroy()
end)

-- SIDEBAR
local sidebar = new("Frame", {
    Position = UDim2.fromOffset(0, 65),
    Size = UDim2.new(0, 150, 1, -65),
    BackgroundColor3 = C.panel,
    BorderSizePixel = 0
}, main)

local content = new("Frame", {
    Position = UDim2.fromOffset(165, 80),
    Size = UDim2.new(1, -180, 1, -95),
    BackgroundTransparency = 1
}, main)

local pages = {}
local buttons = {}

local function createPage(name)
    local page = new("ScrollingFrame", {
        Name = name,
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = C.purple,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false
    }, content)

    new("UIListLayout", {
        Padding = UDim.new(0, 10),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, page)

    pages[name] = page
    return page
end

local function switchPage(name)
    for n, p in pairs(pages) do
        p.Visible = n == name
    end

    for n, b in pairs(buttons) do
        tween(b, {
            BackgroundColor3 = n == name and C.purple or C.card,
            TextColor3 = n == name and C.white or C.gray
        }, 0.2)
    end
end

local function createTab(name, index)
    local button = new("TextButton", {
        Position = UDim2.fromOffset(10, 15 + (index-1)*52),
        Size = UDim2.fromOffset(130, 42),
        BackgroundColor3 = C.card,
        Text = "   " .. name,
        TextColor3 = C.gray,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false
    }, sidebar)

    corner(button, 9)
    buttons[name] = button

    button.MouseButton1Click:Connect(function()
        switchPage(name)
    end)
end

local home = createPage("Home")
local visuals = createPage("Visuals")
local settings = createPage("Settings")
local about = createPage("About")

createTab("Home", 1)
createTab("Visuals", 2)
createTab("Settings", 3)
createTab("About", 4)

switchPage("Home")

-- CARD
local function addCard(page, title, description)
    local card = new("Frame", {
        Size = UDim2.new(1, -5, 0, 75),
        BackgroundColor3 = C.card,
        BorderSizePixel = 0
    }, page)

    corner(card, 11)
    new("UIStroke", {
        Color = Color3.fromRGB(65, 52, 91),
        Transparency = 0.65,
        Thickness = 1
    }, card)

    new("TextLabel", {
        Position = UDim2.fromOffset(15, 12),
        Size = UDim2.new(1, -30, 0, 22),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = C.white,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    new("TextLabel", {
        Position = UDim2.fromOffset(15, 39),
        Size = UDim2.new(1, -30, 0, 20),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = C.gray,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    return card
end

-- SWITCH
local function addToggle(page, title, description, callback)
    local card = addCard(page, title, description)

    local switch = new("TextButton", {
        Size = UDim2.fromOffset(43, 23),
        Position = UDim2.new(1, -57, 0.5, -11),
        BackgroundColor3 = Color3.fromRGB(57, 53, 70),
        Text = "",
        AutoButtonColor = false
    }, card)
    corner(switch, 20)

    local knob = new("Frame", {
        Size = UDim2.fromOffset(17, 17),
        Position = UDim2.fromOffset(3, 3),
        BackgroundColor3 = C.white,
        BorderSizePixel = 0
    }, switch)
    corner(knob, 20)

    local enabled = false

    switch.MouseButton1Click:Connect(function()
        enabled = not enabled

        tween(switch, {
            BackgroundColor3 = enabled and C.purple
                or Color3.fromRGB(57, 53, 70)
        }, 0.2)

        tween(knob, {
            Position = enabled and UDim2.fromOffset(23, 3)
                or UDim2.fromOffset(3, 3)
        }, 0.2)

        if callback then callback(enabled) end
    end)
end

-- HOME
addCard(home, "Welcome to Mercury", "Your personal gaming interface.")
addCard(home, "Version 2.0", "Premium purple edition.")
addCard(home, "Status: Ready", "Interface successfully loaded.")

-- VISUALS
addToggle(visuals, "Visual option 1", "Example visual setting", function(value)
    print("Visual option:", value)
end)

addToggle(visuals, "Visual option 2", "Example display setting", function(value)
    print("Display option:", value)
end)

-- SETTINGS
addToggle(settings, "Animations", "Interface animations", function(value)
    print("Animations:", value)
end)

addToggle(settings, "Extra effects", "Additional interface effects", function(value)
    print("Effects:", value)
end)

-- ABOUT
addCard(about, "Mercury GUI PRO", "Created with Roblox Lua.")
addCard(about, "Developer", "Custom interface project.")
addCard(about, "Design", "Dark / Purple / Modern.")

-- DRAG WINDOW
local dragging = false
local dragStart, startPosition

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
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

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

print("MERCURY GUI PRO loaded!")
