local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

-- ============================================
-- МЕНЮ
-- ============================================
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

-- ============================================
-- КАТЕГОРИИ
-- ============================================
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

-- ============================================
-- КОНТЕНТ
-- ============================================
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

-- ============================================
-- СНЕГ
-- ============================================
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
        y = particle.Position.Y.Scale,
        size = size
    })
    Instance.new("UICorner", particle).CornerRadius = UDim.new(0.5, 0)
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, p in pairs(snowParticles) do
        p.y = p.y + p.speed * 0.005
        p.x = p.x + math.sin(tick() * p.drift) * 0.0003
        if p.y > 1 then
            p.y = -0.05
            p.x = math.random()
            p.speed = 0.1 + math.random() * 0.5
            p.drift = math.random(-1, 1) * 0.1
        end
        if p.x < -0.1 then p.x = 1.1
        elseif p.x > 1.1 then p.x = -0.1 end
        p.frame.Position = UDim2.new(p.x, 0, p.y, 0)
        p.frame.BackgroundTransparency = 0.1 + math.sin(tick() * 0.5 + p.size) * 0.1
    end
end)

-- ============================================
-- УЛЬТРАРЕАЛИСТИЧНАЯ ИКОНКА (С ПЕРЕДВИЖЕНИЕМ)
-- ============================================
local iconGui = Instance.new("ScreenGui", game.CoreGui)
iconGui.Name = "IconGui"
iconGui.ResetOnSpawn = false

local iconBtn = Instance.new("TextButton", iconGui)
iconBtn.Size = UDim2.new(0, 60, 0, 60)
iconBtn.Position = UDim2.new(0.01, 0, 0.85, 0)
iconBtn.Text = "⚡"
iconBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
iconBtn.BackgroundColor3 = Color3.fromRGB(6, 6, 20)
iconBtn.BackgroundTransparency = 0.1
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextSize = 34
iconBtn.BorderSizePixel = 0
iconBtn.ZIndex = 999

-- ЗАКРУГЛЕНИЕ
local corner = Instance.new("UICorner", iconBtn)
corner.CornerRadius = UDim.new(1, 0)

-- НЕОНОВАЯ ОБВОДКА
local stroke = Instance.new("UIStroke", iconBtn)
stroke.Color = Color3.fromRGB(255, 215, 0)
stroke.Thickness = 3
stroke.Transparency = 0.2

-- ВНУТРЕННЕЕ СВЕЧЕНИЕ
local glow = Instance.new("Frame", iconBtn)
glow.Size = UDim2.new(1.4, 0, 1.4, 0)
glow.Position = UDim2.new(-0.2, 0, -0.2, 0)
glow.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
glow.BackgroundTransparency = 0.85
glow.BorderSizePixel = 0
glow.ZIndex = 0
local glowCorner = Instance.new("UICorner", glow)
glowCorner.CornerRadius = UDim.new(1, 0)

-- ПУЛЬСАЦИЯ
spawn(function()
    while true do
        local t = tick() * 2
        stroke.Transparency = 0.15 + math.sin(t) * 0.15
        stroke.Color = Color3.new(1, 0.8 + math.sin(t + 0.5) * 0.15, 0)
        glow.BackgroundTransparency = 0.75 + math.sin(t + 0.3) * 0.15
        iconBtn.TextColor3 = Color3.new(1, 0.85 + math.sin(t) * 0.1, 0)
        iconBtn.Size = UDim2.new(0, 60 + math.sin(t) * 1, 0, 60 + math.sin(t) * 1)
        task.wait(0.02)
    end
end)

-- ПЕРЕДВИЖЕНИЕ ИКОНКИ (ТАЧ/МЫШЬ)
local dragging = false
local dragStart
local dragPos

iconBtn.MouseButton1Down:Connect(function()
    dragging = true
    dragStart = Vector2.new(iconBtn.Position.X.Scale, iconBtn.Position.Y.Scale)
    dragPos = uis:GetMouseLocation()
end)

uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragPos
        local newX = math.clamp(dragStart.X + delta.X / 1920, 0, 0.9)
        local newY = math.clamp(dragStart.Y + delta.Y / 1080, 0.1, 0.9)
        iconBtn.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

uis.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ПЛАВНОЕ ОТКРЫТИЕ/ЗАКРЫТИЕ
local menuAnimating = false
local menuVisible = true

iconBtn.MouseButton1Click:Connect(function()
    if menuAnimating then return end
    menuVisible = not menuVisible
    menuAnimating = true
    
    if menuVisible then
        -- РАЗВОРАЧИВАЕМ
        local targetSize = UDim2.new(0, 450, 0, 520)
        local targetPos = UDim2.new(0.5, -225, 0.1, 0)
        for i = 1, 20 do
            local t = i / 20
            local ease = t * t * (3 - 2 * t)
            frame.Size = UDim2.new(0, 450 * ease, 0, 520 * ease)
            frame.Position = UDim2.new(0.5, -225 * ease, 0.1 + 0.1 * (1 - ease), 0)
            frame.BackgroundTransparency = 0.1 * (1 - ease)
            task.wait(0.01)
        end
        frame.Size = targetSize
        frame.Position = targetPos
        frame.BackgroundTransparency = 0.1
    else
        -- СВОРАЧИВАЕМ
        for i = 1, 20 do
            local t = i / 20
            local ease = t * t * (3 - 2 * t)
            frame.Size = UDim2.new(0, 450 * (1 - ease), 0, 520 * (1 - ease))
            frame.Position = UDim2.new(0.5, -225 * (1 - ease), 0.1 + 0.1 * ease, 0)
            frame.BackgroundTransparency = 0.1 + 0.9 * ease
            task.wait(0.01)
        end
        frame.Size = UDim2.new(0, 0, 0, 0)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.BackgroundTransparency = 1
    end
    menuAnimating = false
end)

print("✅ SHASIK_1488 ЗАГРУЖЕН!")
