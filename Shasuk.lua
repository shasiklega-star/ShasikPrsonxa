-- ============================================
-- ULTRA MEGA CHEAT V21.0 (ИДЕАЛЬНЫЙ)
-- by shasik_1488 | БЕЗ БАГОВ
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
    invisible = false,
    tp = false
}

local connections = {}
local speedValue = 100
local flySpeed = 100
local nc_cache = {}
local espObjects = {}
local espConnections = {}
local flyKeys = {w = false, a = false, s = false, d = false, space = false, shift = false}
local flyBV = nil
local flyBodyGyro = nil
local flyControls = nil
local tpFrame = nil
local tpMenuOpen = false
local menuCollapsed = false

-- ============================================
-- ЗВУК
-- ============================================
function playSound(state)
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = "rbxassetid://9120381960"
    sound.Volume = 0.15
    sound.PlayOnRemove = true
    sound:Play()
    wait(0.3)
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
-- ПЕРЕПОДКЛЮЧЕНИЕ К ПЕРСОНАЖУ
-- ============================================
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if states.highjump then toggleHighJump() end
    if states.speed then toggleSpeed() end
    if states.noclip then toggleNoClip() end
    if states.fly then toggleFly() end
    if states.invisible then toggleInvisible() end
end)

-- ============================================
-- ВЫСОКИЙ ПРЫЖОК
-- ============================================
function toggleHighJump()
    states.highjump = not states.highjump
    playSound(states.highjump)
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

-- ============================================
-- СПИДХАК
-- ============================================
function toggleSpeed()
    states.speed = not states.speed
    playSound(states.speed)
    if states.speed then
        if connections.speed then connections.speed:Disconnect() end
        connections.speed = game:GetService("RunService").Heartbeat:Connect(function()
            if states.speed and humanoid and humanoid.Parent then
                humanoid.WalkSpeed = speedValue
            end
        end)
        sliderFrame.Visible = true
        speedToggle.Text = "⚡ Спидхак    [⊂❍]"
        speedToggle.TextColor3 = Color3.fromRGB(0, 255, 100)
        speedToggle.BorderColor3 = Color3.fromRGB(0, 255, 100)
    else
        if connections.speed then connections.speed:Disconnect(); connections.speed = nil end
        if humanoid and humanoid.Parent then humanoid.WalkSpeed = 16 end
        sliderFrame.Visible = false
        speedToggle.Text = "⚡ Спидхак    [❍⊃]"
        speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedToggle.BorderColor3 = Color3.fromRGB(0, 150, 255)
    end
    notify("Спидхак", states.speed)
end

function updateSpeed(value)
    speedValue = math.clamp(value, 1, 200)
    if states.speed and humanoid and humanoid.Parent then
        humanoid.WalkSpeed = speedValue
    end
    sliderLabel.Text = "Скорость: " .. math.floor(speedValue)
    sliderFill.Size = UDim2.new(speedValue/200, 0, 1, 0)
end

-- ============================================
-- NO CLIP
-- ============================================
function toggleNoClip()
    states.noclip = not states.noclip
    playSound(states.noclip)
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

-- ============================================
-- FLY
-- ============================================
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
    playSound(states.fly)
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
            if move.Magnitude > 0 then flyBV.Velocity = move.Unit * flySpeed else flyBV.Velocity = Vector3.new(0, 0, 0) end
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

-- ============================================
-- ESP
-- ============================================
function createESP(target)
    if not target or not target.Character then return end
    local tChar = target.Character
    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = tRoot
    box.Size = Vector3.new(3, 5, 2)
    box.Color3 = Color3.fromRGB(255, 0, 0)
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
    label.TextColor3 = Color3.fromRGB(255, 0, 0)
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
    playSound(states.esp)
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

-- ============================================
-- AIMBOT
-- ============================================
function getClosestPlayer()
    local closest = nil
    local shortestDistance = math.huge
    local origin = camera.CFrame.Position
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
    if target and target.Character and target.Character:FindFirstChild("Head") then
        local head = target.Character.Head
        local headPos = head.Position
        local screenPos, onScreen = camera:WorldToScreenPoint(headPos)
        if onScreen then
            mouse.Move(Vector2.new(screenPos.X, screenPos.Y))
        end
    end
end

function toggleAimbot()
    states.aimbot = not states.aimbot
    playSound(states.aimbot)
    if states.aimbot then
        if connections.aimbot then connections.aimbot:Disconnect() end
        connections.aimbot = game:GetService("RunService").RenderStepped:Connect(aimbot)
        notify("Aimbot", true)
    else
        if connections.aimbot then connections.aimbot:Disconnect(); connections.aimbot = nil end
        notify("Aimbot", false)
    end
end

