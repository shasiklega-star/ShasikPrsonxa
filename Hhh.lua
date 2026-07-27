-- ============================================
-- SHASIK_1488 ULTIMATE EDITION (ПОЛНАЯ ВЕРСИЯ)
-- PRISON RP | ВСЁ РАБОТАЕТ | КИБЕРПАНК 2026
-- ============================================

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()
local uis = game:GetService("UserInputService")

-- ============================================
-- МАКСИМАЛЬНЫЙ ОБХОД АНТИЧИТА
-- ============================================
pcall(function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            if v.Name:lower():find("anticheat") or 
               v.Name:lower():find("anti") or 
               v.Name:lower():find("detect") or 
               v.Name:lower():find("cheat") or 
               v.Name:lower():find("security") or 
               v.Name:lower():find("exploit") or
               v.Name:lower():find("health") or
               v.Name:lower():find("damage") or
               v.Name:lower():find("heal") or
               v.Name:lower():find("food") or
               v.Name:lower():find("water") or
               v.Name:lower():find("hunger") or
               v.Name:lower():find("ban") or
               v.Name:lower():find("kick") then
                v.Disabled = true
            end
        end
        if v:IsA("RemoteEvent") and (v.Name:lower():find("anti") or v.Name:lower():find("detect") or v.Name:lower():find("health") or v.Name:lower():find("damage") or v.Name:lower():find("heal") or v.Name:lower():find("food") or v.Name:lower():find("water")) then
            v:Destroy()
        end
    end
    pcall(function()
        if game:GetService("ReplicatedStorage"):FindFirstChild("Ping") then
            game:GetService("ReplicatedStorage").Ping:Destroy()
        end
        if game:GetService("ReplicatedStorage"):FindFirstChild("AntiCheat") then
            game:GetService("ReplicatedStorage").AntiCheat:Destroy()
        end
        if game:GetService("ReplicatedStorage"):FindFirstChild("Security") then
            game:GetService("ReplicatedStorage").Security:Destroy()
        end
        if game:GetService("ReplicatedStorage"):FindFirstChild("Telemetry") then
            game:GetService("ReplicatedStorage").Telemetry:Destroy()
        end
        if game:GetService("ReplicatedStorage"):FindFirstChild("Analytics") then
            game:GetService("ReplicatedStorage").Analytics:Destroy()
        end
    end)
    for _, v in pairs(game.CoreGui:GetDescendants()) do
        if v:IsA("ScreenGui") and (v.Name:lower():find("anti") or v.Name:lower():find("detect") or v.Name:lower():find("security")) then
            v:Destroy()
        end
    end
end)

print("✅ АНТИЧИТ ОБОЙДЁН!")

-- ============================================
-- СОХРАНЕНИЕ НАСТРОЕК
-- ============================================
local settingsFile = "ShasikCheatSettings"
local settings = {
    espSize = 3,
    espTransparency = 0.5,
    aimbotDistance = 100,
    speedValue = 100,
    flySpeed = 100,
    jumpPower = 150,
    espColor = Color3.fromRGB(255, 0, 0),
    theme = "dark",
    silentFov = 200
}

function loadSettings()
    local success, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(settingsFile))
    end)
    if success and data then
        for k, v in pairs(data) do
            if k == "espColor" then
                settings.espColor = Color3.fromRGB(v.r, v.g, v.b)
            else
                settings[k] = v
            end
        end
    end
end

function saveSettings()
    local data = {}
    for k, v in pairs(settings) do
        if k == "espColor" then
            data[k] = {r = v.r * 255, g = v.g * 255, b = v.b * 255}
        else
            data[k] = v
        end
    end
    pcall(function()
        writefile(settingsFile, game:GetService("HttpService"):JSONEncode(data))
    end)
end

loadSettings()

-- ============================================
-- СОСТОЯНИЯ
-- ============================================
local states = {
    godmode = false,
    autoHeal = false,
    foodWater = false,
    highjump = false,
    speed = false,
    noclip = false,
    fly = false,
    esp = false,
    aimbot = false,
    autoaim = false,
    invisible = false,
    tp = false,
    espName = false,
    espDistance = false
}

local connections = {}
local espObjects = {}
local espConnections = {}
local flyKeys = {w = false, a = false, s = false, d = false, space = false, shift = false}
local flyBV = nil
local flyBodyGyro = nil
local flyControls = nil
local savedAccessories = {}
local tpFrame = nil
local tpMenuOpen = false
local currentCategory = 1

