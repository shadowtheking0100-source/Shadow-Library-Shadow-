--[[
    FluentUI v1.3 — Clean Edition
    • Frame-drawn icons (zero dependency on asset IDs)
    • No screen blur
    • Strict alignment grid
    • 8 distinct themes
    • Full element suite + Save/Interface managers
]]

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")

-- ═══════════════════════════════════════════════════════
--  Icon System — drawn with Frames (always renders)
-- ═══════════════════════════════════════════════════════
local Icon = {}

local function el(parent, color, w, h, cx, cy, rot, transp)
    local f = Instance.new("Frame")
    f.BackgroundColor3 = color
    f.BackgroundTransparency = transp or 0
    f.BorderSizePixel = 0
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.fromOffset(cx, cy)
    f.Size = UDim2.fromOffset(w, h)
    f.Rotation = rot or 0
    f.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = f
    return f
end

local function ring(parent, color, d, cx, cy, thickness)
    local f = el(parent, color, d, d, cx, cy, 0, 1)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Parent = f
    return f
end

function Icon.make(name, size, color)
    local holder = Instance.new("Frame")
    holder.Name = "Icon_" .. tostring(name)
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.fromOffset(size, size)

    local s, c = size, size / 2
    local t = math.max(1.5, size / 9)

    if name == "menu" then
        el(holder, color, s*0.70, t, c, s*0.30)
        el(holder, color, s*0.70, t, c, s*0.50)
        el(holder, color, s*0.70, t, c, s*0.70)
    elseif name == "close" then
        el(holder, color, s*0.68, t, c, c,  45)
        el(holder, color, s*0.68, t, c, c, -45)
    elseif name == "minimize" then
        el(holder, color, s*0.70, t, c, c)
    elseif name == "check" then
        el(holder, color, s*0.34, t, s*0.32, s*0.60,  45)
        el(holder, color, s*0.66, t, s*0.60, s*0.40, -45)
    elseif name == "chevron-down" then
        el(holder, color, s*0.42, t, s*0.35, s*0.55,  45)
        el(holder, color, s*0.42, t, s*0.65, s*0.55, -45)
    elseif name == "chevron-up" then
        el(holder, color, s*0.42, t, s*0.35, s*0.45, -45)
        el(holder, color, s*0.42, t, s*0.65, s*0.45,  45)
    elseif name == "chevron-right" then
        el(holder, color, s*0.42, t, s*0.55, s*0.35, -45)
        el(holder, color, s*0.42, t, s*0.55, s*0.65,  45)
    elseif name == "chevron-left" then
        el(holder, color, s*0.42, t, s*0.45, s*0.35,  45)
        el(holder, color, s*0.42, t, s*0.45, s*0.65, -45)
    elseif name == "plus" then
        el(holder, color, s*0.70, t, c, c)
        el(holder, color, t, s*0.70, c, c)
    elseif name == "minus" then
        el(holder, color, s*0.70, t, c, c)
    elseif name == "dot" then
        el(holder, color, s*0.42, s*0.42, c, c)
    elseif name == "ring" then
        ring(holder, color, s*0.72, c, c, t)
    elseif name == "search" then
        ring(holder, color, s*0.55, s*0.40, s*0.40, t)
        el(holder, color, s*0.34, t, s*0.68, s*0.68, 45)
    elseif name == "sliders" then
        el(holder, color, s*0.76, t, c, s*0.28)
        el(holder, color, s*0.18, s*0.18, s*0.35, s*0.28)
        el(holder, color, s*0.76, t, c, s*0.50)
        el(holder, color, s*0.18, s*0.18, s*0.68, s*0.50)
        el(holder, color, s*0.76, t, c, s*0.72)
        el(holder, color, s*0.18, s*0.18, s*0.45, s*0.72)
    elseif name == "home" then
        el(holder, color, s*0.68, s*0.52, c, s*0.62)
        el(holder, color, s*0.52, t, s*0.34, s*0.36, -45)
        el(holder, color, s*0.52, t, s*0.66, s*0.36,  45)
    elseif name == "user" then
        el(holder, color, s*0.40, s*0.40, c, s*0.32)
        el(holder, color, s*0.70, s*0.40, c, s*0.76)
    elseif name == "info" then
        ring(holder, color, s*0.86, c, c, t)
        el(holder, color, t*1.4, t*1.4, c, s*0.30)
        el(holder, color, t,      s*0.32, c, s*0.62)
    elseif name == "text" then
        el(holder, color, s*0.70, t, c, s*0.30)
        el(holder, color, t,      s*0.60, c, s*0.60)
    elseif name == "list" then
        el(holder, color, s*0.16, s*0.16, s*0.20, s*0.30)
        el(holder, color, s*0.54, t,      s*0.55, s*0.30)
        el(holder, color, s*0.16, s*0.16, s*0.20, s*0.50)
        el(holder, color, s*0.54, t,      s*0.55, s*0.50)
        el(holder, color, s*0.16, s*0.16, s*0.20, s*0.70)
        el(holder, color, s*0.54, t,      s*0.55, s*0.70)
    elseif name == "keyboard" then
        ring(holder, color, s*0.88, c, s*0.62, t)
        el(holder, color, s*0.10, s*0.10, s*0.28, s*0.62)
        el(holder, color, s*0.10, s*0.10, s*0.50, s*0.62)
        el(holder, color, s*0.10, s*0.10, s*0.72, s*0.62)
        el(holder, color, s*0.34, s*0.10, c, s*0.80)
    elseif name == "palette" then
        el(holder, color, s*0.40, s*0.40, s*0.36, s*0.36)
        el(holder, color, s*0.30, s*0.30, s*0.68, s*0.48)
        el(holder, color, s*0.30, s*0.30, s*0.46, s*0.72)
    elseif name == "zap" then
        el(holder, color, s*0.28, s*0.32, s*0.42, s*0.36, -30)
        el(holder, color, s*0.28, s*0.32, s*0.58, s*0.64, -30)
        el(holder, color, s*0.28, s*0.14, s*0.50, s*0.50, -30)
    elseif name == "shield" then
        el(holder, color, s*0.66, s*0.50, c, s*0.44)
        el(holder, color, s*0.50, s*0.20, c, s*0.68)
        el(holder, color, s*0.30, s*0.20, c, s*0.68)
    elseif name == "eye" then
        el(holder, color, s*0.84, s*0.46, c, c)
        el(holder, color, s*0.26, s*0.26, c, c, 0, 0)
        el(holder, color, s*0.12, s*0.12, c, c, 0, 0)
    elseif name == "refresh" then
        ring(holder, color, s*0.70, c, c, t)
        el(holder, color, s*0.30, t, s*0.50, s*0.16, -25)
        el(holder, color, s*0.30, t, s*0.50, s*0.84, 155)
    elseif name == "trash" then
        el(holder, color, s*0.60, t, c, s*0.24)
        el(holder, color, s*0.22, s*0.12, c, s*0.16)
        el(holder, color, s*0.50, s*0.55, c, s*0.62)
    else
        el(holder, color, s*0.42, s*0.42, c, c)
    end
    return holder
end

local function makeIcon(parent, icon, size, color)
    if type(icon) == "number" or (type(icon) == "string" and icon:sub(1, 10) == "rbxassetid") then
        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.Image = (type(icon) == "number") and ("rbxassetid://" .. icon) or icon
        img.ImageColor3 = color or Color3.new(1,1,1)
        img.Size = UDim2.fromOffset(size, size)
        img.Parent = parent
        return img
    end
    local holder = Icon.make(icon or "dot", size, color)
    holder.Parent = parent
    return holder
end

