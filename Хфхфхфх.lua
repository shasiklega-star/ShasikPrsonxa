if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================
-- МЕНЮ
-- ============================================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 480)
frame.Position = UDim2.new(0.5, -210, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 24)
frame.BackgroundTransparency = 0.15
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 0
frame.ZIndex = 5

local glass = Instance.new("Frame", frame)
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.97
glass.BorderSizePixel = 0
glass.ZIndex = 1

local border = Instance.new("UIStroke", frame)
border.Color = Color3.fromRGB(255, 200, 50)
border.Thickness = 2
border.Transparency = 0.4

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "✦ SHASIK_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 26
title.ZIndex = 10

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0, 42)
subtitle.Text = "PRISON RP | ULTIMATE EDITION"
subtitle.TextColor3 = Color3.fromRGB(130, 130, 230)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.ZIndex = 10

-- ============================================
-- КАТЕГОРИИ
-- ============================================
local categories = {"Персонаж", "Бой", "ESP", "FOV", "Настройки"}
local catBtns = {}
local catFrame = Instance.new("Frame", frame)
catFrame.Size = UDim2.new(0.92, 0, 0, 32)
catFrame.Position = UDim2.new(0.04, 0, 0, 72)
catFrame.BackgroundTransparency = 1
catFrame.ZIndex = 10

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", catFrame)
    btn.Size = UDim2.new(0.2, -4, 1, 0)
    btn.Position = UDim2.new((i - 1) * 0.2, 2, 0, 0)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(180, 180, 240)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    btn.BackgroundTransparency = 0.4
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(catBtns) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
            b.TextColor3 = Color3.fromRGB(180, 180, 240)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 90)
        btn.TextColor3 = Color3.fromRGB(255, 200, 50)
    end)
    catBtns[i] = btn
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)
end
catBtns[1].BackgroundColor3 = Color3.fromRGB(40, 40, 90)
catBtns[1].TextColor3 = Color3.fromRGB(255, 200, 50)

-- ============================================
-- КОНТЕНТ
-- ============================================
local contentFrame = Instance.new("ScrollingFrame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -130)
contentFrame.Position = UDim2.new(0, 10, 0, 115)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 3
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ClipsDescendants = true
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 10
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 50)

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================
-- СНЕГ
-- ============================================
local snowContainer = Instance.new("Frame", frame)
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.ZIndex = 0
snowContainer.ClipsDescendants = false

local snowParticles = {}
for i = 1, 150 do
    local size = math.random(2, 5)
    local particle = Instance.new("Frame", snowContainer)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BackgroundTransparency = 0.2 + math.random() * 0.3
    particle.BorderSizePixel = 0
    particle.ZIndex = 1
    table.insert(snowParticles, {
        frame = particle,
        speed = 0.1 + math.random() * 0.4,
        drift = math.random(-1, 1) * 0.08,
        x = particle.Position.X.Scale,
        y = particle.Position.Y.Scale,
        size = size
    })
    Instance.new("UICorner", particle).CornerRadius = UDim.new(0.5, 0)
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, p in pairs(snowParticles) do
        p.y = p.y + p.speed * 0.004
        p.x = p.x + math.sin(tick() * p.drift) * 0.0002
        if p.y > 1 then
            p.y = -0.05
            p.x = math.random()
            p.speed = 0.1 + math.random() * 0.4
            p.drift = math.random(-1, 1) * 0.08
        end
        if p.x < -0.1 then p.x = 1.1
        elseif p.x > 1.1 then p.x = -0.1 end
        p.frame.Position = UDim2.new(p.x, 0, p.y, 0)
    end
end)

-- ============================================
-- ИКОНКА (УЛЬТРАРЕАЛИСТИЧНАЯ, 50х50)
-- ============================================
local iconGui = Instance.new("ScreenGui", game.CoreGui)
iconGui.Name = "IconGui"
iconGui.ResetOnSpawn = false
iconGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local iconBtn = Instance.new("TextButton", iconGui)
iconBtn.Size = UDim2.new(0, 50, 0, 50)
iconBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
iconBtn.Text = "🪐"
iconBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
iconBtn.BackgroundColor3 = Color3.fromRGB(6, 6, 20)
iconBtn.BackgroundTransparency = 0.05
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextSize = 28
iconBtn.BorderSizePixel = 0
iconBtn.ZIndex = 999
iconBtn.Active = true
iconBtn.Draggable = true