-- ============================================
-- ЗВУК И УВЕДОМЛЕНИЯ
-- ============================================
function playClick()
    pcall(function()
        local sound = Instance.new("Sound", workspace)
        sound.SoundId = "rbxassetid://9120381960"
        sound.Volume = 0.2
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

-- ============================================
-- ПЕРЕЗАГРУЗКА ПОСЛЕ СМЕРТИ
-- ============================================
function reconnectAfterDeath()
    char = player.Character
    if not char then return end
    humanoid = char:WaitForChild("Humanoid")
    root = char:WaitForChild("HumanoidRootPart")
    if states.godmode then toggleGodMode() end
    if states.autoHeal then toggleAutoHeal() end
    if states.foodWater then toggleFoodWater() end
    if states.highjump then toggleHighJump() end
    if states.speed then toggleSpeed() end
    if states.noclip then toggleNoClip() end
    if states.fly then toggleFly() end
    if states.esp then toggleESP() end
    if states.aimbot then toggleAimbot() end
    if states.autoaim then toggleAutoAim() end
    if states.invisible then toggleInvisible() end
end

player.CharacterAdded:Connect(function()
    task.wait(0.5)
    reconnectAfterDeath()
end)

-- ============================================
-- БЕССМЕРТИЕ (РЕАЛЬНОЕ)
-- ============================================
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
                if humanoid.Parent:FindFirstChild("HumanoidRootPart") then
                    humanoid.Parent.HumanoidRootPart.Anchored = true
                end
            end
        end)
        if godBtn then
            godBtn.Text = "👑 Бессмертие    [⊂❍]"
            godBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
            godBtn.BorderColor3 = Color3.fromRGB(255, 215, 0)
        end
        notify("Бессмертие", true)
    else
        if connections.godMode then connections.godMode:Disconnect(); connections.godMode = nil end
        humanoid.BreakJointsOnDeath = true
        root.Anchored = false
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        if godBtn then
            godBtn.Text = "👑 Бессмертие    [❍⊃]"
            godBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            godBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        notify("Бессмертие", false)
    end
end

pcall(function()
    humanoid.Died:Connect(function()
        if states.godmode then
            humanoid.Health = math.huge
            root.Anchored = true
            root.CFrame = CFrame.new(0, 10, 0)
        end
    end)
end)

-- ============================================
-- АВТО-ЛЕЧЕНИЕ
-- ============================================
function toggleAutoHeal()
    states.autoHeal = not states.autoHeal
    playClick()
    if states.autoHeal then
        if connections.autoHeal then connections.autoHeal:Disconnect() end
        connections.autoHeal = game:GetService("RunService").Heartbeat:Connect(function()
            if states.autoHeal and humanoid and humanoid.Parent then
                if humanoid.Health < 50 then
                    humanoid.Health = 100
                end
            end
        end)
        if autoHealBtn then
            autoHealBtn.Text = "💊 Авто-лечение    [⊂❍]"
            autoHealBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            autoHealBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
        notify("Авто-лечение", true)
    else
        if connections.autoHeal then connections.autoHeal:Disconnect(); connections.autoHeal = nil end
        if autoHealBtn then
            autoHealBtn.Text = "💊 Авто-лечение    [❍⊃]"
            autoHealBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            autoHealBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        notify("Авто-лечение", false)
    end
end

-- ============================================
-- ГОЛОД И ВОДА
-- ============================================
function toggleFoodWater()
    states.foodWater = not states.foodWater
    playClick()
    if states.foodWater then
        fillFoodWater()
        if foodWaterBtn then
            foodWaterBtn.Text = "🍔 Голод/Вода    [⊂❍]"
            foodWaterBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            foodWaterBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
        notify("Голод/Вода", true)
    else
        if foodWaterBtn then
            foodWaterBtn.Text = "🍔 Голод/Вода    [❍⊃]"
            foodWaterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            foodWaterBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        notify("Голод/Вода", false)
    end
end

function fillFoodWater()
    pcall(function()
        local hunger = humanoid:FindFirstChild("Hunger")
        if hunger then hunger.Value = 100 end
        local thirst = humanoid:FindFirstChild("Thirst")
        if thirst then thirst.Value = 100 end
        local stats = player:FindFirstChild("leaderstats")
        if stats then
            for _, stat in pairs(stats:GetChildren()) do
                if stat.Name:lower():find("hunger") or stat.Name:lower():find("food") then
                    stat.Value = 100
                end
                if stat.Name:lower():find("thirst") or stat.Name:lower():find("water") then
                    stat.Value = 100
                end
            end
        end
    end)
end

game:GetService("RunService").Heartbeat:Connect(function()
    if states.foodWater then fillFoodWater() end
end)

-- ============================================
-- NO CLIP (ИСПРАВЛЕН)
-- ============================================
function toggleNoClip()
    states.noclip = not states.noclip
    playClick()
    if states.noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        if connections.noclipDesc then connections.noclipDesc:Disconnect() end
        connections.noclipDesc = char.DescendantAdded:Connect(function(part)
            if states.noclip and part:IsA("BasePart") then
                part.CanCollide = false
            end
        end)
        if connections.noclipLoop then connections.noclipLoop:Disconnect() end
        connections.noclipLoop = game:GetService("RunService").Heartbeat:Connect(function()
            if states.noclip and root and root.Parent then
                root.CanCollide = false
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide == true then
                        part.CanCollide = false
                    end
                end
            end
        end)
        if noclipBtn then
            noclipBtn.Text = "👻 No Clip    [⊂❍]"
            noclipBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            noclipBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
        notify("No Clip", true)
    else
        if connections.noclipDesc then connections.noclipDesc:Disconnect(); connections.noclipDesc = nil end
        if connections.noclipLoop then connections.noclipLoop:Disconnect(); connections.noclipLoop = nil end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        if noclipBtn then
            noclipBtn.Text = "👻 No Clip    [❍⊃]"
            noclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            noclipBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        notify("No Clip", false)
    end
end

