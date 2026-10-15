local Lib = {}
Lib.Version = "LzeSilent.UI v1.0.0"
Lib.Flags = {}
Lib.Windows = {}
Lib.Connections = {}
Lib.NotifyQueue = {}

Lib.Theme = {
    BG          = Color3.fromRGB(0, 0, 0),
    BG2         = Color3.fromRGB(10, 10, 10),
    BG3         = Color3.fromRGB(20, 20, 20),
    BG4         = Color3.fromRGB(28, 28, 28),
    Line        = Color3.fromRGB(255, 255, 255),
    LineDim     = Color3.fromRGB(40, 40, 40),
    Text        = Color3.fromRGB(255, 255, 255),
    TextDim     = Color3.fromRGB(130, 130, 130),
    Hover       = Color3.fromRGB(24, 24, 24),
    OK          = Color3.fromRGB(74, 222, 128),
    WARN        = Color3.fromRGB(251, 191, 36),
    ERR         = Color3.fromRGB(248, 113, 113),
    INFO        = Color3.fromRGB(96, 165, 250),
    Accent      = Color3.fromRGB(255, 255, 255)
}

Lib.Fonts = {
    Regular = Enum.Font.Gotham,
    Bold    = Enum.Font.GothamBold,
    Mono    = Enum.Font.Code
}

Lib.TI = {
    tap    = TweenInfo.new(0.09, Enum.EasingStyle.Quad,   Enum.EasingDirection.Out),
    fast   = TweenInfo.new(0.16, Enum.EasingStyle.Quad,   Enum.EasingDirection.Out),
    med    = TweenInfo.new(0.28, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
    soft   = TweenInfo.new(0.35, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
    drift  = TweenInfo.new(0.45, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
    slow   = TweenInfo.new(0.55, Enum.EasingStyle.Quint,  Enum.EasingDirection.Out),
    spring = TweenInfo.new(0.55, Enum.EasingStyle.Back,   Enum.EasingDirection.Out),
    inout  = TweenInfo.new(0.42, Enum.EasingStyle.Quint,  Enum.EasingDirection.InOut),
    roll   = TweenInfo.new(0.5,  Enum.EasingStyle.Quart,  Enum.EasingDirection.Out)
}

local Players      = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local HttpService  = game:GetService("HttpService")
local RunService   = game:GetService("RunService")
local LP           = Players.LocalPlayer
local PG           = LP:WaitForChild("PlayerGui")

local function inst(class, props, parent)
    local o = Instance.new(class)
    if props then
        for k, v in pairs(props) do
            pcall(function() o[k] = v end)
        end
    end
    if parent then o.Parent = parent end
    return o
end

local function stroke(p, col, th, tr, mode)
    return inst("UIStroke", {
        Color = col or Lib.Theme.Line,
        Thickness = th or 0.7,
        Transparency = tr or 0.15,
        ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
    }, p)
end

local function corner(p, r)
    return inst("UICorner", { CornerRadius = UDim.new(0, r or 3) }, p)
end

local function pad(p, n, n2, n3, n4)
    return inst("UIPadding", {
        PaddingTop = UDim.new(0, n or 0),
        PaddingBottom = UDim.new(0, n2 or n or 0),
        PaddingLeft = UDim.new(0, n3 or n or 0),
        PaddingRight = UDim.new(0, n4 or n or 0)
    }, p)
end

local function tw(o, ti, props)
    local t = TweenService:Create(o, ti, props)
    t:Play()
    return t
end

local function ripple(btn)
    pcall(function()
        local ax, ay = btn.AbsoluteSize.X, btn.AbsoluteSize.Y
        if not ax or not ay or ax <= 0 or ay <= 0 then return end
        local rip = inst("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 0.85,
            BorderSizePixel = 0,
            ZIndex = btn.ZIndex + 1
        }, btn)
        corner(rip, 9999)
        local m = math.max(ax, ay) * 2
        tw(rip, TweenInfo.new(0.42, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, m, 0, m),
            BackgroundTransparency = 1
        })
        task.delay(0.45, function()
            if rip and rip.Parent then rip:Destroy() end
        end)
    end)
end

local function makeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            local vp = frame.Parent and frame.Parent.AbsoluteSize or Vector2.new(1920, 1080)
            local nx = math.clamp(startPos.X.Scale * vp.X + startPos.X.Offset + d.X, 0, vp.X - 60)
            local ny = math.clamp(startPos.Y.Scale * vp.Y + startPos.Y.Offset + d.Y, 0, vp.Y - 30)
            frame.Position = UDim2.new(0, nx, 0, ny)
        end
    end)
end

local function rgbToHex(c)
    return string.format("#%02X%02X%02X",
        math.floor(c.R * 255 + 0.5),
        math.floor(c.G * 255 + 0.5),
        math.floor(c.B * 255 + 0.5))
end

local function hexToRgb(hex)
    hex = hex:gsub("#", "")
    if #hex ~= 6 then return nil end
    local r = tonumber(hex:sub(1, 2), 16)
    local g = tonumber(hex:sub(3, 4), 16)
    local b = tonumber(hex:sub(5, 6), 16)
    if not r or not g or not b then return nil end
    return Color3.fromRGB(r, g, b)
end

local function applyThemeRecursive(root)
    for _, d in ipairs(root:GetDescendants()) do
        pcall(function()
            if d:IsA("Frame") then
                if d.Name == "ThemeBG" then
                    tw(d, Lib.TI.med, { BackgroundColor3 = Lib.Theme.BG })
                elseif d.Name == "ThemeBG2" then
                    tw(d, Lib.TI.med, { BackgroundColor3 = Lib.Theme.BG2 })
                elseif d.Name == "ThemeBG3" then
                    tw(d, Lib.TI.med, { BackgroundColor3 = Lib.Theme.BG3 })
                elseif d.Name == "ThemeBG4" then
                    tw(d, Lib.TI.med, { BackgroundColor3 = Lib.Theme.BG4 })
                end
            elseif d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                if d.Name == "ThemeText" then
                    tw(d, Lib.TI.med, { TextColor3 = Lib.Theme.Text })
                elseif d.Name == "ThemeTextDim" then
                    tw(d, Lib.TI.med, { TextColor3 = Lib.Theme.TextDim })
                end
            end
        end)
    end
end

local notifyGui, notifyList

local function initNotify()
    if notifyGui and notifyGui.Parent then return end
    notifyGui = inst("ScreenGui", {
        Name = "LzeSilentNotify",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 9999
    }, PG)
    notifyList = inst("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.new(0, 260, 1, -32),
        BackgroundTransparency = 1
    }, notifyGui)
    inst("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
        VerticalAlignment = Enum.VerticalAlignment.Top,
        HorizontalAlignment = Enum.HorizontalAlignment.Right
    }, notifyList)
end

