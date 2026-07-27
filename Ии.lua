-- ============================================
-- PRISON RP ULTRA V53 (КРАСИВЫЙ ДИЗАЙН)
-- by shasik_1488 | ПЛАВНЫЙ И СТИЛЬНЫЙ
-- ============================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- ============================================
-- СОСТОЯНИЯ
-- ============================================
local states = {
    highjump = false,
    speed = false,
    noclip = false,
    fly = false,
    esp = false,
    aimbot = false,
    invisible = false
}

local connections = {}
local speedValue = 100
local espColor = Color3.fromRGB(255, 0, 0)
local nc_cache = {}
local espObjects = {}
local espConnections = {}
local flyKeys = {w = false, a = false, s = false, d = false, space = false, shift = false}
local flyBV = nil
local flyBodyGyro = nil
local flyControls = nil
local aimPart = "Head"
local savedAccessories = {}

-- ============================================
-- ЗВУК
-- ============================================
function playClick()
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://9120381960"
    sound.Volume = 0.15
    sound.PlayOnRemove = true
    sound:Play()
    wait(0.2)
    sound:Destroy()
end

-- ============================================
-- УВЕДОМЛЕНИЯ
-- ============================================
function notify(text, state)
    game.StarterGui:SetCore("SendNotification", {
        Title = "✦ shasik_1488 ✦",
        Text = state and "✅ " .. text .. " ВКЛ" or "❌ " .. text .. " ВЫКЛ",
        Duration = 2
    })
end

-- ============================================
-- ПЕРЕЗАГРУЗКА ПОСЛЕ СМЕРТИ
-- ============================================
function reconnectAfterDeath()
    char = player.Character
    if not char then return end
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if states.highjump then toggleHighJump() end
    if states.speed then toggleSpeed() end
    if states.noclip then toggleNoClip() end
    if states.fly then toggleFly() end
    if states.esp then toggleESP() end
    if states.aimbot then toggleAimbot() end
    if states.invisible then toggleInvisible() end
end

player.CharacterAdded:Connect(function()
    wait(0.5)
    reconnectAfterDeath()
end)

-- ============================================
-- ФУНКЦИИ
-- ============================================
function toggleHighJump()
    states.highjump = not states.highjump
    playClick()
    if states.highjump then
        if connections.highjump then connections.highjump:Disconnect() end
        connections.highjump = game:GetService("RunService").Heartbeat:Connect(function()
            if states.highjump and humanoid and humanoid.Parent then
                humanoid.JumpPower = 150
            end
        end)
    else
        if connections.highjump then connections.highjump:Disconnect(); connections.highjump = nil end
        if humanoid and humanoid.Parent then humanoid.JumpPower = 50 end
    end
    notify("Высокий прыжок", states.highjump)
end

function toggleSpeed()
    states.speed = not states.speed
    playClick()
    if states.speed then
        if connections.speed then connections.speed:Disconnect() end
        connections.speed = game:GetService("RunService").Heartbeat:Connect(function()
            if states.speed and humanoid and humanoid.Parent then
                humanoid.WalkSpeed = speedValue
            end
        end)
        if speedBtn then
            speedBtn.Text = "⚡ Спидхак    [⊂❍]"
            speedBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            speedBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
        if sliderFrame then
            sliderFrame.Visible = true
        end
    else
        if connections.speed then connections.speed:Disconnect(); connections.speed = nil end
        if humanoid and humanoid.Parent then humanoid.WalkSpeed = 16 end
        if speedBtn then
            speedBtn.Text = "⚡ Спидхак    [❍⊃]"
            speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            speedBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        if sliderFrame then
            sliderFrame.Visible = false
        end
    end
    notify("Спидхак", states.speed)
end

function updateSpeed(value)
    speedValue = math.clamp(value, 1, 200)
    if states.speed and humanoid and humanoid.Parent then
        humanoid.WalkSpeed = speedValue
    end
    if sliderLabel then
        sliderLabel.Text = "Скорость: " .. math.floor(speedValue)
    end
    if sliderFill then
        sliderFill.Size = UDim2.new(speedValue/200, 0, 1, 0)
    end
end

