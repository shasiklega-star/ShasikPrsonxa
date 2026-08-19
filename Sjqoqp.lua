--[===================================================================]--
--  ROBLOX CHEAT: SHASIK CHEATS v9.40 - FULL JETPACK INTEGRATED
--[===================================================================]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Terrain = Workspace:FindFirstChildOfClass("Terrain") or Workspace.Terrain
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local DefaultFOV = 70

if CoreGui:FindFirstChild("FastCheatGui") then
    CoreGui.FastCheatGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "FastCheatGui"
ScreenGui.ResetOnSpawn = false

local isAuthorized = false

--[===================================================================]--
--  МОДАЛЬНЫЕ ОКНА И УВЕДОМЛЕНИЯ
--[===================================================================]--

local ModalContainer = Instance.new("Frame", ScreenGui)
ModalContainer.Size = UDim2.new(1, 0, 1, 0)
ModalContainer.BackgroundTransparency = 1
ModalContainer.ZIndex = 200

local function ShowAlert(titleText, descText, isSuccess, callback)
    for _, child in ipairs(ModalContainer:GetChildren()) do child:Destroy() end

    local AlertBox = Instance.new("Frame", ModalContainer)
    AlertBox.Size = UDim2.new(0, 260, 0, 130)
    AlertBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    AlertBox.AnchorPoint = Vector2.new(0.5, 0.5)
    AlertBox.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    AlertBox.BackgroundTransparency = 1
    AlertBox.ZIndex = 201
    Instance.new("UICorner", AlertBox).CornerRadius = UDim.new(0, 10)

    local ABStroke = Instance.new("UIStroke", AlertBox)
    ABStroke.Color = Color3.fromRGB(45, 50, 65)
    ABStroke.Thickness = 1.2
    ABStroke.Transparency = 1

    local TitleHolder = Instance.new("Frame", AlertBox)
    TitleHolder.Size = UDim2.new(1, -20, 0, 24)
    TitleHolder.Position = UDim2.new(0, 10, 0, 18)
    TitleHolder.BackgroundTransparency = 1
    TitleHolder.ZIndex = 202

    local TitleLbl = Instance.new("TextLabel", TitleHolder)
    TitleLbl.Size = UDim2.new(1, 0, 1, 0)
    TitleLbl.Position = UDim2.new(0, 0, 0, 0)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = titleText
    TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 17
    TitleLbl.TextTransparency = 1
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Center
    TitleLbl.ZIndex = 202

    local CheckMark = nil
    if isSuccess then
        CheckMark = Instance.new("TextLabel", TitleHolder)
        CheckMark.Size = UDim2.new(0, 24, 0, 24)
        CheckMark.Position = UDim2.new(0.5, 42, 0, -1)
        CheckMark.AnchorPoint = Vector2.new(0, 0)
        CheckMark.BackgroundTransparency = 1
        CheckMark.Text = "✓"
        CheckMark.TextColor3 = Color3.fromRGB(65, 215, 140)
        CheckMark.Font = Enum.Font.GothamBold
        CheckMark.TextSize = 18
        CheckMark.TextTransparency = 1
        CheckMark.TextXAlignment = Enum.TextXAlignment.Center
        CheckMark.TextYAlignment = Enum.TextYAlignment.Center
        CheckMark.ZIndex = 203
        CheckMark.Rotation = -30
    end

    local DescLbl = Instance.new("TextLabel", AlertBox)
    DescLbl.Size = UDim2.new(1, -30, 0, 32)
    DescLbl.Position = UDim2.new(0, 15, 0, 48)
    DescLbl.BackgroundTransparency = 1
    DescLbl.Text = descText
    DescLbl.TextColor3 = Color3.fromRGB(160, 165, 180)
    DescLbl.Font = Enum.Font.Gotham
    DescLbl.TextSize = 13
    DescLbl.TextTransparency = 1
    DescLbl.TextWrapped = true
    DescLbl.TextXAlignment = Enum.TextXAlignment.Center
    DescLbl.ZIndex = 202

    local OkBtn = Instance.new("TextButton", AlertBox)
    OkBtn.Size = UDim2.new(0, 110, 0, 36)
    OkBtn.Position = UDim2.new(0.5, -55, 0, 88)
    OkBtn.BackgroundColor3 = Color3.fromRGB(53, 132, 228)
    OkBtn.BackgroundTransparency = 1
    OkBtn.Text = "OK"
    OkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OkBtn.Font = Enum.Font.GothamBold
    OkBtn.TextSize = 14
    OkBtn.TextTransparency = 1
    OkBtn.ZIndex = 202
    Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 8)

    TweenService:Create(AlertBox, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 290, 0, 142), BackgroundTransparency = 0.05}):Play()
    TweenService:Create(ABStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    TweenService:Create(TitleLbl, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(DescLbl, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(OkBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0}):Play()

    if CheckMark then
        task.delay(0.1, function()
            TweenService:Create(CheckMark, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {TextTransparency = 0, Rotation = 0}):Play()
        end)
    end

    OkBtn.MouseButton1Click:Connect(function()
        local tw = TweenService:Create(AlertBox, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 260, 0, 120), BackgroundTransparency = 1})
        TweenService:Create(ABStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        TweenService:Create(TitleLbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(DescLbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(OkBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
        if CheckMark then
            TweenService:Create(CheckMark, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        end
        tw:Play()
        tw.Completed:Connect(function()
            AlertBox:Destroy()
            if callback then callback() end
        end)
    end)
end

local activeLoadingBox = nil
local function ShowLoadingModal(text)
    if activeLoadingBox then activeLoadingBox:Destroy() end

    local LoadBox = Instance.new("Frame", ModalContainer)
    LoadBox.Size = UDim2.new(0, 300, 0, 100)
    LoadBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadBox.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadBox.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    LoadBox.BackgroundTransparency = 1
    LoadBox.ZIndex = 201
    Instance.new("UICorner", LoadBox).CornerRadius = UDim.new(0, 14)

    local LBStroke = Instance.new("UIStroke", LoadBox)
    LBStroke.Color = Color3.fromRGB(55, 60, 80)
    LBStroke.Thickness = 1.5
    LBStroke.Transparency = 1

    local CenterContent = Instance.new("Frame", LoadBox)
    CenterContent.Size = UDim2.new(1, 0, 1, 0)
    CenterContent.BackgroundTransparency = 1
    CenterContent.ZIndex = 202

    local Circle = Instance.new("Frame", CenterContent)
    Circle.Size = UDim2.new(0, 32, 0, 32)
    Circle.Position = UDim2.new(0.5, 0, 0.5, -22)
    Circle.AnchorPoint = Vector2.new(0.5, 0.5)
    Circle.BackgroundTransparency = 1
    Circle.ZIndex = 202

    local Ring = Instance.new("UIStroke", Circle)
    Ring.Color = Color3.fromRGB(200, 205, 215)
    Ring.Thickness = 3.5
    Ring.Transparency = 0
    Ring.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    
    local UIGrad = Instance.new("UIGradient", Ring)
    UIGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(0.7, 1),
        NumberSequenceKeypoint.new(1, 1)
    })

    local UICircle = Instance.new("UICorner", Circle)
    UICircle.CornerRadius = UDim.new(1, 0)

    local TextLbl = Instance.new("TextLabel", CenterContent)
    TextLbl.Size = UDim2.new(1, -20, 0, 32)
    TextLbl.Position = UDim2.new(0.5, 0, 0.5, 10)
    TextLbl.AnchorPoint = Vector2.new(0.5, 0)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLbl.Font = Enum.Font.GothamBold
    TextLbl.TextSize = 18
    TextLbl.TextTransparency = 1
    TextLbl.TextXAlignment = Enum.TextXAlignment.Center
    TextLbl.ZIndex = 202

    TweenService:Create(LoadBox, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 320, 0, 110), BackgroundTransparency = 0.05}):Play()
    TweenService:Create(LBStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
    TweenService:Create(TextLbl, TweenInfo.new(0.25), {TextTransparency = 0}):Play()

    local spinAngle = 0
    local spinConnection
    spinConnection = RunService.RenderStepped:Connect(function(dt)
        spinAngle = (spinAngle + dt * 400) % 360
        Circle.Rotation = spinAngle
    end)

    activeLoadingBox = LoadBox
    return {
        Close = function()
            if spinConnection then spinConnection:Disconnect() end
            if LoadBox then
                local tw = TweenService:Create(LoadBox, TweenInfo.new(0.15), {BackgroundTransparency = 1})
                TweenService:Create(LBStroke, TweenInfo.new(0.15), {Transparency = 1}):Play()
                TweenService:Create(TextLbl, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
                tw:Play()
                tw.Completed:Connect(function()
                    LoadBox:Destroy()
                    activeLoadingBox = nil
                end)
            end
        end
    }
end

--[===================================================================]--
--  КРУГЛАЯ ИКОНКА И АНИМАЦИИ
--[===================================================================]--

local FloatingIcon = Instance.new("ImageButton", ScreenGui)
FloatingIcon.Size = UDim2.new(0, 50, 0, 50)
FloatingIcon.Position = UDim2.new(0.5, -25, 0, 14)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
FloatingIcon.BackgroundTransparency = 0
FloatingIcon.Image = "rbxassetid://86847551807972"
FloatingIcon.Visible = false
FloatingIcon.ZIndex = 10
Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(1, 0)

local dragging = false
local activeTouchInput = nil
local dragStart, startPos
local isMoved = false
local tweenInfoDrag = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

FloatingIcon.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not dragging then
        dragging = true
        activeTouchInput = input
        dragStart = input.Position
        startPos = FloatingIcon.Position
        isMoved = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == activeTouchInput then
        local delta = input.Position - dragStart
        if delta.Magnitude > 6 then
            isMoved = true
        end
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(FloatingIcon, tweenInfoDrag, {Position = targetPos}):Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == activeTouchInput then
        dragging = false
        activeTouchInput = nil
    end
end)

local clickTweenDown = TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local clickTweenUp = TweenInfo.new(0.12, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function playClickAnimation(button)
    local originalSize = button.Size
    local downSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 6, originalSize.Y.Scale, originalSize.Y.Offset - 4)
    
    local toDown = TweenService:Create(button, clickTweenDown, {Size = downSize})
    local toUp = TweenService:Create(button, clickTweenUp, {Size = originalSize})
    
    toDown:Play()
    toDown.Completed:Connect(function()
        toUp:Play()
    end)
end

--[===================================================================]--
--  ОКНО АВТОРИЗАЦИИ
--[===================================================================]--

local AuthFrame = Instance.new("Frame", ScreenGui)
AuthFrame.Size = UDim2.new(0, 380, 0, 240)
AuthFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
AuthFrame.AnchorPoint = Vector2.new(0.5, 0.5)
AuthFrame.BackgroundColor3 = Color3.fromRGB(14, 16, 22)
AuthFrame.BackgroundTransparency = 1
AuthFrame.Visible = false
Instance.new("UICorner", AuthFrame).CornerRadius = UDim.new(0, 12)

local AuthStroke = Instance.new("UIStroke", AuthFrame)
AuthStroke.Color = Color3.fromRGB(40, 45, 60)
AuthStroke.Thickness = 1.2
AuthStroke.Transparency = 1

local AuthCloseBtn = Instance.new("TextButton", AuthFrame)
AuthCloseBtn.Size = UDim2.new(0, 28, 0, 28)
AuthCloseBtn.Position = UDim2.new(1, -34, 0, 12)
AuthCloseBtn.BackgroundTransparency = 1
AuthCloseBtn.Text = "×"
AuthCloseBtn.TextColor3 = Color3.fromRGB(160, 165, 180)
AuthCloseBtn.Font = Enum.Font.GothamBold
AuthCloseBtn.TextSize = 20

local AuthTitle = Instance.new("TextLabel", AuthFrame)
AuthTitle.Size = UDim2.new(1, 0, 0, 28)
AuthTitle.Position = UDim2.new(0, 0, 0, 18)
AuthTitle.BackgroundTransparency = 1
AuthTitle.Text = "ShasikCheats | АВТОРИЗАЦИЯ"
AuthTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AuthTitle.Font = Enum.Font.GothamBold
AuthTitle.TextSize = 16
AuthTitle.TextXAlignment = Enum.TextXAlignment.Center

local TextBoxBg = Instance.new("TextBox", AuthFrame)
TextBoxBg.Size = UDim2.new(1, -40, 0, 48)
TextBoxBg.Position = UDim2.new(0, 20, 0, 64)
TextBoxBg.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
TextBoxBg.Text = ""
TextBoxBg.PlaceholderText = "Введите ключ..."
TextBoxBg.PlaceholderColor3 = Color3.fromRGB(110, 115, 130)
TextBoxBg.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBoxBg.Font = Enum.Font.GothamBold
TextBoxBg.TextSize = 15
TextBoxBg.ClearTextOnFocus = false
Instance.new("UICorner", TextBoxBg).CornerRadius = UDim.new(0, 8)

local TBStroke = Instance.new("UIStroke", TextBoxBg)
TBStroke.Color = Color3.fromRGB(20, 22, 30)
TBStroke.Thickness = 0

local LoginBtn = Instance.new("TextButton", AuthFrame)
LoginBtn.Size = UDim2.new(0.5, -24, 0, 42)
LoginBtn.Position = UDim2.new(0, 20, 0, 142)
LoginBtn.BackgroundColor3 = Color3.fromRGB(53, 132, 228)
LoginBtn.Text = "Войти"
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.TextSize = 14
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 8)

local GetKeyBtn = Instance.new("TextButton", AuthFrame)
GetKeyBtn.Size = UDim2.new(0.5, -24, 0, 42)
GetKeyBtn.Position = UDim2.new(0.5, 4, 0, 142)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
GetKeyBtn.Text = "Получить ключ"
GetKeyBtn.TextColor3 = Color3.fromRGB(190, 195, 205)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

local GKBStroke = Instance.new("UIStroke", GetKeyBtn)
GKBStroke.Color = Color3.fromRGB(40, 45, 55)
GKBStroke.Thickness = 1

local function CloseAuthMenu()
    local tw = TweenService:Create(AuthFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 350, 0, 220),
        BackgroundTransparency = 1
    })
    TweenService:Create(AuthStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    TweenService:Create(AuthTitle, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    TweenService:Create(TextBoxBg, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(TBStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    TweenService:Create(LoginBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    TweenService:Create(GKBStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
    TweenService:Create(AuthCloseBtn, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    
    tw:Play()
    tw.Completed:Connect(function()
        AuthFrame.Visible = false
    end)
end

AuthCloseBtn.MouseButton1Click:Connect(function()
    playClickAnimation(AuthCloseBtn)
    CloseAuthMenu()
end)

local function OpenAuthMenu()
    AuthFrame.Visible = true
    AuthFrame.Size = UDim2.new(0, 350, 0, 220)
    AuthFrame.BackgroundTransparency = 1
    AuthStroke.Transparency = 1
    
    AuthTitle.TextTransparency = 1
    TextBoxBg.BackgroundTransparency = 1
    TextBoxBg.TextTransparency = 1
    TBStroke.Transparency = 1
    LoginBtn.BackgroundTransparency = 1
    LoginBtn.TextTransparency = 1
    GetKeyBtn.BackgroundTransparency = 1
    GetKeyBtn.TextTransparency = 1
    GKBStroke.Transparency = 1
    AuthCloseBtn.TextTransparency = 1

    TweenService:Create(AuthFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 240),
        BackgroundTransparency = 0.05
    }):Play()
    TweenService:Create(AuthStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    TweenService:Create(AuthTitle, TweenInfo.new(0.35), {TextTransparency = 0}):Play()
    TweenService:Create(TextBoxBg, TweenInfo.new(0.35), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TweenService:Create(TBStroke, TweenInfo.new(0.35), {Transparency = 0}):Play()
    TweenService:Create(LoginBtn, TweenInfo.new(0.35), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.35), {BackgroundTransparency = 0, TextTransparency = 0}):Play()
    TweenService:Create(GKBStroke, TweenInfo.new(0.35), {Transparency = 0}):Play()
    TweenService:Create(AuthCloseBtn, TweenInfo.new(0.35), {TextTransparency = 0}):Play()
end

OpenAuthMenu()

GetKeyBtn.MouseButton1Click:Connect(function()
    playClickAnimation(GetKeyBtn)
    pcall(function() setclipboard("https://t.me/shasikbospaxamadrid") end)
    GetKeyBtn.Text = "💬 t.me/shasikbospaxamadrid"
    task.wait(1.5)
    GetKeyBtn.Text = "Получить ключ"
end)

--[===================================================================]--
--  ГЛАВНОЕ ОКНО И ТАЙМЕРЫ
--[===================================================================]--

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 330)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BackgroundTransparency = 1
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(35, 35, 45)
MainStroke.Thickness = 1.0

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, -20, 0, 36)
TopBar.Position = UDim2.new(0, 10, 0, 10)
TopBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TopBar.BackgroundTransparency = 0.15
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 6)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -135, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ShasikCheats | v9.40"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local TimerLabel = Instance.new("TextLabel", TopBar)
TimerLabel.Size = UDim2.new(0, 65, 1, 0)
TimerLabel.Position = UDim2.new(1, -110, 0, 0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "00:00"
TimerLabel.TextColor3 = Color3.fromRGB(160, 165, 180)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextSize = 12
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right

local scriptStartTime = os.time()
local isOwnerKey = false
local totalTimerDuration = 15 * 60

RunService.Heartbeat:Connect(function()
    if isOwnerKey then
        TimerLabel.Text = "∞ Безлимит"
        TimerLabel.TextColor3 = Color3.fromRGB(75, 215, 105)
    else
        local elapsed = os.time() - scriptStartTime
        local remaining = totalTimerDuration - elapsed
        if remaining < 0 then remaining = 0 end
        local mins = math.floor(remaining / 60)
        local secs = remaining % 60
        TimerLabel.Text = string.format("%02d:%02d", mins, secs)
    end
end)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -36, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(180, 185, 200)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22

local isMenuOpen = false
local function toggleMenu()
    if not isAuthorized then
        OpenAuthMenu()
        FloatingIcon.Visible = false
        return
    end

    isMenuOpen = not isMenuOpen
    
    local scaleDown = TweenService:Create(FloatingIcon, TweenInfo.new(0.1), {Size = UDim2.new(0, 44, 0, 44)})
    local scaleUp = TweenService:Create(FloatingIcon, TweenInfo.new(0.1), {Size = UDim2.new(0, 50, 0, 50)})
    scaleDown:Play()
    scaleDown.Completed:Connect(function() scaleUp:Play() end)

    if isMenuOpen then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 530, 0, 310)
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.12,
            Size = UDim2.new(0, 560, 0, 330)
        }):Play()
    else
        local hideTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, 530, 0, 310)
        })
        hideTween:Play()
        hideTween.Completed:Connect(function()
            MainFrame.Visible = false
        end)
    end
