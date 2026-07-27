-- ============================================
-- PRISON RP ULTRA V47 (С ТП К ИГРОКУ)
-- by shasik_1488 | ВСЁ РАБОТАЕТ
-- ============================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- ============================================
-- ЯЗЫК
-- ============================================
local lang = "ru"
local L = {
    ru = {
        title = "✦ shasik_1488 ✦",
        subtitle = "PRISON RP | ULTRA EDITION",
        speed = "⚡ Спидхак",
        highjump = "🦘 Высокий прыжок",
        noclip = "👻 No Clip",
        fly = "✈ Fly",
        aimbot = "🎯 Aimbot",
        esp = "👁️ ESP",
        invisible = "🥷 Невидимость",
        tp = "📌 ТП к игроку",
        close = "⛔ ЗАКРЫТЬ",
        aimPart = "🎯 Цель",
        color = "🎨 Цвет ESP",
        language = "🌐 Язык",
        on = "✅ ВКЛ",
        off = "❌ ВЫКЛ",
        categories = {"Главная", "Бой", "ESP", "Настройки"}
    },
    en = {
        title = "✦ shasik_1488 ✦",
        subtitle = "PRISON RP | ULTRA EDITION",
        speed = "⚡ Speed",
        highjump = "🦘 High Jump",
        noclip = "👻 No Clip",
        fly = "✈ Fly",
        aimbot = "🎯 Aimbot",
        esp = "👁️ ESP",
        invisible = "🥷 Invisible",
        tp = "📌 TP to Player",
        close = "⛔ CLOSE",
        aimPart = "🎯 Target",
        color = "🎨 ESP Color",
        language = "🌐 Language",
        on = "✅ ON",
        off = "❌ OFF",
        categories = {"Main", "Combat", "ESP", "Settings"}
    }
}

local txt = L[lang]

function toggleLanguage()
    lang = lang == "ru" and "en" or "ru"
    txt = L[lang]
    title.Text = txt.title
    subtitle.Text = txt.subtitle
    for i, cat in ipairs(txt.categories) do
        if categoryButtons[i] then
            categoryButtons[i].Text = cat
        end
    end
    updateContent()
end

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

local espColor = Color3.fromRGB(255, 0, 0)
local speedValue = 100
local nc_cache = {}
local espObjects = {}
local espConnections = {}
local flyKeys = {w = false, a = false, s = false, d = false, space = false, shift = false}
local flyBV = nil
local flyBodyGyro = nil
local flyControls = nil
local aimPart = "Head"
local currentCategory = 1
local savedAccessories = {}
local tpFrame = nil
local tpMenuOpen = false

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
        Text = state and "✅ " .. text .. " " .. txt.on or "❌ " .. text .. " " .. txt.off,
        Duration = 2
    })
end

-- ============================================
-- ПЕРЕПОДКЛЮЧЕНИЕ ПОСЛЕ СМЕРТИ
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
    updateAllButtons()
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
    notify(txt.highjump, states.highjump)
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
            speedBtn.Text = txt.speed .. "    [⊂❍]"
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
            speedBtn.Text = txt.speed .. "    [❍⊃]"
            speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            speedBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        if sliderFrame then
            sliderFrame.Visible = false
        end
    end
    notify(txt.speed, states.speed)
end

function updateSpeed(value)
    speedValue = math.clamp(value, 1, 200)
    if states.speed and humanoid and humanoid.Parent then
        humanoid.WalkSpeed = speedValue
    end
    if sliderLabel then
        sliderLabel.Text = txt.speed .. ": " .. math.floor(speedValue)
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
    notify(txt.noclip, states.noclip)
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
        notify(txt.fly, true)
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
        notify(txt.fly, false)
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
        notify(txt.esp, true)
    else
        for p, _ in pairs(espObjects) do
            removeESP(p)
        end
        for _, conn in pairs(espConnections) do
            if conn then conn:Disconnect() end
        end
        espConnections = {}
        notify(txt.esp, false)
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
        notify(txt.aimbot, true)
    else
        if connections.aimbot then connections.aimbot:Disconnect(); connections.aimbot = nil end
        notify(txt.aimbot, false)
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
        notify(txt.invisible, true)
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
        notify(txt.invisible, false)
    end