function toggleNoClip()
    states.noclip = not states.noclip
    playClick()
    if states.noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part.Parent:IsA("Model") then
                if nc_cache[part] == nil and part.CanCollide then
                    part.CanCollide = false
                    nc_cache[part] = true
                end
            end
        end
        if connections.noclip then connections.noclip:Disconnect() end
        connections.noclip = game:GetService("RunService").Heartbeat:Connect(function()
            if states.noclip then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if connections.noclip then connections.noclip:Disconnect(); connections.noclip = nil end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
        for part, _ in pairs(nc_cache) do
            part.CanCollide = true
        end
        nc_cache = {}
    end
    notify("No Clip", states.noclip)
end

function createFlyControls()
    if flyControls then return end
    flyControls = Instance.new("ScreenGui", game.CoreGui)
    flyControls.Name = "FlyControls"
    flyControls.ResetOnSpawn = false
    
    local function makeBtn(text, pos, color, key)
        local btn = Instance.new("TextButton", flyControls)
        btn.Size = UDim2.new(0, 55, 0, 55)
        btn.Position = UDim2.new(0, pos.X, 0, pos.Y)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.2
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 22
        btn.BorderSizePixel = 2
        btn.BorderColor3 = Color3.fromRGB(0, 200, 255)
        btn.ZIndex = 10
        
        btn.MouseButton1Down:Connect(function()
            if states.fly then
                if key == "w" then flyKeys.w = true end
                if key == "a" then flyKeys.a = true end
                if key == "s" then flyKeys.s = true end
                if key == "d" then flyKeys.d = true end
                if key == "space" then flyKeys.space = true end
                if key == "shift" then flyKeys.shift = true end
            end
        end)
        btn.MouseButton1Up:Connect(function()
            if key == "w" then flyKeys.w = false end
            if key == "a" then flyKeys.a = false end
            if key == "s" then flyKeys.s = false end
            if key == "d" then flyKeys.d = false end
            if key == "space" then flyKeys.space = false end
            if key == "shift" then flyKeys.shift = false end
        end)
        btn.MouseLeave:Connect(function()
            if key == "w" then flyKeys.w = false end
            if key == "a" then flyKeys.a = false end
            if key == "s" then flyKeys.s = false end
            if key == "d" then flyKeys.d = false end
            if key == "space" then flyKeys.space = false end
            if key == "shift" then flyKeys.shift = false end
        end)
        return btn
    end
    
    makeBtn("▲", Vector2.new(75, 0), Color3.fromRGB(30, 30, 60), "w")
    makeBtn("▼", Vector2.new(75, 100), Color3.fromRGB(30, 30, 60), "s")
    makeBtn("◄", Vector2.new(25, 50), Color3.fromRGB(30, 30, 60), "a")
    makeBtn("►", Vector2.new(125, 50), Color3.fromRGB(30, 30, 60), "d")
    makeBtn("⬆", Vector2.new(75, -50), Color3.fromRGB(60, 60, 100), "space")
    makeBtn("⬇", Vector2.new(75, 150), Color3.fromRGB(60, 60, 100), "shift")
end

function toggleFly()
    states.fly = not states.fly
    playClick()
    if states.fly then
        notify("Fly", true)
        createFlyControls()
        flyControls.Enabled = true
        humanoid.PlatformStand = false
        
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
                if flyControls then flyControls.Enabled = false end
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
    else
        if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
        if flyControls then flyControls.Enabled = false end
        humanoid.PlatformStand = false
        notify("Fly", false)
    end
end

function createESP(target)
    if not target or not target.Character then return end
    local tChar = target.Character
    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = tRoot
    box.Size = Vector3.new(3, 5, 2)
    box.Color3 = espColor
    box.Transparency = 0.5
    box.ZIndex = 10
    box.AlwaysOnTop = true
    box.Parent = tChar
    
    local nameTag = Instance.new("BillboardGui", tChar)
    nameTag.Adornee = tRoot
    nameTag.Size = UDim2.new(0, 100, 0, 30)
    nameTag.StudsOffset = Vector3.new(0, 3, 0)
    nameTag.AlwaysOnTop = true
    
    local label = Instance.new("TextLabel", nameTag)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = target.Name
    label.TextColor3 = espColor
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    
    espObjects[target] = {box = box, nameTag = nameTag, label = label}
end

function removeESP(target)
    if espObjects[target] then
        local obj = espObjects[target]
        if obj.box then obj.box:Destroy() end
        if obj.nameTag then obj.nameTag:Destroy() end
        espObjects[target] = nil
    end
end

function updateESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            if states.esp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not espObjects[p] then createESP(p) end
            else
                removeESP(p)
            end
        end
    end
end

function toggleESP()
    states.esp = not states.esp
    playClick()
    if states.esp then
        updateESP()
        espConnections.PlayerAdded = game.Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                wait(1)
                if states.esp then createESP(p) end
            end)
        end)
        espConnections.PlayerRemoving = game.Players.PlayerRemoving:Connect(removeESP)
        notify("ESP", true)
    else
        for p, _ in pairs(espObjects) do
            removeESP(p)
        end
        for _, conn in pairs(espConnections) do
            if conn then conn:Disconnect() end
        end
        espConnections = {}
        notify("ESP", false)
    end
