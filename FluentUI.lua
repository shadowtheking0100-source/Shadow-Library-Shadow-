--[[
    FluentUI v1.2 — Polished Edition
    • Fixed: Fluent:Notify / Fluent:Dialog top-level proxies
    • Added: active-tab indicator, ripple effect, hover scale, gradient accents
    • Redesigned: sections, buttons, toggles, notifications for higher polish
]]

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local Lighting         = game:GetService("Lighting")

-- // Lucide Icons
local Icons = {
    Menu="rbxassetid://10734950020", Close="rbxassetid://10747384394",
    Minimize="rbxassetid://10747384238", Maximize="rbxassetid://10747384307",
    Home="rbxassetid://10734949889",     Settings="rbxassetid://10734950227",
    User="rbxassetid://10734950759",     Info="rbxassetid://10734949960",
    Star="rbxassetid://10734950129",     Search="rbxassetid://10734950144",
    ChevronDown="rbxassetid://10734950264", ChevronRight="rbxassetid://10747384051",
    Check="rbxassetid://10734950211",    Palette="rbxassetid://10734950095",
    Keyboard="rbxassetid://10734949957", Type="rbxassetid://10734950707",
    Sliders="rbxassetid://10734950147",  ToggleLeft="rbxassetid://10734950725",
    ToggleRight="rbxassetid://10734950735", List="rbxassetid://10734950033",
    Layers="rbxassetid://10734949985",   Code="rbxassetid://10734949805",
    Bell="rbxassetid://10734949693",     Trash="rbxassetid://10734950707",
    Download="rbxassetid://10734949863", Upload="rbxassetid://10734950747",
    Refresh="rbxassetid://10734950113",  Save="rbxassetid://10734950129",
    Copy="rbxassetid://10734949817",     Eye="rbxassetid://10734949850",
    EyeOff="rbxassetid://10734949835",   Play="rbxassetid://10734950058",
    Pause="rbxassetid://10734950045",    Zap="rbxassetid://10734950775",
    Shield="rbxassetid://10734950167",   Crosshair="rbxassetid://10734949829",
    Rocket="rbxassetid://10734950135",   Gamepad="rbxassetid://10734949895",
    Camera="rbxassetid://10734949793",   Compass="rbxassetid://10734949811",
    Map="rbxassetid://10734950070",      Package="rbxassetid://10734950088",
    Moon="rbxassetid://10734950067",     Sun="rbxassetid://10734950299",
    Heart="rbxassetid://10734949875",    Bookmark="rbxassetid://10734949697",
    Flag="rbxassetid://10734949870",     Lock="rbxassetid://10734950040",
    Key="rbxassetid://10734949947",      Wrench="rbxassetid://10734950769",
    Skull="rbxassetid://10734950191",    Flame="rbxassetid://10734949861",
    Sparkles="rbxassetid://10734950173",
    -- aliases
    Slider="rbxassetid://10734950147",   Switch="rbxassetid://10734950725",
    Textbox="rbxassetid://10734950707",  Dropdown="rbxassetid://10734950033",
    Colorpicker="rbxassetid://10734950095", Keybind="rbxassetid://10734949957",
    Button="rbxassetid://10734949817",   Paragraph="rbxassetid://10734949960",
}

-- // Refined palettes
local Themes = {
    Dark = {
        Background=Color3.fromRGB(18,18,22), SecondaryBackground=Color3.fromRGB(24,24,30),
        TertiaryBackground=Color3.fromRGB(32,32,40), Surface=Color3.fromRGB(28,28,35),
        SurfaceHover=Color3.fromRGB(36,36,44), Text=Color3.fromRGB(238,239,245),
        SubText=Color3.fromRGB(142,144,158), Accent=Color3.fromRGB(99,112,255),
        AccentHover=Color3.fromRGB(122,134,255), AccentMuted=Color3.fromRGB(58,66,150),
        Border=Color3.fromRGB(42,42,52), BorderLight=Color3.fromRGB(58,58,72),
        Success=Color3.fromRGB(87,200,120), Warning=Color3.fromRGB(240,177,50),
        Error=Color3.fromRGB(237,66,69), Shadow=Color3.fromRGB(0,0,0),
        GradientTop=Color3.fromRGB(30,30,40), GradientBottom=Color3.fromRGB(18,18,22),
    },
    Light = {
        Background=Color3.fromRGB(248,249,252), SecondaryBackground=Color3.fromRGB(240,241,246),
        TertiaryBackground=Color3.fromRGB(226,228,236), Surface=Color3.fromRGB(255,255,255),
        SurfaceHover=Color3.fromRGB(245,246,250), Text=Color3.fromRGB(28,30,38),
        SubText=Color3.fromRGB(112,116,130), Accent=Color3.fromRGB(88,101,242),
        AccentHover=Color3.fromRGB(70,84,220), AccentMuted=Color3.fromRGB(200,205,250),
        Border=Color3.fromRGB(220,222,230), BorderLight=Color3.fromRGB(198,201,213),
        Success=Color3.fromRGB(60,180,100), Warning=Color3.fromRGB(230,155,30),
        Error=Color3.fromRGB(220,55,60), Shadow=Color3.fromRGB(120,120,140),
        GradientTop=Color3.fromRGB(255,255,255), GradientBottom=Color3.fromRGB(245,246,252),
    },
    Midnight = {
        Background=Color3.fromRGB(11,13,20), SecondaryBackground=Color3.fromRGB(16,18,28),
        TertiaryBackground=Color3.fromRGB(24,27,40), Surface=Color3.fromRGB(19,22,32),
        SurfaceHover=Color3.fromRGB(26,30,44), Text=Color3.fromRGB(222,228,242),
        SubText=Color3.fromRGB(122,132,158), Accent=Color3.fromRGB(118,138,255),
        AccentHover=Color3.fromRGB(140,158,255), AccentMuted=Color3.fromRGB(48,58,120),
        Border=Color3.fromRGB(30,34,48), BorderLight=Color3.fromRGB(44,50,68),
        Success=Color3.fromRGB(80,190,130), Warning=Color3.fromRGB(240,180,60),
        Error=Color3.fromRGB(240,80,90), Shadow=Color3.fromRGB(0,0,0),
        GradientTop=Color3.fromRGB(20,24,38), GradientBottom=Color3.fromRGB(11,13,20),
    },
    Amethyst = {
        Background=Color3.fromRGB(21,17,29), SecondaryBackground=Color3.fromRGB(28,23,38),
        TertiaryBackground=Color3.fromRGB(38,31,52), Surface=Color3.fromRGB(32,26,44),
        SurfaceHover=Color3.fromRGB(42,35,58), Text=Color3.fromRGB(240,234,250),
        SubText=Color3.fromRGB(162,150,187), Accent=Color3.fromRGB(165,120,245),
        AccentHover=Color3.fromRGB(182,145,255), AccentMuted=Color3.fromRGB(78,54,128),
        Border=Color3.fromRGB(48,40,66), BorderLight=Color3.fromRGB(63,53,86),
        Success=Color3.fromRGB(120,200,150), Warning=Color3.fromRGB(245,190,80),
        Error=Color3.fromRGB(240,90,120), Shadow=Color3.fromRGB(0,0,0),
        GradientTop=Color3.fromRGB(36,28,50), GradientBottom=Color3.fromRGB(21,17,29),
    },
    Emerald = {
        Background=Color3.fromRGB(14,21,19), SecondaryBackground=Color3.fromRGB(20,30,27),
        TertiaryBackground=Color3.fromRGB(28,42,38), Surface=Color3.fromRGB(23,34,31),
        SurfaceHover=Color3.fromRGB(31,45,41), Text=Color3.fromRGB(228,242,238),
        SubText=Color3.fromRGB(142,172,162), Accent=Color3.fromRGB(70,200,160),
        AccentHover=Color3.fromRGB(95,220,180), AccentMuted=Color3.fromRGB(34,98,78),
        Border=Color3.fromRGB(36,54,48), BorderLight=Color3.fromRGB(48,70,63),
        Success=Color3.fromRGB(90,210,140), Warning=Color3.fromRGB(240,190,70),
        Error=Color3.fromRGB(235,90,100), Shadow=Color3.fromRGB(0,0,0),
        GradientTop=Color3.fromRGB(24,36,33), GradientBottom=Color3.fromRGB(14,21,19),
    },
    Rose = {
        Background=Color3.fromRGB(25,17,22), SecondaryBackground=Color3.fromRGB(34,24,29),
        TertiaryBackground=Color3.fromRGB(46,32,38), Surface=Color3.fromRGB(38,28,33),
        SurfaceHover=Color3.fromRGB(50,37,42), Text=Color3.fromRGB(250,234,238),
        SubText=Color3.fromRGB(192,157,167), Accent=Color3.fromRGB(240,105,145),
        AccentHover=Color3.fromRGB(255,130,165), AccentMuted=Color3.fromRGB(118,54,74),
        Border=Color3.fromRGB(56,40,46), BorderLight=Color3.fromRGB(72,54,60),
        Success=Color3.fromRGB(120,200,150), Warning=Color3.fromRGB(245,190,80),
        Error=Color3.fromRGB(240,80,90), Shadow=Color3.fromRGB(0,0,0),
        GradientTop=Color3.fromRGB(42,30,36), GradientBottom=Color3.fromRGB(25,17,22),
    },
}