end

-- ============================================
-- ТЕЛЕПОРТ К ИГРОКУ (РАБОТАЕТ БЕЗ ЗАКРЫТИЯ)
-- ============================================
function toggleTeleport()
    states.tp = not states.tp
    if states.tp then
        if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
        local tpGui = Instance.new("ScreenGui", game.CoreGui)
        tpGui.Name = "TeleportMenu"
        tpGui.ResetOnSpawn = false
        tpGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        tpFrame = Instance.new("Frame", tpGui)
        tpFrame.Size = UDim2.new(0, 280, 0, 350)
        tpFrame.Position = UDim2.new(0.5, -140, 0.25, 0)
        tpFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
        tpFrame.BackgroundTransparency = 0.15
        tpFrame.BorderSizePixel = 2
        tpFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
        tpFrame.ClipsDescendants = true
        tpFrame.Active = true
        tpFrame.Draggable = true
        tpFrame.ZIndex = 20
        
        local stroke = Instance.new("UIStroke", tpFrame)
        stroke.Color = Color3.fromRGB(0, 200, 255)
        stroke.Thickness = 3
        stroke.Transparency = 0.5
        
        local tpTitle = Instance.new("TextLabel", tpFrame)
        tpTitle.Size = UDim2.new(1, 0, 0, 45)
        tpTitle.Text = txt.tp
        tpTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
        tpTitle.BackgroundTransparency = 1
        tpTitle.Font = Enum.Font.SourceSansBold
        tpTitle.TextSize = 20
        tpTitle.ZIndex = 21
        
        local tpScroll = Instance.new("ScrollingFrame", tpFrame)
        tpScroll.Size = UDim2.new(1, -20, 1, -60)
        tpScroll.Position = UDim2.new(0, 10, 0, 50)
        tpScroll.BackgroundTransparency = 1
        tpScroll.ScrollBarThickness = 6
        tpScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        tpScroll.ClipsDescendants = true
        tpScroll.BorderSizePixel = 0
        tpScroll.ZIndex = 21
        
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
            btn.ZIndex = 22
            
            btn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = p.Character.HumanoidRootPart
                    root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                    notify(txt.tp .. " " .. p.Name, true)
                end
            end)
        end
        
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                addPlayerButton(p)
            end
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
        tpClose.ZIndex = 22
        tpClose.MouseButton1Click:Connect(function()
            tpFrame.Parent:Destroy()
            states.tp = false
            if tpBtn then
                tpBtn.Text = txt.tp .. "    [❍⊃]"
                tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                tpBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
            end
        end)
        
        game.Players.PlayerAdded:Connect(function(p)
            if states.tp and p ~= player then
                addPlayerButton(p)
                tpScroll.CanvasSize = UDim2.new(0, 0, 0, #tpScroll:GetChildren() * 45)
            end
        end)
    else
        if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
    end
end

-- ============================================
-- МЕНЮ
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 420, 0, 520)
frame.Position = UDim2.new(0.5, -210, 0.12, 0)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 18)
frame.BackgroundTransparency = 0.15
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 200, 255)
frame.ZIndex = 5

-- СНЕГ
local snowContainer = Instance.new("Frame", frame)
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.ZIndex = 0

