local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local vim = game:GetService("VirtualInputManager")
local userInputService = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local tweenService = game:GetService("TweenService")
local camera = workspace.CurrentCamera

-- إزالة أي واجهة قديمة لمنع التكرار
if playerGui:FindFirstChild("DeltaWanderGUI") then
    playerGui.DeltaWanderGUI:Destroy()
end

-- إنشاء الشاشة الرئيسية
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaWanderGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

------------------------------------------------------------------
-- 1. إنترو أسطوري سينمائي
------------------------------------------------------------------
local introFrame = Instance.new("Frame")
introFrame.Size = UDim2.new(2, 0, 2, 0)
introFrame.Position = UDim2.new(-0.5, 0, -0.5, 0)
introFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
introFrame.BackgroundTransparency = 0
introFrame.BorderSizePixel = 0
introFrame.ZIndex = 25
introFrame.Parent = screenGui

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 0, 30)
logoText.Position = UDim2.new(0, 0, 0.25, 0)
logoText.BackgroundTransparency = 1
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.TextSize = 18
logoText.Font = Enum.Font.GothamBlack
logoText.Text = "P H A N T O M"
logoText.TextTransparency = 1
logoText.ZIndex = 26
logoText.Parent = introFrame

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 85, 0, 85)
avatarImg.Position = UDim2.new(0.5, -42, 0.33, 0)
avatarImg.BackgroundTransparency = 1
avatarImg.ImageTransparency = 1
avatarImg.ZIndex = 26
avatarImg.Parent = introFrame

local imgCorner = Instance.new("UICorner")
imgCorner.CornerRadius = UDim.new(1, 0)
imgCorner.Parent = avatarImg

local imgStroke = Instance.new("UIStroke")
imgStroke.Color = Color3.fromRGB(255, 255, 255)
imgStroke.Thickness = 2
imgStroke.Parent = avatarImg

task.spawn(function()
    pcall(function()
        local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        if isReady and content then
            avatarImg.Image = content
        end
    end)
end)

local userIntroText = Instance.new("TextLabel")
userIntroText.Size = UDim2.new(1, 0, 0, 25)
userIntroText.Position = UDim2.new(0, 0, 0.53, 0)
userIntroText.BackgroundTransparency = 1
userIntroText.TextColor3 = Color3.fromRGB(160, 160, 160)
userIntroText.TextSize = 14
userIntroText.Font = Enum.Font.GothamMedium
userIntroText.Text = "@somenzoaura66"
userIntroText.TextTransparency = 1
userIntroText.ZIndex = 26
userIntroText.Parent = introFrame

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(1, 0, 0, 45)
introText.Position = UDim2.new(0, 0, 0.61, 0)
introText.BackgroundTransparency = 1
introText.TextColor3 = Color3.fromRGB(255, 255, 255)
introText.TextSize = 24
introText.Font = Enum.Font.GothamBold
introText.Text = "سكربت فانطوم الخاص"
introText.TextTransparency = 1
introText.TextWrapped = true
introText.ZIndex = 26
introText.Parent = introFrame

------------------------------------------------------------------
-- 2. نافذة اختيار اللغة
------------------------------------------------------------------
local langFrame = Instance.new("Frame")
langFrame.Size = UDim2.new(0, 260, 0, 160)
langFrame.Position = UDim2.new(0.5, -130, 0.5, -80)
langFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
langFrame.BorderSizePixel = 0
langFrame.Visible = false
langFrame.ZIndex = 15
langFrame.Parent = screenGui

local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 12)
lCorner.Parent = langFrame

local lStroke = Instance.new("UIStroke")
lStroke.Color = Color3.fromRGB(255, 255, 255)
lStroke.Thickness = 2
lStroke.Parent = langFrame

