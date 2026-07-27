-- ============================================
-- ULTRA MEGA CHEAT V1.0
-- by shasik_1488 | СВЕТЯЩЕЕСЯ МЕНЮ
-- ============================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- ============================================
-- СОСТОЯНИЯ
-- ============================================
local states = {
    highjump = false,
    speed = false,
    noclip = false,
    fly = false
}

local connections = {}
local speedValue = 100
local flySpeed = 75
local nc_cache = {}

-- ============================================
-- ФУНКЦИЯ ДЛЯ КРАСИВЫХ УВЕДОМЛЕНИЙ
-- ============================================
function notify(text, state)
    game.StarterGui:SetCore("SendNotification", {
        Title = "shasik_1488",
        Text = state and "✅ " .. text .. " ВКЛ" or "❌ " .. text .. " ВЫКЛ",
        Duration = 2
    })
end

-- ============================================
-- 1. ВЫСОКИЙ ПРЫЖОК (High Jump)
-- ============================================
function toggleHighJump()
    states.highjump = not states.highjump
    humanoid.JumpPower = states.highjump and 150 or 50
    notify("Высокий прыжок", states.highjump)
end

-- ============================================
-- 2. СПИДХАК С ПОЛЗУНКОМ (Speed Hack + Slider)
-- ============================================
function toggleSpeed()
    states.speed = not states.speed
    if states.speed then
        if connections.speed then connections.speed:Disconnect() end
        connections.speed = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.speed then return end
            pcall(function()
                humanoid.WalkSpeed = speedValue
            end)
        end)
    else
        if connections.speed then connections.speed:Disconnect(); connections.speed = nil end
        humanoid.WalkSpeed = 16
    end
    notify("Спидхак", states.speed)
end

function updateSpeed(value)
    speedValue = math.clamp(value, 1, 200)
    if states.speed then
        humanoid.WalkSpeed = speedValue
    end
end

-- ============================================
-- 3. МОЩНЫЙ NoClip (работает везде)
-- ============================================
function toggleNoClip()
    states.noclip = not states.noclip
    if states.noclip then
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                if nc_cache[part] == nil and part.CanCollide then
                    part.CanCollide = false
                    nc_cache[part] = true
                end
            end
        end
        notify("NoClip", true)
    else
        for part, _ in pairs(nc_cache) do
            part.CanCollide = true
        end
        nc_cache = {}
        notify("NoClip", false)
    end
end

-- ============================================
-- 4. РАБОЧИЙ FLY (для телефона и ПК)
-- ============================================
local flyBV = nil
local flyControls = nil

function toggleFly()
    states.fly = not states.fly
    if states.fly then
        notify("Fly", true)
        humanoid.PlatformStand = false
        flyBV = Instance.new("BodyVelocity", root)
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        
        -- Создаём кнопки управления для телефона
        if not flyControls then
            flyControls = Instance.new("ScreenGui", game.CoreGui)
            flyControls.Name = "FlyControls"
            flyControls.ResetOnSpawn = false
            flyControls.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            
            local function makeBtn(text, pos, color, dir)
                local btn = Instance.new("TextButton", flyControls)
                btn.Size = UDim2.new(0, 55, 0, 55)
                btn.Position = UDim2.new(0, pos.X, 0, pos.Y)
                btn.Text = text
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.BackgroundColor3 = color
                btn.Font = Enum.Font.SourceSansBold
                btn.TextSize = 22
                btn.BorderSizePixel = 2
                btn.BorderColor3 = Color3.fromRGB(200, 200, 200)
                btn.ZIndex = 10
                btn.BackgroundTransparency = 0.2
                
                local isHeld = false
                btn.MouseButton1Down:Connect(function()
                    isHeld = true
                    if states.fly and flyBV then
                        flyBV.Velocity = dir * flySpeed
                    end
                end)
                btn.MouseButton1Up:Connect(function()
                    isHeld = false
                    if states.fly and flyBV then
                        flyBV.Velocity = Vector3.new(0, 0, 0)
                    end
                end)
                btn.MouseLeave:Connect(function()
                    if isHeld then
                        isHeld = false
                        if states.fly and flyBV then
                            flyBV.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end)
                return btn
            end
            
            makeBtn("▲", Vector2.new(75, 0), Color3.fromRGB(50, 50, 80), Vector3.new(0, 0, -1))
            makeBtn("▼", Vector2.new(75, 100), Color3.fromRGB(50, 50, 80), Vector3.new(0, 0, 1))
            makeBtn("◄", Vector2.new(25, 50), Color3.fromRGB(50, 50, 80), Vector3.new(-1, 0, 0))
            makeBtn("►", Vector2.new(125, 50), Color3.fromRGB(50, 50, 80), Vector3.new(1, 0, 0))
            makeBtn("⬆", Vector2.new(75, -50), Color3.fromRGB(80, 80, 120), Vector3.new(0, 1, 0))
            makeBtn("⬇", Vector2.new(75, 150), Color3.fromRGB(80, 80, 120), Vector3.new(0, -1, 0))
        end
        flyControls.Enabled = true
        
        if connections.fly then connections.fly:Disconnect() end
        connections.fly = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.fly then
                if flyBV then flyBV:Destroy(); flyBV = nil end
                if flyControls then flyControls.Enabled = false end
                return
            end
        end)
    else
        if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyControls then flyControls.Enabled = false end
        humanoid.PlatformStand = false
        notify("Fly", false)
    end