local corner = Instance.new("UICorner", iconBtn)
corner.CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke", iconBtn)
stroke.Color = Color3.fromRGB(255, 215, 0)
stroke.Thickness = 1.5
stroke.Transparency = 0.2

local glow = Instance.new("Frame", iconBtn)
glow.Size = UDim2.new(1.2, 0, 1.2, 0)
glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
glow.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
glow.BackgroundTransparency = 0.85
glow.BorderSizePixel = 0
glow.ZIndex = 0
local glowCorner = Instance.new("UICorner", glow)
glowCorner.CornerRadius = UDim.new(1, 0)

spawn(function()
    while true do
        local t = tick() * 1.5
        stroke.Transparency = 0.15 + math.sin(t) * 0.15
        stroke.Color = Color3.new(1, 0.8 + math.sin(t + 0.5) * 0.15, 0)
        glow.BackgroundTransparency = 0.75 + math.sin(t + 0.3) * 0.15
        iconBtn.TextColor3 = Color3.new(1, 0.85 + math.sin(t) * 0.1, 0)
        iconBtn.Size = UDim2.new(0, 50 + math.sin(t) * 0.5, 0, 50 + math.sin(t) * 0.5)
        task.wait(0.02)
    end
end)

-- ============================================
-- ПЛАВНОЕ ПЕРЕДВИЖЕНИЕ ПАЛЬЦЕМ
-- ============================================
local dragging = false
local dragStart
local dragPos
local currentPos = Vector2.new(0.85, 0.05)

iconBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = Vector2.new(iconBtn.Position.X.Scale, iconBtn.Position.Y.Scale)
        dragPos = input.Position
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if not dragging then return end
    local mouse = player:GetMouse()
    if not mouse then return end
    local delta = Vector2.new(mouse.X, mouse.Y) - dragPos
    local newX = math.clamp(dragStart.X + delta.X / 1920, 0.01, 0.98)
    local newY = math.clamp(dragStart.Y + delta.Y / 1080, 0.01, 0.98)
    iconBtn.Position = UDim2.new(newX, 0, newY, 0)
end)

iconBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        currentPos = Vector2.new(iconBtn.Position.X.Scale, iconBtn.Position.Y.Scale)
    end
end)

-- ============================================
-- ПЛАВНОЕ ОТКРЫТИЕ/ЗАКРЫТИЕ
-- ============================================
local menuAnimating = false
local menuVisible = true

iconBtn.MouseButton1Click:Connect(function()
    if menuAnimating then return end
    menuVisible = not menuVisible
    menuAnimating = true

    if menuVisible then
        local targetSize = UDim2.new(0, 420, 0, 480)
        local targetPos = UDim2.new(0.5, -210, 0.5, -240)
        for i = 1, 25 do
            local t = i / 25
            local ease = t * t * (3 - 2 * t)
            frame.Size = UDim2.new(0, 420 * ease, 0, 480 * ease)
            frame.Position = UDim2.new(0.5, -210 * ease, 0.5, -240 * ease)
            frame.BackgroundTransparency = 0.15 * (1 - ease)
            task.wait(0.01)
        end
        frame.Size = targetSize
        frame.Position = targetPos
        frame.BackgroundTransparency = 0.15
    else
        for i = 1, 25 do
            local t = i / 25
            local ease = t * t * (3 - 2 * t)
            frame.Size = UDim2.new(0, 420 * (1 - ease), 0, 480 * (1 - ease))
            frame.Position = UDim2.new(0.5, -210 * (1 - ease), 0.5, -240 * (1 - ease))
            frame.BackgroundTransparency = 0.15 + 0.85 * ease
            task.wait(0.01)
        end
        frame.Size = UDim2.new(0, 0, 0, 0)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.BackgroundTransparency = 1
    end
    menuAnimating = false
end)

print("✅ SHASIK_1488 ЗАГРУЖЕН!")
