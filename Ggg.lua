-- ============================================
-- ULTRA MEGA CHEAT V10.0 (С ТЕЛЕПОРТОМ)
-- by shasik_1488 | ТП К ЛЮБОМУ ИГРОКУ
-- ============================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local states = {highjump = false, speed = false, noclip = false, fly = false}
local connections = {}
local speedValue = 100
local flySpeed = 75
local nc_cache = {}
local menuOpen = true

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
end)

-- ============================================
-- ВЫСОКИЙ ПРЫЖОК
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

-- ============================================
-- СПИДХАК
-- ============================================
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

-- ============================================
-- NO CLIP
-- ============================================
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

-- ============================================
-- FLY
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
        
        if not flyControls then
            flyControls = Instance.new("ScreenGui", game.CoreGui)
            flyControls.Name = "FlyControls"
            flyControls.ResetOnSpawn = false
            
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
                btn.BorderColor3 = Color3.fromRGB(0, 200, 255)
                btn.ZIndex = 10
                btn.BackgroundTransparency = 0.1
                
                local isHeld = false
                btn.MouseButton1Down:Connect(function()
                    isHeld = true
                    if states.fly and flyBV then flyBV.Velocity = dir * flySpeed end
                end)
                btn.MouseButton1Up:Connect(function()
                    isHeld = false
                    if states.fly and flyBV then flyBV.Velocity = Vector3.new(0, 0, 0) end
                end)
                btn.MouseLeave:Connect(function()
                    if isHeld then
                        isHeld = false
                        if states.fly and flyBV then flyBV.Velocity = Vector3.new(0, 0, 0) end
                    end
                end)
                return btn
            end
            
            makeBtn("▲", Vector2.new(75, 0), Color3.fromRGB(20, 30, 60), Vector3.new(0, 0, -1))
            makeBtn("▼", Vector2.new(75, 100), Color3.fromRGB(20, 30, 60), Vector3.new(0, 0, 1))
            makeBtn("◄", Vector2.new(25, 50), Color3.fromRGB(20, 30, 60), Vector3.new(-1, 0, 0))
            makeBtn("►", Vector2.new(125, 50), Color3.fromRGB(20, 30, 60), Vector3.new(1, 0, 0))
            makeBtn("⬆", Vector2.new(75, -50), Color3.fromRGB(40, 40, 80), Vector3.new(0, 1, 0))
            makeBtn("⬇", Vector2.new(75, 150), Color3.fromRGB(40, 40, 80), Vector3.new(0, -1, 0))
        end
        flyControls.Enabled = true
        
        if connections.fly then connections.fly:Disconnect() end
        connections.fly = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.fly then
                if flyBV then flyBV:Destroy(); flyBV = nil end
                if flyControls then flyControls.Enabled = false end
                return
            end
            if flyBV and flyBV.Parent == nil then flyBV.Parent = root end
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
-- ТЕЛЕПОРТ К ИГРОКУ
-- ============================================
local tpMenuOpen = false
local tpFrame = nil

function toggleTeleport()
    tpMenuOpen = not tpMenuOpen
    if tpMenuOpen then
        if tpFrame then tpFrame:Destroy(); tpFrame = nil end
        tpFrame = Instance.new("Frame", gui)
        tpFrame.Size = UDim2.new(0, 250, 0, 300)
        tpFrame.Position = UDim2.new(0.5, -125, 0.3, 0)
        tpFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
        tpFrame.BackgroundTransparency = 0.2
        tpFrame.BorderSizePixel = 2
        tpFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
        tpFrame.ClipsDescendants = true
        
        local tpTitle = Instance.new("TextLabel", tpFrame)
        tpTitle.Size = UDim2.new(1, 0, 0, 40)
        tpTitle.Text = "📌 ТЕЛЕПОРТ К ИГРОКУ"
        tpTitle.TextColor3 = Color3.fromRGB(0, 220, 255)
        tpTitle.BackgroundTransparency = 1
        tpTitle.Font = Enum.Font.SourceSansBold
        tpTitle.TextSize = 18
        
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
        
        local function addPlayer(playerName)
            local btn = Instance.new("TextButton", tpScroll)
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Text = playerName
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
            btn.Font = Enum.Font.SourceSansBold
            btn.TextSize = 14
            btn.BorderSizePixel = 0
            btn.BackgroundTransparency = 0.3
            
            btn.MouseButton1Click:Connect(function()
                local target = game.Players:FindFirstChild(playerName)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetRoot = target.Character.HumanoidRootPart
                    root.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
                    notify("Телепорт к " .. playerName, true)
                    tpFrame:Destroy()
                    tpMenuOpen = false
                end
            end)
        end
        
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                addPlayer(p.Name)
            end
        end
        
        game.Players.PlayerAdded:Connect(function(p)
            if p ~= player and tpMenuOpen then
                addPlayer(p.Name)
                tpScroll.CanvasSize = UDim2.new(0, 0, 0, #tpScroll:GetChildren() * 45)
            end
        end)
        
        game.Players.PlayerRemoving:Connect(function()
            if tpMenuOpen then
                for _, child in pairs(tpScroll:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= player then addPlayer(p.Name) end
                end
                tpScroll.CanvasSize = UDim2.new(0, 0, 0, #tpScroll:GetChildren() * 45)
            end
        end)
        
        tpScroll.CanvasSize = UDim2.new(0, 0, 0, #tpScroll:GetChildren() * 45)
        
        local tpClose = Instance.new("TextButton", tpFrame)
        tpClose.Size = UDim2.new(0, 30, 0, 30)
        tpClose.Position = UDim2.new(1, -35, 0, 5)
        tpClose.Text = "✕"
        tpClose.TextColor3 = Color3.fromRGB(255, 50, 50)
        tpClose.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        tpClose.Font = Enum.Font.SourceSansBold
        tpClose.TextSize = 16
        tpClose.MouseButton1Click:Connect(function()
            tpFrame:Destroy()
            tpMenuOpen = false
        end)
    else
        if tpFrame then tpFrame:Destroy(); tpFrame = nil end
    end
end

-- ============================================
-- МЕНЮ (ОТКРЫВАЕТСЯ СРАЗУ)
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 550)
frame.Position = UDim2.new(0.5, -180, 0.15, 0)
frame.BackgroundColor3 = Color3.fromRGB(8, 8, 20)
frame.BackgroundTransparency = 0.15
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 0

local stroke1 = Instance.new("UIStroke", frame)
stroke1.Color = Color3.fromRGB(0, 200, 255)
stroke1.Thickness = 4
stroke1.Transparency = 0.7
local stroke2 = Instance.new("UIStroke", frame)
stroke2.Color = Color3.fromRGB(255, 0, 200)
stroke2.Thickness = 2
stroke2.Transparency = 0.9

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 30))
})
gradient.Rotation = 30

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 55)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(0, 220, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 26
title.TextScaled = true

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 55)
subtitle.Text = "PRISON RP | ULTRA EDITION"
subtitle.TextColor3 = Color3.fromRGB(200, 150, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 14

local line = Instance.new("Frame", frame)
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 85)
line.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
line.BorderSizePixel = 0