-- ============================================
-- ВЫСОКИЙ ПРЫЖОК
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
        if jumpSliderFrame then jumpSliderFrame.Visible = true end
    else
        if connections.highjump then connections.highjump:Disconnect(); connections.highjump = nil end
        if humanoid and humanoid.Parent then humanoid.JumpPower = 50 end
        if jumpBtn then
            jumpBtn.Text = "🦘 Высокий прыжок    [❍⊃]"
            jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            jumpBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        if jumpSliderFrame then jumpSliderFrame.Visible = false end
    end
    notify("Высокий прыжок", states.highjump)
end

-- ============================================
-- СПИДХАК
-- ============================================
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
        if sliderFrame then sliderFrame.Visible = true end
    else
        if connections.speed then connections.speed:Disconnect(); connections.speed = nil end
        if humanoid and humanoid.Parent then humanoid.WalkSpeed = 16 end
        if speedBtn then
            speedBtn.Text = "⚡ Спидхак    [❍⊃]"
            speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            speedBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        if sliderFrame then sliderFrame.Visible = false end
    end
    notify("Спидхак", states.speed)
end

-- ============================================
-- FLY
-- ============================================
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
        if flySliderFrame then flySliderFrame.Visible = true end
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
        if flySliderFrame then flySliderFrame.Visible = false end
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

-- ============================================
-- ESP
-- ============================================
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
                task.wait(1)
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

-- ============================================
-- AIMBOT
-- ============================================
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
        local part = target.Character:FindFirstChild("Head") or target.Character:FindFirstChild("HumanoidRootPart")
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

-- ============================================
-- AUTO-AIM (ЖЁСТКОЕ НАВЕДЕНИЕ)
-- ============================================
function toggleAutoAim()
    states.autoaim = not states.autoaim
    playClick()
    if states.autoaim then
        if connections.autoAim then connections.autoAim:Disconnect() end
        connections.autoAim = game:GetService("RunService").RenderStepped:Connect(function()
            if not states.autoaim then return end
            local target = getClosestHead()
            if target then
                camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
            end
        end)
        if autoAimBtn then
            autoAimBtn.Text = "🎯 Auto-Aim    [⊂❍]"
            autoAimBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
            autoAimBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
        end
        notify("Auto-Aim", true)
    else
        if connections.autoAim then connections.autoAim:Disconnect(); connections.autoAim = nil end
        if autoAimBtn then
            autoAimBtn.Text = "🎯 Auto-Aim    [❍⊃]"
            autoAimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            autoAimBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        notify("Auto-Aim", false)
    end
end

function getClosestHead()
    local closest = nil
    local minDist = math.huge
    local origin = camera.CFrame.Position
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local head = p.Character:FindFirstChild("Head")
            if head then
                local distance = (head.Position - origin).Magnitude
                if distance < minDist then
                    minDist = distance
                    closest = head
                end
            end
        end
    end
    return closest
end

-- ============================================
-- НЕВИДИМОСТЬ
-- ============================================
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

-- ============================================
-- ТЕЛЕПОРТ К ИГРОКУ
-- ============================================
function toggleTeleport()
    if tpMenuOpen then
        if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
        tpMenuOpen = false
        states.tp = false
        if tpBtn then
            tpBtn.Text = "📌 ТП к игроку    [❍⊃]"
            tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tpBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        end
        return
    end
    
    states.tp = true
    tpMenuOpen = true
    
    if tpBtn then
        tpBtn.Text = "📌 ТП к игроку    [⊂❍]"
        tpBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        tpBtn.BorderColor3 = Color3.fromRGB(0, 255, 100)
    end
    
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
        tpMenuOpen = false
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
end

-- ============================================
-- МЕНЮ (КИБЕРПАНК 2026 + СНЕГ ВНУТРИ)
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 500, 0, 640)
frame.Position = UDim2.new(0.5, -250, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(6, 6, 20)
frame.BackgroundTransparency = 0.1
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.BorderSizePixel = 0
frame.ZIndex = 5

-- Стекло
local glass = Instance.new("Frame", frame)
glass.Size = UDim2.new(1, 0, 1, 0)
glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
glass.BackgroundTransparency = 0.95
glass.BorderSizePixel = 0
glass.ZIndex = 1

-- Неоновая рамка
local border = Instance.new("UIStroke", frame)
border.Color = Color3.fromRGB(0, 200, 255)
border.Thickness = 3
border.Transparency = 0.3
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

spawn(function()
    while true do
        local t = tick() * 1.5
        border.Transparency = 0.1 + math.sin(t) * 0.2
        border.Color = Color3.new(0.2 + math.sin(t) * 0.1, 0.8 + math.sin(t + 0.5) * 0.1, 1)
        task.wait(0.05)
    end
end)

-- Уголки
local function corner(pos, color)
    local c = Instance.new("Frame", frame)
    c.Size = UDim2.new(0, 30, 0, 30)
    c.Position = pos
    c.BackgroundColor3 = color
    c.BackgroundTransparency = 0.1
    c.BorderSizePixel = 0
    c.ZIndex = 10
    local s = Instance.new("UIStroke", c)
    s.Color = color
    s.Thickness = 2
    s.Transparency = 0.2
end

corner(UDim2.new(0, 5, 0, 5), Color3.fromRGB(0, 200, 255))
corner(UDim2.new(1, -35, 0, 5), Color3.fromRGB(255, 0, 200))
corner(UDim2.new(0, 5, 1, -35), Color3.fromRGB(200, 0, 255))
corner(UDim2.new(1, -35, 1, -35), Color3.fromRGB(0, 255, 200))

-- Заголовок
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 60)
title.Text = "✦ SHASIK_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 32
title.ZIndex = 10