function Lib:Notify(cfg)
    cfg = cfg or {}
    initNotify()
    local title = cfg.Title or "Notification"
    local text  = cfg.Text or ""
    local dur   = cfg.Duration or 4
    local kind  = cfg.Type or "info"

    local accent = self.Theme.INFO
    if kind == "success" then accent = self.Theme.OK
    elseif kind == "warning" then accent = self.Theme.WARN
    elseif kind == "error" then accent = self.Theme.ERR end

    local card = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = self.Theme.BG,
        BorderSizePixel = 0,
        ClipsDescendants = true
    }, notifyList)
    corner(card, 4)
    stroke(card, self.Theme.Line, 0.7, 0.15)

    local bar = inst("Frame", {
        Size = UDim2.new(0, 3, 0, 0),
        BackgroundColor3 = accent,
        BorderSizePixel = 0
    }, card)
    corner(bar, 4)

    local tl = inst("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 14, 0, 8),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = self.Theme.Text,
        Font = self.Fonts.Bold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, card)

    local bl = inst("TextLabel", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 14, 0, 26),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = self.Theme.TextDim,
        Font = self.Fonts.Regular,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    }, card)

    task.defer(function()
        local h = math.max(44, 34 + (bl.AbsoluteSize.Y or 14))
        card.Size = UDim2.new(1, 0, 0, 0)
        card.Position = UDim2.new(0, 24, 0, 0)
        card.BackgroundTransparency = 1
        tl.TextTransparency = 1
        bl.TextTransparency = 1
        tw(card, Lib.TI.spring, {
            Size = UDim2.new(1, 0, 0, h),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 0
        })
        task.wait(0.1)
        tw(tl, Lib.TI.soft, { TextTransparency = 0 })
        tw(bl, Lib.TI.soft, { TextTransparency = 0 })
        tw(bar, Lib.TI.slow, { Size = UDim2.new(0, 3, 0, h) })
    end)

    task.delay(dur, function()
        pcall(function()
            local out = TweenService:Create(card, Lib.TI.inout, {
                Position = UDim2.new(0, 30, 0, 0),
                BackgroundTransparency = 1
            })
            out:Play()
            tw(tl, Lib.TI.med, { TextTransparency = 1 })
            tw(bl, Lib.TI.med, { TextTransparency = 1 })
            out.Completed:Connect(function()
                if card and card.Parent then card:Destroy() end
            end)
        end)
    end)
    return card
end

function Lib:SetTheme(tbl)
    for k, v in pairs(tbl) do
        if self.Theme[k] then self.Theme[k] = v end
    end
    for _, w in pairs(self.Windows) do
        if w.Gui and w.Gui.Parent then
            applyThemeRecursive(w.Gui)
        end
    end
end

function Lib:ResetTheme()
    self:SetTheme({
        BG      = Color3.fromRGB(0, 0, 0),
        BG2     = Color3.fromRGB(10, 10, 10),
        BG3     = Color3.fromRGB(20, 20, 20),
        BG4     = Color3.fromRGB(28, 28, 28),
        Line    = Color3.fromRGB(255, 255, 255),
        LineDim = Color3.fromRGB(40, 40, 40),
        Text    = Color3.fromRGB(255, 255, 255),
        TextDim = Color3.fromRGB(130, 130, 130),
        Hover   = Color3.fromRGB(24, 24, 24)
    })
end

local Section = {}
Section.__index = Section

local function updateSectionSize(sec)
    task.defer(function()
        local h = sec.Layout.AbsoluteContentSize.Y
        sec.Container.Size = UDim2.new(1, 0, 0, h)
        sec.Frame.Size = UDim2.new(1, 0, 0, h + 36)
    end)
end

local function mkElementFrame(parent, h)
    local f = inst("Frame", {
        Size = UDim2.new(1, 0, 0, h),
        BackgroundColor3 = Lib.Theme.BG3,
        BorderSizePixel = 0,
        Name = "ThemeBG3"
    }, parent)
    corner(f, 4)
    local s = stroke(f, Lib.Theme.Line, 0.6, 0.75)
    return f, s
end

local function addTitleDesc(frame, name, desc)
    local tl = inst("TextLabel", {
        Size = UDim2.new(1, -100, 0, 14),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Text = name,
        TextColor3 = Lib.Theme.Text,
        Font = Lib.Fonts.Regular,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Name = "ThemeText"
    }, frame)

    if desc and desc ~= "" then
        inst("TextLabel", {
            Size = UDim2.new(1, -20, 0, 12),
            Position = UDim2.new(0, 10, 0, 20),
            BackgroundTransparency = 1,
            Text = desc,
            TextColor3 = Lib.Theme.TextDim,
            Font = Lib.Fonts.Regular,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Name = "ThemeTextDim"
        }, frame)
        return tl, 34
    end
    return tl, 22
end

function Section:AddButton(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Button"
    local desc = cfg.Description
    local callback = cfg.Callback or function() end

    local f, s = mkElementFrame(self.Container, desc and 36 or 26)
    addTitleDesc(f, name, desc)

    local btn = inst("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 2
    }, f)

    btn.MouseEnter:Connect(function()
        tw(f, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.Hover })
        tw(s, Lib.TI.fast, { Transparency = 0.2 })
    end)
    btn.MouseLeave:Connect(function()
        tw(f, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.BG3 })
        tw(s, Lib.TI.fast, { Transparency = 0.75 })
    end)
    btn.MouseButton1Down:Connect(function()
        tw(f, Lib.TI.tap, { BackgroundColor3 = Lib.Theme.BG2 })
    end)
    btn.MouseButton1Up:Connect(function()
        tw(f, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.Hover })
    end)
    btn.MouseButton1Click:Connect(function()
        ripple(btn)
        pcall(callback)
    end)

    updateSectionSize(self)
    return { Frame = f, Button = btn }
end

function Section:AddToggle(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Toggle"
    local desc = cfg.Description
    local flag = cfg.Flag or name
    local default = cfg.Default or false
    local callback = cfg.Callback or function() end

    local f, s = mkElementFrame(self.Container, desc and 36 or 26)
    addTitleDesc(f, name, desc)

    local sw = inst("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 34, 0, 18),
        BackgroundColor3 = Lib.Theme.BG2,
        BorderSizePixel = 0,
        Name = "ThemeBG2"
    }, f)
    corner(sw, 9)
    local sws = stroke(sw, Lib.Theme.Line, 0.7, 0.5)

    local knob = inst("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 2, 0.5, 0),
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundColor3 = Lib.Theme.TextDim,
        BorderSizePixel = 0,
        Name = "ThemeTextDim"
    }, sw)
    corner(knob, 9)

    local state = default
    Lib.Flags[flag] = state

    local function render()
        if state then
            tw(sws, Lib.TI.med, { Transparency = 0 })
            tw(knob, Lib.TI.spring, {
                Position = UDim2.new(1, -16, 0.5, 0),
                BackgroundColor3 = Lib.Theme.Text
            })
        else
            tw(sws, Lib.TI.med, { Transparency = 0.5 })
            tw(knob, Lib.TI.spring, {
                Position = UDim2.new(0, 2, 0.5, 0),
                BackgroundColor3 = Lib.Theme.TextDim
            })
        end
    end
    render()

    local btn = inst("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 2
    }, f)
    btn.MouseEnter:Connect(function()
        tw(f, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.Hover })
        tw(s, Lib.TI.fast, { Transparency = 0.2 })
    end)
    btn.MouseLeave:Connect(function()
        tw(f, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.BG3 })
        tw(s, Lib.TI.fast, { Transparency = 0.75 })
    end)
    btn.MouseButton1Click:Connect(function()
        ripple(btn)
        state = not state
        Lib.Flags[flag] = state
        render()
        pcall(callback, state)
    end)

    updateSectionSize(self)
    return {
        Frame = f,
        Set = function(v)
            state = v
            Lib.Flags[flag] = v
            render()
            pcall(callback, v)
        end,
        Get = function() return state end
    }