end

-- ============================================
-- КРАСИВОЕ СВЕТЯЩЕЕСЯ МЕНЮ (NEON DESIGN)
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 520)
frame.Position = UDim2.new(0.5, -170, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 0

-- Светящаяся обводка (неон)
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 200, 255)
stroke.Thickness = 3
stroke.Transparency = 0.6

-- Градиентный фон
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 35)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 35))
})
gradient.Rotation = 45

-- Заголовок с ником
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 55)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 28
title.TextScaled = true

-- Подзаголовок
local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 55)
subtitle.Text = "PRISON RP | ULTRA EDITION"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 14

-- ============================================
-- КНОПКА СКОРОСТИ + ПОЛЗУНОК
-- ============================================
local speedToggle = Instance.new("TextButton", frame)
speedToggle.Size = UDim2.new(1, -40, 0, 40)
speedToggle.Position = UDim2.new(0, 20, 0, 95)
speedToggle.Text = "⚡ Спидхак    [❍⊃]"
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
speedToggle.Font = Enum.Font.SourceSansBold
speedToggle.TextSize = 15
speedToggle.BorderSizePixel = 1
speedToggle.BorderColor3 = Color3.fromRGB(0, 150, 255)

speedToggle.MouseButton1Click:Connect(function()
    toggleSpeed()
    if states.speed then
        speedToggle.Text = "⚡ Спидхак    [⊂❍]"
        speedToggle.TextColor3 = Color3.fromRGB(0, 255, 100)
        speedToggle.BorderColor3 = Color3.fromRGB(0, 255, 100)
        sliderFrame.Visible = true
    else
        speedToggle.Text = "⚡ Спидхак    [❍⊃]"
        speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedToggle.BorderColor3 = Color3.fromRGB(0, 150, 255)
        sliderFrame.Visible = false
        humanoid.WalkSpeed = 16
    end
end)

local sliderFrame = Instance.new("Frame", frame)
sliderFrame.Size = UDim2.new(1, -40, 0, 45)
sliderFrame.Position = UDim2.new(0, 20, 0, 140)
sliderFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
sliderFrame.Visible = false
sliderFrame.BorderSizePixel = 1
sliderFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)

local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(1, 0, 0, 20)
sliderLabel.Text = "Скорость: " .. speedValue
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Font = Enum.Font.SourceSansBold
sliderLabel.TextSize = 14

local sliderBg = Instance.new("Frame", sliderFrame)
sliderBg.Size = UDim2.new(1, 0, 0, 10)
sliderBg.Position = UDim2.new(0, 0, 0, 25)
sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
sliderBg.BorderSizePixel = 0

local sliderFill = Instance.new("Frame", sliderBg)
sliderFill.Size = UDim2.new(speedValue/200, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
sliderFill.BorderSizePixel = 0

local dragSlider = false
sliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragSlider = true
        local pos = input.Position.X - sliderBg.AbsolutePosition.X
        local value = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1) * 200
        updateSpeed(value)
        sliderFill.Size = UDim2.new(value/200, 0, 1, 0)
        sliderLabel.Text = "Скорость: " .. math.floor(value)
    end
end)
sliderBg.InputChanged:Connect(function(input)
    if dragSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = input.Position.X - sliderBg.AbsolutePosition.X
        local value = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1) * 200
        updateSpeed(value)
        sliderFill.Size = UDim2.new(value/200, 0, 1, 0)
        sliderLabel.Text = "Скорость: " .. math.floor(value)
    end
end)
sliderBg.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragSlider = false
    end
end)

-- ============================================
-- ОСТАЛЬНЫЕ КНОПКИ
-- ============================================
local btns = {
    {name = "🦘 Высокий прыжок", func = toggleHighJump, state = "highjump"},
    {name = "👻 No Clip", func = toggleNoClip, state = "noclip"},
    {name = "✈ Fly", func = toggleFly, state = "fly"}
}

for i, btn in ipairs(btns) do
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -40, 0, 40)
    b.Position = UDim2.new(0, 20, 0, 190 + (i-1)*48)
    b.Text = btn.name .. "    [❍⊃]"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 15
    b.BorderSizePixel = 1
    b.BorderColor3 = Color3.fromRGB(0, 150, 255)
    
    b.MouseButton1Click:Connect(function()
        btn.func()
        if states[btn.state] then
            b.Text = btn.name .. "    [⊂❍]"
            b.TextColor3 = Color3.fromRGB(0, 255, 100)
            b.BorderColor3 = Color3.fromRGB(0, 255, 100)
        else
            b.Text = btn.name .. "    [❍⊃]"
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
    end)
end

-- Кнопка выхода
local exitBtn = Instance.new("TextButton", frame)
exitBtn.Size = UDim2.new(1, -40, 0, 40)
exitBtn.Position = UDim2.new(0, 20, 0, 190 + #btns*48 + 10)
exitBtn.Text = "⛔ ЗАКРЫТЬ"
exitBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
exitBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 16
exitBtn.BorderSizePixel = 1
exitBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
exitBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    if flyControls then flyControls:Destroy() end
end)

print("✅ ULTRA MEGA CHEAT by shasik_1488 загружен!")
