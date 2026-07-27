-- ============================================
-- PRISON RP ULTIMATE v1.0
-- by shasik_1488
-- ============================================

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- ============================================
-- ЧИТЫ
-- ============================================

-- 1. БЕССМЕРТИЕ
local godmode = false
local godConnection = nil

function toggleGodmode()
    godmode = not godmode
    if godmode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        if godConnection then godConnection:Disconnect() end
        godConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not godmode then return end
            pcall(function()
                humanoid.MaxHealth = math.huge
                humanoid.Health = math.huge
            end)
        end)
    else
        if godConnection then godConnection:Disconnect(); godConnection = nil end
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
    print(godmode and "✅ Бессмертие ВКЛ" or "❌ Бессмертие ВЫКЛ")
end

-- 2. СКОРОСТЬ
local speed = false
local speedConnection = nil
local speedValue = 100

function toggleSpeed()
    speed = not speed
    if speed then
        if speedConnection then speedConnection:Disconnect() end
        speedConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not speed then return end
            pcall(function()
                humanoid.WalkSpeed = speedValue
            end)
        end)
    else
        if speedConnection then speedConnection:Disconnect(); speedConnection = nil end
        humanoid.WalkSpeed = 16
    end
    print(speed and "✅ Скорость ВКЛ" or "❌ Скорость ВЫКЛ")
end

-- 3. NO CLIP
local noclip = false
function toggleNoclip()
    noclip = not noclip
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclip
        end
    end
    print(noclip and "✅ No Clip ВКЛ" or "❌ No Clip ВЫКЛ")
end

-- 4. FLY
local fly = false
local flyConnection = nil

function toggleFly()
    fly = not fly
    if fly then
        humanoid.PlatformStand = true
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        
        flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not fly then
                bv:Destroy()
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
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
        humanoid.PlatformStand = false
        for _, v in pairs(root:GetChildren()) do
            if v:IsA("BodyVelocity") then v:Destroy() end
        end
    end
    print(fly and "✅ Fly ВКЛ" or "❌ Fly ВЫКЛ")
end

-- ============================================
-- МЕНЮ (ОТКРЫВАЕТСЯ ПО КНОПКЕ "X")
-- ============================================
local menu = Instance.new("ScreenGui", game.CoreGui)
menu.Name = "ShasikMenu"

local frame = Instance.new("Frame", menu)
frame.Size = UDim2.new(0, 250, 0, 400)
frame.Position = UDim2.new(0.5, -125, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
frame.BackgroundTransparency = 0
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 45)
title.Text = "✦ shasik_1488 ✦"
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22

local btns = {
    {text = "❤ Бессмертие", func = toggleGodmode},
    {text = "⚡ Скорость", func = toggleSpeed},
    {text = "👻 No Clip", func = toggleNoclip},
    {text = "✈ Fly", func = toggleFly}
}

for i, btn in ipairs(btns) do
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1, -20, 0, 40)
    b.Position = UDim2.new(0, 10, 0, 60 + (i-1)*50)
    b.Text = btn.text .. "    [❍⊃]"
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    b.BorderSizePixel = 0
    b.ZIndex = 2
    
    b.MouseButton1Click:Connect(function()
        btn.func()
        if b.Text:find("❍⊃") then
            b.Text = btn.text .. "    [⊂❍]"
            b.TextColor3 = Color3.fromRGB(0, 255, 100)
        else
            b.Text = btn.text .. "    [❍⊃]"
            b.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end)
end

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(1, -20, 0, 40)
closeBtn.Position = UDim2.new(0, 10, 0, 60 + #btns*50 + 10)
closeBtn.Text = "⛔ ЗАКРЫТЬ"
closeBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 16
closeBtn.BorderSizePixel = 0
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

print("✅ Меню загружено! Нажми 'X' для вызова.")
