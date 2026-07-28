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

-- ============================================
-- ОБХОД АНТИЧИТА
-- ============================================
pcall(function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            local n = v.Name:lower()
            if n:find("anticheat") or n:find("anti") or n:find("detect") or n:find("cheat") or n:find("security") or n:find("exploit") or n:find("health") or n:find("damage") or n:find("heal") or n:find("ban") or n:find("kick") or n:find("log") or n:find("report") or n:find("admin") or n:find("prison") or n:find("police") or n:find("warden") then
                v.Disabled = true
            end
        end
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("anti") or n:find("detect") or n:find("health") or n:find("damage") or n:find("heal") or n:find("ban") or n:find("kick") or n:find("log") or n:find("report") or n:find("prison") or n:find("police") or n:find("warden") then
                v:Destroy()
            end
        end
    end
    local oldKick = player.Kick
    player.Kick = function() return nil end
    local oldBan = player.Ban
    player.Ban = function() return nil end
    if getgenv then
        getgenv().detected = false
        getgenv().secure = true
    end
end)

print("✅ АНТИЧИТ ОБОЙДЁН!")

-- ============================================
-- ЗВУК
-- ============================================
function playClick()
    pcall(function()
        local s = Instance.new("Sound", workspace)
        s.SoundId = "rbxassetid://9120381960"
        s.Volume = 0.3
        s.PlayOnRemove = true
        s:Play()
        task.wait(0.2)
        s:Destroy()
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

-- ============================================
-- НАСТРОЙКИ
-- ============================================
local settings = {
    speedValue = 100,
    flySpeed = 100,
    jumpPower = 150,
    theme = "dark",
    iconSize = 50,
    menuAlpha = 10,
    camFovValue = 70,
    fovRadius = 200
}

local states = {
    noclip = false,
    fly = false,
    speed = false,
    highjump = false,
    aimbot = false,
    hitbox = "Head",
    camFov = false,
    fov = false,
    invisible = false,
    esp = false,
    espName = false,
    espDist = false,
    espHealth = false
}

local connections = {}
local flyBV = nil
local flyBodyGyro = nil
local currentCategory = 1
local tpMenuOpen = false
local tpFrame = nil
local espObjects = {}
local espConnections = {}
local espColor = Color3.fromRGB(255, 215, 0)
local healthColor = Color3.fromRGB(0, 255, 0)

-- ============================================
-- МЕНЮ
-- ============================================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 520)
frame.Position = UDim2.new(0.5, -250, 0.5, -260)
frame.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(6, 6, 22) or Color3.fromRGB(240, 240, 255)
frame.BackgroundTransparency = settings.menuAlpha / 100
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
border.Color = settings.theme == "dark" and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(100, 100, 200)
border.Thickness = 2.5
border.Transparency = 0.3

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
subtitle.Position = UDim2.new(0, 0, 0, 47)
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
    btn.TextColor3 = settings.theme == "dark" and Color3.fromRGB(180, 180, 240) or Color3.fromRGB(50, 50, 150)
    btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(20, 20, 45) or Color3.fromRGB(200, 200, 230)
    btn.BackgroundTransparency = 0.4
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(catBtns) do
            b.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(20, 20, 45) or Color3.fromRGB(200, 200, 230)
            b.TextColor3 = settings.theme == "dark" and Color3.fromRGB(180, 180, 240) or Color3.fromRGB(50, 50, 150)
        end
        btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(40, 40, 90) or Color3.fromRGB(150, 150, 220)
        btn.TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(0, 0, 150)
        currentCategory = i
        updateContent()
    end)
    catBtns[i] = btn
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.3, 0)
end
catBtns[1].BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(40, 40, 90) or Color3.fromRGB(150, 150, 220)
catBtns[1].TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(0, 0, 150)

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
contentFrame.ScrollBarImageColor3 = settings.theme == "dark" and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(100, 100, 200)

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

function createRGBSlider(parent, labelText, callback, r, g, b)
    local container = Instance.new("Frame", parent)
    container.Size = UDim2.new(1, 0, 0, 90)
    container.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 1
    container.BorderColor3 = Color3.fromRGB(100, 100, 200)
    container.ZIndex = 10
    Instance.new("UICorner", container).CornerRadius = UDim.new(0.1, 0)
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.ZIndex = 10
    
    local function makeSlider(name, defaultValue, color, yPos)
        local bg = Instance.new("Frame", container)
        bg.Size = UDim2.new(1, 0, 0, 12)
        bg.Position = UDim2.new(0, 0, 0, yPos)
        bg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        bg.BorderSizePixel = 0
        bg.ZIndex = 10
        Instance.new("UICorner", bg).CornerRadius = UDim.new(0.2, 0)
        
        local fill = Instance.new("Frame", bg)
        fill.Size = UDim2.new(defaultValue, 0, 1, 0)
        fill.BackgroundColor3 = color
        fill.BorderSizePixel = 0
        fill.ZIndex = 10
        Instance.new("UICorner", fill).CornerRadius = UDim.new(0.2, 0)
        
        local dragging = false
        bg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                local pos = input.Position.X - bg.AbsolutePosition.X
                local value = math.clamp(pos / bg.AbsoluteSize.X, 0, 1)
                callback(value, name)
                fill.Size = UDim2.new(value, 0, 1, 0)
            end
        end)
        bg.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
                local pos = input.Position.X - bg.AbsolutePosition.X
                local value = math.clamp(pos / bg.AbsoluteSize.X, 0, 1)
                callback(value, name)
                fill.Size = UDim2.new(value, 0, 1, 0)
            end
        end)
        bg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    
    makeSlider("R", r, Color3.fromRGB(255, 0, 0), 28)
    makeSlider("G", g, Color3.fromRGB(0, 255, 0), 50)
    makeSlider("B", b, Color3.fromRGB(0, 0, 255), 72)
    
    return container