end

CloseBtn.MouseButton1Click:Connect(function()
    playClickAnimation(CloseBtn)
    if isMenuOpen then toggleMenu() end
end)

FloatingIcon.MouseButton1Click:Connect(function()
    if not isMoved then
        toggleMenu()
    end
end)

local isChecking = false
local keyUsedByOthers = false

LoginBtn.MouseButton1Click:Connect(function()
    playClickAnimation(LoginBtn)
    if isChecking then return end
    
    local enteredKey = TextBoxBg.Text
    if enteredKey == "" then
        ShowAlert("Внимание", "Пожалуйста, введите ключ!", false)
        return
    end
    
    if keyUsedByOthers then
        local elapsed = os.time() - scriptStartTime
        if elapsed >= totalTimerDuration then
            ShowAlert("Неверный ключ", "Срок действия этого ключа истек! Ввод больше недоступен.", false)
            return
        end
    end
    
    isChecking = true
    local loader = ShowLoadingModal("Проверка ключа...")
    
    task.wait(1.5)
    loader.Close()
    
    if enteredKey == "Shasikcheats" or enteredKey == "Shasik" then
        isAuthorized = true
        isOwnerKey = true
        
        ShowAlert("Успешно", "Ключ успешно активирован", true, function()
            local tw = TweenService:Create(AuthFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(0, 350, 0, 220)})
            TweenService:Create(AuthStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(AuthTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(TextBoxBg, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(TBStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(LoginBtn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(GetKeyBtn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(GKBStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(AuthCloseBtn, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            tw:Play()
            tw.Completed:Connect(function()
                AuthFrame:Destroy()
            end)
            
            FloatingIcon.Visible = true
            toggleMenu()
        end)
    elseif enteredKey == "UserKey15m" then
        local elapsed = os.time() - scriptStartTime
        if keyUsedByOthers and elapsed >= totalTimerDuration then
            isChecking = false
            ShowAlert("Неверный ключ", "Этот ключ уже был использован и его время истекло!", false)
            return
        end
        
        isAuthorized = true
        isOwnerKey = false
        keyUsedByOthers = true
        scriptStartTime = os.time()
        
        ShowAlert("Успешно", "Ключ успешно активирован", true, function()
            local tw = TweenService:Create(AuthFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(0, 350, 0, 220)})
            TweenService:Create(AuthStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(AuthTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(TextBoxBg, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(TBStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(LoginBtn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(GetKeyBtn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TweenService:Create(GKBStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(AuthCloseBtn, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            tw:Play()
            tw.Completed:Connect(function()
                AuthFrame:Destroy()
            end)
            
            FloatingIcon.Visible = true
            toggleMenu()
        end)
    else
        isChecking = false
        ShowAlert("Неверный ключ", "Введенный ключ не найден в базе данных!", false)
    end
end)

--[===================================================================]--
--  ЛОГИКА ЧИТОВ, ЗАЩИТЫ И ДЖЕТПАКА
--[===================================================================]--

task.spawn(function()
    pcall(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then return nil end
            return oldNamecall(self, ...)
        end)
    end)
end)

_G.SpeedHackEnabled = _G.SpeedHackEnabled or false
_G.WalkSpeedValue = 150
_G.SuperRunEnabled = _G.SuperRunEnabled or false
_G.HighJumpEnabled = _G.HighJumpEnabled or false
_G.JumpHeightValue = _G.JumpHeightValue or 50
_G.LongJumpEnabled = _G.LongJumpEnabled or false
_G.FastTurnEnabled = _G.FastTurnEnabled or false
_G.GravityEnabled = _G.GravityEnabled or false
_G.NoClipEnabled = _G.NoClipEnabled or false
_G.FakeAFKEnabled = _G.FakeAFKEnabled or false
_G.JetpackEnabled = _G.JetpackEnabled or false

_G.FOVEnabled = _G.FOVEnabled or false
_G.FOV2Enabled = _G.FOV2Enabled or false
_G.FOV3Enabled = _G.FOV3Enabled or false
_G.ESP3DEnabled = _G.ESP3DEnabled or false
_G.ESPNamesEnabled = _G.ESPNamesEnabled or false

_G.WeatherNightEnabled = _G.WeatherNightEnabled or false
_G.WeatherSunsetEnabled = _G.WeatherSunsetEnabled or false
_G.WeatherStormEnabled = _G.WeatherStormEnabled or false
_G.WeatherStarsFogEnabled = _G.WeatherStarsFogEnabled or false
_G.WeatherWhiteFogEnabled = _G.WeatherWhiteFogEnabled or false
_G.UltraGraphicsEnabled = _G.UltraGraphicsEnabled or false
_G.HideNamesEnabled = _G.HideNamesEnabled or false

_G.ESPNameColor = Color3.fromRGB(50, 180, 255)

-- Исходные настройки освещения
local defaultLighting = {
    ClockTime = Lighting.ClockTime,
    Brightness = Lighting.Brightness,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Ambient = Lighting.Ambient,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart,
    FogColor = Lighting.FogColor,
    GlobalShadows = Lighting.GlobalShadows
}

-- ПЕРЕМЕННЫЕ ДЖЕТПАКА
local isFlyingUp = false
local isFlyingDown = false
local targetVerticalSpeed = 0
local currentVerticalSpeed = 0
local MAX_UP_SPEED = 28
local MAX_DOWN_SPEED = -22
local SLOW_DRIFT_SPEED = -1.2
local ACCEL_SPEED = 0.025
local DECEL_SPEED = 0.018
local HORIZ_SMOOTH = 0.045
local smoothVelocity = Vector3.zero
local FLY_SPEED = 24

local bodyVelocity = nil
local fireSound = nil
local windSound = nil
local idleSound = nil
local fireParticles = {}

local function isThirdPerson()
    local camera = Workspace.CurrentCamera
    if not camera then return false end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Head") then
        local dist = (camera.CFrame.Position - char.Head.Position).Magnitude
        return dist > 1.5
    end
    return false
end

local function setupCharacterJetpack(char)
    if not char then return end
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not torso or not humanoid then return end

    if torso:FindFirstChild("JetpackVelocity") then torso.JetpackVelocity:Destroy() end
    if torso:FindFirstChild("JetpackCoreAttachment") then torso.JetpackCoreAttachment:Destroy() end

    fireParticles = {}

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "JetpackVelocity"
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = torso

    fireSound = Instance.new("Sound")
    fireSound.Name = "JetpackFireSound"
    fireSound.SoundId = "rbxassetid://5199136449"
    fireSound.Volume = 0.85
    fireSound.Looped = true
    fireSound.Parent = torso

    windSound = Instance.new("Sound")
    windSound.Name = "JetpackWindSound"
    windSound.SoundId = "rbxassetid://15675021174"
    windSound.Volume = 0.85
    windSound.Looped = true
    windSound.Parent = torso

    idleSound = Instance.new("Sound")
    idleSound.Name = "JetpackIdleSound"
    idleSound.SoundId = "rbxassetid://136678911797673"
    idleSound.Volume = 0.8
    idleSound.Looped = true
    idleSound.Parent = torso

    local coreAttach = Instance.new("Attachment")
    coreAttach.Name = "JetpackCoreAttachment"
    coreAttach.Parent = torso

    local storage = LocalPlayer.PlayerGui

    local tankPrimaryColor = Color3.fromRGB(45, 115, 185)
    local tankAccentColor = Color3.fromRGB(80, 160, 225)
    local darkMetalColor = Color3.fromRGB(25, 25, 28)
    local chromeColor = Color3.fromRGB(180, 185, 190)
    local wireColor = Color3.fromRGB(220, 50, 50)
    local whiteColor = Color3.fromRGB(240, 240, 240)

    local function createCylinder(name, radius, height, color, pos, rotation)
        local p = Instance.new("CylinderHandleAdornment")
        p.Name = name
        p.Radius = radius
        p.Height = height
        p.Color3 = color
        p.Adornee = torso
        p.CFrame = CFrame.new(pos) * (rotation or CFrame.Angles(0,0,0))
        p.Parent = storage
        return p
    end
    
    local function createSphere(name, radius, color, pos)
        local p = Instance.new("SphereHandleAdornment")
        p.Name = name
        p.Radius = radius
        p.Color3 = color
        p.Adornee = torso
        p.CFrame = CFrame.new(pos)
        p.Parent = storage
        return p
    end

    local function createTankAndFire(offset, index)
        createCylinder("TankBody_"..index, 0.32, 1.5, tankPrimaryColor, Vector3.new(offset, 0.1, 0.62), CFrame.Angles(math.rad(90), 0, 0))
        createSphere("TankCap_"..index, 0.32, tankPrimaryColor, Vector3.new(offset, 0.85, 0.62))
        createCylinder("TankStripe_"..index, 0.33, 0.4, tankAccentColor, Vector3.new(offset, 0.25, 0.62), CFrame.Angles(math.rad(90), 0, 0))
        createCylinder("ClampTop_"..index, 0.34, 0.08, chromeColor, Vector3.new(offset, 0.6, 0.62), CFrame.Angles(math.rad(90), 0, 0))
        createCylinder("ClampBottom_"..index, 0.34, 0.08, chromeColor, Vector3.new(offset, -0.4, 0.62), CFrame.Angles(math.rad(90), 0, 0))
        createCylinder("Nozzle_"..index, 0.22, 0.3, chromeColor, Vector3.new(offset, -0.75, 0.62), CFrame.Angles(math.rad(90), 0, 0))
        createCylinder("NozzleInner_"..index, 0.15, 0.32, darkMetalColor, Vector3.new(offset, -0.76, 0.62), CFrame.Angles(math.rad(90), 0, 0))
        createCylinder("WireMain_"..index, 0.04, 0.35, wireColor, Vector3.new(offset * 0.6, 0.4, 0.58), CFrame.Angles(0, 0, math.rad(90)))
        createCylinder("WireLoop_"..index, 0.03, 0.35, darkMetalColor, Vector3.new(offset * 0.7, -0.1, 0.58), CFrame.Angles(math.rad(45), 0, 0))

        local firePart = Instance.new("Part")
        firePart.Name = "FireEmitter_"..index
        firePart.Transparency = 1
        firePart.Size = Vector3.new(0.2, 0.2, 0.2)
        firePart.CanCollide = false
        firePart.Parent = torso

        local weld = Instance.new("Weld")
        weld.Part0 = torso
        weld.Part1 = firePart
        weld.C0 = CFrame.new(offset, -0.88, 0.62) * CFrame.Angles(math.rad(180), 0, 0)
        weld.Parent = firePart

        local fire = Instance.new("Fire")
        fire.Name = "JetFire_"..index
        fire.Size = 1.8
        fire.Heat = 6
        fire.Enabled = true
        fire.Parent = firePart

        table.insert(fireParticles, fire)
    end

    createTankAndFire(-0.42, 1)
    createTankAndFire(0.42, 2)
    createCylinder("BridgeTop", 0.06, 0.84, whiteColor, Vector3.new(0, 0.45, 0.62), CFrame.Angles(0, math.rad(90), 0))
    createCylinder("BridgeBottom", 0.06, 0.84, whiteColor, Vector3.new(0, -0.05, 0.62), CFrame.Angles(0, math.rad(90), 0))
end

local function removeJetpack(char)
    if not char then return end
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if torso then
        if torso:FindFirstChild("JetpackVelocity") then torso.JetpackVelocity:Destroy() end
        if torso:FindFirstChild("JetpackCoreAttachment") then torso.JetpackCoreAttachment:Destroy() end
        if torso:FindFirstChild("JetpackFireSound") then torso.JetpackFireSound:Destroy() end
        if torso:FindFirstChild("JetpackWindSound") then torso.JetpackWindSound:Destroy() end
        if torso:FindFirstChild("JetpackIdleSound") then torso.JetpackIdleSound:Destroy() end
    end
    for _, guiObj in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
        if guiObj.Name == "JetpackControls" or guiObj:IsA("CylinderHandleAdornment") or guiObj:IsA("SphereHandleAdornment") then
            if guiObj.Name == "JetpackControls" or (guiObj.Adornee and guiObj.Adornee.Parent == char) then
                guiObj:Destroy()
            end
        end
    end
end

local function updateJetpackPose(char, isAirborn)
    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not torso or not humanoid then return end

    local animateScript = char:FindFirstChild("Animate")
    local lSh = torso:FindFirstChild("Left Shoulder") or torso:FindFirstChild("LeftShoulder")
    local rSh = torso:FindFirstChild("Right Shoulder") or torso:FindFirstChild("RightShoulder")
    local lHip = torso:FindFirstChild("Left Hip") or torso:FindFirstChild("LeftHip")
    local rHip = torso:FindFirstChild("Right Hip") or torso:FindFirstChild("RightHip")

    if lSh and rSh then
        lSh.C0 = CFrame.new(-1, -0.5, 0) * CFrame.Angles(0, math.rad(-90), 0)
        rSh.C0 = CFrame.new(1, -0.5, 0) * CFrame.Angles(0, math.rad(90), 0)
    end

    local relMove = Vector3.zero
    if humanoid.MoveDirection.Magnitude > 0.05 then
        relMove = torso.CFrame:VectorToObjectSpace(humanoid.MoveDirection)
    end

    local localZ = relMove.Z
    local localX = relMove.X 
    local t = tick() * 5.5
    local legSwayLeft = math.sin(t) * 5
    local legSwayRight = math.cos(t * 0.9) * 5

    if lHip and rHip then
        if isAirborn then
            if animateScript then animateScript.Disabled = true end
            if localZ > 0.15 then
                local kneeKink = math.rad(35 + legSwayLeft)
                local kneeKinkR = math.rad(35 + legSwayRight)
                lHip.C0 = CFrame.new(-0.5, -0.85, -0.1) * CFrame.Angles(kneeKink, math.rad(-4), math.rad(-3))
                rHip.C0 = CFrame.new(0.5, -0.85, -0.1) * CFrame.Angles(kneeKinkR, math.rad(4), math.rad(3))
            elseif localZ < -0.15 then
                local kneeKink = math.rad(35 + legSwayLeft)
                local kneeKinkR = math.rad(35 + legSwayRight)
                lHip.C0 = CFrame.new(-0.5, -0.85, 0.1) * CFrame.Angles(kneeKink, math.rad(-4), math.rad(-3))
                rHip.C0 = CFrame.new(0.5, -0.85, 0.1) * CFrame.Angles(kneeKinkR, math.rad(4), math.rad(3))
            elseif math.abs(localX) > 0.15 then
                local sideTilt = math.rad(localX * 18)
                lHip.C0 = CFrame.new(-0.5, -0.9, 0) * CFrame.Angles(math.rad(15 + legSwayLeft), 0, sideTilt)
                rHip.C0 = CFrame.new(0.5, -0.9, 0) * CFrame.Angles(math.rad(15 + legSwayRight), 0, sideTilt)
            else
                local idleKnee = math.rad(18 + legSwayLeft)
                local idleKneeR = math.rad(18 + legSwayRight)
                lHip.C0 = CFrame.new(-0.5, -0.95, -0.02) * CFrame.Angles(idleKnee, math.rad(-3), math.rad(-2))
                rHip.C0 = CFrame.new(0.5, -0.95, -0.02) * CFrame.Angles(idleKneeR, math.rad(3), math.rad(2))
            end
        else
            if animateScript then animateScript.Disabled = false end
            lHip.C0 = CFrame.new(-0.5, -1, 0) * CFrame.Angles(0, math.rad(-90), 0)
            rHip.C0 = CFrame.new(0.5, -1, 0) * CFrame.Angles(0, math.rad(90), 0)
        end
    end

    if isAirborn and isThirdPerson() and localZ > 0.1 then
        humanoid.AutoRotate = false
        local camera = Workspace.CurrentCamera
        if camera then
            local camLook = camera.CFrame.LookVector
            local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
            if flatLook.Magnitude > 0.1 then
                torso.CFrame = CFrame.lookAt(torso.Position, torso.Position + flatLook)
            end
        end
    else
        humanoid.AutoRotate = true
    end
end

local function createJetpackUI()
    local playerGui = LocalPlayer.PlayerGui
    if playerGui:FindFirstChild("JetpackControls") then return end

    local sg = Instance.new("ScreenGui")
    sg.Name = "JetpackControls"
    sg.ResetOnSpawn = false
    sg.Parent = playerGui

    local btnUp = Instance.new("TextButton")
    btnUp.Name = "BtnUp"
    btnUp.Size = UDim2.new(0, 48, 0, 48)
    btnUp.Position = UDim2.new(1, -115, 0.45, 0)
    btnUp.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btnUp.Text = "▲\nВВЕРХ"
    btnUp.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnUp.TextSize = 9
    btnUp.Parent = sg
    Instance.new("UICorner", btnUp).CornerRadius = UDim.new(0, 10)

    local btnDown = Instance.new("TextButton")
    btnDown.Name = "BtnDown"
    btnDown.Size = UDim2.new(0, 48, 0, 48)
    btnDown.Position = UDim2.new(1, -60, 0.45, 0)
    btnDown.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
    btnDown.Text = "▼\nВНИЗ"
    btnDown.TextColor3 = Color3.fromRGB(255, 255, 255)
    btnDown.TextSize = 9
    btnDown.Parent = sg
    Instance.new("UICorner", btnDown).CornerRadius = UDim.new(0, 10)

    btnUp.MouseButton1Down:Connect(function() isFlyingUp = true end)
    btnUp.MouseButton1Up:Connect(function() isFlyingUp = false end)
    btnDown.MouseButton1Down:Connect(function() isFlyingDown = true end)
    btnDown.MouseButton1Up:Connect(function() isFlyingDown = false end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not _G.JetpackEnabled then return end
    if input.KeyCode == Enum.KeyCode.E then isFlyingUp = true end
    if input.KeyCode == Enum.KeyCode.LeftShift then isFlyingDown = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if not _G.JetpackEnabled then return end
    if input.KeyCode == Enum.KeyCode.E then isFlyingUp = false end
    if input.KeyCode == Enum.KeyCode.LeftShift then isFlyingDown = false end
end)

local flyingUpSpace = false
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Space then flyingUpSpace = true end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then flyingUpSpace = false end
end)

local function applyAntiGravity(character)
    if not character then return end
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if hrp and humanoid then
        local bodyForce = hrp:FindFirstChild("AntiGravityForce") or Instance.new("BodyForce")
        bodyForce.Name = "AntiGravityForce"
        local totalMass = 0
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then totalMass = totalMass + part:GetMass() end
        end
        if _G.GravityEnabled then
            bodyForce.Force = Vector3.new(0, totalMass * workspace.Gravity, 0)
        else
            bodyForce.Force = Vector3.new(0, 0, 0)
        end
        bodyForce.Parent = hrp
    end
end

local function update3DESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local existingHighlight = char:FindFirstChild("Custom3DHighlight")
            if _G.ESP3DEnabled then
                if not existingHighlight then
                    local hl = Instance.new("Highlight")
                    hl.Name = "Custom3DHighlight"
                    hl.Adornee = char
                    hl.FillColor = _G.ESPNameColor
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.Parent = char
                    hl.Enabled = true
                else
                    existingHighlight.FillColor = _G.ESPNameColor
                    existingHighlight.Enabled = true
                end
            else
                if existingHighlight then existingHighlight.Enabled = false end
            end
        end
    end
end

local function updateNameESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local existingGui = head:FindFirstChild("CustomNameESP")
                if _G.ESPNamesEnabled then
                    if not existingGui then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "CustomNameESP"
                        bb.Adornee = head
                        bb.Size = UDim2.new(0, 200, 0, 40)
                        bb.StudsOffset = Vector3.new(0, 2.5, 0)
                        bb.AlwaysOnTop = true

                        local lbl = Instance.new("TextLabel", bb)
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = player.DisplayName .. " (@" .. player.Name .. ")"
                        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                        lbl.TextStrokeTransparency = 0
                        lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 13
                        lbl.TextYAlignment = Enum.TextYAlignment.Center
                        bb.Parent = head
                    end
                else
                    if existingGui then existingGui:Destroy() end
                end
            end
        end
    end
end

local originalHumanoidStates = {}
local namesWereHidden = false
local function updateHideNames()
    if _G.HideNamesEnabled then
        if not namesWereHidden then
            namesWereHidden = true
            originalHumanoidStates = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        originalHumanoidStates[humanoid] = {
                            Display = humanoid.DisplayDistanceType,
                            Health = humanoid.HealthDisplayType,
                            NameDist = humanoid.NameDisplayDistance,
                            HealthDist = humanoid.HealthDisplayDistance
                        }
                        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                        humanoid.NameDisplayDistance = 0
                        humanoid.HealthDisplayDistance = 0
                    end
                end
            end
        end
    else
        if namesWereHidden then
            namesWereHidden = false
            for humanoid, state in pairs(originalHumanoidStates) do
                if humanoid and humanoid.Parent then
                    humanoid.DisplayDistanceType = state.Display
                    humanoid.HealthDisplayType = state.Health
                    humanoid.NameDisplayDistance = state.NameDist
                    humanoid.HealthDisplayDistance = state.HealthDist
                end
            end
            table.clear(originalHumanoidStates)
        end
    end
end

local function cleanupStorm()
    if Workspace:FindFirstChild("RainSystemPart") then Workspace.RainSystemPart:Destroy() end
    if _G.RainLoop then _G.RainLoop:Disconnect(); _G.RainLoop = nil end
    if _G.LightningLoop then task.cancel(_G.LightningLoop); _G.LightningLoop = nil end
end

local function applyHyperRealism()
    Lighting.GlobalShadows = true
    Lighting.Brightness = 3.2
    Lighting.Ambient = Color3.fromRGB(135, 145, 155)
    Lighting.OutdoorAmbient = Color3.fromRGB(140, 155, 170)
end

local function applyWhiteFog()
    Lighting.FogStart = 0
    Lighting.FogEnd = 200
    Lighting.FogColor = Color3.fromRGB(240, 245, 250)
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere") or Instance.new("Atmosphere", Lighting)
    atmosphere.Name = "CustomFogAtmosphere"
    atmosphere.Density = 0.75
    atmosphere.Offset = 0.6
    atmosphere.Color = Color3.fromRGB(240, 245, 250)
    atmosphere.Decay = Color3.fromRGB(220, 225, 230)
end

local function resetLighting()
    cleanupStorm()
    if Lighting:FindFirstChild("CustomFogAtmosphere") then
        Lighting.CustomFogAtmosphere:Destroy()
    end
    Lighting.ClockTime = defaultLighting.ClockTime
    Lighting.Brightness = defaultLighting.Brightness
    Lighting.OutdoorAmbient = defaultLighting.OutdoorAmbient
    Lighting.Ambient = defaultLighting.Ambient
    Lighting.FogEnd = defaultLighting.FogEnd
    Lighting.FogStart = defaultLighting.FogStart
    Lighting.FogColor = defaultLighting.FogColor
    Lighting.GlobalShadows = defaultLighting.GlobalShadows
end

local function updateWeather()
    resetLighting()

    if _G.WeatherWhiteFogEnabled then
        applyWhiteFog()
    elseif _G.UltraGraphicsEnabled then
        applyHyperRealism()
    elseif _G.WeatherNightEnabled then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0.2
        Lighting.OutdoorAmbient = Color3.fromRGB(20, 20, 35)
        Lighting.Ambient = Color3.fromRGB(15, 15, 25)
    elseif _G.WeatherSunsetEnabled then
        Lighting.ClockTime = 17.8
        Lighting.Brightness = 1.8
        Lighting.OutdoorAmbient = Color3.fromRGB(200, 100, 50)
        Lighting.Ambient = Color3.fromRGB(120, 60, 40)
    elseif _G.WeatherStormEnabled then
        Lighting.ClockTime = 14
        Lighting.Brightness = 0.3
        Lighting.OutdoorAmbient = Color3.fromRGB(35, 40, 50)
        Lighting.Ambient = Color3.fromRGB(25, 30, 40)
        Lighting.FogStart = 0
        Lighting.FogEnd = 300
        Lighting.FogColor = Color3.fromRGB(40, 45, 55)
    elseif _G.WeatherStarsFogEnabled then
        Lighting.ClockTime = 0
        Lighting.Brightness = 0
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.FogStart = 0
        Lighting.FogEnd = 150
        Lighting.FogColor = Color3.fromRGB(5, 5, 10)
    end
end

RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        if _G.SuperRunEnabled then humanoid.WalkSpeed = 65
        elseif _G.SpeedHackEnabled then humanoid.WalkSpeed = 150 end

        if _G.HighJumpEnabled then
            humanoid.UseJumpPower = false
            humanoid.JumpHeight = _G.JumpHeightValue
        end
    end

    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = not _G.NoClipEnabled end
        end
    end

    if _G.FastTurnEnabled and rootPart and humanoid and Camera then
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0.01 then
            local targetAngle = math.atan2(-moveDir.X, -moveDir.Z)
            rootPart.CFrame = CFrame.new(rootPart.Position) * CFrame.Angles(0, targetAngle, 0)
        end
    end
    
    if _G.GravityEnabled and rootPart then
        local bodyForce = rootPart:FindFirstChild("AntiGravityForce")
        if bodyForce then
            local totalMass = 0
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then totalMass = totalMass + part:GetMass() end
            end
            local upForce = flyingUpSpace and (totalMass * workspace.Gravity * 1.5) or 0
            bodyForce.Force = Vector3.new(0, (totalMass * workspace.Gravity) + upForce, 0)
        end
    end

    if _G.JetpackEnabled and character then
        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if torso and not torso:FindFirstChild("JetpackCoreAttachment") then
            setupCharacterJetpack(character)
            createJetpackUI()
        end

        if bodyVelocity and bodyVelocity.Parent and humanoid then
            local isInAir = (humanoid.FloorMaterial == Enum.Material.Air)

            if not isInAir and not isFlyingUp then
                bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                currentVerticalSpeed = 0
                smoothVelocity = Vector3.zero
                updateJetpackPose(character, false)

                if fireSound and fireSound.IsPlaying then fireSound:Stop() end
                if windSound and windSound.IsPlaying then windSound:Stop() end
                if idleSound and not idleSound.IsPlaying then idleSound:Play() end
            else
                updateJetpackPose(character, true)

                if isFlyingUp then targetVerticalSpeed = MAX_UP_SPEED
                elseif isFlyingDown then targetVerticalSpeed = MAX_DOWN_SPEED
                else targetVerticalSpeed = SLOW_DRIFT_SPEED end

                local lerpRate = (isFlyingUp or isFlyingDown) and ACCEL_SPEED or DECEL_SPEED
                currentVerticalSpeed = currentVerticalSpeed + (targetVerticalSpeed - currentVerticalSpeed) * lerpRate
                
                local targetHoriz = humanoid.MoveDirection * FLY_SPEED
                smoothVelocity = smoothVelocity:Lerp(targetHoriz, HORIZ_SMOOTH)

                bodyVelocity.MaxForce = Vector3.new(450000, 450000, 450000)
                bodyVelocity.Velocity = Vector3.new(smoothVelocity.X, currentVerticalSpeed, smoothVelocity.Z)

                if isFlyingUp then
                    if fireSound and not fireSound.IsPlaying then fireSound:Play() end
                    if windSound and windSound.IsPlaying then windSound:Stop() end
                    if idleSound and idleSound.IsPlaying then idleSound:Stop() end
                else
                    if fireSound and fireSound.IsPlaying then fireSound:Stop() end
                    if windSound and not windSound.IsPlaying then windSound:Play() end
                    if idleSound and not idleSound.IsPlaying then idleSound:Play() end
                end
            end
        end
    end

    update3DESP()
    updateNameESP()
    updateHideNames()
end)

--[===================================================================]--
--  ИНТЕРФЕЙС И ВКЛАДКИ
--[===================================================================]--

local fovTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local function updateFOV()
    local activeCam = workspace.CurrentCamera or Camera
    if activeCam then
        local targetFOV = DefaultFOV
        if _G.FOV3Enabled then targetFOV = 120
        elseif _G.FOV2Enabled then targetFOV = 105
        elseif _G.FOVEnabled then targetFOV = 90 end
        TweenService:Create(activeCam, fovTweenInfo, {FieldOfView = targetFOV}):Play()
    end
end

local ContentHolder = Instance.new("Frame", MainFrame)
ContentHolder.Size = UDim2.new(1, -20, 1, -52)
ContentHolder.Position = UDim2.new(0, 10, 0, 54)
ContentHolder.BackgroundTransparency = 1

local LeftContainer = Instance.new("Frame", ContentHolder)
LeftContainer.Size = UDim2.new(0, 122, 0, 226)
LeftContainer.Position = UDim2.new(0, 0, 0, 0)
LeftContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
LeftContainer.BackgroundTransparency = 0.15
Instance.new("UICorner", LeftContainer).CornerRadius = UDim.new(0, 8)

local RightPanel = Instance.new("Frame", ContentHolder)
RightPanel.Size = UDim2.new(1, -132, 0, 226)
RightPanel.Position = UDim2.new(0, 132, 0, 0)
RightPanel.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
RightPanel.BackgroundTransparency = 0.15
Instance.new("UICorner", RightPanel).CornerRadius = UDim.new(0, 8)

local ScrollingFrame = Instance.new("ScrollingFrame", RightPanel)
ScrollingFrame.Size = UDim2.new(1, -6, 1, -10)
ScrollingFrame.Position = UDim2.new(0, 3, 0, 5)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 650)
ScrollingFrame.ScrollBarThickness = 3.5
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(240, 240, 240)

local loadPersonageTab
local loadVisualTab
local activeToggleButtons = {}

local function updateAllToggleStates()
    for varName, btnData in pairs(activeToggleButtons) do
        if btnData and btnData.Button and btnData.Button.Parent then
            local state = _G[varName]
            local targetBg = state and Color3.fromRGB(18, 35, 22) or Color3.fromRGB(22, 22, 28)
            local targetStroke = state and Color3.fromRGB(55, 125, 72) or Color3.fromRGB(45, 45, 55)
            local targetDotColor = state and Color3.fromRGB(75, 195, 95) or Color3.fromRGB(40, 45, 55)
            local targetText = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210)

            TweenService:Create(btnData.Button, TweenInfo.new(0.2), {BackgroundColor3 = targetBg}):Play()
            TweenService:Create(btnData.Stroke, TweenInfo.new(0.2), {Color = targetStroke}):Play()
            TweenService:Create(btnData.InnerDot, TweenInfo.new(0.2), {BackgroundColor3 = targetDotColor}):Play()
            TweenService:Create(btnData.Label, TweenInfo.new(0.2), {TextColor3 = targetText}):Play()
        end
    end
end

local function createToggleUniversal(parent, name, pos, enabledVar, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 192, 0, 38)
    btn.Position = pos
    btn.BackgroundColor3 = _G[enabledVar] and Color3.fromRGB(18, 35, 22) or Color3.fromRGB(22, 22, 28)
    btn.BackgroundTransparency = 0.15
    btn.Text = ""
    btn.ClipsDescendants = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = _G[enabledVar] and Color3.fromRGB(55, 125, 72) or Color3.fromRGB(45, 45, 55)
    btnStroke.Thickness = 1.1

    local outerCircle = Instance.new("Frame", btn)
    outerCircle.Size = UDim2.new(0, 16, 0, 16)
    outerCircle.Position = UDim2.new(0, 12, 0.5, 0)
    outerCircle.AnchorPoint = Vector2.new(0, 0.5)
    outerCircle.BackgroundTransparency = 1
    
    local circleStroke = Instance.new("UIStroke", outerCircle)
    circleStroke.Color = Color3.fromRGB(80, 85, 95)
    circleStroke.Thickness = 1.2
    Instance.new("UICorner", outerCircle).CornerRadius = UDim.new(1, 0)

    local innerDot = Instance.new("Frame", outerCircle)
    innerDot.Size = UDim2.new(0, 8, 0, 8)
    innerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    innerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    innerDot.BackgroundColor3 = _G[enabledVar] and Color3.fromRGB(75, 195, 95) or Color3.fromRGB(40, 45, 55)
    Instance.new("UICorner", innerDot).CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -38, 1, 0)
    label.Position = UDim2.new(0, 36, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = _G[enabledVar] and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    activeToggleButtons[enabledVar] = {
        Button = btn,
        Stroke = btnStroke,
        InnerDot = innerDot,
        Label = label
    }

    btn.MouseButton1Click:Connect(function()
        playClickAnimation(btn)
        _G[enabledVar] = not _G[enabledVar]
        local newState = _G[enabledVar]
        if callback then callback(newState) end
        updateAllToggleStates()
    end)
end

local function createActionButton(parent, name, pos, actionCallback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 192, 0, 38)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    btn.BackgroundTransparency = 0.15
    btn.Text = ""
    btn.ClipsDescendants = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 1.1

    local outerCircle = Instance.new("Frame", btn)
    outerCircle.Size = UDim2.new(0, 16, 0, 16)
    outerCircle.Position = UDim2.new(0, 12, 0.5, 0)
    outerCircle.AnchorPoint = Vector2.new(0, 0.5)
    outerCircle.BackgroundTransparency = 1
    Instance.new("UICorner", outerCircle).CornerRadius = UDim.new(1, 0)

    local circleStroke = Instance.new("UIStroke", outerCircle)
    circleStroke.Color = Color3.fromRGB(80, 85, 95)
    circleStroke.Thickness = 1.2

    local innerDot = Instance.new("Frame", outerCircle)
    innerDot.Size = UDim2.new(0, 8, 0, 8)
    innerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    innerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    innerDot.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
    Instance.new("UICorner", innerDot).CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel", btn)
    label.Size = UDim2.new(1, -38, 1, 0)
    label.Position = UDim2.new(0, 36, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.fromRGB(200, 200, 210)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left

    local isActive = false
    btn.MouseButton1Click:Connect(function()
        if actionCallback then actionCallback() end
        if isActive then return end
        isActive = true
        playClickAnimation(btn)

        btn.BackgroundColor3 = Color3.fromRGB(18, 35, 22)
        stroke.Color = Color3.fromRGB(55, 125, 72)
        innerDot.BackgroundColor3 = Color3.fromRGB(75, 195, 95)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)

        task.delay(0.5, function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 28)}):Play()
            TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(45, 45, 55)}):Play()
            TweenService:Create(innerDot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 45, 55)}):Play()
            TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 210)}):Play()
            task.wait(0.2)
            isActive = false
        end)
    end)
