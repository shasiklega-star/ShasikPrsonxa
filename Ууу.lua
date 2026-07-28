local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")

-- ОБХОД АНТИЧИТА
pcall(function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            if v.Name:lower():find("anticheat") or v.Name:lower():find("anti") or v.Name:lower():find("detect") or v.Name:lower():find("cheat") or v.Name:lower():find("security") or v.Name:lower():find("exploit") or v.Name:lower():find("health") or v.Name:lower():find("damage") or v.Name:lower():find("heal") or v.Name:lower():find("ban") or v.Name:lower():find("kick") then
                v.Disabled = true
            end
        end
        if v:IsA("RemoteEvent") and (v.Name:lower():find("anti") or v.Name:lower():find("detect") or v.Name:lower():find("health") or v.Name:lower():find("damage") or v.Name:lower():find("heal")) then
            v:Destroy()
        end
    end
end)

print("✅ ОБХОД АНТИЧИТА АКТИВИРОВАН!")

-- ЗВУК
function playClick()
    pcall(function()
        local sound = Instance.new("Sound", workspace)
        sound.SoundId = "rbxassetid://9120381960"
        sound.Volume = 0.25
        sound.PlayOnRemove = true
        sound:Play()
        task.wait(0.2)
        sound:Destroy()
    end)
end

function notify(text, state)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "✦ SHASIK_1488 ✦",
            Text = state and "✅ " .. text .. " ВКЛ" or "❌ " .. text .. " ВЫКЛ",
            Duration = 2
        })
    end)
end

-- СОСТОЯНИЯ
local states = {
    godmode = false,
    autoHeal = false,
    speed = false,
    noclip = false,
    fly = false,
    esp = false,
    aimbot = false,
    invisible = false,
    tp = false
}

local connections = {}
local flyKeys = {w = false, a = false, s = false, d = false, space = false, shift = false}
local flyBV = nil
local flyBodyGyro = nil
local flyControls = nil
local tpFrame = nil
local tpMenuOpen = false
local currentCategory = 1

-- БЕССМЕРТИЕ
function toggleGodMode()
    states.godmode = not states.godmode
    playClick()
    if states.godmode then
        humanoid.BreakJointsOnDeath = false
        root.Anchored = true
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        if connections.godMode then connections.godMode:Disconnect() end
        connections.godMode = game:GetService("RunService").Heartbeat:Connect(function()
            if states.godmode and humanoid and humanoid.Parent then
                if humanoid.Health < 100 then humanoid.Health = math.huge end
                if humanoid.MaxHealth < 100 then humanoid.MaxHealth = math.huge end
                if root then root.Anchored = true end
            end
        end)
        notify("Бессмертие", true)
    else
        if connections.godMode then connections.godMode:Disconnect(); connections.godMode = nil end
        humanoid.BreakJointsOnDeath = true
        root.Anchored = false
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        notify("Бессмертие", false)
    end
end

-- АВТО-ЛЕЧЕНИЕ
function toggleAutoHeal()
    states.autoHeal = not states.autoHeal
    playClick()
    if states.autoHeal then
        if connections.autoHeal then connections.autoHeal:Disconnect() end
        connections.autoHeal = game:GetService("RunService").Heartbeat:Connect(function()
            if states.autoHeal and humanoid and humanoid.Parent and humanoid.Health < 50 then
                humanoid.Health = 100
            end
        end)
        notify("Авто-лечение", true)
    else
        if connections.autoHeal then connections.autoHeal:Disconnect(); connections.autoHeal = nil end
        notify("Авто-лечение", false)
    end
end

-- NO CLIP
function toggleNoClip()
    states.noclip = not states.noclip
    playClick()
    if states.noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        connections.noclipLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if states.noclip and root then
                root.CanCollide = false
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
        notify("No Clip", true)
    else
        if connections.noclipLoop then connections.noclipLoop:Disconnect(); connections.noclipLoop = nil end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
        notify("No Clip", false)
    end
end

-- СПИДХАК
function toggleSpeed()
    states.speed = not states.speed
    playClick()
    if states.speed then
        if connections.speed then connections.speed:Disconnect() end
        connections.speed = game:GetService("RunService").Heartbeat:Connect(function()
            if states.speed and humanoid then humanoid.WalkSpeed = 100 end
        end)
        notify("Спидхак", true)
    else
        if connections.speed then connections.speed:Disconnect(); connections.speed = nil end
        if humanoid then humanoid.WalkSpeed = 16 end
        notify("Спидхак", false)
    end