end

function Section:AddSlider(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Slider"
    local desc = cfg.Description
    local flag = cfg.Flag or name
    local min = cfg.Min or 0
    local max = cfg.Max or 100
    local default = cfg.Default or min
    local callback = cfg.Callback or function() end
    local suffix = cfg.Suffix or ""
    local decimals = cfg.Decimals or 0

    local f, s = mkElementFrame(self.Container, desc and 50 or 38)
    local _, usedH = addTitleDesc(f, name, desc)

    local valueLbl = inst("TextLabel", {
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 6),
        Size = UDim2.new(0, 90, 0, 14),
        BackgroundTransparency = 1,
        Text = tostring(default) .. suffix,
        TextColor3 = Lib.Theme.Text,
        Font = Lib.Fonts.Mono,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
        Name = "ThemeText"
    }, f)

    local barBg = inst("Frame", {
        Position = UDim2.new(0, 10, 0, usedH + 6),
        Size = UDim2.new(1, -20, 0, 6),
        BackgroundColor3 = Lib.Theme.BG2,
        BorderSizePixel = 0,
        Name = "ThemeBG2"
    }, f)
    corner(barBg, 3)
    stroke(barBg, Lib.Theme.Line, 0.5, 0.75)

    local barFill = inst("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Lib.Theme.Text,
        BorderSizePixel = 0,
        Name = "ThemeText"
    }, barBg)
    corner(barFill, 3)

    local knob = inst("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0, 0, 0.5, 0),
        Size = UDim2.new(0, 12, 0, 12),
        BackgroundColor3 = Lib.Theme.Text,
        BorderSizePixel = 0,
        Name = "ThemeText"
    }, barBg)
    corner(knob, 9)

    local value = math.clamp(default, min, max)
    Lib.Flags[flag] = value

    local function fmt(v)
        if decimals > 0 then
            return string.format("%." .. decimals .. "f", v) .. suffix
        end
        return tostring(math.floor(v + 0.5)) .. suffix
    end

    local function apply(newVal, cb)
        value = math.clamp(newVal, min, max)
        local range = max - min
        local pct = range ~= 0 and (value - min) / range or 0
        tw(barFill, Lib.TI.fast, { Size = UDim2.new(pct, 0, 1, 0) })
        tw(knob, Lib.TI.fast, { Position = UDim2.new(pct, 0, 0.5, 0) })
        valueLbl.Text = fmt(value)
        Lib.Flags[flag] = value
        if cb then pcall(callback, value) end
    end
    apply(value, false)

    local dragging = false
    local hit = inst("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 2
    }, f)

    local function calc(input)
        local relX = input.Position.X - barBg.AbsolutePosition.X
        local pct = relX / math.max(barBg.AbsoluteSize.X, 1)
        pct = math.clamp(pct, 0, 1)
        return min + (max - min) * pct
    end

    hit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            apply(calc(i), true)
        end
    end)
    hit.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            apply(calc(i), true)
        end
    end)

    updateSectionSize(self)
    return {
        Frame = f,
        Set = function(v) apply(v, true) end,
        Get = function() return value end
    }
end

