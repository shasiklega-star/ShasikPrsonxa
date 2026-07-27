-- ============================================
-- PRISON RP ULTRA V62 (НЕОНОВЫЕ УГОЛКИ)
-- by shasik_1488 | АНИМАЦИЯ + СТИЛЬ
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
    tp = false,
    espName = true,
    espDistance = true
}

local settings = {
    espSize = 3,
    espTransparency = 0.5,
    aimbotDistance = 100,
    speedValue = 100,
    flySpeed = 100,
    jumpPower = 150,
    espColor = Color3.fromRGB(255, 0, 0)
}

local connections = {}
local nc_cache = {}
local espObjects = {}
local espConnections = {}
local flyKeys = {w = false, a = false, s = false, d = false, space = false, shift = false}
local flyBV = nil
local flyBodyGyro = nil
local flyControls = nil
local aimPart = "Head"
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
                humanoid.JumpPower = settings.jumpPower
            end
        end)
        humanoid.JumpPower = settings.jumpPower
        if jumpBtn then
            jumpBtn.Text = "🦘 Высокий прыжок    [⊂❍]"
            jumpBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            jumpBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
        if jumpSliderFrame then
            jumpSliderFrame.Visible = true
        end
    else
        if connections.highjump then connections.highjump:Disconnect(); connections.highjump = nil end
        if humanoid and humanoid.Parent then humanoid.JumpPower = 50 end
        if jumpBtn then
            jumpBtn.Text = "🦘 Высокий прыжок    [❍⊃]"
            jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            jumpBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        if jumpSliderFrame then
            jumpSliderFrame.Visible = false
        end
    end
    notify("Высокий прыжок", states.highjump)
end

function updateJump(value)
    settings.jumpPower = math.clamp(value, 50, 500)
    if states.highjump and humanoid and humanoid.Parent then
        humanoid.JumpPower = settings.jumpPower
    end
    if jumpSliderLabel then
        jumpSliderLabel.Text = "Высота прыжка: " .. math.floor(settings.jumpPower)
    end
    if jumpSliderFill then
        jumpSliderFill.Size = UDim2.new((settings.jumpPower - 50) / 450, 0, 1, 0)
    end
end

function toggleSpeed()
    states.speed = not states.speed
    playClick()
    if states.speed then
        if connections.speed then connections.speed:Disconnect() end
        connections.speed = game:GetService("RunService").Heartbeat:Connect(function()
            if states.speed and humanoid and humanoid.Parent then
                humanoid.WalkSpeed = settings.speedValue
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
    settings.speedValue = math.clamp(value, 1, 200)
    if states.speed and humanoid and humanoid.Parent then
        humanoid.WalkSpeed = settings.speedValue
    end
    if sliderLabel then
        sliderLabel.Text = "Скорость: " .. math.floor(settings.speedValue)
    end
    if sliderFill then
        sliderFill.Size = UDim2.new(settings.speedValue/200, 0, 1, 0)
    end
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
            if move.Magnitude > 0 then flyBV.Velocity = move.Unit * settings.flySpeed else flyBV.Velocity = Vector3.new(0, 0, 0) end
        end)
        
        if flyBtn then
            flyBtn.Text = "✈ Fly    [⊂❍]"
            flyBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            flyBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
        if flySliderFrame then
            flySliderFrame.Visible = true
        end
    else
        if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
        if flyBV then flyBV:Destroy(); flyBV = nil end
        if flyBodyGyro then flyBodyGyro:Destroy(); flyBodyGyro = nil end
        if flyControls then flyControls.Enabled = false end
        humanoid.PlatformStand = false
        notify("Fly", false)
        if flyBtn then
            flyBtn.Text = "✈ Fly    [❍⊃]"
            flyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            flyBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        if flySliderFrame then
            flySliderFrame.Visible = false
        end
    end
end

function updateFlySpeed(value)
    settings.flySpeed = math.clamp(value, 20, 300)
    if flySliderLabel then
        flySliderLabel.Text = "Скорость Fly: " .. math.floor(settings.flySpeed)
    end
    if flySliderFill then
        flySliderFill.Size = UDim2.new((settings.flySpeed - 20) / 280, 0, 1, 0)
    end
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
        if noclipBtn then
            noclipBtn.Text = "👻 No Clip    [⊂❍]"
            noclipBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            noclipBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
    else
        if connections.noclip then connections.noclip:Disconnect(); connections.noclip = nil end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
        for part, _ in pairs(nc_cache) do
            part.CanCollide = true
        end
        nc_cache = {}
        if noclipBtn then
            noclipBtn.Text = "👻 No Clip    [❍⊃]"
            noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            noclipBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
    end
    notify("No Clip", states.noclip)