end

function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    local origin = root.Position
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = p.Character.HumanoidRootPart.Position
            local distance = (targetPos - origin).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closest = p
            end
        end
    end
    return closest
end

function aimbot()
    if not states.aimbot then return end
    local target = getClosestPlayer()
    if target and target.Character then
        local part = target.Character:FindFirstChild(aimPart) or target.Character:FindFirstChild("Head")
        if part then
            local partPos = part.Position
            local currentCF = camera.CFrame
            local targetCF = CFrame.new(currentCF.Position, partPos)
            camera.CFrame = currentCF:Lerp(targetCF, 0.3)
        end
    end
end

function toggleAimbot()
    states.aimbot = not states.aimbot
    playClick()
    if states.aimbot then
        if connections.aimbot then connections.aimbot:Disconnect() end
        connections.aimbot = game:GetService("RunService").RenderStepped:Connect(aimbot)
        notify("Aimbot", true)
    else
        if connections.aimbot then connections.aimbot:Disconnect(); connections.aimbot = nil end
        notify("Aimbot", false)
    end
end

function toggleInvisible()
    states.invisible = not states.invisible
    playClick()
    if states.invisible then
        savedAccessories = {}
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") or v:IsA("Hat") then
                table.insert(savedAccessories, v)
            end
        end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        for _, v in pairs(savedAccessories) do
            v:Destroy()
        end
        if char:FindFirstChild("DisplayName") then
            char.DisplayName.Text = ""
        end
        root.LocalTransparencyModifier = 1
        notify("Невидимость", true)
    else
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
        if char:FindFirstChild("DisplayName") then
            char.DisplayName.Text = player.Name
        end
        root.LocalTransparencyModifier = 0
        notify("Невидимость", false)
    end
end

-- ============================================
-- КРАСИВОЕ МЕНЮ (НОВЫЙ ДИЗАЙН)
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 380, 0, 480)
frame.Position = UDim2.new(0.5, -190, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 200, 255)
frame.ZIndex = 5

-- Обводки
local stroke1 = Instance.new("UIStroke", frame)
stroke1.Color = Color3.fromRGB(0, 200, 255)
stroke1.Thickness = 3
stroke1.Transparency = 0.5

local stroke2 = Instance.new("UIStroke", frame)
stroke2.Color = Color3.fromRGB(255, 0, 200)
stroke2.Thickness = 1
stroke2.Transparency = 0.8

-- Градиент
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 30))
})
gradient.Rotation = 30

-- ЗАГОЛОВКИ
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.ZIndex = 10

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.Text = "PRISON RP | ULTRA EDITION"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 14
subtitle.ZIndex = 10

local line = Instance.new("Frame", frame)
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 80)
line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
line.BorderSizePixel = 0
line.ZIndex = 10

-- КАТЕГОРИИ
local categories = {"Главная", "Бой", "ESP", "Настройки"}
local currentCategory = 1
local categoryButtons = {}