end

loadPersonageTab = function()
    table.clear(activeToggleButtons)
    for _, child in ipairs(ScrollingFrame:GetChildren()) do child:Destroy() end

    local LeftX = 6
    local RightX = 204
    local row1Y = 4
    local row2Y = row1Y + 44
    local row3Y = row2Y + 44
    local row4Y = row3Y + 44
    local row5Y = row4Y + 44
    local row6Y = row5Y + 44

    createToggleUniversal(ScrollingFrame, "SpeedHack", UDim2.new(0, LeftX, 0, row1Y), "SpeedHackEnabled", function(en)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = en and 150 or 16 end
    end)

    createToggleUniversal(ScrollingFrame, "Высокий прыжок", UDim2.new(0, RightX, 0, row1Y), "HighJumpEnabled", function(en)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower = false; h.JumpHeight = en and _G.JumpHeightValue or 7.2 end
    end)

    createToggleUniversal(ScrollingFrame, "Выдать Jetpack", UDim2.new(0, LeftX, 0, row2Y), "JetpackEnabled", function(en)
        if en then
            setupCharacterJetpack(LocalPlayer.Character)
            createJetpackUI()
        else
            removeJetpack(LocalPlayer.Character)
        end
    end)

    createToggleUniversal(ScrollingFrame, "Быстрый бег", UDim2.new(0, RightX, 0, row2Y), "SuperRunEnabled", function(en)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = en and 65 or (_G.SpeedHackEnabled and 150 or 16) end
    end)

    createToggleUniversal(ScrollingFrame, "Гравитация", UDim2.new(0, LeftX, 0, row3Y), "GravityEnabled", function(en)
        if en then applyAntiGravity(LocalPlayer.Character)
        else
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local force = hrp and hrp:FindFirstChild("AntiGravityForce")
            if force then force:Destroy() end
        end
    end)
    
    createToggleUniversal(ScrollingFrame, "Быстрый поворот", UDim2.new(0, RightX, 0, row3Y), "FastTurnEnabled")
    createToggleUniversal(ScrollingFrame, "NoClip", UDim2.new(0, LeftX, 0, row4Y), "NoClipEnabled")
    createToggleUniversal(ScrollingFrame, "Fake AFK", UDim2.new(0, RightX, 0, row4Y), "FakeAFKEnabled")
    
    createActionButton(ScrollingFrame, "Суицид", UDim2.new(0, LeftX, 0, row5Y), function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.Health = 0 end
        end
    end)

    createActionButton(ScrollingFrame, "Slap вверх", UDim2.new(0, RightX, 0, row5Y), function()
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 0.25, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 160, hrp.AssemblyLinearVelocity.Z)
        end
    end)

    createActionButton(ScrollingFrame, "Slap вниз", UDim2.new(0, LeftX, 0, row6Y), function()
        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, -180, hrp.AssemblyLinearVelocity.Z)
        end
    end)
    
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, row6Y + 48)
end

