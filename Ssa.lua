-- ============================================
-- PRISON RP ULTIMATE v3.0 (FULL WORKING)
-- by shasik_1488 | FOR MOBILE + PC
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- ============================================
-- ОБХОД АНТИЧИТА
-- ============================================
pcall(function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            if v.Name:lower():find("anticheat") or v.Name:lower():find("anti") or v.Name:lower():find("detect") or v.Name:lower():find("cheat") then
                v.Disabled = true
            end
        end
        if v:IsA("RemoteEvent") and v.Name:lower():find("anti") then
            v:Destroy()
        end
    end
    if getgenv then
        getgenv().detected = false
        getgenv().secure = true
    end
    pcall(function()
        game:GetService("ReplicatedStorage"):FindFirstChild("Ping"):Destroy()
        game:GetService("ReplicatedStorage"):FindFirstChild("AntiCheat"):Destroy()
    end)
    for _, v in pairs(game.CoreGui:GetDescendants()) do
        if v:IsA("ScreenGui") and v.Name:lower():find("anti") then
            v:Destroy()
        end
    end
end)

-- ============================================
-- СОСТОЯНИЯ
-- ============================================
local states = {
    godmode = false,
    speed = false,
    noclip = false,
    fly = false,
    universal = false,
    antiafk = false,
    invisible = false
}

local connections = {}
local speedValue = 100

-- ============================================
-- УВЕДОМЛЕНИЯ
-- ============================================
function notify(title, state)
    game.StarterGui:SetCore("SendNotification", {
        Title = "PRISON RP",
        Text = state and "✅ " .. title .. " ВКЛ" or "❌ " .. title .. " ВЫКЛ",
        Duration = 2
    })
end

-- ============================================
-- БЕССМЕРТИЕ
-- ============================================
function tGodmode()
    states.godmode = not states.godmode
    if states.godmode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        if connections.god then connections.god:Disconnect() end
        connections.god = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.godmode then return end
            pcall(function()
                if humanoid.Health < 999999 then humanoid.Health = math.huge end
                humanoid.MaxHealth = math.huge
            end)
        end)
    else
        if connections.god then connections.god:Disconnect(); connections.god = nil end
        pcall(function()
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end)
    end
    notify("Бессмертие", states.godmode)
end

-- ============================================
-- СКОРОСТЬ
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
    notify("Скорость", states.speed)
end

function updateSpeed(value)
    speedValue = math.clamp(value, 1, 200)
    if states.speed then
        humanoid.WalkSpeed = speedValue
    end
end

-- ============================================
-- NO CLIP
-- ============================================
function tNoClip()
    states.noclip = not states.noclip
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not states.noclip
        end
    end
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not states.noclip
        end
    end
    notify("No Clip", states.noclip)
end

-- ============================================
-- FLY (ДЛЯ ТЕЛЕФОНА + ПК)
-- ============================================
local flyActive = false
local flyBV = nil
local flyBG = nil
local flySpeed = 50

function toggleFly()
    states.fly = not states.fly
    if states.fly then
        notify("Fly", true)
        humanoid.PlatformStand = true
        
        flyBV = Instance.new("BodyVelocity", root)
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        
        flyBG = Instance.new("BodyGyro", root)
        flyBG.P = 9e4
        flyBG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        flyBG.cframe = root.CFrame
        
        -- Управление с мобильных кнопок (будет ниже)
    else
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBG then flyBG:Destroy(); flyBG = nil end
        humanoid.PlatformStand = false
        notify("Fly", false)
    end
end

-- ============================================
-- УНИВЕРСАЛЬНЫЕ ДВЕРИ
-- ============================================
function tUniversalDoors()
    states.universal = not states.universal
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (
            obj.Name:lower():find("door") or
            obj.Name:lower():find("gate") or
            obj.Name:lower():find("cell") or
            obj.Name:lower():find("entrance") or
            obj.Name:lower():find("exit") or
            obj.Name:lower():find("window") or
            obj.Name:lower():find("barrier") or
            obj.Name:lower():find("fence")
        ) then
            pcall(function()
                obj.CanCollide = not states.universal
                obj.Transparency = states.universal and 0.5 or 0
                if obj.Parent and obj.Parent:FindFirstChild("ClickDetector") then
                    fireclickdetector(obj.Parent:FindFirstChild("ClickDetector"))
                end
            end)
        end
    end
    notify("Универсальные двери", states.universal)
end

-- ============================================
-- НЕВИДИМОСТЬ (ПОЛНАЯ)
-- ============================================
function tInvisible()
    states.invisible = not states.invisible
    if states.invisible then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        for _, v in pairs(character:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then
                v:Destroy()
            end
        end
        if character:FindFirstChild("DisplayName") then
            character.DisplayName.Text = ""
        end
        root.LocalTransparencyModifier = 1
        notify("Невидимость", true)
    else
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        if character:FindFirstChild("DisplayName") then
            character.DisplayName.Text = player.Name
        end
        root.LocalTransparencyModifier = 0
        notify("Невидимость", false)
    end
end

-- ============================================
-- АНТИ-АФК
-- ============================================
function tAntiAFK()
    states.antiafk = not states.antiafk
    if states.antiafk then
        if connections.afk then connections.afk:Disconnect() end
        connections.afk = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.antiafk then return end
            humanoid.MoveTo(root.Position + Vector3.new(0, 0, 0.1))
        end)
    else
        if connections.afk then connections.afk:Disconnect(); connections.afk = nil end
    end
    notify("Анти-АФК", states.antiafk)