-- ═══════════════════════════════════════════════════════
--  Themes (8 distinct palettes)
-- ═══════════════════════════════════════════════════════
local Themes = {
    Dark = {
        Bg=Color3.fromRGB(15,15,19), Bg2=Color3.fromRGB(20,20,26), Bg3=Color3.fromRGB(26,26,34),
        Surface=Color3.fromRGB(22,22,29), SurfaceHi=Color3.fromRGB(30,30,39),
        Text=Color3.fromRGB(235,236,242), SubText=Color3.fromRGB(140,143,155),
        Accent=Color3.fromRGB(99,102,241), AccentHi=Color3.fromRGB(125,128,255),
        AccentMuted=Color3.fromRGB(60,62,135),
        Border=Color3.fromRGB(38,38,48), BorderHi=Color3.fromRGB(52,52,66),
        Success=Color3.fromRGB(87,200,120), Warning=Color3.fromRGB(240,177,50),
        Error=Color3.fromRGB(237,66,69), Shadow=Color3.fromRGB(0,0,0),
    },
    Light = {
        Bg=Color3.fromRGB(248,249,252), Bg2=Color3.fromRGB(241,242,247), Bg3=Color3.fromRGB(230,232,240),
        Surface=Color3.fromRGB(255,255,255), SurfaceHi=Color3.fromRGB(245,246,250),
        Text=Color3.fromRGB(24,26,34), SubText=Color3.fromRGB(108,112,126),
        Accent=Color3.fromRGB(88,101,242), AccentHi=Color3.fromRGB(70,84,220),
        AccentMuted=Color3.fromRGB(200,205,250),
        Border=Color3.fromRGB(220,222,230), BorderHi=Color3.fromRGB(198,201,213),
        Success=Color3.fromRGB(60,180,100), Warning=Color3.fromRGB(230,155,30),
        Error=Color3.fromRGB(220,55,60), Shadow=Color3.fromRGB(140,140,160),
    },
    Midnight = {
        Bg=Color3.fromRGB(9,12,20), Bg2=Color3.fromRGB(14,18,29), Bg3=Color3.fromRGB(20,26,40),
        Surface=Color3.fromRGB(16,21,34), SurfaceHi=Color3.fromRGB(24,30,45),
        Text=Color3.fromRGB(216,224,240), SubText=Color3.fromRGB(118,130,158),
        Accent=Color3.fromRGB(56,189,248), AccentHi=Color3.fromRGB(96,206,255),
        AccentMuted=Color3.fromRGB(30,80,120),
        Border=Color3.fromRGB(26,34,52), BorderHi=Color3.fromRGB(40,52,76),
        Success=Color3.fromRGB(80,190,130), Warning=Color3.fromRGB(240,180,60),
        Error=Color3.fromRGB(240,80,90), Shadow=Color3.fromRGB(0,0,0),
    },
    Dracula = {
        Bg=Color3.fromRGB(28,26,38), Bg2=Color3.fromRGB(36,33,48), Bg3=Color3.fromRGB(46,42,60),
        Surface=Color3.fromRGB(40,37,54), SurfaceHi=Color3.fromRGB(52,48,68),
        Text=Color3.fromRGB(248,248,242), SubText=Color3.fromRGB(170,168,190),
        Accent=Color3.fromRGB(255,121,198), AccentHi=Color3.fromRGB(255,152,210),
        AccentMuted=Color3.fromRGB(130,60,100),
        Border=Color3.fromRGB(56,52,74), BorderHi=Color3.fromRGB(72,68,92),
        Success=Color3.fromRGB(80,250,123), Warning=Color3.fromRGB(241,250,140),
        Error=Color3.fromRGB(255,85,85), Shadow=Color3.fromRGB(0,0,0),
    },
    Nord = {
        Bg=Color3.fromRGB(38,42,52), Bg2=Color3.fromRGB(46,52,64), Bg3=Color3.fromRGB(58,66,82),
        Surface=Color3.fromRGB(50,56,70), SurfaceHi=Color3.fromRGB(62,70,86),
        Text=Color3.fromRGB(236,239,244), SubText=Color3.fromRGB(150,160,180),
        Accent=Color3.fromRGB(136,192,208), AccentHi=Color3.fromRGB(160,210,225),
        AccentMuted=Color3.fromRGB(60,90,105),
        Border=Color3.fromRGB(60,68,84), BorderHi=Color3.fromRGB(76,86,106),
        Success=Color3.fromRGB(163,190,140), Warning=Color3.fromRGB(235,203,139),
        Error=Color3.fromRGB(191,97,106), Shadow=Color3.fromRGB(0,0,0),
    },
    Emerald = {
        Bg=Color3.fromRGB(12,20,18), Bg2=Color3.fromRGB(18,28,25), Bg3=Color3.fromRGB(26,40,36),
        Surface=Color3.fromRGB(20,32,29), SurfaceHi=Color3.fromRGB(28,44,40),
        Text=Color3.fromRGB(228,242,238), SubText=Color3.fromRGB(140,172,162),
        Accent=Color3.fromRGB(52,211,153), AccentHi=Color3.fromRGB(96,226,178),
        AccentMuted=Color3.fromRGB(30,100,78),
        Border=Color3.fromRGB(34,52,46), BorderHi=Color3.fromRGB(46,70,62),
        Success=Color3.fromRGB(90,210,140), Warning=Color3.fromRGB(240,190,70),
        Error=Color3.fromRGB(235,90,100), Shadow=Color3.fromRGB(0,0,0),
    },
    Rose = {
        Bg=Color3.fromRGB(24,15,20), Bg2=Color3.fromRGB(32,22,28), Bg3=Color3.fromRGB(44,30,38),
        Surface=Color3.fromRGB(36,26,32), SurfaceHi=Color3.fromRGB(48,35,42),
        Text=Color3.fromRGB(250,232,238), SubText=Color3.fromRGB(192,155,168),
        Accent=Color3.fromRGB(244,114,182), AccentHi=Color3.fromRGB(255,140,200),
        AccentMuted=Color3.fromRGB(120,55,88),
        Border=Color3.fromRGB(54,38,46), BorderHi=Color3.fromRGB(70,52,60),
        Success=Color3.fromRGB(120,200,150), Warning=Color3.fromRGB(245,190,80),
        Error=Color3.fromRGB(240,80,90), Shadow=Color3.fromRGB(0,0,0),
    },
    Monokai = {
        Bg=Color3.fromRGB(30,30,26), Bg2=Color3.fromRGB(38,38,33), Bg3=Color3.fromRGB(50,50,44),
        Surface=Color3.fromRGB(42,42,36), SurfaceHi=Color3.fromRGB(54,54,46),
        Text=Color3.fromRGB(248,248,242), SubText=Color3.fromRGB(160,160,150),
        Accent=Color3.fromRGB(230,219,116), AccentHi=Color3.fromRGB(245,238,150),
        AccentMuted=Color3.fromRGB(110,105,55),
        Border=Color3.fromRGB(58,58,50), BorderHi=Color3.fromRGB(74,74,64),
        Success=Color3.fromRGB(166,226,46), Warning=Color3.fromRGB(253,151,31),
        Error=Color3.fromRGB(249,38,114), Shadow=Color3.fromRGB(0,0,0),
    },
}

-- ═══════════════════════════════════════════════════════
--  Utilities
-- ═══════════════════════════════════════════════════════
local U = {}
function U.new(c, p) local i = Instance.new(c); for k,v in pairs(p or {}) do i[k]=v end; return i end
function U.tween(i, p, d, s, dir)
    local t = TweenService:Create(i, TweenInfo.new(d or 0.2, s or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), p)
    t:Play(); return t
end
function U.corner(p, r) return U.new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p }) end
function U.stroke(p, c, t, tr) return U.new("UIStroke", { Color=c, Thickness=t or 1, Transparency=tr or 0, ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=p }) end
function U.pad(p, t, b, l, r) return U.new("UIPadding", { PaddingTop=UDim.new(0,t), PaddingBottom=UDim.new(0,b), PaddingLeft=UDim.new(0,l), PaddingRight=UDim.new(0,r), Parent=p }) end
function U.shadow(p, c, tr)
    return U.new("ImageLabel", { Name="Sh", BackgroundTransparency=1, Image="rbxassetid://6014261993",
        ImageColor3=c or Color3.new(0,0,0), ImageTransparency=tr or 0.55, ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450), Size=UDim2.new(1,32,1,32), Position=UDim2.new(0,-16,0,-16),
        ZIndex=-1, Parent=p })
end
function U.drag(frame, handle, bounds)
    handle = handle or frame
    local dr, di, ds, sp
    local function up(i)
        local d = i.Position - ds
        local np = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        if bounds then
            local vp = workspace.CurrentCamera.ViewportSize
            local a = frame.AbsoluteSize
            np = UDim2.fromOffset(
                math.clamp(np.X.Offset+np.X.Scale*vp.X, bounds.minX, vp.X-a.X-bounds.maxX),
                math.clamp(np.Y.Offset+np.Y.Scale*vp.Y, bounds.minY, vp.Y-a.Y-bounds.maxY))
        end
        frame.Position = np
    end
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dr = true; ds = i.Position; sp = frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dr = false end end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UserInputService.InputChanged:Connect(function(i) if i == di and dr then up(i) end end)
end
function U.ripple(btn, color)
    btn.MouseButton1Down:Connect(function()
        local sz = btn.AbsoluteSize
        local maxD = math.max(sz.X, sz.Y) * 2
        local r = U.new("Frame", { Size=UDim2.fromOffset(0,0), AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.fromOffset(sz.X/2, sz.Y/2), BackgroundColor3=color or Color3.new(1,1,1),
            BackgroundTransparency=0.78, BorderSizePixel=0, ZIndex=5, Parent=btn })
        U.corner(r, maxD)
        TweenService:Create(r, TweenInfo.new(0.55, Enum.EasingStyle.Quart), {
            Size=UDim2.fromOffset(maxD,maxD), BackgroundTransparency=1 }):Play()
        task.delay(0.55, function() if r then r:Destroy() end end)
    end)
end
function U.round(n, d) local m = 10^(d or 0); return math.floor(n*m+0.5)/m end
function U.toHex(c) return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)) end
function U.fromHex(h) h = h:gsub("#",""); if #h ~= 6 then return nil end
    return Color3.fromRGB(tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16)) end

-- ═══════════════════════════════════════════════════════
--  Library Root
-- ═══════════════════════════════════════════════════════
local Fluent = {
    Version = "1.3.0", Icons = {
        Menu="menu", Close="close", Minimize="minimize", Check="check",
        ChevronDown="chevron-down", ChevronUp="chevron-up",
        ChevronRight="chevron-right", ChevronLeft="chevron-left",
        Plus="plus", Minus="minus", Dot="dot", Ring="ring", Search="search",
        Sliders="sliders", Home="home", User="user", Info="info", Text="text",
        List="list", Keyboard="keyboard", Palette="palette", Zap="zap",
        Shield="shield", Eye="eye", Refresh="refresh", Trash="trash",
        -- aliases
        Settings="sliders", Toggle="sliders", Slider="sliders",
        Dropdown="list", Colorpicker="palette", Keybind="keyboard",
        Textbox="text", Button="chevron-right", Paragraph="info",
        Star="ring", Sparkles="ring", Bell="info", Save="check",
        Upload="chevron-up", Download="chevron-down", Package="home",
        Crosshair="ring", Camera="ring", Rocket="chevron-up",
        Gamepad="home", Sun="ring", Moon="ring", Heart="ring",
        User2="user", Copy="check",
    },
    Themes = Themes, Options = {}, Theme = "Dark", Unloaded = false,
}

