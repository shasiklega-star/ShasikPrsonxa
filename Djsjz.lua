--[===================================================================]--
--  ROBLOX CHEAT: SHASIK CHEATS v9.42 - FIXED ATMOSPHERE & JETPACK
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
Title.Text = "ShasikCheats | v9.42"
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
_G.WeatherSunriseEnabled = _G.WeatherSunriseEnabled or false
_G.WeatherWhiteFogEnabled = _G.WeatherWhiteFogEnabled or false
_G.UltraGraphicsEnabled = _G.UltraGraphicsEnabled or false
_G.HideNamesEnabled = _G.HideNamesEnabled or false

_G.ESPNameColor = Color3.fromRGB(50, 180, 255)

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

local function setJetpackFire(active)
    for _, fire in ipairs(fireParticles) do
        if fire and fire.Parent then
            fire.Enabled = active
        end
    end
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

    local tankPrimaryColor = Color3.fromRGB(45, 115, 185)
    local tankAccentColor = Color3.fromRGB(80, 160, 225)
    local darkMetalColor = Color3.fromRGB(25, 25, 28)
    local chromeColor = Color3.fromRGB(180, 185, 190)
    local wireColor = Color3.fromRGB(220, 50, 50)
    local whiteColor = Color3.fromRGB(240, 240, 240)

    local storage = LocalPlayer.PlayerGui

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
        fire.Enabled = false
        fire.Parent = firePart

        table.insert(fireParticles, fire)
    end

    createTankAndFire(-0.42, 1)
    createTankAndFire(0.42, 2)
end

local function removeJetpack(char)
    setJetpackFire(false)
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
            guiObj:Destroy()
        end
    end
    fireParticles = {}
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

-- СБРОС И ОЧИСТКА ВСЕХ ЭФФЕКТОВ ПОГОДЫ
local function resetEnvironment()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") or child:IsA("BloomEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("PostEffect") then
            child:Destroy()
        end
    end
    if Terrain:FindFirstChildOfClass("Clouds") then 
        Terrain:FindFirstChildOfClass("Clouds"):Destroy() 
    end

    Lighting.ClockTime = 14
    Lighting.Brightness = 2
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    Lighting.FogColor = Color3.fromRGB(192, 192, 192)
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
end

local function applySunrise()
    resetEnvironment()
    local atmosphere = Instance.new("Atmosphere", Lighting)
    atmosphere.Density = 0.35
    atmosphere.Offset = 0.1
    atmosphere.Color = Color3.fromRGB(190, 210, 215)
    atmosphere.Decay = Color3.fromRGB(90, 100, 110)
    atmosphere.Glare = 0.4
    atmosphere.Haze = 2.0

    Lighting.Brightness = 2
    Lighting.ClockTime = 7
    Lighting.OutdoorAmbient = Color3.fromRGB(120, 130, 140)

    local bloom = Instance.new("BloomEffect", Lighting)
    bloom.Intensity = 0.4
    bloom.Size = 12
    bloom.Threshold = 0.8
end

local function applyWhiteFog()
    resetEnvironment()
    local atmosphere = Instance.new("Atmosphere", Lighting)
    atmosphere.Density = 0.85
    atmosphere.Offset = 0.0
    atmosphere.Haze = 10.0
    atmosphere.Glare = 0.0
    atmosphere.Color = Color3.fromRGB(150, 155, 160)
    atmosphere.Decay = Color3.fromRGB(100, 105, 110)

    Lighting.ClockTime = 12
    Lighting.Brightness = 0.5
    Lighting.OutdoorAmbient = Color3.fromRGB(130, 130, 130)

    Lighting.FogColor = Color3.fromRGB(150, 155, 160)
    Lighting.FogStart = 10
    Lighting.FogEnd = 130
end

local function applySunset()
    resetEnvironment()
    local sky = Instance.new("Sky", Lighting)
    sky.SkyboxBk = "rbxassetid://12064115166"
    sky.SkyboxDn = "rbxassetid://12064115243"
    sky.SkyboxFt = "rbxassetid://12064115316"
    sky.SkyboxLf = "rbxassetid://12064115437"
    sky.SkyboxRt = "rbxassetid://12064115545"
    sky.SkyboxUp = "rbxassetid://12064115629"
    sky.SunTextureId = "rbxassetid://6031535905"
    sky.SunAngularSize = 15

    local clouds = Instance.new("Clouds", Terrain)
    clouds.Density = 0.65
    clouds.Cover = 0.55
    clouds.Color = Color3.fromRGB(240, 150, 110)

    local atmosphere = Instance.new("Atmosphere", Lighting)
    atmosphere.Density = 0.28
    atmosphere.Offset = 0.4
    atmosphere.Haze = 1.2
    atmosphere.Glare = 2.0
    atmosphere.Color = Color3.fromRGB(255, 130, 70)
    atmosphere.Decay = Color3.fromRGB(120, 60, 110)

    Lighting.ClockTime = 17.85
    Lighting.Brightness = 4.0
    Lighting.OutdoorAmbient = Color3.fromRGB(55, 45, 60)

    local sunRays = Instance.new("SunRaysEffect", Lighting)
    sunRays.Intensity = 0.35
    local colorCorrection = Instance.new("ColorCorrectionEffect", Lighting)
    colorCorrection.Contrast = 0.25
    colorCorrection.Saturation = 0.35