local langTitle = Instance.new("TextLabel")
langTitle.Size = UDim2.new(1, 0, 0, 45)
langTitle.Position = UDim2.new(0, 0, 0, 10)
langTitle.BackgroundTransparency = 1
langTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
langTitle.TextSize = 14
langTitle.Font = Enum.Font.GothamBold
langTitle.Text = "اختر اللغة / Choose Language"
langTitle.ZIndex = 16
langTitle.Parent = langFrame

local arButton = Instance.new("TextButton")
arButton.Size = UDim2.new(0.85, 0, 0, 38)
arButton.Position = UDim2.new(0.075, 0, 0, 60)
arButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
arButton.TextColor3 = Color3.fromRGB(255, 255, 255)
arButton.TextSize = 13
arButton.Font = Enum.Font.GothamBold
arButton.Text = "النسخة العربية (Arabic)"
arButton.ZIndex = 16
arButton.Parent = langFrame

local arCorner = Instance.new("UICorner")
arCorner.CornerRadius = UDim.new(0, 8)
arCorner.Parent = arButton

local enButton = Instance.new("TextButton")
enButton.Size = UDim2.new(0.85, 0, 0, 38)
enButton.Position = UDim2.new(0.075, 0, 0, 108)
enButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
enButton.TextColor3 = Color3.fromRGB(255, 255, 255)
enButton.TextSize = 13
enButton.Font = Enum.Font.GothamBold
enButton.Text = "English Version"
enButton.ZIndex = 16
enButton.Parent = langFrame

local enCorner = Instance.new("UICorner")
enCorner.CornerRadius = UDim.new(0, 8)
enCorner.Parent = enButton

task.spawn(function()
    local t1 = tweenService:Create(logoText, TweenInfo.new(0.8), {TextTransparency = 0})
    local t2 = tweenService:Create(introText, TweenInfo.new(0.8), {TextTransparency = 0})
    local t3 = tweenService:Create(userIntroText, TweenInfo.new(0.8), {TextTransparency = 0})
    local t4 = tweenService:Create(avatarImg, TweenInfo.new(0.8), {ImageTransparency = 0})
    t1:Play() t2:Play() t3:Play() t4:Play()
    t2.Completed:Wait()
    
    task.wait(1.5)
    
    local f1 = tweenService:Create(introFrame, TweenInfo.new(1), {BackgroundTransparency = 1})
    local f2 = tweenService:Create(logoText, TweenInfo.new(1), {TextTransparency = 1})
    local f3 = tweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 1})
    local f4 = tweenService:Create(userIntroText, TweenInfo.new(1), {TextTransparency = 1})
    local f5 = tweenService:Create(avatarImg, TweenInfo.new(1), {ImageTransparency = 1})
    f1:Play() f2:Play() f3:Play() f4:Play() f5:Play()
    f1.Completed:Wait()
    
    introFrame:Destroy()
    langFrame.Visible = true
end)

------------------------------------------------------------------
-- 3. الواجهة الرئيسية
------------------------------------------------------------------
local currentLang = "AR"

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 45, 0, 45)
toggleButton.Position = UDim2.new(0, 20, 0.4, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 20
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Text = "P"
toggleButton.Visible = false
toggleButton.Parent = screenGui

local pCorner = Instance.new("UICorner")
pCorner.CornerRadius = UDim.new(1, 0)
pCorner.Parent = toggleButton

local pStroke = Instance.new("UIStroke")
pStroke.Color = Color3.fromRGB(255, 255, 255)
pStroke.Thickness = 2
pStroke.Parent = toggleButton

local pDragging, pDragInput, pDragStart, pStartPos
toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        pDragging = true
        pDragStart = input.Position
        pStartPos = toggleButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then pDragging = false end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        pDragInput = input
    end
end)

userInputService.InputChanged:Connect(function(input)
    if input == pDragInput and pDragging then
        local delta = input.Position - pDragStart
        toggleButton.Position = UDim2.new(pStartPos.X.Scale, pStartPos.X.Offset + delta.X, pStartPos.Y.Scale, pStartPos.Y.Offset + delta.Y)
    end
end)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 435)
mainFrame.Position = UDim2.new(0.5, -120, 0.4, -217)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(255, 255, 255)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