-- ═══════════════════════════════════════════════════════
--  Floating Toggle Button
-- ═══════════════════════════════════════════════════════
function Fluent:CreateToggleButton(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local gui = U.new("ScreenGui", { Name="FluentToggle", ResetOnSpawn=false,
        ZIndexBehavior=Enum.ZIndexBehavior.Sibling, IgnoreGuiInset=true,
        DisplayOrder=9999, Parent=CoreGui })

    local size = cfg.Size or 48
    local btn = U.new("ImageButton", { Name="Btn", Size=UDim2.fromOffset(size,size),
        Position=cfg.Position or UDim2.new(0, 20, 0.5, -size/2),
        BackgroundColor3=theme.Surface, BorderSizePixel=0, Image="",
        AutoButtonColor=false, Parent=gui })
    U.corner(btn, size/2)
    U.stroke(btn, theme.BorderHi, 1)
    U.shadow(btn, theme.Shadow, 0.4)

    local holder = U.new("Frame", { BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=btn })
    local color = theme.Text
    local barSize = UDim2.fromOffset(math.floor(size*0.42), 2)
    local barX = (size - barSize.X.Offset) / 2
    local b1 = U.new("Frame", { Size=barSize, Position=UDim2.fromOffset(barX, size/2 - 6),
        BackgroundColor3=color, BorderSizePixel=0, Parent=holder }); U.corner(b1, 2)
    local b2 = U.new("Frame", { Size=barSize, Position=UDim2.fromOffset(barX, size/2 - 1),
        BackgroundColor3=color, BorderSizePixel=0, Parent=holder }); U.corner(b2, 2)
    local b3 = U.new("Frame", { Size=barSize, Position=UDim2.fromOffset(barX, size/2 + 4),
        BackgroundColor3=color, BorderSizePixel=0, Parent=holder }); U.corner(b3, 2)

    local function setOpen(open)
        if open then
            U.tween(b1, { Position=UDim2.fromOffset(barX, size/2-1), Rotation=45 }, 0.22, Enum.EasingStyle.Back)
            U.tween(b3, { Position=UDim2.fromOffset(barX, size/2-1), Rotation=-45 }, 0.22, Enum.EasingStyle.Back)
            U.tween(b2, { BackgroundTransparency=1 }, 0.15)
        else
            U.tween(b1, { Position=UDim2.fromOffset(barX, size/2-6), Rotation=0 }, 0.22, Enum.EasingStyle.Back)
            U.tween(b3, { Position=UDim2.fromOffset(barX, size/2+4), Rotation=0 }, 0.22, Enum.EasingStyle.Back)
            U.tween(b2, { BackgroundTransparency=0 }, 0.15)
        end
    end

    btn.MouseEnter:Connect(function()
        U.tween(btn, { BackgroundColor3=theme.SurfaceHi }, 0.15)
        U.tween(btn, { Size=UDim2.fromOffset(size+4, size+4) }, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        U.tween(btn, { BackgroundColor3=theme.Surface }, 0.15)
        U.tween(btn, { Size=UDim2.fromOffset(size, size) }, 0.15)
    end)

    U.drag(btn, btn, { minX=6, maxX=6, minY=6, maxY=6 })

    local pressPos, dragged
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            pressPos = i.Position; dragged = false
        end
    end)
    btn.InputChanged:Connect(function(i)
        if pressPos and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            if (i.Position - pressPos).Magnitude > 6 then dragged = true end
        end
    end)
    btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if not dragged and cfg.OnClick then cfg.OnClick() end
            pressPos = nil
        end
    end)

    btn.Size = UDim2.fromOffset(0, 0)
    U.tween(btn, { Size=UDim2.fromOffset(size, size) }, 0.4, Enum.EasingStyle.Back)

    self.ToggleButton = btn
    self.ToggleButtonGui = gui
    self.ToggleButtonSetOpen = setOpen
    return { Instance=btn, SetOpen=setOpen, Destroy=function() gui:Destroy() end }
end

-- ═══════════════════════════════════════════════════════
--  Window
-- ═══════════════════════════════════════════════════════
local Window = {}
Window.__index = Window

-- Layout constants
local ELEM_PAD   = 14   -- inner padding of any element frame
local ICON_SIZE  = 16
local ICON_GAP   = 12
local TEXT_X     = ELEM_PAD + ICON_SIZE + ICON_GAP  -- = 42
local RIGHT_END  = ELEM_PAD                          -- controls end at this from right
local ROW_H      = 44
local ROW_H_DESC = 54