-- // Utilities
local U = {}

function U.new(c, p) local i = Instance.new(c); for k,v in pairs(p or {}) do i[k]=v end; return i end

function U.tween(i, p, d, s, dir)
    local t = TweenService:Create(i, TweenInfo.new(d or 0.22, s or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), p)
    t:Play(); return t
end

function U.corner(p, r) return U.new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = p }) end

function U.stroke(p, c, t, tr)
    return U.new("UIStroke", { Color=c or Color3.fromRGB(60,60,70), Thickness=t or 1,
        Transparency=tr or 0, ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=p })
end

function U.padding(p, t, b, l, r)
    return U.new("UIPadding", { PaddingTop=UDim.new(0,t or 8), PaddingBottom=UDim.new(0,b or 8),
        PaddingLeft=UDim.new(0,l or 8), PaddingRight=UDim.new(0,r or 8), Parent=p })
end

function U.shadow(p, c, tr)
    return U.new("ImageLabel", { Name="Shadow", BackgroundTransparency=1,
        Image="rbxassetid://6014261993", ImageColor3=c or Color3.new(0,0,0),
        ImageTransparency=tr or 0.55, ScaleType=Enum.ScaleType.Slice,
        SliceCenter=Rect.new(49,49,450,450), Size=UDim2.new(1,36,1,36),
        Position=UDim2.new(0,-18,0,-18), ZIndex=-1, Parent=p })
end

function U.icon(p, id, size, color, pos, zi)
    return U.new("ImageLabel", { BackgroundTransparency=1, Image=id,
        ImageColor3=color or Color3.fromRGB(200,200,210), Size=size or UDim2.fromOffset(16,16),
        Position=pos or UDim2.fromOffset(0,0), ZIndex=zi or 1, Parent=p })
end

function U.draggable(frame, handle, bounds)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        local np = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        if bounds then
            local vp = workspace.CurrentCamera.ViewportSize
            local a = frame.AbsoluteSize
            local x = math.clamp(np.X.Offset+np.X.Scale*vp.X, bounds.minX or 0, vp.X-a.X-(bounds.maxX or 0))
            local y = math.clamp(np.Y.Offset+np.Y.Scale*vp.Y, bounds.minY or 0, vp.Y-a.Y-(bounds.maxY or 0))
            np = UDim2.fromOffset(x, y)
        end
        frame.Position = np
    end
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = i.Position; startPos = frame.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            dragInput = i
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == dragInput and dragging then update(i) end
    end)
end

-- // Ripple effect (press feedback on buttons)
function U.ripple(button, color)
    button.MouseButton1Down:Connect(function()
        local size = button.AbsoluteSize
        local maxDim = math.max(size.X, size.Y) * 2
        local r = U.new("Frame", {
            Size = UDim2.fromOffset(0,0), Position = UDim2.fromOffset(size.X/2, size.Y/2),
            AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = color or Color3.new(1,1,1),
            BackgroundTransparency = 0.75, BorderSizePixel = 0, ZIndex = 5,
            Parent = button,
        })
        U.corner(r, maxDim)
        TweenService:Create(r, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {
            Size = UDim2.fromOffset(maxDim, maxDim), BackgroundTransparency = 1,
        }):Play()
        task.delay(0.5, function() if r then r:Destroy() end end)
    end)
end

function U.round(n, d) local m = 10^(d or 0); return math.floor(n*m+0.5)/m end
function U.toHex(c) return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)) end
function U.fromHex(h) h = h:gsub("#",""); if #h ~= 6 then return nil end
    return Color3.fromRGB(tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16)) end

-- // Library root
local Fluent = {
    Version = "1.2.0", Icons = Icons, Themes = Themes, Options = {},
    Theme = "Dark", Unloaded = false, UseAcrylic = true,
}

-- ═══════════════════════════════════════════════════════════
--  Floating Toggle Button
-- ═══════════════════════════════════════════════════════════
function Fluent:CreateToggleButton(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local gui = cfg.Parent or U.new("ScreenGui", {
        Name = "FluentUI_ToggleButton", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true,
        DisplayOrder = 9999, Parent = CoreGui,
    })

    local size = cfg.Size or 50
    local button = U.new("ImageButton", {
        Name = "ToggleButton", Size = UDim2.fromOffset(size, size),
        Position = cfg.Position or UDim2.new(0, 24, 0.5, -size/2),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Image = "",
        AutoButtonColor = false, Parent = gui,
    })
    U.corner(button, size/2)
    U.stroke(button, theme.BorderLight, 1)
    U.shadow(button, theme.Shadow, 0.4)

    -- gradient tint
    local grad = U.new("UIGradient", {
        Color = ColorSequence.new(theme.Surface, theme.TertiaryBackground),
        Rotation = 135, Parent = button,
    })

    local holder = U.new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = button })

    local barColor = cfg.IconColor or theme.Text
    local barSize = UDim2.fromOffset(math.floor(size * 0.42), 2)
    local barX = (size - barSize.X.Offset) / 2
    local bar1 = U.new("Frame", { Size=barSize, Position=UDim2.fromOffset(barX, size/2-6),
        BackgroundColor3=barColor, BorderSizePixel=0, Parent=holder }); U.corner(bar1,2)
    local bar2 = U.new("Frame", { Size=barSize, Position=UDim2.fromOffset(barX, size/2-1),
        BackgroundColor3=barColor, BorderSizePixel=0, Parent=holder }); U.corner(bar2,2)
    local bar3 = U.new("Frame", { Size=barSize, Position=UDim2.fromOffset(barX, size/2+4),
        BackgroundColor3=barColor, BorderSizePixel=0, Parent=holder }); U.corner(bar3,2)

    local function setOpen(open)
        if open then
            U.tween(bar1, { Position=UDim2.fromOffset(barX, size/2-1), Rotation=45 }, 0.24)
            U.tween(bar3, { Position=UDim2.fromOffset(barX, size/2-1), Rotation=-45 }, 0.24)
            U.tween(bar2, { BackgroundTransparency=1 }, 0.15)
        else
            U.tween(bar1, { Position=UDim2.fromOffset(barX, size/2-6), Rotation=0 }, 0.24)
            U.tween(bar3, { Position=UDim2.fromOffset(barX, size/2+4), Rotation=0 }, 0.24)
            U.tween(bar2, { BackgroundTransparency=0 }, 0.15)
        end
    end

    button.MouseEnter:Connect(function()
        U.tween(button, { BackgroundColor3 = theme.SurfaceHover }, 0.16)
        U.tween(button, { Size = UDim2.fromOffset(size+4, size+4),
            Position = UDim2.new(button.Position.X.Scale, button.Position.X.Offset - 2,
                button.Position.Y.Scale, button.Position.Y.Offset - 2) }, 0.16)
    end)
    button.MouseLeave:Connect(function()
        U.tween(button, { BackgroundColor3 = theme.Surface }, 0.16)
        U.tween(button, { Size = UDim2.fromOffset(size, size),
            Position = UDim2.new(button.Position.X.Scale, button.Position.X.Offset + 2,
                button.Position.Y.Scale, button.Position.Y.Offset + 2) }, 0.16)
    end)

    U.draggable(button, button, { minX=6, maxX=6, minY=6, maxY=6 })

    local pressPos, dragged
    button.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            pressPos = i.Position; dragged = false
        end
    end)
    button.InputChanged:Connect(function(i)
        if pressPos and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            if (i.Position - pressPos).Magnitude > 6 then dragged = true end
        end
    end)
    button.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if not dragged and cfg.OnClick then cfg.OnClick() end
            pressPos = nil
        end
    end)

    button.Size = UDim2.fromOffset(0,0)
    U.tween(button, { Size = UDim2.fromOffset(size, size) }, 0.4, Enum.EasingStyle.Back)

    self.ToggleButton = button
    self.ToggleButtonGui = gui
    self.ToggleButtonSetOpen = setOpen
    return { Instance = button, SetOpen = setOpen, Destroy = function() gui:Destroy() end }