local fDragging, fDragInput, fDragStart, fStartPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        fDragging = true
        fDragStart = input.Position
        fStartPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then fDragging = false end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        fDragInput = input
    end
end)

userInputService.InputChanged:Connect(function(input)
    if input == fDragInput and fDragging then
        local delta = input.Position - fDragStart
        mainFrame.Position = UDim2.new(pStartPos.X.Scale, pStartPos.X.Offset + delta.X, pStartPos.Y.Scale, pStartPos.Y.Offset + delta.Y)
    end
end)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -65, 0, 18)
titleLabel.Position = UDim2.new(0, 10, 0, 6)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "BY PHANTOM"
titleLabel.Parent = mainFrame

local userLabel = Instance.new("TextLabel")
userLabel.Size = UDim2.new(1, -65, 0, 16)
userLabel.Position = UDim2.new(0, 10, 0, 24)
userLabel.BackgroundTransparency = 1
userLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
userLabel.TextSize = 11
userLabel.Font = Enum.Font.GothamMedium
userLabel.Text = "@somenzoaura66"
userLabel.Parent = mainFrame

local timerLabel = Instance.new("TextLabel")
timerLabel.Size = UDim2.new(1, -115, 0, 18)
timerLabel.Position = UDim2.new(0, 10, 0, 42)
timerLabel.BackgroundTransparency = 1
timerLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
timerLabel.TextSize = 11
timerLabel.Font = Enum.Font.GothamBold
timerLabel.Text = "00:00:00"
timerLabel.Parent = mainFrame

local currentTimeFormatted = "00:00:00"

task.spawn(function()
    local startTime = tick()
    while true do
        task.wait(1)
        local elapsed = math.floor(tick() - startTime)
        local hours = math.floor(elapsed / 3600)
        local minutes = math.floor((elapsed % 3600) / 60)
        local seconds = elapsed % 60
        currentTimeFormatted = string.format("%02d:%02d:%02d", hours, minutes, seconds)
        timerLabel.Text = currentTimeFormatted
    end
end)

local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 45, 0, 20)
copyButton.Position = UDim2.new(1, -105, 0, 41)
copyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextSize = 10
copyButton.Font = Enum.Font.GothamBold
copyButton.Text = "نسخ"
copyButton.Parent = mainFrame

local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 4)
copyCorner.Parent = copyButton

local function showNotification(msgAR, msgEN)
    task.spawn(function()
        if screenGui:FindFirstChild("NotifFrame") then
            screenGui.NotifFrame:Destroy()
        end
        
        local notif = Instance.new("TextLabel")
        notif.Name = "NotifFrame"
        notif.Size = UDim2.new(0, 280, 0, 35)
        notif.Position = UDim2.new(0.5, -140, 0, -40)
        notif.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        notif.TextColor3 = Color3.fromRGB(255, 255, 255)
        notif.TextSize = 12
        notif.Font = Enum.Font.GothamMedium
        notif.Text = (currentLang == "AR") and msgAR or msgEN
        notif.Parent = screenGui
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = notif
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1.5
        stroke.Parent = notif
        
        notif:TweenPosition(UDim2.new(0.5, -140, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        task.wait(2.5)
        notif:TweenPosition(UDim2.new(0.5, -140, 0, -40), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
        task.wait(0.3)
        notif:Destroy()
    end)
end

copyButton.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then
            if currentLang == "AR" then
                setclipboard("مدة بقائك: " .. currentTimeFormatted)
                showNotification("تم نسخ الوقت بنجاح!", "Time copied successfully!")
            else
                setclipboard("Time spent: " .. currentTimeFormatted)
                showNotification("تم نسخ الوقت بنجاح!", "Time copied successfully!")
            end
        else
            showNotification("خاصية النسخ غير مدعومة في جهازك", "Clipboard not supported")
        end
    end)
end)

local isMinimized = false
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 25, 0, 25)
minButton.Position = UDim2.new(1, -60, 0, 12)
minButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minButton.TextSize = 14
minButton.Font = Enum.Font.GothamBold
minButton.Text = "-"
minButton.Parent = mainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minButton

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 12)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Text = "×"
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

