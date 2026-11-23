
-- Luau | LocalScript | Roblox Studio | StarterPlayerScripts/Mercury

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local PURPLE = Color3.fromRGB(145, 35, 255)
local DARK = Color3.fromRGB(10, 8, 19)
local PANEL = Color3.fromRGB(19, 15, 32)
local WHITE = Color3.fromRGB(240, 235, 255)

local gui = Instance.new("ScreenGui")
gui.Name = "Mercury"
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

local function corner(parent, radius)
    create("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, parent)
end

local function stroke(parent, color, thickness)
    return create("UIStroke", {
        Color = color,
        Thickness = thickness,
        Transparency = 0.15
    }, parent)
end

local function tween(obj, duration, properties)
    local info = TweenInfo.new(
        duration,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, properties)
    t:Play()
    return t
end

-- Main window

local main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(760, 470),
    Position = UDim2.new(0.5, -380, 0.5, -235),
    BackgroundColor3 = DARK,
    BorderSizePixel = 0,
    Visible = false
}, gui)

corner(main, 14)

local mainStroke = stroke(main, PURPLE, 2)

local gradient = create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 12, 45)),
        ColorSequenceKeypoint.new(1, DARK)
    }),
    Rotation = 35
}, main)

local scale = create("UIScale", {
    Scale = 0.85
}, main)

local camera = workspace.CurrentCamera

local function updateScale()
    local size = camera.ViewportSize
    scale.Scale = math.clamp(
        math.min(size.X / 820, size.Y / 530),
        0.55,
        1
    )
end

updateScale()
camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)

-- Animated border

task.spawn(function()
    while gui.Parent do
        tween(mainStroke, 1.2, {
            Color = Color3.fromRGB(210, 80, 255)
        })
        task.wait(1.2)
        tween(mainStroke, 1.2, {
            Color = Color3.fromRGB(90, 35, 255)
        })
        task.wait(1.2)
    end
end)

-- Header

local header = create("Frame", {
    Size = UDim2.new(1, 0, 0, 90),
    BackgroundTransparency = 1
}, main)