function Fluent:CreateWindow(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, Window)

    self.Title       = cfg.Title or "FluentUI"
    self.SubTitle    = cfg.SubTitle or ""
    self.TabWidth    = cfg.TabWidth or 180
    self.Size        = cfg.Size or UDim2.fromOffset(660, 520)
    self.Theme       = cfg.Theme or Fluent.Theme
    self.MinimizeKey = cfg.MinimizeKey or Enum.KeyCode.LeftControl
    self.ToggleKey   = cfg.ToggleKey or Enum.KeyCode.RightShift
    self.CornerR     = cfg.CornerRadius or 14
    self.Minimized   = false
    self.Hidden      = false
    self.Tabs        = {}
    self.SelectedTab = nil
    self.DialogOpen  = false

    local theme = Themes[self.Theme] or Themes.Dark

    self.GUI = U.new("ScreenGui", { Name="FluentUI_"..HttpService:GenerateGUID(false),
        ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset=true, DisplayOrder=999, Parent=CoreGui })

    self.Root = U.new("Frame", { Name="Root", Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1, Parent=self.GUI })

    self.Frame = U.new("Frame", { Name="Window", Size=self.Size,
        Position=UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2),
        BackgroundColor3=theme.Bg, BorderSizePixel=0, ClipsDescendants=true, Parent=self.Root })
    U.corner(self.Frame, self.CornerR)
    U.stroke(self.Frame, theme.Border, 1)
    U.shadow(self.Frame, theme.Shadow, 0.5)

    -- Title bar
    self.TitleBar = U.new("Frame", { Name="TitleBar", Size=UDim2.new(1,0,0,52),
        BackgroundColor3=theme.Bg2, BorderSizePixel=0, Parent=self.Frame })
    U.new("UIGradient", { Color=ColorSequence.new(theme.Bg3, theme.Bg2), Rotation=90, Parent=self.TitleBar })

    -- Brand chip
    local chip = U.new("Frame", { Size=UDim2.fromOffset(30,30),
        Position=UDim2.fromOffset(14, 11),
        BackgroundColor3=theme.Accent, BorderSizePixel=0, Parent=self.TitleBar })
    U.corner(chip, 9)
    U.new("UIGradient", { Color=ColorSequence.new(theme.AccentHi, theme.Accent), Rotation=135, Parent=chip })
    local chipIcon = makeIcon(chip, "dot", 14, Color3.new(1,1,1))
    chipIcon.Position = UDim2.fromOffset(8, 8)
    chipIcon.AnchorPoint = Vector2.new(0, 0)

    self.TitleLabel = U.new("TextLabel", { Text=self.Title, Font=Enum.Font.GothamBold, TextSize=14,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(54, self.SubTitle ~= "" and 8 or 0),
        Size=UDim2.new(0, 260, 0, self.SubTitle ~= "" and 20 or 52),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=self.TitleBar })

    if self.SubTitle ~= "" then
        U.new("TextLabel", { Text=self.SubTitle, Font=Enum.Font.Gotham, TextSize=11,
            TextColor3=theme.SubText, BackgroundTransparency=1,
            Position=UDim2.fromOffset(54, 28), Size=UDim2.new(0, 260, 0, 16),
            TextXAlignment=Enum.TextXAlignment.Left, Parent=self.TitleBar })
    end

    -- Window controls
    local function ctrlBtn(iconName, xOff, hoverColor)
        local holder = U.new("Frame", { BackgroundTransparency=1, Size=UDim2.fromOffset(28,28),
            Position=UDim2.new(1, xOff, 0.5, -14), Parent=self.TitleBar })
        local btn = U.new("TextButton", { Text="", BackgroundTransparency=1,
            Size=UDim2.fromScale(1,1), AutoButtonColor=false, Parent=holder })
        local ic = makeIcon(holder, iconName, 14, theme.SubText)
        ic.Position = UDim2.fromOffset(7, 7); ic.AnchorPoint = Vector2.new(0,0)
        btn.MouseEnter:Connect(function()
            U.tween(ic, { ImageColor3=hoverColor or theme.Text }, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            U.tween(ic, { ImageColor3=theme.SubText }, 0.15)
        end)
        return btn, holder
    end

    self.MinBtn = ctrlBtn("minimize", -70, theme.Text)
    self.CloseBtn = ctrlBtn("close", -36, theme.Error)

    -- Tab sidebar
    self.TabList = U.new("ScrollingFrame", { Name="Tabs", Size=UDim2.new(0, self.TabWidth, 1, -52),
        Position=UDim2.fromOffset(0, 52), BackgroundColor3=theme.Bg2, BorderSizePixel=0,
        ScrollBarThickness=2, ScrollBarImageColor3=theme.Border,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=self.Frame })
    U.new("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder, Parent=self.TabList })
    U.pad(self.TabList, 10, 10, 8, 8)

    -- Divider
    U.new("Frame", { Size=UDim2.new(0,1,1,-52), Position=UDim2.new(0, self.TabWidth, 0, 52),
        BackgroundColor3=theme.Border, BorderSizePixel=0, BackgroundTransparency=0.3, Parent=self.Frame })

    -- Content
    self.Content = U.new("ScrollingFrame", { Name="Content", Size=UDim2.new(1, -self.TabWidth, 1, -52),
        Position=UDim2.new(0, self.TabWidth, 0, 52), BackgroundColor3=theme.Bg,
        BorderSizePixel=0, ScrollBarThickness=2, ScrollBarImageColor3=theme.Border,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=self.Frame })
    U.new("UIListLayout", { Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder, Parent=self.Content })
    U.pad(self.Content, 16, 16, 16, 16)

    -- Notification stack
    self.NotifyBox = U.new("Frame", { Name="Notifs", Size=UDim2.new(0, 340, 1, 0),
        Position=UDim2.new(1, -356, 0, 0), BackgroundTransparency=1, Parent=self.GUI })
    U.new("UIListLayout", { Padding=UDim.new(0,10), SortOrder=Enum.SortOrder.LayoutOrder,
        VerticalAlignment=Enum.VerticalAlignment.Bottom,
        HorizontalAlignment=Enum.HorizontalAlignment.Right, Parent=self.NotifyBox })

    -- Dialog overlay
    self.DialogLayer = U.new("TextButton", { Name="DialogLayer", Size=UDim2.fromScale(1,1),
        BackgroundColor3=Color3.new(0,0,0), BackgroundTransparency=1, Text="", Visible=false, Parent=self.GUI })

    U.drag(self.Frame, self.TitleBar)
    self.MinBtn.MouseButton1Click:Connect(function() self:ToggleMinimize() end)
    self.CloseBtn.MouseButton1Click:Connect(function() self:Destroy() end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.MinimizeKey then self:ToggleMinimize() end
        if input.KeyCode == self.ToggleKey then self:ToggleVisibility() end
    end)

    self.ToggleBtnHandle = Fluent:CreateToggleButton({ OnClick=function() self:ToggleVisibility() end })
    self._syncToggle = function(v) if Fluent.ToggleButtonSetOpen then Fluent.ToggleButtonSetOpen(v) end end
    self._syncToggle(true)

    Fluent.Window = self
    return self
end

function Window:ToggleVisibility(force)
    self.Hidden = (force ~= nil) and force or (not self.Hidden)
    local visible = not self.Hidden
    if visible then
        self.Root.Visible = true
        self.Frame.Size = UDim2.fromOffset(self.Size.X.Offset*0.95, self.Size.Y.Offset*0.95)
        self.Frame.Position = UDim2.new(0.5, -self.Size.X.Offset*0.475, 0.5, -self.Size.Y.Offset*0.475)
        U.tween(self.Frame, { Size=self.Size,
            Position=UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2) },
            0.28, Enum.EasingStyle.Back)
    else
        U.tween(self.Frame, { Size=UDim2.fromOffset(self.Size.X.Offset*0.95, self.Size.Y.Offset*0.95),
            Position=UDim2.new(0.5, -self.Size.X.Offset*0.475, 0.5, -self.Size.Y.Offset*0.475) },
            0.2, Enum.EasingStyle.Quart)
        task.delay(0.2, function() if self.Hidden then self.Root.Visible = false end end)
    end
    if self._syncToggle then self._syncToggle(visible) end
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        U.tween(self.Frame, { Size=UDim2.new(0, self.Size.X.Offset, 0, 52) }, 0.3, Enum.EasingStyle.Quart)
        self.TabList.Visible = false; self.Content.Visible = false
    else
        U.tween(self.Frame, { Size=self.Size }, 0.3, Enum.EasingStyle.Quart)
        self.TabList.Visible = true; self.Content.Visible = true
    end
end

function Window:AddTab(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local tab = { Title=cfg.Title or "Tab", Icon=cfg.Icon, Window=self, Elements={} }

    tab.Button = U.new("TextButton", { Name=tab.Title, Text="", BackgroundColor3=theme.Bg2,
        BackgroundTransparency=1, BorderSizePixel=0, Size=UDim2.new(1,0,0,38),
        AutoButtonColor=false, Parent=self.TabList })
    U.corner(tab.Button, 8)

    -- Active indicator
    tab.Indicator = U.new("Frame", { Size=UDim2.new(0, 3, 0, 0),
        Position=UDim2.new(0, 0, 0.5, 0), AnchorPoint=Vector2.new(0, 0.5),
        BackgroundColor3=theme.Accent, BorderSizePixel=0, BackgroundTransparency=1, Parent=tab.Button })
    U.corner(tab.Indicator, 2)

    local iconOffset = 0
    if tab.Icon then
        tab.IconImg = makeIcon(tab.Button, tab.Icon, 16, theme.SubText)
        tab.IconImg.Position = UDim2.fromOffset(16, 11)
        tab.IconImg.AnchorPoint = Vector2.new(0,0)
        iconOffset = 30
    end

    tab.Label = U.new("TextLabel", { Text=tab.Title, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.SubText, BackgroundTransparency=1,
        Position=UDim2.fromOffset(14 + iconOffset, 0),
        Size=UDim2.new(1, -(14 + iconOffset), 1, 0),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=tab.Button })

    tab.Button.MouseEnter:Connect(function()
        if self.SelectedTab ~= tab then
            U.tween(tab.Button, { BackgroundColor3=theme.Bg3, BackgroundTransparency=0.4 }, 0.16)
        end
    end)
    tab.Button.MouseLeave:Connect(function()
        if self.SelectedTab ~= tab then
            U.tween(tab.Button, { BackgroundTransparency=1 }, 0.16)
        end
    end)
    tab.Button.MouseButton1Click:Connect(function() self:SelectTab(tab) end)

    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then self:SelectTab(tab) end
    return tab
end

function Window:SelectTab(tab)
    local theme = Themes[self.Theme] or Themes.Dark
    self.SelectedTab = tab
    for _, t in ipairs(self.Tabs) do
        local active = (t == tab)
        U.tween(t.Button, { BackgroundColor3=active and theme.Bg3 or theme.Bg2,
            BackgroundTransparency=active and 0 or 1 }, 0.2)
        U.tween(t.Label, { TextColor3=active and theme.Text or theme.SubText }, 0.2)
        if t.IconImg then U.tween(t.IconImg, { ImageColor3=active and theme.Accent or theme.SubText }, 0.2) end
        if t.Indicator then
            U.tween(t.Indicator, { Size=UDim2.new(0, 3, 0, active and 20 or 0),
                BackgroundTransparency=active and 0 or 1 }, 0.25, Enum.EasingStyle.Quart)
        end
    end
    for _, c in ipairs(self.Content:GetChildren()) do
        if c:IsA("GuiObject") and not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
            c.Visible = false
        end
    end
    for _, el in ipairs(tab.Elements) do if el.Instance then el.Instance.Visible = true end end
end

-- ═══════════════════════════════════════════════════════
--  Elements — strict alignment
-- ═══════════════════════════════════════════════════════
local function push(win, el) if win.SelectedTab then table.insert(win.SelectedTab.Elements, el) end; return el end
local function baseFrame(win, name, height)
    local theme = Themes[win.Theme]
    local f = U.new("Frame", { Name=name, Size=UDim2.new(1,0,0,height),
        BackgroundColor3=theme.Surface, BorderSizePixel=0, Parent=win.Content })
    U.corner(f, 10); U.stroke(f, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=f })
    return f
end

function Window:AddSection(name)
    local theme = Themes[self.Theme]
    local inst = U.new("Frame", { Size=UDim2.new(1,0,0,26), BackgroundTransparency=1, Parent=self.Content })
    local bar = U.new("Frame", { Size=UDim2.new(0,3,0,12), Position=UDim2.fromOffset(0,7),
        BackgroundColor3=theme.Accent, BorderSizePixel=0, Parent=inst })
    U.corner(bar, 2)
    U.new("UIGradient", { Color=ColorSequence.new(theme.AccentHi, theme.Accent), Rotation=90, Parent=bar })
    U.new("TextLabel", { Text=string.upper(name), Font=Enum.Font.GothamBold, TextSize=10,
        TextColor3=theme.SubText, BackgroundTransparency=1,
        Position=UDim2.fromOffset(12,0), Size=UDim2.new(1,-12,1,0),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst })
    return push(self, { Instance=inst })
end

function Window:AddParagraph(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme]
    local inst = U.new("Frame", { Size=UDim2.new(1,0,0,68), BackgroundColor3=theme.Surface,
        BorderSizePixel=0, Parent=self.Content })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=inst })

    local ic = makeIcon(inst, cfg.Icon or "info", ICON_SIZE, theme.Accent)
    ic.Position = UDim2.fromOffset(ELEM_PAD, 13); ic.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or "Paragraph", Font=Enum.Font.GothamBold, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(TEXT_X, 13), Size=UDim2.new(1, -TEXT_X - ELEM_PAD, 0, 16),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst })
    U.new("TextLabel", { Text=cfg.Content or "", Font=Enum.Font.Gotham, TextSize=11,
        TextColor3=theme.SubText, BackgroundTransparency=1,
        Position=UDim2.fromOffset(ELEM_PAD, 38), Size=UDim2.new(1, -ELEM_PAD*2, 1, -46),
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=inst })
    return push(self, { Instance=inst })