end

-- ═══════════════════════════════════════════════════════════
--  Window
-- ═══════════════════════════════════════════════════════════
local Window = {}
Window.__index = Window

function Fluent:CreateWindow(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, Window)

    self.Title        = cfg.Title or "FluentUI"
    self.SubTitle     = cfg.SubTitle or ""
    self.TabWidth     = cfg.TabWidth or 176
    self.Size         = cfg.Size or UDim2.fromOffset(640, 500)
    self.Theme        = cfg.Theme or Fluent.Theme
    self.MinimizeKey  = cfg.MinimizeKey or Enum.KeyCode.LeftControl
    self.ToggleKey    = cfg.ToggleKey or Enum.KeyCode.RightShift
    self.Acrylic      = cfg.Acrylic ~= false
    self.Minimized    = false
    self.Hidden       = false
    self.Tabs         = {}
    self.SelectedTab  = nil
    self.DialogOpen   = false
    self.CornerRadius = cfg.CornerRadius or 14

    local theme = Themes[self.Theme] or Themes.Dark

    self.GUI = U.new("ScreenGui", {
        Name = "FluentUI_"..HttpService:GenerateGUID(false),
        ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true, DisplayOrder = 999, Parent = CoreGui,
    })

    self.Root = U.new("Frame", { Name="Root", Size=UDim2.fromScale(1,1),
        BackgroundTransparency=1, Parent=self.GUI })

    self.WindowFrame = U.new("Frame", {
        Name = "Window", Size = self.Size,
        Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2),
        BackgroundColor3 = theme.Background, BorderSizePixel = 0,
        ClipsDescendants = true, Parent = self.Root,
    })
    U.corner(self.WindowFrame, self.CornerRadius)
    U.stroke(self.WindowFrame, theme.Border, 1)
    U.shadow(self.WindowFrame, theme.Shadow, 0.45)

    -- subtle background gradient
    local bgGrad = U.new("UIGradient", {
        Color = ColorSequence.new(theme.GradientTop, theme.GradientBottom),
        Rotation = 90, Parent = self.WindowFrame,
    })

    if self.Acrylic then
        self.Blur = U.new("BlurEffect", { Size = 14, Parent = Lighting })
    end

    -- Title bar (with its own subtle gradient)
    self.TitleBar = U.new("Frame", {
        Name = "TitleBar", Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = theme.SecondaryBackground,
        BorderSizePixel = 0, Parent = self.WindowFrame,
    })
    local titleGrad = U.new("UIGradient", {
        Color = ColorSequence.new(theme.TertiaryBackground, theme.SecondaryBackground),
        Rotation = 90, Parent = self.TitleBar,
    })

    -- Brand icon inside a rounded chip
    local chip = U.new("Frame", {
        Size = UDim2.fromOffset(28,28), Position = UDim2.fromOffset(14, 11),
        BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Parent = self.TitleBar,
    })
    U.corner(chip, 8)
    local chipGrad = U.new("UIGradient", {
        Color = ColorSequence.new(theme.AccentHover, theme.Accent),
        Rotation = 135, Parent = chip,
    })
    U.icon(chip, Icons.Sparkles, UDim2.fromOffset(15,15), Color3.new(1,1,1), UDim2.fromOffset(7,7))

    self.TitleLabel = U.new("TextLabel", {
        Text = self.Title, Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(52, self.SubTitle ~= "" and 8 or 0),
        Size = UDim2.new(0, 240, 0, self.SubTitle ~= "" and 20 or 50),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = self.TitleBar,
    })

    if self.SubTitle ~= "" then
        U.new("TextLabel", {
            Text = self.SubTitle, Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = theme.SubText, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(52, 26), Size = UDim2.new(0, 240, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left, Parent = self.TitleBar,
        })
    end

    -- Window controls
    local function makeCtrl(iconId, xOff, hoverColor)
        local b = U.new("ImageButton", {
            BackgroundTransparency = 1, Image = iconId, ImageColor3 = theme.SubText,
            Size = UDim2.fromOffset(16,16), Position = UDim2.new(1, xOff, 0.5, -8),
            AutoButtonColor = false, Parent = self.TitleBar,
        })
        b.MouseEnter:Connect(function() U.tween(b, { ImageColor3 = hoverColor or theme.Text }, 0.15) end)
        b.MouseLeave:Connect(function() U.tween(b, { ImageColor3 = theme.SubText }, 0.15) end)
        return b
    end
    self.MinimizeButton = makeCtrl(Icons.Minimize, -74, theme.Text)
    self.CloseButton    = makeCtrl(Icons.Close,    -42, theme.Error)

    -- Left sidebar (tabs)
    self.TabContainer = U.new("ScrollingFrame", {
        Name = "TabContainer", Size = UDim2.new(0, self.TabWidth, 1, -50),
        Position = UDim2.fromOffset(0, 50), BackgroundColor3 = theme.SecondaryBackground,
        BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Border,
        CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.WindowFrame,
    })
    U.new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = self.TabContainer })
    U.padding(self.TabContainer, 10, 10, 8, 8)

    -- Right side content
    self.ContentContainer = U.new("ScrollingFrame", {
        Name = "ContentContainer", Size = UDim2.new(1, -self.TabWidth, 1, -50),
        Position = UDim2.new(0, self.TabWidth, 0, 50),
        BackgroundColor3 = theme.Background, BackgroundTransparency = 1,
        BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Border,
        CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.WindowFrame,
    })
    U.new("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = self.ContentContainer })
    U.padding(self.ContentContainer, 16, 16, 16, 16)

    -- Vertical divider line
    local divider = U.new("Frame", {
        Size = UDim2.new(0, 1, 1, -50), Position = UDim2.new(0, self.TabWidth, 0, 50),
        BackgroundColor3 = theme.Border, BorderSizePixel = 0,
        BackgroundTransparency = 0.3, Parent = self.WindowFrame,
    })

    -- Notification stack
    self.NotifyContainer = U.new("Frame", {
        Name = "Notifications", Size = UDim2.new(0, 330, 1, 0),
        Position = UDim2.new(1, -346, 0, 0), BackgroundTransparency = 1, Parent = self.GUI,
    })
    U.new("UIListLayout", {
        Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right, Parent = self.NotifyContainer,
    })

    self.DialogOverlay = U.new("TextButton", {
        Name = "DialogOverlay", Size = UDim2.fromScale(1,1),
        BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1,
        Text = "", Visible = false, Parent = self.GUI,
    })

    U.draggable(self.WindowFrame, self.TitleBar)

    self.MinimizeButton.MouseButton1Click:Connect(function() self:ToggleMinimize() end)
    self.CloseButton.MouseButton1Click:Connect(function() self:Destroy() end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.MinimizeKey then self:ToggleMinimize() end
        if input.KeyCode == self.ToggleKey then self:ToggleVisibility() end
    end)

    -- Floating toggle button
    self.ToggleButtonHandle = Fluent:CreateToggleButton({
        OnClick = function() self:ToggleVisibility() end,
    })
    self._syncToggleButton = function(visible)
        if Fluent.ToggleButtonSetOpen then Fluent.ToggleButtonSetOpen(visible) end
    end
    self._syncToggleButton(true)

    Fluent.Window = self
    return self
end

function Window:ToggleVisibility(force)
    self.Hidden = (force ~= nil) and force or (not self.Hidden)
    local visible = not self.Hidden
    if visible then
        self.Root.Visible = true
        self.WindowFrame.Size = UDim2.fromOffset(self.Size.X.Offset*0.95, self.Size.Y.Offset*0.95)
        self.WindowFrame.Position = UDim2.new(0.5, -self.Size.X.Offset*0.475, 0.5, -self.Size.Y.Offset*0.475)
        U.tween(self.WindowFrame, {
            Size = self.Size,
            Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2),
        }, 0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    else
        U.tween(self.WindowFrame, {
            Size = UDim2.fromOffset(self.Size.X.Offset*0.95, self.Size.Y.Offset*0.95),
            Position = UDim2.new(0.5, -self.Size.X.Offset*0.475, 0.5, -self.Size.Y.Offset*0.475),
        }, 0.2, Enum.EasingStyle.Quart)
        task.delay(0.2, function() if self.Hidden then self.Root.Visible = false end end)
    end
    if self._syncToggleButton then self._syncToggleButton(visible) end
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        U.tween(self.WindowFrame, { Size = UDim2.new(0, self.Size.X.Offset, 0, 50) }, 0.3)
        self.TabContainer.Visible = false
        self.ContentContainer.Visible = false
    else
        U.tween(self.WindowFrame, { Size = self.Size }, 0.3)
        self.TabContainer.Visible = true
        self.ContentContainer.Visible = true
    end
end

function Window:AddTab(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local tab = { Title = cfg.Title or "Tab", Icon = cfg.Icon, Window = self, Elements = {} }

    tab.Button = U.new("TextButton", {
        Name = tab.Title, Text = "", BackgroundColor3 = theme.SecondaryBackground,
        BackgroundTransparency = 1, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36), AutoButtonColor = false, Parent = self.TabContainer,
    })
    U.corner(tab.Button, 8)

    -- Active indicator bar (left)
    tab.Indicator = U.new("Frame", {
        Size = UDim2.new(0, 3, 0, 0), Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = theme.Accent, BorderSizePixel = 0,
        BackgroundTransparency = 1, Parent = tab.Button,
    })
    U.corner(tab.Indicator, 2)

    local iconOffset = 0
    if tab.Icon then
        tab.IconImage = U.icon(tab.Button, tab.Icon, UDim2.fromOffset(16,16),
            theme.SubText, UDim2.fromOffset(14, 10))
        iconOffset = 28
    end

    tab.Label = U.new("TextLabel", {
        Text = tab.Title, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.SubText, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14 + iconOffset, 0),
        Size = UDim2.new(1, -(14 + iconOffset), 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = tab.Button,
    })

    tab.Button.MouseEnter:Connect(function()
        if self.SelectedTab ~= tab then
            U.tween(tab.Button, { BackgroundColor3 = theme.TertiaryBackground, BackgroundTransparency = 0.4 }, 0.16)
        end
    end)
    tab.Button.MouseLeave:Connect(function()
        if self.SelectedTab ~= tab then
            U.tween(tab.Button, { BackgroundTransparency = 1 }, 0.16)
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
        U.tween(t.Button, { BackgroundColor3 = active and theme.TertiaryBackground or theme.SecondaryBackground,
            BackgroundTransparency = active and 0 or 1 }, 0.2)
        U.tween(t.Label, { TextColor3 = active and theme.Text or theme.SubText }, 0.2)
        if t.IconImage then
            U.tween(t.IconImage, { ImageColor3 = active and theme.Accent or theme.SubText }, 0.2)
        end
        if t.Indicator then
            U.tween(t.Indicator, { Size = UDim2.new(0, 3, 0, active and 18 or 0),
                BackgroundTransparency = active and 0 or 1 }, 0.25, Enum.EasingStyle.Quart)
        end
    end

    for _, c in ipairs(self.ContentContainer:GetChildren()) do
        if c:IsA("GuiObject") and not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
            c.Visible = false
        end
    end
    for _, el in ipairs(tab.Elements) do
        if el.Instance then el.Instance.Visible = true end
    end
end

-- ═══════════════════════════════════════════════════════════
--  Elements
-- ═══════════════════════════════════════════════════════════
local function push(win, el) if win.SelectedTab then table.insert(win.SelectedTab.Elements, el) end; return el end

function Window:AddSection(name)
    local theme = Themes[self.Theme] or Themes.Dark
    local inst = U.new("Frame", {
        Name = "Section_"..name, Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1, Parent = self.ContentContainer,
    })
    local bar = U.new("Frame", { Size=UDim2.new(0, 3, 0, 12), Position=UDim2.fromOffset(0, 7),
        BackgroundColor3=theme.Accent, BorderSizePixel=0, Parent=inst })
    U.corner(bar, 2)
    local grad = U.new("UIGradient", {
        Color = ColorSequence.new(theme.AccentHover, theme.Accent),
        Rotation = 90, Parent = bar,
    })
    U.new("TextLabel", {
        Text = string.upper(name), Font = Enum.Font.GothamBold, TextSize = 10,
        TextColor3 = theme.SubText, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -12, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })
    return push(self, { Instance = inst })
end

function Window:AddParagraph(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local inst = U.new("Frame", {
        Name="Paragraph", Size=UDim2.new(1,0,0,68),
        BackgroundColor3=theme.Surface, BorderSizePixel=0, Parent=self.ContentContainer,
    })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color = ColorSequence.new(theme.Surface, theme.Background),
        Rotation = 90, Parent = inst })

    U.icon(inst, cfg.Icon or Icons.Info, UDim2.fromOffset(16,16), theme.Accent, UDim2.fromOffset(14, 14))
    U.new("TextLabel", {
        Text = cfg.Title or "Paragraph", Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(40, 12), Size = UDim2.new(1, -52, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })
    U.new("TextLabel", {
        Text = cfg.Content or "", Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = theme.SubText, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 36), Size = UDim2.new(1, -28, 1, -44),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Parent = inst,
    })
    return push(self, { Instance = inst })
end

function Window:AddButton(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local inst = U.new("TextButton", {
        Name="Button", Text="", BackgroundColor3=theme.Surface, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,cfg.Description and 50 or 42), AutoButtonColor=false, Parent=self.ContentContainer,
    })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color = ColorSequence.new(theme.Surface, theme.Background),
        Rotation = 90, Parent = inst })

    U.icon(inst, cfg.Icon or Icons.Button, UDim2.fromOffset(16,16), theme.Accent, UDim2.fromOffset(14, 13))
    U.new("TextLabel", {
        Text = cfg.Title or "Button", Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -52, 0, cfg.Description and 26 or 42),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })
    if cfg.Description then
        U.new("TextLabel", {
            Text = cfg.Description, Font = Enum.Font.Gotham, TextSize = 10,
            TextColor3 = theme.SubText, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(40, 26), Size = UDim2.new(1, -52, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
        })
    end
    -- Chevron hint
    U.icon(inst, Icons.ChevronRight, UDim2.fromOffset(14,14), theme.SubText, UDim2.new(1, -28, 0.5, -7))

    inst.MouseEnter:Connect(function()
        U.tween(inst, { BackgroundColor3 = theme.SurfaceHover }, 0.16)
    end)
    inst.MouseLeave:Connect(function()
        U.tween(inst, { BackgroundColor3 = theme.Surface }, 0.16)
    end)
    U.ripple(inst, theme.Accent)
    inst.MouseButton1Click:Connect(function() if cfg.Callback then task.spawn(cfg.Callback) end end)
    return push(self, { Instance = inst })
end

function Window:AddToggle(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local toggle = { Value = cfg.Default or false, Callbacks = {} }

    local inst = U.new("Frame", {
        Name="Toggle_"..id, Size=UDim2.new(1,0,0,cfg.Description and 50 or 42),
        BackgroundColor3=theme.Surface, BorderSizePixel=0, Parent=self.ContentContainer,
    })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color = ColorSequence.new(theme.Surface, theme.Background),
        Rotation = 90, Parent = inst })

    U.icon(inst, cfg.Icon or Icons.Switch, UDim2.fromOffset(16,16), theme.Accent, UDim2.fromOffset(14, 13))
    U.new("TextLabel", {
        Text = cfg.Title or id, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(40, 0), Size = UDim2.new(1, -110, 0, cfg.Description and 26 or 42),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })
    if cfg.Description then
        U.new("TextLabel", {
            Text = cfg.Description, Font = Enum.Font.Gotham, TextSize = 10,
            TextColor3 = theme.SubText, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(40, 26), Size = UDim2.new(1, -110, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
        })
    end

    local swBg = U.new("Frame", {
        Size=UDim2.fromOffset(40,22), Position=UDim2.new(1,-54,0.5,-11),
        BackgroundColor3=toggle.Value and theme.Accent or theme.Border, BorderSizePixel=0, Parent=inst,
    })
    U.corner(swBg, 11)
    local swGrad = U.new("UIGradient", {
        Color = ColorSequence.new(theme.AccentHover, theme.Accent), Rotation = 135,
        Enabled = toggle.Value, Parent = swBg,
    })
    local swKnob = U.new("Frame", {
        Size=UDim2.fromOffset(18,18),
        Position=UDim2.new(0, toggle.Value and 20 or 2, 0.5, -9),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=swBg,
    })
    U.corner(swKnob, 9)
    U.shadow(swKnob, Color3.new(0,0,0), 0.6)

    local click = U.new("TextButton", { Text="", BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=inst })

    local function setValue(v)
        toggle.Value = v
        U.tween(swBg, { BackgroundColor3 = v and theme.Accent or theme.Border }, 0.22)
        swGrad.Enabled = v
        U.tween(swKnob, { Position = UDim2.new(0, v and 20 or 2, 0.5, -9) }, 0.22, Enum.EasingStyle.Back)
        for _, cb in ipairs(toggle.Callbacks) do task.spawn(cb, v) end
        if cfg.Callback then task.spawn(cfg.Callback, v) end
    end
    click.MouseButton1Click:Connect(function() setValue(not toggle.Value) end)

    toggle.Instance = inst
    toggle.SetValue = setValue
    toggle.GetValue = function() return toggle.Value end
    toggle.OnChanged = function(cb) table.insert(toggle.Callbacks, cb) end
    Fluent.Options[id] = toggle
    return push(self, toggle)
end

function Window:AddSlider(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local min, max = cfg.Min or 0, cfg.Max or 100
    local slider = { Value = cfg.Default or min, Callbacks = {} }

    local inst = U.new("Frame", {
        Name="Slider_"..id, Size=UDim2.new(1,0,0,62),
        BackgroundColor3=theme.Surface, BorderSizePixel=0, Parent=self.ContentContainer,
    })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color = ColorSequence.new(theme.Surface, theme.Background), Rotation=90, Parent=inst })

    U.icon(inst, cfg.Icon or Icons.Slider, UDim2.fromOffset(16,16), theme.Accent, UDim2.fromOffset(14, 11))
    U.new("TextLabel", {
        Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(40, 10), Size=UDim2.new(1,-110,0,16),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst,
    })
    local valueLabel = U.new("TextLabel", {
        Text=tostring(slider.Value), Font=Enum.Font.GothamBold, TextSize=11,
        TextColor3=theme.Accent, BackgroundTransparency=1,
        Position=UDim2.new(1,-64,0,10), Size=UDim2.fromOffset(50,16),
        TextXAlignment=Enum.TextXAlignment.Right, Parent=inst,
    })

    local track = U.new("Frame", {
        Size=UDim2.new(1,-28,0,6), Position=UDim2.fromOffset(14,42),
        BackgroundColor3=theme.Border, BorderSizePixel=0, Parent=inst,
    })
    U.corner(track, 3)
    local fill = U.new("Frame", { Size=UDim2.new(0,0,1,0), BackgroundColor3=theme.Accent,
        BorderSizePixel=0, Parent=track })
    U.corner(fill, 3)
    U.new("UIGradient", { Color=ColorSequence.new(theme.AccentHover, theme.Accent), Parent=fill })
    local knob = U.new("Frame", {
        Size=UDim2.fromOffset(14,14), Position=UDim2.new(0,-7,0.5,-7),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=track,
    })
    U.corner(knob, 7); U.stroke(knob, theme.Accent, 2)
    U.shadow(knob, Color3.new(0,0,0), 0.6)

    local function calc(i)
        local start, w = track.AbsolutePosition.X, track.AbsoluteSize.X
        local rel = math.clamp((i.Position.X - start) / w, 0, 1)
        local raw = min + (max - min) * rel
        local r = cfg.Rounding or 0
        local val = U.round(raw, r)
        slider.Value = val
        valueLabel.Text = (r == 0) and tostring(math.floor(val)) or string.format("%."..r.."f", val)
        local p = (val - min) / (max - min)
        U.tween(fill, { Size = UDim2.new(p, 0, 1, 0) }, 0.08)
        U.tween(knob, { Position = UDim2.new(p, -7, 0.5, -7) }, 0.08)
        for _, cb in ipairs(slider.Callbacks) do task.spawn(cb, val) end
        if cfg.Callback then task.spawn(cfg.Callback, val) end
    end

    local dragging = false
    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; calc(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then calc(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    local p0 = (slider.Value - min) / (max - min)
    fill.Size = UDim2.new(p0, 0, 1, 0)
    knob.Position = UDim2.new(p0, -7, 0.5, -7)

    slider.Instance = inst
    slider.SetValue = function(v)
        slider.Value = v
        local p = (v - min) / (max - min)
        valueLabel.Text = tostring(v)
        U.tween(fill, { Size = UDim2.new(p, 0, 1, 0) }, 0.15)
        U.tween(knob, { Position = UDim2.new(p, -7, 0.5, -7) }, 0.15)
    end
    slider.GetValue = function() return slider.Value end
    slider.OnChanged = function(cb) table.insert(slider.Callbacks, cb) end
    Fluent.Options[id] = slider
    return push(self, slider)
end

function Window:AddDropdown(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local multi = cfg.Multi or false
    local dropdown = {
        Value = cfg.Default or (multi and {} or nil),
        Options = cfg.Values or {}, Multi = multi, Callbacks = {}, Expanded = false,
    }

    local inst = U.new("Frame", {
        Name="Dropdown_"..id, Size=UDim2.new(1,0,0,42),
        BackgroundColor3=theme.Surface, BorderSizePixel=0,
        ClipsDescendants=false, Parent=self.ContentContainer,
    })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.Surface, theme.Background), Rotation=90, Parent=inst })

    U.icon(inst, cfg.Icon or Icons.Dropdown, UDim2.fromOffset(16,16), theme.Accent, UDim2.fromOffset(14, 13))
    U.new("TextLabel", {
        Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(40, 0), Size=UDim2.new(1,-130,1,0),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst,
    })

    local arrow = U.icon(inst, Icons.ChevronDown, UDim2.fromOffset(14,14), theme.SubText,
        UDim2.new(1,-28,0.5,-7))

    local click = U.new("TextButton", { Text="", BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=inst })

    local previewText = "Select..."
    if multi and type(dropdown.Value) == "table" then
        previewText = #dropdown.Value > 0 and table.concat(dropdown.Value, ", ") or "Select..."
    elseif dropdown.Value then
        previewText = tostring(dropdown.Value)
    end
    local preview = U.new("TextLabel", {
        Text=previewText, Font=Enum.Font.Gotham, TextSize=10, TextColor3=theme.SubText,
        BackgroundTransparency=1, Position=UDim2.new(1,-92,0.5,-8),
        Size=UDim2.fromOffset(64,16), TextXAlignment=Enum.TextXAlignment.Right,
        TextTruncate=Enum.TextTruncate.AtEnd, Parent=inst,
    })

    local popup = U.new("ScrollingFrame", {
        Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,1,6),
        BackgroundColor3=theme.TertiaryBackground, BorderSizePixel=0,
        Visible=false, ZIndex=20, ScrollBarThickness=2, ScrollBarImageColor3=theme.Border,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y, Parent=inst,
    })
    U.corner(popup, 10); U.stroke(popup, theme.BorderLight, 1)
    U.padding(popup, 6, 6, 6, 6)
    U.new("UIListLayout", { Padding=UDim.new(0,2), SortOrder=Enum.SortOrder.LayoutOrder, Parent=popup })
    U.shadow(popup, theme.Shadow, 0.35)

    local searchBox
    if cfg.Searchable ~= false and #dropdown.Options > 6 then
        local sf = U.new("Frame", { Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, Parent=popup })
        searchBox = U.new("TextBox", {
            Text="", PlaceholderText="Search...", Font=Enum.Font.Gotham, TextSize=11,
            TextColor3=theme.Text, PlaceholderColor3=theme.SubText,
            BackgroundColor3=theme.Surface, BorderSizePixel=0,
            Size=UDim2.new(1,0,1,0), ClearTextOnFocus=false, Parent=sf,
        })
        U.corner(searchBox, 6); U.stroke(searchBox, theme.Border, 1)
    end

    local optionButtons = {}
    local function renderOptions(filter)
        for _, b in ipairs(optionButtons) do b:Destroy() end
        optionButtons = {}
        filter = (filter or ""):lower()
        for _, opt in ipairs(dropdown.Options) do
            if filter == "" or string.find(tostring(opt):lower(), filter, 1, true) then
                local isSelected = (multi and type(dropdown.Value) == "table" and table.find(dropdown.Value, opt))
                    or (not multi and dropdown.Value == opt)
                local ob = U.new("TextButton", {
                    Text="", Font=Enum.Font.Gotham, TextSize=11,
                    BackgroundColor3 = isSelected and theme.AccentMuted or theme.TertiaryBackground,
                    BorderSizePixel=0, Size=UDim2.new(1,0,0,30), AutoButtonColor=false, Parent=popup,
                })
                U.corner(ob, 6)
                U.new("TextLabel", {
                    Text=tostring(opt), Font=Enum.Font.Gotham, TextSize=11,
                    TextColor3=theme.Text, BackgroundTransparency=1,
                    Position=UDim2.fromOffset(12,0), Size=UDim2.new(1,-40,1,0),
                    TextXAlignment=Enum.TextXAlignment.Left, Parent=ob,
                })
                if isSelected then
                    U.icon(ob, Icons.Check, UDim2.fromOffset(14,14), theme.Accent, UDim2.new(1,-22,0.5,-7))
                end
                ob.MouseEnter:Connect(function()
                    if not isSelected then U.tween(ob, { BackgroundColor3 = theme.SurfaceHover }, 0.12) end
                end)
                ob.MouseLeave:Connect(function()
                    if not isSelected then U.tween(ob, { BackgroundColor3 = theme.TertiaryBackground }, 0.12) end
                end)
                ob.MouseButton1Click:Connect(function()
                    if multi then
                        local arr = dropdown.Value
                        local idx = table.find(arr, opt)
                        if idx then table.remove(arr, idx) else table.insert(arr, opt) end
                        preview.Text = #arr > 0 and table.concat(arr, ", ") or "Select..."
                    else
                        dropdown.Value = opt
                        preview.Text = tostring(opt)
                        dropdown.Toggle()
                    end
                    for _, cb in ipairs(dropdown.Callbacks) do task.spawn(cb, dropdown.Value) end
                    if cfg.Callback then task.spawn(cfg.Callback, dropdown.Value) end
                    renderOptions(searchBox and searchBox.Text or "")
                end)
                table.insert(optionButtons, ob)
            end
        end
    end

    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function() renderOptions(searchBox.Text) end)
    end
    renderOptions()

    function dropdown.Toggle()
        dropdown.Expanded = not dropdown.Expanded
        U.tween(arrow, { Rotation = dropdown.Expanded and 180 or 0 }, 0.22)
        if dropdown.Expanded then
            local h = math.min(#dropdown.Options * 32 + (searchBox and 36 or 0) + 12, 240)
            popup.Visible = true
            U.tween(popup, { Size = UDim2.new(1, 0, 0, h) }, 0.24, Enum.EasingStyle.Quart)
        else
            U.tween(popup, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
            task.delay(0.18, function() popup.Visible = false end)
        end
    end

    click.MouseButton1Click:Connect(dropdown.Toggle)

    dropdown.Instance = inst
    dropdown.SetValue = function(v)
        dropdown.Value = v
        if type(v) == "table" then preview.Text = #v > 0 and table.concat(v, ", ") or "Select..."
        else preview.Text = tostring(v) end
        renderOptions(searchBox and searchBox.Text or "")
    end
    dropdown.GetValue = function() return dropdown.Value end
    dropdown.OnChanged = function(cb) table.insert(dropdown.Callbacks, cb) end

    Fluent.Options[id] = dropdown
    return push(self, dropdown)
end

function Window:AddColorpicker(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local cp = { Value = cfg.Default or Color3.fromRGB(99,112,255), Callbacks = {}, Expanded = false }

    local inst = U.new("Frame", {
        Name="Colorpicker_"..id, Size=UDim2.new(1,0,0,42),
        BackgroundColor3=theme.Surface, BorderSizePixel=0,
        ClipsDescendants=false, Parent=self.ContentContainer,
    })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.Surface, theme.Background), Rotation=90, Parent=inst })

    U.icon(inst, cfg.Icon or Icons.Palette, UDim2.fromOffset(16,16), theme.Accent, UDim2.fromOffset(14, 13))
    U.new("TextLabel", {
        Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(40,0), Size=UDim2.new(1,-80,1,0),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst,
    })

    local preview = U.new("Frame", {
        Size=UDim2.fromOffset(24,24), Position=UDim2.new(1,-40,0.5,-12),
        BackgroundColor3=cp.Value, BorderSizePixel=0, Parent=inst,
    })
    U.corner(preview, 7); U.stroke(preview, theme.BorderLight, 1)

    local click = U.new("TextButton", { Text="", BackgroundTransparency=1, Size=UDim2.fromScale(1,1), Parent=inst })

    local popup = U.new("Frame", {
        Size=UDim2.new(1,0,0,0), Position=UDim2.new(0,0,1,6),
        BackgroundColor3=theme.TertiaryBackground, BorderSizePixel=0,
        Visible=false, ZIndex=20, Parent=inst,
    })
    U.corner(popup, 10); U.stroke(popup, theme.BorderLight, 1); U.padding(popup, 10, 10, 10, 10)
    U.shadow(popup, theme.Shadow, 0.35)

    local hue = U.new("Frame", {
        Size=UDim2.new(1,0,0,22), BackgroundColor3=cp.Value,
        BorderSizePixel=0, Parent=popup,
    })
    U.corner(hue, 6)
    U.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0)),
        }), Parent=hue,
    })
    local hueKnob = U.new("Frame", {
        Size=UDim2.fromOffset(16,16), Position=UDim2.new(0,-8,0.5,-8),
        BackgroundColor3=Color3.new(1,1,1), BorderSizePixel=0, Parent=hue,
    })
    U.corner(hueKnob, 8); U.stroke(hueKnob, theme.Text, 2)
    U.shadow(hueKnob, Color3.new(0,0,0), 0.55)

    local hexBox = U.new("TextBox", {
        Text=U.toHex(cp.Value), PlaceholderText="#RRGGBB",
        Font=Enum.Font.Code, TextSize=12, TextColor3=theme.Text,
        BackgroundColor3=theme.Surface, BorderSizePixel=0,
        Size=UDim2.new(1,0,0,28), Position=UDim2.fromOffset(0,34),
        ClearTextOnFocus=false, Parent=popup,
    })
    U.corner(hexBox, 6); U.stroke(hexBox, theme.Border, 1)

    local draggingHue = false
    local function apply(i)
        local start, w = hue.AbsolutePosition.X, hue.AbsoluteSize.X
        local rel = math.clamp((i.Position.X - start) / w, 0, 1)
        hueKnob.Position = UDim2.new(rel, -8, 0.5, -8)
        local c = Color3.fromHSV(rel, 1, 1)
        cp.Value = c; preview.BackgroundColor3 = c; hexBox.Text = U.toHex(c)
        for _, cb in ipairs(cp.Callbacks) do task.spawn(cb, c) end
        if cfg.Callback then task.spawn(cfg.Callback, c) end
    end
    hue.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true; apply(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if draggingHue and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then apply(i) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then draggingHue = false end
    end)

    hexBox.FocusLost:Connect(function()
        local c = U.fromHex(hexBox.Text)
        if c then
            cp.Value = c; preview.BackgroundColor3 = c
            local h = select(1, Color3.toHSV(c))
            hueKnob.Position = UDim2.new(h, -8, 0.5, -8)
        else hexBox.Text = U.toHex(cp.Value) end
    end)

    click.MouseButton1Click:Connect(function()
        cp.Expanded = not cp.Expanded
        if cp.Expanded then
            popup.Visible = true
            U.tween(popup, { Size = UDim2.new(1, 0, 0, 72) }, 0.24)
        else
            U.tween(popup, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
            task.delay(0.18, function() popup.Visible = false end)
        end
    end)

    local h0 = select(1, Color3.toHSV(cp.Value))
    hueKnob.Position = UDim2.new(h0, -8, 0.5, -8)

    cp.Instance = inst
    cp.SetValue = function(c)
        cp.Value = c; preview.BackgroundColor3 = c; hexBox.Text = U.toHex(c)
        local h = select(1, Color3.toHSV(c))
        hueKnob.Position = UDim2.new(h, -8, 0.5, -8)
    end
    cp.GetValue = function() return cp.Value end
    cp.OnChanged = function(cb) table.insert(cp.Callbacks, cb) end
    Fluent.Options[id] = cp
    return push(self, cp)
end

function Window:AddKeybind(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local kb = { Value = cfg.Default or Enum.KeyCode.Unknown, Callbacks = {}, Listening = false }

    local inst = U.new("Frame", {
        Name="Keybind_"..id, Size=UDim2.new(1,0,0,42),
        BackgroundColor3=theme.Surface, BorderSizePixel=0, Parent=self.ContentContainer,
    })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.Surface, theme.Background), Rotation=90, Parent=inst })

    U.icon(inst, cfg.Icon or Icons.Keyboard, UDim2.fromOffset(16,16), theme.Accent, UDim2.fromOffset(14, 13))
    U.new("TextLabel", {
        Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(40,0), Size=UDim2.new(1,-140,1,0),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst,
    })

    local keyBtn = U.new("TextButton", {
        Text = kb.Value ~= Enum.KeyCode.Unknown and kb.Value.Name or "None",
        Font=Enum.Font.GothamMedium, TextSize=11, TextColor3=theme.Text,
        BackgroundColor3=theme.TertiaryBackground, BorderSizePixel=0,
        Size=UDim2.fromOffset(84,28), Position=UDim2.new(1,-96,0.5,-14),
        AutoButtonColor=false, Parent=inst,
    })
    U.corner(keyBtn, 7); U.stroke(keyBtn, theme.BorderLight, 1)
    keyBtn.MouseEnter:Connect(function() U.tween(keyBtn, { BackgroundColor3 = theme.SurfaceHover }, 0.15) end)
    keyBtn.MouseLeave:Connect(function() U.tween(keyBtn, { BackgroundColor3 = theme.TertiaryBackground }, 0.15) end)

    keyBtn.MouseButton1Click:Connect(function()
        kb.Listening = true; keyBtn.Text = "..." ; keyBtn.TextColor3 = theme.Warning
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
    local theme = Themes[self.Theme] or Themes.Dark
    local tb = { Value = cfg.Default or "", Callbacks = {} }

    local inst = U.new("Frame", {
        Name="Textbox_"..id, Size=UDim2.new(1,0,0,64),
        BackgroundColor3=theme.Surface, BorderSizePixel=0, Parent=self.ContentContainer,
    })
    U.corner(inst, 10); U.stroke(inst, theme.Border, 1)
    U.new("UIGradient", { Color=ColorSequence.new(theme.Surface, theme.Background), Rotation=90, Parent=inst })

    U.icon(inst, cfg.Icon or Icons.Textbox, UDim2.fromOffset(16,16), theme.Accent, UDim2.fromOffset(14, 11))
    U.new("TextLabel", {
        Text=cfg.Title or id, Font=Enum.Font.GothamMedium, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(40,10), Size=UDim2.new(1,-52,0,16),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=inst,
    })

    local box = U.new("TextBox", {
        Text=tb.Value, PlaceholderText=cfg.Placeholder or "Enter text...",
        Font=Enum.Font.Gotham, TextSize=11, TextColor3=theme.Text,
        PlaceholderColor3=theme.SubText, BackgroundColor3=theme.TertiaryBackground,
        BorderSizePixel=0, Size=UDim2.new(1,-28,0,26), Position=UDim2.fromOffset(14,30),
        ClearTextOnFocus=false, Parent=inst,
    })
    U.corner(box, 7); U.stroke(box, theme.Border, 1)

    box.Focused:Connect(function() U.tween(box, { BackgroundColor3 = theme.SurfaceHover }, 0.15) end)
    box.FocusLost:Connect(function()
        U.tween(box, { BackgroundColor3 = theme.TertiaryBackground }, 0.15)
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

-- ═══════════════════════════════════════════════════════════
--  Dialog
-- ═══════════════════════════════════════════════════════════
function Window:Dialog(cfg)
    cfg = cfg or {}
    if self.DialogOpen then return end
    self.DialogOpen = true
    local theme = Themes[self.Theme] or Themes.Dark

    self.DialogOverlay.Visible = true
    U.tween(self.DialogOverlay, { BackgroundTransparency = 0.55 }, 0.22)

    local d = U.new("Frame", {
        Size=UDim2.fromOffset(360,180), Position=UDim2.new(0.5,-180,0.5,-90),
        BackgroundColor3=theme.Surface, BorderSizePixel=0, Parent=self.GUI,
    })
    U.corner(d, 14); U.stroke(d, theme.BorderLight, 1); U.shadow(d, theme.Shadow, 0.35)
    U.new("UIGradient", { Color=ColorSequence.new(theme.TertiaryBackground, theme.Surface),
        Rotation=90, Parent=d })

    local iconChip = U.new("Frame", {
        Size=UDim2.fromOffset(30,30), Position=UDim2.fromOffset(20,20),
        BackgroundColor3=theme.Accent, BorderSizePixel=0, Parent=d,
    })
    U.corner(iconChip, 8)
    U.new("UIGradient", { Color=ColorSequence.new(theme.AccentHover, theme.Accent),
        Rotation=135, Parent=iconChip })
    U.icon(iconChip, cfg.Icon or Icons.Info, UDim2.fromOffset(16,16),
        Color3.new(1,1,1), UDim2.fromOffset(7,7))

    U.new("TextLabel", {
        Text=cfg.Title or "Dialog", Font=Enum.Font.GothamBold, TextSize=14,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(60,22), Size=UDim2.new(1,-80,0,22),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=d,
    })
    U.new("TextLabel", {
        Text=cfg.Content or "", Font=Enum.Font.Gotham, TextSize=12,
        TextColor3=theme.SubText, BackgroundTransparency=1,
        Position=UDim2.fromOffset(20,60), Size=UDim2.new(1,-40,0,64),
        TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Top, TextWrapped=true, Parent=d,
    })

    local row = U.new("Frame", {
        Size=UDim2.new(1,-40,0,34), Position=UDim2.new(0,20,1,-48),
        BackgroundTransparency=1, Parent=d,
    })
    U.new("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal,
        HorizontalAlignment=Enum.HorizontalAlignment.Right,
        Padding=UDim.new(0,8), Parent=row })

    local function close()
        U.tween(d, { BackgroundTransparency = 1 }, 0.15)
        task.delay(0.15, function() d:Destroy() end)
        self.DialogOverlay.Visible = false
        self.DialogOpen = false
    end

    for _, btn in ipairs(cfg.Buttons or {}) do
        local primary = btn.Primary ~= false
        local b = U.new("TextButton", {
            Text=btn.Title or "OK", Font=Enum.Font.GothamMedium, TextSize=12,
            TextColor3=primary and Color3.new(1,1,1) or theme.Text,
            BackgroundColor3=primary and theme.Accent or theme.TertiaryBackground,
            BorderSizePixel=0, Size=UDim2.fromOffset(94,34), AutoButtonColor=false, Parent=row,
        })
        U.corner(b, 8)
        b.MouseEnter:Connect(function()
            U.tween(b, { BackgroundColor3 = primary and theme.AccentHover or theme.SurfaceHover }, 0.15)
        end)
        b.MouseLeave:Connect(function()
            U.tween(b, { BackgroundColor3 = primary and theme.Accent or theme.TertiaryBackground }, 0.15)
        end)
        U.ripple(b, primary and Color3.new(1,1,1) or theme.Accent)
        b.MouseButton1Click:Connect(function()
            if btn.Callback then task.spawn(btn.Callback) end
            close()
        end)
    end

    self.DialogOverlay.MouseButton1Click:Connect(function() close() end)
end

-- ═══════════════════════════════════════════════════════════
--  Notifications
-- ═══════════════════════════════════════════════════════════
function Window:Notify(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local accent = cfg.Type == "Error" and theme.Error
        or cfg.Type == "Success" and theme.Success
        or cfg.Type == "Warning" and theme.Warning or theme.Accent

    local n = U.new("Frame", {
        Name="Notification", Size=UDim2.new(1,0,0, cfg.SubContent and 82 or 68),
        BackgroundColor3=theme.Surface, BorderSizePixel=0,
        BackgroundTransparency=1, Position=UDim2.new(0,360,0,0),
        Parent=self.NotifyContainer,
    })
    U.corner(n, 12); U.stroke(n, theme.BorderLight, 1); U.shadow(n, theme.Shadow, 0.35)
    U.new("UIGradient", { Color=ColorSequence.new(theme.TertiaryBackground, theme.Surface),
        Rotation=90, Parent=n })

    local accentBar = U.new("Frame", {
        Size=UDim2.new(0,3,1,-20), Position=UDim2.fromOffset(0,10),
        BackgroundColor3=accent, BorderSizePixel=0, Parent=n,
    })
    U.corner(accentBar, 2)

    local chip = U.new("Frame", {
        Size=UDim2.fromOffset(28,28), Position=UDim2.fromOffset(16,14),
        BackgroundColor3=accent, BorderSizePixel=0, Parent=n,
    })
    U.corner(chip, 8)
    local iconId = cfg.Icon or (cfg.Type == "Error" and Icons.Close
        or cfg.Type == "Success" and Icons.Check
        or cfg.Type == "Warning" and Icons.Flag or Icons.Bell)
    U.icon(chip, iconId, UDim2.fromOffset(15,15), Color3.new(1,1,1), UDim2.fromOffset(7,7))

    U.new("TextLabel", {
        Text=cfg.Title or "Notification", Font=Enum.Font.GothamBold, TextSize=12,
        TextColor3=theme.Text, BackgroundTransparency=1,
        Position=UDim2.fromOffset(54,14), Size=UDim2.new(1,-66,0,16),
        TextXAlignment=Enum.TextXAlignment.Left, Parent=n,
    })
    U.new("TextLabel", {
        Text=cfg.Content or "", Font=Enum.Font.Gotham, TextSize=11,
        TextColor3=theme.SubText, BackgroundTransparency=1,
        Position=UDim2.fromOffset(54,34), Size=UDim2.new(1,-66,0,18),
        TextXAlignment=Enum.TextXAlignment.Left,
        TextTruncate=Enum.TextTruncate.AtEnd, Parent=n,
    })
    if cfg.SubContent then
        U.new("TextLabel", {
            Text=cfg.SubContent, Font=Enum.Font.Gotham, TextSize=10,
            TextColor3=theme.SubText, BackgroundTransparency=1,
            Position=UDim2.fromOffset(54,52), Size=UDim2.new(1,-66,0,16),
            TextXAlignment=Enum.TextXAlignment.Left, Parent=n,
        })
    end

    U.tween(n, { Position = UDim2.new(0,0,0,0), BackgroundTransparency = 0 }, 0.32, Enum.EasingStyle.Quart)

    local dur = cfg.Duration or 5
    if dur > 0 then
        task.delay(dur, function()
            if n and n.Parent then
                U.tween(n, { Position = UDim2.new(0,360,0,0), BackgroundTransparency = 1 }, 0.3)
                task.wait(0.3); n:Destroy()
            end
        end)
    end
end

function Window:SetTheme(name)
    local theme = Themes[name]; if not theme then return end
    self.Theme = name; Fluent.Theme = name
    self.WindowFrame.BackgroundColor3 = theme.Background
    self.TitleBar.BackgroundColor3 = theme.SecondaryBackground
    self.TabContainer.BackgroundColor3 = theme.SecondaryBackground
    self.TitleLabel.TextColor3 = theme.Text
end

function Window:ToggleAcrylic(state)
    self.Acrylic = state
    if self.Blur then self.Blur.Size = state and 14 or 0 end
end

function Window:Destroy()
    Fluent.Unloaded = true
    if self.Blur then self.Blur:Destroy() end
    if Fluent.ToggleButtonGui then Fluent.ToggleButtonGui:Destroy() end
    self.GUI:Destroy()
end

-- ═══════════════════════════════════════════════════════════
--  Top-level proxies (FIX for `Fluent:Notify` error)
-- ═══════════════════════════════════════════════════════════
function Fluent:Notify(cfg)
    if self.Window then return self.Window:Notify(cfg) end
end
function Fluent:Dialog(cfg)
    if self.Window then return self.Window:Dialog(cfg) end
end
function Fluent:SetTheme(name)
    if self.Window then return self.Window:SetTheme(name) end
end
function Fluent:ToggleAcrylic(state)
    if self.Window then return self.Window:ToggleAcrylic(state) end
end
function Fluent:ToggleVisibility(force)
    if self.Window then return self.Window:ToggleVisibility(force) end
end

-- ═══════════════════════════════════════════════════════════
--  Save / Interface managers
-- ═══════════════════════════════════════════════════════════
local SaveManager = {}; SaveManager.__index = SaveManager
function SaveManager:SetLibrary(lib) self.Library = lib end
local function cfgName(lib) return lib.Options.ConfigName and lib.Options.ConfigName.Value or "default" end

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
    if ok and writefile then pcall(writefile, "FluentUI_"..cfgName(self.Library)..".json", enc) end
end

function SaveManager:Load()
    if not readfile then return end
    local ok, content = pcall(readfile, "FluentUI_"..cfgName(self.Library)..".json")
    if not ok then return end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, content)
    if not ok2 then return end
    for id, entry in pairs(data) do
        local o = self.Library.Options[id]
        if o and o.SetValue then
            if entry.t == "Color3" then o:SetValue(Color3.new(entry.v[1], entry.v[2], entry.v[3]))
            elseif entry.t == "EnumItem" then o:SetValue(Enum.KeyCode[entry.v])
            else o:SetValue(entry.v) end
        end
    end
end

function SaveManager:Delete()
    if delfile then pcall(delfile, "FluentUI_"..cfgName(self.Library)..".json") end
end

function SaveManager:BuildConfigSection(tab)
    tab:AddParagraph({ Title="Configuration", Content="Save, load, or delete your settings.", Icon=Icons.Save })
    tab:AddTextbox("ConfigName", { Title="Config Name", Default="default", Icon=Icons.Type })
    tab:AddButton({ Title="Save Config", Icon=Icons.Save, Callback=function()
        self:Save(); Fluent:Notify({ Title="Saved", Content="Configuration saved successfully.", Type="Success", Icon=Icons.Save })
    end })
    tab:AddButton({ Title="Load Config", Icon=Icons.Upload, Callback=function()
        self:Load(); Fluent:Notify({ Title="Loaded", Content="Configuration loaded successfully.", Type="Success", Icon=Icons.Upload })
    end })
    tab:AddButton({ Title="Delete Config", Icon=Icons.Trash, Callback=function()
        self:Delete(); Fluent:Notify({ Title="Deleted", Content="Configuration deleted.", Type="Warning", Icon=Icons.Trash })
    end })
end

local InterfaceManager = {}; InterfaceManager.__index = InterfaceManager
function InterfaceManager:SetLibrary(lib) self.Library = lib end

function InterfaceManager:BuildInterfaceSection(tab)
    tab:AddParagraph({ Title="Interface", Content="Customize the look and behavior.", Icon=Icons.Settings })
    tab:AddDropdown("ThemeSelector", { Title="Theme", Icon=Icons.Palette,
        Values={"Dark","Light","Midnight","Amethyst","Emerald","Rose"}, Default="Dark",
        Callback=function(v) Fluent:SetTheme(v) end })
    tab:AddToggle("AcrylicToggle", { Title="Acrylic Blur", Icon=Icons.Eye, Default=true,
        Callback=function(v) Fluent:ToggleAcrylic(v) end })
    tab:AddKeybind("ToggleKeybind", { Title="Toggle UI Keybind", Icon=Icons.Keyboard, Default=Enum.KeyCode.RightShift })
    tab:AddButton({ Title="Destroy Interface", Icon=Icons.Trash, Callback=function()
        if Fluent.Window then Fluent.Window:Destroy() end
    end })
end

Fluent.SaveManager = SaveManager
Fluent.InterfaceManager = InterfaceManager

return Fluent
