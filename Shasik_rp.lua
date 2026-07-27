-- Prison RP Script v17.0 | by shasik_1488 | SLIDERS + ULTRA DESIGN
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

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
local savedAccessories = {}
local menuOpen = false

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
-- ВСЕ ФУНКЦИИ
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

function tSpeed(speed)
    if speed then
        if connections.speed then connections.speed:Disconnect() end
        connections.speed = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.speed then return end
            pcall(function()
                humanoid.WalkSpeed = speed
            end)
        end)
    end
end

function toggleSpeed()
    states.speed = not states.speed
    if not states.speed then
        if connections.speed then connections.speed:Disconnect(); connections.speed = nil end
        humanoid.WalkSpeed = 16
    end
    notify("Скорость", states.speed)
end

function tNoClip()
    states.noclip = not states.noclip
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not states.noclip
        end
    end
    notify("No Clip", states.noclip)
end

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
-- КРУТОЕ МЕНЮ (ПЛАВАЮЩАЯ ИКОНКА)
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"

-- ============================================
-- ПЛАВАЮЩАЯ ИКОНКА (КРУГЛАЯ)
-- ============================================
local icon = Instance.new("ImageButton", gui)
icon.Size = UDim2.new(0, 60, 0, 60)
icon.Position = UDim2.new(0.85, 0, 0.1, 0)
icon.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
icon.BackgroundTransparency = 0.2
icon.Image = ""
icon.BorderSizePixel = 2
icon.BorderColor3 = Color3.fromRGB(255, 200, 0)
icon.ClipsDescendants = true
icon.ZIndex = 10

local label = Instance.new("TextLabel", icon)
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "P"
label.TextColor3 = Color3.fromRGB(255, 200, 0)
label.BackgroundTransparency = 1
label.Font = Enum.Font.SourceSansBold
label.TextSize = 30
label.TextScaled = true

-- ============================================
-- МЕНЮ (С ПОЛЗУНКАМИ)
-- ============================================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, -250, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
frame.BackgroundTransparency = 0.05
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.ZIndex = 5

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 60)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 28

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0, 0, 0, 60)
subtitle.Text = "PRISON RP | ULTIMATE"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 14

-- ============================================
-- ПОЛЗУНОК ДЛЯ СКОРОСТИ
-- ============================================
local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Size = UDim2.new(1, -40, 0, 30)
speedLabel.Position = UDim2.new(0, 20, 0, 100)
speedLabel.Text = "⚡ Скорость: 0"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.BackgroundTransparency = 1
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 16
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSlider = Instance.new("Frame", frame)
speedSlider.Size = UDim2.new(0, 200, 0, 10)
speedSlider.Position = UDim2.new(0, 20, 0, 135)
speedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
speedSlider.BorderSizePixel = 0

local speedFill = Instance.new("Frame", speedSlider)
speedFill.Size = UDim2.new(0, 0, 1, 0)
speedFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
speedFill.BorderSizePixel = 0

local speedValue = 0
local speedDragging = false

local function updateSpeed(value)
    speedValue = math.clamp(value, 0, 200)
    speedFill.Size = UDim2.new(speedValue/200, 0, 1, 0)
    speedLabel.Text = "⚡ Скорость: " .. math.floor(speedValue)
    if states.speed then
        tSpeed(speedValue)
    end
end

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        speedDragging = true
        local pos = input.Position.X - speedSlider.AbsolutePosition.X
        local value = math.clamp(pos / speedSlider.AbsoluteSize.X, 0, 1) * 200
        updateSpeed(value)
    end
end)

speedSlider.InputChanged:Connect(function(input)
    if speedDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local pos = input.Position.X - speedSlider.AbsolutePosition.X
        local value = math.clamp(pos / speedSlider.AbsoluteSize.X, 0, 1) * 200
        updateSpeed(value)
    end
end)

speedSlider.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        speedDragging = false
    end
end)

-- ============================================
-- КНОПКИ
-- ============================================
local btns = {
    {name = "❤ Бессмертие", func = tGodmode, state = "godmode"},
    {name = "⚡ Вкл/Выкл скорость", func = toggleSpeed, state = "speed"},
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
    b.Position = UDim2.new(0, 20, 0, 160 + (i-1)*45)
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
exitBtn.Position = UDim2.new(0, 20, 0, 160 + #btns*45 + 10)
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
-- ОТКРЫТИЕ/ЗАКРЫТИЕ МЕНЮ
-- ============================================
icon.MouseButton1Click:Connect(function()
    if menuOpen then
        frame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3)
        menuOpen = false
    else
        frame:TweenSize(UDim2.new(0, 500, 0, 580), "Out", "Quad", 0.3)
        menuOpen = true
    end
end)

print("✅ Prison RP Cheat by shasik_1488 загружен!")