function Section:AddDropdown(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Dropdown"
    local desc = cfg.Description
    local flag = cfg.Flag or name
    local options = cfg.Options or {}
    local default = cfg.Default
    local multi = cfg.Multi or false
    local callback = cfg.Callback or function() end

    local f, s = mkElementFrame(self.Container, desc and 40 or 28)
    addTitleDesc(f, name, desc)

    local selected = {}
    if multi and type(default) == "table" then
        for _, d in ipairs(default) do selected[d] = true end
    elseif not multi and default ~= nil then
        selected[default] = true
    end
    Lib.Flags[flag] = multi and selected or default

    local function selectedText()
        if multi then
            local t = {}
            for k in pairs(selected) do table.insert(t, k) end
            if #t == 0 then return "—" end
            return table.concat(t, ", ")
        else
            for k in pairs(selected) do return k end
            return "—"
        end
    end

    local valueLbl = inst("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -30, 0.5, 0),
        Size = UDim2.new(0, 180, 0, 14),
        BackgroundTransparency = 1,
        Text = selectedText(),
        TextColor3 = Lib.Theme.Text,
        Font = Lib.Fonts.Regular,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Name = "ThemeText"
    }, f)

    local arrow = inst("TextLabel", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.new(0, 14, 0, 14),
        BackgroundTransparency = 1,
        Text = "▾",
        TextColor3 = Lib.Theme.TextDim,
        Font = Lib.Fonts.Regular,
        TextSize = 12,
        Rotation = 0,
        Name = "ThemeTextDim"
    }, f)

    local btn = inst("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 2
    }, f)
    btn.MouseEnter:Connect(function()
        tw(f, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.Hover })
        tw(s, Lib.TI.fast, { Transparency = 0.2 })
    end)
    btn.MouseLeave:Connect(function()
        tw(f, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.BG3 })
        tw(s, Lib.TI.fast, { Transparency = 0.75 })
    end)

    local open = false
    local panel = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = Lib.Theme.BG2,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 10,
        Visible = false,
        Name = "ThemeBG2"
    }, f)
    corner(panel, 4)
    stroke(panel, Lib.Theme.Line, 0.6, 0.5)
    inst("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    }, panel)
    pad(panel, 4)

    for i, opt in ipairs(options) do
        local ob = inst("TextButton", {
            Size = UDim2.new(1, 0, 0, 20),
            BackgroundColor3 = Lib.Theme.BG2,
            BorderSizePixel = 0,
            Text = "  " .. tostring(opt),
            TextColor3 = Lib.Theme.Text,
            Font = Lib.Fonts.Regular,
            TextSize = 10,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            LayoutOrder = i,
            ZIndex = 11,
            Name = "ThemeBG2"
        }, panel)
        corner(ob, 3)

        local obT = ob:FindFirstChildOfClass("TextLabel")
        ob.MouseEnter:Connect(function()
            tw(ob, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.BG4 })
        end)
        ob.MouseLeave:Connect(function()
            tw(ob, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.BG2 })
        end)
        ob.MouseButton1Click:Connect(function()
            if multi then
                if selected[opt] then
                    selected[opt] = nil
                else
                    selected[opt] = true
                end
            else
                selected = { [opt] = true }
            end
            valueLbl.Text = selectedText()
            Lib.Flags[flag] = multi and selected or opt
            pcall(callback, multi and selected or opt)
        end)
    end

    local function setOpen(state)
        open = state
        tw(arrow, Lib.TI.med, { Rotation = state and 180 or 0 })
        if state then
            panel.Visible = true
            local h = math.min(#options * 22 + 8, 180)
            panel.Size = UDim2.new(1, 0, 0, 0)
            tw(panel, Lib.TI.drift, { Size = UDim2.new(1, 0, 0, h) })
        else
            local t = tw(panel, Lib.TI.med, { Size = UDim2.new(1, 0, 0, 0) })
            t.Completed:Connect(function()
                if not open then panel.Visible = false end
            end)
        end
    end

    btn.MouseButton1Click:Connect(function()
        ripple(btn)
        setOpen(not open)
    end)

    updateSectionSize(self)
    return {
        Frame = f,
        Set = function(v)
            if multi then
                selected = {}
                for _, x in ipairs(v) do selected[x] = true end
                valueLbl.Text = selectedText()
                Lib.Flags[flag] = selected
            else
                selected = { [v] = true }
                valueLbl.Text = selectedText()
                Lib.Flags[flag] = v
            end
        end,
        Get = function() return Lib.Flags[flag] end
    }
end

function Section:AddTextBox(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Input"
    local desc = cfg.Description
    local flag = cfg.Flag or name
    local default = cfg.Default or ""
    local placeholder = cfg.Placeholder or ""
    local clear = cfg.ClearOnFocus or false
    local callback = cfg.Callback or function() end

    local f, s = mkElementFrame(self.Container, desc and 50 or 38)
    local _, usedH = addTitleDesc(f, name, desc)

    local tb = inst("TextBox", {
        Position = UDim2.new(0, 10, 0, usedH + 2),
        Size = UDim2.new(1, -20, 0, 20),
        BackgroundColor3 = Lib.Theme.BG2,
        BorderSizePixel = 0,
        Text = default,
        PlaceholderText = placeholder,
        PlaceholderColor3 = Lib.Theme.TextDim,
        TextColor3 = Lib.Theme.Text,
        Font = Lib.Fonts.Regular,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = clear,
        Name = "ThemeBG2"
    }, f)
    corner(tb, 3)
    local tbs = stroke(tb, Lib.Theme.Line, 0.6, 0.6)
    pad(tb, 6, 6, 8, 8)

    tb.Focused:Connect(function()
        tw(tbs, Lib.TI.fast, { Transparency = 0 })
        tw(s, Lib.TI.fast, { Transparency = 0.2 })
    end)
    tb.FocusLost:Connect(function(enter)
        tw(tbs, Lib.TI.fast, { Transparency = 0.6 })
        tw(s, Lib.TI.fast, { Transparency = 0.75 })
        Lib.Flags[flag] = tb.Text
        pcall(callback, tb.Text, enter)
    end)

    Lib.Flags[flag] = default
    updateSectionSize(self)
    return {
        Frame = f,
        Set = function(v)
            tb.Text = tostring(v)
            Lib.Flags[flag] = v
        end,
        Get = function() return tb.Text end
    }
end

function Section:AddKeybind(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Keybind"
    local desc = cfg.Description
    local flag = cfg.Flag or name
    local default = cfg.Default or Enum.KeyCode.RightShift
    local callback = cfg.Callback or function() end

    local f, s = mkElementFrame(self.Container, desc and 36 or 26)
    addTitleDesc(f, name, desc)

    local current = default
    Lib.Flags[flag] = current

    local keyLbl = inst("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 90, 0, 20),
        BackgroundColor3 = Lib.Theme.BG2,
        BorderSizePixel = 0,
        Text = current.Name,
        TextColor3 = Lib.Theme.Text,
        Font = Lib.Fonts.Mono,
        TextSize = 10,
        AutoButtonColor = false,
        Name = "ThemeBG2"
    }, f)
    corner(keyLbl, 3)
    local kls = stroke(keyLbl, Lib.Theme.Line, 0.6, 0.5)

    local listening = false
    keyLbl.MouseEnter:Connect(function()
        tw(kls, Lib.TI.fast, { Transparency = 0 })
    end)
    keyLbl.MouseLeave:Connect(function()
        tw(kls, Lib.TI.fast, { Transparency = 0.5 })
    end)
    keyLbl.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true
        keyLbl.Text = "..."
        tw(kls, Lib.TI.fast, { Transparency = 0, Color = Lib.Theme.INFO })
        local conn
        conn = UIS.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.UserInputType == Enum.UserInputType.Keyboard then
                current = i.KeyCode
                keyLbl.Text = current.Name
                Lib.Flags[flag] = current
                listening = false
                tw(kls, Lib.TI.fast, { Color = Lib.Theme.Line })
                pcall(callback, current)
                conn:Disconnect()
            elseif i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.MouseButton2 then
                keyLbl.Text = current.Name
                listening = false
                tw(kls, Lib.TI.fast, { Color = Lib.Theme.Line })
                conn:Disconnect()
            end
        end)
    end)

    UIS.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == current then
            pcall(callback, current)
        end
    end)

    updateSectionSize(self)
    return {
        Frame = f,
        Set = function(k)
            current = k
            keyLbl.Text = k.Name
            Lib.Flags[flag] = k
        end,
        Get = function() return current end
    }
end

function Section:AddLabel(cfg)
    cfg = cfg or {}
    local text = cfg.Text or "Label"
    local color = cfg.Color or Lib.Theme.TextDim
    local size = cfg.TextSize or 10

    local f = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1
    }, self.Container)
    inst("TextLabel", {
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 4, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color,
        Font = Lib.Fonts.Regular,
        TextSize = size,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = false
    }, f)
    updateSectionSize(self)
    return { Frame = f }
end

function Section:AddParagraph(cfg)
    cfg = cfg or {}
    local title = cfg.Title or "Paragraph"
    local text = cfg.Text or ""

    local f = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Lib.Theme.BG3,
        BorderSizePixel = 0,
        Name = "ThemeBG3"
    }, self.Container)
    corner(f, 4)
    stroke(f, Lib.Theme.Line, 0.6, 0.75)

    inst("TextLabel", {
        Size = UDim2.new(1, -20, 0, 14),
        Position = UDim2.new(0, 10, 0, 6),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Lib.Theme.Text,
        Font = Lib.Fonts.Bold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "ThemeText"
    }, f)
    local body = inst("TextLabel", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 22),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Lib.Theme.TextDim,
        Font = Lib.Fonts.Regular,
        TextSize = 10,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Name = "ThemeTextDim"
    }, f)

    task.defer(function()
        local h = 34 + (body.AbsoluteSize.Y or 14)
        f.Size = UDim2.new(1, 0, 0, h)
    end)

    updateSectionSize(self)
    return { Frame = f, Set = function(t) body.Text = t end }
end

function Section:AddDivider()
    local f = inst("Frame", {
        Size = UDim2.new(1, -8, 0, 1),
        BackgroundColor3 = Lib.Theme.LineDim,
        BorderSizePixel = 0,
        Name = "ThemeLineDim"
    }, self.Container)
    updateSectionSize(self)
    return { Frame = f }
end