end

function createESP(target)
    if not target or not target.Character then return end
    local tChar = target.Character
    local tRoot = tChar:FindFirstChild("HumanoidRootPart")
    if not tRoot then return end
    
    local size = settings.espSize
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = tRoot
    box.Size = Vector3.new(size, size + 2, size - 1)
    box.Color3 = settings.espColor
    box.Transparency = settings.espTransparency
    box.ZIndex = 10
    box.AlwaysOnTop = true
    box.Parent = tChar
    
    local nameTag = Instance.new("BillboardGui", tChar)
    nameTag.Adornee = tRoot
    nameTag.Size = UDim2.new(0, 200, 0, 60)
    nameTag.StudsOffset = Vector3.new(0, 3.5, 0)
    nameTag.AlwaysOnTop = true
    
    local label = Instance.new("TextLabel", nameTag)
    label.Size = UDim2.new(1, 0, 0.5, 0)
    label.Text = target.Name
    label.TextColor3 = settings.espColor
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.SourceSansBold
    label.TextSize = 14
    
    local distLabel = Instance.new("TextLabel", nameTag)
    distLabel.Size = UDim2.new(1, 0, 0.5, 0)
    distLabel.Position = UDim2.new(0, 0, 0.5, 0)
    distLabel.Text = "0 м"
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.SourceSans
    distLabel.TextSize = 12
    
    espObjects[target] = {box = box, nameTag = nameTag, label = label, distLabel = distLabel}
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
                    local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if espObjects[p].distLabel then
                        espObjects[p].distLabel.Text = math.floor(dist) .. " м"
                    end
                    if espObjects[p].label then
                        espObjects[p].label.Visible = states.espName
                    end
                    if espObjects[p].distLabel then
                        espObjects[p].distLabel.Visible = states.espDistance
                    end
                    if espObjects[p].box then
                        local size = settings.espSize
                        espObjects[p].box.Size = Vector3.new(size, size + 2, size - 1)
                        espObjects[p].box.Transparency = settings.espTransparency
                        espObjects[p].box.Color3 = settings.espColor
                    end
                    if espObjects[p].label then
                        espObjects[p].label.TextColor3 = settings.espColor
                    end
                end
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
        if connections.esp then connections.esp:Disconnect() end
        connections.esp = game:GetService("RunService").Heartbeat:Connect(updateESP)
        if espBtn then
            espBtn.Text = "👁️ ESP    [⊂❍]"
            espBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            espBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
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
        if espBtn then
            espBtn.Text = "👁️ ESP    [❍⊃]"
            espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            espBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        notify("ESP", false)
    end
end

function toggleESPName()
    states.espName = not states.espName
    playClick()
    for _, obj in pairs(espObjects) do
        if obj.label then
            obj.label.Visible = states.espName
        end
    end
    if espNameBtn then
        espNameBtn.Text = states.espName and "👤 Имя    [⊂❍]" or "👤 Имя    [❍⊃]"
        espNameBtn.TextColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        espNameBtn.BorderColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    notify("Имя игрока", states.espName)
end

function toggleESPDistance()
    states.espDistance = not states.espDistance
    playClick()
    for _, obj in pairs(espObjects) do
        if obj.distLabel then
            obj.distLabel.Visible = states.espDistance
        end
    end
    if espDistBtn then
        espDistBtn.Text = states.espDistance and "📏 Дистанция    [⊂❍]" or "📏 Дистанция    [❍⊃]"
        espDistBtn.TextColor3 = states.espDistance and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        espDistBtn.BorderColor3 = states.espDistance and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
    end
    notify("Дистанция", states.espDistance)
end

function getClosestPlayer()
    local closest = nil
    local shortestDistance = settings.aimbotDistance
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
        if aimBtn then
            aimBtn.Text = "🎯 Aimbot    [⊂❍]"
            aimBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            aimBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
        notify("Aimbot", true)
    else
        if connections.aimbot then connections.aimbot:Disconnect(); connections.aimbot = nil end
        if aimBtn then
            aimBtn.Text = "🎯 Aimbot    [❍⊃]"
            aimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            aimBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
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
        if invBtn then
            invBtn.Text = "🥷 Невидимость    [⊂❍]"
            invBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            invBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
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
        if invBtn then
            invBtn.Text = "🥷 Невидимость    [❍⊃]"
            invBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            invBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        notify("Невидимость", false)
    end
