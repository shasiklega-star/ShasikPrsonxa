local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

-- ОСНОВНАЯ РАМКА
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 450, 0, 520)
frame.Position = UDim2.new(0.5, -225, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(6, 6, 20)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 0
frame.ZIndex = 5

local glass = Instance.new("Frame", frame)
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.95
glass.BorderSizePixel = 0
glass.ZIndex = 1

local border = Instance.new("UIStroke", frame)
border.Color = Color3.fromRGB(255, 215, 0)
border.Thickness = 3
border.Transparency = 0.3

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "✦ SHASIK_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.ZIndex = 10

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.Text = "PRISON RP | ULTIMATE EDITION"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13
subtitle.ZIndex = 10

-- КАТЕГОРИИ
local categories = {"Персонаж", "Бой", "ESP", "FOV", "Настройки"}
local catBtns = {}
local catFrame = Instance.new("Frame", frame)
catFrame.Size = UDim2.new(0.9, 0, 0, 35)
catFrame.Position = UDim2.new(0.05, 0, 0, 80)
catFrame.BackgroundTransparency = 1
catFrame.ZIndex = 10

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", catFrame)
    btn.Size = UDim2.new(0.2, -4, 1, 0)
    btn.Position = UDim2.new((i-1)*0.2, 2, 0, 0)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
    btn.BackgroundTransparency = 0.3
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(catBtns) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
            b.TextColor3 = Color3.fromRGB(200, 200, 255)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 100)
        btn.TextColor3 = Color3.fromRGB(255, 215, 0)
    end)
    catBtns[i] = btn
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)
end
catBtns[1].BackgroundColor3 = Color3.fromRGB(40, 40, 100)
catBtns[1].TextColor3 = Color3.fromRGB(255, 215, 0)

-- КОНТЕНТ
local contentFrame = Instance.new("ScrollingFrame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -140)
contentFrame.Position = UDim2.new(0, 10, 0, 125)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ClipsDescendants = true
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 10
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 215, 0)

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- СНЕГ
local snowContainer = Instance.new("Frame", frame)
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.ZIndex = 0
snowContainer.ClipsDescendants = false

local snowParticles = {}
for i = 1, 200 do
    local size = math.random(2, 6)
    local particle = Instance.new("Frame", snowContainer)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BackgroundTransparency = 0.1 + math.random() * 0.2
    particle.BorderSizePixel = 0
    particle.ZIndex = 1
    table.insert(snowParticles, {
        frame = particle,
        speed = 0.1 + math.random() * 0.5,
        drift = math.random(-1, 1) * 0.1,
        x = particle.Position.X.Scale,
