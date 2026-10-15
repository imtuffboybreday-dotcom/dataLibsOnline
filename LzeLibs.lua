local Lib = {}
Lib.Version = "LzeSilent.UI v2.0.0"
Lib.Flags = {}
Lib.Windows = {}
Lib.ThemePresets = {
    Dark = {
        BG=Color3.fromRGB(0,0,0), BG2=Color3.fromRGB(12,12,12), BG3=Color3.fromRGB(22,22,22),
        BG4=Color3.fromRGB(32,32,32), BG5=Color3.fromRGB(45,45,45),
        Line=Color3.fromRGB(255,255,255), LineDim=Color3.fromRGB(60,60,60),
        Text=Color3.fromRGB(255,255,255), TextDim=Color3.fromRGB(160,160,160),
        TextMute=Color3.fromRGB(100,100,100), Hover=Color3.fromRGB(38,38,38),
        OK=Color3.fromRGB(74,222,128), WARN=Color3.fromRGB(251,191,36),
        ERR=Color3.fromRGB(248,113,113), INFO=Color3.fromRGB(96,165,250)
    },
    Midnight = {
        BG=Color3.fromRGB(8,10,18), BG2=Color3.fromRGB(14,18,28), BG3=Color3.fromRGB(20,26,40),
        BG4=Color3.fromRGB(28,36,54), BG5=Color3.fromRGB(40,52,76),
        Line=Color3.fromRGB(120,170,255), LineDim=Color3.fromRGB(50,70,110),
        Text=Color3.fromRGB(230,240,255), TextDim=Color3.fromRGB(150,170,200),
        TextMute=Color3.fromRGB(90,110,140), Hover=Color3.fromRGB(32,42,62),
        OK=Color3.fromRGB(80,220,140), WARN=Color3.fromRGB(250,190,60),
        ERR=Color3.fromRGB(250,120,120), INFO=Color3.fromRGB(120,180,255)
    },
    Blood = {
        BG=Color3.fromRGB(14,8,8), BG2=Color3.fromRGB(24,12,12), BG3=Color3.fromRGB(36,18,18),
        BG4=Color3.fromRGB(52,26,26), BG5=Color3.fromRGB(72,36,36),
        Line=Color3.fromRGB(255,90,90), LineDim=Color3.fromRGB(100,40,40),
        Text=Color3.fromRGB(255,230,230), TextDim=Color3.fromRGB(200,150,150),
        TextMute=Color3.fromRGB(140,90,90), Hover=Color3.fromRGB(50,24,24),
        OK=Color3.fromRGB(120,220,120), WARN=Color3.fromRGB(250,200,80),
        ERR=Color3.fromRGB(255,80,80), INFO=Color3.fromRGB(255,140,140)
    },
    Matrix = {
        BG=Color3.fromRGB(4,10,4), BG2=Color3.fromRGB(8,18,8), BG3=Color3.fromRGB(12,26,12),
        BG4=Color3.fromRGB(18,38,18), BG5=Color3.fromRGB(28,54,28),
        Line=Color3.fromRGB(80,255,80), LineDim=Color3.fromRGB(40,100,40),
        Text=Color3.fromRGB(220,255,220), TextDim=Color3.fromRGB(140,200,140),
        TextMute=Color3.fromRGB(80,140,80), Hover=Color3.fromRGB(20,42,20),
        OK=Color3.fromRGB(80,255,80), WARN=Color3.fromRGB(200,255,80),
        ERR=Color3.fromRGB(255,120,120), INFO=Color3.fromRGB(120,255,180)
    },
    Snow = {
        BG=Color3.fromRGB(245,246,250), BG2=Color3.fromRGB(232,234,240), BG3=Color3.fromRGB(218,222,232),
        BG4=Color3.fromRGB(200,206,220), BG5=Color3.fromRGB(180,190,208),
        Line=Color3.fromRGB(40,45,60), LineDim=Color3.fromRGB(160,168,184),
        Text=Color3.fromRGB(20,22,30), TextDim=Color3.fromRGB(90,96,110),
        TextMute=Color3.fromRGB(140,146,160), Hover=Color3.fromRGB(210,216,228),
        OK=Color3.fromRGB(60,180,100), WARN=Color3.fromRGB(220,160,40),
        ERR=Color3.fromRGB(220,70,70), INFO=Color3.fromRGB(70,120,220)
    }
}
Lib.Theme = {}
for k,v in pairs(Lib.ThemePresets.Dark) do Lib.Theme[k] = v end

Lib.Fonts = { Regular=Enum.Font.Gotham, Bold=Enum.Font.GothamBold, Mono=Enum.Font.Code }