end

function toggleTeleport()
    states.tp = not states.tp
    if states.tp then
        if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
        local tpGui = Instance.new("ScreenGui", game.CoreGui)
        tpGui.Name = "TeleportMenu"
        tpGui.ResetOnSpawn = false
        
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
        tpTitle.Text = "📌 ТП к игроку"
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
                    notify("Телепорт к " .. p.Name, true)
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
                tpBtn.Text = "📌 ТП к игроку    [❍⊃]"
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
-- МЕНЮ С НЕОНОВЫМИ УГОЛКАМИ
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

-- ============================================
-- ФУНКЦИЯ ДЛЯ СОЗДАНИЯ НЕОНОВОГО УГОЛКА
-- ============================================
function createCorner(frame, pos, size, color)
    local corner = Instance.new("Frame", frame)
    corner.Size = UDim2.new(0, size, 0, size)
    corner.Position = pos
    corner.BackgroundColor3 = color
    corner.BackgroundTransparency = 0.1
    corner.ZIndex = 20
    corner.BorderSizePixel = 0
    corner.ClipsDescendants = true
    
    local stroke = Instance.new("UIStroke", corner)
    stroke.Color = color
    stroke.Thickness = 3
    stroke.Transparency = 0.3
    
    -- Анимация свечения
    spawn(function()
        while true do
            local t = tick() * 0.5
            local r = math.sin(t) * 0.3 + 0.3
            local g = math.sin(t + 0.5) * 0.3 + 0.3
            local b = math.sin(t + 1) * 0.3 + 0.3
            stroke.Color = Color3.new(r, g, b)
            stroke.Transparency = 0.2 + math.sin(t * 1.5) * 0.2
            wait(0.05)
        end
    end)
    
    return corner
end

-- ОСНОВНАЯ РАМКА
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 460, 0, 560)
frame.Position = UDim2.new(0.5, -230, 0.1, 0)
frame.BackgroundColor3 = Color3.fromRGB(6, 6, 18)
frame.BackgroundTransparency = 0.05
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 0
frame.ZIndex = 5

-- НЕОНОВЫЕ УГОЛКИ
local cornerSize = 25
local colors = {
    Color3.fromRGB(0, 200, 255),
    Color3.fromRGB(255, 0, 200),
    Color3.fromRGB(200, 0, 255),
    Color3.fromRGB(0, 255, 200)
}

-- Верхний левый
createCorner(frame, UDim2.new(0, 5, 0, 5), cornerSize, colors[1])
-- Верхний правый
createCorner(frame, UDim2.new(1, -(cornerSize + 5), 0, 5), cornerSize, colors[2])
-- Нижний левый
createCorner(frame, UDim2.new(0, 5, 1, -(cornerSize + 5)), cornerSize, colors[3])
-- Нижний правый
createCorner(frame, UDim2.new(1, -(cornerSize + 5), 1, -(cornerSize + 5)), cornerSize, colors[4])

-- НЕОНОВАЯ ОБВОДКА (основная)
local stroke1 = Instance.new("UIStroke", frame)
stroke1.Color = Color3.fromRGB(0, 200, 255)
stroke1.Thickness = 1
stroke1.Transparency = 0.6

-- Вторая обводка (розовая)
local stroke2 = Instance.new("UIStroke", frame)
stroke2.Color = Color3.fromRGB(255, 0, 200)
stroke2.Thickness = 1
stroke2.Transparency = 0.8

-- Градиентный фон
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 6, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 6, 25))
})
gradient.Rotation = 25