end

function Window:AddButton(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme]
    local h = cfg.Description and ROW_H_DESC or ROW_H
    local inst = U.new("TextButton", { Text="", BackgroundColor3=theme.Surface,
        BorderSizePixel=0, Size=UDim2.new(1,0,0,h), AutoButtonColor=false, Parent=self.Content })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=inst })

    local ic = makeIcon(inst, cfg.Icon or "chevron-right", ICON_SIZE, theme.Accent)
    ic.Position = UDim2.fromOffset(ELEM_PAD, h/2 - ICON_SIZE/2); ic.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or "Button", Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(TEXT_X, cfg.Description and 10 or 0),
        Size=UDim2.new(1, -TEXT_X - 30, 0, cfg.Description and 18 or h),
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=cfg.Description and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        Parent=inst })
    if cfg.Description then
        U.new("TextLabel", { Text=cfg.Description, Font=Enum.Font.Gotham, TextSize=10,
            TextColor3=theme.SubText, BackgroundTransparency=1,
            Position=UDim2.fromOffset(TEXT_X, 30), Size=UDim2.new(1, -TEXT_X - 30, 0, 16),
            TextXAlignment=Enum.TextXAlignment.Left, Parent=inst })
    end

    local ch = makeIcon(inst, "chevron-right", 14, theme.SubText)
    ch.Position = UDim2.new(1, -RIGHT_END - 14, 0.5, -7); ch.AnchorPoint = Vector2.new(0,0)

    inst.MouseEnter:Connect(function() U.tween(inst, { BackgroundColor3=theme.SurfaceHi }, 0.16) end)
    inst.MouseLeave:Connect(function() U.tween(inst, { BackgroundColor3=theme.Surface }, 0.16) end)
    U.ripple(inst, theme.Accent)
    inst.MouseButton1Click:Connect(function() if cfg.Callback then task.spawn(cfg.Callback) end end)
    return push(self, { Instance=inst })
end

function Window:AddToggle(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme]
    local h = cfg.Description and ROW_H_DESC or ROW_H
    local t = { Value = cfg.Default or false, Callbacks = {} }

    local inst = U.new("Frame", { BackgroundColor3=theme.Surface, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,h), Parent=self.Content })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=inst })

    local ic = makeIcon(inst, cfg.Icon or "sliders", ICON_SIZE, theme.Accent)
    ic.Position = UDim2.fromOffset(ELEM_PAD, h/2 - ICON_SIZE/2); ic.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(TEXT_X, cfg.Description and 10 or 0),
        Size=UDim2.new(1, -TEXT_X - 60, 0, cfg.Description and 18 or h),
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=cfg.Description and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        Parent=inst })
    if cfg.Description then
        U.new("TextLabel", { Text=cfg.Description, Font=Enum.Font.Gotham, TextSize=10,
            TextColor3=theme.SubText, BackgroundTransparency=1,
            Position=UDim2.fromOffset(TEXT_X, 30), Size=UDim2.new(1, -TEXT_X - 60, 0, 16),
            TextXAlignment=Enum.TextXAlignment.Left, Parent=inst })
    end

    local swBg = U.new("Frame", { Size=UDim2.fromOffset(40,22),
        Position=UDim2.new(1, -RIGHT_END - 40, 0.5, -11),
        BackgroundColor3=t.Value and theme.Accent or theme.Border, BorderSizePixel=0, Parent=inst })
    U.corner(swBg, 11)
    local swGrad = U.new("UIGradient", { Color=ColorSequence.new(theme.AccentHi, theme.Accent),
        Rotation=135, Enabled=t.Value, Parent=swBg })
    local knob = U.new("Frame", { Size=UDim2.fromOffset(18,18),
        Position=UDim2.new(0, t.Value and 20 or 2, 0.5, -9),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=swBg })
    U.corner(knob, 9)

    local click = U.new("TextButton", { Text="", BackgroundTransparency=1,
        Size=UDim2.fromScale(1,1), Parent=inst })

    local function setValue(v)
        t.Value = v
        U.tween(swBg, { BackgroundColor3 = v and theme.Accent or theme.Border }, 0.22)
        swGrad.Enabled = v
        U.tween(knob, { Position=UDim2.new(0, v and 20 or 2, 0.5, -9) }, 0.24, Enum.EasingStyle.Back)
        for _, cb in ipairs(t.Callbacks) do task.spawn(cb, v) end
        if cfg.Callback then task.spawn(cfg.Callback, v) end
    end
    click.MouseButton1Click:Connect(function() setValue(not t.Value) end)

    t.Instance = inst; t.SetValue = setValue
    t.GetValue = function() return t.Value end
    t.OnChanged = function(cb) table.insert(t.Callbacks, cb) end
    Fluent.Options[id] = t
    return push(self, t)
end

