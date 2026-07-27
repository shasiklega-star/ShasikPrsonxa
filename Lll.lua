-- ============================================
-- PRISON RP ULTRA V27.0 (AIMBOT FIXED)
-- by shasik_1488 | РАБОЧИЙ АИМБОТ
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
local flySpeed = 100
local nc_cache = {}
local espObjects = {}
local espConnections = {}
local flyKeys = {w = false, a = false, s = false, d = false, space = false, shift = false}
local flyBV = nil
local flyBodyGyro = nil
local flyControls = nil
local aimTarget = nil
local aimPart = "Head"

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
-- ВСЕ ФУНКЦИИ
-- ============================================
function toggleHighJump()
    states.highjump = not states.highjump
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
    if states.speed then
        if connections.speed then connections.speed:Disconnect() end
        connections.speed = game:GetService("RunService").Heartbeat:Connect(function()
            if states.speed and humanoid and humanoid.Parent then
                humanoid.WalkSpeed = speedValue
            end
        end)
        sliderFrame.Visible = true
    else
        if connections.speed then connections.speed:Disconnect(); connections.speed = nil end
        if humanoid and humanoid.Parent then humanoid.WalkSpeed = 16 end
        sliderFrame.Visible = false
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

function toggleNoClip()
    states.noclip = not states.noclip
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
    if target and target.Character then
        local part = target.Character:FindFirstChild(aimPart) or target.Character:FindFirstChild("Head")
        if part then
            local partPos = part.Position
            local screenPos, onScreen = camera:WorldToScreenPoint(partPos)
            if onScreen then
                mouse.Move(Vector2.new(screenPos.X, screenPos.Y))
            end
        end
    end
end

function toggleAimbot()
    states.aimbot = not states.aimbot
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
-- МЕНЮ В СТИЛЕ NOTORIETY
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 480)
frame.Position = UDim2.new(0.5, -180, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 1
frame.BorderColor3 = Color3.fromRGB(30, 30, 50)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.Text = "PRISON RP | ULTRA EDITION"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 14

local line = Instance.new("Frame", frame)
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 80)
line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
line.BorderSizePixel = 0

-- КАТЕГОРИИ
local categories = {"Main", "Combat", "ESP", "Settings"}
local currentCategory = "Main"
local categoryButtons = {}

local categoryFrame = Instance.new("Frame", frame)
categoryFrame.Size = UDim2.new(0.9, 0, 0, 30)
categoryFrame.Position = UDim2.new(0.05, 0, 0, 88)
categoryFrame.BackgroundTransparency = 1

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", categoryFrame)
    btn.Size = UDim2.new(0.25, -2, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 2, 0, 0)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(function()
        currentCategory = cat
        for _, b in pairs(categoryButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
            b.TextColor3 = Color3.fromRGB(200, 200, 255)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 80)
        btn.TextColor3 = Color3.fromRGB(255, 200, 0)
        updateContent()
    end)
    categoryButtons[i] = btn
end
categoryButtons[1].BackgroundColor3 = Color3.fromRGB(40, 40, 80)
categoryButtons[1].TextColor3 = Color3.fromRGB(255, 200, 0)

