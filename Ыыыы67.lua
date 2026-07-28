local TweenService = game:Service("TweenService")
local Players = game:Service("Players")
local RunService = game:Service("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Удаляем старую версию интерфейса
if PlayerGui:FindFirstChild("PrisonRP_Menu") then
    PlayerGui.PrisonRP_Menu:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PrisonRP_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ==========================================
-- КРУГЛАЯ ИКОНКА С ТВОЕЙ КАРТИНКОЙ
-- ==========================================
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 65, 0, 65) -- Чуть увеличил размер для красоты
ToggleButton.Position = UDim2.new(0, 20, 0.5, -32)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

-- Твоя картинка (Серебряный Сёрфер), загруженная в Roblox
ToggleButton.Image = "rbxassetid://135890786522338" 
ToggleButton.ImageScaleType = Enum.ScaleType.Crop -- Обрезает картинку ровно под круг

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(1, 0) -- Делает кнопку идеально круглой
ButtonCorner.Parent = ToggleButton

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(255, 255, 255) -- Белая обводка под стиль картинки
ButtonStroke.Thickness = 2
ButtonStroke.Parent = ToggleButton

-- Перетаскивание кнопки (Drag)
local dragging, dragInput, dragStart, startPos
ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleButton.Position
    end
end)
ToggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
game:Service("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        ToggleButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
game:Service("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- ==========================================
-- ГЛАВНОЕ МЕНЮ С ЭФФЕКТОМ СНЕГА
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BackgroundTransparency = 1
MainFrame.ClipsDescendants = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 14)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(100, 100, 110)
FrameStroke.Thickness = 1.5
FrameStroke.Transparency = 1
FrameStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "[good] Premium Menu"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextTransparency = 1
Title.ZIndex = 2
Title.Parent = MainFrame

local SnowContainer = Instance.new("Frame")
SnowContainer.Name = "SnowContainer"
SnowContainer.Size = UDim2.new(1, 0, 1, 0)
SnowContainer.BackgroundTransparency = 1
SnowContainer.ZIndex = 1
SnowContainer.Parent = MainFrame

-- Система реалистичного снега
local maxSnowflakes = 45
local snowflakes = {}

local function createSnowflake()
    local flake = Instance.new("Frame")
    flake.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    flake.BackgroundTransparency = math.random(3, 7) / 10
    local size = math.random(2, 4)
    flake.Size = UDim2.new(0, size, 0, size)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = flake
    flake.Position = UDim2.new(math.random(), 0, -0.05, 0)
    flake.ZIndex = 1
    flake.Parent = SnowContainer
    
    table.insert(snowflakes, {
        object = flake,
        speedY = math.random(50, 95) / 100,
        speedX = math.random(-15, 15) / 100,
        swingSpeed = math.random(2, 4),
        swingIntensity = math.random(6, 12) / 100,
        timeAlive = 0
    })
end

RunService.RenderStepped:Connect(function(deltaTime)
    if not MainFrame.Visible then return end
    if #snowflakes < maxSnowflakes and math.random() > 0.75 then
        createSnowflake()
    end
    for i = #snowflakes, 1, -1 do
        local data = snowflakes[i]
        if data and data.object and data.object.Parent then
            data.timeAlive = data.timeAlive + deltaTime
            local currentX = data.object.Position.X.Scale
            local currentY = data.object.Position.Y.Scale
            local windEffect = math.sin(data.timeAlive * data.swingSpeed) * data.swingIntensity * deltaTime
            local newX = currentX + (data.speedX * deltaTime) + windEffect
            local newY = currentY + (data.speedY * deltaTime)
            if newY > 1.05 or newX < -0.05 or newX > 1.05 then
                data.object:Destroy()
                table.remove(snowflakes, i)
            else
                data.object.Position = UDim2.new(newX, 0, newY, 0)
            end
        else
            table.remove(snowflakes, i)
        end
    end
end)

-- ==========================================
-- АНИМАЦИЯ ОТКРЫТИЯ И ЗАКРЫТИЯ
-- ==========================================
local menuOpen = false
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local function toggleMenu()
    menuOpen = not menuOpen
    
    if menuOpen then
        MainFrame.Visible = true
        TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 0.15}):Play()
        TweenService:Create(FrameStroke, tweenInfo, {Transparency = 0}):Play()
        TweenService:Create(Title, tweenInfo, {TextTransparency = 0}):Play()
        
        -- Меню плавно вырастает
        MainFrame.Size = UDim2.new(0, 400, 0, 240)
        MainFrame.Position = UDim2.new(0.5, -200, 0.5, -120)
        TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 450, 0, 280),
            Position = UDim2.new(0.5, -225, 0.5, -140)
        }):Play()
        
        -- Эффект легкого увеличения иконки при нажатии
        TweenService:Create(ToggleButton, tweenInfo, {Size = UDim2.new(0, 70, 0, 70)}):Play()
    else
        local closeTween = TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 400, 0, 240),
            Position = UDim2.new(0.5, -200, 0.5, -120),
            BackgroundTransparency = 1
        })
        TweenService:Create(FrameStroke, tweenInfo, {Transparency = 1}):Play()
        TweenService:Create(Title, tweenInfo, {TextTransparency = 1}):Play()
        TweenService:Create(ToggleButton, tweenInfo, {Size = UDim2.new(0, 65, 0, 65)}):Play()
        
        closeTween:Play()
        closeTween.Completed:Connect(function()
            if not menuOpen then
                MainFrame.Visible = false
                SnowContainer:ClearAllChildren()
                snowflakes = {}
            end
        end)
    end
end

ToggleButton.MouseButton1Click:Connect(toggleMenu)
print("[good]: Круглая иконка-аватарка настроена, меню готово.")