for i = 1, 150 do
    local particle = Instance.new("Frame", snowContainer)
    local size = math.random(6, 16)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(220 + math.random(0, 35), 230 + math.random(0, 25), 255)
    particle.BackgroundTransparency = 0.1 + math.random() * 0.3
    particle.ZIndex = 0
    particle.BorderSizePixel = 0
    local corner = Instance.new("UICorner", particle)
    corner.CornerRadius = UDim.new(1, 0)
    local shadow = Instance.new("UIStroke", particle)
    shadow.Color = Color3.fromRGB(200, 220, 255)
    shadow.Thickness = 1
    shadow.Transparency = 0.8
    
    local speed = 0.08 + math.random() * 0.3
    local wobble = math.random() * 200
    local wind = 0.001 + math.random() * 0.002
    
    spawn(function()
        while true do
            local pos = particle.Position
            local xOffset = math.sin(wobble + tick() * 0.5) * wind * 50
            local yOffset = speed * 0.002
            particle.Position = UDim2.new(pos.X.Scale + xOffset, 0, pos.Y.Scale + yOffset, 0)
            if particle.Position.Y.Scale > 1 then
                particle.Position = UDim2.new(math.random(), 0, -0.05, 0)
                local newSize = math.random(6, 16)
                particle.Size = UDim2.new(0, newSize, 0, newSize)
            end
            wait(0.05)
        end
    end)
end

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 200, 255)
stroke.Thickness = 3
stroke.Transparency = 0.5

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 30))
})
gradient.Rotation = 30

title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = txt.title
title.TextColor3 = Color3.fromRGB(255, 200, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24
title.ZIndex = 10

subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 50)
subtitle.Text = txt.subtitle
subtitle.TextColor3 = Color3.fromRGB(150, 150, 200)
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
categoryButtons = {}