function Window:AddSlider(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme]
    local mn, mx = cfg.Min or 0, cfg.Max or 100
    local sl = { Value = cfg.Default or mn, Callbacks = {} }

    local inst = U.new("Frame", { BackgroundColor3=theme.Surface, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,66), Parent=self.Content })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=inst })

    local ic = makeIcon(inst, cfg.Icon or "sliders", ICON_SIZE, theme.Accent)
    ic.Position = UDim2.fromOffset(ELEM_PAD, 11); ic.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(TEXT_X, 11), Size=UDim2.new(1, -TEXT_X - 70, 0, 16),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst })

    local val = U.new("TextLabel", { Text=tostring(sl.Value), Font=Enum.Font.GothamBold, TextSize=11,
        TextColor3=theme.Accent, BackgroundTransparency=1,
        Position=UDim2.new(1, -RIGHT_END - 50, 0, 11), Size=UDim2.fromOffset(50,16),
        TextXAlignment=Enum.TextXAlignment.Right, Parent=inst })

    local track = U.new("Frame", { Size=UDim2.new(1, -ELEM_PAD*2, 0, 6),
        Position=UDim2.fromOffset(ELEM_PAD, 44), BackgroundColor3=theme.Border,
        BorderSizePixel=0, Parent=inst })
    U.corner(track, 3)
    local fill = U.new("Frame", { Size=UDim2.new(0,0,1,0), BackgroundColor3=theme.Accent,
        BorderSizePixel=0, Parent=track })
    U.corner(fill, 3)
    U.new("UIGradient", { Color=ColorSequence.new(theme.AccentHi, theme.Accent), Parent=fill })

    local knob = U.new("Frame", { Size=UDim2.fromOffset(14,14),
        Position=UDim2.new(0, -7, 0.5, -7), BackgroundColor3=Color3.new(1,1,1),
        BorderSizePixel=0, Parent=track })
    U.corner(knob, 7); U.stroke(knob, theme.Accent, 2)

    local function calc(i)
        local start, w = track.AbsolutePosition.X, track.AbsoluteSize.X
        local rel = math.clamp((i.Position.X - start) / w, 0, 1)
        local r = cfg.Rounding or 0
        local v = U.round(mn + (mx - mn) * rel, r)
        sl.Value = v
        val.Text = (r == 0) and tostring(math.floor(v)) or string.format("%."..r.."f", v)
        local p = (v - mn) / (mx - mn)
        U.tween(fill, { Size=UDim2.new(p, 0, 1, 0) }, 0.08)
        U.tween(knob, { Position=UDim2.new(p, -7, 0.5, -7) }, 0.08)
        for _, cb in ipairs(sl.Callbacks) do task.spawn(cb, v) end
        if cfg.Callback then task.spawn(cfg.Callback, v) end
    end

    local drag = false
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; calc(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then calc(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)

    local p0 = (sl.Value - mn) / (mx - mn)
    fill.Size = UDim2.new(p0, 0, 1, 0)
    knob.Position = UDim2.new(p0, -7, 0.5, -7)

    sl.Instance = inst
    sl.SetValue = function(v)
        sl.Value = v
        local p = (v - mn) / (mx - mn)
        val.Text = tostring(v)
        U.tween(fill, { Size=UDim2.new(p, 0, 1, 0) }, 0.15)
        U.tween(knob, { Position=UDim2.new(p, -7, 0.5, -7) }, 0.15)
    end
    sl.GetValue = function() return sl.Value end
    sl.OnChanged = function(cb) table.insert(sl.Callbacks, cb) end
    Fluent.Options[id] = sl
    return push(self, sl)
end

function Window:AddDropdown(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme]
    local multi = cfg.Multi or false
    local dd = {
        Value = cfg.Default or (multi and {} or nil),
        Options = cfg.Values or {}, Multi = multi, Callbacks = {}, Expanded = false,
    }

    local inst = U.new("Frame", { BackgroundColor3=theme.Surface, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,ROW_H), ClipsDescendants=false, Parent=self.Content })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=inst })

    local ic = makeIcon(inst, cfg.Icon or "list", ICON_SIZE, theme.Accent)
    ic.Position = UDim2.fromOffset(ELEM_PAD, ROW_H/2 - ICON_SIZE/2); ic.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(TEXT_X, 0), Size=UDim2.new(1, -TEXT_X - 100, 1, 0),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst })

    local arrow = makeIcon(inst, "chevron-down", 14, theme.SubText)
    arrow.Position = UDim2.new(1, -RIGHT_END - 14, 0.5, -7); arrow.AnchorPoint = Vector2.new(0,0)

    local previewTxt = "Select..."
    if multi and type(dd.Value) == "table" then
        previewTxt = #dd.Value > 0 and table.concat(dd.Value, ", ") or "Select..."
    elseif dd.Value then previewTxt = tostring(dd.Value) end
    local preview = U.new("TextLabel", { Text=previewTxt, Font=Enum.Font.Gotham, TextSize=10,
        TextColor3=theme.SubText, BackgroundTransparency=1,
        Position=UDim2.new(1, -RIGHT_END - 88, 0.5, -8), Size=UDim2.fromOffset(60,16),
        TextXAlignment=Enum.TextXAlignment.Right, TextTruncate=Enum.TextTruncate.AtEnd, Parent=inst })

    local popup = U.new("ScrollingFrame", { Size=UDim2.new(1,0,0,0),
        Position=UDim2.new(0,0,1,6), BackgroundColor3=theme.Bg3, BorderSizePixel=0,
        Visible=false, ZIndex=20, ScrollBarThickness=2, ScrollBarImageColor3=theme.Border,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=inst })
    U.corner(popup, 10); U.stroke(popup, theme.BorderHi, 1)
    U.pad(popup, 6, 6, 6, 6)
    U.new("UIListLayout", { Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder, Parent=popup })
    U.shadow(popup, theme.Shadow, 0.4)

    local searchBox
    if cfg.Searchable ~= false and #dd.Options > 6 then
        local sf = U.new("Frame", { Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, Parent=popup })
        searchBox = U.new("TextBox", { Text="", PlaceholderText="Search...",
            Font=Enum.Font.Gotham, TextSize=11, TextColor3=theme.Text, PlaceholderColor3=theme.SubText,
            BackgroundColor3=theme.Surface, BorderSizePixel=0, Size=UDim2.new(1,0,1,0),
            ClearTextOnFocus=false, Parent=sf })
        U.corner(searchBox, 6); U.stroke(searchBox, theme.Border, 1)
    end

    local optBtns = {}
    local function render(filter)
        for _, b in ipairs(optBtns) do b:Destroy() end
        optBtns = {}
        filter = (filter or ""):lower()
        for _, opt in ipairs(dd.Options) do
            if filter == "" or string.find(tostring(opt):lower(), filter, 1, true) then
                local sel = (multi and type(dd.Value) == "table" and table.find(dd.Value, opt))
                    or (not multi and dd.Value == opt)
                local ob = U.new("TextButton", { Text="", BackgroundColor3=sel and theme.AccentMuted or theme.Bg3,
                    BorderSizePixel=0, Size=UDim2.new(1,0,0,30), AutoButtonColor=false, Parent=popup })
                U.corner(ob, 6)
                U.new("TextLabel", { Text=tostring(opt), Font=Enum.Font.Gotham, TextSize=11,
                    TextColor3=theme.Text, BackgroundTransparency=1,
                    Position=UDim2.fromOffset(12,0), Size=UDim2.new(1, -40, 1, 0),
                    TextXAlignment=Enum.TextXAlignment.Left, Parent=ob })
                if sel then
                    local ck = makeIcon(ob, "check", 14, theme.Accent)
                    ck.Position = UDim2.new(1, -22, 0.5, -7); ck.AnchorPoint = Vector2.new(0,0)
                end
                ob.MouseEnter:Connect(function() if not sel then U.tween(ob, { BackgroundColor3=theme.SurfaceHi }, 0.12) end end)
                ob.MouseLeave:Connect(function() if not sel then U.tween(ob, { BackgroundColor3=theme.Bg3 }, 0.12) end end)
                ob.MouseButton1Click:Connect(function()
                    if multi then
                        local arr = dd.Value
                        local idx = table.find(arr, opt)
                        if idx then table.remove(arr, idx) else table.insert(arr, opt) end
                        preview.Text = #arr > 0 and table.concat(arr, ", ") or "Select..."
                    else
                        dd.Value = opt; preview.Text = tostring(opt); dd.Toggle()
                    end
                    for _, cb in ipairs(dd.Callbacks) do task.spawn(cb, dd.Value) end
                    if cfg.Callback then task.spawn(cfg.Callback, dd.Value) end
                    render(searchBox and searchBox.Text or "")
                end)
                table.insert(optBtns, ob)
            end
        end
    end
    if searchBox then searchBox:GetPropertyChangedSignal("Text"):Connect(function() render(searchBox.Text) end) end
    render()

    function dd.Toggle()
        dd.Expanded = not dd.Expanded
        U.tween(arrow, { Rotation = dd.Expanded and 180 or 0 }, 0.22)
        if dd.Expanded then
            local h = math.min(#dd.Options * 32 + (searchBox and 36 or 0) + 12, 240)
            popup.Visible = true
            U.tween(popup, { Size=UDim2.new(1, 0, 0, h) }, 0.24, Enum.EasingStyle.Quart)
        else
            U.tween(popup, { Size=UDim2.new(1, 0, 0, 0) }, 0.18)
            task.delay(0.18, function() popup.Visible = false end)
        end
    end

    U.new("TextButton", { Text="", BackgroundTransparency=1, Size=UDim2.fromScale(1,1),
        Parent=inst }).MouseButton1Click:Connect(dd.Toggle)

    dd.Instance = inst
    dd.SetValue = function(v)
        dd.Value = v
        if type(v) == "table" then preview.Text = #v > 0 and table.concat(v, ", ") or "Select..."
        else preview.Text = tostring(v) end
        render(searchBox and searchBox.Text or "")
    end
    dd.GetValue = function() return dd.Value end
    dd.OnChanged = function(cb) table.insert(dd.Callbacks, cb) end
    Fluent.Options[id] = dd
    return push(self, dd)
end

function Window:AddColorpicker(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme]
    local cp = { Value = cfg.Default or Color3.fromRGB(99,102,241), Callbacks = {}, Expanded = false }

    local inst = U.new("Frame", { BackgroundColor3=theme.Surface, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,ROW_H), ClipsDescendants=false, Parent=self.Content })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=inst })

    local ic = makeIcon(inst, cfg.Icon or "palette", ICON_SIZE, theme.Accent)
    ic.Position = UDim2.fromOffset(ELEM_PAD, ROW_H/2 - ICON_SIZE/2); ic.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(TEXT_X, 0), Size=UDim2.new(1, -TEXT_X - 60, 1, 0),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst })

    local prev = U.new("Frame", { Size=UDim2.fromOffset(24,24),
        Position=UDim2.new(1, -RIGHT_END - 24, 0.5, -12),
        BackgroundColor3=cp.Value, BorderSizePixel=0, Parent=inst })
    U.corner(prev, 7); U.stroke(prev, theme.BorderHi, 1)

    local popup = U.new("Frame", { Size=UDim2.new(1,0,0,0),
        Position=UDim2.new(0,0,1,6), BackgroundColor3=theme.Bg3, BorderSizePixel=0,
        Visible=false, ZIndex=20, Parent=inst })
    U.corner(popup, 10); U.stroke(popup, theme.BorderHi, 1); U.pad(popup, 10, 10, 10, 10)
    U.shadow(popup, theme.Shadow, 0.4)

    local hue = U.new("Frame", { Size=UDim2.new(1,0,0,22),
        BackgroundColor3=cp.Value, BorderSizePixel=0, Parent=popup })
    U.corner(hue, 6)
    U.new("UIGradient", { Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0)),
    }), Parent=hue })
    local hk = U.new("Frame", { Size=UDim2.fromOffset(16,16), Position=UDim2.new(0,-8,0.5,-8),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=hue })
    U.corner(hk, 8); U.stroke(hk, theme.Text, 2)

    local hex = U.new("TextBox", { Text=U.toHex(cp.Value), PlaceholderText="#RRGGBB",
        Font=Enum.Font.Code, TextSize=12, TextColor3=theme.Text,
        BackgroundColor3=theme.Surface, BorderSizePixel=0,
        Size=UDim2.new(1, 0, 0, 28), Position=UDim2.fromOffset(0, 34),
        ClearTextOnFocus=false, Parent=popup })
    U.corner(hex, 6); U.stroke(hex, theme.Border, 1)

    local dragH = false
    local function applyHue(i)
        local start, w = hue.AbsolutePosition.X, hue.AbsoluteSize.X
        local rel = math.clamp((i.Position.X - start) / w, 0, 1)
        hk.Position = UDim2.new(rel, -8, 0.5, -8)
        local c = Color3.fromHSV(rel, 1, 1)
        cp.Value = c; prev.BackgroundColor3 = c; hex.Text = U.toHex(c)
        for _, cb in ipairs(cp.Callbacks) do task.spawn(cb, c) end
        if cfg.Callback then task.spawn(cfg.Callback, c) end
    end
    hue.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragH = true; applyHue(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragH and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then applyHue(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragH = false end
    end)

    hex.FocusLost:Connect(function()
        local c = U.fromHex(hex.Text)
        if c then
            cp.Value = c; prev.BackgroundColor3 = c
            local h = select(1, Color3.toHSV(c))
            hk.Position = UDim2.new(h, -8, 0.5, -8)
        else hex.Text = U.toHex(cp.Value) end
    end)

    U.new("TextButton", { Text="", BackgroundTransparency=1, Size=UDim2.fromScale(1,1),
        Parent=inst }).MouseButton1Click:Connect(function()
        cp.Expanded = not cp.Expanded
        if cp.Expanded then
            popup.Visible = true
            U.tween(popup, { Size=UDim2.new(1, 0, 0, 72) }, 0.24)
        else
            U.tween(popup, { Size=UDim2.new(1, 0, 0, 0) }, 0.18)
            task.delay(0.18, function() popup.Visible = false end)
        end
    end)

    local h0 = select(1, Color3.toHSV(cp.Value))
    hk.Position = UDim2.new(h0, -8, 0.5, -8)

    cp.Instance = inst
    cp.SetValue = function(c)
        cp.Value = c; prev.BackgroundColor3 = c; hex.Text = U.toHex(c)
        local h = select(1, Color3.toHSV(c))
        hk.Position = UDim2.new(h, -8, 0.5, -8)
    end
    cp.GetValue = function() return cp.Value end
    cp.OnChanged = function(cb) table.insert(cp.Callbacks, cb) end
    Fluent.Options[id] = cp
    return push(self, cp)
end

function Window:AddKeybind(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme]
    local kb = { Value = cfg.Default or Enum.KeyCode.Unknown, Callbacks = {}, Listening = false }

    local inst = U.new("Frame", { BackgroundColor3=theme.Surface, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,ROW_H), Parent=self.Content })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=inst })

    local ic = makeIcon(inst, cfg.Icon or "keyboard", ICON_SIZE, theme.Accent)
    ic.Position = UDim2.fromOffset(ELEM_PAD, ROW_H/2 - ICON_SIZE/2); ic.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(TEXT_X, 0), Size=UDim2.new(1, -TEXT_X - 110, 1, 0),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst })

    local keyBtn = U.new("TextButton", { Text = kb.Value ~= Enum.KeyCode.Unknown and kb.Value.Name or "None",
        Font=Enum.Font.GothamMedium, TextSize=11, TextColor3=theme.Text,
        BackgroundColor3=theme.Bg3, BorderSizePixel=0,
        Size=UDim2.fromOffset(88, 28), Position=UDim2.new(1, -RIGHT_END - 88, 0.5, -14),
        AutoButtonColor=false, Parent=inst })
    U.corner(keyBtn, 7); U.stroke(keyBtn, theme.BorderHi, 1)

    keyBtn.MouseButton1Click:Connect(function()
        kb.Listening = true; keyBtn.Text = "..."; keyBtn.TextColor3 = theme.Warning
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if kb.Listening and input.UserInputType == Enum.UserInputType.Keyboard then
            kb.Listening = false; kb.Value = input.KeyCode
            keyBtn.Text = input.KeyCode.Name; keyBtn.TextColor3 = theme.Text
            for _, cb in ipairs(kb.Callbacks) do task.spawn(cb, input.KeyCode) end
            if cfg.Callback then task.spawn(cfg.Callback, input.KeyCode) end
            return
        end
        if not gp and not kb.Listening and input.KeyCode == kb.Value and kb.Value ~= Enum.KeyCode.Unknown then
            if cfg.Callback then task.spawn(cfg.Callback, input.KeyCode) end
        end
    end)

    kb.Instance = inst
    kb.SetValue = function(k) kb.Value = k; keyBtn.Text = k.Name end
    kb.GetValue = function() return kb.Value end
    kb.OnChanged = function(cb) table.insert(kb.Callbacks, cb) end
    Fluent.Options[id] = kb
    return push(self, kb)
