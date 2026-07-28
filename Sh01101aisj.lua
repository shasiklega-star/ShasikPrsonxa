if not game:IsLoaded() then game.Loaded:Wait() end

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settings = {
    speedValue = 100,
    flySpeed = 100
}

local states = {
    noclip = false,
    fly = false,
    speed = false
}

local connections = {}
local flyBV = nil
local flyBodyGyro = nil
local flyKeys = {w = false, a = false, s = false, d = false, space = false, shift = false}

-- ============================================
-- МЕНЮ (ШИРЕ, 500px)
-- ============================================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 520)
frame.Position = UDim2.new(0.5, -250, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(6, 6, 22)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 0
frame.ZIndex = 5

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 28)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 28))
})
gradient.Rotation = 45

local glass = Instance.new("Frame", frame)
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.97
glass.BorderSizePixel = 0
glass.ZIndex = 1

local border = Instance.new("UIStroke", frame)
border.Color = Color3.fromRGB(255, 200, 50)
border.Thickness = 2
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
subtitle.Position = UDim2.new(0, 0, 0, 47)
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
catFrame.Position = UDim2.new(0.05, 0, 0, 82)
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
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(catBtns) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
            b.TextColor3 = Color3.fromRGB(180, 180, 240)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 90)
        btn.TextColor3 = Color3.fromRGB(255, 200, 50)
        updateContent()
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
contentFrame.Size = UDim2.new(1, -20, 1, -140)
contentFrame.Position = UDim2.new(0, 10, 0, 125)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ClipsDescendants = true
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 10
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 200, 50)

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================
-- ФУНКЦИИ
-- ============================================
function notify(text, state)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "✦ SHASIK_1488 ✦",
            Text = state and "✅ " .. text .. " ВКЛ" or "❌ " .. text .. " ВЫКЛ",
            Duration = 2
        })
    end)
end

function toggleNoClip()
    states.noclip = not states.noclip
    if states.noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        if connections.noclip then connections.noclip:Disconnect() end
        connections.noclip = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.noclip then return end
            if not char or not char.Parent then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
            if root then root.CanCollide = false end
        end)
        notify("No Clip", true)
    else
        if connections.noclip then connections.noclip:Disconnect(); connections.noclip = nil end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
        notify("No Clip", false)
    end
end

function toggleFly()
    states.fly = not states.fly
    if states.fly then
        if flyBV then flyBV:Destroy() end
        if flyBodyGyro then flyBodyGyro:Destroy() end
        flyBV = Instance.new("BodyVelocity", root)
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBodyGyro = Instance.new("BodyGyro", root)
        flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBodyGyro.P = 1e6
        flyBodyGyro.CFrame = root.CFrame
        if connections.fly then connections.fly:Disconnect() end
        connections.fly = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.fly then
                if flyBV then flyBV:Destroy(); flyBV = nil end
                if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
                return
            end
            if not char or not char.Parent then return end
            if flyBodyGyro then flyBodyGyro.CFrame = root.CFrame end
            local cam = workspace.CurrentCamera
            local forward = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local up = cam.CFrame.UpVector
            local move = Vector3.new(0, 0, 0)
            if uis:IsKeyDown(Enum.KeyCode.W) then move = move + forward end
            if uis:IsKeyDown(Enum.KeyCode.S) then move = move - forward end
            if uis:IsKeyDown(Enum.KeyCode.A) then move = move - right end
            if uis:IsKeyDown(Enum.KeyCode.D) then move = move + right end
            if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + up end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - up end
            if move.Magnitude > 0 then
                flyBV.Velocity = move.Unit * settings.flySpeed
            else
                flyBV.Velocity = Vector3.new(0, 0, 0)
            end
        end)
        notify("Fly", true)
    else
        if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
        notify("Fly", false)
    end
end

function toggleSpeed()
    states.speed = not states.speed
    if states.speed then
        if connections.speed then connections.speed:Disconnect() end
        connections.speed = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.speed then return end
            if not humanoid or not humanoid.Parent then return end
            humanoid.WalkSpeed = settings.speedValue
        end)
        notify("Спидхак", true)
    else
        if connections.speed then connections.speed:Disconnect(); connections.speed = nil end
        if humanoid then humanoid.WalkSpeed = 16 end
        notify("Спидхак", false)
    end
end