end

-- ============================================
-- ФУНКЦИИ ПЕРСОНАЖА
-- ============================================
function toggleNoClip()
    playClick()
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
    updateContent()
end

function toggleFly()
    playClick()
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
    updateContent()
end

function toggleSpeed()
    playClick()
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
    updateContent()
end

function toggleHighJump()
    playClick()
    states.highjump = not states.highjump
    if states.highjump then
        if humanoid then
            humanoid.JumpPower = settings.jumpPower or 150
        end
        if connections.highjump then connections.highjump:Disconnect() end
        connections.highjump = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.highjump then return end
            if not humanoid or not humanoid.Parent then return end
            humanoid.JumpPower = settings.jumpPower or 150
        end)
        notify("Высокий прыжок", true)
    else
        if connections.highjump then connections.highjump:Disconnect(); connections.highjump = nil end
        if humanoid then humanoid.JumpPower = 50 end
        notify("Высокий прыжок", false)
    end
    updateContent()
end

function toggleInvisible()
    playClick()
    states.invisible = not states.invisible
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
    updateContent()
end

function toggleTeleport()
    playClick()
    if tpMenuOpen then
        if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
        tpMenuOpen = false
        return
    end
    tpMenuOpen = true
    
    tpFrame = Instance.new("ScreenGui", game.CoreGui)
    local frameTp = Instance.new("Frame", tpFrame)
    frameTp.Size = UDim2.new(0, 320, 0, 420)
    frameTp.Position = UDim2.new(0.5, -160, 0.5, -210)
    frameTp.BackgroundColor3 = Color3.fromRGB(6, 6, 22)
    frameTp.BackgroundTransparency = 0.1
    frameTp.Active = true
    frameTp.Draggable = true
    frameTp.ClipsDescendants = true
    frameTp.BorderSizePixel = 0
    frameTp.ZIndex = 20
    
    local glassTp = Instance.new("Frame", frameTp)
    glassTp.Size = UDim2.new(1, 0, 1, 0)
    glassTp.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glassTp.BackgroundTransparency = 0.97
    glassTp.BorderSizePixel = 0
    glassTp.ZIndex = 1
    
    local borderTp = Instance.new("UIStroke", frameTp)
    borderTp.Color = Color3.fromRGB(0, 200, 255)
    borderTp.Thickness = 2
    borderTp.Transparency = 0.3
    
    local titleTp = Instance.new("TextLabel", frameTp)
    titleTp.Size = UDim2.new(1, 0, 0, 45)
    titleTp.Text = "📌 ТП к игроку"
    titleTp.TextColor3 = Color3.fromRGB(0, 220, 255)
    titleTp.BackgroundTransparency = 1
    titleTp.Font = Enum.Font.GothamBold
    titleTp.TextSize = 20
    titleTp.ZIndex = 21
    
    local closeBtn = Instance.new("TextButton", frameTp)
    closeBtn.Size = UDim2.new(0, 35, 0, 35)
    closeBtn.Position = UDim2.new(1, -40, 0, 5)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.ZIndex = 22
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0.3, 0)
    closeBtn.MouseButton1Click:Connect(function()
        tpFrame:Destroy()
        tpMenuOpen = false
    end)
    
    local scroll = Instance.new("ScrollingFrame", frameTp)
    scroll.Size = UDim2.new(1, -20, 1, -60)
    scroll.Position = UDim2.new(0, 10, 0, 50)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ClipsDescendants = true
    scroll.BorderSizePixel = 0
    scroll.ZIndex = 21
    
    local function addPlayer(p)
        if p == player then return end
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.Text = p.Name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.BorderSizePixel = 0
        btn.BackgroundTransparency = 0.3
        btn.ZIndex = 22
        btn.MouseButton1Click:Connect(function()
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                root.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                notify("Телепорт к " .. p.Name, true)
                tpFrame:Destroy()
                tpMenuOpen = false
            end
        end)
    end
    
    for _, p in pairs(game.Players:GetPlayers()) do
        addPlayer(p)
    end
    scroll.CanvasSize = UDim2.new(0, 0, 0, #scroll:GetChildren() * 40)
end

-- ============================================
-- ФУНКЦИИ БОЯ
-- ============================================
function getClosestTarget()
    local closest = nil
    local minDist = math.huge
    local origin = camera.CFrame.Position
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local targetPart = nil
            if states.hitbox == "Head" then
                targetPart = p.Character:FindFirstChild("Head")
            elseif states.hitbox == "Body" then
                targetPart = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("HumanoidRootPart")
            else
                targetPart = p.Character:FindFirstChild("Head") or p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("HumanoidRootPart")
            end
            if targetPart then
                local distance = (targetPart.Position - origin).Magnitude
                if distance < minDist then
                    minDist = distance
                    closest = targetPart
                end
            end
        end
    end
    return closest
end

function toggleAimbot()
    playClick()
    states.aimbot = not states.aimbot
    if states.aimbot then
        if connections.aimbot then connections.aimbot:Disconnect() end
        connections.aimbot = game:GetService("RunService").RenderStepped:Connect(function()
            if not states.aimbot then return end
            local target = getClosestTarget()
            if target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end
        end)
        if connections.silentAim then connections.silentAim:Disconnect() end
        connections.silentAim = game:GetService("RunService").RenderStepped:Connect(function()
            if not states.aimbot then return end
            local target = getClosestTarget()
            if target then
                local oldCF = camera.CFrame
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
                camera.CFrame = oldCF
            end
        end)
        notify("Aimbot", true)
    else
        if connections.aimbot then connections.aimbot:Disconnect(); connections.aimbot = nil end
        if connections.silentAim then connections.silentAim:Disconnect(); connections.silentAim = nil end
        notify("Aimbot", false)
    end
    updateContent()
end

function setHitbox(part)
    playClick()
    states.hitbox = part
    notify("Цель: " .. part, true)
    updateContent()
end

-- ============================================
-- ФУНКЦИИ ESP
-- ============================================
function createESP(target)
    if not target or not target.Character then return end
    local tChar = target.Character
    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = tRoot
    box.Size = Vector3.new(3, 5, 3)
    box.Color3 = espColor
    box.Transparency = 0.5
    box.ZIndex = 10
    box.AlwaysOnTop = true
    box.Parent = tChar
    
    local nameTag = Instance.new("BillboardGui", tChar)
    nameTag.Adornee = tRoot
    nameTag.Size = UDim2.new(0, 200, 0, 80)
    nameTag.StudsOffset = Vector3.new(0, 3.5, 0)
    nameTag.AlwaysOnTop = true
    
    local label = Instance.new("TextLabel", nameTag)
    label.Size = UDim2.new(1, 0, 0.4, 0)
    label.Text = target.Name
    label.TextColor3 = espColor
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Visible = states.espName
    
    local distLabel = Instance.new("TextLabel", nameTag)
    distLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distLabel.Position = UDim2.new(0, 0, 0.4, 0)
    distLabel.Text = "0 м"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 12
    distLabel.Visible = states.espDist
    
    local healthText = Instance.new("TextLabel", nameTag)
    healthText.Size = UDim2.new(1, 0, 0.3, 0)
    healthText.Position = UDim2.new(0, 0, 0.7, 0)
    healthText.Text = "100 HP"
    healthText.TextColor3 = healthColor
    healthText.BackgroundTransparency = 1
    healthText.Font = Enum.Font.GothamBold
    healthText.TextSize = 13
    healthText.Visible = states.espHealth
    
    espObjects[target] = {box = box, nameTag = nameTag, label = label, distLabel = distLabel, healthText = healthText}
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
                if not espObjects[p] then
                    createESP(p)
                else
                    local obj = espObjects[p]
                    local tChar = p.Character
                    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
                    local tHum = tChar:FindFirstChild("Humanoid")
                    if tRoot and tHum then
                        if obj.distLabel then
                            obj.distLabel.Text = math.floor((root.Position - tRoot.Position).Magnitude) .. " м"
                            obj.distLabel.Visible = states.espDist
                        end
                        if obj.label then
                            obj.label.Visible = states.espName
                            obj.label.Text = p.Name
                        end
                        if obj.box then
                            obj.box.Color3 = espColor
                        end
                        if obj.healthText and states.espHealth then
                            local health = math.floor(tHum.Health)
                            local maxHealth = math.floor(tHum.MaxHealth)
                            obj.healthText.Text = health .. " / " .. maxHealth .. " HP"
                            obj.healthText.Visible = true
                            obj.healthText.TextColor3 = healthColor
                        elseif obj.healthText then
                            obj.healthText.Visible = false
                        end
                    end
                end
            else
                removeESP(p)
            end
        end
    end
end

function toggleESP()
    playClick()
    states.esp = not states.esp
    if states.esp then
        updateESP()
        espConnections.PlayerAdded = game.Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                task.wait(1)
                if states.esp then createESP(p) end
            end)
        end)
        espConnections.PlayerRemoving = game.Players.PlayerRemoving:Connect(removeESP)
        if connections.esp then connections.esp:Disconnect() end
        connections.esp = game:GetService("RunService").Heartbeat:Connect(updateESP)
        notify("ESP", true)
    else
        for p, obj in pairs(espObjects) do
            if obj.box then obj.box:Destroy() end
            if obj.nameTag then obj.nameTag:Destroy() end
        end
        espObjects = {}
        for _, conn in pairs(espConnections) do
            if conn then conn:Disconnect() end
        end
        espConnections = {}
        if connections.esp then connections.esp:Disconnect(); connections.esp = nil end
        notify("ESP", false)
    end
    updateContent()
