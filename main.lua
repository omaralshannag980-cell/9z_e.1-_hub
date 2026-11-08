--[[════════════════════════════════════════════════════════════════════
    ╔═══════════════════════════════════════════════════════════════╗
    ║         LANSHER HUB  ·  SURVIVAL + TRACKER EDITION            ║
    ║                     الإصدار: v5.1.0                           ║
    ║                                                               ║
    ║   🛡️ حماية من الطرد (4 طبقات)                                  ║
    ║   📡 تحسين الشبكة وتقليل البينج                                 ║
    ║   📜 السكربتات العربية + بروك                                   ║
    ║   ⚡ أوامر سريعة                                               ║
    ║   👥 تسجيل اللاعبين (50 خانة) - جديد!                           ║
    ╚═══════════════════════════════════════════════════════════════╝
════════════════════════════════════════════════════════════════════]]

--══════════════════════════════════════════════════════════════════
-- SECTION 1: SERVICES
--══════════════════════════════════════════════════════════════════
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local Workspace        = game:GetService("Workspace")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")
local TeleportService  = game:GetService("TeleportService")
local VirtualUser      = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

local RGB = Color3.fromRGB
local U2  = UDim2.new
local UD  = UDim.new
local V2  = Vector2.new
local V3  = Vector3.new
local New = Instance.new
local TI  = TweenInfo.new
local KC  = Enum.KeyCode
local ES  = Enum.EasingStyle
local ED  = Enum.EasingDirection

--══════════════════════════════════════════════════════════════════
-- SECTION 2: CONFIG
--══════════════════════════════════════════════════════════════════
local CFG = {
    Hub_Name    = "Lansher Hub",
    Hub_Version = "v5.1.0 Survival",
    Toggle_Key  = KC.RightShift,

    Cor_Hub     = RGB(15, 15, 15),
    Cor_Options = RGB(28, 28, 28),
    Cor_Stroke  = RGB(255, 50, 50),
    Cor_Text    = RGB(255, 255, 255),
    Cor_Dark    = RGB(150, 150, 150),
    Cor_Success = RGB(50, 220, 130),
    Cor_Warn    = RGB(255, 180, 50),
    Cor_Error   = RGB(255, 70, 70),

    Font   = Enum.Font.FredokaOne,
    Corner = UD(0, 12),
}

--══════════════════════════════════════════════════════════════════
-- SECTION 3: HELPERS
--══════════════════════════════════════════════════════════════════
local function Create(cls, parent, props)
    local o = Instance.new(cls, parent)
    if props then for k, v in pairs(props) do o[k] = v end end
    return o
end

local function Corner(parent, radius)
    local c = New("UICorner", parent)
    c.CornerRadius = radius or CFG.Corner
    return c
end

local function Stroke(parent)
    local s = New("UIStroke", parent)
    s.Color = CFG.Cor_Stroke
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Thickness = 2
    return s
end

local function Tween(obj, prop, value, time, wait)
    local t = TweenService:Create(obj, TI(time or 0.2, ES.Linear), {[prop] = value})
    t:Play()
    if wait then t.Completed:Wait() end
    return t
end