end

-- FLY
function toggleFly()
    states.fly = not states.fly
    playClick()
    if states.fly then
        flyControls = Instance.new("ScreenGui", game.CoreGui)
        flyControls.Name = "FlyControls"
        flyControls.ResetOnSpawn = false
        
        flyBV = Instance.new("BodyVelocity", root)
        flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        
        flyBodyGyro = Instance.new("BodyGyro", root)
        flyBodyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyBodyGyro.P = 1e6
        flyBodyGyro.CFrame = root.CFrame
        
        connections.fly = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.fly then
                if flyBV then flyBV:Destroy(); flyBV = nil end
                if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
                if flyControls then flyControls:Destroy(); flyControls = nil end
                return
            end
            if flyBodyGyro then flyBodyGyro.CFrame = root.CFrame end
            local cam = workspace.CurrentCamera
            local forward = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local up = cam.CFrame.UpVector
            local move = Vector3.new(0, 0, 0)
            if flyKeys.w then move = move + forward end
            if flyKeys.s then move = move - forward end
            if flyKeys.a then move = move - right end
            if flyKeys.d then move = move + right end
            if flyKeys.space then move = move + up end
            if flyKeys.shift then move = move - up end
            if move.Magnitude > 0 then flyBV.Velocity = move.Unit * 100 else flyBV.Velocity = Vector3.new(0, 0, 0) end
        end)
        notify("Fly", true)
    else
        if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
        if flyControls then flyControls:Destroy(); flyControls = nil end
        notify("Fly", false)
    end
end

-- НЕВИДИМОСТЬ
function toggleInvisible()
    states.invisible = not states.invisible
    playClick()
    if states.invisible then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 1 end
        end
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("Hat") then v:Destroy() end
        end
        if char:FindFirstChild("DisplayName") then char.DisplayName.Text = "" end
        notify("Невидимость", true)
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 0 end
        end
        if char:FindFirstChild("DisplayName") then char.DisplayName.Text = player.Name end
        notify("Невидимость", false)
    end
end

-- ТЕЛЕПОРТ
function toggleTeleport()
    if tpMenuOpen then
        if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
        tpMenuOpen = false
        states.tp = false
        return
    end
    states.tp = true
    tpMenuOpen = true
    tpFrame = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", tpFrame)
    frame.Size = UDim2.new(0, 300, 0, 400)
    frame.Position = UDim2.new(0.5, -150, 0.25, 0)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    frame.BackgroundTransparency = 0.15
    frame.Active = true
    frame.Draggable = true
    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -35, 0, 5)
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(255, 50, 50)
    close.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    close.Font = Enum.Font.SourceSansBold
    close.TextSize = 18
    close.MouseButton1Click:Connect(function()
        tpFrame:Destroy()
        tpMenuOpen = false
        states.tp = false
    end)
    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -10, 1, -50)
    scroll.Position = UDim2.new(0, 5, 0, 45)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            local btn = Instance.new("TextButton", scroll)
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Text = p.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 15
            btn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                end
            end)
        end
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, #scroll:GetChildren() * 40)
end

-- ============================================
-- МЕНЮ + СНЕГ + ИКОНКА
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 450, 0, 550)
frame.Position = UDim2.new(0.5, -225, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(6, 6, 20)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 0

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

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 45)
subtitle.Text = "PRISON RP | ULTIMATE EDITION"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13

local categories = {"Персонаж", "Бой", "Настройки"}
local catFrame = Instance.new("Frame", frame)
catFrame.Size = UDim2.new(0.9, 0, 0, 35)
catFrame.Position = UDim2.new(0.05, 0, 0, 80)
catFrame.BackgroundTransparency = 1

local catBtns = {}
for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", catFrame)
    btn.Size = UDim2.new(0.33, -5, 1, 0)
    btn.Position = UDim2.new((i-1)*0.33, 2, 0, 0)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
    btn.BackgroundTransparency = 0.3
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.BorderSizePixel = 0
    btn.MouseButton1Click:Connect(function()
        currentCategory = i
        for _, b in pairs(catBtns) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
            b.TextColor3 = Color3.fromRGB(200, 200, 255)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 100)
        btn.TextColor3 = Color3.fromRGB(255, 215, 0)
        updateContent()
    end)
    catBtns[i] = btn
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)
end
catBtns[1].BackgroundColor3 = Color3.fromRGB(40, 40, 100)
catBtns[1].TextColor3 = Color3.fromRGB(255, 215, 0)