end

function toggleESPName()
    playClick()
    states.espName = not states.espName
    for _, obj in pairs(espObjects) do
        if obj.label then obj.label.Visible = states.espName end
    end
    notify("Имя", states.espName)
    updateContent()
end

function toggleESPDist()
    playClick()
    states.espDist = not states.espDist
    for _, obj in pairs(espObjects) do
        if obj.distLabel then obj.distLabel.Visible = states.espDist end
    end
    notify("Дистанция", states.espDist)
    updateContent()
end

function toggleESPHealth()
    playClick()
    states.espHealth = not states.espHealth
    for _, obj in pairs(espObjects) do
        if obj.healthText then obj.healthText.Visible = states.espHealth end
    end
    notify("ХП", states.espHealth)
    updateContent()
end

function updateESPColor(r, g, b)
    espColor = Color3.new(r, g, b)
    for _, obj in pairs(espObjects) do
        if obj.box then obj.box.Color3 = espColor end
        if obj.label then obj.label.TextColor3 = espColor end
    end
end

function updateHealthColor(r, g, b)
    healthColor = Color3.new(r, g, b)
    for _, obj in pairs(espObjects) do
        if obj.healthText then obj.healthText.TextColor3 = healthColor end
    end
end

-- ============================================
-- ФУНКЦИИ FOV
-- ============================================
local fovCircle = Drawing.new("Circle")
fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
fovCircle.Radius = settings.fovRadius
fovCircle.Visible = false
fovCircle.Color = Color3.fromRGB(0, 255, 0)
fovCircle.Thickness = 2
fovCircle.Filled = false
fovCircle.NumSides = 64
fovCircle.Transparency = 0.5

camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
end)

function updateFOV()
    fovCircle.Radius = settings.fovRadius
    fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
end

function toggleFOV()
    playClick()
    states.fov = not states.fov
    if states.fov then
        fovCircle.Visible = true
        notify("FOV круг", true)
    else
        fovCircle.Visible = false
        notify("FOV круг", false)
    end
    updateContent()
end

function toggleCamFov()
    playClick()
    states.camFov = not states.camFov
    if states.camFov then
        camera.FieldOfView = settings.camFovValue
        notify("Широкий обзор", true)
    else
        camera.FieldOfView = 70
        notify("Широкий обзор", false)
    end
    updateContent()
end

function updateFOVColor(r, g, b)
    fovCircle.Color = Color3.new(r, g, b)
end

-- ============================================
-- ОБНОВЛЕНИЕ КОНТЕНТА
-- ============================================
function updateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if currentCategory == 1 then
        -- ПЕРСОНАЖ
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
        
        local btn4 = Instance.new("TextButton", contentFrame)
        btn4.Size = UDim2.new(1, 0, 0, 40)
        btn4.Text = states.highjump and "🦘 Высокий прыжок [⊂❍]" or "🦘 Высокий прыжок [❍⊃]"
        btn4.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn4.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn4.BackgroundTransparency = 0.2
        btn4.Font = Enum.Font.GothamBold
        btn4.TextSize = 15
        btn4.BorderSizePixel = 1
        btn4.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn4.MouseButton1Click:Connect(function()
            toggleHighJump()
            btn4.Text = states.highjump and "🦘 Высокий прыжок [⊂❍]" or "🦘 Высокий прыжок [❍⊃]"
            btn4.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn4.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn4).CornerRadius = UDim.new(0.1, 0)
        
        local btn5 = Instance.new("TextButton", contentFrame)
        btn5.Size = UDim2.new(1, 0, 0, 40)
        btn5.Text = states.invisible and "🥷 Невидимость [⊂❍]" or "🥷 Невидимость [❍⊃]"
        btn5.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn5.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn5.BackgroundTransparency = 0.2
        btn5.Font = Enum.Font.GothamBold
        btn5.TextSize = 15
        btn5.BorderSizePixel = 1
        btn5.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn5.MouseButton1Click:Connect(function()
            toggleInvisible()
            btn5.Text = states.invisible and "🥷 Невидимость [⊂❍]" or "🥷 Невидимость [❍⊃]"
            btn5.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn5.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn5).CornerRadius = UDim.new(0.1, 0)
        
        local btn6 = Instance.new("TextButton", contentFrame)
        btn6.Size = UDim2.new(1, 0, 0, 40)
        btn6.Text = "📌 ТП к игроку"
        btn6.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn6.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn6.BackgroundTransparency = 0.2
        btn6.Font = Enum.Font.GothamBold
        btn6.TextSize = 15
        btn6.BorderSizePixel = 1
        btn6.BorderColor3 = Color3.fromRGB(100, 100, 200)
        btn6.MouseButton1Click:Connect(function()
            toggleTeleport()
        end)
        Instance.new("UICorner", btn6).CornerRadius = UDim.new(0.1, 0)
        
        if states.speed then
            createSlider(contentFrame, "📏 Скорость", 1, 200, settings.speedValue, function(value)
                settings.speedValue = value
                if states.speed and humanoid then
                    humanoid.WalkSpeed = value
                end
            end)
        end
        if states.fly then
            createSlider(contentFrame, "📏 Скорость Fly", 20, 300, settings.flySpeed, function(value)
                settings.flySpeed = value
            end)
        end
        if states.highjump then
            createSlider(contentFrame, "📏 Высота прыжка", 50, 500, settings.jumpPower, function(value)
                settings.jumpPower = value
                if states.highjump and humanoid then
                    humanoid.JumpPower = value
                end
            end)
        end
        
    elseif currentCategory == 2 then
        -- БОЙ
        local btn = Instance.new("TextButton", contentFrame)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.Text = states.aimbot and "🎯 Aimbot [⊂❍]" or "🎯 Aimbot [❍⊃]"
        btn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btn.BackgroundTransparency = 0.2
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 15
        btn.BorderSizePixel = 1
        btn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btn.MouseButton1Click:Connect(function()
            toggleAimbot()
            btn.Text = states.aimbot and "🎯 Aimbot [⊂❍]" or "🎯 Aimbot [❍⊃]"
            btn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0.1, 0)
        
        local hitboxFrame = Instance.new("Frame", contentFrame)
        hitboxFrame.Size = UDim2.new(1, 0, 0, 45)
        hitboxFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
        hitboxFrame.BackgroundTransparency = 0.3
        hitboxFrame.BorderSizePixel = 1
        hitboxFrame.BorderColor3 = Color3.fromRGB(100, 100, 200)
        hitboxFrame.ZIndex = 10
        Instance.new("UICorner", hitboxFrame).CornerRadius = UDim.new(0.1, 0)
        
        local hitboxLabel = Instance.new("TextLabel", hitboxFrame)
        hitboxLabel.Size = UDim2.new(1, 0, 0, 20)
        hitboxLabel.Text = "🎯 Цель: " .. states.hitbox
        hitboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        hitboxLabel.BackgroundTransparency = 1
        hitboxLabel.Font = Enum.Font.GothamBold
        hitboxLabel.TextSize = 14
        hitboxLabel.ZIndex = 10
        
        local hitboxBg = Instance.new("Frame", hitboxFrame)
        hitboxBg.Size = UDim2.new(1, 0, 0, 20)
        hitboxBg.Position = UDim2.new(0, 0, 0, 22)
        hitboxBg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        hitboxBg.BorderSizePixel = 0
        hitboxBg.ZIndex = 10
        Instance.new("UICorner", hitboxBg).CornerRadius = UDim.new(0.2, 0)
        
        local parts = {"Head", "Body", "Any"}
        for i, part in ipairs(parts) do
            local partBtn = Instance.new("TextButton", hitboxBg)
            partBtn.Size = UDim2.new(0.33, -2, 1, 0)
            partBtn.Position = UDim2.new((i-1)*0.33, 1, 0, 0)
            partBtn.Text = part
            partBtn.TextColor3 = states.hitbox == part and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 255)
            partBtn.BackgroundColor3 = states.hitbox == part and Color3.fromRGB(0, 50, 0) or Color3.fromRGB(20, 20, 50)
            partBtn.BackgroundTransparency = 0.2
            partBtn.Font = Enum.Font.GothamBold
            partBtn.TextSize = 12
            partBtn.BorderSizePixel = 0
            partBtn.ZIndex = 10
            partBtn.MouseButton1Click:Connect(function()
                setHitbox(part)
                hitboxLabel.Text = "🎯 Цель: " .. part
                for _, b in pairs(hitboxBg:GetChildren()) do
                    if b:IsA("TextButton") then
                        b.TextColor3 = b.Text == part and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 255)
                        b.BackgroundColor3 = b.Text == part and Color3.fromRGB(0, 50, 0) or Color3.fromRGB(20, 20, 50)
                    end
                end
            end)
            Instance.new("UICorner", partBtn).CornerRadius = UDim.new(0.2, 0)
        end
        
    elseif currentCategory == 3 then
        -- ESP
        local btnEsp = Instance.new("TextButton", contentFrame)
        btnEsp.Size = UDim2.new(1, 0, 0, 40)
        btnEsp.Text = states.esp and "👁️ ESP [⊂❍]" or "👁️ ESP [❍⊃]"
        btnEsp.TextColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btnEsp.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btnEsp.BackgroundTransparency = 0.2
        btnEsp.Font = Enum.Font.GothamBold
        btnEsp.TextSize = 15
        btnEsp.BorderSizePixel = 1
        btnEsp.BorderColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btnEsp.MouseButton1Click:Connect(function()
            toggleESP()
            btnEsp.Text = states.esp and "👁️ ESP [⊂❍]" or "👁️ ESP [❍⊃]"
            btnEsp.TextColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btnEsp.BorderColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btnEsp).CornerRadius = UDim.new(0.1, 0)
        
        local btnName = Instance.new("TextButton", contentFrame)
        btnName.Size = UDim2.new(1, 0, 0, 40)
        btnName.Text = states.espName and "👤 Имя [⊂❍]" or "👤 Имя [❍⊃]"
        btnName.TextColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btnName.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btnName.BackgroundTransparency = 0.2
        btnName.Font = Enum.Font.GothamBold
        btnName.TextSize = 15
        btnName.BorderSizePixel = 1
        btnName.BorderColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btnName.MouseButton1Click:Connect(function()
            toggleESPName()
            btnName.Text = states.espName and "👤 Имя [⊂❍]" or "👤 Имя [❍⊃]"
            btnName.TextColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btnName.BorderColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btnName).CornerRadius = UDim.new(0.1, 0)
        
        local btnDist = Instance.new("TextButton", contentFrame)
        btnDist.Size = UDim2.new(1, 0, 0, 40)
        btnDist.Text = states.espDist and "📏 Дистанция [⊂❍]" or "📏 Дистанция [❍⊃]"
        btnDist.TextColor3 = states.espDist and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btnDist.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btnDist.BackgroundTransparency = 0.2
        btnDist.Font = Enum.Font.GothamBold
        btnDist.TextSize = 15
        btnDist.BorderSizePixel = 1
        btnDist.BorderColor3 = states.espDist and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btnDist.MouseButton1Click:Connect(function()
            toggleESPDist()
            btnDist.Text = states.espDist and "📏 Дистанция [⊂❍]" or "📏 Дистанция [❍⊃]"
            btnDist.TextColor3 = states.espDist and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btnDist.BorderColor3 = states.espDist and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btnDist).CornerRadius = UDim.new(0.1, 0)
        
        local btnHealth = Instance.new("TextButton", contentFrame)
        btnHealth.Size = UDim2.new(1, 0, 0, 40)
        btnHealth.Text = states.espHealth and "❤️ ХП [⊂❍]" or "❤️ ХП [❍⊃]"
        btnHealth.TextColor3 = states.espHealth and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btnHealth.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btnHealth.BackgroundTransparency = 0.2
        btnHealth.Font = Enum.Font.GothamBold
        btnHealth.TextSize = 15
        btnHealth.BorderSizePixel = 1
        btnHealth.BorderColor3 = states.espHealth and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btnHealth.MouseButton1Click:Connect(function()
            toggleESPHealth()
            btnHealth.Text = states.espHealth and "❤️ ХП [⊂❍]" or "❤️ ХП [❍⊃]"
            btnHealth.TextColor3 = states.espHealth and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btnHealth.BorderColor3 = states.espHealth and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btnHealth).CornerRadius = UDim.new(0.1, 0)
        
        createRGBSlider(contentFrame, "🎨 Цвет ESP", function(value, channel)
            local r = espColor.r
            local g = espColor.g
            local b = espColor.b
            if channel == "R" then r = value
            elseif channel == "G" then g = value
            elseif channel == "B" then b = value end
            updateESPColor(r, g, b)
        end, espColor.r, espColor.g, espColor.b)
        
        createRGBSlider(contentFrame, "❤️ Цвет ХП", function(value, channel)
            local r = healthColor.r
            local g = healthColor.g
            local b = healthColor.b
            if channel == "R" then r = value
            elseif channel == "G" then g = value
            elseif channel == "B" then b = value end
            updateHealthColor(r, g, b)
        end, healthColor.r, healthColor.g, healthColor.b)
        
    elseif currentCategory == 4 then
        -- FOV
        local btnFov = Instance.new("TextButton", contentFrame)
        btnFov.Size = UDim2.new(1, 0, 0, 40)
        btnFov.Text = states.fov and "🎯 FOV круг [⊂❍]" or "🎯 FOV круг [❍⊃]"
        btnFov.TextColor3 = states.fov and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btnFov.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btnFov.BackgroundTransparency = 0.2
        btnFov.Font = Enum.Font.GothamBold
        btnFov.TextSize = 15
        btnFov.BorderSizePixel = 1
        btnFov.BorderColor3 = states.fov and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btnFov.MouseButton1Click:Connect(function()
            toggleFOV()
            btnFov.Text = states.fov and "🎯 FOV круг [⊂❍]" or "🎯 FOV круг [❍⊃]"
            btnFov.TextColor3 = states.fov and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btnFov.BorderColor3 = states.fov and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btnFov).CornerRadius = UDim.new(0.1, 0)
        
        createSlider(contentFrame, "📏 Радиус FOV", 50, 500, settings.fovRadius, function(value)
            settings.fovRadius = value
            fovCircle.Radius = value
            updateFOV()
        end)
        
        createRGBSlider(contentFrame, "🎨 Цвет FOV", function(value, channel)
            local r = fovCircle.Color.r
            local g = fovCircle.Color.g
            local b = fovCircle.Color.b
            if channel == "R" then r = value
            elseif channel == "G" then g = value
            elseif channel == "B" then b = value end
            updateFOVColor(r, g, b)
        end, fovCircle.Color.r, fovCircle.Color.g, fovCircle.Color.b)
        
        local btnCam = Instance.new("TextButton", contentFrame)
        btnCam.Size = UDim2.new(1, 0, 0, 40)
        btnCam.Text = states.camFov and "📷 Широкий обзор [⊂❍]" or "📷 Широкий обзор [❍⊃]"
        btnCam.TextColor3 = states.camFov and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        btnCam.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        btnCam.BackgroundTransparency = 0.2
        btnCam.Font = Enum.Font.GothamBold
        btnCam.TextSize = 15
        btnCam.BorderSizePixel = 1
        btnCam.BorderColor3 = states.camFov and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        btnCam.MouseButton1Click:Connect(function()
            toggleCamFov()
            btnCam.Text = states.camFov and "📷 Широкий обзор [⊂❍]" or "📷 Широкий обзор [❍⊃]"
            btnCam.TextColor3 = states.camFov and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            btnCam.BorderColor3 = states.camFov and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", btnCam).CornerRadius = UDim.new(0.1, 0)
        
        createSlider(contentFrame, "📐 Угол обзора", 50, 120, settings.camFovValue, function(value)
            settings.camFovValue = value
            if states.camFov then
                camera.FieldOfView = value
            end
        end)
        
    elseif currentCategory == 5 then
        -- НАСТРОЙКИ
        local themeBtn = Instance.new("TextButton", contentFrame)
        themeBtn.Size = UDim2.new(1, 0, 0, 40)
        themeBtn.Text = settings.theme == "dark" and "🌙 Тёмная тема [⊂❍]" or "☀️ Светлая тема [⊂❍]"
        themeBtn.TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        themeBtn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(20, 20, 50) or Color3.fromRGB(200, 200, 230)
        themeBtn.BackgroundTransparency = 0.2
        themeBtn.Font = Enum.Font.GothamBold
        themeBtn.TextSize = 15
        themeBtn.BorderSizePixel = 1
        themeBtn.BorderColor3 = Color3.fromRGB(100, 100, 200)
        themeBtn.MouseButton1Click:Connect(function()
            settings.theme = settings.theme == "dark" and "light" or "dark"
            themeBtn.Text = settings.theme == "dark" and "🌙 Тёмная тема [⊂❍]" or "☀️ Светлая тема [⊂❍]"
            themeBtn.TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
            themeBtn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(20, 20, 50) or Color3.fromRGB(200, 200, 230)
            frame.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(6, 6, 22) or Color3.fromRGB(240, 240, 255)
            border.Color = settings.theme == "dark" and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(100, 100, 200)
            title.TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 0, 100)
            subtitle.TextColor3 = settings.theme == "dark" and Color3.fromRGB(150, 150, 255) or Color3.fromRGB(50, 50, 150)
            for _, btn in pairs(catBtns) do
                if btn.TextColor3 == (settings.theme == "dark" and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(0, 0, 150)) then
                    btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(40, 40, 90) or Color3.fromRGB(150, 150, 220)
                else
                    btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(20, 20, 45) or Color3.fromRGB(200, 200, 230)
                    btn.TextColor3 = settings.theme == "dark" and Color3.fromRGB(180, 180, 240) or Color3.fromRGB(50, 50, 150)
                end
            end
            contentFrame.ScrollBarImageColor3 = settings.theme == "dark" and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(100, 100, 200)
        end)
        Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0.1, 0)
        
        local soundBtn = Instance.new("TextButton", contentFrame)
        soundBtn.Size = UDim2.new(1, 0, 0, 40)
        soundBtn.Text = "🔊 Звук [⊂❍]"
        soundBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        soundBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        soundBtn.BackgroundTransparency = 0.2
        soundBtn.Font = Enum.Font.GothamBold
        soundBtn.TextSize = 15
        soundBtn.BorderSizePixel = 1
        soundBtn.BorderColor3 = Color3.fromRGB(100, 100, 200)
        soundBtn.MouseButton1Click:Connect(function()
            soundEnabled = not soundEnabled
            soundBtn.Text = soundEnabled and "🔊 Звук [⊂❍]" or "🔇 Звук [❍⊃]"
            notify("Звук", soundEnabled)
        end)
        Instance.new("UICorner", soundBtn).CornerRadius = UDim.new(0.1, 0)
        
        createSlider(contentFrame, "📏 Размер иконки", 30, 80, settings.iconSize, function(value)
            settings.iconSize = value
            iconBtn.Size = UDim2.new(0, value, 0, value)
            iconBtn.TextSize = value * 0.6
        end)
        
        createSlider(contentFrame, "🔆 Прозрачность", 5, 50, settings.menuAlpha, function(value)
            settings.menuAlpha = value
            frame.BackgroundTransparency = value / 100
        end)
        
        local resetBtn = Instance.new("TextButton", contentFrame)
        resetBtn.Size = UDim2.new(1, 0, 0, 40)
        resetBtn.Text = "🔄 Сбросить настройки"
        resetBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
        resetBtn.BackgroundColor3 = Color3.fromRGB(50, 10, 10)
        resetBtn.BackgroundTransparency = 0.2
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 15
        resetBtn.BorderSizePixel = 1
        resetBtn.BorderColor3 = Color3.fromRGB(255, 100, 100)
        resetBtn.MouseButton1Click:Connect(function()
            settings.speedValue = 100
            settings.flySpeed = 100
            settings.jumpPower = 150
            settings.theme = "dark"
            settings.iconSize = 50
            settings.menuAlpha = 10
            settings.camFovValue = 70
            settings.fovRadius = 200
            updateContent()
            notify("Настройки сброшены", true)
        end)
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0.1, 0)
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 52)
end