end

function Window:AddTextbox(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme]
    local tb = { Value = cfg.Default or "", Callbacks = {} }

    local inst = U.new("Frame", { BackgroundColor3=theme.Surface, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,68), Parent=self.Content })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=inst })

    local ic = makeIcon(inst, cfg.Icon or "text", ICON_SIZE, theme.Accent)
    ic.Position = UDim2.fromOffset(ELEM_PAD, 12); ic.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(TEXT_X, 12), Size=UDim2.new(1, -TEXT_X - ELEM_PAD, 0, 16),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst })

    local box = U.new("TextBox", { Text=tb.Value, PlaceholderText=cfg.Placeholder or "Enter text...",
        Font=Enum.Font.Gotham, TextSize=11, TextColor3=theme.Text,
        PlaceholderColor3=theme.SubText, BackgroundColor3=theme.Bg3,
        BorderSizePixel=0, Size=UDim2.new(1, -ELEM_PAD*2, 0, 28),
        Position=UDim2.fromOffset(ELEM_PAD, 34), ClearTextOnFocus=false, Parent=inst })
    U.corner(box, 7); U.stroke(box, theme.Border, 1)

    box.Focused:Connect(function() U.tween(box, { BackgroundColor3=theme.SurfaceHi }, 0.15) end)
    box.FocusLost:Connect(function()
        U.tween(box, { BackgroundColor3=theme.Bg3 }, 0.15)
        tb.Value = box.Text
        for _, cb in ipairs(tb.Callbacks) do task.spawn(cb, tb.Value) end
        if cfg.Callback then task.spawn(cfg.Callback, tb.Value) end
    end)

    tb.Instance = inst
    tb.SetValue = function(v) tb.Value = v; box.Text = v end
    tb.GetValue = function() return tb.Value end
    tb.OnChanged = function(cb) table.insert(tb.Callbacks, cb) end
    Fluent.Options[id] = tb
    return push(self, tb)
end

-- ═══════════════════════════════════════════════════════
--  Dialog + Notifications
-- ═══════════════════════════════════════════════════════
function Window:Dialog(cfg)
    cfg = cfg or {}
    if self.DialogOpen then return end
    self.DialogOpen = true
    local theme = Themes[self.Theme]

    self.DialogLayer.Visible = true
    U.tween(self.DialogLayer, { BackgroundTransparency=0.55 }, 0.22)

    local d = U.new("Frame", { Size=UDim2.fromOffset(360,180),
        Position=UDim2.new(0.5,-180,0.5,-90),
        BackgroundColor3=theme.Surface, BorderSizePixel=0, Parent=self.GUI })
    U.corner(d, 14); U.stroke(d, theme.BorderHi, 1); U.shadow(d, theme.Shadow, 0.35)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=d })

    local chip = U.new("Frame", { Size=UDim2.fromOffset(30,30), Position=UDim2.fromOffset(20,20),
        BackgroundColor3=theme.Accent, BorderSizePixel=0, Parent=d })
    U.corner(chip, 9)
    U.new("UIGradient", { Color=ColorSequence.new(theme.AccentHi, theme.Accent), Rotation=135, Parent=chip })
    local ci = makeIcon(chip, cfg.Icon or "info", 14, Color3.new(1,1,1))
    ci.Position = UDim2.fromOffset(8,8); ci.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or "Dialog", Font=Enum.Font.GothamBold, TextSize=14,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(60,22), Size=UDim2.new(1,-80,0,22),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=d })
    U.new("TextLabel", { Text=cfg.Content or "", Font=Enum.Font.Gotham, TextSize=12,
        TextColor3=theme.SubText, BackgroundTransparency=1,
        Position=UDim2.fromOffset(20,60), Size=UDim2.new(1,-40,0,64),
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=d })

    local row = U.new("Frame", { Size=UDim2.new(1,-40,0,34), Position=UDim2.new(0,20,1,-48),
        BackgroundTransparency=1, Parent=d })
    U.new("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal,
        HorizontalAlignment=Enum.HorizontalAlignment.Right,
        Padding=UDim.new(0,8), Parent=row })

    local function close()
        U.tween(d, { BackgroundTransparency=1 }, 0.15)
        task.delay(0.15, function() d:Destroy() end)
        self.DialogLayer.Visible = false; self.DialogOpen = false
    end

    for _, btn in ipairs(cfg.Buttons or {}) do
        local primary = btn.Primary ~= false
        local b = U.new("TextButton", { Text=btn.Title or "OK", Font=Enum.Font.GothamMedium, TextSize=12,
            TextColor3=primary and Color3.new(1,1,1) or theme.Text,
            BackgroundColor3=primary and theme.Accent or theme.Bg3,
            BorderSizePixel=0, Size=UDim2.fromOffset(94,34), AutoButtonColor=false, Parent=row })
        U.corner(b, 8)
        b.MouseEnter:Connect(function() U.tween(b, { BackgroundColor3=primary and theme.AccentHi or theme.SurfaceHi }, 0.15) end)
        b.MouseLeave:Connect(function() U.tween(b, { BackgroundColor3=primary and theme.Accent or theme.Bg3 }, 0.15) end)
        U.ripple(b, primary and Color3.new(1,1,1) or theme.Accent)
        b.MouseButton1Click:Connect(function()
            if btn.Callback then task.spawn(btn.Callback) end
            close()
        end)
    end

    self.DialogLayer.MouseButton1Click:Connect(close)
end

