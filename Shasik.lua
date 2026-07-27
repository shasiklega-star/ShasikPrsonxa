-- Prison RP Script v12.0 | by shasik_1488 | FLY FIXED
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
-- БЕССМЕРТИЕ
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

-- ============================================
-- СКОРОСТЬ
-- ============================================
function tSpeed()
    states.speed = not states.speed
    if connections.speed then connections.speed:Disconnect() end
    if states.speed then
        connections.speed = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.speed then return end
            pcall(function()
                humanoid.WalkSpeed = 100
            end)
        end)
    else
        humanoid.WalkSpeed = 16
    end
    notify("Скорость", states.speed)
end

-- ============================================
-- NO CLIP
-- ============================================
function tNoClip()
    states.noclip = not states.noclip
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not states.noclip
        end
    end
    notify("No Clip", states.noclip)
end

-- ============================================
-- FLY (ИСПРАВЛЕН)
-- ============================================
function tFly()
    states.fly = not states.fly
    if states.fly then
        notify("Fly", true)
        if connections.fly then connections.fly:Disconnect() end
        
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        humanoid.PlatformStand = true
        
        connections.fly = game:GetService("RunService").Heartbeat:Connect(function()
            if not states.fly then
                bv:Destroy()
                humanoid.PlatformStand = false
                return
            end
            
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

-- ============================================
-- УНИВЕРСАЛЬНЫЕ ДВЕРИ
-- ============================================
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

-- ============================================
-- НЕВИДИМОСТЬ (ПРОСТАЯ)
-- ============================================
function tInvisible()
    states.invisible = not states.invisible
    if states.invisible then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
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

-- ============================================
-- АНТИ-АФК
-- ============================================
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

-- ============================================
-- ОРУЖИЕ
-- ============================================
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
-- ПРОСТОЕ МЕНЮ (БЕЗ ГЛЮКОВ)
-- ============================================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "ShasikCheat"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 400)
frame.Position = UDim2.new(0.5, -120, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "✧ shasik_1488 ✧"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local btns = {
    {name = "❤ Бессмертие", func = tGodmode, state = "godmode"},
    {name = "⚡ Супер скорость", func = tSpeed, state = "speed"},
    {name = "👻 No Clip", func = tNoClip, state = "noclip"},
    {name = "✈ Fly", func = tFly, state = "fly"},
    {name = "🚪 Универсальные двери", func = tUniversalDoors, state = "universal"},
    {name = "👀 Невидимость", func = tInvisible, state = "invisible"},
    {name = "🔒 Анти-АФК", func = tAntiAFK, state = "antiafk"},
    {name = "🔫 Всё оружие", func = giveAllWeapons, state = "weapons"}
}

for i, btn in ipairs(btns) do
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.new(0, 10, 0, 45 + (i-1)*40)
    b.Text = btn.name .. "    [❍⊃]"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    
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
exitBtn.Size = UDim2.new(1, -20, 0, 35)
exitBtn.Position = UDim2.new(0, 10, 0, 45 + #btns*40 + 10)
exitBtn.Text = "⛔ Выйти"
exitBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
exitBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
exitBtn.Font = Enum.Font.SourceSansBold
exitBtn.TextSize = 15
exitBtn.MouseButton1Click:Connect(function()
    for _, v in pairs(connections) do if v then v:Disconnect() end end
    gui:Destroy()
end)

print("✅ Prison RP Cheat by shasik_1488 загружен!")