updateContent()

-- ============================================
-- ПЛАВНОЕ ОТКРЫТИЕ ПРИ ЗАПУСКЕ
-- ============================================
frame.BackgroundTransparency = 1
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)

task.spawn(function()
    local targetSize = UDim2.new(0, 500, 0, 520)
    local targetPos = UDim2.new(0.5, -250, 0.5, -260)
    for i = 1, 30 do
        local t = i / 30
        local ease = t * t * (3 - 2 * t)
        frame.Size = UDim2.new(0, 500 * ease, 0, 520 * ease)
        frame.Position = UDim2.new(0.5, -250 * ease, 0.5, -260 * ease)
        frame.BackgroundTransparency = (settings.menuAlpha / 100) * (1 - ease)
        task.wait(0.015)
    end
    frame.Size = targetSize
    frame.Position = targetPos
    frame.BackgroundTransparency = settings.menuAlpha / 100
end)

-- ============================================
-- ИКОНКА
-- ============================================
local iconGui = Instance.new("ScreenGui", game.CoreGui)
iconGui.Name = "IconGui"
iconGui.ResetOnSpawn = false

local iconBtn = Instance.new("TextButton", iconGui)
iconBtn.Size = UDim2.new(0, settings.iconSize, 0, settings.iconSize)
iconBtn.Position = UDim2.new(0.85, 0, 0.05, 0)
iconBtn.Text = "🪐"
iconBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
iconBtn.BackgroundColor3 = Color3.fromRGB(6, 6, 20)
iconBtn.BackgroundTransparency = 0.05
iconBtn.Font = Enum.Font.GothamBold
iconBtn.TextSize = settings.iconSize * 0.6
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
        iconBtn.Size = UDim2.new(0, settings.iconSize + math.sin(t) * 0.5, 0, settings.iconSize + math.sin(t) * 0.5)
        task.wait(0.02)
    end