local subtitle = Instance.new("TextLabel", frame)
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0, 0, 0, 55)
subtitle.Text = "PRISON RP | ULTIMATE EDITION"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 255)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.ZIndex = 10

-- Категории
local categories = {"Главная", "Бой", "ESP", "Настройки"}
local categoryButtons = {}
local catFrame = Instance.new("Frame", frame)
catFrame.Size = UDim2.new(0.9, 0, 0, 40)
catFrame.Position = UDim2.new(0.05, 0, 0, 95)
catFrame.BackgroundTransparency = 1
catFrame.ZIndex = 10

for i, cat in ipairs(categories) do
    local btn = Instance.new("TextButton", catFrame)
    btn.Size = UDim2.new(0.25, -4, 1, 0)
    btn.Position = UDim2.new((i-1)*0.25, 2, 0, 0)
    btn.Text = cat
    btn.TextColor3 = Color3.fromRGB(200, 200, 255)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
    btn.BackgroundTransparency = 0.3
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.ZIndex = 10
    local cornerBtn = Instance.new("UICorner", btn)
    cornerBtn.CornerRadius = UDim.new(0.3, 0)
    btn.MouseButton1Click:Connect(function()
        currentCategory = i
        for _, b in pairs(categoryButtons) do
            b.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
            b.TextColor3 = Color3.fromRGB(200, 200, 255)
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 100)
        btn.TextColor3 = Color3.fromRGB(255, 215, 0)
        updateContent()
    end)
    categoryButtons[i] = btn
end
categoryButtons[1].BackgroundColor3 = Color3.fromRGB(40, 40, 100)
categoryButtons[1].TextColor3 = Color3.fromRGB(255, 215, 0)

-- Контент
local contentFrame = Instance.new("ScrollingFrame", frame)
contentFrame.Size = UDim2.new(1, -20, 1, -170)
contentFrame.Position = UDim2.new(0, 10, 0, 145)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.ClipsDescendants = true
contentFrame.BorderSizePixel = 0
contentFrame.ZIndex = 10
contentFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- ============================================
-- СНЕГ В МЕНЮ
-- ============================================
local snowContainer = Instance.new("Frame", frame)
snowContainer.Size = UDim2.new(1, 0, 1, 0)
snowContainer.Position = UDim2.new(0, 0, 0, 0)
snowContainer.BackgroundTransparency = 1
snowContainer.ZIndex = 0
snowContainer.ClipsDescendants = false