function Window:Notify(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme]
    local accent = cfg.Type == "Error" and theme.Error
        or cfg.Type == "Success" and theme.Success
        or cfg.Type == "Warning" and theme.Warning or theme.Accent
    local iconName = cfg.Icon or (cfg.Type == "Error" and "close"
        or cfg.Type == "Success" and "check"
        or cfg.Type == "Warning" and "info" or "info")

    local h = cfg.SubContent and 84 or 70
    local n = U.new("Frame", { Size=UDim2.new(1,0,0,h), BackgroundColor3=theme.Surface,
        BorderSizePixel=0, BackgroundTransparency=1, Position=UDim2.new(0,360,0,0),
        Parent=self.NotifyBox })
    U.corner(n, 12); U.stroke(n, theme.BorderHi, 1); U.shadow(n, theme.Shadow, 0.35)
    U.new("UIGradient", { Color=ColorSequence.new(theme.SurfaceHi, theme.Surface), Rotation=90, Parent=n })

    local ab = U.new("Frame", { Size=UDim2.new(0,3,1,-20), Position=UDim2.fromOffset(0,10),
        BackgroundColor3=accent, BorderSizePixel=0, Parent=n })
    U.corner(ab, 2)

    local chip = U.new("Frame", { Size=UDim2.fromOffset(28,28), Position=UDim2.fromOffset(16,14),
        BackgroundColor3=accent, BorderSizePixel=0, Parent=n })
    U.corner(chip, 9)
    local ci = makeIcon(chip, iconName, 14, Color3.new(1,1,1))
    ci.Position = UDim2.fromOffset(7,7); ci.AnchorPoint = Vector2.new(0,0)

    U.new("TextLabel", { Text=cfg.Title or "Notification", Font=Enum.Font.GothamBold, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(54,14), Size=UDim2.new(1,-66,0,16),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=n })
    U.new("TextLabel", { Text=cfg.Content or "", Font=Enum.Font.Gotham, TextSize=11,
        TextColor3=theme.SubText, BackgroundTransparency=1,
        Position=UDim2.fromOffset(54,34), Size=UDim2.new(1,-66,0,18),
        TextXAlignment=Enum.TextXAlignment.Left, TextTruncate=Enum.TextTruncate.AtEnd, Parent=n })
    if cfg.SubContent then
        U.new("TextLabel", { Text=cfg.SubContent, Font=Enum.Font.Gotham, TextSize=10,
            TextColor3=theme.SubText, BackgroundTransparency=1,
            Position=UDim2.fromOffset(54,54), Size=UDim2.new(1,-66,0,16),
            TextXAlignment=Enum.TextXAlignment.Left, Parent=n })
    end

    U.tween(n, { Position=UDim2.new(0,0,0,0), BackgroundTransparency=0 }, 0.32, Enum.EasingStyle.Quart)

    local dur = cfg.Duration or 5
    if dur > 0 then
        task.delay(dur, function()
            if n and n.Parent then
                U.tween(n, { Position=UDim2.new(0,360,0,0), BackgroundTransparency=1 }, 0.3)
                task.wait(0.3); n:Destroy()
            end
        end)
    end
end

function Window:SetTheme(name)
    local t = Themes[name]; if not t then return end
    self.Theme = name; Fluent.Theme = name
    self.Frame.BackgroundColor3 = t.Bg
    self.TitleBar.BackgroundColor3 = t.Bg2
    self.TabList.BackgroundColor3 = t.Bg2
    self.Content.BackgroundColor3 = t.Bg
    self.TitleLabel.TextColor3 = t.Text
end

function Window:Destroy()
    Fluent.Unloaded = true
    if Fluent.ToggleButtonGui then Fluent.ToggleButtonGui:Destroy() end
    self.GUI:Destroy()
end

-- ═══════════════════════════════════════════════════════
--  Top-level proxies
-- ═══════════════════════════════════════════════════════
function Fluent:Notify(cfg) if self.Window then return self.Window:Notify(cfg) end end
function Fluent:Dialog(cfg) if self.Window then return self.Window:Dialog(cfg) end end
function Fluent:SetTheme(name) if self.Window then return self.Window:SetTheme(name) end end
function Fluent:ToggleVisibility(f) if self.Window then return self.Window:ToggleVisibility(f) end end
function Fluent:Destroy() if self.Window then return self.Window:Destroy() end end

-- ═══════════════════════════════════════════════════════
--  Save Manager
-- ═══════════════════════════════════════════════════════
local SaveManager = {}; SaveManager.__index = SaveManager
function SaveManager:SetLibrary(l) self.Library = l end
local function cname(l) return l.Options.ConfigName and l.Options.ConfigName.Value or "default" end
function SaveManager:Save()
    local data = {}
    for id, o in pairs(self.Library.Options) do
        if o.Value ~= nil then
            local t = typeof(o.Value)
            if t == "Color3" then data[id] = { t="Color3", v={o.Value.R,o.Value.G,o.Value.B} }
            elseif t == "EnumItem" then data[id] = { t="EnumItem", v=o.Value.Name }
            else data[id] = { t="raw", v=o.Value } end
        end
    end
    local ok, enc = pcall(HttpService.JSONEncode, HttpService, data)
    if ok and writefile then pcall(writefile, "FluentUI_"..cname(self.Library)..".json", enc) end
end
function SaveManager:Load()
    if not readfile then return end
    local ok, content = pcall(readfile, "FluentUI_"..cname(self.Library)..".json")
    if not ok then return end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, content)
    if not ok2 then return end
    for id, e in pairs(data) do
        local o = self.Library.Options[id]
        if o and o.SetValue then
            if e.t == "Color3" then o:SetValue(Color3.new(e.v[1],e.v[2],e.v[3]))
            elseif e.t == "EnumItem" then o:SetValue(Enum.KeyCode[e.v])
            else o:SetValue(e.v) end
        end
    end
end
function SaveManager:Delete() if delfile then pcall(delfile, "FluentUI_"..cname(self.Library)..".json") end end
function SaveManager:BuildConfigSection(tab)
    tab:AddParagraph({ Title="Configuration", Content="Save, load, or delete your settings.", Icon="check" })
    tab:AddTextbox("ConfigName", { Title="Config Name", Default="default", Icon="text" })
    tab:AddButton({ Title="Save Config", Icon="check", Description="Write current settings to disk",
        Callback=function() self:Save(); Fluent:Notify({ Title="Saved", Content="Configuration saved.", Type="Success" }) end })
    tab:AddButton({ Title="Load Config", Icon="chevron-up", Description="Read settings from disk",
        Callback=function() self:Load(); Fluent:Notify({ Title="Loaded", Content="Configuration loaded.", Type="Success" }) end })
    tab:AddButton({ Title="Delete Config", Icon="close", Description="Remove the saved file",
        Callback=function() self:Delete(); Fluent:Notify({ Title="Deleted", Content="Configuration removed.", Type="Warning" }) end })
end

-- ═══════════════════════════════════════════════════════
--  Interface Manager
-- ═══════════════════════════════════════════════════════
local InterfaceManager = {}; InterfaceManager.__index = InterfaceManager
function InterfaceManager:SetLibrary(l) self.Library = l end

function InterfaceManager:BuildInterfaceSection(tab)
    tab:AddParagraph({ Title="Interface", Content="Customize the look and behavior of FluentUI.", Icon="sliders" })

    tab:AddDropdown("ThemeSelector", { Title="Theme", Icon="palette",
        Values={"Dark","Light","Midnight","Dracula","Nord","Emerald","Rose","Monokai"},
        Default="Dark",
        Callback=function(v) Fluent:SetTheme(v); Fluent:Notify({ Title="Theme Changed", Content="Now using "..v, Duration=2 }) end })

    tab:AddSlider("UIScale", { Title="UI Scale", Icon="sliders", Min=80, Max=120, Default=100, Rounding=0,
        Callback=function(v) end })  -- placeholder for scale concept

    tab:AddSlider("NotifDuration", { Title="Notification Duration", Icon="info",
        Min=1, Max=15, Default=5, Rounding=0, Callback=function(v) end })

    tab:AddToggle("NotifEnabled", { Title="Enable Notifications", Icon="info", Default=true,
        Description="Toggle toast notifications globally" })

    tab:AddKeybind("ToggleKeybind", { Title="Hide/Show UI", Icon="keyboard",
        Default=Enum.KeyCode.RightShift,
        Callback=function(k) if Fluent.Window then Fluent.Window.ToggleKey = k end end })

    tab:AddKeybind("MinimizeKeybind", { Title="Minimize UI", Icon="keyboard",
        Default=Enum.KeyCode.LeftControl,
        Callback=function(k) if Fluent.Window then Fluent.Window.MinimizeKey = k end end })

    tab:AddButton({ Title="Reset Interface", Icon="refresh",
        Description="Restore default window position and size",
        Callback=function()
            if Fluent.Window then
                Fluent.Window.Frame.Position = UDim2.new(0.5, -Fluent.Window.Size.X.Offset/2, 0.5, -Fluent.Window.Size.Y.Offset/2)
                Fluent.Window.Frame.Size = Fluent.Window.Size
            end
        end })

    tab:AddButton({ Title="Destroy Interface", Icon="close",
        Description="Close FluentUI completely",
        Callback=function() Fluent:Destroy() end })
end

Fluent.SaveManager = SaveManager
Fluent.InterfaceManager = InterfaceManager

return Fluent