end

local function applyStorm()
    resetEnvironment()
    local sky = Instance.new("Sky", Lighting)
    sky.SkyboxBk = "rbxassetid://12128564243"
    sky.SkyboxDn = "rbxassetid://12128564539"
    sky.SkyboxFt = "rbxassetid://12128564755"
    sky.SkyboxLf = "rbxassetid://12128564998"
    sky.SkyboxRt = "rbxassetid://12128565257"
    sky.SkyboxUp = "rbxassetid://12128565545"
    sky.SunTextureId = ""
    sky.CelestialBodiesShown = false

    local clouds = Instance.new("Clouds", Terrain)
    clouds.Density = 0.75
    clouds.Cover = 0.82
    clouds.Color = Color3.fromRGB(110, 115, 125)

    local atmosphere = Instance.new("Atmosphere", Lighting)
    atmosphere.Density = 0.38
    atmosphere.Offset = 0.15
    atmosphere.Haze = 2.5
    atmosphere.Color = Color3.fromRGB(130, 138, 145)

    Lighting.ClockTime = 13.5
    Lighting.Brightness = 0.8
    Lighting.OutdoorAmbient = Color3.fromRGB(105, 110, 115)
end

local function applyNight()
    resetEnvironment()
    local sky = Instance.new("Sky", Lighting)
    sky.Name = "CosmicSkybox"
    sky.SkyboxBk = "rbxassetid://12104593444"
    sky.SkyboxDn = "rbxassetid://12104593710"
    sky.SkyboxFt = "rbxassetid://12104593922"
    sky.SkyboxLf = "rbxassetid://12104594101"
    sky.SkyboxRt = "rbxassetid://12104594348"
    sky.SkyboxUp = "rbxassetid://12104594611"
    sky.MoonTextureId = ""
    sky.SunTextureId = ""

    local atmosphere = Instance.new("Atmosphere", Lighting)
    atmosphere.Density = 0.05
    atmosphere.Haze = 0.2
    atmosphere.Color = Color3.fromRGB(10, 12, 18)

    Lighting.ClockTime = 0.0
    Lighting.Brightness = 0.0
    Lighting.OutdoorAmbient = Color3.fromRGB(35, 38, 45)
end

function updateWeather()
    if _G.WeatherSunriseEnabled then applySunrise()
    elseif _G.WeatherWhiteFogEnabled then applyWhiteFog()
    elseif _G.WeatherSunsetEnabled then applySunset()
    elseif _G.WeatherStormEnabled then applyStorm()
    elseif _G.WeatherNightEnabled then applyNight()
    else resetEnvironment() end
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

    if _G.JetpackEnabled and character then
        local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
        if torso and not torso:FindFirstChild("JetpackVelocity") then
            setupCharacterJetpack(character)
            createJetpackUI()
        end

        if bodyVelocity and bodyVelocity.Parent and humanoid then
            local isInAir = (humanoid.FloorMaterial == Enum.Material.Air)

            if not isInAir and not isFlyingUp then
                bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                currentVerticalSpeed = 0
                smoothVelocity = Vector3.zero
                setJetpackFire(false)

                if fireSound and fireSound.IsPlaying then fireSound:Stop() end
                if windSound and windSound.IsPlaying then windSound:Stop() end
                if idleSound and not idleSound.IsPlaying then idleSound:Play() end
            else
                if isFlyingUp then
                    targetVerticalSpeed = MAX_UP_SPEED
                    setJetpackFire(true)
                elseif isFlyingDown then
                    targetVerticalSpeed = MAX_DOWN_SPEED
                    setJetpackFire(false)
                else
                    targetVerticalSpeed = SLOW_DRIFT_SPEED
                    setJetpackFire(false)
                end

                local lerpRate = (isFlyingUp or isFlyingDown) and ACCEL_SPEED or DECEL_SPEED
                currentVerticalSpeed = currentVerticalSpeed + (targetVerticalSpeed - currentVerticalSpeed) * lerpRate
                
                local targetHoriz = humanoid.MoveDirection * FLY_SPEED
                smoothVelocity = smoothVelocity:Lerp(targetHoriz, HORIZ_SMOOTH)

                bodyVelocity.MaxForce = Vector3.new(450000, 450000, 450000)
                bodyVelocity.Velocity = Vector3.new(smoothVelocity.X, currentVerticalSpeed, smoothVelocity.Z)

                if isFlyingUp then
                    if fireSound and not fireSound.IsPlaying then fireSound:Play() end
                    if windSound and windSound.IsPlaying then windSound:Stop() end
                else
                    if fireSound and fireSound.IsPlaying then fireSound:Stop() end
                    if windSound and not windSound.IsPlaying then windSound:Play() end
                end
            end
        end
    else
        if character then removeJetpack(character) end
    end
end)