--══════════════════════════════════════════════════════════════════
-- SECTION 4: NOTIFICATIONS
--══════════════════════════════════════════════════════════════════
local function Notify(title, text, kind, dur)
    local gui = CoreGui:FindFirstChild("LansherNotifs")
    if not gui then
        gui = Create("ScreenGui", CoreGui, {Name = "LansherNotifs", ResetOnSpawn = false, DisplayOrder = 999})
        local frame = Create("Frame", gui, {
            Size = U2(0, 280, 1, -20),
            Position = U2(1, -290, 0, 10),
            BackgroundTransparency = 1,
        })
        Create("UIListLayout", frame, {Padding = UDim.new(0, 6), VerticalAlignment = Enum.VerticalAlignment.Bottom})
    end
    local container = gui:FindFirstChildOfClass("Frame")
    local colors = {info = CFG.Cor_Stroke, success = CFG.Cor_Success, warn = CFG.Cor_Warn, error = CFG.Cor_Error}
    local col = colors[kind] or colors.info

    local n = Create("Frame", container, {
        Size = U2(1, 0, 0, 60),
        BackgroundColor3 = CFG.Cor_Hub,
        BorderSizePixel = 0,
    })
    Corner(n)
    local accent = Create("Frame", n, {Size = U2(0, 4, 1, 0), BackgroundColor3 = col, BorderSizePixel = 0})
    Corner(accent, UD(1, 0))
    Create("TextLabel", n, {
        Size = U2(1, -20, 0, 20), Position = U2(0, 10, 0, 6),
        BackgroundTransparency = 1, Text = title, TextColor3 = CFG.Cor_Text,
        Font = CFG.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    })
    Create("TextLabel", n, {
        Size = U2(1, -20, 0, 30), Position = U2(0, 10, 0, 26),
        BackgroundTransparency = 1, Text = text, TextColor3 = col,
        Font = CFG.Font, TextSize = 11, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    task.delay(dur or 3, function()
        Tween(n, "BackgroundTransparency", 1, 0.3)
        for _, c in ipairs(n:GetChildren()) do
            if c:IsA("TextLabel") then Tween(c, "TextTransparency", 1, 0.3) end
        end
        task.wait(0.35)
        n:Destroy()
    end)
end

local function safeNotify(t, txt, k, d) pcall(Notify, t, txt, k, d) end

--══════════════════════════════════════════════════════════════════
-- SECTION 5: SURVIVAL CORE (4 طبقات حماية)
--══════════════════════════════════════════════════════════════════

-- الطبقة 1: تعطيل Idle Kick
local function DisableIdleKick()
    local ok, conns = pcall(function() return getconnections(LocalPlayer.Idled) end)
    if ok and conns then
        for _, conn in pairs(conns) do
            pcall(function() conn:Disable() end)
        end
        return true
    end
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(V2(0, 0))
    end)
    return false
end

-- الطبقة 2: اعتراض دوال الطرد
local function HookKick()
    pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if (method == "Kick" or method == "Ban") and self == LocalPlayer then
                warn("[Lansher] تم اعتراض محاولة طرد!")
                return nil
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
end

-- الطبقة 3: إزالة شاشة الطرد
local function RemoveKickScreen()
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(function()
                for _, gui in pairs(CoreGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        local name = gui.Name:lower()
                        if name:match("kick") or name:match("ban") or name:match("disconnect") then
                            gui:Destroy()
                        end
                    end
                end
            end)
        end
    end)
end

-- الطبقة 4: Auto-Rejoin
local function SetupRejoin()
    getgenv().Lansher_LastJobId = game.JobId
    getgenv().Lansher_LastPlaceId = game.PlaceId
end

-- تحسين الشبكة
local function OptimizeNetwork()
    pcall(function()
        settings().Network.IncomingReplicationLag = -1000
    end)
end

local function OptimizeFFlags()
    pcall(function()
        if setfflag then
            setfflag("DFIntTaskSchedulerTargetFps", "99999")
            setfflag("DFIntS2PhysicsSenderRate", "1")
        end
    end)
end

-- Anti-Crash
local function EnableAntiCrash()
    task.spawn(function()
        while true do
            task.wait(5)
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") then
                        obj.Enabled = false
                    end
                end
            end)
        end
    end)
end

-- تشغيل كل الحمايات
DisableIdleKick()
HookKick()
RemoveKickScreen()
SetupRejoin()
OptimizeNetwork()
OptimizeFFlags()
EnableAntiCrash()

--══════════════════════════════════════════════════════════════════
-- SECTION 6: BUILD UI
--══════════════════════════════════════════════════════════════════
local oldGui = CoreGui:FindFirstChild("LansherHubXR7")
if oldGui then oldGui:Destroy() end