end)

local isDragging = false
local dragStartPos = nil
local dragStartMouse = nil
local hasMoved = false

iconBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = true
        hasMoved = false
        dragStartPos = Vector2.new(iconBtn.Position.X.Scale, iconBtn.Position.Y.Scale)
        dragStartMouse = input.Position
    end
end)

iconBtn.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStartMouse
        if delta.Magnitude > 5 then
            hasMoved = true
        end
        local newX = math.clamp(dragStartPos.X + delta.X / 1920, 0.01, 0.98)
        local newY = math.clamp(dragStartPos.Y + delta.Y / 1080, 0.01, 0.98)
        iconBtn.Position = UDim2.new(newX, 0, newY, 0)
    end
end)

iconBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
        if not hasMoved then
            toggleMenu()
        end
    end
end)

local menuAnimating = false
local menuVisible = true

function toggleMenu()
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
            frame.BackgroundTransparency = (settings.menuAlpha / 100) * (1 - ease)
            task.wait(0.01)
        end
        frame.Size = targetSize
        frame.Position = targetPos
        frame.BackgroundTransparency = settings.menuAlpha / 100
    else
        for i = 1, 25 do
            local t = i / 25
            local ease = t * t * (3 - 2 * t)
            frame.Size = UDim2.new(0, 500 * (1 - ease), 0, 520 * (1 - ease))
            frame.Position = UDim2.new(0.5, -250 * (1 - ease), 0.5, -260 * (1 - ease))
            frame.BackgroundTransparency = (settings.menuAlpha / 100) + 0.9 * ease
            task.wait(0.01)
        end
        frame.Size = UDim2.new(0, 0, 0, 0)
        frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        frame.BackgroundTransparency = 1
    end
    menuAnimating = false
end

print("✅ SHASIK_1488 ULTIMATE EDITION ЗАГРУЖЕН!")