loadVisualTab = function()
    table.clear(activeToggleButtons)
    for _, child in ipairs(ScrollingFrame:GetChildren()) do child:Destroy() end

    local camTitle = Instance.new("TextLabel", ScrollingFrame)
    camTitle.Size = UDim2.new(1, 0, 0, 18)
    camTitle.Position = UDim2.new(0, 6, 0, 4)
    camTitle.BackgroundTransparency = 1
    camTitle.Text = "КАМЕРА И FOV"
    camTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
    camTitle.Font = Enum.Font.GothamBold
    camTitle.TextSize = 11
    camTitle.TextXAlignment = Enum.TextXAlignment.Left

    createToggleUniversal(ScrollingFrame, "FOV 1", UDim2.new(0, 6, 0, 26), "FOVEnabled", function(en)
        if en then _G.FOV2Enabled = false; _G.FOV3Enabled = false end
        updateFOV()
    end)

    createToggleUniversal(ScrollingFrame, "FOV 2", UDim2.new(0, 204, 0, 26), "FOV2Enabled", function(en)
        if en then _G.FOVEnabled = false; _G.FOV3Enabled = false end
        updateFOV()
    end)

    createToggleUniversal(ScrollingFrame, "FOV 3", UDim2.new(0, 6, 0, 74), "FOV3Enabled", function(en)
        if en then _G.FOVEnabled = false; _G.FOV2Enabled = false end
        updateFOV()
    end)

    local weatherTitle = Instance.new("TextLabel", ScrollingFrame)
    weatherTitle.Size = UDim2.new(1, 0, 0, 18)
    weatherTitle.Position = UDim2.new(0, 6, 0, 126)
    weatherTitle.BackgroundTransparency = 1
    weatherTitle.Text = "АТМОСФЕРА И ОКРУЖЕНИЕ"
    weatherTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
    weatherTitle.Font = Enum.Font.GothamBold
    weatherTitle.TextSize = 11
    weatherTitle.TextXAlignment = Enum.TextXAlignment.Left

    createToggleUniversal(ScrollingFrame, "Ночь", UDim2.new(0, 6, 0, 148), "WeatherNightEnabled", function(en)
        if en then
            _G.WeatherSunsetEnabled = false; _G.WeatherStormEnabled = false
            _G.WeatherStarsFogEnabled = false; _G.WeatherWhiteFogEnabled = false; _G.UltraGraphicsEnabled = false
        end
        updateWeather()
    end)

    createToggleUniversal(ScrollingFrame, "Закат", UDim2.new(0, 204, 0, 148), "WeatherSunsetEnabled", function(en)
        if en then
            _G.WeatherNightEnabled = false; _G.WeatherStormEnabled = false
            _G.WeatherStarsFogEnabled = false; _G.WeatherWhiteFogEnabled = false; _G.UltraGraphicsEnabled = false
        end
        updateWeather()
    end)

    createToggleUniversal(ScrollingFrame, "Тёмная гроза", UDim2.new(0, 6, 0, 196), "WeatherStormEnabled", function(en)
        if en then
            _G.WeatherNightEnabled = false; _G.WeatherSunsetEnabled = false
            _G.WeatherStarsFogEnabled = false; _G.WeatherWhiteFogEnabled = false; _G.UltraGraphicsEnabled = false
        end
        updateWeather()
    end)

    createToggleUniversal(ScrollingFrame, "Чёрное небо", UDim2.new(0, 204, 0, 196), "WeatherStarsFogEnabled", function(en)
        if en then
            _G.WeatherNightEnabled = false; _G.WeatherSunsetEnabled = false
            _G.WeatherStormEnabled = false; _G.WeatherWhiteFogEnabled = false; _G.UltraGraphicsEnabled = false
        end
        updateWeather()
    end)

    createToggleUniversal(ScrollingFrame, "Ультра графика", UDim2.new(0, 6, 0, 244), "UltraGraphicsEnabled", function(en)
        if en then
            _G.WeatherNightEnabled = false; _G.WeatherSunsetEnabled = false
            _G.WeatherStormEnabled = false; _G.WeatherStarsFogEnabled = false; _G.WeatherWhiteFogEnabled = false
        end
        updateWeather()
    end)

    createToggleUniversal(ScrollingFrame, "Туман", UDim2.new(0, 204, 0, 244), "WeatherWhiteFogEnabled", function(en)
        if en then
            _G.WeatherNightEnabled = false; _G.WeatherSunsetEnabled = false
            _G.WeatherStormEnabled = false; _G.WeatherStarsFogEnabled = false; _G.UltraGraphicsEnabled = false
        end
        updateWeather()
    end)

    local espTitle = Instance.new("TextLabel", ScrollingFrame)
    espTitle.Size = UDim2.new(1, 0, 0, 18)
    espTitle.Position = UDim2.new(0, 6, 0, 292)
    espTitle.BackgroundTransparency = 1
    espTitle.Text = "ПОДСВЕТКА И ESP"
    espTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextSize = 11
    espTitle.TextXAlignment = Enum.TextXAlignment.Left

    createToggleUniversal(ScrollingFrame, "ESP игроки", UDim2.new(0, 6, 0, 314), "ESP3DEnabled")
    createToggleUniversal(ScrollingFrame, "ESP ники", UDim2.new(0, 204, 0, 314), "ESPNamesEnabled")
    createToggleUniversal(ScrollingFrame, "Скрыть ники", UDim2.new(0, 6, 0, 362), "HideNamesEnabled", function(en)
        _G.HideNamesEnabled = en
    end)
    
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 420)
end

