-- Prison RP Script v22.0 | by shasik_1488 | FAST + BEAUTIFUL ICON
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
local menuOpen = false
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
    notify("No Clip", states.noclip)
end

-- ============================================
-- FLY
-- ============================================
function tFly()
    states.fly = not states.fly
    if states.fly then
        notify("Fly", true)
        if connections.fly then connections.fly:Disconnect() end
        humanoid.PlatformStand = true
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        connections.fly = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.fly then return end
            local uis = game:GetService("UserInputService")
            local move = Vector3.new(0, 0, 0)
            if uis:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -50) end
            if uis:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 50) end
            if uis:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-50, 0, 0) end
            if uis:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(50, 0, 0) end
            if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 50, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -50, 0) end
            bv.Velocity = move
        end)
    else
        if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
        humanoid.PlatformStand = false
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
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
-- НЕВИДИМОСТЬ
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
-- ОРУЖИЕ
-- ============================================
function giveAllWeapons()
    local weapons = {
        "Pistol", "Shotgun", "Taser", "AssaultRifle", "M4A1", "AK47", "MP5", "UMP45",
        "Sniper", "M98B", "M60", "Shank", "Knife", "Bat", "Hammer", "Crowbar", "Knuckle"
    }
    local replicated = game:GetService("ReplicatedStorage")
    local giveEvent = nil
    
    for _, obj in pairs(replicated:GetDescendants()) do
        if obj:IsA("RemoteEvent") and (
            obj.Name:lower():find("give") or
            obj.Name:lower():find("weapon") or
            obj.Name:lower():find("tool") or
            obj.Name:lower():find("item") or
            obj.Name:lower():find("equip") or
            obj.Name:lower():find("spawn")
        ) then
            giveEvent = obj
            break
        end
    end
    
    if giveEvent then
        for _, weapon in ipairs(weapons) do
            pcall(function()
                giveEvent:FireServer(weapon)
                wait(0.1)
            end)
        end
        notify("Оружие выдано", true)
    else
        notify("Оружие не найдено", false)
    end
end

-- ============================================
-- БЫСТРОЕ МЕНЮ (С КРАСИВОЙ ИКОНКОЙ)
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"

-- ============================================
-- ИКОНКА (С КАРТИНКОЙ И ТВОИМ ИМЕНЕМ)
-- ============================================
local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0.85, 0, 0.1, 0)
icon.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
icon.BackgroundTransparency = 0
icon.Image = "" -- если есть ссылка на картинку, вставь сюда
icon.BorderSizePixel = 2
icon.BorderColor3 = Color3.fromRGB(255, 215, 0)
icon.ClipsDescendants = true
icon.ZIndex = 10

-- Имя на иконке
local iconName = Instance.new("TextLabel", icon)
iconName.Size = UDim2.new(1, 0, 1, 0)
iconName.Text = "shasik"
iconName.TextColor3 = Color3.fromRGB(255, 215, 0)
iconName.BackgroundTransparency = 1
iconName.Font = Enum.Font.SourceSansBold
iconName.TextSize = 14
iconName.TextScaled = true

-- Перетаскивание иконки
local dragIcon = false
local dragStart = nil
local iconPos = nil

icon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragIcon = true
        dragStart = input.Position
        iconPos = icon.Position
    end
end)

icon.InputChanged:Connect(function(input)
    if dragIcon and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        icon.Position = UDim2.new(iconPos.X.Scale, iconPos.X.Offset + delta.X, iconPos.Y.Scale, iconPos.Y.Offset + delta.Y)
    end
end)

icon.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragIcon = false
    end
end)

-- ============================================
-- МЕНЮ (ОТКРЫВАЕТСЯ МГНОВЕННО)
-- ============================================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, -250, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
frame.BackgroundTransparency = 0
frame.Active = true
frame.Draggable = false
frame.ClipsDescendants = true
frame.ZIndex = 5
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

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
    {name = "✈ Fly", func = tFly, state = "fly"},
    {name = "🚪 Универсальные двери", func = tUniversalDoors, state = "universal"},
    {name = "👀 Невидимость", func = tInvisible, state = "invisible"},
    {name = "🔒 Анти-АФК", func = tAntiAFK, state = "antiafk"},
    {name = "🔫 Всё оружие", func = giveAllWeapons, state = "weapons"}
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

local exitBtn = Instance.new("TextButton", frame)
exitBtn.Size = UDim2.new(1, -40, 0, 40)
exitBtn.Position = UDim2.new(0, 20, 0, 180 + #btns*45 + 10)
exitBtn.Text = "⛔ ЗАКРЫТЬ"
exitBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
exitBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 16
exitBtn.MouseButton1Click:Connect(function()
    frame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3)
    menuOpen = false
end)

-- ============================================
-- ОТКРЫТИЕ/ЗАКРЫТИЕ (МГНОВЕННО)
-- ============================================
icon.MouseButton1Click:Connect(function()
    if not dragIcon then
        if menuOpen then
            frame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.2)
            menuOpen = false
        else
            frame:TweenSize(UDim2.new(0, 500, 0, 580), "Out", "Quad", 0.2)
            menuOpen = true
        end
    end
end)

print("✅ Prison RP Cheat by shasik_1488 загружен!")