end

-- ============================================
-- ПОЛНОЕ МЕНЮ (СРАЗУ ОТКРЫВАЕТСЯ)
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 520)
frame.Position = UDim2.new(0.5, -160, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
frame.BackgroundTransparency = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.Text = "PRISON RP | ULTIMATE"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 14

-- ============================================
-- КНОПКА СКОРОСТИ + ПОЛЗУНОК
-- ============================================
local speedToggle = Instance.new("TextButton", frame)
speedToggle.Size = UDim2.new(1, -40, 0, 35)
speedToggle.Position = UDim2.new(0, 20, 0, 90)
speedToggle.Text = "⚡ Скорость    [❍⊃]"
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedToggle.Font = Enum.Font.SourceSansBold
speedToggle.TextSize = 14
speedToggle.BorderSizePixel = 0

speedToggle.MouseButton1Click:Connect(function()
    toggleSpeed()
    if states.speed then
        speedToggle.Text = "⚡ Скорость    [⊂❍]"
        speedToggle.TextColor3 = Color3.fromRGB(0, 255, 100)
        sliderFrame.Visible = true
    else
        speedToggle.Text = "⚡ Скорость    [❍⊃]"
        speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderFrame.Visible = false
        humanoid.WalkSpeed = 16
    end
end)

local sliderFrame = Instance.new("Frame", frame)
sliderFrame.Size = UDim2.new(1, -40, 0, 40)
sliderFrame.Position = UDim2.new(0, 20, 0, 130)
sliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
sliderFrame.Visible = false
sliderFrame.BorderSizePixel = 0

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
sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
sliderBg.BorderSizePixel = 0

local sliderFill = Instance.new("Frame", sliderBg)
sliderFill.Size = UDim2.new(speedValue/200, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
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
    {name = "❤ Бессмертие", func = tGodmode, state = "godmode"},
    {name = "👻 No Clip", func = tNoClip, state = "noclip"},
    {name = "✈ Fly", func = toggleFly, state = "fly"},
    {name = "🚪 Универсальные двери", func = tUniversalDoors, state = "universal"},
    {name = "👀 Невидимость", func = tInvisible, state = "invisible"},
    {name = "🔒 Анти-АФК", func = tAntiAFK, state = "antiafk"}
}

for i, btn in ipairs(btns) do
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -40, 0, 35)
    b.Position = UDim2.new(0, 20, 0, 180 + (i-1)*45)
    b.Text = btn.name .. "    [❍⊃]"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.BorderSizePixel = 0
    
    b.MouseButton1Click:Connect(function()
        btn.func()
        if states[btn.state] then
            b.Text = btn.name .. "    [⊂❍]"
            b.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            b.Text = btn.name .. "    [❍⊃]"
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

-- ============================================
-- КНОПКИ УПРАВЛЕНИЯ FLY ДЛЯ ТЕЛЕФОНА
-- ============================================
local flyControls = Instance.new("Frame", gui)
flyControls.Size = UDim2.new(0, 200, 0, 150)
flyControls.Position = UDim2.new(0.5, -100, 0.8, 0)
flyControls.BackgroundTransparency = 1
flyControls.Visible = false
flyControls.ZIndex = 20

local function createFlyButton(text, position, size, color, direction)
    local btn = Instance.new("TextButton", flyControls)
    btn.Size = UDim2.new(0, size, 0, size)
    btn.Position = UDim2.new(0, position.X, 0, position.Y)
    btn.Text = text
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 20
    btn.BorderSizePixel = 0
    btn.ZIndex = 21
    
    local isHeld = false
    
    btn.MouseButton1Down:Connect(function()
        isHeld = true
        if states.fly and flyBV then
            local move = direction * flySpeed
            flyBV.Velocity = move
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

-- Создаём кнопки управления (WASD + Space/Shift)
local up = createFlyButton("▲", Vector2.new(75, 0), 50, Color3.fromRGB(50, 50, 80), Vector3.new(0, 0, -1))
local down = createFlyButton("▼", Vector2.new(75, 100), 50, Color3.fromRGB(50, 50, 80), Vector3.new(0, 0, 1))
local left = createFlyButton("◄", Vector2.new(25, 50), 50, Color3.fromRGB(50, 50, 80), Vector3.new(-1, 0, 0))
local right = createFlyButton("►", Vector2.new(125, 50), 50, Color3.fromRGB(50, 50, 80), Vector3.new(1, 0, 0))
local upFly = createFlyButton("⬆", Vector2.new(75, -50), 50, Color3.fromRGB(80, 80, 120), Vector3.new(0, 1, 0))
local downFly = createFlyButton("⬇", Vector2.new(75, 150), 50, Color3.fromRGB(80, 80, 120), Vector3.new(0, -1, 0))

-- Показываем/скрываем кнопки управления при включении/выключении Fly
local oldFlyState = false
game:GetService("RunService").Heartbeat:Connect(function()
    if states.fly ~= oldFlyState then
        oldFlyState = states.fly
        flyControls.Visible = states.fly
    end
end)

-- ============================================
-- ЗАКРЫТЬ МЕНЮ
-- ============================================
local exitBtn = Instance.new("TextButton", frame)
exitBtn.Size = UDim2.new(1, -40, 0, 40)
exitBtn.Position = UDim2.new(0, 20, 0, 180 + #btns*45 + 10)
exitBtn.Text = "⛔ ЗАКРЫТЬ"
exitBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
exitBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 16
exitBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

print("✅ Prison RP Cheat by shasik_1488 загружен!")