local categoryFrame = Instance.new("Frame", frame)
categoryFrame.Size = UDim2.new(0.9, 0, 0, 32)
categoryFrame.Position = UDim2.new(0.05, 0, 0, 88)
categoryFrame.BackgroundTransparency = 1
categoryFrame.ZIndex = 10

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", categoryFrame)
    btn.Size = UDim2.new(0.25, -2, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 2, 0, 0)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    btn.BackgroundTransparency = 0.2
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(40, 40, 80)
    btn.ZIndex = 10
    
    btn.MouseEnter:Connect(function()
        if btn.TextColor3 ~= Color3.fromRGB(255, 200, 0) then
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.TextColor3 ~= Color3.fromRGB(255, 200, 0) then
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        currentCategory = i
        for _, b in pairs(categoryButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
            b.TextColor3 = Color3.fromRGB(200, 200, 255)
            b.BorderColor3 = Color3.fromRGB(40, 40, 80)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
        btn.TextColor3 = Color3.fromRGB(255, 200, 0)
        btn.BorderColor3 = Color3.fromRGB(255, 200, 0)
        updateContent()
    end)
    categoryButtons[i] = btn
end
categoryButtons[1].BackgroundColor3 = Color3.fromRGB(40, 40, 80)
categoryButtons[1].TextColor3 = Color3.fromRGB(255, 200, 0)
categoryButtons[1].BorderColor3 = Color3.fromRGB(255, 200, 0)

-- КОНТЕНТ
local contentFrame = Instance.new("ScrollingFrame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -140)
contentFrame.Position = UDim2.new(0, 10, 0, 128)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 6
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ClipsDescendants = true
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 10
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- КНОПКИ
local speedBtn, sliderFrame, sliderLabel, sliderFill
local jumpBtn, noclipBtn, flyBtn, espBtn, aimBtn, invBtn

function updateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if currentCategory == 1 then -- Главная
        -- Спидхак
        speedBtn = Instance.new("TextButton", contentFrame)
        speedBtn.Size = UDim2.new(1, 0, 0, 40)
        speedBtn.Text = states.speed and "⚡ Спидхак    [⊂❍]" or "⚡ Спидхак    [❍⊃]"
        speedBtn.TextColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        speedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        speedBtn.BackgroundTransparency = 0.2
        speedBtn.Font = Enum.Font.SourceSansBold
        speedBtn.TextSize = 15
        speedBtn.BorderSizePixel = 1
        speedBtn.BorderColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        speedBtn.ZIndex = 10
        
        speedBtn.MouseEnter:Connect(function()
            speedBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 65)
        end)
        speedBtn.MouseLeave:Connect(function()
            speedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        
        speedBtn.MouseButton1Click:Connect(function()
            toggleSpeed()
            speedBtn.Text = states.speed and "⚡ Спидхак    [⊂❍]" or "⚡ Спидхак    [❍⊃]"
            speedBtn.TextColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            speedBtn.BorderColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
            if sliderFrame then
                sliderFrame.Visible = states.speed
            end
        end)
        
        sliderFrame = Instance.new("Frame", contentFrame)
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
        sliderFrame.BackgroundTransparency = 0.2
        sliderFrame.Visible = states.speed
        sliderFrame.BorderSizePixel = 1
        sliderFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
        sliderFrame.ZIndex = 10
        
        sliderLabel = Instance.new("TextLabel", sliderFrame)
        sliderLabel.Size = UDim2.new(1, 0, 0, 22)
        sliderLabel.Text = "Скорость: " .. speedValue
        sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Font = Enum.Font.SourceSansBold
        sliderLabel.TextSize = 14
        sliderLabel.ZIndex = 10
        
        local sliderBg = Instance.new("Frame", sliderFrame)
        sliderBg.Size = UDim2.new(1, 0, 0, 12)
        sliderBg.Position = UDim2.new(0, 0, 0, 28)
        sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        sliderBg.BorderSizePixel = 0
        sliderBg.ZIndex = 10
        
        sliderFill = Instance.new("Frame", sliderBg)
        sliderFill.Size = UDim2.new(speedValue/200, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        sliderFill.BorderSizePixel = 0
        sliderFill.ZIndex = 10
        
        local dragSlider = false
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragSlider = true
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                local value = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1) * 200
                updateSpeed(value)
            end
        end)
        sliderBg.InputChanged:Connect(function(input)
            if dragSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                local value = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1) * 200
                updateSpeed(value)
            end
        end)
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragSlider = false
            end
        end)
        
        -- Остальные кнопки
        jumpBtn = Instance.new("TextButton", contentFrame)
        jumpBtn.Size = UDim2.new(1, 0, 0, 40)
        jumpBtn.Text = states.highjump and "🦘 Высокий прыжок    [⊂❍]" or "🦘 Высокий прыжок    [❍⊃]"
        jumpBtn.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        jumpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        jumpBtn.BackgroundTransparency = 0.2
        jumpBtn.Font = Enum.Font.SourceSansBold
        jumpBtn.TextSize = 15
        jumpBtn.BorderSizePixel = 1
        jumpBtn.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        jumpBtn.ZIndex = 10
        
        jumpBtn.MouseEnter:Connect(function()
            jumpBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 65)
        end)
        jumpBtn.MouseLeave:Connect(function()
            jumpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        jumpBtn.MouseButton1Click:Connect(function()
            toggleHighJump()
            jumpBtn.Text = states.highjump and "🦘 Высокий прыжок    [⊂❍]" or "🦘 Высокий прыжок    [❍⊃]"
            jumpBtn.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            jumpBtn.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        noclipBtn = Instance.new("TextButton", contentFrame)
        noclipBtn.Size = UDim2.new(1, 0, 0, 40)
        noclipBtn.Text = states.noclip and "👻 No Clip    [⊂❍]" or "👻 No Clip    [❍⊃]"
        noclipBtn.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        noclipBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        noclipBtn.BackgroundTransparency = 0.2
        noclipBtn.Font = Enum.Font.SourceSansBold
        noclipBtn.TextSize = 15
        noclipBtn.BorderSizePixel = 1
        noclipBtn.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        noclipBtn.ZIndex = 10
        
        noclipBtn.MouseEnter:Connect(function()
            noclipBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 65)
        end)
        noclipBtn.MouseLeave:Connect(function()
            noclipBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        noclipBtn.MouseButton1Click:Connect(function()
            toggleNoClip()
            noclipBtn.Text = states.noclip and "👻 No Clip    [⊂❍]" or "👻 No Clip    [❍⊃]"
            noclipBtn.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            noclipBtn.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        flyBtn = Instance.new("TextButton", contentFrame)
        flyBtn.Size = UDim2.new(1, 0, 0, 40)
        flyBtn.Text = states.fly and "✈ Fly    [⊂❍]" or "✈ Fly    [❍⊃]"
        flyBtn.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        flyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        flyBtn.BackgroundTransparency = 0.2
        flyBtn.Font = Enum.Font.SourceSansBold
        flyBtn.TextSize = 15
        flyBtn.BorderSizePixel = 1
        flyBtn.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        flyBtn.ZIndex = 10
        
        flyBtn.MouseEnter:Connect(function()
            flyBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 65)
        end)
        flyBtn.MouseLeave:Connect(function()
            flyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        flyBtn.MouseButton1Click:Connect(function()
            toggleFly()
            flyBtn.Text = states.fly and "✈ Fly    [⊂❍]" or "✈ Fly    [❍⊃]"
            flyBtn.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            flyBtn.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        invBtn = Instance.new("TextButton", contentFrame)
        invBtn.Size = UDim2.new(1, 0, 0, 40)
        invBtn.Text = states.invisible and "🥷 Невидимость    [⊂❍]" or "🥷 Невидимость    [❍⊃]"
        invBtn.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        invBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        invBtn.BackgroundTransparency = 0.2
        invBtn.Font = Enum.Font.SourceSansBold
        invBtn.TextSize = 15
        invBtn.BorderSizePixel = 1
        invBtn.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        invBtn.ZIndex = 10
        
        invBtn.MouseEnter:Connect(function()
            invBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 65)
        end)
        invBtn.MouseLeave:Connect(function()
            invBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        invBtn.MouseButton1Click:Connect(function()
            toggleInvisible()
            invBtn.Text = states.invisible and "🥷 Невидимость    [⊂❍]" or "🥷 Невидимость    [❍⊃]"
            invBtn.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            invBtn.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 2 then -- Бой
        aimBtn = Instance.new("TextButton", contentFrame)
        aimBtn.Size = UDim2.new(1, 0, 0, 40)
        aimBtn.Text = states.aimbot and "🎯 Aimbot    [⊂❍]" or "🎯 Aimbot    [❍⊃]"
        aimBtn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        aimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        aimBtn.BackgroundTransparency = 0.2
        aimBtn.Font = Enum.Font.SourceSansBold
        aimBtn.TextSize = 15
        aimBtn.BorderSizePixel = 1
        aimBtn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        aimBtn.ZIndex = 10
        
        aimBtn.MouseEnter:Connect(function()
            aimBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 65)
        end)
        aimBtn.MouseLeave:Connect(function()
            aimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        aimBtn.MouseButton1Click:Connect(function()
            toggleAimbot()
            aimBtn.Text = states.aimbot and "🎯 Aimbot    [⊂❍]" or "🎯 Aimbot    [❍⊃]"
            aimBtn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            aimBtn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 3 then -- ESP
        espBtn = Instance.new("TextButton", contentFrame)
        espBtn.Size = UDim2.new(1, 0, 0, 40)
        espBtn.Text = states.esp and "👁️ ESP    [⊂❍]" or "👁️ ESP    [❍⊃]"
        espBtn.TextColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        espBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        espBtn.BackgroundTransparency = 0.2
        espBtn.Font = Enum.Font.SourceSansBold
        espBtn.TextSize = 15
        espBtn.BorderSizePixel = 1
        espBtn.BorderColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        espBtn.ZIndex = 10
        
        espBtn.MouseEnter:Connect(function()
            espBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 65)
        end)
        espBtn.MouseLeave:Connect(function()
            espBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        espBtn.MouseButton1Click:Connect(function()
            toggleESP()
            espBtn.Text = states.esp and "👁️ ESP    [⊂❍]" or "👁️ ESP    [❍⊃]"
            espBtn.TextColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            espBtn.BorderColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 4 then -- Настройки
        -- Цвет ESP
        local colorBtn = Instance.new("TextButton", contentFrame)
        colorBtn.Size = UDim2.new(1, 0, 0, 40)
        local colors = {
            {name = "🔴 Красный", value = Color3.fromRGB(255, 0, 0)},
            {name = "🟡 Жёлтый", value = Color3.fromRGB(255, 255, 0)},
            {name = "🔵 Синий", value = Color3.fromRGB(0, 0, 255)},
            {name = "🟢 Зелёный", value = Color3.fromRGB(0, 255, 0)},
            {name = "🩷 Розовый", value = Color3.fromRGB(255, 105, 180)},
            {name = "⚪ Белый", value = Color3.fromRGB(255, 255, 255)}
        }
        local currentIndex = 1
        for i, c in ipairs(colors) do
            if c.value == espColor then currentIndex = i end
        end
        colorBtn.Text = "🎨 Цвет ESP: " .. colors[currentIndex].name
        colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        colorBtn.BackgroundTransparency = 0.2
        colorBtn.Font = Enum.Font.SourceSansBold
        colorBtn.TextSize = 15
        colorBtn.BorderSizePixel = 1
        colorBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        colorBtn.ZIndex = 10
        
        colorBtn.MouseEnter:Connect(function()
            colorBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 65)
        end)
        colorBtn.MouseLeave:Connect(function()
            colorBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        
        colorBtn.MouseButton1Click:Connect(function()
            currentIndex = currentIndex % #colors + 1
            espColor = colors[currentIndex].value
            colorBtn.Text = "🎨 Цвет ESP: " .. colors[currentIndex].name
            if states.esp then
                for _, obj in pairs(espObjects) do
                    if obj.box then obj.box.Color3 = espColor end
                    if obj.label then obj.label.TextColor3 = espColor end
                end
            end
        end)
        
        -- Закрыть
        local closeBtn = Instance.new("TextButton", contentFrame)
        closeBtn.Size = UDim2.new(1, 0, 0, 40)
        closeBtn.Text = "⛔ ЗАКРЫТЬ"
        closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        closeBtn.BackgroundTransparency = 0.2
        closeBtn.Font = Enum.Font.SourceSansBold
        closeBtn.TextSize = 16
        closeBtn.BorderSizePixel = 1
        closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.ZIndex = 10
        
        closeBtn.MouseEnter:Connect(function()
            closeBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
        end)
        closeBtn.MouseLeave:Connect(function()
            closeBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        end)
        
        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
            if flyControls then flyControls:Destroy() end
        end)
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 52)
end

updateContent()

print("✅ PRISON RP ULTRA V53 by shasik_1488 загружен!")