local logo = create("TextLabel", {
    Size = UDim2.fromOffset(320, 48),
    Position = UDim2.fromOffset(24, 12),
    BackgroundTransparency = 1,
    Text = "♛ MERCURY",
    TextColor3 = Color3.fromRGB(190, 115, 255),
    Font = Enum.Font.GothamBlack,
    TextSize = 34,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local subtitle = create("TextLabel", {
    Position = UDim2.fromOffset(28, 56),
    Size = UDim2.fromOffset(260, 20),
    BackgroundTransparency = 1,
    Text = "UNIVERSAL INTERFACE  •  v1.0",
    TextColor3 = Color3.fromRGB(150, 130, 180),
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local close = create("TextButton", {
    Size = UDim2.fromOffset(42, 38),
    Position = UDim2.new(1, -55, 0, 15),
    BackgroundColor3 = PANEL,
    Text = "✕",
    TextColor3 = WHITE,
    TextSize = 20,
    Font = Enum.Font.GothamBold,
    AutoButtonColor = false
}, header)

corner(close, 8)
stroke(close, PURPLE, 1)

-- Sidebar

local sidebar = create("Frame", {
    Position = UDim2.fromOffset(15, 100),
    Size = UDim2.new(0, 180, 1, -115),
    BackgroundTransparency = 1
}, main)

local tabs = {
    {"⌂", "Главная"},
    {"⚡", "Функции"},
    {"◉", "Визуал"},
    {"⚙", "Настройки"},
    {"ⓘ", "Инфо"}
}

local content = create("Frame", {
    Position = UDim2.fromOffset(210, 100),
    Size = UDim2.new(1, -225, 1, -115),
    BackgroundTransparency = 1
}, main)

local activeTab = "Главная"

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        child:Destroy()
    end
end

local function makeLabel(parent, text, position, size, fontSize)
    return create("TextLabel", {
        Position = position,
        Size = size,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = WHITE,
        TextSize = fontSize or 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, parent)
end

-- Toggle component (interface demonstration)

local function makeToggle(parent, name, description, y)
    local card = create("Frame", {
        Position = UDim2.fromOffset(0, y),
        Size = UDim2.new(1, -5, 0, 65),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0
    }, parent)

    corner(card, 9)
    stroke(card, Color3.fromRGB(65, 40, 100), 1)

    makeLabel(card, name,
        UDim2.fromOffset(15, 8),
        UDim2.new(1, -100, 0, 25), 16)

    local desc = create("TextLabel", {
        Position = UDim2.fromOffset(15, 34),
        Size = UDim2.new(1, -100, 0, 20),
        BackgroundTransparency = 1,
        Text = description,
        TextColor3 = Color3.fromRGB(155, 140, 180),
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    local button = create("TextButton", {
        Position = UDim2.new(1, -72, 0.5, -13),
        Size = UDim2.fromOffset(58, 27),
        BackgroundColor3 = Color3.fromRGB(55, 45, 70),
        Text = "",
        AutoButtonColor = false
    }, card)

    corner(button, 20)

    local knob = create("Frame", {
        Position = UDim2.fromOffset(3, 3),
        Size = UDim2.fromOffset(21, 21),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0
    }, button)

    corner(knob, 20)

    local enabled = false

    button.MouseButton1Click:Connect(function()
        enabled = not enabled

        tween(button, 0.2, {
            BackgroundColor3 = enabled
                and PURPLE
                or Color3.fromRGB(55, 45, 70)
        })

        tween(knob, 0.2, {
            Position = enabled
                and UDim2.fromOffset(34, 3)
                or UDim2.fromOffset(3, 3)
        })
    end)

    return function()
        return enabled
    end
end

-- Pages

local function showPage(page)
    activeTab = page
    clearContent()

    local title = makeLabel(
        content,
        page,
        UDim2.fromOffset(8, 0),
        UDim2.new(1, -10, 0, 35),
        25
    )

    local line = create("Frame", {
        Position = UDim2.fromOffset(8, 42),
        Size = UDim2.new(1, -15, 0, 2),
        BackgroundColor3 = PURPLE,
        BorderSizePixel = 0
    }, content)

    tween(title, 0.25, {
        TextColor3 = Color3.fromRGB(205, 155, 255)
    })

    if page == "Главная" then
        makeLabel(content,
            "Добро пожаловать в MERCURY!",
            UDim2.fromOffset(15, 75),
            UDim2.new(1, -20, 0, 40), 22)

        makeLabel(content,
            "Твой интерфейс. Твои настройки.",
            UDim2.fromOffset(15, 120),
            UDim2.new(1, -20, 0, 25), 14)

        makeLabel(content,
            "Версия: 1.0.0\nПлатформа: Roblox\nСтатус: Загружено",
            UDim2.fromOffset(15, 180),
            UDim2.new(1, -20, 0, 90), 16)

    elseif page == "Функции" then
        makeToggle(content,
            "Анимация интерфейса",
            "Включение визуальных эффектов",
            65)

        makeToggle(content,
            "Уведомления",
            "Показывать сообщения GUI",
            140)

        makeToggle(content,
            "Компактный режим",
            "Настройка отображения меню",
            215)

    elseif page == "Визуал" then
        makeToggle(content,
            "Неоновое свечение",
            "Фиолетовая подсветка интерфейса",
            65)

        makeToggle(content,
            "Плавные переходы",
            "Анимация переключения страниц",
            140)

        makeToggle(content,
            "Частицы",
            "Декоративные эффекты интерфейса",
            215)

    elseif page == "Настройки" then
        makeLabel(content,
            "Настройки Mercury",
            UDim2.fromOffset(15, 75),
            UDim2.new(1, -20, 0, 30), 18)

        makeToggle(content,
            "Звуки интерфейса",
            "Звуковые эффекты кнопок",
            125)

        makeToggle(content,
            "Подсказки",
            "Отображение подсказок",
            200)

    elseif page == "Инфо" then
        makeLabel(content,
            "MERCURY v1.0",
            UDim2.fromOffset(15, 80),
            UDim2.new(1, -20, 0, 40), 25)

        makeLabel(content,
            "Разработано на Roblox Luau.\n\n"
            .. "Интерфейс поддерживает ПК и Android.\n"
            .. "Все переключатели в этой версии демонстрационные.",
            UDim2.fromOffset(15, 130),
            UDim2.new(1, -20, 0, 130), 15)
    end
end

-- Tab buttons

for i, tab in ipairs(tabs) do
    local button = create("TextButton", {
        Position = UDim2.fromOffset(0, (i - 1) * 65),
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = PANEL,
        Text = tab[1] .. "    " .. tab[2],
        TextColor3 = WHITE,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    }, sidebar)

    corner(button, 9)
    local outline = stroke(button,
        Color3.fromRGB(65, 40, 100), 1)

    button.MouseButton1Click:Connect(function()
        for _, item in ipairs(sidebar:GetChildren()) do
            if item:IsA("TextButton") then
                tween(item, 0.15, {
                    BackgroundColor3 = PANEL
                })
            end
        end

        tween(button, 0.2, {
            BackgroundColor3 = Color3.fromRGB(65, 25, 110)
        })

        showPage(tab[2])
    end)
end

showPage("Главная")

-- Drag window

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

-- Floating open button

local openButton = create("TextButton", {
    Position = UDim2.new(0, 20, 0.5, -25),
    Size = UDim2.fromOffset(55, 55),
    BackgroundColor3 = Color3.fromRGB(45, 15, 85),
    Text = "♛",
    TextColor3 = WHITE,
    TextSize = 30,
    Font = Enum.Font.GothamBlack,
    AutoButtonColor = false
}, gui)

corner(openButton, 12)
stroke(openButton, PURPLE, 2)

-- Open / close animations

local isOpen = false
local busy = false

local function openMenu()
    if busy or isOpen then return end
    busy = true
    isOpen = true

    main.Visible = true
    main.Size = UDim2.fromOffset(700, 430)
    main.BackgroundTransparency = 1
    main.Position = UDim2.new(0.5, -350, 0.5, -215)
    scale.Scale = scale.Scale * 0.9

    tween(main, 0.35, {
        Size = UDim2.fromOffset(760, 470),
        BackgroundTransparency = 0
    })

    tween(scale, 0.35, {
        Scale = math.clamp(
            math.min(
                camera.ViewportSize.X / 820,
                camera.ViewportSize.Y / 530
            ), 0.55, 1
        )
    })

    task.wait(0.36)
    busy = false
end

local function closeMenu()
    if busy or not isOpen then return end
    busy = true
    isOpen = false

    tween(main, 0.25, {
        Size = UDim2.fromOffset(680, 420),
        BackgroundTransparency = 1
    })

    task.wait(0.27)
    main.Visible = false
    busy = false
end

openButton.MouseButton1Click:Connect(function()
    if isOpen then
        closeMenu()
    else
        openMenu()
    end
end)

close.MouseButton1Click:Connect(closeMenu)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then
            closeMenu()
        else
            openMenu()
        end
    end
end)

print("Mercury UI loaded successfully!")