-- ============================================
-- ЗАГОЛОВКИ
-- ============================================
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 55)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 210, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 28
title.ZIndex = 10

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 55)
subtitle.Text = "PRISON RP | ULTRA EDITION"
subtitle.TextColor3 = Color3.fromRGB(180, 180, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.SourceSans
subtitle.TextSize = 14
subtitle.ZIndex = 10

local line = Instance.new("Frame", frame)
line.Size = UDim2.new(0.9, 0, 0, 2)
line.Position = UDim2.new(0.05, 0, 0, 85)
line.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
line.BorderSizePixel = 0
line.ZIndex = 10

-- ============================================
-- КАТЕГОРИИ
-- ============================================
local categories = {"Главная", "Бой", "ESP", "Настройки"}
local currentCategory = 1
local categoryButtons = {}

local categoryFrame = Instance.new("Frame", frame)
categoryFrame.Size = UDim2.new(0.9, 0, 0, 36)
categoryFrame.Position = UDim2.new(0.05, 0, 0, 92)
categoryFrame.BackgroundTransparency = 1
categoryFrame.ZIndex = 10

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", categoryFrame)
    btn.Size = UDim2.new(0.25, -2, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 2, 0, 0)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
    btn.BackgroundTransparency = 0.3
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 14
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(40, 40, 80)
    btn.ZIndex = 10
    btn.ClipsDescendants = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0.2, 0)
    
    btn.MouseEnter:Connect(function()
        if btn.TextColor3 ~= Color3.fromRGB(255, 200, 0) then
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
            btn.BorderColor3 = Color3.fromRGB(80, 80, 150)
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.TextColor3 ~= Color3.fromRGB(255, 200, 0) then
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
            btn.BorderColor3 = Color3.fromRGB(40, 40, 80)
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        currentCategory = i
        for _, b in pairs(categoryButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
            b.TextColor3 = Color3.fromRGB(200, 200, 255)
            b.BorderColor3 = Color3.fromRGB(40, 40, 80)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 90)
        btn.TextColor3 = Color3.fromRGB(255, 200, 0)
        btn.BorderColor3 = Color3.fromRGB(255, 200, 0)
        updateContent()
    end)
    categoryButtons[i] = btn
end
categoryButtons[1].BackgroundColor3 = Color3.fromRGB(40, 40, 90)
categoryButtons[1].TextColor3 = Color3.fromRGB(255, 200, 0)
categoryButtons[1].BorderColor3 = Color3.fromRGB(255, 200, 0)