function Section:AddColorPicker(cfg)
    cfg = cfg or {}
    local name = cfg.Name or "Color"
    local desc = cfg.Description
    local flag = cfg.Flag or name
    local default = cfg.Default or Color3.fromRGB(255, 255, 255)
    local callback = cfg.Callback or function() end

    local f, s = mkElementFrame(self.Container, desc and 40 or 30)
    addTitleDesc(f, name, desc)

    local swatch = inst("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -10, 0.5, 0),
        Size = UDim2.new(0, 40, 0, 20),
        BackgroundColor3 = default,
        BorderSizePixel = 0
    }, f)
    corner(swatch, 3)
    stroke(swatch, Lib.Theme.Line, 0.6, 0.4)

    Lib.Flags[flag] = default

    local btn = inst("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 2
    }, f)
    btn.MouseEnter:Connect(function()
        tw(f, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.Hover })
    end)
    btn.MouseLeave:Connect(function()
        tw(f, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.BG3 })
    end)

    local open = false
    local panel = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 2),
        BackgroundColor3 = Lib.Theme.BG2,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 10,
        Name = "ThemeBG2"
    }, f)
    corner(panel, 4)
    stroke(panel, Lib.Theme.Line, 0.6, 0.5)

    local hexInput = inst("TextBox", {
        Position = UDim2.new(0, 6, 0, 6),
        Size = UDim2.new(1, -12, 0, 22),
        BackgroundColor3 = Lib.Theme.BG3,
        BorderSizePixel = 0,
        Text = rgbToHex(default),
        PlaceholderText = "#FFFFFF",
        PlaceholderColor3 = Lib.Theme.TextDim,
        TextColor3 = Lib.Theme.Text,
        Font = Lib.Fonts.Mono,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        Name = "ThemeBG3"
    }, panel)
    corner(hexInput, 3)
    stroke(hexInput, Lib.Theme.Line, 0.5, 0.6)
    pad(hexInput, 4)

    local function applyColor(c, cb)
        swatch.BackgroundColor3 = c
        Lib.Flags[flag] = c
        hexInput.Text = rgbToHex(c)
        if cb then pcall(callback, c) end
    end

    hexInput.FocusLost:Connect(function()
        local c = hexToRgb(hexInput.Text)
        if c then
            applyColor(c, true)
        else
            hexInput.Text = rgbToHex(swatch.BackgroundColor3)
        end
    end)

    local function setOpen(state)
        open = state
        if state then
            panel.Visible = true
            panel.Size = UDim2.new(1, 0, 0, 0)
            tw(panel, Lib.TI.drift, { Size = UDim2.new(1, 0, 0, 38) })
        else
            local t = tw(panel, Lib.TI.med, { Size = UDim2.new(1, 0, 0, 0) })
            t.Completed:Connect(function()
                if not open then panel.Visible = false end
            end)
        end
    end

    btn.MouseButton1Click:Connect(function()
        ripple(btn)
        setOpen(not open)
    end)

    updateSectionSize(self)
    return {
        Frame = f,
        Set = function(c) applyColor(c, true) end,
        Get = function() return Lib.Flags[flag] end
    }
end

local TabMeta = {}
TabMeta.__index = TabMeta

function TabMeta:CreateSection(title)
    local frame = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Lib.Theme.BG2,
        BorderSizePixel = 0,
        Name = "ThemeBG2"
    }, self.Page)
    corner(frame, 4)
    stroke(frame, Lib.Theme.Line, 0.6, 0.7)

    inst("TextLabel", {
        Size = UDim2.new(1, -20, 0, 26),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Lib.Theme.Text,
        Font = Lib.Fonts.Bold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "ThemeText"
    }, frame)

    local container = inst("Frame", {
        Size = UDim2.new(1, -12, 0, 0),
        Position = UDim2.new(0, 6, 0, 30),
        BackgroundTransparency = 1
    }, frame)
    local layout = inst("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6)
    }, container)

    local sec = setmetatable({
        Frame = frame,
        Container = container,
        Layout = layout,
        Title = title
    }, Section)

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        updateSectionSize(sec)
    end)
    updateSectionSize(sec)
    table.insert(self.Sections, sec)
    return sec
end

function TabMeta:AddParagraph(cfg)
    return self:CreateSection("Info"):AddParagraph(cfg)
end

