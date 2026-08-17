--[===================================================================]--
--  ROBLOX CHEAT: SHASIK CHEATS v9.20 (ULTIMATE EDITION)
--[===================================================================]--

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local DefaultFOV = Camera.FieldOfView

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
    AlertBox.Size = UDim2.new(0, 280, 0, 160)
    AlertBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    AlertBox.AnchorPoint = Vector2.new(0.5, 0.5)
    AlertBox.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    AlertBox.BackgroundTransparency = 1
    AlertBox.ZIndex = 201
    Instance.new("UICorner", AlertBox).CornerRadius = UDim.new(0, 12)

    local ABStroke = Instance.new("UIStroke", AlertBox)
    ABStroke.Color = Color3.fromRGB(45, 50, 65)
    ABStroke.Thickness = 1.2
    ABStroke.Transparency = 1

    if isSuccess then
        local IconCircle = Instance.new("Frame", AlertBox)
        IconCircle.Size = UDim2.new(0, 36, 0, 36)
        IconCircle.Position = UDim2.new(0.5, -18, 0, 16)
        IconCircle.BackgroundColor3 = Color3.fromRGB(30, 60, 40)
        IconCircle.BackgroundTransparency = 1
        IconCircle.ZIndex = 202
        Instance.new("UICorner", IconCircle).CornerRadius = UDim.new(1, 0)

        local ICStroke = Instance.new("UIStroke", IconCircle)
        ICStroke.Color = Color3.fromRGB(65, 185, 95)
        ICStroke.Thickness = 1.5
        ICStroke.Transparency = 1

        local CheckMark = Instance.new("TextLabel", IconCircle)
        CheckMark.Size = UDim2.new(1, 0, 1, 0)
        CheckMark.BackgroundTransparency = 1
        CheckMark.Text = "✓"
        CheckMark.TextColor3 = Color3.fromRGB(75, 215, 105)
        CheckMark.Font = Enum.Font.GothamBold
        CheckMark.TextSize = 18
        CheckMark.TextTransparency = 1
        CheckMark.ZIndex = 203

        TweenService:Create(IconCircle, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
        TweenService:Create(ICStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
        TweenService:Create(CheckMark, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    end

    local titleY = isSuccess and 58 or 18
    local TitleLbl = Instance.new("TextLabel", AlertBox)
    TitleLbl.Size = UDim2.new(1, 0, 0, 24)
    TitleLbl.Position = UDim2.new(0, 0, 0, titleY)
    TitleLbl.BackgroundTransparency = 1
    TitleLbl.Text = titleText
    TitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLbl.Font = Enum.Font.GothamBold
    TitleLbl.TextSize = 17
    TitleLbl.TextTransparency = 1
    TitleLbl.TextXAlignment = Enum.TextXAlignment.Center
    TitleLbl.ZIndex = 202

    local descY = isSuccess and 86 or 48
    local DescLbl = Instance.new("TextLabel", AlertBox)
    DescLbl.Size = UDim2.new(1, -30, 0, 35)
    DescLbl.Position = UDim2.new(0, 15, 0, descY)
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
    OkBtn.Size = UDim2.new(0, 120, 0, 34)
    OkBtn.Position = UDim2.new(0.5, -60, 0, 114)
    OkBtn.BackgroundColor3 = Color3.fromRGB(53, 132, 228)
    OkBtn.BackgroundTransparency = 1
    OkBtn.Text = "OK"
    OkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OkBtn.Font = Enum.Font.GothamBold
    OkBtn.TextSize = 14
    OkBtn.TextTransparency = 1
    OkBtn.ZIndex = 202
    Instance.new("UICorner", OkBtn).CornerRadius = UDim.new(0, 8)

    TweenService:Create(AlertBox, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 310, 0, 165), BackgroundTransparency = 0.05}):Play()
    TweenService:Create(ABStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    TweenService:Create(TitleLbl, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(DescLbl, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    TweenService:Create(OkBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0}):Play()

    OkBtn.MouseButton1Click:Connect(function()
        local tw = TweenService:Create(AlertBox, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 280, 0, 140), BackgroundTransparency = 1})
        TweenService:Create(ABStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
        TweenService:Create(TitleLbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(DescLbl, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
        TweenService:Create(OkBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
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
    LoadBox.Size = UDim2.new(0, 240, 0, 80)
    LoadBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    LoadBox.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadBox.BackgroundColor3 = Color3.fromRGB(16, 18, 24)
    LoadBox.BackgroundTransparency = 1
    LoadBox.ZIndex = 201
    Instance.new("UICorner", LoadBox).CornerRadius = UDim.new(0, 12)

    local LBStroke = Instance.new("UIStroke", LoadBox)
    LBStroke.Color = Color3.fromRGB(45, 50, 65)
    LBStroke.Thickness = 1.2
    LBStroke.Transparency = 1

    local Circle = Instance.new("Frame", LoadBox)
    Circle.Size = UDim2.new(0, 28, 0, 28)
    Circle.Position = UDim2.new(0, 20, 0.5, -14)
    Circle.BackgroundTransparency = 1
    Circle.ZIndex = 202

    local Ring = Instance.new("UIStroke", Circle)
    Ring.Color = Color3.fromRGB(53, 132, 228)
    Ring.Thickness = 3
    Ring.Transparency = 0

    local UICircle = Instance.new("UICorner", Circle)
    UICircle.CornerRadius = UDim.new(1, 0)

    local TextLbl = Instance.new("TextLabel", LoadBox)
    TextLbl.Size = UDim2.new(1, -60, 1, 0)
    TextLbl.Position = UDim2.new(0, 56, 0, 0)
    TextLbl.BackgroundTransparency = 1
    TextLbl.Text = text
    TextLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLbl.Font = Enum.Font.GothamBold
    TextLbl.TextSize = 13
    TextLbl.TextTransparency = 1
    TextLbl.TextXAlignment = Enum.TextXAlignment.Left
    TextLbl.ZIndex = 202

    TweenService:Create(LoadBox, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 260, 0, 85), BackgroundTransparency = 0.05}):Play()
    TweenService:Create(LBStroke, TweenInfo.new(0.25), {Transparency = 0}):Play()
    TweenService:Create(TextLbl, TweenInfo.new(0.25), {TextTransparency = 0}):Play()

    local spin = TweenService:Create(Circle, TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360})
    spin:Play()

    activeLoadingBox = LoadBox
    return {
        Close = function()
            spin:Cancel()
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
--  ПЛАВАЮЩАЯ ИКОНКА (ПО ЦЕНТРУ СВЕРХУ)
--[===================================================================]--
local FloatingIcon = Instance.new("TextButton", ScreenGui)
FloatingIcon.Size = UDim2.new(0, 48, 0, 48)
FloatingIcon.Position = UDim2.new(0.5, -24, 0, 12)
FloatingIcon.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
FloatingIcon.BackgroundTransparency = 0
FloatingIcon.Text = "🧬"
FloatingIcon.TextSize = 22
FloatingIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingIcon.Visible = false
FloatingIcon.ZIndex = 10
Instance.new("UICorner", FloatingIcon).CornerRadius = UDim.new(1, 0)

local FIStroke = Instance.new("UIStroke", FloatingIcon)
FIStroke.Color = Color3.fromRGB(65, 150, 85)
FIStroke.Thickness = 2.0

local dragging = false
local dragStart, startPos
local tweenInfoDrag = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatingIcon.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(FloatingIcon, tweenInfoDrag, {Position = targetPos}):Play()
    end
end)

--[===================================================================]--
--  ОКНО АВТОРИЗАЦИИ
--[===================================================================]--
local AuthFrame = Instance.new("Frame", ScreenGui)
AuthFrame.Size = UDim2.new(0, 380, 0, 260)
AuthFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
AuthFrame.AnchorPoint = Vector2.new(0.5, 0.5)
AuthFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
AuthFrame.BackgroundTransparency = 1
AuthFrame.Visible = false
Instance.new("UICorner", AuthFrame).CornerRadius = UDim.new(0, 12)

local AuthStroke = Instance.new("UIStroke", AuthFrame)
AuthStroke.Color = Color3.fromRGB(45, 50, 65)
AuthStroke.Thickness = 1.2
AuthStroke.Transparency = 1

local function OpenAuthMenu()
    AuthFrame.Visible = true
    AuthFrame.Size = UDim2.new(0, 340, 0, 230)
    AuthFrame.BackgroundTransparency = 1
    AuthStroke.Transparency = 1

    TweenService:Create(AuthFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 380, 0, 260),
        BackgroundTransparency = 0.08
    }):Play()
    TweenService:Create(AuthStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
end

OpenAuthMenu()

local AuthTitle = Instance.new("TextLabel", AuthFrame)
AuthTitle.Size = UDim2.new(1, 0, 0, 30)
AuthTitle.Position = UDim2.new(0, 0, 0, 18)
AuthTitle.BackgroundTransparency = 1
AuthTitle.Text = "Shasik Cheats | Авторизация"
AuthTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
AuthTitle.Font = Enum.Font.GothamBold
AuthTitle.TextSize = 17
AuthTitle.TextXAlignment = Enum.TextXAlignment.Center

local TextBoxBg = Instance.new("TextBox", AuthFrame)
TextBoxBg.Size = UDim2.new(0, 320, 0, 42)
TextBoxBg.Position = UDim2.new(0.5, -160, 0, 65)
TextBoxBg.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
TextBoxBg.Text = ""
TextBoxBg.PlaceholderText = "Введите ключ..."
TextBoxBg.PlaceholderColor3 = Color3.fromRGB(120, 125, 140)
TextBoxBg.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBoxBg.Font = Enum.Font.GothamBold
TextBoxBg.TextSize = 14
TextBoxBg.ClearTextOnFocus = false
Instance.new("UICorner", TextBoxBg).CornerRadius = UDim.new(0, 8)

local TBStroke = Instance.new("UIStroke", TextBoxBg)
TBStroke.Color = Color3.fromRGB(45, 45, 55)
TBStroke.Thickness = 1

local LoginBtn = Instance.new("TextButton", AuthFrame)
LoginBtn.Size = UDim2.new(0, 152, 0, 40)
LoginBtn.Position = UDim2.new(0.5, -160, 0, 122)
LoginBtn.BackgroundColor3 = Color3.fromRGB(53, 132, 228)
LoginBtn.Text = "Войти"
LoginBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LoginBtn.Font = Enum.Font.GothamBold
LoginBtn.TextSize = 14
Instance.new("UICorner", LoginBtn).CornerRadius = UDim.new(0, 8)

local GetKeyBtn = Instance.new("TextButton", AuthFrame)
GetKeyBtn.Size = UDim2.new(0, 152, 0, 40)
GetKeyBtn.Position = UDim2.new(0.5, 8, 0, 122)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
GetKeyBtn.Text = "Получить ключ"
GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 14
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 8)

local GKBStroke = Instance.new("UIStroke", GetKeyBtn)
GKBStroke.Color = Color3.fromRGB(45, 45, 55)
GKBStroke.Thickness = 1

local TelegramFooter = Instance.new("TextButton", AuthFrame)
TelegramFooter.Size = UDim2.new(1, 0, 0, 24)
TelegramFooter.Position = UDim2.new(0, 0, 1, -30)
TelegramFooter.BackgroundTransparency = 1
TelegramFooter.Text = "💬 t.me/shasikbospaxamadrid"
TelegramFooter.TextColor3 = Color3.fromRGB(110, 160, 230)
TelegramFooter.Font = Enum.Font.GothamSemibold
TelegramFooter.TextSize = 12

TelegramFooter.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://t.me/shasikbospaxamadrid") end)
    TelegramFooter.Text = "✓ Ссылка скопирована в буфер обмена!"
    task.wait(1.5)
    TelegramFooter.Text = "💬 t.me/shasikbospaxamadrid"
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard("https://t.me/shasikbospaxamadrid") end)
    GetKeyBtn.Text = "Скопировано!"
    task.wait(1.5)
    GetKeyBtn.Text = "Получить ключ"
