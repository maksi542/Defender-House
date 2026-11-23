
-- MERCURY GUI
-- Version 1.0
-- Roblox Studio / LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local Purple = Color3.fromRGB(145, 85, 255)
local Background = Color3.fromRGB(17, 17, 24)
local Panel = Color3.fromRGB(25, 25, 35)
local White = Color3.fromRGB(240, 240, 255)

local gui = Instance.new("ScreenGui")
gui.Name = "MercuryGUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

-- Main window
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(600, 400)
main.Position = UDim2.new(0.5, -300, 0.5, -200)
main.BackgroundColor3 = Background
main.BorderSizePixel = 0
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Purple
stroke.Thickness = 1.5
stroke.Parent = main

-- Animation
main.Size = UDim2.fromOffset(0, 0)

TweenService:Create(main, TweenInfo.new(
    0.5,
    Enum.EasingStyle.Back,
    Enum.EasingDirection.Out
), {
    Size = UDim2.fromOffset(600, 400)
}):Play()

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 55)
header.BackgroundColor3 = Panel
header.BorderSizePixel = 0
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -110, 1, 0)
title.Position = UDim2.fromOffset(20, 0)
title.BackgroundTransparency = 1
title.Text = "MERCURY"
title.TextColor3 = Purple
title.TextSize = 23
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(35, 35)
close.Position = UDim2.new(1, -45, 0, 10)
close.Text = "×"
close.TextSize = 25
close.TextColor3 = White
close.BackgroundColor3 = Color3.fromRGB(65, 35, 75)
close.Parent = header
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

close.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(main, TweenInfo.new(0.3), {
        Size = UDim2.fromOffset(0, 0)
    })
    tween:Play()
    tween.Completed:Wait()
    gui:Destroy()
end)

-- Sidebar
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromOffset(145, 345)
sidebar.Position = UDim2.fromOffset(0, 55)
sidebar.BackgroundColor3 = Panel
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local pages = Instance.new("Frame")
pages.Size = UDim2.new(1, -165, 1, -75)
pages.Position = UDim2.fromOffset(155, 65)
pages.BackgroundTransparency = 1
pages.Parent = main

local pageNames = {"Home", "Visuals", "Settings", "About"}
local pageFrames = {}

for _, name in ipairs(pageNames) do
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = pages
    pageFrames[name] = page

    local button = Instance.new("TextButton")
    button.Size = UDim2.fromOffset(125, 42)
    button.Position = UDim2.fromOffset(10, 15 + (_ - 1) * 52)
    button.BackgroundColor3 = Background
    button.Text = "  " .. name
    button.TextColor3 = White
    button.TextSize = 15
    button.Font = Enum.Font.GothamMedium
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Parent = sidebar

    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

    button.MouseButton1Click:Connect(function()
        for _, frame in pairs(pageFrames) do
            frame.Visible = false
        end
        page.Visible = true

        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = Purple
        }):Play()

        for _, other in pairs(sidebar:GetChildren()) do
            if other:IsA("TextButton") and other ~= button then
                other.BackgroundColor3 = Background
            end
        end
    end)
end

pageFrames.Home.Visible = true

-- Text helper
local function addText(page, text, y)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 40)
    label.Position = UDim2.fromOffset(10, y)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = White
    label.TextSize = 19
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = page
end

addText(pageFrames.Home, "Welcome to Mercury!", 15)
addText(pageFrames.Home, "Your custom interface is ready.", 60)

addText(pageFrames.Visuals, "Visual Settings", 15)
addText(pageFrames.Settings, "GUI Settings", 15)
addText(pageFrames.About, "Mercury GUI v1.0", 15)
addText(pageFrames.About, "Created with Lua", 60)

print("Mercury GUI loaded!")