-- ============================================
-- НЕВИДИМОСТЬ
-- ============================================
function toggleInvisible()
    states.invisible = not states.invisible
    playSound(states.invisible)
    if states.invisible then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") or v:IsA("Shirt") or v:IsA("Pants") then
                v:Destroy()
            end
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
-- ТЕЛЕПОРТ К ИГРОКУ
-- ============================================
function toggleTeleport()
    tpMenuOpen = not tpMenuOpen
    if tpMenuOpen then
        if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
        local tpGui = Instance.new("ScreenGui", game.CoreGui)
        tpGui.Name = "TeleportMenu"
        tpGui.ResetOnSpawn = false
        
        tpFrame = Instance.new("Frame", tpGui)
        tpFrame.Size = UDim2.new(0, 280, 0, 350)
        tpFrame.Position = UDim2.new(0.5, -140, 0.3, 0)
        tpFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
        tpFrame.BackgroundTransparency = 0.15
        tpFrame.BorderSizePixel = 2
        tpFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
        tpFrame.ClipsDescendants = true
        tpFrame.Active = true
        tpFrame.Draggable = true
        
        local stroke = Instance.new("UIStroke", tpFrame)
        stroke.Color = Color3.fromRGB(0, 200, 255)
        stroke.Thickness = 3
        stroke.Transparency = 0.5
        
        local tpTitle = Instance.new("TextLabel", tpFrame)
        tpTitle.Size = UDim2.new(1, 0, 0, 45)
        tpTitle.Text = "📌 ТЕЛЕПОРТ К ИГРОКУ"
        tpTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
        tpTitle.BackgroundTransparency = 1
        tpTitle.Font = Enum.Font.SourceSansBold
        tpTitle.TextSize = 20
        
        local tpScroll = Instance.new("ScrollingFrame", tpFrame)
        tpScroll.Size = UDim2.new(1, -20, 1, -60)
        tpScroll.Position = UDim2.new(0, 10, 0, 50)
        tpScroll.BackgroundTransparency = 1
        tpScroll.ScrollBarThickness = 6
        tpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        tpScroll.ClipsDescendants = true
        tpScroll.BorderSizePixel = 0
        
        local tpLayout = Instance.new("UIListLayout", tpScroll)
        tpLayout.Padding = UDim.new(0, 5)
        tpLayout.SortOrder = Enum.SortOrder.LayoutOrder
        
        local function addPlayerButton(p)
            local btn = Instance.new("TextButton", tpScroll)
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Text = p.Name
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 15
            btn.BorderSizePixel = 0
            btn.BackgroundTransparency = 0.3
            
            btn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = p.Character.HumanoidRootPart
                    root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                    notify("Телепорт к " .. p.Name, true)
                end
            end)
        end
        
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then addPlayerButton(p) end
        end
        tpScroll.CanvasSize = UDim2.new(0, 0, 0, #tpScroll:GetChildren() * 45)
        
        local tpClose = Instance.new("TextButton", tpFrame)
        tpClose.Size = UDim2.new(0, 35, 0, 35)
        tpClose.Position = UDim2.new(1, -40, 0, 5)
        tpClose.Text = "✕"
        tpClose.TextColor3 = Color3.fromRGB(255, 50, 50)
        tpClose.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        tpClose.Font = Enum.Font.SourceSansBold
        tpClose.TextSize = 18
        tpClose.MouseButton1Click:Connect(function()
            tpFrame.Parent:Destroy()
            tpMenuOpen = false
        end)
        
        game.Players.PlayerAdded:Connect(function(p)
            if tpMenuOpen and p ~= player then
                addPlayerButton(p)
                tpScroll.CanvasSize = UDim2.new(0, 0, 0, #tpScroll:GetChildren() * 45)
            end
        end)
    else
        if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
    end
end

-- ============================================
-- ГЛАВНОЕ МЕНЮ (ИДЕАЛЬНОЕ)
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

-- ============================================
-- НЕОНОВАЯ ПАНЕЛЬ
-- ============================================
local panel = Instance.new("ImageButton", gui)
panel.Size = UDim2.new(0.4, 0, 0, 40)
panel.Position = UDim2.new(0.3, 0, 0, -40)
panel.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
panel.BackgroundTransparency = 0.1
panel.BorderSizePixel = 0
panel.Image = ""
panel.ZIndex = 10

local strokePanel = Instance.new("UIStroke", panel)
strokePanel.Color = Color3.fromRGB(0, 200, 255)
strokePanel.Thickness = 3
strokePanel.Transparency = 0.4

-- Анимация свечения
local colors = {
    Color3.fromRGB(0, 200, 255),
    Color3.fromRGB(255, 0, 200),
    Color3.fromRGB(200, 0, 255),
    Color3.fromRGB(0, 255, 200),
    Color3.fromRGB(255, 200, 0),
}
local colorIndex = 1
spawn(function()
    while true do
        strokePanel.Color = colors[colorIndex]
        panel.BorderColor3 = colors[colorIndex]
        wait(0.6)
        colorIndex = colorIndex % #colors + 1
    end
end)

local panelLabel = Instance.new("TextLabel", panel)
panelLabel.Size = UDim2.new(1, 0, 1, 0)
panelLabel.Text = "✦ shasik_1488 ✦  [▼]"
panelLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
panelLabel.BackgroundTransparency = 1
panelLabel.Font = Enum.Font.SourceSansBold
panelLabel.TextSize = 18

-- ============================================
-- ОСНОВНОЕ МЕНЮ
-- ============================================
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 340, 0, 520)
frame.Position = UDim2.new(0.5, -170, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 200, 255)
frame.ZIndex = 5

local stroke1 = Instance.new("UIStroke", frame)
stroke1.Color = Color3.fromRGB(0, 200, 255)
stroke1.Thickness = 2
stroke1.Transparency = 0.5

local stroke2 = Instance.new("UIStroke", frame)
stroke2.Color = Color3.fromRGB(255, 0, 200)
stroke2.Thickness = 1
stroke2.Transparency = 0.8

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 30))
})
gradient.Rotation = 30

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.Text = "PRISON RP | ULTRA EDITION"
subtitle.TextColor3 = Color3.fromRGB(200, 150, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 14

local line = Instance.new("Frame", frame)
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 80)
line.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
line.BorderSizePixel = 0