-- ============================================
-- КОНТЕНТ
-- ============================================
local contentFrame = Instance.new("ScrollingFrame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -145)
contentFrame.Position = UDim2.new(0, 10, 0, 136)
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
local jumpBtn, jumpSliderFrame, jumpSliderLabel, jumpSliderFill
local flyBtn, flySliderFrame, flySliderLabel, flySliderFill
local noclipBtn, espBtn, aimBtn, invBtn, tpBtn
local espNameBtn, espDistBtn, colorBtn, sizeBtn, transBtn, distBtn

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
        Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0.1, 0)
        
        speedBtn.MouseEnter:Connect(function()
            speedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
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
        sliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
        sliderFrame.BackgroundTransparency = 0.3
        sliderFrame.Visible = states.speed
        sliderFrame.BorderSizePixel = 1
        sliderFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
        sliderFrame.ZIndex = 10
        Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0.1, 0)
        
        sliderLabel = Instance.new("TextLabel", sliderFrame)
        sliderLabel.Size = UDim2.new(1, 0, 0, 22)
        sliderLabel.Text = "Скорость: " .. math.floor(settings.speedValue)
        sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Font = Enum.Font.SourceSansBold
        sliderLabel.TextSize = 14
        sliderLabel.ZIndex = 10
        
        local sliderBg = Instance.new("Frame", sliderFrame)
        sliderBg.Size = UDim2.new(1, 0, 0, 12)
        sliderBg.Position = UDim2.new(0, 0, 0, 28)
        sliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        sliderBg.BorderSizePixel = 0
        sliderBg.ZIndex = 10
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0.2, 0)
        
        sliderFill = Instance.new("Frame", sliderBg)
        sliderFill.Size = UDim2.new(settings.speedValue/200, 0, 1, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        sliderFill.BorderSizePixel = 0
        sliderFill.ZIndex = 10
        Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(0.2, 0)
        
        local dragSlider = false
        sliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragSlider = true
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                local value = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1) * 200
                settings.speedValue = math.floor(value)
                if states.speed and humanoid and humanoid.Parent then
                    humanoid.WalkSpeed = settings.speedValue
                end
                sliderLabel.Text = "Скорость: " .. settings.speedValue
                sliderFill.Size = UDim2.new(settings.speedValue/200, 0, 1, 0)
            end
        end)
        sliderBg.InputChanged:Connect(function(input)
            if dragSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                local value = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1) * 200
                settings.speedValue = math.floor(value)
                if states.speed and humanoid and humanoid.Parent then
                    humanoid.WalkSpeed = settings.speedValue
                end
                sliderLabel.Text = "Скорость: " .. settings.speedValue
                sliderFill.Size = UDim2.new(settings.speedValue/200, 0, 1, 0)
            end
        end)
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragSlider = false
            end
        end)
        
        -- Высокий прыжок
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
        Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(0.1, 0)
        
        jumpBtn.MouseEnter:Connect(function()
            jumpBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
        end)
        jumpBtn.MouseLeave:Connect(function()
            jumpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        
        jumpBtn.MouseButton1Click:Connect(function()
            toggleHighJump()
            jumpBtn.Text = states.highjump and "🦘 Высокий прыжок    [⊂❍]" or "🦘 Высокий прыжок    [❍⊃]"
            jumpBtn.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            jumpBtn.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
            if jumpSliderFrame then
                jumpSliderFrame.Visible = states.highjump
            end
        end)
        
        jumpSliderFrame = Instance.new("Frame", contentFrame)
        jumpSliderFrame.Size = UDim2.new(1, 0, 0, 50)
        jumpSliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
        jumpSliderFrame.BackgroundTransparency = 0.3
        jumpSliderFrame.Visible = states.highjump
        jumpSliderFrame.BorderSizePixel = 1
        jumpSliderFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
        jumpSliderFrame.ZIndex = 10
        Instance.new("UICorner", jumpSliderFrame).CornerRadius = UDim.new(0.1, 0)
        
        jumpSliderLabel = Instance.new("TextLabel", jumpSliderFrame)
        jumpSliderLabel.Size = UDim2.new(1, 0, 0, 22)
        jumpSliderLabel.Text = "Высота прыжка: " .. math.floor(settings.jumpPower)
        jumpSliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        jumpSliderLabel.BackgroundTransparency = 1
        jumpSliderLabel.Font = Enum.Font.SourceSansBold
        jumpSliderLabel.TextSize = 14
        jumpSliderLabel.ZIndex = 10
        
        local jumpSliderBg = Instance.new("Frame", jumpSliderFrame)
        jumpSliderBg.Size = UDim2.new(1, 0, 0, 12)
        jumpSliderBg.Position = UDim2.new(0, 0, 0, 28)
        jumpSliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        jumpSliderBg.BorderSizePixel = 0
        jumpSliderBg.ZIndex = 10
        Instance.new("UICorner", jumpSliderBg).CornerRadius = UDim.new(0.2, 0)
        
        jumpSliderFill = Instance.new("Frame", jumpSliderBg)
        jumpSliderFill.Size = UDim2.new((settings.jumpPower - 50) / 450, 0, 1, 0)
        jumpSliderFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        jumpSliderFill.BorderSizePixel = 0
        jumpSliderFill.ZIndex = 10
        Instance.new("UICorner", jumpSliderFill).CornerRadius = UDim.new(0.2, 0)
        
        local dragJump = false
        jumpSliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragJump = true
                local pos = input.Position.X - jumpSliderBg.AbsolutePosition.X
                local value = math.clamp(pos / jumpSliderBg.AbsoluteSize.X, 0, 1) * 450 + 50
                settings.jumpPower = math.floor(value)
                if states.highjump and humanoid and humanoid.Parent then
                    humanoid.JumpPower = settings.jumpPower
                end
                jumpSliderLabel.Text = "Высота прыжка: " .. settings.jumpPower
                jumpSliderFill.Size = UDim2.new((settings.jumpPower - 50) / 450, 0, 1, 0)
            end
        end)
        jumpSliderBg.InputChanged:Connect(function(input)
            if dragJump and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = input.Position.X - jumpSliderBg.AbsolutePosition.X
                local value = math.clamp(pos / jumpSliderBg.AbsoluteSize.X, 0, 1) * 450 + 50
                settings.jumpPower = math.floor(value)
                if states.highjump and humanoid and humanoid.Parent then
                    humanoid.JumpPower = settings.jumpPower
                end
                jumpSliderLabel.Text = "Высота прыжка: " .. settings.jumpPower
                jumpSliderFill.Size = UDim2.new((settings.jumpPower - 50) / 450, 0, 1, 0)
            end
        end)
        jumpSliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragJump = false
            end
        end)
        
        -- No Clip
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
        Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0.1, 0)
        
        noclipBtn.MouseEnter:Connect(function()
            noclipBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
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
        
        -- Fly
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
        Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0.1, 0)
        
        flyBtn.MouseEnter:Connect(function()
            flyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
        end)
        flyBtn.MouseLeave:Connect(function()
            flyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        flyBtn.MouseButton1Click:Connect(function()
            toggleFly()
            flyBtn.Text = states.fly and "✈ Fly    [⊂❍]" or "✈ Fly    [❍⊃]"
            flyBtn.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            flyBtn.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
            if flySliderFrame then
                flySliderFrame.Visible = states.fly
            end
        end)
        
        flySliderFrame = Instance.new("Frame", contentFrame)
        flySliderFrame.Size = UDim2.new(1, 0, 0, 50)
        flySliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
        flySliderFrame.BackgroundTransparency = 0.3
        flySliderFrame.Visible = states.fly
        flySliderFrame.BorderSizePixel = 1
        flySliderFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
        flySliderFrame.ZIndex = 10
        Instance.new("UICorner", flySliderFrame).CornerRadius = UDim.new(0.1, 0)
        
        flySliderLabel = Instance.new("TextLabel", flySliderFrame)
        flySliderLabel.Size = UDim2.new(1, 0, 0, 22)
        flySliderLabel.Text = "Скорость Fly: " .. math.floor(settings.flySpeed)
        flySliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        flySliderLabel.BackgroundTransparency = 1
        flySliderLabel.Font = Enum.Font.SourceSansBold
        flySliderLabel.TextSize = 14
        flySliderLabel.ZIndex = 10
        
        local flySliderBg = Instance.new("Frame", flySliderFrame)
        flySliderBg.Size = UDim2.new(1, 0, 0, 12)
        flySliderBg.Position = UDim2.new(0, 0, 0, 28)
        flySliderBg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        flySliderBg.BorderSizePixel = 0
        flySliderBg.ZIndex = 10
        Instance.new("UICorner", flySliderBg).CornerRadius = UDim.new(0.2, 0)
        
        flySliderFill = Instance.new("Frame", flySliderBg)
        flySliderFill.Size = UDim2.new((settings.flySpeed - 20) / 280, 0, 1, 0)
        flySliderFill.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        flySliderFill.BorderSizePixel = 0
        flySliderFill.ZIndex = 10
        Instance.new("UICorner", flySliderFill).CornerRadius = UDim.new(0.2, 0)
        
        local dragFly = false
        flySliderBg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragFly = true
                local pos = input.Position.X - flySliderBg.AbsolutePosition.X
                local value = math.clamp(pos / flySliderBg.AbsoluteSize.X, 0, 1) * 280 + 20
                settings.flySpeed = math.floor(value)
                flySliderLabel.Text = "Скорость Fly: " .. settings.flySpeed
                flySliderFill.Size = UDim2.new((settings.flySpeed - 20) / 280, 0, 1, 0)
            end
        end)
        flySliderBg.InputChanged:Connect(function(input)
            if dragFly and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = input.Position.X - flySliderBg.AbsolutePosition.X
                local value = math.clamp(pos / flySliderBg.AbsoluteSize.X, 0, 1) * 280 + 20
                settings.flySpeed = math.floor(value)
                flySliderLabel.Text = "Скорость Fly: " .. settings.flySpeed
                flySliderFill.Size = UDim2.new((settings.flySpeed - 20) / 280, 0, 1, 0)
            end
        end)
        flySliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragFly = false
            end
        end)
        
        -- Невидимость
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
        Instance.new("UICorner", invBtn).CornerRadius = UDim.new(0.1, 0)
        
        invBtn.MouseEnter:Connect(function()
            invBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
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
        
        -- ТП к игроку
        tpBtn = Instance.new("TextButton", contentFrame)
        tpBtn.Size = UDim2.new(1, 0, 0, 40)
        tpBtn.Text = states.tp and "📌 ТП к игроку    [⊂❍]" or "📌 ТП к игроку    [❍⊃]"
        tpBtn.TextColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        tpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        tpBtn.BackgroundTransparency = 0.2
        tpBtn.Font = Enum.Font.SourceSansBold
        tpBtn.TextSize = 15
        tpBtn.BorderSizePixel = 1
        tpBtn.BorderColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        tpBtn.ZIndex = 10
        Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0.1, 0)
        
        tpBtn.MouseEnter:Connect(function()
            tpBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
        end)
        tpBtn.MouseLeave:Connect(function()
            tpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        tpBtn.MouseButton1Click:Connect(function()
            toggleTeleport()
            tpBtn.Text = states.tp and "📌 ТП к игроку    [⊂❍]" or "📌 ТП к игроку    [❍⊃]"
            tpBtn.TextColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            tpBtn.BorderColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
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
        Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0.1, 0)
        
        aimBtn.MouseEnter:Connect(function()
            aimBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
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
        Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0.1, 0)
        
        espBtn.MouseEnter:Connect(function()
            espBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
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
        
        espNameBtn = Instance.new("TextButton", contentFrame)
        espNameBtn.Size = UDim2.new(1, 0, 0, 40)
        espNameBtn.Text = states.espName and "👤 Имя    [⊂❍]" or "👤 Имя    [❍⊃]"
        espNameBtn.TextColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        espNameBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        espNameBtn.BackgroundTransparency = 0.2
        espNameBtn.Font = Enum.Font.SourceSansBold
        espNameBtn.TextSize = 15
        espNameBtn.BorderSizePixel = 1
        espNameBtn.BorderColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        espNameBtn.ZIndex = 10
        Instance.new("UICorner", espNameBtn).CornerRadius = UDim.new(0.1, 0)
        
        espNameBtn.MouseEnter:Connect(function()
            espNameBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
        end)
        espNameBtn.MouseLeave:Connect(function()
            espNameBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        espNameBtn.MouseButton1Click:Connect(function()
            toggleESPName()
            espNameBtn.Text = states.espName and "👤 Имя    [⊂❍]" or "👤 Имя    [❍⊃]"
            espNameBtn.TextColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            espNameBtn.BorderColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        espDistBtn = Instance.new("TextButton", contentFrame)
        espDistBtn.Size = UDim2.new(1, 0, 0, 40)
        espDistBtn.Text = states.espDistance and "📏 Дистанция    [⊂❍]" or "📏 Дистанция    [❍⊃]"
        espDistBtn.TextColor3 = states.espDistance and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        espDistBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        espDistBtn.BackgroundTransparency = 0.2
        espDistBtn.Font = Enum.Font.SourceSansBold
        espDistBtn.TextSize = 15
        espDistBtn.BorderSizePixel = 1
        espDistBtn.BorderColor3 = states.espDistance and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        espDistBtn.ZIndex = 10
        Instance.new("UICorner", espDistBtn).CornerRadius = UDim.new(0.1, 0)
        
        espDistBtn.MouseEnter:Connect(function()
            espDistBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
        end)
        espDistBtn.MouseLeave:Connect(function()
            espDistBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        espDistBtn.MouseButton1Click:Connect(function()
            toggleESPDistance()
            espDistBtn.Text = states.espDistance and "📏 Дистанция    [⊂❍]" or "📏 Дистанция    [❍⊃]"
            espDistBtn.TextColor3 = states.espDistance and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            espDistBtn.BorderColor3 = states.espDistance and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 4 then -- Настройки
        -- Цвет ESP
        colorBtn = Instance.new("TextButton", contentFrame)
        colorBtn.Size = UDim2.new(1, 0, 0, 40)
        local colorNames = {"🔴 Красный", "🟡 Жёлтый", "🔵 Синий", "🟢 Зелёный", "🩷 Розовый", "⚪ Белый"}
        local colorValues = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(255, 105, 180),
            Color3.fromRGB(255, 255, 255)
        }
        local currentIdx = 1
        for i, c in ipairs(colorValues) do
            if c == settings.espColor then currentIdx = i end
        end
        colorBtn.Text = "🎨 Цвет ESP: " .. colorNames[currentIdx]
        colorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        colorBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        colorBtn.BackgroundTransparency = 0.2
        colorBtn.Font = Enum.Font.SourceSansBold
        colorBtn.TextSize = 15
        colorBtn.BorderSizePixel = 1
        colorBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        colorBtn.ZIndex = 10
        Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0.1, 0)
        
        colorBtn.MouseEnter:Connect(function()
            colorBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
        end)
        colorBtn.MouseLeave:Connect(function()
            colorBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        colorBtn.MouseButton1Click:Connect(function()
            currentIdx = currentIdx % #colorValues + 1
            settings.espColor = colorValues[currentIdx]
            colorBtn.Text = "🎨 Цвет ESP: " .. colorNames[currentIdx]
            if states.esp then
                for _, obj in pairs(espObjects) do
                    if obj.box then obj.box.Color3 = settings.espColor end
                    if obj.label then obj.label.TextColor3 = settings.espColor end
                end
            end
        end)
        
        -- Размер ESP
        sizeBtn = Instance.new("TextButton", contentFrame)
        sizeBtn.Size = UDim2.new(1, 0, 0, 40)
        sizeBtn.Text = "📐 Размер ESP: " .. settings.espSize
        sizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        sizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        sizeBtn.BackgroundTransparency = 0.2
        sizeBtn.Font = Enum.Font.SourceSansBold
        sizeBtn.TextSize = 15
        sizeBtn.BorderSizePixel = 1
        sizeBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        sizeBtn.ZIndex = 10
        Instance.new("UICorner", sizeBtn).CornerRadius = UDim.new(0.1, 0)
        
        sizeBtn.MouseEnter:Connect(function()
            sizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
        end)
        sizeBtn.MouseLeave:Connect(function()
            sizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        sizeBtn.MouseButton1Click:Connect(function()
            settings.espSize = settings.espSize % 10 + 1
            sizeBtn.Text = "📐 Размер ESP: " .. settings.espSize
            if states.esp then
                for _, obj in pairs(espObjects) do
                    if obj.box then
                        local size = settings.espSize
                        obj.box.Size = Vector3.new(size, size + 2, size - 1)
                    end
                end
            end
        end)
        
        -- Прозрачность ESP
        transBtn = Instance.new("TextButton", contentFrame)
        transBtn.Size = UDim2.new(1, 0, 0, 40)
        transBtn.Text = "🔆 Прозрачность: " .. string.format("%.1f", settings.espTransparency)
        transBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        transBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        transBtn.BackgroundTransparency = 0.2
        transBtn.Font = Enum.Font.SourceSansBold
        transBtn.TextSize = 15
        transBtn.BorderSizePixel = 1
        transBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        transBtn.ZIndex = 10
        Instance.new("UICorner", transBtn).CornerRadius = UDim.new(0.1, 0)
        
        transBtn.MouseEnter:Connect(function()
            transBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
        end)
        transBtn.MouseLeave:Connect(function()
            transBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        transBtn.MouseButton1Click:Connect(function()
            settings.espTransparency = (settings.espTransparency + 0.1)
            if settings.espTransparency > 1.0 then
                settings.espTransparency = 0.1
            end
            transBtn.Text = "🔆 Прозрачность: " .. string.format("%.1f", settings.espTransparency)
            if states.esp then
                for _, obj in pairs(espObjects) do
                    if obj.box then
                        obj.box.Transparency = settings.espTransparency
                    end
                end
            end
        end)
        
        -- Дальность Aimbot
        distBtn = Instance.new("TextButton", contentFrame)
        distBtn.Size = UDim2.new(1, 0, 0, 40)
        distBtn.Text = "🎯 Дальность: " .. settings.aimbotDistance
        distBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        distBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        distBtn.BackgroundTransparency = 0.2
        distBtn.Font = Enum.Font.SourceSansBold
        distBtn.TextSize = 15
        distBtn.BorderSizePixel = 1
        distBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        distBtn.ZIndex = 10
        Instance.new("UICorner", distBtn).CornerRadius = UDim.new(0.1, 0)
        
        distBtn.MouseEnter:Connect(function()
            distBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 70)
        end)
        distBtn.MouseLeave:Connect(function()
            distBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        end)
        distBtn.MouseButton1Click:Connect(function()
            settings.aimbotDistance = settings.aimbotDistance + 50
            if settings.aimbotDistance > 500 then
                settings.aimbotDistance = 50
            end
            distBtn.Text = "🎯 Дальность: " .. settings.aimbotDistance
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
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0.1, 0)
        
        closeBtn.MouseEnter:Connect(function()
            closeBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
        end)
        closeBtn.MouseLeave:Connect(function()
            closeBtn.BackgroundColor3 = Color3.fromRGB(30, 10, 10)
        end)
        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
            if flyControls then flyControls:Destroy() end
            if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
        end)
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 52)
end

updateContent()

print("✅ PRISON RP ULTRA V62 by shasik_1488 загружен!")
