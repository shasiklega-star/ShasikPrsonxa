local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settings = {
    theme = "dark"
}

-- ============================================
-- ГЛАВНАЯ РАМКА
-- ============================================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 450, 0, 520)
frame.Position = UDim2.new(0.5, -225, 0.1, 0)
frame.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(6, 6, 20) or Color3.fromRGB(240, 240, 255)
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
border.Color = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 200)
border.Thickness = 3
border.Transparency = 0.3
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "✦ SHASIK_1488 ✦"
title.TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 0, 100)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.ZIndex = 10

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.Text = "PRISON RP | ULTIMATE EDITION"
subtitle.TextColor3 = settings.theme == "dark" and Color3.fromRGB(150, 150, 255) or Color3.fromRGB(50, 50, 150)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13
subtitle.ZIndex = 10

-- ============================================
-- КАТЕГОРИИ
-- ============================================
local categories = {"Персонаж", "Бой", "ESP", "FOV", "Настройки"}
local categoryButtons = {}
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
    btn.TextColor3 = settings.theme == "dark" and Color3.fromRGB(200, 200, 255) or Color3.fromRGB(50, 50, 150)
    btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(20, 20, 50) or Color3.fromRGB(200, 200, 230)
    btn.BackgroundTransparency = 0.3
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(categoryButtons) do
            b.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(20, 20, 50) or Color3.fromRGB(200, 200, 230)
            b.TextColor3 = settings.theme == "dark" and Color3.fromRGB(200, 200, 255) or Color3.fromRGB(50, 50, 150)
        end
        btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(40, 40, 100) or Color3.fromRGB(150, 150, 220)
        btn.TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 0, 150)
        updateContent()
    end)
    categoryButtons[i] = btn
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)
end
categoryButtons[1].BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(40, 40, 100) or Color3.fromRGB(150, 150, 220)
categoryButtons[1].TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 0, 150)

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
contentFrame.ScrollBarImageColor3 = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 200)

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================
-- СНЕГ (ПО ВСЕЙ МЕНЮШКЕ)
-- ============================================
local snowContainer = Instance.new("Frame", frame)
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.ZIndex = 0
snowContainer.ClipsDescendants = false

local snowParticles = {}
for i = 1, 120 do
    local size = math.random(2, 6)
    local particle = Instance.new("Frame", snowContainer)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
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
        p.y = p.y + p.speed * 0.005
        p.x = p.x + math.sin(tick() * p.drift) * 0.0003
        if p.y > 1 then
            p.y = -0.05
            p.x = math.random() / 2
            p.speed = 0.1 + math.random() * 0.4
            p.drift = math.random(-1, 1) * 0.08
        end
        if p.x < -0.1 then p.x = 1.1
        elseif p.x > 1.1 then p.x = -0.1 end
        p.frame.Position = UDim2.new(p.x, 0, p.y, 0)
        p.frame.BackgroundTransparency = 0.2 + math.sin(tick() * 0.5 + p.size) * 0.1
    end
end)

-- ============================================
-- ОБНОВЛЕНИЕ КОНТЕНТА
-- ============================================
function updateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if currentCategory == 5 then
        -- НАСТРОЙКИ
        local themeBtn = Instance.new("TextButton", contentFrame)
        themeBtn.Size = UDim2.new(1, 0, 0, 40)
        themeBtn.Text = settings.theme == "dark" and "🌙 Тёмная тема" or "☀️ Светлая тема"
        themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        themeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        themeBtn.BackgroundTransparency = 0.2
        themeBtn.Font = Enum.Font.GothamBold
        themeBtn.TextSize = 15
        themeBtn.BorderSizePixel = 1
        themeBtn.BorderColor3 = Color3.fromRGB(100, 100, 200)
        themeBtn.ZIndex = 10
        Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0.1, 0)
        themeBtn.MouseButton1Click:Connect(function()
            settings.theme = settings.theme == "dark" and "light" or "dark"
            themeBtn.Text = settings.theme == "dark" and "🌙 Тёмная тема" or "☀️ Светлая тема"
            frame.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(6, 6, 20) or Color3.fromRGB(240, 240, 255)
            border.Color = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 200)
            title.TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 0, 100)
            subtitle.TextColor3 = settings.theme == "dark" and Color3.fromRGB(150, 150, 255) or Color3.fromRGB(50, 50, 150)
            for _, btn in pairs(categoryButtons) do
                if btn.TextColor3 == (settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 0, 150)) then
                    btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(40, 40, 100) or Color3.fromRGB(150, 150, 220)
                else
                    btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(20, 20, 50) or Color3.fromRGB(200, 200, 230)
                    btn.TextColor3 = settings.theme == "dark" and Color3.fromRGB(200, 200, 255) or Color3.fromRGB(50, 50, 150)
                end
            end
            contentFrame.ScrollBarImageColor3 = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(100, 100, 200)
        end)
        
        local closeBtn = Instance.new("TextButton", contentFrame)
        closeBtn.Size = UDim2.new(1, 0, 0, 40)
        closeBtn.Text = "⛔ ЗАКРЫТЬ"
        closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        closeBtn.BackgroundTransparency = 0.2
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 16
        closeBtn.BorderSizePixel = 1
        closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.ZIndex = 10
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0.1, 0)
        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
        end)
    end
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 48)
end

updateContent()

-- ============================================
-- КРУГЛАЯ ИКОНКА
-- ============================================
local iconBtn = Instance.new("TextButton", game.CoreGui)
iconBtn.Size = UDim2.new(0, 60, 0, 60)
iconBtn.Position = UDim2.new(0.01, 0, 0.85, 0)
iconBtn.Text = "⚡"
iconBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
iconBtn.BackgroundColor3 = Color3.fromRGB(6, 6, 20)
iconBtn.BackgroundTransparency = 0.15
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextSize = 34
iconBtn.BorderSizePixel = 0
iconBtn.ZIndex = 999
Instance.new("UICorner", iconBtn).CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke", iconBtn)
stroke.Color = Color3.fromRGB(255, 215, 0)
stroke.Thickness = 3
stroke.Transparency = 0.2

local menuVisible = true
iconBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    iconBtn.Size = menuVisible and UDim2.new(0, 60, 0, 60) or UDim2.new(0, 50, 0, 50)
    iconBtn.Position = menuVisible and UDim2.new(0.01, 0, 0.85, 0) or UDim2.new(0.01, 0, 0.90, 0)
end)

print("✅ SHASIK_1488 МЕНЮ ЗАГРУЖЕНО!")