end)

--[===================================================================]--
--  ГЛАВНЫЙ ИНТЕРФЕЙС
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
Title.Size = UDim2.new(1, -95, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ShasikCheats | t.me/shasikbospaxamadrid | v9.20"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local TimerLabel = Instance.new("TextLabel", TopBar)
TimerLabel.Size = UDim2.new(0, 65, 1, 0)
TimerLabel.Position = UDim2.new(1, -105, 0, 0)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "05:00"
TimerLabel.TextColor3 = Color3.fromRGB(160, 165, 180)
TimerLabel.Font = Enum.Font.GothamBold
TimerLabel.TextSize = 12
TimerLabel.TextXAlignment = Enum.TextXAlignment.Right

-- Таймер на 5 минут. Останавливается, если меню закрыто, и продолжает идти при открытии.
task.spawn(function()
    local totalSeconds = 5 * 60
    while totalSeconds > 0 do
        if isMenuOpen then
            totalSeconds = totalSeconds - 1
            local mins = math.floor(totalSeconds / 60)
            local secs = totalSeconds % 60
            TimerLabel.Text = string.format("%02d:%02d", mins, secs)
        end
        task.wait(1)
    end
    TimerLabel.Text = "00:00"
end)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -36, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(210, 210, 210)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22

isMenuOpen = false
local function toggleMenu()
    if not isAuthorized then
        OpenAuthMenu()
        FloatingIcon.Visible = false
        return
    end

    isMenuOpen = not isMenuOpen
    
    local scaleDown = TweenService:Create(FloatingIcon, TweenInfo.new(0.1), {Size = UDim2.new(0, 42, 0, 42)})
    local scaleUp = TweenService:Create(FloatingIcon, TweenInfo.new(0.1), {Size = UDim2.new(0, 48, 0, 48)})
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

FloatingIcon.MouseButton1Click:Connect(toggleMenu)
CloseBtn.MouseButton1Click:Connect(toggleMenu)

local isChecking = false

LoginBtn.MouseButton1Click:Connect(function()
    if isChecking then return end
    
    if TextBoxBg.Text == "" then
        ShowAlert("Внимание", "Пожалуйста, введите ключ!", false)
        return
    end
    
    isChecking = true
    local loader = ShowLoadingModal("Проверка ключа...")
    
    task.wait(1.5)
    loader.Close()
    
    if TextBoxBg.Text == "Shasikcheats" then
        isAuthorized = true
        LoginBtn.BackgroundColor3 = Color3.fromRGB(65, 175, 85)
        LoginBtn.Text = "Успешно!"
        
        ShowAlert("Успешно", "Ключ успешно активирован!", true, function()
            TweenService:Create(AuthFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            for _, obj in pairs(AuthFrame:GetDescendants()) do
                if obj:IsA("TextLabel") or obj:IsA("TextBox") or obj:IsA("TextButton") then
                    TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
                elseif obj:IsA("UIStroke") then
                    obj.Transparency = 1
                end
            end
            task.wait(0.3)
            AuthFrame:Destroy()
            
            FloatingIcon.Visible = true
            toggleMenu()
        end)
    else
        isChecking = false
        LoginBtn.Text = "Войти"
        ShowAlert("Ошибка", "Введенный ключ не найден в базе данных!", false)
    end
end)

--[===================================================================]--
--  ЛОГИКА ЧИТОВ И ВКЛАДОК
--[===================================================================]--

_G.SpeedHackEnabled = _G.SpeedHackEnabled or false
_G.WalkSpeedValue = _G.WalkSpeedValue or 22
_G.SuperRunEnabled = _G.SuperRunEnabled or false
_G.HighJumpEnabled = _G.HighJumpEnabled or false
_G.JumpHeightValue = _G.JumpHeightValue or 50
_G.LongJumpEnabled = _G.LongJumpEnabled or false
_G.FastTurnEnabled = _G.FastTurnEnabled or false
_G.GravityEnabled = _G.GravityEnabled or false
_G.NoClipEnabled = _G.NoClipEnabled or false
_G.FakeAFKEnabled = _G.FakeAFKEnabled or false
_G.FOVEnabled = _G.FOVEnabled or false
_G.FOV2Enabled = _G.FOV2Enabled or false
_G.ESP3DEnabled = _G.ESP3DEnabled or false

_G.WeatherNightEnabled = _G.WeatherNightEnabled or false
_G.WeatherSunsetEnabled = _G.WeatherSunsetEnabled or false
_G.WeatherStormEnabled = _G.WeatherStormEnabled or false
_G.UltraGraphicsEnabled = _G.UltraGraphicsEnabled or false
_G.HideNamesEnabled = _G.HideNamesEnabled or false

_G.ESPNameColor = Color3.fromRGB(50, 180, 255)

local flyingUp = false

UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Space then flyingUp = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Space then flyingUp = false end
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

LocalPlayer.CharacterAdded:Connect(function(newChar)
    if _G.GravityEnabled then
        task.spawn(function()
            task.wait(0.5)
            applyAntiGravity(newChar)
        end)
    end
end)

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

local function updateWeather()
    if _G.UltraGraphicsEnabled then
        Lighting.TimeOfDay = "14:00:00"
        Lighting.Brightness = 2.5
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 130, 150)
        Lighting.FogEnd = 100000
    elseif _G.WeatherNightEnabled then
        Lighting.TimeOfDay = "00:00:00"
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
    elseif _G.WeatherSunsetEnabled then
        Lighting.TimeOfDay = "18:30:00"
        Lighting.Brightness = 2
        Lighting.FogEnd = 100000
    elseif _G.WeatherStormEnabled then
        Lighting.TimeOfDay = "02:00:00"
        Lighting.Brightness = 0.2
        Lighting.FogEnd = 350
    else
        Lighting.TimeOfDay = "14:00:00"
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
    end
end

local lastJumpState = false
local function checkLongJump()
    if not _G.LongJumpEnabled then return end
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and hrp then
        local isJumping = (humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid.Jump)
        if isJumping and not lastJumpState then
            local lookDir = hrp.CFrame.LookVector
            hrp.AssemblyLinearVelocity = Vector3.new(lookDir.X * 140, hrp.AssemblyLinearVelocity.Y + 12, lookDir.Z * 140)
        end
        lastJumpState = isJumping
    end
end

RunService.RenderStepped:Connect(function()
    local character = LocalPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        if _G.SuperRunEnabled then
            humanoid.WalkSpeed = 65
        elseif _G.SpeedHackEnabled then
            humanoid.WalkSpeed = _G.WalkSpeedValue
        end

        if _G.HighJumpEnabled then
            humanoid.UseJumpPower = false
            humanoid.JumpHeight = _G.JumpHeightValue
        end
    end

    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not _G.NoClipEnabled
            end
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
            local upForce = flyingUp and (totalMass * workspace.Gravity * 1.5) or 0
            bodyForce.Force = Vector3.new(0, (totalMass * workspace.Gravity) + upForce, 0)
        end
    end

    if _G.FakeAFKEnabled and rootPart then
        rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0.0001, 0)
    end

    update3DESP()
    updateHideNames()
    updateWeather()
    checkLongJump()
end)

local fovTweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function updateFOV()
    if Camera then
        local targetFOV = DefaultFOV
        if _G.FOV2Enabled then targetFOV = 135
        elseif _G.FOVEnabled then targetFOV = 100 end
        TweenService:Create(Camera, fovTweenInfo, {FieldOfView = targetFOV}):Play()
    end
end

local fastTweenInfo = TweenInfo.new(0.06, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local function playClickAnimation(button)
    local originalSize = button.Size
    local smallerSize = UDim2.new(originalSize.X.Scale, originalSize.X.Offset - 6, originalSize.Y.Scale, originalSize.Y.Offset - 3)
    local toSmall = TweenService:Create(button, fastTweenInfo, {Size = smallerSize})
    local toNormal = TweenService:Create(button, fastTweenInfo, {Size = originalSize})
    toSmall:Play()
    toSmall.Completed:Connect(function() toNormal:Play() end)
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
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 520)
ScrollingFrame.ScrollBarThickness = 3.5
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(240, 240, 240)

local loadPersonageTab
local loadVisualTab

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
    outerCircle.Size = UDim2.new(0, 18, 0, 18)
    outerCircle.Position = UDim2.new(0, 10, 0.5, 0)
    outerCircle.AnchorPoint = Vector2.new(0, 0.5)
    outerCircle.BackgroundColor3 = _G[enabledVar] and Color3.fromRGB(22, 48, 28) or Color3.fromRGB(28, 28, 36)
    outerCircle.BackgroundTransparency = 0.2
    Instance.new("UICorner", outerCircle).CornerRadius = UDim.new(1, 0)

    local outerStroke = Instance.new("UIStroke", outerCircle)
    outerStroke.Color = _G[enabledVar] and Color3.fromRGB(70, 160, 90) or Color3.fromRGB(60, 60, 70)
    outerStroke.Thickness = 1.0

    local innerDot = Instance.new("Frame", outerCircle)
    innerDot.Size = UDim2.new(0, 6, 0, 6)
    innerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    innerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    innerDot.BackgroundColor3 = _G[enabledVar] and Color3.fromRGB(75, 195, 95) or Color3.fromRGB(90, 90, 100)
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

    local isAnimating = false

    btn.MouseButton1Click:Connect(function()
        if isAnimating then return end
        isAnimating = true
        playClickAnimation(btn)

        _G[enabledVar] = not _G[enabledVar]
        local newState = _G[enabledVar]

        local targetBg = newState and Color3.fromRGB(18, 35, 22) or Color3.fromRGB(22, 22, 28)
        local targetStroke = newState and Color3.fromRGB(55, 125, 72) or Color3.fromRGB(45, 45, 55)
        local targetOuterBg = newState and Color3.fromRGB(22, 48, 28) or Color3.fromRGB(28, 28, 36)
        local targetOuterStroke = newState and Color3.fromRGB(70, 160, 90) or Color3.fromRGB(60, 60, 70)
        local targetDot = newState and Color3.fromRGB(75, 195, 95) or Color3.fromRGB(90, 90, 100)
        local targetText = newState and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 210)

        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = targetBg}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = targetStroke}):Play()
        TweenService:Create(outerCircle, TweenInfo.new(0.2), {BackgroundColor3 = targetOuterBg}):Play()
        TweenService:Create(outerStroke, TweenInfo.new(0.2), {Color = targetOuterStroke}):Play()
        TweenService:Create(innerDot, TweenInfo.new(0.2), {BackgroundColor3 = targetDot}):Play()
        TweenService:Create(label, TweenInfo.new(0.2), {TextColor3 = targetText}):Play()

        if callback then callback(newState) end
        isAnimating = false
    end)