-- ============================================
-- ПОЛЗУНОК
-- ============================================
function createSlider(parent, labelText, minVal, maxVal, currentVal, callback)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 1
    container.BorderColor3 = Color3.fromRGB(255, 200, 50)
    container.ZIndex = 10
    Instance.new("UICorner", container).CornerRadius = UDim.new(0.1, 0)
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = labelText .. ": " .. math.floor(currentVal)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 10
    
    local bg = Instance.new("Frame", container)
    bg.Size = UDim2.new(1, 0, 0, 12)
    bg.Position = UDim2.new(0, 0, 0, 28)
    bg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    bg.BorderSizePixel = 0
    bg.ZIndex = 10
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0.2, 0)
    
    local fill = Instance.new("Frame", bg)
    fill.Size = UDim2.new((currentVal - minVal) / (maxVal - minVal), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    fill.BorderSizePixel = 0
    fill.ZIndex = 10
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0.2, 0)
    
    local dragging = false
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = input.Position.X - bg.AbsolutePosition.X
            local value = math.clamp(pos / bg.AbsoluteSize.X, 0, 1) * (maxVal - minVal) + minVal
            callback(math.floor(value))
            label.Text = labelText .. ": " .. math.floor(value)
            fill.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
        end
    end)
    bg.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local pos = input.Position.X - bg.AbsolutePosition.X
            local value = math.clamp(pos / bg.AbsoluteSize.X, 0, 1) * (maxVal - minVal) + minVal
            callback(math.floor(value))
            label.Text = labelText .. ": " .. math.floor(value)
            fill.Size = UDim2.new((value - minVal) / (maxVal - minVal), 0, 1, 0)
        end
    end)
    bg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    return container
end

-- ============================================
-- ОБНОВЛЕНИЕ КОНТЕНТА
-- ============================================
local currentCategory = 1

function updateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if currentCategory == 1 then
        local btn1 = Instance.new("TextButton", contentFrame)
        btn1.Size = UDim2.new(1, 0, 0, 40)
        btn1.Text = states.noclip and "👻 No Clip [⊂❍]" or "👻 No Clip [❍⊃]"
        btn1.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn1.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn1.BackgroundTransparency = 0.2
        btn1.Font = Enum.Font.GothamBold
        btn1.TextSize = 15
        btn1.BorderSizePixel = 1
        btn1.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn1.MouseButton1Click:Connect(function()
            toggleNoClip()
            btn1.Text = states.noclip and "👻 No Clip [⊂❍]" or "👻 No Clip [❍⊃]"
            btn1.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn1.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn1).CornerRadius = UDim.new(0.1, 0)
        
        local btn2 = Instance.new("TextButton", contentFrame)
        btn2.Size = UDim2.new(1, 0, 0, 40)
        btn2.Text = states.fly and "✈ Fly [⊂❍]" or "✈ Fly [❍⊃]"
        btn2.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn2.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn2.BackgroundTransparency = 0.2
        btn2.Font = Enum.Font.GothamBold
        btn2.TextSize = 15
        btn2.BorderSizePixel = 1
        btn2.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn2.MouseButton1Click:Connect(function()
            toggleFly()
            btn2.Text = states.fly and "✈ Fly [⊂❍]" or "✈ Fly [❍⊃]"
            btn2.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn2.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn2).CornerRadius = UDim.new(0.1, 0)
        
        local btn3 = Instance.new("TextButton", contentFrame)
        btn3.Size = UDim2.new(1, 0, 0, 40)
        btn3.Text = states.speed and "⚡ Спидхак [⊂❍]" or "⚡ Спидхак [❍⊃]"
        btn3.TextColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn3.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn3.BackgroundTransparency = 0.2
        btn3.Font = Enum.Font.GothamBold
        btn3.TextSize = 15
        btn3.BorderSizePixel = 1
        btn3.BorderColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn3.MouseButton1Click:Connect(function()
            toggleSpeed()
            btn3.Text = states.speed and "⚡ Спидхак [⊂❍]" or "⚡ Спидхак [❍⊃]"
            btn3.TextColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn3.BorderColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn3).CornerRadius = UDim.new(0.1, 0)
        
        createSlider(contentFrame, "Скорость", 1, 200, settings.speedValue, function(value)
            settings.speedValue = value
            if states.speed and humanoid then
                humanoid.WalkSpeed = value
            end
        end)
        
        createSlider(contentFrame, "Скорость Fly", 20, 300, settings.flySpeed, function(value)
            settings.flySpeed = value
        end)
    end
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 52)
end

updateContent()

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
-- УЛЬТРАРЕАЛИСТИЧНАЯ ИКОНКА (САТУРН)
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
-- ПЕРЕДВИЖЕНИЕ ИКОНКИ
-- ============================================
local dragging = false
local dragStart
local dragPos

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
        local targetSize = UDim2.new(0, 500, 0, 520)
        local targetPos = UDim2.new(0.5, -250, 0.5, -260)
        for i = 1, 25 do
            local t = i / 25
            local ease = t * t * (3 - 2 * t)
            frame.Size = UDim2.new(0, 500 * ease, 0, 520 * ease)
            frame.Position = UDim2.new(0.5, -250 * ease, 0.5, -260 * ease)
            frame.BackgroundTransparency = 0.1 * (1 - ease)
            task.wait(0.01)
        end
        frame.Size = targetSize
        frame.Position = targetPos
        frame.BackgroundTransparency = 0.1
    else
        for i = 1, 25 do
            local t = i / 25
            local ease = t * t * (3 - 2 * t)
            frame.Size = UDim2.new(0, 500 * (1 - ease), 0, 520 * (1 - ease))
            frame.Position = UDim2.new(0.5, -250 * (1 - ease), 0.5, -260 * (1 - ease))
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