Lib.TI = {
    tap=TweenInfo.new(0.08,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    fast=TweenInfo.new(0.15,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
    med=TweenInfo.new(0.26,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
    soft=TweenInfo.new(0.35,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
    drift=TweenInfo.new(0.45,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
    slow=TweenInfo.new(0.55,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
    spring=TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
    pop=TweenInfo.new(0.6,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out),
    inout=TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut),
    loop=TweenInfo.new(2.5,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,-1)
}

local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local HttpService=game:GetService("HttpService")
local RunService=game:GetService("RunService")
local LP=Players.LocalPlayer
local PG=LP:WaitForChild("PlayerGui")

local function inst(c,props,parent)
    local o=Instance.new(c)
    if props then for k,v in pairs(props) do pcall(function() o[k]=v end) end end
    if parent then o.Parent=parent end
    return o
end
local function stroke(p,c,t,tr,md)
    return inst("UIStroke",{Color=c or Lib.Theme.Line,Thickness=t or 0.7,Transparency=tr or 0.15,ApplyStrokeMode=md or Enum.ApplyStrokeMode.Border},p)
end
local function corner(p,r) return inst("UICorner",{CornerRadius=UDim.new(0,r or 4)},p) end
local function pad(p,n,n2,n3,n4)
    return inst("UIPadding",{PaddingTop=UDim.new(0,n or 0),PaddingBottom=UDim.new(0,n2 or n or 0),PaddingLeft=UDim.new(0,n3 or n or 0),PaddingRight=UDim.new(0,n4 or n or 0)},p)
end
local function tw(o,ti,props) local t=TweenService:Create(o,ti,props); t:Play(); return t end
local function ripple(btn)
    pcall(function()
        local ax,ay=btn.AbsoluteSize.X,btn.AbsoluteSize.Y
        if not ax or not ay or ax<=0 or ay<=0 then return end
        local r=inst("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0,0,0,0),BackgroundColor3=Color3.fromRGB(255,255,255),BackgroundTransparency=0.85,BorderSizePixel=0,ZIndex=btn.ZIndex+1},btn)
        corner(r,9999)
        local m=math.max(ax,ay)*2
        tw(r,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Size=UDim2.new(0,m,0,m),BackgroundTransparency=1})
        task.delay(0.42,function() if r and r.Parent then r:Destroy() end end)
    end)
end
local function drag(frame,handle,onMove)
    local dg,ds,sp
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dg=true; ds=i.Position; sp=frame.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dg=false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            local vp=frame.Parent and frame.Parent.AbsoluteSize or Vector2.new(1920,1080)
            local nx=math.clamp(sp.X.Scale*vp.X+sp.X.Offset+d.X,0,vp.X-60)
            local ny=math.clamp(sp.Y.Scale*vp.Y+sp.Y.Offset+d.Y,0,vp.Y-30)
            frame.Position=UDim2.new(0,nx,0,ny)
            if onMove then onMove(nx,ny) end
        end
    end)
end
local function rgbToHex(c) return string.format("#%02X%02X%02X",math.floor(c.R*255+0.5),math.floor(c.G*255+0.5),math.floor(c.B*255+0.5)) end
local function hexToRgb(h)
    h=h:gsub("#","")
    if #h~=6 then return nil end
    local r=tonumber(h:sub(1,2),16); local g=tonumber(h:sub(3,4),16); local b=tonumber(h:sub(5,6),16)
    if not r or not g or not b then return nil end
    return Color3.fromRGB(r,g,b)
end
local function applyTheme(root)
    for _,d in ipairs(root:GetDescendants()) do
        pcall(function()
            if d:IsA("Frame") or d:IsA("ScrollingFrame") then
                if d.Name=="TBG" then tw(d,Lib.TI.med,{BackgroundColor3=Lib.Theme.BG}) end
                if d.Name=="TBG2" then tw(d,Lib.TI.med,{BackgroundColor3=Lib.Theme.BG2}) end
                if d.Name=="TBG3" then tw(d,Lib.TI.med,{BackgroundColor3=Lib.Theme.BG3}) end
                if d.Name=="TBG4" then tw(d,Lib.TI.med,{BackgroundColor3=Lib.Theme.BG4}) end
            end
            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                if d.Name=="TTX" then tw(d,Lib.TI.med,{TextColor3=Lib.Theme.Text}) end
                if d.Name=="TTXD" then tw(d,Lib.TI.med,{TextColor3=Lib.Theme.TextDim}) end
                if d.Name=="TTXM" then tw(d,Lib.TI.med,{TextColor3=Lib.Theme.TextMute}) end
            end
            if d:IsA("UIStroke") then
                if d.Name=="TST" then tw(d,Lib.TI.med,{Color=Lib.Theme.Line}) end
                if d.Name=="TSTD" then tw(d,Lib.TI.med,{Color=Lib.Theme.LineDim}) end
            end
        end)
    end
end

local notifyGui,notifyList
local function initNotify()
    if notifyGui and notifyGui.Parent then return end
    notifyGui=inst("ScreenGui",{Name="LzeNotify",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=9999},PG)
    notifyList=inst("Frame",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-16,0,16),Size=UDim2.new(0,280,1,-32),BackgroundTransparency=1},notifyGui)
    inst("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8),VerticalAlignment=Enum.VerticalAlignment.Top,HorizontalAlignment=Enum.HorizontalAlignment.Right},notifyList)
end
function Lib:Notify(cfg)
    cfg=cfg or {}
    initNotify()
    local title=cfg.Title or "Notice"
    local text=cfg.Text or ""
    local dur=cfg.Duration or 4
    local kind=cfg.Type or "info"
    local accent=self.Theme.INFO
    if kind=="success" then accent=self.Theme.OK elseif kind=="warning" then accent=self.Theme.WARN elseif kind=="error" then accent=self.Theme.ERR end
    local card=inst("Frame",{Size=UDim2.new(1,0,0,0),BackgroundColor3=self.Theme.BG,BorderSizePixel=0,ClipsDescendants=true,Name="TBG"},notifyList)
    corner(card,6); stroke(card,self.Theme.Line,0.8,0.3)
    local bar=inst("Frame",{Size=UDim2.new(0,3,0,0),BackgroundColor3=accent,BorderSizePixel=0},card); corner(bar,4)
    local tl=inst("TextLabel",{Size=UDim2.new(1,-20,0,16),Position=UDim2.new(0,14,0,8),BackgroundTransparency=1,Text=title,TextColor3=self.Theme.Text,Font=self.Fonts.Bold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Name="TTX"},card)
    local bl=inst("TextLabel",{Size=UDim2.new(1,-20,0,0),Position=UDim2.new(0,14,0,26),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=text,TextColor3=self.Theme.TextDim,Font=self.Fonts.Regular,TextSize=10,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Name="TTXD"},card)
    task.defer(function()
        local h=math.max(46,36+(bl.AbsoluteSize.Y or 14))
        card.Size=UDim2.new(1,0,0,0); card.Position=UDim2.new(0,28,0,0); card.BackgroundTransparency=1
        tl.TextTransparency=1; bl.TextTransparency=1
        tw(card,Lib.TI.spring,{Size=UDim2.new(1,0,0,h),Position=UDim2.new(0,0,0,0),BackgroundTransparency=0})
        task.wait(0.08)
        tw(tl,Lib.TI.soft,{TextTransparency=0}); tw(bl,Lib.TI.soft,{TextTransparency=0})
        tw(bar,Lib.TI.slow,{Size=UDim2.new(0,3,0,h)})
    end)
    task.delay(dur,function()
        pcall(function()
            local out=TweenService:Create(card,Lib.TI.inout,{Position=UDim2.new(0,34,0,0),BackgroundTransparency=1})
            out:Play(); tw(tl,Lib.TI.med,{TextTransparency=1}); tw(bl,Lib.TI.med,{TextTransparency=1})
            out.Completed:Connect(function() if card and card.Parent then card:Destroy() end end)
        end)
    end)
    return card
end

function Lib:SetTheme(t)
    for k,v in pairs(t) do if self.Theme[k] then self.Theme[k]=v end end
    for _,w in pairs(self.Windows) do if w.Gui and w.Gui.Parent then applyTheme(w.Gui) end end
end
function Lib:LoadTheme(name)
    local p=self.ThemePresets[name]
    if p then self:SetTheme(p); self:Notify({Title="Theme",Text="loaded: "..name,Type="success"}) end
end

local Section={}
Section.__index=Section
local function updateSec(sec)
    task.defer(function()
        if not sec or not sec.Layout then return end
        local h=sec.Layout.AbsoluteContentSize.Y
        if sec.Container then sec.Container.Size=UDim2.new(1,0,0,h) end
        if sec.Frame then sec.Frame.Size=UDim2.new(1,0,0,h+40) end
    end)
end
local function mkCard(parent,h)
    local f=inst("Frame",{Size=UDim2.new(1,0,0,h),BackgroundColor3=Lib.Theme.BG3,BorderSizePixel=0,Name="TBG3",ClipsDescendants=true},parent)
    corner(f,5)
    local s=stroke(f,Lib.Theme.LineDim,0.7,0.4); s.Name="TSTD"
    return f,s
end
local function mkTitleDesc(frame,name,desc)
    local tl=inst("TextLabel",{Size=UDim2.new(1,-110,0,14),Position=UDim2.new(0,12,0,7),BackgroundTransparency=1,Text=name,TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Regular,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Name="TTX"},frame)
    if desc and desc~="" then
        inst("TextLabel",{Size=UDim2.new(1,-24,0,12),Position=UDim2.new(0,12,0,22),BackgroundTransparency=1,Text=desc,TextColor3=Lib.Theme.TextDim,Font=Lib.Fonts.Regular,TextSize=9,TextXAlignment=Enum.TextXAlignment.Left,TextTruncate=Enum.TextTruncate.AtEnd,Name="TTXD"},frame)
        return tl,36
    end
    return tl,24
end
local function tooltip(parent,text)
    if not text or text=="" then return end
    local tp
    parent.MouseEnter:Connect(function()
        if tp then return end
        tp=inst("Frame",{Size=UDim2.new(0,0,0,26),Position=UDim2.new(1,8,0.5,-13),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,ZIndex=50,Name="TBG2"},parent)
        corner(tp,4); stroke(tp,Lib.Theme.LineDim,0.7,0.3)
        local l=inst("TextLabel",{Size=UDim2.new(0,0,1,0),Position=UDim2.new(0,0,0,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Text="  "..text.."  ",TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Regular,TextSize=10,Name="TTX"},tp)
        pad(tp,0,0,6,6)
        tw(tp,Lib.TI.med,{Size=UDim2.new(0,l.AbsoluteSize.X+12,0,26)})
    end)
    parent.MouseLeave:Connect(function()
        if tp then local t=tp; tp=nil; tw(t,Lib.TI.fast,{BackgroundTransparency=1}); task.delay(0.16,function() if t and t.Parent then t:Destroy() end end) end
    end)
end

function Section:AddButton(cfg)
    cfg=cfg or {}
    local name=cfg.Name or "Button"
    local desc=cfg.Description
    local cb=cfg.Callback or function() end
    local tip=cfg.Tooltip
    local f,s=mkCard(self.Container,desc and 40 or 30)
    mkTitleDesc(f,name,desc)
    local btn=inst("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=2},f)
    btn.MouseEnter:Connect(function() tw(f,Lib.TI.fast,{BackgroundColor3=Lib.Theme.Hover}); tw(s,Lib.TI.fast,{Transparency=0.1}) end)
    btn.MouseLeave:Connect(function() tw(f,Lib.TI.fast,{BackgroundColor3=Lib.Theme.BG3}); tw(s,Lib.TI.fast,{Transparency=0.4}) end)
    btn.MouseButton1Down:Connect(function() tw(f,Lib.TI.tap,{BackgroundColor3=Lib.Theme.BG2}) end)
    btn.MouseButton1Up:Connect(function() tw(f,Lib.TI.fast,{BackgroundColor3=Lib.Theme.Hover}) end)
    btn.MouseButton1Click:Connect(function() ripple(btn); pcall(cb) end)
    if tip then tooltip(f,tip) end
    updateSec(self)
    return {Frame=f,Button=btn}
end

function Section:AddToggle(cfg)
    cfg=cfg or {}
    local name=cfg.Name or "Toggle"
    local desc=cfg.Description
    local flag=cfg.Flag or name
    local default=cfg.Default or false
    local cb=cfg.Callback or function() end
    local tip=cfg.Tooltip
    local f,s=mkCard(self.Container,desc and 40 or 30)
    mkTitleDesc(f,name,desc)
    local sw=inst("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.new(0,38,0,20),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,Name="TBG2"},f)
    corner(sw,10)
    local sws=stroke(sw,Lib.Theme.LineDim,0.8,0.3); sws.Name="TSTD"
    local knob=inst("Frame",{AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0,2,0.5,0),Size=UDim2.new(0,16,0,16),BackgroundColor3=Lib.Theme.TextMute,BorderSizePixel=0},sw)
    corner(knob,9)
    local state=default; Lib.Flags[flag]=state
    local function render()
        if state then
            tw(sws,Lib.TI.med,{Transparency=0,Color=Lib.Theme.Line})
            tw(knob,Lib.TI.spring,{Position=UDim2.new(1,-18,0.5,0),BackgroundColor3=Lib.Theme.Text})
        else
            tw(sws,Lib.TI.med,{Transparency=0.3,Color=Lib.Theme.LineDim})
            tw(knob,Lib.TI.spring,{Position=UDim2.new(0,2,0.5,0),BackgroundColor3=Lib.Theme.TextMute})
        end
    end
    render()
    local btn=inst("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=2},f)
    btn.MouseEnter:Connect(function() tw(f,Lib.TI.fast,{BackgroundColor3=Lib.Theme.Hover}); tw(s,Lib.TI.fast,{Transparency=0.1}) end)
    btn.MouseLeave:Connect(function() tw(f,Lib.TI.fast,{BackgroundColor3=Lib.Theme.BG3}); tw(s,Lib.TI.fast,{Transparency=0.4}) end)
    btn.MouseButton1Click:Connect(function()
        ripple(btn); state=not state; Lib.Flags[flag]=state; render(); pcall(cb,state)
    end)
    if tip then tooltip(f,tip) end
    updateSec(self)
    return {Frame=f,Set=function(v) state=v; Lib.Flags[flag]=v; render(); pcall(cb,v) end,Get=function() return state end}
end

function Section:AddSlider(cfg)
    cfg=cfg or {}
    local name=cfg.Name or "Slider"
    local desc=cfg.Description
    local flag=cfg.Flag or name
    local min=cfg.Min or 0
    local max=cfg.Max or 100
    local def=cfg.Default or min
    local cb=cfg.Callback or function() end
    local suffix=cfg.Suffix or ""
    local dec=cfg.Decimals or 0
    local f,s=mkCard(self.Container,desc and 54 or 42)
    local _,usedH=mkTitleDesc(f,name,desc)
    local valL=inst("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,7),Size=UDim2.new(0,100,0,14),BackgroundTransparency=1,Text=tostring(def)..suffix,TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Mono,TextSize=10,TextXAlignment=Enum.TextXAlignment.Right,Name="TTX"},f)
    local bg=inst("Frame",{Position=UDim2.new(0,12,0,usedH+6),Size=UDim2.new(1,-24,0,6),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,Name="TBG2"},f)
    corner(bg,3); stroke(bg,Lib.Theme.LineDim,0.6,0.4)
    local fill=inst("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=Lib.Theme.Text,BorderSizePixel=0,Name="TTX"},bg); corner(fill,3)
    local knob=inst("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(0,14,0,14),BackgroundColor3=Lib.Theme.Text,BorderSizePixel=0,Name="TTX"},bg)
    corner(knob,9); stroke(knob,Lib.Theme.BG,1,0)
    local value=math.clamp(def,min,max); Lib.Flags[flag]=value
    local function fmt(v) if dec>0 then return string.format("%."..dec.."f",v)..suffix end; return tostring(math.floor(v+0.5))..suffix end
    local function apply(v,cb2)
        value=math.clamp(v,min,max)
        local range=max-min
        local pct=range~=0 and (value-min)/range or 0
        tw(fill,Lib.TI.fast,{Size=UDim2.new(pct,0,1,0)})
        tw(knob,Lib.TI.fast,{Position=UDim2.new(pct,0,0.5,0)})
        valL.Text=fmt(value); Lib.Flags[flag]=value
        if cb2 then pcall(cb,value) end
    end
    apply(value,false)
    local dragging=false
    local hit=inst("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=2},f)
    local function calc(i)
        local rx=i.Position.X-bg.AbsolutePosition.X
        local pct=rx/math.max(bg.AbsoluteSize.X,1)
        return min+(max-min)*math.clamp(pct,0,1)
    end
    hit.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; apply(calc(i),true)
        end
    end)
    hit.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then apply(calc(i),true) end
    end)
    updateSec(self)
    return {Frame=f,Set=function(v) apply(v,true) end,Get=function() return value end}
end

function Section:AddDropdown(cfg)
    cfg=cfg or {}
    local name=cfg.Name or "Dropdown"
    local desc=cfg.Description
    local flag=cfg.Flag or name
    local opts=cfg.Options or {}
    local def=cfg.Default
    local multi=cfg.Multi or false
    local cb=cfg.Callback or function() end
    local f,s=mkCard(self.Container,desc and 44 or 32)
    mkTitleDesc(f,name,desc)
    local sel={}
    if multi and type(def)=="table" then for _,d in ipairs(def) do sel[d]=true end
    elseif not multi and def~=nil then sel[def]=true end
    Lib.Flags[flag]=multi and sel or def
    local function selText()
        if multi then
            local t={}
            for k in pairs(sel) do table.insert(t,k) end
            if #t==0 then return "—" end
            return table.concat(t,", ")
        else
            for k in pairs(sel) do return k end
            return "—"
        end
    end
    local valL=inst("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-32,0.5,0),Size=UDim2.new(0,190,0,14),BackgroundTransparency=1,Text=selText(),TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Regular,TextSize=10,TextXAlignment=Enum.TextXAlignment.Right,TextTruncate=Enum.TextTruncate.AtEnd,Name="TTX"},f)
    local arrow=inst("TextLabel",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-10,0.5,0),Size=UDim2.new(0,14,0,14),BackgroundTransparency=1,Text="▾",TextColor3=Lib.Theme.TextDim,Font=Lib.Fonts.Regular,TextSize=12,Name="TTXD"},f)
    local btn=inst("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=2},f)
    btn.MouseEnter:Connect(function() tw(f,Lib.TI.fast,{BackgroundColor3=Lib.Theme.Hover}); tw(s,Lib.TI.fast,{Transparency=0.1}) end)
    btn.MouseLeave:Connect(function() tw(f,Lib.TI.fast,{BackgroundColor3=Lib.Theme.BG3}); tw(s,Lib.TI.fast,{Transparency=0.4}) end)
    local open=false
    local panel=inst("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,3),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,ClipsDescendants=true,ZIndex=10,Visible=false,Name="TBG2"},f)
    corner(panel,5); stroke(panel,Lib.Theme.LineDim,0.7,0.2)
    inst("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2)},panel)
    pad(panel,4)
    for i,opt in ipairs(opts) do
        local ob=inst("TextButton",{Size=UDim2.new(1,0,0,22),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,Text="  "..tostring(opt),TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Regular,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,LayoutOrder=i,ZIndex=11,Name="TBG2"},panel)
        corner(ob,3)
        ob.MouseEnter:Connect(function() tw(ob,Lib.TI.fast,{BackgroundColor3=Lib.Theme.BG4}) end)
        ob.MouseLeave:Connect(function() tw(ob,Lib.TI.fast,{BackgroundColor3=Lib.Theme.BG2}) end)
        ob.MouseButton1Click:Connect(function()
            if multi then if sel[opt] then sel[opt]=nil else sel[opt]=true end
            else sel={[opt]=true} end
            valL.Text=selText(); Lib.Flags[flag]=multi and sel or opt
            pcall(cb,multi and sel or opt)
        end)
    end
    local function setOpen(st)
        open=st
        tw(arrow,Lib.TI.med,{Rotation=st and 180 or 0})
        if st then
            panel.Visible=true
            local h=math.min(#opts*24+8,200)
            panel.Size=UDim2.new(1,0,0,0)
            tw(panel,Lib.TI.drift,{Size=UDim2.new(1,0,0,h)})
        else
            local t=tw(panel,Lib.TI.med,{Size=UDim2.new(1,0,0,0)})
            t.Completed:Connect(function() if not open then panel.Visible=false end end)
        end
    end
    btn.MouseButton1Click:Connect(function() ripple(btn); setOpen(not open) end)
    updateSec(self)
    return {Frame=f,Set=function(v)
        if multi then sel={}; for _,x in ipairs(v) do sel[x]=true end; valL.Text=selText(); Lib.Flags[flag]=sel
        else sel={[v]=true}; valL.Text=selText(); Lib.Flags[flag]=v end
    end,Get=function() return Lib.Flags[flag] end}
end

function Section:AddTextBox(cfg)
    cfg=cfg or {}
    local name=cfg.Name or "Input"
    local desc=cfg.Description
    local flag=cfg.Flag or name
    local def=cfg.Default or ""
    local ph=cfg.Placeholder or ""
    local clear=cfg.ClearOnFocus or false
    local cb=cfg.Callback or function() end
    local f,s=mkCard(self.Container,desc and 54 or 42)
    local _,usedH=mkTitleDesc(f,name,desc)
    local tb=inst("TextBox",{Position=UDim2.new(0,12,0,usedH+4),Size=UDim2.new(1,-24,0,22),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,Text=def,PlaceholderText=ph,PlaceholderColor3=Lib.Theme.TextMute,TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Regular,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=clear,Name="TBG2"},f)
    corner(tb,4)
    local tbs=stroke(tb,Lib.Theme.LineDim,0.7,0.4); tbs.Name="TSTD"
    pad(tb,8,8,8,8)
    tb.Focused:Connect(function() tw(tbs,Lib.TI.fast,{Transparency=0,Color=Lib.Theme.Line}); tw(s,Lib.TI.fast,{Transparency=0.1}) end)
    tb.FocusLost:Connect(function(enter)
        tw(tbs,Lib.TI.fast,{Transparency=0.4,Color=Lib.Theme.LineDim}); tw(s,Lib.TI.fast,{Transparency=0.4})
        Lib.Flags[flag]=tb.Text; pcall(cb,tb.Text,enter)
    end)
    Lib.Flags[flag]=def
    updateSec(self)
    return {Frame=f,Set=function(v) tb.Text=tostring(v); Lib.Flags[flag]=v end,Get=function() return tb.Text end}
end

function Section:AddKeybind(cfg)
    cfg=cfg or {}
    local name=cfg.Name or "Keybind"
    local desc=cfg.Description
    local flag=cfg.Flag or name
    local def=cfg.Default or Enum.KeyCode.RightShift
    local cb=cfg.Callback or function() end
    local f,s=mkCard(self.Container,desc and 40 or 30)
    mkTitleDesc(f,name,desc)
    local current=def; Lib.Flags[flag]=current
    local keyL=inst("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.new(0,96,0,22),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,Text=current.Name,TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Mono,TextSize=10,AutoButtonColor=false,Name="TBG2"},f)
    corner(keyL,4)
    local kls=stroke(keyL,Lib.Theme.LineDim,0.7,0.3); kls.Name="TSTD"
    local listening=false
    keyL.MouseEnter:Connect(function() tw(kls,Lib.TI.fast,{Transparency=0,Color=Lib.Theme.Line}) end)
    keyL.MouseLeave:Connect(function() tw(kls,Lib.TI.fast,{Transparency=0.3,Color=Lib.Theme.LineDim}) end)
    keyL.MouseButton1Click:Connect(function()
        if listening then return end
        listening=true; keyL.Text="..."
        tw(kls,Lib.TI.fast,{Transparency=0,Color=Lib.Theme.INFO})
        local conn
        conn=UIS.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.UserInputType==Enum.UserInputType.Keyboard then
                current=i.KeyCode; keyL.Text=current.Name; Lib.Flags[flag]=current; listening=false
                tw(kls,Lib.TI.fast,{Color=Lib.Theme.LineDim}); pcall(cb,current); conn:Disconnect()
            elseif i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.MouseButton2 then
                keyL.Text=current.Name; listening=false; tw(kls,Lib.TI.fast,{Color=Lib.Theme.LineDim}); conn:Disconnect()
            end
        end)
    end)
    UIS.InputBegan:Connect(function(i,gp) if gp then return end; if i.KeyCode==current then pcall(cb,current) end end)
    updateSec(self)
    return {Frame=f,Set=function(k) current=k; keyL.Text=k.Name; Lib.Flags[flag]=k end,Get=function() return current end}
end

function Section:AddLabel(cfg)
    cfg=cfg or {}
    local text=cfg.Text or "Label"
    local color=cfg.Color or Lib.Theme.TextDim
    local sz=cfg.TextSize or 10
    local f=inst("Frame",{Size=UDim2.new(1,0,0,20),BackgroundTransparency=1},self.Container)
    inst("TextLabel",{Size=UDim2.new(1,-12,1,0),Position=UDim2.new(0,6,0,0),BackgroundTransparency=1,Text=text,TextColor3=color,Font=Lib.Fonts.Regular,TextSize=sz,TextXAlignment=Enum.TextXAlignment.Left,Name="TTXD"},f)
    updateSec(self)
    return {Frame=f}
end

function Section:AddParagraph(cfg)
    cfg=cfg or {}
    local title=cfg.Title or "Paragraph"
    local text=cfg.Text or ""
    local f=inst("Frame",{Size=UDim2.new(1,0,0,44),BackgroundColor3=Lib.Theme.BG3,BorderSizePixel=0,Name="TBG3",ClipsDescendants=true},self.Container)
    corner(f,5); stroke(f,Lib.Theme.LineDim,0.7,0.4)
    inst("TextLabel",{Size=UDim2.new(1,-24,0,14),Position=UDim2.new(0,12,0,8),BackgroundTransparency=1,Text=title,TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Bold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Name="TTX"},f)
    local body=inst("TextLabel",{Size=UDim2.new(1,-24,0,0),Position=UDim2.new(0,12,0,26),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Text=text,TextColor3=Lib.Theme.TextDim,Font=Lib.Fonts.Regular,TextSize=10,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Name="TTXD"},f)
    task.defer(function()
        local h=38+(body.AbsoluteSize.Y or 14)
        f.Size=UDim2.new(1,0,0,h)
    end)
    updateSec(self)
    return {Frame=f,Set=function(t) body.Text=t end}
end

function Section:AddDivider()
    local f=inst("Frame",{Size=UDim2.new(1,-12,0,1),BackgroundColor3=Lib.Theme.LineDim,BackgroundTransparency=0.4,BorderSizePixel=0},self.Container)
    updateSec(self)
    return {Frame=f}
end

function Section:AddColorPicker(cfg)
    cfg=cfg or {}
    local name=cfg.Name or "Color"
    local desc=cfg.Description
    local flag=cfg.Flag or name
    local def=cfg.Default or Color3.fromRGB(255,255,255)
    local cb=cfg.Callback or function() end
    local f,s=mkCard(self.Container,desc and 44 or 32)
    mkTitleDesc(f,name,desc)
    local sw=inst("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,-12,0.5,0),Size=UDim2.new(0,44,0,22),BackgroundColor3=def,BorderSizePixel=0},f)
    corner(sw,4); stroke(sw,Lib.Theme.LineDim,0.7,0.3)
    Lib.Flags[flag]=def
    local btn=inst("TextButton",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text="",ZIndex=2},f)
    btn.MouseEnter:Connect(function() tw(f,Lib.TI.fast,{BackgroundColor3=Lib.Theme.Hover}) end)
    btn.MouseLeave:Connect(function() tw(f,Lib.TI.fast,{BackgroundColor3=Lib.Theme.BG3}) end)
    local open=false
    local panel=inst("Frame",{Size=UDim2.new(1,0,0,0),Position=UDim2.new(0,0,1,3),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,ClipsDescendants=true,Visible=false,ZIndex=10,Name="TBG2"},f)
    corner(panel,5); stroke(panel,Lib.Theme.LineDim,0.7,0.2)
    local hex=inst("TextBox",{Position=UDim2.new(0,8,0,8),Size=UDim2.new(1,-16,0,24),BackgroundColor3=Lib.Theme.BG3,BorderSizePixel=0,Text=rgbToHex(def),PlaceholderText="#FFFFFF",PlaceholderColor3=Lib.Theme.TextMute,TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Mono,TextSize=11,TextXAlignment=Enum.TextXAlignment.Center,Name="TBG3"},panel)
    corner(hex,4); stroke(hex,Lib.Theme.LineDim,0.6,0.4); pad(hex,4)
    local function apply(c,cb2)
        sw.BackgroundColor3=c; Lib.Flags[flag]=c; hex.Text=rgbToHex(c)
        if cb2 then pcall(cb,c) end
    end
    hex.FocusLost:Connect(function()
        local c=hexToRgb(hex.Text)
        if c then apply(c,true) else hex.Text=rgbToHex(sw.BackgroundColor3) end
    end)
    local function setOpen(st)
        open=st
        if st then
            panel.Visible=true; panel.Size=UDim2.new(1,0,0,0)
            tw(panel,Lib.TI.drift,{Size=UDim2.new(1,0,0,44)})
        else
            local t=tw(panel,Lib.TI.med,{Size=UDim2.new(1,0,0,0)})
            t.Completed:Connect(function() if not open then panel.Visible=false end end)
        end
    end
    btn.MouseButton1Click:Connect(function() ripple(btn); setOpen(not open) end)
    updateSec(self)
    return {Frame=f,Set=function(c) apply(c,true) end,Get=function() return Lib.Flags[flag] end}
end

function Section:AddProgressBar(cfg)
    cfg=cfg or {}
    local name=cfg.Name or "Progress"
    local def=cfg.Default or 0
    local f,s=mkCard(self.Container,42)
    mkTitleDesc(f,name,"")
    local valL=inst("TextLabel",{AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-12,0,7),Size=UDim2.new(0,60,0,14),BackgroundTransparency=1,Text=math.floor(def).."%",TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Mono,TextSize=10,TextXAlignment=Enum.TextXAlignment.Right,Name="TTX"},f)
    local bg=inst("Frame",{Position=UDim2.new(0,12,0,26),Size=UDim2.new(1,-24,0,6),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,Name="TBG2"},f)
    corner(bg,3); stroke(bg,Lib.Theme.LineDim,0.6,0.4)
    local fill=inst("Frame",{Size=UDim2.new(def/100,0,1,0),BackgroundColor3=Lib.Theme.Text,BorderSizePixel=0,Name="TTX"},bg); corner(fill,3)
    updateSec(self)
    return {Frame=f,Set=function(v)
        v=math.clamp(v,0,100)
        tw(fill,Lib.TI.med,{Size=UDim2.new(v/100,0,1,0)}); valL.Text=math.floor(v).."%"
    end}
end

function Section:AddSearchBox(cfg)
    cfg=cfg or {}
    local name=cfg.Name or "Search"
    local ph=cfg.Placeholder or "search..."
    local cb=cfg.Callback or function() end
    local f,s=mkCard(self.Container,42)
    local _,usedH=mkTitleDesc(f,name,"")
    local tb=inst("TextBox",{Position=UDim2.new(0,12,0,usedH+2),Size=UDim2.new(1,-24,0,22),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,Text="",PlaceholderText=ph,PlaceholderColor3=Lib.Theme.TextMute,TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Regular,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Name="TBG2"},f)
    corner(tb,4); stroke(tb,Lib.Theme.LineDim,0.7,0.4); pad(tb,8,8,8,8)
    tb:GetPropertyChangedSignal("Text"):Connect(function() pcall(cb,tb.Text) end)
    updateSec(self)
    return {Frame=f,Get=function() return tb.Text end}
end

local TabMeta={}
TabMeta.__index=TabMeta
function TabMeta:CreateSection(title)
    local frame=inst("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=Lib.Theme.BG2,BorderSizePixel=0,Name="TBG2",ClipsDescendants=true},self.Page)
    corner(frame,5); stroke(frame,Lib.Theme.LineDim,0.7,0.4)
    inst("TextLabel",{Size=UDim2.new(1,-24,0,28),Position=UDim2.new(0,12,0,0),BackgroundTransparency=1,Text=title,TextColor3=Lib.Theme.Text,Font=Lib.Fonts.Bold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Name="TTX"},frame)
    local cont=inst("Frame",{Size=UDim2.new(1,-12,0,0),Position=UDim2.new(0,6,0,32),BackgroundTransparency=1},frame)
    local layout=inst("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)},cont)
    local sec=setmetatable({Frame=frame,Container=cont,Layout=layout,Title=title},Section)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() updateSec(sec) end)
    updateSec(sec)
    table.insert(self.Sections,sec)
    return sec
end

function Lib:CreateWindow(cfg)
    cfg=cfg or {}
    local winName=cfg.Title or "LzeSilent"
    local sub=cfg.Subtitle or Lib.Version
    local size=cfg.Size or UDim2.fromOffset(540,380)
    local toggleKey=cfg.ToggleKey or Enum.KeyCode.RightControl
    local footer=cfg.Footer
    local resizable=cfg.Resizable~=false
    local gui=inst("ScreenGui",{Name="Lze_"..winName,ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=100},PG)
    local main=inst("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0,0,0,0),BackgroundColor3=self.Theme.BG,BorderSizePixel=0,ClipsDescendants=true,Visible=false,Name="TBG"},gui)
    corner(main,8); stroke(main,self.Theme.Line,0.8,0.2)
    local titleBar=inst("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=self.Theme.BG2,BorderSizePixel=0,Name="TBG2",ClipsDescendants=true},main)
    inst("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=self.Theme.LineDim,BackgroundTransparency=0.3,BorderSizePixel=0,Name="TSTD"},titleBar)
    local th=inst("Frame",{Size=UDim2.new(0,220,0,18),Position=UDim2.new(0,10,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1},titleBar)
    inst("TextLabel",{Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,1,0,1),BackgroundTransparency=1,Text=winName,TextColor3=Color3.fromRGB(0,0,0),TextTransparency=0.3,Font=self.Fonts.Bold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},th)
    local tMain=inst("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=winName,TextColor3=self.Theme.Text,Font=self.Fonts.Bold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Name="TTX"},th)
    stroke(tMain,self.Theme.Line,0.5,0.6,Enum.ApplyStrokeMode.Contextual)
    inst("TextLabel",{Size=UDim2.new(0,160,1,0),Position=UDim2.new(0,110,0,0),BackgroundTransparency=1,Text=sub,TextColor3=self.Theme.TextDim,Font=self.Fonts.Mono,TextSize=10,TextXAlignment=Enum.TextXAlignment.Left,Name="TTXD"},titleBar)
    local function mkCtrl(sym,x,isClose)
        local b=inst("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,x,0.5,0),Size=UDim2.new(0,24,0,24),BackgroundColor3=self.Theme.BG3,BorderSizePixel=0,Text=sym,TextColor3=isClose and self.Theme.ERR or self.Theme.Text,Font=self.Fonts.Regular,TextSize=13,AutoButtonColor=false,Name="TBG3"},titleBar)
        corner(b,5)
        local s=stroke(b,self.Theme.LineDim,0.8,0.3); s.Name="TSTD"
        b.MouseEnter:Connect(function() tw(b,Lib.TI.fast,{BackgroundColor3=isClose and Color3.fromRGB(70,28,28) or self.Theme.Hover}); tw(s,Lib.TI.fast,{Transparency=0}) end)
        b.MouseLeave:Connect(function() tw(b,Lib.TI.fast,{BackgroundColor3=self.Theme.BG3}); tw(s,Lib.TI.fast,{Transparency=0.3}) end)
        return b
    end
    local btnClose=mkCtrl("×",-12,true)
    local btnMin=mkCtrl("—",-42,false)
    local body=inst("Frame",{Position=UDim2.new(0,0,0,33),Size=UDim2.new(1,0,1,-33),BackgroundColor3=self.Theme.BG,BorderSizePixel=0,Name="TBG",ClipsDescendants=true},main)
    local sidebar=inst("Frame",{Size=UDim2.new(0,130,1,0),BackgroundColor3=self.Theme.BG2,BorderSizePixel=0,Name="TBG2",ClipsDescendants=true},body)
    inst("Frame",{Size=UDim2.new(0,1,1,0),Position=UDim2.new(1,-1,0,0),BackgroundColor3=self.Theme.LineDim,BackgroundTransparency=0.3,BorderSizePixel=0,Name="TSTD"},sidebar)
    local tabList=inst("Frame",{Position=UDim2.new(0,8,0,8),Size=UDim2.new(1,-16,1,-16),BackgroundTransparency=1},sidebar)
    inst("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,5)},tabList)
    local content=inst("Frame",{Position=UDim2.new(0,131,0,0),Size=UDim2.new(1,-131,1,0),BackgroundColor3=self.Theme.BG,BorderSizePixel=0,ClipsDescendants=true,Name="TBG"},body)
    if footer then
        inst("TextLabel",{Size=UDim2.new(1,0,0,18),Position=UDim2.new(0,0,1,-20),BackgroundTransparency=1,Text=footer,TextColor3=self.Theme.TextMute,Font=self.Fonts.Regular,TextSize=9,TextXAlignment=Enum.TextXAlignment.Center,Name="TTXM"},body)
    end
    local Window={Gui=gui,Main=main,Sidebar=sidebar,Content=content,TabList=tabList,Tabs={},ActiveTab=nil,Visible=false,Minimized=false,Size=size}
    local function setVis(st)
        if st==Window.Visible then return end
        Window.Visible=st
        if st then
            main.Visible=true
            main.Size=UDim2.new(0,Window.Size.X.Offset*0.9,0,Window.Size.Y.Offset*0.9)
            main.BackgroundTransparency=1
            main.Position=UDim2.new(0.5,0,0.55,0)
            tw(main,Lib.TI.spring,{Size=UDim2.new(0,Window.Size.X.Offset,0,Window.Size.Y.Offset),Position=UDim2.new(0.5,0,0.5,0),BackgroundTransparency=0})
        else
            local out=tw(main,Lib.TI.inout,{Size=UDim2.new(0,Window.Size.X.Offset*0.9,0,Window.Size.Y.Offset*0.9),BackgroundTransparency=1})
            out.Completed:Connect(function() if not Window.Visible then main.Visible=false end end)
        end
    end
    function Window:Toggle() setVis(not Window.Visible) end
    function Window:Show() setVis(true) end
    function Window:Hide() setVis(false) end
    btnClose.MouseButton1Click:Connect(function()
        pcall(function()
            local out=TweenService:Create(main,Lib.TI.inout,{Position=UDim2.new(0.5,0,0.55,0),BackgroundTransparency=1})
            out:Play()
            out.Completed:Connect(function() main.Visible=false; Window.Visible=false end)
        end)
    end)
    btnMin.MouseButton1Click:Connect(function()
        Window.Minimized=not Window.Minimized
        if Window.Minimized then
            tw(body,Lib.TI.drift,{Size=UDim2.new(1,0,0,0)})
            tw(main,Lib.TI.drift,{Size=UDim2.new(0,Window.Size.X.Offset,0,33)})
        else
            tw(body,Lib.TI.drift,{Size=UDim2.new(1,0,1,-33)})
            tw(main,Lib.TI.spring,{Size=UDim2.new(0,Window.Size.X.Offset,0,Window.Size.Y.Offset)})
        end
    end)
    drag(main,titleBar)
    if toggleKey then
        UIS.InputBegan:Connect(function(i,gp)
            if gp then return end
            if i.KeyCode==toggleKey then Window:Toggle() end
        end)
    end
    function Window:CreateTab(name)
        local btn=inst("TextButton",{Size=UDim2.new(1,0,0,30),BackgroundColor3=self.Theme.BG3,BorderSizePixel=0,Text="   "..name,TextColor3=self.Theme.TextDim,Font=self.Fonts.Regular,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,AutoButtonColor=false,LayoutOrder=#Window.Tabs+1,Name="TBG3"},tabList)
        corner(btn,5)
        local st=stroke(btn,self.Theme.LineDim,0.7,0.5); st.Name="TSTD"
        local page=inst("ScrollingFrame",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=3,ScrollBarImageColor3=self.Theme.LineDim,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false,ClipsDescendants=true,ScrollingDirection=Enum.ScrollingDirection.Y},content)
        pad(page,12)
        inst("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,8)},page)
        local Tab=setmetatable({Name=name,Button=btn,Page=page,Sections={}},TabMeta)
        btn.MouseEnter:Connect(function()
            if Window.ActiveTab~=Tab then tw(btn,Lib.TI.fast,{BackgroundColor3=self.Theme.Hover}); tw(st,Lib.TI.fast,{Transparency=0.2}) end
        end)
        btn.MouseLeave:Connect(function()
            if Window.ActiveTab~=Tab then tw(btn,Lib.TI.fast,{BackgroundColor3=self.Theme.BG3}); tw(st,Lib.TI.fast,{Transparency=0.5}) end
        end)
        btn.MouseButton1Click:Connect(function()
            ripple(btn)
            pcall(function() Window:SelectTab(Tab) end)
        end)
        table.insert(Window.Tabs,Tab)
        if #Window.Tabs==1 then Window:SelectTab(Tab) end
        return Tab
    end
    function Window:SelectTab(Tab)
        if Window.ActiveTab==Tab then return end
        for _,t in ipairs(Window.Tabs) do
            if t==Tab then
                t.Page.Visible=true
                t.Page.Position=UDim2.new(0,14,0,0)
                tw(t.Page,Lib.TI.drift,{Position=UDim2.new(0,0,0,0)})
                tw(t.Button,Lib.TI.med,{BackgroundColor3=self.Theme.BG5,TextColor3=self.Theme.Text})
            else
                t.Page.Visible=false
                tw(t.Button,Lib.TI.med,{BackgroundColor3=self.Theme.BG3,TextColor3=self.Theme.TextDim})
            end
        end
        Window.ActiveTab=Tab
    end
    self.Windows[winName]=Window
    task.wait(0.05)
    if #Window.Tabs==0 then
        local a=Window:CreateTab("Main")
        local w=a:CreateSection("Welcome")
        w:AddParagraph({Title="LzeSilent.UI "..Lib.Version,Text="Ready. Gunakan Window:CreateTab lalu Section:AddButton / AddToggle / AddSlider / AddDropdown / AddTextBox / AddKeybind / AddColorPicker / AddProgressBar / AddSearchBox / AddLabel / AddParagraph / AddDivider."})
        w:AddLabel({Text="made with LzeSilent.UI"})
    end
    setVis(true)
    return Window
end

function Lib:CreateScriptEditor(cfg)
    cfg=cfg or {}
    local winName=cfg.Title or "LzeSilent Script Editor"
    local size=cfg.Size or UDim2.fromOffset(660,440)
    local gui=inst("ScreenGui",{Name="LzeEditor",ResetOnSpawn=false,IgnoreGuiInset=true,ZIndexBehavior=Enum.ZIndexBehavior.Sibling,DisplayOrder=200},PG)
    local main=inst("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0,0,0,0),BackgroundColor3=self.Theme.BG,BorderSizePixel=0,ClipsDescendants=true,Visible=false,Name="TBG"},gui)
    corner(main,8); stroke(main,self.Theme.Line,0.8,0.2)
    local tb=inst("Frame",{Size=UDim2.new(1,0,0,32),BackgroundColor3=self.Theme.BG2,BorderSizePixel=0,Name="TBG2"},main)
    inst("Frame",{Size=UDim2.new(1,0,0,1),Position=UDim2.new(0,0,1,-1),BackgroundColor3=self.Theme.LineDim,BackgroundTransparency=0.3,BorderSizePixel=0},tb)
    local th=inst("Frame",{Size=UDim2.new(0,240,0,18),Position=UDim2.new(0,10,0.5,0),AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1},tb)
    inst("TextLabel",{Size=UDim2.new(1,0,1,0),Position=UDim2.new(0,1,0,1),BackgroundTransparency=1,Text=winName,TextColor3=Color3.fromRGB(0,0,0),TextTransparency=0.3,Font=self.Fonts.Bold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},th)
    local tMain=inst("TextLabel",{Size=UDim2.new(1,0,1,0),BackgroundTransparency=1,Text=winName,TextColor3=self.Theme.Text,Font=self.Fonts.Bold,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,Name="TTX"},th)
    stroke(tMain,self.Theme.Line,0.5,0.6,Enum.ApplyStrokeMode.Contextual)
    local function mkCtrl(sym,x,isClose)
        local b=inst("TextButton",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(1,x,0.5,0),Size=UDim2.new(0,24,0,24),BackgroundColor3=self.Theme.BG3,BorderSizePixel=0,Text=sym,TextColor3=isClose and self.Theme.ERR or self.Theme.Text,Font=self.Fonts.Regular,TextSize=13,AutoButtonColor=false,Name="TBG3"},tb)
        corner(b,5); stroke(b,self.Theme.LineDim,0.8,0.3)
        return b
    end
    local btnClose=mkCtrl("×",-12,true)
    local btnMin=mkCtrl("—",-42,false)
    local editorBox=inst("TextBox",{Position=UDim2.new(0,14,0,48),Size=UDim2.new(1,-28,1,-116),BackgroundColor3=self.Theme.BG2,BorderSizePixel=0,Text='print("hello from LzeSilent")',PlaceholderText="-- write lua here",TextColor3=self.Theme.Text,PlaceholderColor3=self.Theme.TextMute,Font=self.Fonts.Mono,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,ClearTextOnFocus=false,Name="TBG2"},main)
    pcall(function() editorBox.Multiline=true end)
    pcall(function() editorBox.TextWrapped=true end)
    corner(editorBox,5)
    local ebs=stroke(editorBox,self.Theme.LineDim,0.7,0.4); ebs.Name="TSTD"
    pad(editorBox,10)
    local row=inst("Frame",{Position=UDim2.new(0,14,1,-58),Size=UDim2.new(1,-28,0,28),BackgroundTransparency=1},main)
    local function mkAct(text,x,w)
        local b=inst("TextButton",{Position=UDim2.new(0,x,0,0),Size=UDim2.new(0,w,0,28),BackgroundColor3=self.Theme.BG3,BorderSizePixel=0,Text=text,TextColor3=self.Theme.Text,Font=self.Fonts.Regular,TextSize=11,AutoButtonColor=false,Name="TBG3"},row)
        corner(b,5); local s=stroke(b,self.Theme.LineDim,0.7,0.4); s.Name="TSTD"
        b.MouseEnter:Connect(function() tw(b,Lib.TI.fast,{BackgroundColor3=Lib.Theme.Hover}); tw(s,Lib.TI.fast,{Transparency=0}) end)
        b.MouseLeave:Connect(function() tw(b,Lib.TI.fast,{BackgroundColor3=Lib.Theme.BG3}); tw(s,Lib.TI.fast,{Transparency=0.4}) end)
        b.MouseButton1Down:Connect(function() tw(b,Lib.TI.tap,{BackgroundColor3=Lib.Theme.BG2}) end)
        b.MouseButton1Up:Connect(function() tw(b,Lib.TI.fast,{BackgroundColor3=Lib.Theme.Hover}) end)
        return b
    end
    local runBtn=mkAct("▶  Execute",0,120)
    local clearBtn=mkAct("Clear",128,76)
    local saveBtn=mkAct("Save File",212,96)
    local copyBtn=mkAct("Copy",316,70)
    editorBox.Focused:Connect(function() tw(ebs,Lib.TI.fast,{Transparency=0,Color=Lib.Theme.Line}) end)
    editorBox.FocusLost:Connect(function() tw(ebs,Lib.TI.fast,{Transparency=0.4,Color=Lib.Theme.LineDim}) end)
    local function exec(code)
        if not code or code=="" then Lib:Notify({Title="Editor",Text="nothing to run",Type="warning"}); return end
        if type(loadstring)~="function" then Lib:Notify({Title="Editor",Text="no loadstring",Type="error"}); return end
        local fn,e=loadstring(code)
        if not fn then Lib:Notify({Title="Compile Error",Text=tostring(e),Type="error",Duration=6}); return end
        Lib:Notify({Title="Editor",Text="running",Type="info"})
        local ok,r=pcall(fn)
        if ok then Lib:Notify({Title="Editor",Text="executed",Type="success"}) else Lib:Notify({Title="Runtime Error",Text=tostring(r),Type="error",Duration=6}) end
    end
    runBtn.MouseButton1Click:Connect(function() ripple(runBtn); exec(editorBox.Text) end)
    clearBtn.MouseButton1Click:Connect(function() ripple(clearBtn); editorBox.Text="" end)
    copyBtn.MouseButton1Click:Connect(function()
        ripple(copyBtn)
        if type(setclipboard)=="function" then pcall(setclipboard,editorBox.Text); Lib:Notify({Title="Editor",Text="copied",Type="success"})
        else Lib:Notify({Title="Editor",Text="no clipboard",Type="error"}) end
    end)
    local saveDlg=inst("Frame",{AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0,280,0,100),BackgroundColor3=self.Theme.BG2,BorderSizePixel=0,Visible=false,ZIndex=20,Name="TBG2"},main)
    corner(saveDlg,6); stroke(saveDlg,self.Theme.Line,0.8,0.2)
    inst("TextLabel",{Size=UDim2.new(1,-20,0,18),Position=UDim2.new(0,12,0,10),BackgroundTransparency=1,Text="Save as...",TextColor3=self.Theme.Text,Font=self.Fonts.Bold,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,Name="TTX"},saveDlg)
    local nameIn=inst("TextBox",{Position=UDim2.new(0,12,0,34),Size=UDim2.new(1,-24,0,26),BackgroundColor3=self.Theme.BG3,BorderSizePixel=0,Text="myscript",TextColor3=self.Theme.Text,Font=self.Fonts.Mono,TextSize=11,ClearTextOnFocus=false,Name="TBG3"},saveDlg)
    corner(nameIn,5); stroke(nameIn,self.Theme.LineDim,0.6,0.4); pad(nameIn,6,6,10,10)
    local confirmSave=mkAct("Save",12,90); confirmSave.Parent=saveDlg; confirmSave.Position=UDim2.new(0,12,1,-36)
    local cancelSave=mkAct("Cancel",108,90); cancelSave.Parent=saveDlg; cancelSave.Position=UDim2.new(0,108,1,-36)
    saveBtn.MouseButton1Click:Connect(function()
        ripple(saveBtn); saveDlg.Visible=true
        saveDlg.BackgroundTransparency=1; saveDlg.Size=UDim2.new(0,260,0,90)
        tw(saveDlg,Lib.TI.spring,{Size=UDim2.new(0,280,0,100),BackgroundTransparency=0})
    end)
    cancelSave.MouseButton1Click:Connect(function()
        local t=tw(saveDlg,Lib.TI.med,{BackgroundTransparency=1})
        t.Completed:Connect(function() saveDlg.Visible=false; saveDlg.BackgroundTransparency=0 end)
    end)
    confirmSave.MouseButton1Click:Connect(function()
        local nm=nameIn.Text
        if not nm or nm=="" then Lib:Notify({Title="Editor",Text="name required",Type="error"}); return end
        if type(writefile)~="function" or type(makefolder)~="function" then Lib:Notify({Title="Editor",Text="no filesystem",Type="error"}); return end
        if type(isfolder)=="function" and not isfolder("LzeSilentScripts") then pcall(makefolder,"LzeSilentScripts") end
        local path="LzeSilentScripts/"..nm..".lua"
        local ok=pcall(writefile,path,editorBox.Text)
        if ok then Lib:Notify({Title="Editor",Text="saved: "..nm,Type="success"})
            local t=tw(saveDlg,Lib.TI.med,{BackgroundTransparency=1}); t.Completed:Connect(function() saveDlg.Visible=false; saveDlg.BackgroundTransparency=0 end)
        else Lib:Notify({Title="Editor",Text="save failed",Type="error"}) end
    end)
    local W={Gui=gui,Main=main,Editor=editorBox,Visible=false,Execute=exec}
    local function setVis(st)
        if st==W.Visible then return end
        W.Visible=st
        if st then
            main.Visible=true
            main.Size=UDim2.new(0,size.X.Offset*0.9,0,size.Y.Offset*0.9)
            main.BackgroundTransparency=1
            main.Position=UDim2.new(0.5,0,0.55,0)
            tw(main,Lib.TI.spring,{Size=UDim2.new(0,size.X.Offset,0,size.Y.Offset),Position=UDim2.new(0.5,0,0.5,0),BackgroundTransparency=0})
        else
            local out=tw(main,Lib.TI.inout,{Size=UDim2.new(0,size.X.Offset*0.9,0,size.Y.Offset*0.9),BackgroundTransparency=1})
            out.Completed:Connect(function() if not W.Visible then main.Visible=false end end)
        end
    end
    function W:Toggle() setVis(not W.Visible) end
    function W:Show() setVis(true) end
    function W:Hide() setVis(false) end
    function W:SetCode(c) editorBox.Text=tostring(c) end
    function W:GetCode() return editorBox.Text end
    btnClose.MouseButton1Click:Connect(function()
        pcall(function()
            local out=TweenService:Create(main,Lib.TI.inout,{Position=UDim2.new(0.5,0,0.55,0),BackgroundTransparency=1})
            out:Play(); out.Completed:Connect(function() main.Visible=false; W.Visible=false end)
        end)
    end)
    btnMin.MouseButton1Click:Connect(function()
        tw(main,Lib.TI.med,{Size=UDim2.new(0,size.X.Offset,0,32)})
        task.delay(0.5,function() tw(main,Lib.TI.spring,{Size=UDim2.new(0,size.X.Offset,0,size.Y.Offset)}) end)
    end)
    drag(main,tb)
    task.wait(0.05)
    setVis(true)
    return W
end

local CFG="LzeSilentConfig"
local function ensureCfg()
    if type(isfolder)=="function" and type(makefolder)=="function" then
        if not isfolder(CFG) then pcall(makefolder,CFG) end
        return true
    end
    return false
end
function Lib:SaveConfig(name)
    if type(writefile)~="function" then self:Notify({Title="Config",Text="no fs",Type="error"}); return false end
    if not ensureCfg() then return false end
    name=name or "default"
    local ok,enc=pcall(function()
        local o={}
        for k,v in pairs(self.Flags) do
            if type(v)=="EnumItem" then o[k]={__t="E",n=v.Name,c=tostring(v.EnumType)}
            elseif type(v)=="Color3" then o[k]={__t="C",r=v.R,g=v.G,b=v.B}
            elseif type(v)=="table" then o[k]=v
            else o[k]=v end
        end
        return HttpService:JSONEncode(o)
    end)
    if not ok then return false end
    local path=CFG.."/"..name..".json"
    local ok2=pcall(writefile,path,enc)
    if ok2 then self:Notify({Title="Config",Text="saved: "..name,Type="success"}) end
    return ok2
end
function Lib:LoadConfig(name)
    if type(readfile)~="function" then self:Notify({Title="Config",Text="no fs",Type="error"}); return false end
    name=name or "default"
    local path=CFG.."/"..name..".json"
    local ok,content=pcall(readfile,path)
    if not ok then self:Notify({Title="Config",Text="not found: "..name,Type="error"}); return false end
    local dec
    local ok2=pcall(function() dec=HttpService:JSONDecode(content) end)
    if not ok2 then self:Notify({Title="Config",Text="corrupt file",Type="error"}); return false end
    for k,v in pairs(dec) do
        if type(v)=="table" and v.__t=="E" then
            local et=v.c:gsub("Enum%.","")
            local c=Enum[et]
            if c then self.Flags[k]=c[v.n] end
        elseif type(v)=="table" and v.__t=="C" then
            self.Flags[k]=Color3.new(v.r,v.g,v.B or v.b)
        else self.Flags[k]=v end
    end
    self:Notify({Title="Config",Text="loaded: "..name,Type="success"})
    return true
end
function Lib:ListConfigs()
    if type(listfiles)~="function" or type(isfolder)~="function" then return {} end
    if not isfolder(CFG) then return {} end
    local ok,files=pcall(listfiles,CFG)
    if not ok then return {} end
    local o={}
    for _,f in ipairs(files) do
        local nm=f:match("([^/\\]+)%.json$")
        if nm then table.insert(o,nm) end
    end
    return o
end
function Lib:Unload()
    pcall(function() for _,w in pairs(self.Windows) do if w.Gui and w.Gui.Parent then w.Gui:Destroy() end end end)
    pcall(function() if notifyGui and notifyGui.Parent then notifyGui:Destroy() end end)
    self.Windows={}
    self.Flags={}
end
function Lib:GetFlag(n) return self.Flags[n] end
function Lib:SetFlag(n,v) self.Flags[n]=v end
function Lib:GetWindows() return self.Windows end
function Lib:GetVersion() return self.Version end
function Lib:GetTheme() return self.Theme end

return Lib