function Lib:CreateWindow(cfg)
    cfg = cfg or {}
    local winName  = cfg.Title or "LzeSilent"
    local subtitle = cfg.Subtitle or Lib.Version
    local winSize  = cfg.Size or UDim2.fromOffset(520, 340)
    local toggleKey = cfg.ToggleKey or Enum.KeyCode.RightControl
    local footer = cfg.Footer

    local gui = inst("ScreenGui", {
        Name = "LzeSilent_" .. winName,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 100
    }, PG)

    local main = inst("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.Theme.BG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        Name = "ThemeBG"
    }, gui)
    corner(main, 6)
    stroke(main, self.Theme.Line, 0.7, 0.15)

    local titleBar = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.BG2,
        BorderSizePixel = 0,
        Name = "ThemeBG2"
    }, main)

    inst("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = self.Theme.LineDim,
        BorderSizePixel = 0,
        Name = "ThemeLineDim"
    }, titleBar)

    local titleHolder = inst("Frame", {
        Size = UDim2.new(0, 200, 0, 16),
        Position = UDim2.new(0, 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1
    }, titleBar)

    inst("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Text = winName,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextTransparency = 0.3,
        Font = self.Fonts.Bold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, titleHolder)

    local tMain = inst("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = winName,
        TextColor3 = self.Theme.Text,
        Font = self.Fonts.Bold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "ThemeText"
    }, titleHolder)
    stroke(tMain, self.Theme.Line, 0.5, 0.55, Enum.ApplyStrokeMode.Contextual)

    inst("TextLabel", {
        Size = UDim2.new(0, 140, 1, 0),
        Position = UDim2.new(0, 100, 0, 0),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = self.Theme.TextDim,
        Font = self.Fonts.Mono,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "ThemeTextDim"
    }, titleBar)

    local function mkCtrl(sym, x, isClose)
        local b = inst("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, x, 0.5, 0),
            Size = UDim2.new(0, 22, 0, 22),
            BackgroundColor3 = self.Theme.BG3,
            BorderSizePixel = 0,
            Text = sym,
            TextColor3 = isClose and self.Theme.ERR or self.Theme.Text,
            Font = self.Fonts.Regular,
            TextSize = 12,
            AutoButtonColor = false,
            Name = "ThemeBG3"
        }, titleBar)
        corner(b, 4)
        local s = stroke(b, self.Theme.LineDim, 1, 0.5)
        b.MouseEnter:Connect(function()
            tw(b, Lib.TI.fast, { BackgroundColor3 = isClose and Color3.fromRGB(60, 25, 25) or self.Theme.Hover })
            tw(s, Lib.TI.fast, { Transparency = 0 })
        end)
        b.MouseLeave:Connect(function()
            tw(b, Lib.TI.fast, { BackgroundColor3 = self.Theme.BG3 })
            tw(s, Lib.TI.fast, { Transparency = 0.5 })
        end)
        return b
    end

    local btnClose = mkCtrl("×", -10, true)
    local btnMin   = mkCtrl("—", -36, false)

    local body = inst("Frame", {
        Position = UDim2.new(0, 0, 0, 31),
        Size = UDim2.new(1, 0, 1, -31),
        BackgroundColor3 = self.Theme.BG,
        BorderSizePixel = 0,
        Name = "ThemeBG"
    }, main)

    local sidebar = inst("Frame", {
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = self.Theme.BG2,
        BorderSizePixel = 0,
        Name = "ThemeBG2"
    }, body)

    inst("Frame", {
        Size = UDim2.new(0, 1, 1, 0),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = self.Theme.LineDim,
        BorderSizePixel = 0,
        Name = "ThemeLineDim"
    }, sidebar)

    local tabList = inst("Frame", {
        Position = UDim2.new(0, 6, 0, 8),
        Size = UDim2.new(1, -12, 1, -16),
        BackgroundTransparency = 1
    }, sidebar)
    inst("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4)
    }, tabList)

    local content = inst("Frame", {
        Position = UDim2.new(0, 121, 0, 0),
        Size = UDim2.new(1, -121, 1, 0),
        BackgroundColor3 = self.Theme.BG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Name = "ThemeBG"
    }, body)

    if footer then
        inst("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 1, -18),
            BackgroundTransparency = 1,
            Text = footer,
            TextColor3 = self.Theme.TextDim,
            Font = self.Fonts.Regular,
            TextSize = 9,
            TextXAlignment = Enum.TextXAlignment.Center,
            Name = "ThemeTextDim"
        }, body)
    end

    local Window = {
        Gui = gui,
        Main = main,
        Sidebar = sidebar,
        Content = content,
        TabList = tabList,
        Tabs = {},
        ActiveTab = nil,
        Visible = false,
        Minimized = false
    }

    local function setVisible(state)
        if state == Window.Visible then return end
        Window.Visible = state
        if state then
            main.Visible = true
            main.Size = UDim2.new(0, winSize.X.Offset * 0.9, 0, winSize.Y.Offset * 0.9)
            main.BackgroundTransparency = 1
            main.Position = UDim2.new(0.5, 0, 0.55, 0)
            tw(main, Lib.TI.spring, {
                Size = UDim2.new(0, winSize.X.Offset, 0, winSize.Y.Offset),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 0
            })
        else
            local out = tw(main, Lib.TI.inout, {
                Size = UDim2.new(0, winSize.X.Offset * 0.9, 0, winSize.Y.Offset * 0.9),
                BackgroundTransparency = 1
            })
            out.Completed:Connect(function()
                if not Window.Visible then main.Visible = false end
            end)
        end
    end

    function Window:Toggle() setVisible(not Window.Visible) end
    function Window:Show() setVisible(true) end
    function Window:Hide() setVisible(false) end

    btnClose.MouseButton1Click:Connect(function()
        pcall(function()
            local out = TweenService:Create(main, Lib.TI.inout, {
                Position = UDim2.new(0.5, 0, 0.55, 0),
                BackgroundTransparency = 1
            })
            out:Play()
            out.Completed:Connect(function()
                main.Visible = false
                Window.Visible = false
            end)
        end)
    end)

    btnMin.MouseButton1Click:Connect(function()
        Window.Minimized = not Window.Minimized
        if Window.Minimized then
            tw(body, Lib.TI.drift, { Size = UDim2.new(1, 0, 0, 0) })
            tw(main, Lib.TI.drift, { Size = UDim2.new(0, winSize.X.Offset, 0, 31) })
        else
            tw(body, Lib.TI.drift, { Size = UDim2.new(1, 0, 1, -31) })
            tw(main, Lib.TI.spring, { Size = UDim2.new(0, winSize.X.Offset, 0, winSize.Y.Offset) })
        end
    end)

    makeDraggable(main, titleBar)

    if toggleKey then
        UIS.InputBegan:Connect(function(i, gp)
            if gp then return end
            if i.KeyCode == toggleKey then Window:Toggle() end
        end)
    end

    function Window:CreateTab(name)
        local btn = inst("TextButton", {
            Size = UDim2.new(1, 0, 0, 26),
            BackgroundColor3 = self.Theme.BG2,
            BorderSizePixel = 0,
            Text = "  " .. name,
            TextColor3 = self.Theme.TextDim,
            Font = self.Fonts.Regular,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            LayoutOrder = #Window.Tabs + 1,
            Name = "ThemeBG2"
        }, tabList)
        corner(btn, 4)
        local st = stroke(btn, self.Theme.Line, 0.7, 0.75)

        local page = inst("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = self.Theme.Line,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false
        }, content)
        pad(page, 10)
        inst("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 8)
        }, page)

        local Tab = setmetatable({
            Name = name,
            Button = btn,
            Page = page,
            Sections = {}
        }, TabMeta)

        btn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then
                tw(btn, Lib.TI.fast, { BackgroundColor3 = self.Theme.Hover })
                tw(st, Lib.TI.fast, { Transparency = 0.3 })
            end
        end)
        btn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then
                tw(btn, Lib.TI.fast, { BackgroundColor3 = self.Theme.BG2 })
                tw(st, Lib.TI.fast, { Transparency = 0.75 })
            end
        end)
        btn.MouseButton1Click:Connect(function()
            ripple(btn)
            pcall(function() Window:SelectTab(Tab) end)
        end)

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then Window:SelectTab(Tab) end
        return Tab
    end

    function Window:SelectTab(Tab)
        if Window.ActiveTab == Tab then return end
        for _, t in ipairs(Window.Tabs) do
            if t == Tab then
                t.Page.Visible = true
                t.Page.Position = UDim2.new(0, 12, 0, 0)
                tw(t.Page, self.TI.drift, { Position = UDim2.new(0, 0, 0, 0) })
                tw(t.Button, self.TI.med, {
                    BackgroundColor3 = self.Theme.BG3,
                    TextColor3 = self.Theme.Text
                })
            else
                t.Page.Visible = false
                tw(t.Button, self.TI.med, {
                    BackgroundColor3 = self.Theme.BG2,
                    TextColor3 = self.Theme.TextDim
                })
            end
        end
        Window.ActiveTab = Tab
    end

    self.Windows[winName] = Window
    task.wait(0.05)
    setVisible(true)
    return Window
end