end

loadPersonageTab = function()
    for _, child in ipairs(ScrollingFrame:GetChildren()) do child:Destroy() end

    if not _G.SpeedHackEnabled then
        createToggleUniversal(ScrollingFrame, "SpeedHack", UDim2.new(0, 6, 0, 4), "SpeedHackEnabled", function(en)
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h and not _G.SuperRunEnabled then h.WalkSpeed = en and _G.WalkSpeedValue or 16 end
            loadPersonageTab()
        end)
    else
        local speedCard = Instance.new("Frame", ScrollingFrame)
        speedCard.Size = UDim2.new(0, 192, 0, 84)
        speedCard.Position = UDim2.new(0, 6, 0, 4)
        speedCard.BackgroundColor3 = Color3.fromRGB(18, 35, 22)
        speedCard.BackgroundTransparency = 0.15
        Instance.new("UICorner", speedCard).CornerRadius = UDim.new(0, 8)

        local scStroke = Instance.new("UIStroke", speedCard)
        scStroke.Color = Color3.fromRGB(55, 125, 72)
        scStroke.Thickness = 1.1

        local toggleArea = Instance.new("TextButton", speedCard)
        toggleArea.Size = UDim2.new(1, 0, 0, 38)
        toggleArea.BackgroundTransparency = 1
        toggleArea.Text = ""

        local outerCircle = Instance.new("Frame", speedCard)
        outerCircle.Size = UDim2.new(0, 18, 0, 18)
        outerCircle.Position = UDim2.new(0, 10, 0, 10)
        outerCircle.BackgroundColor3 = Color3.fromRGB(22, 48, 28)
        outerCircle.BackgroundTransparency = 0.2
        Instance.new("UICorner", outerCircle).CornerRadius = UDim.new(1, 0)

        local outerStroke = Instance.new("UIStroke", outerCircle)
        outerStroke.Color = Color3.fromRGB(70, 160, 90)
        outerStroke.Thickness = 1.0

        local innerDot = Instance.new("Frame", outerCircle)
        innerDot.Size = UDim2.new(0, 6, 0, 6)
        innerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
        innerDot.AnchorPoint = Vector2.new(0.5, 0.5)
        innerDot.BackgroundColor3 = Color3.fromRGB(75, 195, 95)
        Instance.new("UICorner", innerDot).CornerRadius = UDim.new(1, 0)

        local label = Instance.new("TextLabel", speedCard)
        label.Size = UDim2.new(1, -38, 0, 38)
        label.Position = UDim2.new(0, 36, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = "SpeedHack"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left

        local sVal = Instance.new("TextLabel", speedCard)
        sVal.Size = UDim2.new(0, 40, 0, 38)
        sVal.Position = UDim2.new(1, -45, 0, 0)
        sVal.BackgroundTransparency = 1
        sVal.Text = tostring(_G.WalkSpeedValue)
        sVal.TextColor3 = Color3.fromRGB(75, 195, 95)
        sVal.Font = Enum.Font.GothamBold
        sVal.TextSize = 11
        sVal.TextXAlignment = Enum.TextXAlignment.Right

        local strackBg = Instance.new("Frame", speedCard)
        strackBg.Size = UDim2.new(0, 172, 0, 10)
        strackBg.Position = UDim2.new(0, 10, 0, 48)
        strackBg.BackgroundColor3 = Color3.fromRGB(12, 24, 15)
        Instance.new("UICorner", strackBg).CornerRadius = UDim.new(1, 0)

        local sFillPerc = math.clamp((_G.WalkSpeedValue - 1) / 149, 0, 1)
        local strackFill = Instance.new("Frame", strackBg)
        strackFill.Size = UDim2.new(sFillPerc, 0, 1, 0)
        strackFill.BackgroundColor3 = Color3.fromRGB(75, 195, 95)
        Instance.new("UICorner", strackFill).CornerRadius = UDim.new(1, 0)

        local strackBtn = Instance.new("TextButton", strackBg)
        strackBtn.Size = UDim2.new(1, 0, 1, 0)
        strackBtn.BackgroundTransparency = 1
        strackBtn.Text = ""

        strackBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local conn
                conn = RunService.RenderStepped:Connect(function()
                    local mouse = LocalPlayer:GetMouse()
                    local rel = math.clamp((mouse.X - strackBg.AbsolutePosition.X) / strackBg.AbsoluteSize.X, 0, 1)
                    _G.WalkSpeedValue = math.floor(1 + (rel * 149))
                    strackFill.Size = UDim2.new(rel, 0, 1, 0)
                    sVal.Text = tostring(_G.WalkSpeedValue)
                    if _G.SpeedHackEnabled and not _G.SuperRunEnabled then
                        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                        if h then h.WalkSpeed = _G.WalkSpeedValue end
                    end
                end)
                input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then conn:Disconnect() end end)
            end
        end)

        toggleArea.MouseButton1Click:Connect(function()
            _G.SpeedHackEnabled = false
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if h and not _G.SuperRunEnabled then h.WalkSpeed = 16 end
            loadPersonageTab()
        end)
    end

    local secondRowY = _G.SpeedHackEnabled and 92 or 46
    
    createToggleUniversal(ScrollingFrame, "Высокий прыжок", UDim2.new(0, 204, 0, 4), "HighJumpEnabled", function(en)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower = false; h.JumpHeight = en and _G.JumpHeightValue or 7.2 end
    end)

    createToggleUniversal(ScrollingFrame, "Длинный прыжок", UDim2.new(0, 6, 0, secondRowY), "LongJumpEnabled")
    createToggleUniversal(ScrollingFrame, "Быстрый бег", UDim2.new(0, 204, 0, secondRowY), "SuperRunEnabled", function(en)
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = en and 65 or (_G.SpeedHackEnabled and _G.WalkSpeedValue or 16) end
    end)

    local thirdRowY = secondRowY + 42
    createToggleUniversal(ScrollingFrame, "Гравитация", UDim2.new(0, 6, 0, thirdRowY), "GravityEnabled", function(en)
        if en then applyAntiGravity(LocalPlayer.Character)
        else
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local force = hrp and hrp:FindFirstChild("AntiGravityForce")
            if force then force:Destroy() end
        end
    end)
    createToggleUniversal(ScrollingFrame, "Быстрый поворот", UDim2.new(0, 204, 0, thirdRowY), "FastTurnEnabled")
    
    local fourthRowY = thirdRowY + 42
    createToggleUniversal(ScrollingFrame, "NoClip", UDim2.new(0, 6, 0, fourthRowY), "NoClipEnabled")
    createToggleUniversal(ScrollingFrame, "Fake AFK", UDim2.new(0, 204, 0, fourthRowY), "FakeAFKEnabled")
    
    local fifthRowY = fourthRowY + 42
    local suicideBtn = Instance.new("TextButton", ScrollingFrame)
    suicideBtn.Size = UDim2.new(0, 192, 0, 38)
    suicideBtn.Position = UDim2.new(0, 6, 0, fifthRowY)
    suicideBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    suicideBtn.BackgroundTransparency = 0.15
    suicideBtn.Text = ""
    suicideBtn.ClipsDescendants = true
    Instance.new("UICorner", suicideBtn).CornerRadius = UDim.new(0, 8)

    local suicideStroke = Instance.new("UIStroke", suicideBtn)
    suicideStroke.Color = Color3.fromRGB(45, 45, 55)
    suicideStroke.Thickness = 1.1

    local sOuterCircle = Instance.new("Frame", suicideBtn)
    sOuterCircle.Size = UDim2.new(0, 18, 0, 18)
    sOuterCircle.Position = UDim2.new(0, 10, 0.5, 0)
    sOuterCircle.AnchorPoint = Vector2.new(0, 0.5)
    sOuterCircle.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    sOuterCircle.BackgroundTransparency = 0.2
    Instance.new("UICorner", sOuterCircle).CornerRadius = UDim.new(1, 0)

    local sOuterStroke = Instance.new("UIStroke", sOuterCircle)
    sOuterStroke.Color = Color3.fromRGB(60, 60, 70)
    sOuterStroke.Thickness = 1.0

    local sInnerDot = Instance.new("Frame", sOuterCircle)
    sInnerDot.Size = UDim2.new(0, 6, 0, 6)
    sInnerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    sInnerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    sInnerDot.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
    Instance.new("UICorner", sInnerDot).CornerRadius = UDim.new(1, 0)

    local suicideLabel = Instance.new("TextLabel", suicideBtn)
    suicideLabel.Size = UDim2.new(1, -38, 1, 0)
    suicideLabel.Position = UDim2.new(0, 36, 0, 0)
    suicideLabel.BackgroundTransparency = 1
    suicideLabel.Text = "Суицид"
    suicideLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    suicideLabel.Font = Enum.Font.GothamBold
    suicideLabel.TextSize = 12
    suicideLabel.TextXAlignment = Enum.TextXAlignment.Left

    suicideBtn.MouseButton1Click:Connect(function()
        playClickAnimation(suicideBtn)
        ShowAlert("Успешно", "Персонаж ликвидирован!", true)
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.Health = 0 end
        end
    end)