local ScreenGui = Create("ScreenGui", CoreGui, {
    Name = "LansherHubXR7",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

-- زر الفتح
local OpenBtn = Create("ImageButton", ScreenGui, {
    Size = U2(0, 60, 0, 60),
    Position = U2(0, 30, 0.5, -30),
    BackgroundColor3 = CFG.Cor_Options,
    Image = "rbxassetid://106176016019821",
    Draggable = true,
    AutoButtonColor = false,
})
Corner(OpenBtn, UD(1, 0))
Stroke(OpenBtn)

-- النافذة
local Menu = Create("Frame", ScreenGui, {
    Size = U2(0, 560, 0, 460),
    Position = U2(0.5, -280, 0.5, -230),
    BackgroundColor3 = CFG.Cor_Hub,
    Visible = false,
    Active = true,
    Draggable = true,
})
Corner(Menu)
Stroke(Menu)

-- شريط العنوان
local TopBar = Create("Frame", Menu, {Size = U2(1, 0, 0, 30), BackgroundTransparency = 1})
Create("TextLabel", TopBar, {
    Size = U2(1, -60, 1, 0), Position = U2(0, 10, 0, 0),
    BackgroundTransparency = 1, Text = CFG.Hub_Name .. " " .. CFG.Hub_Version,
    TextColor3 = CFG.Cor_Stroke, Font = CFG.Font, TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
})
local CloseBtn = Create("TextButton", TopBar, {
    Size = U2(0, 30, 0, 30), Position = U2(1, -35, 0, 0),
    BackgroundTransparency = 1, Text = "×", TextColor3 = CFG.Cor_Text,
    Font = CFG.Font, TextSize = 22,
})
CloseBtn.MouseButton1Click:Connect(function() Menu.Visible = false end)
OpenBtn.MouseButton1Click:Connect(function() Menu.Visible = not Menu.Visible end)

-- التابات
local TabFrame = Create("Frame", Menu, {
    Size = U2(0, 150, 1, -30), Position = U2(0, 0, 0, 30),
    BackgroundColor3 = CFG.Cor_Options,
})
Corner(TabFrame)
Create("UIListLayout", TabFrame, {Padding = UDim.new(0, 4)})
Create("UIPadding", TabFrame, {
    PaddingTop = UDim.new(0, 8),
    PaddingLeft = UDim.new(0, 8),
    PaddingRight = UDim.new(0, 8),
})

local Content = Create("Frame", Menu, {
    Size = U2(1, -150, 1, -30), Position = U2(0, 150, 0, 30),
    BackgroundTransparency = 1,
})

local tabs = {}
local function MakeTab(name)
    local btn = Create("TextButton", TabFrame, {
        Size = U2(1, 0, 0, 30), BackgroundColor3 = CFG.Cor_Hub,
        Text = name, TextColor3 = CFG.Cor_Text, Font = CFG.Font, TextSize = 13,
        AutoButtonColor = false,
    })
    Corner(btn)
    local frame = Create("ScrollingFrame", Content, {
        Size = U2(1, 0, 1, 0), BackgroundTransparency = 1,
        ScrollBarThickness = 4, CanvasSize = U2(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false,
    })
    Create("UIPadding", frame, {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
    })
    Create("UIListLayout", frame, {Padding = UDim.new(0, 5)})
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.frame.Visible = false
            t.btn.BackgroundColor3 = CFG.Cor_Hub
        end
        frame.Visible = true
        btn.BackgroundColor3 = CFG.Cor_Stroke
    end)
    table.insert(tabs, {btn = btn, frame = frame})
    return frame
end

-- التابات الستة
local TabSurvival = MakeTab("🛡️ البقاء")
local TabScripts  = MakeTab("📜 السكربتات")
local TabCommands = MakeTab("⚡ الأوامر")
local TabAnti     = MakeTab("🛡️ المضادات")
local TabBrook    = MakeTab("🌉 بروك")
local TabTracker  = MakeTab("👥 تسجيل اللاعبين")

-- تفعيل تاب البقاء
TabSurvival.Visible = true
tabs[1].btn.BackgroundColor3 = CFG.Cor_Stroke

--══════════════════════════════════════════════════════════════════
-- SECTION 7: WIDGETS
--══════════════════════════════════════════════════════════════════
local function AddButton(parent, name, callback)
    local btn = Create("TextButton", parent, {
        Size = U2(1, 0, 0, 30), BackgroundColor3 = CFG.Cor_Options,
        Text = "  " .. name, TextColor3 = CFG.Cor_Text, Font = CFG.Font,
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
    })
    Corner(btn)
    Stroke(btn)
    btn.MouseButton1Click:Connect(function() pcall(callback) end)
    return btn
end

local function AddLabel(parent, text)
    return Create("TextLabel", parent, {
        Size = U2(1, 0, 0, 22), BackgroundTransparency = 1,
        Text = "  ◆ " .. text, TextColor3 = CFG.Cor_Stroke,
        Font = CFG.Font, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    })
end

local function AddTextbox(parent, placeholder, callback)
    local box = Create("TextBox", parent, {
        Size = U2(1, 0, 0, 30), BackgroundColor3 = CFG.Cor_Options,
        PlaceholderText = placeholder, Text = "", TextColor3 = CFG.Cor_Text,
        Font = CFG.Font, TextSize = 13, ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    Corner(box)
    Stroke(box)
    Create("UIPadding", box, {PaddingLeft = UDim.new(0, 10)})
    box.FocusLost:Connect(function(enter)
        if enter then pcall(callback, box.Text) end
    end)
    return box
end

local function AddToggle(parent, name, default, callback)
    local state = default or false
    local frame = Create("Frame", parent, {Size = U2(1, 0, 0, 30), BackgroundColor3 = CFG.Cor_Options})
    Corner(frame)
    Stroke(frame)
    Create("TextLabel", frame, {
        Size = U2(1, -60, 1, 0), Position = U2(0, 10, 0, 0),
        BackgroundTransparency = 1, Text = name, TextColor3 = CFG.Cor_Text,
        Font = CFG.Font, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local sw = Create("TextButton", frame, {
        Size = U2(0, 40, 0, 20), Position = U2(1, -50, 0.5, -10),
        BackgroundColor3 = state and CFG.Cor_Stroke or RGB(60, 60, 60),
        Text = "", AutoButtonColor = false,
    })
    Corner(sw, UD(1, 0))
    local knob = Create("Frame", sw, {
        Size = U2(0, 16, 0, 16),
        Position = state and U2(0, 22, 0, 2) or U2(0, 2, 0, 2),
        BackgroundColor3 = RGB(255, 255, 255),
    })
    Corner(knob, UD(1, 0))
    sw.MouseButton1Click:Connect(function()
        state = not state
        Tween(sw, "BackgroundColor3", state and CFG.Cor_Stroke or RGB(60, 60, 60), 0.15)
        Tween(knob, "Position", state and U2(0, 22, 0, 2) or U2(0, 2, 0, 2), 0.15)
        pcall(callback, state)
    end)
end

--══════════════════════════════════════════════════════════════════
-- SECTION 8: SURVIVAL TAB
--══════════════════════════════════════════════════════════════════
AddLabel(TabSurvival, "حالة الحماية (نشطة تلقائياً)")

AddButton(TabSurvival, "✅ تفعيل كل الحمايات يدوياً", function()
    DisableIdleKick()
    HookKick()
    RemoveKickScreen()
    SetupRejoin()
    OptimizeNetwork()
    OptimizeFFlags()
    EnableAntiCrash()
    safeNotify("Survival", "تم تفعيل جميع الحمايات", "success", 3)
end)

AddButton(TabSurvival, "🔄 إعادة الاتصال بالسيرفر", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

AddButton(TabSurvival, "📊 عرض حالة الحماية", function()
    safeNotify("الحمايات النشطة",
        "Anti-Kick ✅\nAnti-AFK ✅\nAnti-Crash ✅\nNetwork Boost ✅\nAuto-Rejoin ✅",
        "info", 5)
end)

AddLabel(TabSurvival, "تحسين الشبكة")
AddButton(TabSurvival, "⚡ تحسين الشبكة (Ping)", function()
    pcall(function()
        settings().Network.IncomingReplicationLag = -1000
        safeNotify("الشبكة", "تم تقليل التأخير", "success", 2)
    end)
end)

AddButton(TabSurvival, "⚡ تحسين FFlags", function()
    pcall(function()
        if setfflag then
            setfflag("DFIntTaskSchedulerTargetFps", "99999")
            safeNotify("FFlags", "تم التحسين", "success", 2)
        end
    end)
end)

AddLabel(TabSurvival, "Anti-AFK")
AddToggle(TabSurvival, "Anti-AFK تلقائي", true, function(v)
    if v then
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(V2(0, 0))
        end)
    end
end)

AddLabel(TabSurvival, "الطوارئ")
AddButton(TabSurvival, "💾 حفظ الموقع الحالي", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        getgenv().Lansher_EmergencyPos = hrp.CFrame
        safeNotify("حفظ", "تم حفظ الموقع", "success", 2)
    end
end)

AddButton(TabSurvival, "🏠 العودة للموقع المحفوظ", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and getgenv().Lansher_EmergencyPos then
        hrp.CFrame = getgenv().Lansher_EmergencyPos
        safeNotify("عودة", "تمت العودة", "success", 2)
    end
end)

--══════════════════════════════════════════════════════════════════
-- SECTION 9: SCRIPTS TAB
--══════════════════════════════════════════════════════════════════
AddLabel(TabScripts, "سكربتات عربية")
AddButton(TabScripts, "سكربت زيكو", function() loadstring(game:HttpGet('https://pastefy.app/mXMaE9fC/raw'))() end)
AddButton(TabScripts, "سكربت عسكر", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-3skr-hub-240894"))() end)
AddButton(TabScripts, "سكربت جحيم الأساسي", function() loadstring(game:HttpGet("https://gist.githubusercontent.com/adamoalihossen-lang/1fcc9f47858217b73c7d21396347ee41/raw"))() end)
AddButton(TabScripts, "سكربت حكومة", function() loadstring(game:HttpGet('https://pastebin.com/raw/FMC7ZWsw'))() end)
AddButton(TabScripts, "سكربت انصاري", function() loadstring(game:HttpGet("https://gist.githubusercontent.com/Yemenx/e976b6c7c681e67ebe0f31f88ebb6ac6/raw/536a222c673c23ba43ebe29dfcc29a53c8808eea/ANSRY.YAMEN.VAMPAIRE.lua"))() end)
AddButton(TabScripts, "سكربت أبو عتب", function() loadstring(game:HttpGet("https://gist.githubusercontent.com/yhmwd406-boop/2dd250fe58d63fabee981b085afc10c5/raw/8bf78e204f3f04cac8bea68e887a95f41c8b81c4/%25D8%25B3%25D9%2583%25D8%25B1%25D8%25A8%25D8%25AA%2520%25D8%25B9%25D8%25AF%25D8%25A7%25D8%25A7%25D8%25AA"))() end)
AddButton(TabScripts, "سكربت داركو", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Zenix-all-on-one-240296"))() end)
AddButton(TabScripts, "سكربت نقاط مراد", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-NO9AT-SAMLAT-47637"))() end)

AddLabel(TabScripts, "أدوات مساعدة")
AddButton(TabScripts, "تشغيل وتخفيف لاق", function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
    end
    safeNotify("تخفيف اللاق", "تم", "success", 2)
end)

--══════════════════════════════════════════════════════════════════
-- SECTION 10: COMMANDS TAB
--══════════════════════════════════════════════════════════════════
AddLabel(TabCommands, "أوامر سريعة")

local cmdBox = AddTextbox(TabCommands, "اكتب أمر... (speed 100)", function(text)
    local args = {}
    for w in text:gmatch("%S+") do table.insert(args, w) end
    local cmd = args[1] and args[1]:lower() or ""
    local val = tonumber(args[2]) or 0

    if cmd == "speed" and val > 0 then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = val; safeNotify("أمر", "السرعة: " .. val, "success", 2) end
    elseif cmd == "jump" and val > 0 then
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.JumpPower = val; safeNotify("أمر", "القفز: " .. val, "success", 2) end
    elseif cmd == "kickprotect" then
        DisableIdleKick()
        safeNotify("أمر", "تم تفعيل الحماية", "success", 2)
    elseif cmd == "rejoin" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    elseif cmd == "ping" then
        local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        safeNotify("البينج", "البينج: " .. tostring(ping), "info", 4)
    else
        safeNotify("أمر غير معروف", "جرب: speed / jump / kickprotect / rejoin / ping", "warn", 3)
    end
end)

AddLabel(TabCommands, "أوامر جاهزة")
AddButton(TabCommands, "أمر: speed 100", function() cmdBox.Text = "speed 100" end)
AddButton(TabCommands, "أمر: jump 200", function() cmdBox.Text = "jump 200" end)
AddButton(TabCommands, "أمر: kickprotect", function() cmdBox.Text = "kickprotect" end)
AddButton(TabCommands, "أمر: rejoin", function() cmdBox.Text = "rejoin" end)
AddButton(TabCommands, "أمر: ping", function() cmdBox.Text = "ping" end)

--══════════════════════════════════════════════════════════════════
-- SECTION 11: ANTI TAB
--══════════════════════════════════════════════════════════════════
AddLabel(TabAnti, "مضادات أساسية")

AddButton(TabAnti, "مضاد تطير", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5)
        safeNotify("مضاد تطير", "تم", "success", 2)
    end
end)

AddButton(TabAnti, "مضاد افك (Anti-AFK)", function()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(V2(0, 0), Camera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(V2(0, 0), Camera.CFrame)
    end)
    safeNotify("Anti-AFK", "مفعّل", "success", 2)
end)

AddButton(TabAnti, "مضاد موت", function()
    local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if h then h.MaxHealth = math.huge; h.Health = math.huge end
    safeNotify("Anti-Death", "مفعّل", "success", 2)
end)

AddLabel(TabAnti, "مضادات متقدمة")

AddButton(TabAnti, "مضاد Freeze", function()
    task.spawn(function()
        while true do
            task.wait(0.1)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Anchored then hrp.Anchored = false end
        end
    end)
    safeNotify("Anti-Freeze", "مفعّل", "success", 2)
end)

AddButton(TabAnti, "مضاد Void", function()
    task.spawn(function()
        while true do
            task.wait(0.5)
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y < -100 then hrp.CFrame = CFrame.new(0, 10, 0) end
        end
    end)
    safeNotify("Anti-Void", "مفعّل", "success", 2)
end)

--══════════════════════════════════════════════════════════════════
-- SECTION 12: BROOK TAB
--══════════════════════════════════════════════════════════════════
AddLabel(TabBrook, "سكربتات بروك هافن")
AddButton(TabBrook, "سكربت عزام", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-3azaam-hub-224262"))() end)
AddButton(TabBrook, "سكربت ميكي شات", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-Mickey-Chat-85762"))() end)
AddButton(TabBrook, "سكربت REXM", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-REXM-206004"))() end)
AddButton(TabBrook, "سكربت ABD HUB", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ABD-HUB-PRO-238979"))() end)
AddButton(TabBrook, "طيران عدنان", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Flying-55336"))() end)
AddButton(TabBrook, "سكربت JG", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-New-Update-Script-JG-Brookhaven-93130"))() end)
AddButton(TabBrook, "رافكس سكربت", function() loadstring(game:HttpGet("https://rawscripts.net/raw/Brookhaven-RP-RAVEX-HUB-ARAB-NOW-86210"))() end)

--══════════════════════════════════════════════════════════════════
-- SECTION 13: TRACKER TAB (تسجيل اللاعبين - 50 خانة)
--══════════════════════════════════════════════════════════════════
AddLabel(TabTracker, "تسجيل اللاعبين — 50 خانة")
AddLabel(TabTracker, "اكتب اسم اللاعب واضغط Start لبدء التتبع")

local TrackerScroll = Create("ScrollingFrame", TabTracker, {
    Size = U2(1, 0, 0, 400),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    CanvasSize = U2(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
})
Create("UIPadding", TrackerScroll, {
    PaddingTop = UDim.new(0, 5),
    PaddingLeft = UDim.new(0, 5),
    PaddingRight = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 5),
})
Create("UIListLayout", TrackerScroll, {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder,
})

-- دالة جلب ID اللاعب من الاسم
local function getUserIdFromName(name)
    local player = Players:FindFirstChild(name)
    if player then return player.UserId end

    local ok, userId = pcall(function()
        return Players:GetUserIdFromNameAsync(name)
    end)
    if ok and userId then return userId end

    local ok2, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://api.roblox.com/users/get-by-username?username=" .. name))
    end)
    if ok2 and result and result.Id then return result.Id end

    return nil
end

local Slots = {}
local NUM_SLOTS = 50

local function updateCounter(index, kind)
    local slot = Slots[index]
    if not slot or not slot.active then return end

    if kind == "join" then
        slot.joins = slot.joins + 1
        slot.joinsLabel.Text = "الدخول: " .. slot.joins
    elseif kind == "leave" then
        slot.leaves = slot.leaves + 1
        slot.leavesLabel.Text = "الخروج: " .. slot.leaves
    end
end

local function createTrackerSlot(index)
    local slotFrame = Create("Frame", TrackerScroll, {
        Size = U2(1, 0, 0, 60),
        BackgroundColor3 = CFG.Cor_Options,
        BorderSizePixel = 0,
        LayoutOrder = index,
    })
    Corner(slotFrame)
    Stroke(slotFrame)

    -- رقم الخانة
    Create("TextLabel", slotFrame, {
        Size = U2(0, 30, 0, 30),
        Position = U2(0, 5, 0, 5),
        BackgroundTransparency = 1,
        Text = "#" .. index,
        TextColor3 = CFG.Cor_Stroke,
        Font = CFG.Font,
        TextSize = 12,
    })

    -- مربع الكتابة
    local textBox = Create("TextBox", slotFrame, {
        Size = U2(1, -135, 0, 26),
        Position = U2(0, 40, 0, 7),
        BackgroundColor3 = CFG.Cor_Hub,
        Text = "",
        PlaceholderText = "اكتب اسم اللاعب...",
        PlaceholderColor3 = CFG.Cor_Dark,
        TextColor3 = CFG.Cor_Text,
        Font = CFG.Font,
        TextSize = 12,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    Corner(textBox)
    Stroke(textBox)
    Create("UIPadding", textBox, {PaddingLeft = UDim.new(0, 8)})

    -- زر Start
    local startBtn = Create("TextButton", slotFrame, {
        Size = U2(0, 80, 0, 26),
        Position = U2(1, -90, 0, 7),
        BackgroundColor3 = CFG.Cor_Stroke,
        Text = "Start",
        TextColor3 = CFG.Cor_Text,
        Font = CFG.Font,
        TextSize = 12,
        AutoButtonColor = false,
    })
    Corner(startBtn)

    -- زر الإعادة
    local resetBtn = Create("TextButton", slotFrame, {
        Size = U2(0, 20, 0, 20),
        Position = U2(1, -25, 0, 10),
        BackgroundColor3 = CFG.Cor_Error,
        Text = "×",
        TextColor3 = CFG.Cor_Text,
        Font = CFG.Font,
        TextSize = 14,
        AutoButtonColor = false,
        Visible = false,
    })
    Corner(resetBtn)
    Stroke(resetBtn)

    -- إطار التفاصيل (يظهر عند التفعيل)
    local details = Create("Frame", slotFrame, {
        Size = U2(1, -10, 0, 0),
        Position = U2(0, 5, 0, 40),
        BackgroundTransparency = 1,
        Visible = false,
    })

    -- صورة اللاعب
    local avatar = Create("ImageLabel", details, {
        Size = U2(0, 60, 0, 60),
        Position = U2(0, 0, 0, 0),
        BackgroundColor3 = CFG.Cor_Hub,
        BorderSizePixel = 0,
        Image = "",
    })
    Corner(avatar)
    Stroke(avatar)

    -- اسم اللاعب تحت الصورة
    local usernameLabel = Create("TextLabel", details, {
        Size = U2(0, 60, 0, 16),
        Position = U2(0, 0, 0, 62),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = CFG.Cor_Text,
        Font = CFG.Font,
        TextSize = 10,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })

    -- عدّاد الدخول (فوق)
    local joinsLabel = Create("TextLabel", details, {
        Size = U2(1, -85, 0, 22),
        Position = U2(0, 75, 0, 5),
        BackgroundTransparency = 1,
        Text = "الدخول: 0",
        TextColor3 = CFG.Cor_Success,
        Font = CFG.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    -- عدّاد الخروج (تحت)
    local leavesLabel = Create("TextLabel", details, {
        Size = U2(1, -85, 0, 22),
        Position = U2(0, 75, 0, 32),
        BackgroundTransparency = 1,
        Text = "الخروج: 0",
        TextColor3 = CFG.Cor_Error,
        Font = CFG.Font,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    Slots[index] = {
        frame = slotFrame,
        textBox = textBox,
        startBtn = startBtn,
        resetBtn = resetBtn,
        details = details,
        avatar = avatar,
        usernameLabel = usernameLabel,
        joinsLabel = joinsLabel,
        leavesLabel = leavesLabel,
        active = false,
        name = nil,
        userId = nil,
        joins = 0,
        leaves = 0,
    }

    -- زر Start
    startBtn.MouseButton1Click:Connect(function()
        local name = textBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
        if name == "" then
            safeNotify("تنبيه", "اكتب اسم اللاعب أولاً", "warn", 2)
            return
        end

        safeNotify("بحث", "جاري البحث عن " .. name, "info", 2)

        local userId = getUserIdFromName(name)
        if not userId then
            safeNotify("خطأ", "لم يتم العثور على اللاعب: " .. name, "error", 3)
            return
        end

        local slot = Slots[index]
        slot.active = true
        slot.name = name
        slot.userId = userId
        slot.joins = 0
        slot.leaves = 0

        textBox.Text = name
        textBox.TextEditable = false
        startBtn.Visible = false
        resetBtn.Visible = true
        details.Visible = true

        slotFrame.Size = U2(1, 0, 0, 130)
        details.Size = U2(1, -10, 0, 85)

        avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=100&h=100"
        usernameLabel.Text = name
        joinsLabel.Text = "الدخول: 0"
        leavesLabel.Text = "الخروج: 0"

        safeNotify("تسجيل", "بدأ تتبع " .. name, "success", 3)
    end)

    -- زر الإعادة
    resetBtn.MouseButton1Click:Connect(function()
        local slot = Slots[index]
        slot.active = false
        slot.name = nil
        slot.userId = nil
        slot.joins = 0
        slot.leaves = 0

        textBox.Text = ""
        textBox.TextEditable = true
        startBtn.Visible = true
        resetBtn.Visible = false
        details.Visible = false

        slotFrame.Size = U2(1, 0, 0, 60)
        details.Size = U2(1, -10, 0, 0)

        safeNotify("إعادة تعيين", "تم مسح الخانة #" .. index, "info", 2)
    end)
end

-- إنشاء 50 خانة
for i = 1, NUM_SLOTS do
    createTrackerSlot(i)
end

-- ربط أحداث الدخول والخروج
Players.PlayerAdded:Connect(function(player)
    for i, slot in pairs(Slots) do
        if slot.active and slot.name and slot.name:lower() == player.Name:lower() then
            updateCounter(i, "join")
            safeNotify("دخول " .. slot.name, "المجموع: " .. slot.joins, "success", 3)
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    for i, slot in pairs(Slots) do
        if slot.active and slot.name and slot.name:lower() == player.Name:lower() then
            updateCounter(i, "leave")
            safeNotify("خروج " .. slot.name, "المجموع: " .. slot.leaves, "warn", 3)
        end
    end
end)

--══════════════════════════════════════════════════════════════════
-- SECTION 14: KEYBIND & INIT
--══════════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == CFG.Toggle_Key then
        Menu.Visible = not Menu.Visible
    end
end)

task.wait(2)
safeNotify("Lansher Hub", "v5.1 Survival + Tracker جاهز!", "success", 4)
task.wait(0.5)
safeNotify("Lansher Hub", "الحماية مفعّلة تلقائياً 🛡️", "success", 3)
task.wait(0.5)
safeNotify("Lansher Hub", "50 خانة لتسجيل اللاعبين 👥", "info", 3)
task.wait(0.5)
safeNotify("Lansher Hub", "اضغط " .. tostring(CFG.Toggle_Key) .. " للفتح", "info", 3)

print("[Lansher Hub v5.1 Survival + Tracker] Loaded successfully.")