local tabs = {"Персонаж", "Визуал"}
local currentActive = nil
local tabObjects = {}

for i, name in pairs(tabs) do
    local tabContainer = Instance.new("Frame", LeftContainer)
    tabContainer.Size = UDim2.new(0, 102, 0, 35)
    tabContainer.Position = UDim2.new(0, 10, 0, 6 + (i - 1) * 43)
    tabContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    tabContainer.BackgroundTransparency = 0.15
    Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(0, 8)
    
    local stroke = Instance.new("UIStroke", tabContainer)
    stroke.Thickness = 0.8
    stroke.Color = Color3.fromRGB(45, 45, 55)
    
    local tabBtn = Instance.new("TextButton", tabContainer)
    tabBtn.Size = UDim2.new(1, 0, 1, 0)
    tabBtn.BackgroundTransparency = 1
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 13
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
    
    local dot = Instance.new("Frame", tabContainer)
    dot.Size = UDim2.new(0, 5, 0, 5)
    dot.Position = UDim2.new(1, -12, 0.5, 0)
    dot.AnchorPoint = Vector2.new(0, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(75, 195, 95)
    dot.Visible = false
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local tabData = {
        Container = tabContainer,
        Style = stroke,
        Button = tabBtn,
        Dot = dot,
        Name = name
    }
    table.insert(tabObjects, tabData)

    local function activateTab()
        playClickAnimation(tabBtn)
        if currentActive == tabData then return end

        for _, tObj in ipairs(tabObjects) do
            tObj.Container.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
            tObj.Style.Color = Color3.fromRGB(45, 45, 55)
            tObj.Button.TextColor3 = Color3.fromRGB(180, 180, 190)
            tObj.Dot.Visible = false
        end

        currentActive = tabData
        tabData.Container.BackgroundColor3 = Color3.fromRGB(22, 30, 24)
        tabData.Style.Color = Color3.fromRGB(55, 125, 72)
        tabData.Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabData.Dot.Visible = true

        if name == "Персонаж" then
            loadPersonageTab()
        elseif name == "Визуал" then
            loadVisualTab()
        end
    end

    tabBtn.MouseButton1Click:Connect(activateTab)

    if i == 1 then
        activateTab()
    end
end