end

loadVisualTab = function()
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

    createToggleUniversal(ScrollingFrame, "FOV Эффект", UDim2.new(0, 6, 0, 26), "FOVEnabled", function(en)
        if en then _G.FOV2Enabled = false end
        updateFOV()
        loadVisualTab()
    end)

    createToggleUniversal(ScrollingFrame, "FOV Эффект 2", UDim2.new(0, 204, 0, 26), "FOV2Enabled", function(en)
        if en then _G.FOVEnabled = false end
        updateFOV()
        loadVisualTab()
    end)

    local weatherTitle = Instance.new("TextLabel", ScrollingFrame)
    weatherTitle.Size = UDim2.new(1, 0, 0, 18)
    weatherTitle.Position = UDim2.new(0, 6, 0, 78)
    weatherTitle.BackgroundTransparency = 1
    weatherTitle.Text = "АТМОСФЕРА И ОКРУЖЕНИЕ"
    weatherTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
    weatherTitle.Font = Enum.Font.GothamBold
    weatherTitle.TextSize = 11
    weatherTitle.TextXAlignment = Enum.TextXAlignment.Left

    createToggleUniversal(ScrollingFrame, "Ночь", UDim2.new(0, 6, 0, 100), "WeatherNightEnabled", function(en)
        if en then
            _G.WeatherSunsetEnabled = false
            _G.WeatherStormEnabled = false
            _G.UltraGraphicsEnabled = false
            loadVisualTab()
        end
    end)

    createToggleUniversal(ScrollingFrame, "Закат", UDim2.new(0, 204, 0, 100), "WeatherSunsetEnabled", function(en)
        if en then
            _G.WeatherNightEnabled = false
            _G.WeatherStormEnabled = false
            _G.UltraGraphicsEnabled = false
            loadVisualTab()
        end
    end)

    createToggleUniversal(ScrollingFrame, "Ночь с грозой", UDim2.new(0, 6, 0, 148), "WeatherStormEnabled", function(en)
        if en then
            _G.WeatherNightEnabled = false
            _G.WeatherSunsetEnabled = false
            _G.UltraGraphicsEnabled = false
            loadVisualTab()
        end
    end)

    createToggleUniversal(ScrollingFrame, "Ультра графика", UDim2.new(0, 204, 0, 148), "UltraGraphicsEnabled", function(en)
        if en then
            _G.WeatherNightEnabled = false
            _G.WeatherSunsetEnabled = false
            _G.WeatherStormEnabled = false
            loadVisualTab()
        end
    end)

    local resetWeather = Instance.new("TextButton", ScrollingFrame)
    resetWeather.Size = UDim2.new(0, 192, 0, 38)
    resetWeather.Position = UDim2.new(0, 6, 0, 196)
    resetWeather.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    resetWeather.BackgroundTransparency = 0.15
    resetWeather.Text = "Сбросить погоду"
    resetWeather.TextColor3 = Color3.fromRGB(200, 200, 210)
    resetWeather.Font = Enum.Font.GothamBold
    resetWeather.TextSize = 12
    Instance.new("UICorner", resetWeather).CornerRadius = UDim.new(0, 8)

    resetWeather.MouseButton1Click:Connect(function()
        playClickAnimation(resetWeather)
        _G.WeatherNightEnabled = false
        _G.WeatherSunsetEnabled = false
        _G.WeatherStormEnabled = false
        _G.UltraGraphicsEnabled = false
        loadVisualTab()
    end)

    local espTitle = Instance.new("TextLabel", ScrollingFrame)
    espTitle.Size = UDim2.new(1, 0, 0, 18)
    espTitle.Position = UDim2.new(0, 6, 0, 244)
    espTitle.BackgroundTransparency = 1
    espTitle.Text = "ПОДСВЕТКА И ESP"
    espTitle.TextColor3 = Color3.fromRGB(150, 150, 160)
    espTitle.Font = Enum.Font.GothamBold
    espTitle.TextSize = 11
    espTitle.TextXAlignment = Enum.TextXAlignment.Left

    createToggleUniversal(ScrollingFrame, "ESP игроки", UDim2.new(0, 6, 0, 266), "ESP3DEnabled")
    createToggleUniversal(ScrollingFrame, "Скрыть ники", UDim2.new(0, 204, 0, 266), "HideNamesEnabled", function(en)
        _G.HideNamesEnabled = en
    end)
end

local tabs = {"Персонаж", "Визуал", "Оружие", "Прочее"}
local currentActive = nil

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
    
    local function activateTab()
        playClickAnimation(tabBtn)
        if currentActive then
            currentActive.Container.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
            currentActive.Style.Color = Color3.fromRGB(45, 45, 55)
            currentActive.Dot.Visible = false
            currentActive.Btn.TextColor3 = Color3.fromRGB(180, 180, 190)
        end
        tabContainer.BackgroundColor3 = Color3.fromRGB(22, 42, 26)
        stroke.Color = Color3.fromRGB(65, 150, 85)
        dot.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentActive = {Container = tabContainer, Style = stroke, Dot = dot, Btn = tabBtn}

        if name == "Персонаж" then loadPersonageTab()
        elseif name == "Визуал" then loadVisualTab()
        else
            for _, child in ipairs(ScrollingFrame:GetChildren()) do child:Destroy() end
        end
    end

    if i == 1 then activateTab() end
    tabBtn.MouseButton1Click:Connect(activateTab)
end