local contentFrame = Instance.new("ScrollingFrame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -140)
contentFrame.Position = UDim2.new(0, 10, 0, 125)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ClipsDescendants = true
contentFrame.BorderSizePixel = 0

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- СНЕГ
local snowContainer = Instance.new("Frame", frame)
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.ZIndex = 0
local snowParticles = {}
for i = 1, 80 do
    local size = math.random(2, 5)
    local particle = Instance.new("Frame", snowContainer)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BackgroundTransparency = 0.2 + math.random() * 0.3
    particle.BorderSizePixel = 0
    table.insert(snowParticles, {
        frame = particle,
        speed = 0.1 + math.random() * 0.3,
        drift = math.random(-1, 1) * 0.05,
        x = particle.Position.X.Scale,
        y = particle.Position.Y.Scale
    })
    Instance.new("UICorner", particle).CornerRadius = UDim.new(0.5, 0)
end
game:GetService("RunService").Heartbeat:Connect(function()
    for _, p in pairs(snowParticles) do
        p.y = p.y + p.speed * 0.005
        p.x = p.x + math.sin(tick() * p.drift) * 0.0002
        if p.y > 1 then
            p.y = -0.05
            p.x = math.random() / 2
        end
        if p.x < -0.1 then p.x = 1.1 elseif p.x > 1.1 then p.x = -0.1 end
        p.frame.Position = UDim2.new(p.x, 0, p.y, 0)
    end
end)

function updateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    if currentCategory == 1 then
        local btn1 = Instance.new("TextButton", contentFrame)
        btn1.Size = UDim2.new(1, 0, 0, 40)
        btn1.Text = states.godmode and "👑 Бессмертие [⊂❍]" or "👑 Бессмертие [❍⊃]"
        btn1.TextColor3 = states.godmode and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn1.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn1.BackgroundTransparency = 0.2
        btn1.Font = Enum.Font.GothamBold
        btn1.TextSize = 15
        btn1.BorderSizePixel = 1
        btn1.BorderColor3 = states.godmode and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn1.MouseButton1Click:Connect(function()
            toggleGodMode()
            btn1.Text = states.godmode and "👑 Бессмертие [⊂❍]" or "👑 Бессмертие [❍⊃]"
            btn1.TextColor3 = states.godmode and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn1.BorderColor3 = states.godmode and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn1).CornerRadius = UDim.new(0.1, 0)
        
        local btn2 = Instance.new("TextButton", contentFrame)
        btn2.Size = UDim2.new(1, 0, 0, 40)
        btn2.Text = states.autoHeal and "💊 Авто-лечение [⊂❍]" or "💊 Авто-лечение [❍⊃]"
        btn2.TextColor3 = states.autoHeal and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn2.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn2.BackgroundTransparency = 0.2
        btn2.Font = Enum.Font.GothamBold
        btn2.TextSize = 15
        btn2.BorderSizePixel = 1
        btn2.BorderColor3 = states.autoHeal and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn2.MouseButton1Click:Connect(function()
            toggleAutoHeal()
            btn2.Text = states.autoHeal and "💊 Авто-лечение [⊂❍]" or "💊 Авто-лечение [❍⊃]"
            btn2.TextColor3 = states.autoHeal and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn2.BorderColor3 = states.autoHeal and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
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
        
        local btn4 = Instance.new("TextButton", contentFrame)
        btn4.Size = UDim2.new(1, 0, 0, 40)
        btn4.Text = states.noclip and "👻 No Clip [⊂❍]" or "👻 No Clip [❍⊃]"
        btn4.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn4.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn4.BackgroundTransparency = 0.2
        btn4.Font = Enum.Font.GothamBold
        btn4.TextSize = 15
        btn4.BorderSizePixel = 1
        btn4.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn4.MouseButton1Click:Connect(function()
            toggleNoClip()
            btn4.Text = states.noclip and "👻 No Clip [⊂❍]" or "👻 No Clip [❍⊃]"
            btn4.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn4.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn4).CornerRadius = UDim.new(0.1, 0)
        
        local btn5 = Instance.new("TextButton", contentFrame)
        btn5.Size = UDim2.new(1, 0, 0, 40)
        btn5.Text = states.fly and "✈ Fly [⊂❍]" or "✈ Fly [❍⊃]"
        btn5.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn5.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn5.BackgroundTransparency = 0.2
        btn5.Font = Enum.Font.GothamBold
        btn5.TextSize = 15
        btn5.BorderSizePixel = 1
        btn5.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn5.MouseButton1Click:Connect(function()
            toggleFly()
            btn5.Text = states.fly and "✈ Fly [⊂❍]" or "✈ Fly [❍⊃]"
            btn5.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn5.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn5).CornerRadius = UDim.new(0.1, 0)
        
        local btn6 = Instance.new("TextButton", contentFrame)
        btn6.Size = UDim2.new(1, 0, 0, 40)
        btn6.Text = states.invisible and "🥷 Невидимость [⊂❍]" or "🥷 Невидимость [❍⊃]"
        btn6.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn6.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn6.BackgroundTransparency = 0.2
        btn6.Font = Enum.Font.GothamBold
        btn6.TextSize = 15
        btn6.BorderSizePixel = 1
        btn6.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn6.MouseButton1Click:Connect(function()
            toggleInvisible()
            btn6.Text = states.invisible and "🥷 Невидимость [⊂❍]" or "🥷 Невидимость [❍⊃]"
            btn6.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn6.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn6).CornerRadius = UDim.new(0.1, 0)
        
        local btn7 = Instance.new("TextButton", contentFrame)
        btn7.Size = UDim2.new(1, 0, 0, 40)
        btn7.Text = states.tp and "📌 ТП к игроку [⊂❍]" or "📌 ТП к игроку [❍⊃]"
        btn7.TextColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn7.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn7.BackgroundTransparency = 0.2
        btn7.Font = Enum.Font.GothamBold
        btn7.TextSize = 15
        btn7.BorderSizePixel = 1
        btn7.BorderColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn7.MouseButton1Click:Connect(function()
            toggleTeleport()
            btn7.Text = states.tp and "📌 ТП к игроку [⊂❍]" or "📌 ТП к игроку [❍⊃]"
            btn7.TextColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn7.BorderColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn7).CornerRadius = UDim.new(0.1, 0)
    elseif currentCategory == 2 then
        -- БОЙ
        local aimBtn = Instance.new("TextButton", contentFrame)
        aimBtn.Size = UDim2.new(1, 0, 0, 40)
        aimBtn.Text = states.aimbot and "🎯 Aimbot [⊂❍]" or "🎯 Aimbot [❍⊃]"
        aimBtn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        aimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        aimBtn.BackgroundTransparency = 0.2
        aimBtn.Font = Enum.Font.GothamBold
        aimBtn.TextSize = 15
        aimBtn.BorderSizePixel = 1
        aimBtn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        aimBtn.MouseButton1Click:Connect(function()
            states.aimbot = not states.aimbot
            playClick()
            if states.aimbot then
                if connections.aimbot then connections.aimbot:Disconnect() end
                connections.aimbot = game:GetService("RunService").RenderStepped:Connect(function()
                    if not states.aimbot then return end
                    local closest, dist = nil, math.huge
                    for _, p in pairs(game.Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                            local d = (root.Position - p.Character.Head.Position).Magnitude
                            if d < dist then dist = d; closest = p.Character.Head end
                        end
                    end
                    if closest then camera.CFrame = CFrame.new(camera.CFrame.Position, closest.Position) end
                end)
                aimBtn.Text = "🎯 Aimbot [⊂❍]"
                aimBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
                aimBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
                notify("Aimbot", true)
            else
                if connections.aimbot then connections.aimbot:Disconnect(); connections.aimbot = nil end
                aimBtn.Text = "🎯 Aimbot [❍⊃]"
                aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                aimBtn.BorderColor3 = Color3.fromRGB(100, 100, 200)
                notify("Aimbot", false)
            end
        end)
        Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0.1, 0)
    elseif currentCategory == 3 then
        -- НАСТРОЙКИ
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
        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
            if flyControls then flyControls:Destroy() end
            if tpFrame then tpFrame:Destroy() end
        end)
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0.1, 0)
    end
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 48)
end

updateContent()

-- ИКОНКА
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
Instance.new("UICorner", iconBtn).CornerRadius = UDim.new(1, 0)

local stroke = Instance.new("UIStroke", iconBtn)
stroke.Color = Color3.fromRGB(255, 215, 0)
stroke.Thickness = 3
stroke.Transparency = 0.2

local menuVisible = true
iconBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    frame.Visible = menuVisible
    if menuVisible then
        iconBtn.Position = UDim2.new(0.01, 0, 0.85, 0)
    else
        iconBtn.Position = UDim2.new(0.01, 0, 0.90, 0)
    end
end)

print("✅ SHASIK_1488 ЗАГРУЖЕН!")