function Lib:CreateScriptEditor(cfg)
    cfg = cfg or {}
    local winName = cfg.Title or "LzeSilent Script Editor"
    local winSize = cfg.Size or UDim2.fromOffset(620, 420)

    local gui = inst("ScreenGui", {
        Name = "LzeSilentEditor",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 200
    }, PG)

    local main = inst("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.Theme.BG,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Visible = false,
        Name = "ThemeBG"
    }, gui)
    corner(main, 6)
    stroke(main, self.Theme.Line, 0.7, 0.15)

    local titleBar = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.BG2,
        BorderSizePixel = 0,
        Name = "ThemeBG2"
    }, main)
    inst("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = self.Theme.LineDim,
        BorderSizePixel = 0,
        Name = "ThemeLineDim"
    }, titleBar)

    local titleHolder = inst("Frame", {
        Size = UDim2.new(0, 200, 0, 16),
        Position = UDim2.new(0, 8, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundTransparency = 1
    }, titleBar)
    inst("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 1, 0, 1),
        BackgroundTransparency = 1,
        Text = winName,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextTransparency = 0.3,
        Font = self.Fonts.Bold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left
    }, titleHolder)
    local tMain = inst("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = winName,
        TextColor3 = self.Theme.Text,
        Font = self.Fonts.Bold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "ThemeText"
    }, titleHolder)
    stroke(tMain, self.Theme.Line, 0.5, 0.55, Enum.ApplyStrokeMode.Contextual)

    local function mkCtrl(sym, x, isClose)
        local b = inst("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, x, 0.5, 0),
            Size = UDim2.new(0, 22, 0, 22),
            BackgroundColor3 = self.Theme.BG3,
            BorderSizePixel = 0,
            Text = sym,
            TextColor3 = isClose and self.Theme.ERR or self.Theme.Text,
            Font = self.Fonts.Regular,
            TextSize = 12,
            AutoButtonColor = false,
            Name = "ThemeBG3"
        }, titleBar)
        corner(b, 4)
        stroke(b, self.Theme.LineDim, 1, 0.5)
        return b
    end
    local btnClose = mkCtrl("×", -10, true)
    local btnMin   = mkCtrl("—", -36, false)

    local editorBox = inst("TextBox", {
        Position = UDim2.new(0, 12, 0, 44),
        Size = UDim2.new(1, -24, 1, -108),
        BackgroundColor3 = self.Theme.BG2,
        BorderSizePixel = 0,
        Text = 'print("hello from LzeSilent")',
        PlaceholderText = "-- write lua here",
        TextColor3 = self.Theme.Text,
        PlaceholderColor3 = self.Theme.TextDim,
        Font = self.Fonts.Mono,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ClearTextOnFocus = false,
        MultiLine = true,
        Name = "ThemeBG2"
    }, main)
    corner(editorBox, 4)
    local ebs = stroke(editorBox, self.Theme.Line, 0.6, 0.6)
    pad(editorBox, 8)

    local btnRow = inst("Frame", {
        Position = UDim2.new(0, 12, 1, -52),
        Size = UDim2.new(1, -24, 0, 26),
        BackgroundTransparency = 1
    }, main)

    local function mkActionBtn(text, x, w)
        local b = inst("TextButton", {
            Position = UDim2.new(0, x, 0, 0),
            Size = UDim2.new(0, w, 0, 26),
            BackgroundColor3 = self.Theme.BG3,
            BorderSizePixel = 0,
            Text = text,
            TextColor3 = self.Theme.Text,
            Font = self.Fonts.Regular,
            TextSize = 11,
            AutoButtonColor = false,
            Name = "ThemeBG3"
        }, btnRow)
        corner(b, 4)
        local s = stroke(b, self.Theme.Line, 0.6, 0.5)
        b.MouseEnter:Connect(function()
            tw(b, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.Hover })
            tw(s, Lib.TI.fast, { Transparency = 0 })
        end)
        b.MouseLeave:Connect(function()
            tw(b, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.BG3 })
            tw(s, Lib.TI.fast, { Transparency = 0.5 })
        end)
        b.MouseButton1Down:Connect(function()
            tw(b, Lib.TI.tap, { BackgroundColor3 = Lib.Theme.BG2 })
        end)
        b.MouseButton1Up:Connect(function()
            tw(b, Lib.TI.fast, { BackgroundColor3 = Lib.Theme.Hover })
        end)
        return b, s
    end

    local runBtn = mkActionBtn("▶  Execute", 0, 110)
    local clearBtn = mkActionBtn("Clear", 118, 70)
    local saveBtn = mkActionBtn("Save File", 196, 90)
    local copyBtn = mkActionBtn("Copy", 294, 60)

    editorBox.Focused:Connect(function()
        tw(ebs, Lib.TI.fast, { Transparency = 0 })
    end)
    editorBox.FocusLost:Connect(function()
        tw(ebs, Lib.TI.fast, { Transparency = 0.6 })
    end)

    local function executeCode(code)
        if not code or code == "" then
            Lib:Notify({ Title = "Editor", Text = "nothing to run", Type = "warning" })
            return
        end
        if type(loadstring) ~= "function" then
            Lib:Notify({ Title = "Editor", Text = "no loadstring here", Type = "error" })
            return
        end
        local fn, e = loadstring(code)
        if not fn then
            Lib:Notify({ Title = "Compile Error", Text = tostring(e), Type = "error", Duration = 6 })
            return
        end
        Lib:Notify({ Title = "Editor", Text = "running...", Type = "info" })
        local ok, r = pcall(fn)
        if ok then
            Lib:Notify({ Title = "Editor", Text = "executed", Type = "success" })
        else
            Lib:Notify({ Title = "Runtime Error", Text = tostring(r), Type = "error", Duration = 6 })
        end
    end

    runBtn.MouseButton1Click:Connect(function()
        ripple(runBtn)
        executeCode(editorBox.Text)
    end)
    clearBtn.MouseButton1Click:Connect(function()
        ripple(clearBtn)
        editorBox.Text = ""
    end)
    copyBtn.MouseButton1Click:Connect(function()
        ripple(copyBtn)
        if type(setclipboard) == "function" then
            pcall(setclipboard, editorBox.Text)
            Lib:Notify({ Title = "Editor", Text = "copied to clipboard", Type = "success" })
        else
            Lib:Notify({ Title = "Editor", Text = "no clipboard support", Type = "error" })
        end
    end)

    local saveDialog = inst("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 260, 0, 90),
        BackgroundColor3 = self.Theme.BG2,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 20,
        Name = "ThemeBG2"
    }, main)
    corner(saveDialog, 6)
    stroke(saveDialog, self.Theme.Line, 0.7, 0.2)
    inst("TextLabel", {
        Size = UDim2.new(1, -20, 0, 16),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = "Save as...",
        TextColor3 = self.Theme.Text,
        Font = self.Fonts.Bold,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        Name = "ThemeText"
    }, saveDialog)
    local nameInput = inst("TextBox", {
        Position = UDim2.new(0, 10, 0, 30),
        Size = UDim2.new(1, -20, 0, 24),
        BackgroundColor3 = self.Theme.BG3,
        BorderSizePixel = 0,
        Text = "myscript",
        TextColor3 = self.Theme.Text,
        Font = self.Fonts.Mono,
        TextSize = 11,
        ClearTextOnFocus = false,
        Name = "ThemeBG3"
    }, saveDialog)
    corner(nameInput, 4)
    stroke(nameInput, self.Theme.Line, 0.5, 0.6)
    pad(nameInput, 4, 4, 8, 8)
    local confirmSave = mkActionBtn("Save", 10, 80)
    confirmSave.Parent = saveDialog
    confirmSave.Position = UDim2.new(0, 10, 1, -30)
    local cancelSave = mkActionBtn("Cancel", 100, 80)
    cancelSave.Parent = saveDialog
    cancelSave.Position = UDim2.new(0, 100, 1, -30)

    local function showSavePopup()
        saveDialog.Visible = true
        saveDialog.BackgroundTransparency = 1
        saveDialog.Size = UDim2.new(0, 240, 0, 80)
        tw(saveDialog, Lib.TI.spring, {
            Size = UDim2.new(0, 260, 0, 90),
            BackgroundTransparency = 0
        })
    end
    local function hideSavePopup()
        local t = tw(saveDialog, Lib.TI.med, { BackgroundTransparency = 1 })
        t.Completed:Connect(function()
            saveDialog.Visible = false
            saveDialog.BackgroundTransparency = 0
        end)
    end

    saveBtn.MouseButton1Click:Connect(function()
        ripple(saveBtn)
        showSavePopup()
    end)
    cancelSave.MouseButton1Click:Connect(hideSavePopup)
    confirmSave.MouseButton1Click:Connect(function()
        local nm = nameInput.Text
        if not nm or nm == "" then
            Lib:Notify({ Title = "Editor", Text = "name can't be empty", Type = "error" })
            return
        end
        if type(writefile) ~= "function" or type(makefolder) ~= "function" then
            Lib:Notify({ Title = "Editor", Text = "no filesystem", Type = "error" })
            return
        end
        if type(isfolder) == "function" and not isfolder("LzeSilentScripts") then
            pcall(makefolder, "LzeSilentScripts")
        end
        local path = "LzeSilentScripts/" .. nm .. ".lua"
        local ok = pcall(writefile, path, editorBox.Text)
        if ok then
            Lib:Notify({ Title = "Editor", Text = "saved: " .. nm, Type = "success" })
            hideSavePopup()
        else
            Lib:Notify({ Title = "Editor", Text = "save failed", Type = "error" })
        end
    end)

    local window = {
        Gui = gui,
        Main = main,
        Editor = editorBox,
        Visible = false,
        Execute = executeCode
    }

    local function setVisible(state)
        if state == window.Visible then return end
        window.Visible = state
        if state then
            main.Visible = true
            main.Size = UDim2.new(0, winSize.X.Offset * 0.9, 0, winSize.Y.Offset * 0.9)
            main.BackgroundTransparency = 1
            main.Position = UDim2.new(0.5, 0, 0.55, 0)
            tw(main, Lib.TI.spring, {
                Size = UDim2.new(0, winSize.X.Offset, 0, winSize.Y.Offset),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundTransparency = 0
            })
        else
            local out = tw(main, Lib.TI.inout, {
                Size = UDim2.new(0, winSize.X.Offset * 0.9, 0, winSize.Y.Offset * 0.9),
                BackgroundTransparency = 1
            })
            out.Completed:Connect(function()
                if not window.Visible then main.Visible = false end
            end)
        end
    end
    function window:Toggle() setVisible(not window.Visible) end
    function window:Show() setVisible(true) end
    function window:Hide() setVisible(false) end
    function window:SetCode(code) editorBox.Text = tostring(code) end
    function window:GetCode() return editorBox.Text end

    btnClose.MouseButton1Click:Connect(function()
        pcall(function()
            local out = TweenService:Create(main, Lib.TI.inout, {
                Position = UDim2.new(0.5, 0, 0.55, 0),
                BackgroundTransparency = 1
            })
            out:Play()
            out.Completed:Connect(function()
                main.Visible = false
                window.Visible = false
            end)
        end)
    end)
    btnMin.MouseButton1Click:Connect(function()
        tw(main, Lib.TI.med, { Size = UDim2.new(0, winSize.X.Offset, 0, 30) })
        task.delay(0.5, function()
            tw(main, Lib.TI.spring, { Size = UDim2.new(0, winSize.X.Offset, 0, winSize.Y.Offset) })
        end)
    end)

    makeDraggable(main, titleBar)

    task.wait(0.05)
    setVisible(true)
    return window