------------------------------------------------------------------
-- 4. نافذة التأكيد للإغلاق
------------------------------------------------------------------
local confirmFrame = Instance.new("Frame")
confirmFrame.Size = UDim2.new(0, 220, 0, 120)
confirmFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
confirmFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
confirmFrame.BorderSizePixel = 0
confirmFrame.Visible = false
confirmFrame.ZIndex = 20
confirmFrame.Parent = screenGui

local confirmCorner = Instance.new("UICorner")
confirmCorner.CornerRadius = UDim.new(0, 10)
confirmCorner.Parent = confirmFrame

local confirmStroke = Instance.new("UIStroke")
confirmStroke.Color = Color3.fromRGB(255, 255, 255)
confirmStroke.Thickness = 2
confirmStroke.Parent = confirmFrame

local confirmText = Instance.new("TextLabel")
confirmText.Size = UDim2.new(1, 0, 0, 50)
confirmText.Position = UDim2.new(0, 0, 0, 10)
confirmText.BackgroundTransparency = 1
confirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmText.TextSize = 14
confirmText.Font = Enum.Font.GothamBold
confirmText.Text = "هل تريد اغلاق السكربت؟"
confirmText.ZIndex = 21
confirmText.Parent = confirmFrame

local noButton = Instance.new("TextButton")
noButton.Size = UDim2.new(0.4, 0, 0, 35)
noButton.Position = UDim2.new(0.07, 0, 0, 65)
noButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
noButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noButton.TextSize = 13
noButton.Font = Enum.Font.GothamSemibold
noButton.Text = "لا"
noButton.ZIndex = 21
noButton.Parent = confirmFrame

local noCorner = Instance.new("UICorner")
noCorner.CornerRadius = UDim.new(0, 6)
noCorner.Parent = noButton

local yesButton = Instance.new("TextButton")
yesButton.Size = UDim2.new(0.4, 0, 0, 35)
yesButton.Position = UDim2.new(0.53, 0, 0, 65)
yesButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
yesButton.TextColor3 = Color3.fromRGB(0, 0, 0)
yesButton.TextSize = 12
yesButton.Font = Enum.Font.GothamBold
yesButton.Text = "نعم حل عني"
yesButton.ZIndex = 21
yesButton.Parent = confirmFrame

local yesCorner = Instance.new("UICorner")
yesCorner.CornerRadius = UDim.new(0, 6)
yesCorner.Parent = yesButton

local function updateCloseDialogLang()
    if currentLang == "AR" then
        confirmText.Text = "هل تريد اغلاق السكربت؟"
        noButton.Text = "لا"
        yesButton.Text = "نعم حل عني"
        copyButton.Text = "نسخ"
    else
        confirmText.Text = "Close Script?"
        noButton.Text = "No"
        yesButton.Text = "Yes, Leave"
        copyButton.Text = "Copy"
    end
end

closeButton.MouseButton1Click:Connect(function()
    confirmFrame.Visible = true
end)

noButton.MouseButton1Click:Connect(function()
    confirmFrame.Visible = false
end)

yesButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

------------------------------------------------------------------
-- 5. أزرار التحكم
------------------------------------------------------------------
local buttonsData = {}