local categoryFrame = Instance.new("Frame", frame)
categoryFrame.Size = UDim2.new(0.9, 0, 0, 30)
categoryFrame.Position = UDim2.new(0.05, 0, 0, 88)
categoryFrame.BackgroundTransparency = 1
categoryFrame.ZIndex = 10

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", categoryFrame)
    btn.Size = UDim2.new(0.25, -2, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 2, 0, 0)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    btn.BackgroundTransparency = 0.2
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    
    btn.MouseButton1Click:Connect(function()
        currentCategory = i
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
contentFrame.ZIndex = 10
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local speedBtn, jumpBtn, noclipBtn, flyBtn, aimBtn, espBtn, invBtn, tpBtn, sliderFrame, sliderLabel, sliderFill

function updateAllButtons()
    if speedBtn then
        speedBtn.Text = states.speed and txt.speed .. "    [⊂❍]" or txt.speed .. "    [❍⊃]"
        speedBtn.TextColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        speedBtn.BorderColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    if jumpBtn then
        jumpBtn.Text = states.highjump and txt.highjump .. "    [⊂❍]" or txt.highjump .. "    [❍⊃]"
        jumpBtn.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        jumpBtn.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    if noclipBtn then
        noclipBtn.Text = states.noclip and txt.noclip .. "    [⊂❍]" or txt.noclip .. "    [❍⊃]"
        noclipBtn.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        noclipBtn.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    if flyBtn then
        flyBtn.Text = states.fly and txt.fly .. "    [⊂❍]" or txt.fly .. "    [❍⊃]"
        flyBtn.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        flyBtn.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    if aimBtn then
        aimBtn.Text = states.aimbot and txt.aimbot .. "    [⊂❍]" or txt.aimbot .. "    [❍⊃]"
        aimBtn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        aimBtn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    if espBtn then
        espBtn.Text = states.esp and txt.esp .. "    [⊂❍]" or txt.esp .. "    [❍⊃]"
        espBtn.TextColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        espBtn.BorderColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    if invBtn then
        invBtn.Text = states.invisible and txt.invisible .. "    [⊂❍]" or txt.invisible .. "    [❍⊃]"
        invBtn.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        invBtn.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    if tpBtn then
        tpBtn.Text = states.tp and txt.tp .. "    [⊂❍]" or txt.tp .. "    [❍⊃]"
        tpBtn.TextColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        tpBtn.BorderColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    if sliderFrame then
        sliderFrame.Visible = states.speed
    end
end

function updateContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    if currentCategory == 1 then -- Главная / Main
        speedBtn = Instance.new("TextButton", contentFrame)
        speedBtn.Size = UDim2.new(1, 0, 0, 38)
        speedBtn.Text = states.speed and txt.speed .. "    [⊂❍]" or txt.speed .. "    [❍⊃]"
        speedBtn.TextColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        speedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        speedBtn.BackgroundTransparency = 0.2
        speedBtn.Font = Enum.Font.SourceSansBold
        speedBtn.TextSize = 15
        speedBtn.BorderSizePixel = 1
        speedBtn.BorderColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        speedBtn.ZIndex = 10
        speedBtn.MouseButton1Click:Connect(function()
            toggleSpeed()
            speedBtn.Text = states.speed and txt.speed .. "    [⊂❍]" or txt.speed .. "    [❍⊃]"
            speedBtn.TextColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            speedBtn.BorderColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
            if sliderFrame then
                sliderFrame.Visible = states.speed
            end
        end)
        
        sliderFrame = Instance.new("Frame", contentFrame)
        sliderFrame.Size = UDim2.new(1, 0, 0, 45)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
        sliderFrame.BackgroundTransparency = 0.2
        sliderFrame.Visible = states.speed
        sliderFrame.BorderSizePixel = 0
        sliderFrame.ZIndex = 10
        
        sliderLabel = Instance.new("TextLabel", sliderFrame)
        sliderLabel.Size = UDim2.new(1, 0, 0, 20)
        sliderLabel.Text = txt.speed .. ": " .. speedValue
        sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Font = Enum.Font.SourceSansBold
        sliderLabel.TextSize = 14
        sliderLabel.ZIndex = 10
        
        local sliderBg = Instance.new("Frame", sliderFrame)
        sliderBg.Size = UDim2.new(1, 0, 0, 10)
        sliderBg.Position = UDim2.new(0, 0, 0, 25)
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
        
        jumpBtn = Instance.new("TextButton", contentFrame)
        jumpBtn.Size = UDim2.new(1, 0, 0, 38)
        jumpBtn.Text = states.highjump and txt.highjump .. "    [⊂❍]" or txt.highjump .. "    [❍⊃]"
        jumpBtn.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        jumpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        jumpBtn.BackgroundTransparency = 0.2
        jumpBtn.Font = Enum.Font.SourceSansBold
        jumpBtn.TextSize = 15
        jumpBtn.BorderSizePixel = 1
        jumpBtn.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        jumpBtn.ZIndex = 10
        jumpBtn.MouseButton1Click:Connect(function()
            toggleHighJump()
            jumpBtn.Text = states.highjump and txt.highjump .. "    [⊂❍]" or txt.highjump .. "    [❍⊃]"
            jumpBtn.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            jumpBtn.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        noclipBtn = Instance.new("TextButton", contentFrame)
        noclipBtn.Size = UDim2.new(1, 0, 0, 38)
        noclipBtn.Text = states.noclip and txt.noclip .. "    [⊂❍]" or txt.noclip .. "    [❍⊃]"
        noclipBtn.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        noclipBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        noclipBtn.BackgroundTransparency = 0.2
        noclipBtn.Font = Enum.Font.SourceSansBold
        noclipBtn.TextSize = 15
        noclipBtn.BorderSizePixel = 1
        noclipBtn.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        noclipBtn.ZIndex = 10
        noclipBtn.MouseButton1Click:Connect(function()
            toggleNoClip()
            noclipBtn.Text = states.noclip and txt.noclip .. "    [⊂❍]" or txt.noclip .. "    [❍⊃]"
            noclipBtn.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            noclipBtn.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        flyBtn = Instance.new("TextButton", contentFrame)
        flyBtn.Size = UDim2.new(1, 0, 0, 38)
        flyBtn.Text = states.fly and txt.fly .. "    [⊂❍]" or txt.fly .. "    [❍⊃]"
        flyBtn.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        flyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        flyBtn.BackgroundTransparency = 0.2
        flyBtn.Font = Enum.Font.SourceSansBold
        flyBtn.TextSize = 15
        flyBtn.BorderSizePixel = 1
        flyBtn.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        flyBtn.ZIndex = 10
        flyBtn.MouseButton1Click:Connect(function()
            toggleFly()
            flyBtn.Text = states.fly and txt.fly .. "    [⊂❍]" or txt.fly .. "    [❍⊃]"
            flyBtn.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            flyBtn.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        invBtn = Instance.new("TextButton", contentFrame)
        invBtn.Size = UDim2.new(1, 0, 0, 38)
        invBtn.Text = states.invisible and txt.invisible .. "    [⊂❍]" or txt.invisible .. "    [❍⊃]"
        invBtn.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        invBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        invBtn.BackgroundTransparency = 0.2
        invBtn.Font = Enum.Font.SourceSansBold
        invBtn.TextSize = 15
        invBtn.BorderSizePixel = 1
        invBtn.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        invBtn.ZIndex = 10
        invBtn.MouseButton1Click:Connect(function()
            toggleInvisible()
            invBtn.Text = states.invisible and txt.invisible .. "    [⊂❍]" or txt.invisible .. "    [❍⊃]"
            invBtn.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            invBtn.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        tpBtn = Instance.new("TextButton", contentFrame)
        tpBtn.Size = UDim2.new(1, 0, 0, 38)
        tpBtn.Text = states.tp and txt.tp .. "    [⊂❍]" or txt.tp .. "    [❍⊃]"
        tpBtn.TextColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        tpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        tpBtn.BackgroundTransparency = 0.2
        tpBtn.Font = Enum.Font.SourceSansBold
        tpBtn.TextSize = 15
        tpBtn.BorderSizePixel = 1
        tpBtn.BorderColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        tpBtn.ZIndex = 10
        tpBtn.MouseButton1Click:Connect(function()
            toggleTeleport()
            tpBtn.Text = states.tp and txt.tp .. "    [⊂❍]" or txt.tp .. "    [❍⊃]"
            tpBtn.TextColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            tpBtn.BorderColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 2 then -- Бой / Combat
        aimBtn = Instance.new("TextButton", contentFrame)
        aimBtn.Size = UDim2.new(1, 0, 0, 38)
        aimBtn.Text = states.aimbot and txt.aimbot .. "    [⊂❍]" or txt.aimbot .. "    [❍⊃]"
        aimBtn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        aimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        aimBtn.BackgroundTransparency = 0.2
        aimBtn.Font = Enum.Font.SourceSansBold
        aimBtn.TextSize = 15
        aimBtn.BorderSizePixel = 1
        aimBtn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        aimBtn.ZIndex = 10
        aimBtn.MouseButton1Click:Connect(function()
            toggleAimbot()
            aimBtn.Text = states.aimbot and txt.aimbot .. "    [⊂❍]" or txt.aimbot .. "    [❍⊃]"
            aimBtn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            aimBtn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 3 then -- ESP
        espBtn = Instance.new("TextButton", contentFrame)
        espBtn.Size = UDim2.new(1, 0, 0, 38)
        espBtn.Text = states.esp and txt.esp .. "    [⊂❍]" or txt.esp .. "    [❍⊃]"
        espBtn.TextColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        espBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        espBtn.BackgroundTransparency = 0.2
        espBtn.Font = Enum.Font.SourceSansBold
        espBtn.TextSize = 15
        espBtn.BorderSizePixel = 1
        espBtn.BorderColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        espBtn.ZIndex = 10
        espBtn.MouseButton1Click:Connect(function()
            toggleESP()
            espBtn.Text = states.esp and txt.esp .. "    [⊂❍]" or txt.esp .. "    [❍⊃]"
            espBtn.TextColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            espBtn.BorderColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 4 then -- Настройки / Settings
        -- Цвет ESP
        local colorBtn = Instance.new("TextButton", contentFrame)
        colorBtn.Size = UDim2.new(1, 0, 0, 38)
        colorBtn.Text = txt.color .. ": " .. (espColor == Color3.fromRGB(255, 0, 0) and "🔴 Красный" or
                                               espColor == Color3.fromRGB(255, 255, 0) and "🟡 Жёлтый" or
                                               espColor == Color3.fromRGB(0, 0, 255) and "🔵 Синий" or
                                               espColor == Color3.fromRGB(0, 255, 0) and "🟢 Зелёный" or
                                               espColor == Color3.fromRGB(255, 105, 180) and "🩷 Розовый" or
                                               "⚪ Белый")
        colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        colorBtn.BackgroundTransparency = 0.2
        colorBtn.Font = Enum.Font.SourceSansBold
        colorBtn.TextSize = 15
        colorBtn.BorderSizePixel = 1
        colorBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        colorBtn.ZIndex = 10
        colorBtn.MouseButton1Click:Connect(function()
            local colors = {
                Color3.fromRGB(255, 0, 0),
                Color3.fromRGB(255, 255, 0),
                Color3.fromRGB(0, 0, 255),
                Color3.fromRGB(0, 255, 0),
                Color3.fromRGB(255, 105, 180),
                Color3.fromRGB(255, 255, 255)
            }
            local names = {"🔴 Красный", "🟡 Жёлтый", "🔵 Синий", "🟢 Зелёный", "🩷 Розовый", "⚪ Белый"}
            local currentIndex = 0
            for i, c in ipairs(colors) do
                if c == espColor then currentIndex = i end
            end
            local nextIndex = currentIndex % #colors + 1
            espColor = colors[nextIndex]
            colorBtn.Text = txt.color .. ": " .. names[nextIndex]
            if states.esp then
                for _, obj in pairs(espObjects) do
                    if obj.box then obj.box.Color3 = espColor end
                    if obj.label then obj.label.TextColor3 = espColor end
                end
            end
        end)
        
        -- Язык
        local langBtn = Instance.new("TextButton", contentFrame)
        langBtn.Size = UDim2.new(1, 0, 0, 38)
        langBtn.Text = txt.language .. ": " .. (lang == "ru" and "🇷🇺 Русский" or "🇬🇧 English")
        langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        langBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        langBtn.BackgroundTransparency = 0.2
        langBtn.Font = Enum.Font.SourceSansBold
        langBtn.TextSize = 15
        langBtn.BorderSizePixel = 1
        langBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        langBtn.ZIndex = 10
        langBtn.MouseButton1Click:Connect(function()
            toggleLanguage()
            langBtn.Text = txt.language .. ": " .. (lang == "ru" and "🇷🇺 Русский" or "🇬🇧 English")
            for i, cat in ipairs(txt.categories) do
                if categoryButtons[i] then
                    categoryButtons[i].Text = cat
                end
            end
            title.Text = txt.title
            subtitle.Text = txt.subtitle
            updateAllButtons()
        end)
        
        -- Закрыть
        local closeBtn = Instance.new("TextButton", contentFrame)
        closeBtn.Size = UDim2.new(1, 0, 0, 38)
        closeBtn.Text = txt.close
        closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        closeBtn.BackgroundTransparency = 0.2
        closeBtn.Font = Enum.Font.SourceSansBold
        closeBtn.TextSize = 16
        closeBtn.BorderSizePixel = 1
        closeBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
        closeBtn.ZIndex = 10
        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
            if flyControls then flyControls:Destroy() end
            if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
        end)
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 50)
end

updateContent()

print("✅ PRISON RP ULTRA V47 by shasik_1488 загружен!")