end

local CONFIG_DIR = "LzeSilentConfig"

local function ensureConfigDir()
    if type(isfolder) == "function" and type(makefolder) == "function" then
        if not isfolder(CONFIG_DIR) then pcall(makefolder, CONFIG_DIR) end
        return true
    end
    return false
end

function Lib:SaveConfig(name)
    if type(writefile) ~= "function" then
        self:Notify({ Title = "Config", Text = "no filesystem", Type = "error" })
        return false
    end
    if not ensureConfigDir() then return false end
    name = name or "default"
    local ok, encoded = pcall(function()
        local out = {}
        for k, v in pairs(self.Flags) do
            if type(v) == "EnumItem" then
                out[k] = { __t = "EnumItem", n = v.Name, c = tostring(v.EnumType) }
            elseif type(v) == "Color3" then
                out[k] = { __t = "Color3", r = v.R, g = v.G, b = v.B }
            elseif type(v) == "table" then
                out[k] = v
            else
                out[k] = v
            end
        end
        return HttpService:JSONEncode(out)
    end)
    if not ok then return false end
    local path = CONFIG_DIR .. "/" .. name .. ".json"
    local ok2 = pcall(writefile, path, encoded)
    if ok2 then
        self:Notify({ Title = "Config", Text = "saved: " .. name, Type = "success" })
    end
    return ok2
end

function Lib:LoadConfig(name)
    if type(readfile) ~= "function" then
        self:Notify({ Title = "Config", Text = "no filesystem", Type = "error" })
        return false
    end
    name = name or "default"
    local path = CONFIG_DIR .. "/" .. name .. ".json"
    local ok, content = pcall(readfile, path)
    if not ok then
        self:Notify({ Title = "Config", Text = "not found: " .. name, Type = "error" })
        return false
    end
    local decoded
    local ok2, err2 = pcall(function() decoded = HttpService:JSONDecode(content) end)
    if not ok2 then
        self:Notify({ Title = "Config", Text = "corrupt file", Type = "error" })
        return false
    end
    for k, v in pairs(decoded) do
        if type(v) == "table" and v.__t == "EnumItem" then
            local et = v.c:gsub("Enum%.", "")
            local container = Enum[et]
            if container then
                self.Flags[k] = container[v.n]
            end
        elseif type(v) == "table" and v.__t == "Color3" then
            self.Flags[k] = Color3.new(v.r, v.g, v.b)
        else
            self.Flags[k] = v
        end
    end
    self:Notify({ Title = "Config", Text = "loaded: " .. name, Type = "success" })
    return true
end

function Lib:ListConfigs()
    if type(listfiles) ~= "function" or type(isfolder) ~= "function" then return {} end
    if not isfolder(CONFIG_DIR) then return {} end
    local ok, files = pcall(listfiles, CONFIG_DIR)
    if not ok then return {} end
    local out = {}
    for _, f in ipairs(files) do
        local nm = f:match("([^/\\]+)%.json$")
        if nm then table.insert(out, nm) end
    end
    return out
end

function Lib:Unload()
    pcall(function()
        for _, w in pairs(self.Windows) do
            if w.Gui and w.Gui.Parent then w.Gui:Destroy() end
        end
    end)
    pcall(function()
        if notifyGui and notifyGui.Parent then notifyGui:Destroy() end
    end)
    self.Windows = {}
    self.Flags = {}
end

function Lib:GetFlag(name) return self.Flags[name] end
function Lib:SetFlag(name, value) self.Flags[name] = value end
function Lib:GetWindows() return self.Windows end
function Lib:GetVersion() return self.Version end
function Lib:GetTheme() return self.Theme end

return Lib