local scrollFrame = Instance.new("ScrollingFrame", frame)
scrollFrame.Size = UDim2.new(1, -20, 1, -100)
scrollFrame.Position = UDim2.new(0, 10, 0, 95)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ClipsDescendants = true
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)

local layout = Instance.new("UIListLayout", scrollFrame)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- КНОПКА СПИДХАКА
local speedToggle = Instance.new("TextButton", scrollFrame)
speedToggle.Size = UDim2.new(1, 0, 0, 40)
speedToggle.Text = "⚡ Спидхак    [❍⊃]"
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
speedToggle.Font = Enum.Font.SourceSansBold
speedToggle.TextSize = 15
speedToggle.BorderSizePixel = 2
speedToggle.BorderColor3 = Color3.fromRGB(0, 150, 255)
speedToggle.BackgroundTransparency = 0.2

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
    end
end)

local sliderFrame = Instance.new("Frame", scrollFrame)
sliderFrame.Size = UDim2.new(1, 0, 0, 50)
sliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
sliderFrame.Visible = false
sliderFrame.BorderSizePixel = 2
sliderFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
sliderFrame.BackgroundTransparency = 0.2

local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(1, 0, 0, 22)
sliderLabel.Text = "Скорость: " .. speedValue
sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Font = Enum.Font.SourceSansBold
sliderLabel.TextSize = 14

local sliderBg = Instance.new("Frame", sliderFrame)
sliderBg.Size = UDim2.new(1, 0, 0, 12)
sliderBg.Position = UDim2.new(0, 0, 0, 28)
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

-- ТЕЛЕПОРТ
local tpToggle = Instance.new("TextButton", scrollFrame)
tpToggle.Size = UDim2.new(1, 0, 0, 40)
tpToggle.Text = "📌 ТП к игроку    [❍⊃]"
tpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
tpToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
tpToggle.Font = Enum.Font.SourceSansBold
tpToggle.TextSize = 15
tpToggle.BorderSizePixel = 2
tpToggle.BorderColor3 = Color3.fromRGB(0, 150, 255)
tpToggle.BackgroundTransparency = 0.2

tpToggle.MouseButton1Click:Connect(function()
    if tpMenuOpen then
        tpToggle.Text = "📌 ТП к игроку    [❍⊃]"
        tpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        tpToggle.BorderColor3 = Color3.fromRGB(0, 150, 255)
    else
        tpToggle.Text = "📌 ТП к игроку    [⊂❍]"
        tpToggle.TextColor3 = Color3.fromRGB(0, 255, 100)
        tpToggle.BorderColor3 = Color3.fromRGB(0, 255, 100)
    end
    toggleTeleport()
end)

-- ОСТАЛЬНЫЕ КНОПКИ
local btns = {
    {name = "🦘 Высокий прыжок", func = toggleHighJump, state = "highjump"},
    {name = "👻 No Clip", func = toggleNoClip, state = "noclip"},
    {name = "✈ Fly", func = toggleFly, state = "fly"}
}

for i, btn in ipairs(btns) do
    local b = Instance.new("TextButton", scrollFrame)
    b.Size = UDim2.new(1, 0, 0, 40)
    b.Text = btn.name .. "    [❍⊃]"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 15
    b.BorderSizePixel = 2
    b.BorderColor3 = Color3.fromRGB(0, 150, 255)
    b.BackgroundTransparency = 0.2
    
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

local exitBtn = Instance.new("TextButton", scrollFrame)
exitBtn.Size = UDim2.new(1, 0, 0, 40)
exitBtn.Text = "⛔ ЗАКРЫТЬ"
exitBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
exitBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 16
exitBtn.BorderSizePixel = 2
exitBtn.BorderColor3 = Color3.fromRGB(255, 50, 50)
exitBtn.BackgroundTransparency = 0.2
exitBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    if flyControls then flyControls:Destroy() end
end)

-- Обновляем размер Canvas
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #scrollFrame:GetChildren() * 52)

print("✅ ULTRA MEGA CHEAT V10.0 by shasik_1488 загружен!")