local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, -20, 1, -100)
scrollFrame.Position = UDim2.new(0, 10, 0, 90)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ClipsDescendants = true
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- КНОПКИ
speedToggle = Instance.new("TextButton", scrollFrame)
speedToggle.Size = UDim2.new(1, 0, 0, 38)
speedToggle.Text = "⚡ Спидхак    [❍⊃]"
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
speedToggle.Font = Enum.Font.SourceSansBold
speedToggle.TextSize = 15
speedToggle.BorderSizePixel = 1
speedToggle.BorderColor3 = Color3.fromRGB(0, 150, 255)
speedToggle.BackgroundTransparency = 0.3
speedToggle.MouseButton1Click:Connect(toggleSpeed)

local sliderFrame = Instance.new("Frame", scrollFrame)
sliderFrame.Size = UDim2.new(1, 0, 0, 45)
sliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
sliderFrame.Visible = false
sliderFrame.BorderSizePixel = 1
sliderFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
sliderFrame.BackgroundTransparency = 0.3

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
sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
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

local btns = {
    {name = "🦘 Высокий прыжок", func = toggleHighJump, state = "highjump"},
    {name = "👻 No Clip", func = toggleNoClip, state = "noclip"},
    {name = "✈ Fly", func = toggleFly, state = "fly"},
    {name = "👁️ ESP", func = toggleESP, state = "esp"},
    {name = "🎯 Aimbot", func = toggleAimbot, state = "aimbot"},
    {name = "🥷 Невидимость", func = toggleInvisible, state = "invisible"}
}

for i, btn in ipairs(btns) do
    local b = Instance.new("TextButton", scrollFrame)
    b.Size = UDim2.new(1, 0, 0, 38)
    b.Text = btn.name .. "    [❍⊃]"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 15
    b.BorderSizePixel = 1
    b.BorderColor3 = Color3.fromRGB(0, 150, 255)
    b.BackgroundTransparency = 0.3
    
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

tpToggle = Instance.new("TextButton", scrollFrame)
tpToggle.Size = UDim2.new(1, 0, 0, 38)
tpToggle.Text = "📌 ТП к игроку    [❍⊃]"
tpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
tpToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
tpToggle.Font = Enum.Font.SourceSansBold
tpToggle.TextSize = 15
tpToggle.BorderSizePixel = 1
tpToggle.BorderColor3 = Color3.fromRGB(0, 150, 255)
tpToggle.BackgroundTransparency = 0.3
tpToggle.MouseButton1Click:Connect(function()
    toggleTeleport()
    if tpMenuOpen then
        tpToggle.Text = "📌 ТП к игроку    [⊂❍]"
        tpToggle.TextColor3 = Color3.fromRGB(0, 255, 100)
        tpToggle.BorderColor3 = Color3.fromRGB(0, 255, 100)
    else
        tpToggle.Text = "📌 ТП к игроку    [❍⊃]"
        tpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        tpToggle.BorderColor3 = Color3.fromRGB(0, 150, 255)
    end
end)

local exitBtn = Instance.new("TextButton", scrollFrame)
exitBtn.Size = UDim2.new(1, 0, 0, 38)
exitBtn.Text = "⛔ ЗАКРЫТЬ"
exitBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
exitBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 16
exitBtn.BorderSizePixel = 1
exitBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
exitBtn.BackgroundTransparency = 0.3
exitBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    if flyControls then flyControls:Destroy() end
end)

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #scrollFrame:GetChildren() * 50)

-- ============================================
-- СВОРАЧИВАНИЕ
-- ============================================
panel.MouseButton1Click:Connect(function()
    menuCollapsed = not menuCollapsed
    if menuCollapsed then
        frame:TweenSize(UDim2.new(0, 0, 0, 0), "Out", "Quad", 0.3)
        panelLabel.Text = "✦ shasik_1488 ✦  [▲]"
        panel.Position = UDim2.new(0.3, 0, 0, 0)
    else
        frame:TweenSize(UDim2.new(0, 340, 0, 520), "Out", "Quad", 0.3)
        panelLabel.Text = "✦ shasik_1488 ✦  [▼]"
        panel.Position = UDim2.new(0.3, 0, 0, -40)
    end
end)

frame:TweenSize(UDim2.new(0, 340, 0, 520), "Out", "Quad", 0.3)

print("✅ ULTRA MEGA CHEAT V21.0 by shasik_1488 загружен!")