-- КОНТЕНТ
local contentFrame = Instance.new("ScrollingFrame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -140)
contentFrame.Position = UDim2.new(0, 10, 0, 125)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 6
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ClipsDescendants = true
contentFrame.BorderSizePixel = 0

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function updateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if currentCategory == "Main" then
        -- Спидхак
        local speedBtn = Instance.new("TextButton", contentFrame)
        speedBtn.Size = UDim2.new(1, 0, 0, 36)
        speedBtn.Text = "⚡ Спидхак    [❍⊃]"
        speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        speedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        speedBtn.Font = Enum.Font.SourceSansBold
        speedBtn.TextSize = 15
        speedBtn.BorderSizePixel = 0
        speedBtn.MouseButton1Click:Connect(function()
            toggleSpeed()
            if states.speed then
                speedBtn.Text = "⚡ Спидхак    [⊂❍]"
                speedBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            else
                speedBtn.Text = "⚡ Спидхак    [❍⊃]"
                speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
        
        sliderFrame = Instance.new("Frame", contentFrame)
        sliderFrame.Size = UDim2.new(1, 0, 0, 45)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
        sliderFrame.Visible = false
        sliderFrame.BorderSizePixel = 0
        
        sliderLabel = Instance.new("TextLabel", sliderFrame)
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
        
        sliderFill = Instance.new("Frame", sliderBg)
        sliderFill.Size = UDim2.new(speedValue/200, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
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
        
        local mainBtns = {
            {name = "🦘 Высокий прыжок", func = toggleHighJump, state = "highjump"},
            {name = "👻 No Clip", func = toggleNoClip, state = "noclip"},
            {name = "✈ Fly", func = toggleFly, state = "fly"}
        }
        for _, btn in ipairs(mainBtns) do
            local b = Instance.new("TextButton", contentFrame)
            b.Size = UDim2.new(1, 0, 0, 36)
            b.Text = btn.name .. "    [❍⊃]"
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
            b.Font = Enum.Font.SourceSansBold
            b.TextSize = 15
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
        
    elseif currentCategory == "Combat" then
        -- Aimbot
        local aimBtn = Instance.new("TextButton", contentFrame)
        aimBtn.Size = UDim2.new(1, 0, 0, 36)
        aimBtn.Text = "🎯 Aimbot    [❍⊃]"
        aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        aimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        aimBtn.Font = Enum.Font.SourceSansBold
        aimBtn.TextSize = 15
        aimBtn.BorderSizePixel = 0
        aimBtn.MouseButton1Click:Connect(function()
            toggleAimbot()
            if states.aimbot then
                aimBtn.Text = "🎯 Aimbot    [⊂❍]"
                aimBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            else
                aimBtn.Text = "🎯 Aimbot    [❍⊃]"
                aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
        
        -- Выбор цели (Голова/Торс)
        local partBtn = Instance.new("TextButton", contentFrame)
        partBtn.Size = UDim2.new(1, 0, 0, 36)
        partBtn.Text = "🎯 Цель: " .. aimPart
        partBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
        partBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
        partBtn.Font = Enum.Font.SourceSansBold
        partBtn.TextSize = 14
        partBtn.BorderSizePixel = 0
        partBtn.MouseButton1Click:Connect(function()
            if aimPart == "Head" then
                aimPart = "Torso"
            else
                aimPart = "Head"
            end
            partBtn.Text = "🎯 Цель: " .. aimPart
        end)
        
    elseif currentCategory == "ESP" then
        local espBtn = Instance.new("TextButton", contentFrame)
        espBtn.Size = UDim2.new(1, 0, 0, 36)
        espBtn.Text = "👁️ ESP    [❍⊃]"
        espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        espBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        espBtn.Font = Enum.Font.SourceSansBold
        espBtn.TextSize = 15
        espBtn.BorderSizePixel = 0
        espBtn.MouseButton1Click:Connect(function()
            toggleESP()
            if states.esp then
                espBtn.Text = "👁️ ESP    [⊂❍]"
                espBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            else
                espBtn.Text = "👁️ ESP    [❍⊃]"
                espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
        
    elseif currentCategory == "Settings" then
        local invBtn = Instance.new("TextButton", contentFrame)
        invBtn.Size = UDim2.new(1, 0, 0, 36)
        invBtn.Text = "🥷 Невидимость    [❍⊃]"
        invBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        invBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        invBtn.Font = Enum.Font.SourceSansBold
        invBtn.TextSize = 15
        invBtn.BorderSizePixel = 0
        invBtn.MouseButton1Click:Connect(function()
            toggleInvisible()
            if states.invisible then
                invBtn.Text = "🥷 Невидимость    [⊂❍]"
                invBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            else
                invBtn.Text = "🥷 Невидимость    [❍⊃]"
                invBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end)
        
        local closeBtn = Instance.new("TextButton", contentFrame)
        closeBtn.Size = UDim2.new(1, 0, 0, 36)
        closeBtn.Text = "⛔ ЗАКРЫТЬ"
        closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        closeBtn.Font = Enum.Font.SourceSansBold
        closeBtn.TextSize = 16
        closeBtn.BorderSizePixel = 0
        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
            if flyControls then flyControls:Destroy() end
        end)
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 50)
end

updateContent()

print("✅ PRISON RP ULTRA V27.0 by shasik_1488 загружен!")