local snowParticles = {}
for i = 1, 100 do
    local size = math.random(1, 5)
    local particle = Instance.new("Frame", snowContainer)
    particle.Size = UDim2.new(0, size, 0, size)
    particle.Position = UDim2.new(math.random() / 2, 0, math.random() / 2, 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    particle.BackgroundTransparency = 0.3 + math.random() * 0.4
    particle.BorderSizePixel = 0
    particle.ZIndex = 1
    local corner = Instance.new("UICorner", particle)
    corner.CornerRadius = UDim.new(0.5, 0)
    table.insert(snowParticles, {
        frame = particle,
        speed = 0.1 + math.random() * 0.4,
        drift = math.random(-1, 1) * 0.05,
        x = particle.Position.X.Scale,
        y = particle.Position.Y.Scale
    })
end

game:GetService("RunService").Heartbeat:Connect(function()
    for _, p in pairs(snowParticles) do
        p.y = p.y + p.speed * 0.005
        p.x = p.x + math.sin(tick() * p.drift) * 0.0002
        if p.y > 1 then
            p.y = -0.05
            p.x = math.random() / 2
        end
        if p.x < -0.1 then p.x = 1.1
        elseif p.x > 1.1 then p.x = -0.1 end
        p.frame.Position = UDim2.new(p.x, 0, p.y, 0)
    end
end)

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
        -- ГЛАВНАЯ
        godBtn = Instance.new("TextButton", contentFrame)
        godBtn.Size = UDim2.new(1, 0, 0, 40)
        godBtn.Text = states.godmode and "👑 Бессмертие    [⊂❍]" or "👑 Бессмертие    [❍⊃]"
        godBtn.TextColor3 = states.godmode and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
        godBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        godBtn.BackgroundTransparency = 0.2
        godBtn.Font = Enum.Font.GothamBold
        godBtn.TextSize = 15
        godBtn.BorderSizePixel = 1
        godBtn.BorderColor3 = states.godmode and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 150, 255)
        godBtn.ZIndex = 10
        Instance.new("UICorner", godBtn).CornerRadius = UDim.new(0.1, 0)
        godBtn.MouseButton1Click:Connect(function()
            toggleGodMode()
            godBtn.Text = states.godmode and "👑 Бессмертие    [⊂❍]" or "👑 Бессмертие    [❍⊃]"
            godBtn.TextColor3 = states.godmode and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(255, 255, 255)
            godBtn.BorderColor3 = states.godmode and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 150, 255)
        end)
        
        autoHealBtn = Instance.new("TextButton", contentFrame)
        autoHealBtn.Size = UDim2.new(1, 0, 0, 40)
        autoHealBtn.Text = states.autoHeal and "💊 Авто-лечение    [⊂❍]" or "💊 Авто-лечение    [❍⊃]"
        autoHealBtn.TextColor3 = states.autoHeal and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        autoHealBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        autoHealBtn.BackgroundTransparency = 0.2
        autoHealBtn.Font = Enum.Font.GothamBold
        autoHealBtn.TextSize = 15
        autoHealBtn.BorderSizePixel = 1
        autoHealBtn.BorderColor3 = states.autoHeal and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        autoHealBtn.ZIndex = 10
        Instance.new("UICorner", autoHealBtn).CornerRadius = UDim.new(0.1, 0)
        autoHealBtn.MouseButton1Click:Connect(function()
            toggleAutoHeal()
            autoHealBtn.Text = states.autoHeal and "💊 Авто-лечение    [⊂❍]" or "💊 Авто-лечение    [❍⊃]"
            autoHealBtn.TextColor3 = states.autoHeal and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            autoHealBtn.BorderColor3 = states.autoHeal and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        foodWaterBtn = Instance.new("TextButton", contentFrame)
        foodWaterBtn.Size = UDim2.new(1, 0, 0, 40)
        foodWaterBtn.Text = states.foodWater and "🍔 Голод/Вода    [⊂❍]" or "🍔 Голод/Вода    [❍⊃]"
        foodWaterBtn.TextColor3 = states.foodWater and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        foodWaterBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        foodWaterBtn.BackgroundTransparency = 0.2
        foodWaterBtn.Font = Enum.Font.GothamBold
        foodWaterBtn.TextSize = 15
        foodWaterBtn.BorderSizePixel = 1
        foodWaterBtn.BorderColor3 = states.foodWater and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        foodWaterBtn.ZIndex = 10
        Instance.new("UICorner", foodWaterBtn).CornerRadius = UDim.new(0.1, 0)
        foodWaterBtn.MouseButton1Click:Connect(function()
            toggleFoodWater()
            foodWaterBtn.Text = states.foodWater and "🍔 Голод/Вода    [⊂❍]" or "🍔 Голод/Вода    [❍⊃]"
            foodWaterBtn.TextColor3 = states.foodWater and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            foodWaterBtn.BorderColor3 = states.foodWater and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        noclipBtn = Instance.new("TextButton", contentFrame)
        noclipBtn.Size = UDim2.new(1, 0, 0, 40)
        noclipBtn.Text = states.noclip and "👻 No Clip    [⊂❍]" or "👻 No Clip    [❍⊃]"
        noclipBtn.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        noclipBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        noclipBtn.BackgroundTransparency = 0.2
        noclipBtn.Font = Enum.Font.GothamBold
        noclipBtn.TextSize = 15
        noclipBtn.BorderSizePixel = 1
        noclipBtn.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        noclipBtn.ZIndex = 10
        Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0.1, 0)
        noclipBtn.MouseButton1Click:Connect(function()
            toggleNoClip()
            noclipBtn.Text = states.noclip and "👻 No Clip    [⊂❍]" or "👻 No Clip    [❍⊃]"
            noclipBtn.TextColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            noclipBtn.BorderColor3 = states.noclip and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        speedBtn = Instance.new("TextButton", contentFrame)
        speedBtn.Size = UDim2.new(1, 0, 0, 40)
        speedBtn.Text = states.speed and "⚡ Спидхак    [⊂❍]" or "⚡ Спидхак    [❍⊃]"
        speedBtn.TextColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        speedBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        speedBtn.BackgroundTransparency = 0.2
        speedBtn.Font = Enum.Font.GothamBold
        speedBtn.TextSize = 15
        speedBtn.BorderSizePixel = 1
        speedBtn.BorderColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        speedBtn.ZIndex = 10
        Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0.1, 0)
        speedBtn.MouseButton1Click:Connect(function()
            toggleSpeed()
            speedBtn.Text = states.speed and "⚡ Спидхак    [⊂❍]" or "⚡ Спидхак    [❍⊃]"
            speedBtn.TextColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            speedBtn.BorderColor3 = states.speed and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
            if sliderFrame then sliderFrame.Visible = states.speed end
        end)
        
        sliderFrame = Instance.new("Frame", contentFrame)
        sliderFrame.Size = UDim2.new(1, 0, 0, 52)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
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
        sliderLabel.Font = Enum.Font.GothamBold
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
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragSlider = true
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                local value = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1) * 200
                settings.speedValue = math.floor(value)
                if states.speed and humanoid then humanoid.WalkSpeed = settings.speedValue end
                sliderLabel.Text = "Скорость: " .. settings.speedValue
                sliderFill.Size = UDim2.new(settings.speedValue/200, 0, 1, 0)
            end
        end)
        sliderBg.InputChanged:Connect(function(input)
            if dragSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = input.Position.X - sliderBg.AbsolutePosition.X
                local value = math.clamp(pos / sliderBg.AbsoluteSize.X, 0, 1) * 200
                settings.speedValue = math.floor(value)
                if states.speed and humanoid then humanoid.WalkSpeed = settings.speedValue end
                sliderLabel.Text = "Скорость: " .. settings.speedValue
                sliderFill.Size = UDim2.new(settings.speedValue/200, 0, 1, 0)
            end
        end)
        sliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragSlider = false
            end
        end)
        
        jumpBtn = Instance.new("TextButton", contentFrame)
        jumpBtn.Size = UDim2.new(1, 0, 0, 40)
        jumpBtn.Text = states.highjump and "🦘 Высокий прыжок    [⊂❍]" or "🦘 Высокий прыжок    [❍⊃]"
        jumpBtn.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        jumpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        jumpBtn.BackgroundTransparency = 0.2
        jumpBtn.Font = Enum.Font.GothamBold
        jumpBtn.TextSize = 15
        jumpBtn.BorderSizePixel = 1
        jumpBtn.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        jumpBtn.ZIndex = 10
        Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(0.1, 0)
        jumpBtn.MouseButton1Click:Connect(function()
            toggleHighJump()
            jumpBtn.Text = states.highjump and "🦘 Высокий прыжок    [⊂❍]" or "🦘 Высокий прыжок    [❍⊃]"
            jumpBtn.TextColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            jumpBtn.BorderColor3 = states.highjump and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
            if jumpSliderFrame then jumpSliderFrame.Visible = states.highjump end
        end)
        
        jumpSliderFrame = Instance.new("Frame", contentFrame)
        jumpSliderFrame.Size = UDim2.new(1, 0, 0, 52)
        jumpSliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
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
        jumpSliderLabel.Font = Enum.Font.GothamBold
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
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragJump = true
                local pos = input.Position.X - jumpSliderBg.AbsolutePosition.X
                local value = math.clamp(pos / jumpSliderBg.AbsoluteSize.X, 0, 1) * 450 + 50
                settings.jumpPower = math.floor(value)
                if states.highjump and humanoid then humanoid.JumpPower = settings.jumpPower end
                jumpSliderLabel.Text = "Высота прыжка: " .. settings.jumpPower
                jumpSliderFill.Size = UDim2.new((settings.jumpPower - 50) / 450, 0, 1, 0)
            end
        end)
        jumpSliderBg.InputChanged:Connect(function(input)
            if dragJump and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = input.Position.X - jumpSliderBg.AbsolutePosition.X
                local value = math.clamp(pos / jumpSliderBg.AbsoluteSize.X, 0, 1) * 450 + 50
                settings.jumpPower = math.floor(value)
                if states.highjump and humanoid then humanoid.JumpPower = settings.jumpPower end
                jumpSliderLabel.Text = "Высота прыжка: " .. settings.jumpPower
                jumpSliderFill.Size = UDim2.new((settings.jumpPower - 50) / 450, 0, 1, 0)
            end
        end)
        jumpSliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragJump = false
            end
        end)
        
        flyBtn = Instance.new("TextButton", contentFrame)
        flyBtn.Size = UDim2.new(1, 0, 0, 40)
        flyBtn.Text = states.fly and "✈ Fly    [⊂❍]" or "✈ Fly    [❍⊃]"
        flyBtn.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        flyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        flyBtn.BackgroundTransparency = 0.2
        flyBtn.Font = Enum.Font.GothamBold
        flyBtn.TextSize = 15
        flyBtn.BorderSizePixel = 1
        flyBtn.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        flyBtn.ZIndex = 10
        Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0.1, 0)
        flyBtn.MouseButton1Click:Connect(function()
            toggleFly()
            flyBtn.Text = states.fly and "✈ Fly    [⊂❍]" or "✈ Fly    [❍⊃]"
            flyBtn.TextColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            flyBtn.BorderColor3 = states.fly and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
            if flySliderFrame then flySliderFrame.Visible = states.fly end
        end)
        
        flySliderFrame = Instance.new("Frame", contentFrame)
        flySliderFrame.Size = UDim2.new(1, 0, 0, 52)
        flySliderFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
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
        flySliderLabel.Font = Enum.Font.GothamBold
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
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragFly = true
                local pos = input.Position.X - flySliderBg.AbsolutePosition.X
                local value = math.clamp(pos / flySliderBg.AbsoluteSize.X, 0, 1) * 280 + 20
                settings.flySpeed = math.floor(value)
                flySliderLabel.Text = "Скорость Fly: " .. settings.flySpeed
                flySliderFill.Size = UDim2.new((settings.flySpeed - 20) / 280, 0, 1, 0)
            end
        end)
        flySliderBg.InputChanged:Connect(function(input)
            if dragFly and input.UserInputType == Enum.UserInputType.MouseMovement then
                local pos = input.Position.X - flySliderBg.AbsolutePosition.X
                local value = math.clamp(pos / flySliderBg.AbsoluteSize.X, 0, 1) * 280 + 20
                settings.flySpeed = math.floor(value)
                flySliderLabel.Text = "Скорость Fly: " .. settings.flySpeed
                flySliderFill.Size = UDim2.new((settings.flySpeed - 20) / 280, 0, 1, 0)
            end
        end)
        flySliderBg.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragFly = false
            end
        end)
        
        invBtn = Instance.new("TextButton", contentFrame)
        invBtn.Size = UDim2.new(1, 0, 0, 40)
        invBtn.Text = states.invisible and "🥷 Невидимость    [⊂❍]" or "🥷 Невидимость    [❍⊃]"
        invBtn.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        invBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        invBtn.BackgroundTransparency = 0.2
        invBtn.Font = Enum.Font.GothamBold
        invBtn.TextSize = 15
        invBtn.BorderSizePixel = 1
        invBtn.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        invBtn.ZIndex = 10
        Instance.new("UICorner", invBtn).CornerRadius = UDim.new(0.1, 0)
        invBtn.MouseButton1Click:Connect(function()
            toggleInvisible()
            invBtn.Text = states.invisible and "🥷 Невидимость    [⊂❍]" or "🥷 Невидимость    [❍⊃]"
            invBtn.TextColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            invBtn.BorderColor3 = states.invisible and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        tpBtn = Instance.new("TextButton", contentFrame)
        tpBtn.Size = UDim2.new(1, 0, 0, 40)
        tpBtn.Text = states.tp and "📌 ТП к игроку    [⊂❍]" or "📌 ТП к игроку    [❍⊃]"
        tpBtn.TextColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        tpBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        tpBtn.BackgroundTransparency = 0.2
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.TextSize = 15
        tpBtn.BorderSizePixel = 1
        tpBtn.BorderColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        tpBtn.ZIndex = 10
        Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0.1, 0)
        tpBtn.MouseButton1Click:Connect(function()
            toggleTeleport()
            tpBtn.Text = states.tp and "📌 ТП к игроку    [⊂❍]" or "📌 ТП к игроку    [❍⊃]"
            tpBtn.TextColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            tpBtn.BorderColor3 = states.tp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 2 then
        -- БОЙ
        aimBtn = Instance.new("TextButton", contentFrame)
        aimBtn.Size = UDim2.new(1, 0, 0, 40)
        aimBtn.Text = states.aimbot and "🎯 Aimbot    [⊂❍]" or "🎯 Aimbot    [❍⊃]"
        aimBtn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        aimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        aimBtn.BackgroundTransparency = 0.2
        aimBtn.Font = Enum.Font.GothamBold
        aimBtn.TextSize = 15
        aimBtn.BorderSizePixel = 1
        aimBtn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        aimBtn.ZIndex = 10
        Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0.1, 0)
        aimBtn.MouseButton1Click:Connect(function()
            toggleAimbot()
            aimBtn.Text = states.aimbot and "🎯 Aimbot    [⊂❍]" or "🎯 Aimbot    [❍⊃]"
            aimBtn.TextColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            aimBtn.BorderColor3 = states.aimbot and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
        autoAimBtn = Instance.new("TextButton", contentFrame)
        autoAimBtn.Size = UDim2.new(1, 0, 0, 40)
        autoAimBtn.Text = states.autoaim and "🎯 Auto-Aim    [⊂❍]" or "🎯 Auto-Aim    [❍⊃]"
        autoAimBtn.TextColor3 = states.autoaim and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        autoAimBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        autoAimBtn.BackgroundTransparency = 0.2
        autoAimBtn.Font = Enum.Font.GothamBold
        autoAimBtn.TextSize = 15
        autoAimBtn.BorderSizePixel = 1
        autoAimBtn.BorderColor3 = states.autoaim and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        autoAimBtn.ZIndex = 10
        Instance.new("UICorner", autoAimBtn).CornerRadius = UDim.new(0.1, 0)
        autoAimBtn.MouseButton1Click:Connect(function()
            toggleAutoAim()
            autoAimBtn.Text = states.autoaim and "🎯 Auto-Aim    [⊂❍]" or "🎯 Auto-Aim    [❍⊃]"
            autoAimBtn.TextColor3 = states.autoaim and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            autoAimBtn.BorderColor3 = states.autoaim and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 3 then
        -- ESP
        espBtn = Instance.new("TextButton", contentFrame)
        espBtn.Size = UDim2.new(1, 0, 0, 40)
        espBtn.Text = states.esp and "👁️ ESP    [⊂❍]" or "👁️ ESP    [❍⊃]"
        espBtn.TextColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
        espBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        espBtn.BackgroundTransparency = 0.2
        espBtn.Font = Enum.Font.GothamBold
        espBtn.TextSize = 15
        espBtn.BorderSizePixel = 1
        espBtn.BorderColor3 = states.esp and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        espBtn.ZIndex = 10
        Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0.1, 0)
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
        espNameBtn.Font = Enum.Font.GothamBold
        espNameBtn.TextSize = 15
        espNameBtn.BorderSizePixel = 1
        espNameBtn.BorderColor3 = states.espName and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        espNameBtn.ZIndex = 10
        Instance.new("UICorner", espNameBtn).CornerRadius = UDim.new(0.1, 0)
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
        espDistBtn.Font = Enum.Font.GothamBold
        espDistBtn.TextSize = 15
        espDistBtn.BorderSizePixel = 1
        espDistBtn.BorderColor3 = states.espDistance and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        espDistBtn.ZIndex = 10
        Instance.new("UICorner", espDistBtn).CornerRadius = UDim.new(0.1, 0)
        espDistBtn.MouseButton1Click:Connect(function()
            toggleESPDistance()
            espDistBtn.Text = states.espDistance and "📏 Дистанция    [⊂❍]" or "📏 Дистанция    [❍⊃]"
            espDistBtn.TextColor3 = states.espDistance and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 255, 255)
            espDistBtn.BorderColor3 = states.espDistance and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 150, 255)
        end)
        
    elseif currentCategory == 4 then
        -- НАСТРОЙКИ
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
        colorBtn.Font = Enum.Font.GothamBold
        colorBtn.TextSize = 15
        colorBtn.BorderSizePixel = 1
        colorBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        colorBtn.ZIndex = 10
        Instance.new("UICorner", colorBtn).CornerRadius = UDim.new(0.1, 0)
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
            saveSettings()
        end)
        
        sizeBtn = Instance.new("TextButton", contentFrame)
        sizeBtn.Size = UDim2.new(1, 0, 0, 40)
        sizeBtn.Text = "📐 Размер ESP: " .. settings.espSize
        sizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        sizeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        sizeBtn.BackgroundTransparency = 0.2
        sizeBtn.Font = Enum.Font.GothamBold
        sizeBtn.TextSize = 15
        sizeBtn.BorderSizePixel = 1
        sizeBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        sizeBtn.ZIndex = 10
        Instance.new("UICorner", sizeBtn).CornerRadius = UDim.new(0.1, 0)
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
            saveSettings()
        end)
        
        transBtn = Instance.new("TextButton", contentFrame)
        transBtn.Size = UDim2.new(1, 0, 0, 40)
        transBtn.Text = "🔆 Прозрачность: " .. string.format("%.1f", settings.espTransparency)
        transBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        transBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        transBtn.BackgroundTransparency = 0.2
        transBtn.Font = Enum.Font.GothamBold
        transBtn.TextSize = 15
        transBtn.BorderSizePixel = 1
        transBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        transBtn.ZIndex = 10
        Instance.new("UICorner", transBtn).CornerRadius = UDim.new(0.1, 0)
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
            saveSettings()
        end)
        
        distBtn = Instance.new("TextButton", contentFrame)
        distBtn.Size = UDim2.new(1, 0, 0, 40)
        distBtn.Text = "🎯 Дальность: " .. settings.aimbotDistance
        distBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        distBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        distBtn.BackgroundTransparency = 0.2
        distBtn.Font = Enum.Font.GothamBold
        distBtn.TextSize = 15
        distBtn.BorderSizePixel = 1
        distBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        distBtn.ZIndex = 10
        Instance.new("UICorner", distBtn).CornerRadius = UDim.new(0.1, 0)
        distBtn.MouseButton1Click:Connect(function()
            settings.aimbotDistance = settings.aimbotDistance + 50
            if settings.aimbotDistance > 500 then
                settings.aimbotDistance = 50
            end
            distBtn.Text = "🎯 Дальность: " .. settings.aimbotDistance
            saveSettings()
        end)
        
        themeBtn = Instance.new("TextButton", contentFrame)
        themeBtn.Size = UDim2.new(1, 0, 0, 40)
        themeBtn.Text = settings.theme == "dark" and "🌙 Тёмная тема" or "☀️ Светлая тема"
        themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        themeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
        themeBtn.BackgroundTransparency = 0.2
        themeBtn.Font = Enum.Font.GothamBold
        themeBtn.TextSize = 15
        themeBtn.BorderSizePixel = 1
        themeBtn.BorderColor3 = Color3.fromRGB(0, 150, 255)
        themeBtn.ZIndex = 10
        Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0.1, 0)
        themeBtn.MouseButton1Click:Connect(function()
            settings.theme = settings.theme == "dark" and "light" or "dark"
            themeBtn.Text = settings.theme == "dark" and "🌙 Тёмная тема" or "☀️ Светлая тема"
            frame.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(6, 6, 20) or Color3.fromRGB(240, 240, 255)
            border.Color = settings.theme == "dark" and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(100, 100, 200)
            title.TextColor3 = settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 0, 100)
            subtitle.TextColor3 = settings.theme == "dark" and Color3.fromRGB(150, 150, 255) or Color3.fromRGB(50, 50, 150)
            for _, btn in pairs(categoryButtons) do
                if btn.TextColor3 == (settings.theme == "dark" and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(0, 0, 150)) then
                    btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(40, 40, 100) or Color3.fromRGB(150, 150, 220)
                else
                    btn.BackgroundColor3 = settings.theme == "dark" and Color3.fromRGB(20, 20, 50) or Color3.fromRGB(200, 200, 230)
                    btn.TextColor3 = settings.theme == "dark" and Color3.fromRGB(200, 200, 255) or Color3.fromRGB(50, 50, 150)
                end
            end
            contentFrame.ScrollBarImageColor3 = settings.theme == "dark" and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(100, 100, 200)
            saveSettings()
        end)
        
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
        closeBtn.ZIndex = 10
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0.1, 0)
        closeBtn.MouseButton1Click:Connect(function()
            gui:Destroy()
            if flyControls then flyControls:Destroy() end
            if tpFrame then tpFrame.Parent:Destroy(); tpFrame = nil end
        end)
    end
    
    contentFrame.CanvasSize = UDim2.new(0, 0, 0, #contentFrame:GetChildren() * 52)
end

updateContent()

print("✅ SHASIK_1488 ULTIMATE EDITION ЗАГРУЖЕН!")