local function createToggle(nameAR, nameEN, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 32)
    btn.Position = UDim2.new(0.075, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = (currentLang == "AR") and (nameAR .. ": متوقف") or (nameEN .. ": OFF")
    btn.Parent = mainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    local active = false
    table.insert(buttonsData, {
        button = btn,
        nameAR = nameAR,
        nameEN = nameEN,
        getActive = function() return active end
    })
    
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            btn.Text = (currentLang == "AR") and (nameAR .. ": مفعل") or (nameEN .. ": ON")
            showNotification("[PHANTOM]: تم تفعيل " .. nameAR, "[PHANTOM]: Enabled " .. nameEN)
        else
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.Text = (currentLang == "AR") and (nameAR .. ": متوقف") or (nameEN .. ": OFF")
            showNotification("[PHANTOM]: تم إيقاف " .. nameAR, "[PHANTOM]: Disabled " .. nameEN)
        end
        callback(active)
    end)
    return btn
end

local wanderRunning = false
local antiVoidActive = false
local antiSitActive = false
local antiDeathActive = false
local antiKickActive = false
local antiAfkActive = false
local camSpinActive = false
local speedBoostActive = false

------------------------------------------------------------------
-- 6. ميزة AFK فوق رأس اللاعب
------------------------------------------------------------------
local afkBillboard = nil

local function updateAfkTag(state)
    local char = player.Character
    if state then
        if char and not char:FindFirstChild("PhantomAFKTag") then
            local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
            if head then
                local bb = Instance.new("BillboardGui")
                bb.Name = "PhantomAFKTag"
                bb.Size = UDim2.new(0, 100, 0, 40)
                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                bb.AlwaysOnTop = true
                bb.Adornee = head
                bb.Parent = char

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                lbl.TextSize = 16
                lbl.Font = Enum.Font.GothamBold
                lbl.Text = "AFK 💤"
                lbl.Parent = bb

                local stroke = Instance.new("UIStroke")
                stroke.Color = Color3.fromRGB(0, 0, 0)
                stroke.Thickness = 2
                stroke.Parent = lbl
                
                afkBillboard = bb
            end
        end
    else
        if afkBillboard then
            afkBillboard:Destroy()
            afkBillboard = nil
        end
        if char and char:FindFirstChild("PhantomAFKTag") then
            char.PhantomAFKTag:Destroy()
        end
    end
end

player.CharacterAdded:Connect(function(newChar)
    task.wait(1)
    if wanderRunning then
        updateAfkTag(true)
    end
end)

local b1 = createToggle("حركة ذكية (تجنب الجدران)", "Smart Wander (Avoid Walls)", 68, function(state) 
    wanderRunning = state 
    updateAfkTag(state)
end)
local b2 = createToggle("مضاد فويد (Anti-Void)", "Anti-Void", 108, function(state) antiVoidActive = state end)
local b3 = createToggle("مضاد جلوس (Anti-Sit)", "Anti-Sit", 148, function(state) antiSitActive = state end)
local b4 = createToggle("مضاد موت (Anti-Death)", "Anti-Death", 188, function(state) antiDeathActive = state end)
local b5 = createToggle("مضاد طرد (Anti-Kick)", "Anti-Kick", 228, function(state) antiKickActive = state end)
local b6 = createToggle("مضاد إفك (Anti-AFK)", "Anti-AFK", 268, function(state) antiAfkActive = state end)
local b7 = createToggle("دوران الكاميرا الخفي", "Hidden Camera Spin", 308, function(state) camSpinActive = state end)
local b8 = createToggle("سرعة المشي الوهمية", "Fake WalkSpeed Boost", 348, function(state) speedBoostActive = state end)

local function setLanguage(lang)
    currentLang = lang
    langFrame:Destroy()
    toggleButton.Visible = true
    
    for _, item in ipairs(buttonsData) do
        local isActive = item.getActive()
        if lang == "AR" then
            if isActive then
                item.button.Text = item.nameAR .. ": مفعل"
            else
                item.button.Text = item.nameAR .. ": متوقف"
            end
        else
            if isActive then
                item.button.Text = item.nameEN .. ": ON"
            else
                item.button.Text = item.nameEN .. ": OFF"
            end
        end
    end
    updateCloseDialogLang()
end

arButton.MouseButton1Click:Connect(function()
    setLanguage("AR")
end)

enButton.MouseButton1Click:Connect(function()
    setLanguage("EN")
end)

minButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    b1.Visible = not isMinimized
    b2.Visible = not isMinimized
    b3.Visible = not isMinimized
    b4.Visible = not isMinimized
    b5.Visible = not isMinimized
    b6.Visible = not isMinimized
    b7.Visible = not isMinimized
    b8.Visible = not isMinimized
    
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 240, 0, 50)
        minButton.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 240, 0, 435)
        minButton.Text = "-"
    end
end)

toggleButton.MouseButton1Click:Connect(function()
    if not pDragging then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

------------------------------------------------------------------
-- 7. الوظائف والخوارزميات الخلفية (معدلة ومضمونة لحركة الكاميرا)
------------------------------------------------------------------

-- ميزة دوران الكاميرا المضمونة (عبر محاكاة الأسهم أو تغيير زاوية الرؤية بمرونة)
task.spawn(function()
    while true do
        task.wait(math.random(6, 12))
        if camSpinActive then
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- تحريك الكاميرا بسلاسة عبر تدوير الـ CFrame الخاص بها حول الشخصية
                    local hrp = char.HumanoidRootPart
                    local currentCam = workspace.CurrentCamera
                    local angle = math.rad(math.random(-35, 35))
                    currentCam.CFrame = currentCam.CFrame * CFrame.Angles(0, angle, 0)
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.5)
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            if speedBoostActive then
                char.Humanoid.WalkSpeed = 18
            else
                char.Humanoid.WalkSpeed = 16
            end
        end
    end
end)

local function getSafePosition(rootPart)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    if player.Character then
        raycastParams.FilterDescendantsInstances = {player.Character}
    end

    for i = 1, 6 do
        local randomX = math.random(-18, 18)
        local randomZ = math.random(-18, 18)
        local direction = Vector3.new(randomX, 0, randomZ)
        local raycastResult = workspace:Raycast(rootPart.Position, direction, raycastParams)
        
        if not raycastResult then
            return rootPart.Position + direction
        end
    end
    return rootPart.Position + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))
end

task.spawn(function()
    while true do
        if wanderRunning then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
                local humanoid = character.Humanoid
                local rootPart = character.HumanoidRootPart
                
                local randomWait = math.random(3, 7)
                task.wait(randomWait)
                
                if wanderRunning then
                    local actionChoice = math.random(1, 2)
                    if actionChoice == 1 then
                        local safePos = getSafePosition(rootPart)
                        humanoid:MoveTo(safePos)
                    else
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.4)
        if antiVoidActive then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                if rootPart.Position.Y < -50 then
                    local raycastParams = RaycastParams.new()
                    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                    raycastParams.FilterDescendantsInstances = {character}
                    
                    local startRayPos = Vector3.new(rootPart.Position.X, 300, rootPart.Position.Z)
                    local raycastResult = workspace:Raycast(startRayPos, Vector3.new(0, -500, 0), raycastParams)
                    
                    if raycastResult then
                        rootPart.CFrame = CFrame.new(raycastResult.Position + Vector3.new(0, 5, 0))
                    else
                        rootPart.CFrame = rootPart.CFrame + Vector3.new(0, 150, 0)
                    end
                    
                    showNotification("[PHANTOM]: تم إنقاذك وإعادتك لأقرب أرضية!", "[PHANTOM]: Saved and returned to nearest ground!")
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.2)
        if antiSitActive then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid.Sit = false
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if antiDeathActive then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                if character.Humanoid.Health <= 5 and character.Humanoid.Health > 0 then
                    character.Humanoid.Health = character.Humanoid.MaxHealth
                end
            end
        end
    end
end)

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if antiKickActive and method == "Kick" and self == player then
        showNotification("[PHANTOM]: تم التصدي لمحاولة طرد!", "[PHANTOM]: Blocked a kick attempt!")
        return nil
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

player.Idled:Connect(function()
    if antiAfkActive then
        vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait(0.1)
        vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end
end)
