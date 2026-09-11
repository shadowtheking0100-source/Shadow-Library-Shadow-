--[[
    FluentUI v1.1 — Professional Edition
    Inspired by dawid-scripts/Fluent
    • Lucide icon system (no emojis)
    • Floating toggle button + global hotkey
    • Refined multi-theme palettes
    • Full element suite + Save/Interface managers
]]

-- // Services
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local RunService       = game:GetService("RunService")
local CoreGui          = game:GetService("CoreGui")
local HttpService      = game:GetService("HttpService")
local Lighting         = game:GetService("Lighting")
local TextService      = game:GetService("TextService")

local LocalPlayer = Players.LocalPlayer

-- // Icon Library (Lucide — rbxassetid)
local Icons = {
    Menu          = "rbxassetid://10734950020",
    Close         = "rbxassetid://10747384394",
    Minimize      = "rbxassetid://10747384238",
    Maximize      = "rbxassetid://10747384307",
    Home          = "rbxassetid://10734949889",
    Settings      = "rbxassetid://10734950227",
    User          = "rbxassetid://10734950759",
    Info          = "rbxassetid://10734949960",
    Star          = "rbxassetid://10734950129",
    Search        = "rbxassetid://10734950144",
    ChevronDown   = "rbxassetid://10734950264",
    ChevronRight  = "rbxassetid://10747384051",
    Check         = "rbxassetid://10734950211",
    Palette       = "rbxassetid://10734950095",
    Keyboard      = "rbxassetid://10734949957",
    Type          = "rbxassetid://10734950707",
    Sliders       = "rbxassetid://10734950147",
    ToggleLeft    = "rbxassetid://10734950725",
    ToggleRight   = "rbxassetid://10734950735",
    List          = "rbxassetid://10734950033",
    Layers        = "rbxassetid://10734949985",
    Code          = "rbxassetid://10734949805",
    Bell          = "rbxassetid://10734949693",
    Trash         = "rbxassetid://10734950707",
    Download      = "rbxassetid://10734949863",
    Upload        = "rbxassetid://10734950747",
    Refresh       = "rbxassetid://10734950113",
    Save          = "rbxassetid://10734950129",
    Copy          = "rbxassetid://10734949817",
    Eye           = "rbxassetid://10734949850",
    EyeOff        = "rbxassetid://10734949835",
    Play          = "rbxassetid://10734950058",
    Pause         = "rbxassetid://10734950045",
    Zap           = "rbxassetid://10734950775",
    Shield        = "rbxassetid://10734950167",
    Crosshair     = "rbxassetid://10734949829",
    Rocket        = "rbxassetid://10734950135",
    Gamepad       = "rbxassetid://10734949895",
    Camera        = "rbxassetid://10734949793",
    Compass       = "rbxassetid://10734949811",
    Map           = "rbxassetid://10734950070",
    Package       = "rbxassetid://10734950088",
    Moon          = "rbxassetid://10734950067",
    Sun           = "rbxassetid://10734950299",
    Heart         = "rbxassetid://10734949875",
    Bookmark      = "rbxassetid://10734949697",
    Flag          = "rbxassetid://10734949870",
    Lock          = "rbxassetid://10734950040",
    Key           = "rbxassetid://10734949947",
    Wrench        = "rbxassetid://10734950769",
    Skull         = "rbxassetid://10734950191",
    Flame         = "rbxassetid://10734949861",
    Sparkles      = "rbxassetid://10734950173",
    -- aliases
    Slider        = "rbxassetid://10734950147",
    Switch        = "rbxassetid://10734950725",
    Textbox       = "rbxassetid://10734950707",
    Dropdown      = "rbxassetid://10734950033",
    Colorpicker   = "rbxassetid://10734950095",
    Keybind       = "rbxassetid://10734949957",
    Button        = "rbxassetid://10734949817",
    Paragraph     = "rbxassetid://10734949960",
}

-- // Refined Theme Palettes
local Themes = {
    Dark = {
        Background          = Color3.fromRGB(18, 18, 22),
        SecondaryBackground = Color3.fromRGB(25, 25, 30),
        TertiaryBackground  = Color3.fromRGB(34, 34, 42),
        Surface             = Color3.fromRGB(29, 29, 36),
        SurfaceHover        = Color3.fromRGB(36, 36, 44),
        Text                = Color3.fromRGB(236, 237, 243),
        SubText             = Color3.fromRGB(140, 142, 155),
        Accent              = Color3.fromRGB(88, 101, 242),
        AccentHover         = Color3.fromRGB(108, 120, 250),
        AccentMuted         = Color3.fromRGB(58, 66, 150),
        Border              = Color3.fromRGB(42, 42, 52),
        BorderLight         = Color3.fromRGB(55, 55, 68),
        Success             = Color3.fromRGB(87, 200, 120),
        Warning             = Color3.fromRGB(240, 177, 50),
        Error               = Color3.fromRGB(237, 66, 69),
        Shadow              = Color3.fromRGB(0, 0, 0),
    },
    Light = {
        Background          = Color3.fromRGB(248, 249, 252),
        SecondaryBackground = Color3.fromRGB(240, 241, 246),
        TertiaryBackground  = Color3.fromRGB(228, 230, 238),
        Surface             = Color3.fromRGB(255, 255, 255),
        SurfaceHover        = Color3.fromRGB(245, 246, 250),
        Text                = Color3.fromRGB(28, 30, 38),
        SubText             = Color3.fromRGB(110, 114, 128),
        Accent              = Color3.fromRGB(88, 101, 242),
        AccentHover         = Color3.fromRGB(70, 84, 220),
        AccentMuted         = Color3.fromRGB(200, 205, 250),
        Border              = Color3.fromRGB(220, 222, 230),
        BorderLight         = Color3.fromRGB(200, 203, 215),
        Success             = Color3.fromRGB(60, 180, 100),
        Warning             = Color3.fromRGB(230, 155, 30),
        Error               = Color3.fromRGB(220, 55, 60),
        Shadow              = Color3.fromRGB(120, 120, 140),
    },
    Midnight = {
        Background          = Color3.fromRGB(12, 14, 22),
        SecondaryBackground = Color3.fromRGB(18, 20, 30),
        TertiaryBackground  = Color3.fromRGB(26, 29, 42),
        Surface             = Color3.fromRGB(20, 23, 34),
        SurfaceHover        = Color3.fromRGB(28, 32, 46),
        Text                = Color3.fromRGB(220, 226, 240),
        SubText             = Color3.fromRGB(120, 130, 155),
        Accent              = Color3.fromRGB(120, 140, 255),
        AccentHover         = Color3.fromRGB(140, 160, 255),
        AccentMuted         = Color3.fromRGB(50, 60, 120),
        Border              = Color3.fromRGB(32, 36, 50),
        BorderLight         = Color3.fromRGB(45, 50, 68),
        Success             = Color3.fromRGB(80, 190, 130),
        Warning             = Color3.fromRGB(240, 180, 60),
        Error               = Color3.fromRGB(240, 80, 90),
        Shadow              = Color3.fromRGB(0, 0, 0),
    },
    Amethyst = {
        Background          = Color3.fromRGB(22, 18, 30),
        SecondaryBackground = Color3.fromRGB(30, 25, 40),
        TertiaryBackground  = Color3.fromRGB(40, 33, 54),
        Surface             = Color3.fromRGB(34, 28, 46),
        SurfaceHover        = Color3.fromRGB(44, 36, 60),
        Text                = Color3.fromRGB(238, 232, 248),
        SubText             = Color3.fromRGB(160, 148, 185),
        Accent              = Color3.fromRGB(160, 120, 245),
        AccentHover         = Color3.fromRGB(180, 145, 255),
        AccentMuted         = Color3.fromRGB(80, 55, 130),
        Border              = Color3.fromRGB(50, 42, 68),
        BorderLight         = Color3.fromRGB(65, 54, 88),
        Success             = Color3.fromRGB(120, 200, 150),
        Warning             = Color3.fromRGB(245, 190, 80),
        Error               = Color3.fromRGB(240, 90, 120),
        Shadow              = Color3.fromRGB(0, 0, 0),
    },
    Emerald = {
        Background          = Color3.fromRGB(15, 22, 20),
        SecondaryBackground = Color3.fromRGB(22, 32, 29),
        TertiaryBackground  = Color3.fromRGB(30, 44, 40),
        Surface             = Color3.fromRGB(25, 36, 33),
        SurfaceHover        = Color3.fromRGB(33, 47, 43),
        Text                = Color3.fromRGB(226, 240, 236),
        SubText             = Color3.fromRGB(140, 170, 160),
        Accent              = Color3.fromRGB(70, 200, 160),
        AccentHover         = Color3.fromRGB(95, 220, 180),
        AccentMuted         = Color3.fromRGB(35, 100, 80),
        Border              = Color3.fromRGB(38, 55, 50),
        BorderLight         = Color3.fromRGB(50, 72, 65),
        Success             = Color3.fromRGB(90, 210, 140),
        Warning             = Color3.fromRGB(240, 190, 70),
        Error               = Color3.fromRGB(235, 90, 100),
        Shadow              = Color3.fromRGB(0, 0, 0),
    },
    Rose = {
        Background          = Color3.fromRGB(26, 18, 22),
        SecondaryBackground = Color3.fromRGB(35, 25, 30),
        TertiaryBackground  = Color3.fromRGB(48, 34, 40),
        Surface             = Color3.fromRGB(40, 29, 34),
        SurfaceHover        = Color3.fromRGB(52, 38, 44),
        Text                = Color3.fromRGB(248, 232, 236),
        SubText             = Color3.fromRGB(190, 155, 165),
        Accent              = Color3.fromRGB(240, 105, 145),
        AccentHover         = Color3.fromRGB(255, 130, 165),
        AccentMuted         = Color3.fromRGB(120, 55, 75),
        Border              = Color3.fromRGB(58, 42, 48),
        BorderLight         = Color3.fromRGB(75, 55, 62),
        Success             = Color3.fromRGB(120, 200, 150),
        Warning             = Color3.fromRGB(245, 190, 80),
        Error               = Color3.fromRGB(240, 80, 90),
        Shadow              = Color3.fromRGB(0, 0, 0),
    },
}

-- // Utilities
local U = {}

function U.new(class, props)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    return i
end

function U.tween(inst, props, dur, style, dir)
    local ti = TweenInfo.new(dur or 0.22, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(inst, ti, props)
    t:Play(); return t
end

function U.corner(parent, r)
    return U.new("UICorner", { CornerRadius = UDim.new(0, r or 8), Parent = parent })
end

function U.stroke(parent, color, thickness, transparency)
    return U.new("UIStroke", {
        Color = color or Color3.fromRGB(60,60,70),
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

function U.padding(parent, t, b, l, r)
    return U.new("UIPadding", {
        PaddingTop = UDim.new(0, t or 8), PaddingBottom = UDim.new(0, b or 8),
        PaddingLeft = UDim.new(0, l or 8), PaddingRight = UDim.new(0, r or 8),
        Parent = parent,
    })
end

function U.shadow(parent, color, transparency)
    return U.new("ImageLabel", {
        Name = "Shadow", BackgroundTransparency = 1, Image = "rbxassetid://6014261993",
        ImageColor3 = color or Color3.new(0,0,0), ImageTransparency = transparency or 0.55,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49,49,450,450),
        Size = UDim2.new(1, 40, 1, 40), Position = UDim2.new(0, -20, 0, -20),
        ZIndex = -1, Parent = parent,
    })
end

function U.icon(parent, assetId, size, color, pos, zIndex)
    return U.new("ImageLabel", {
        BackgroundTransparency = 1, Image = assetId,
        ImageColor3 = color or Color3.fromRGB(200,200,210),
        Size = size or UDim2.fromOffset(16,16), Position = pos or UDim2.fromOffset(0,0),
        ZIndex = zIndex or 1, Parent = parent,
    })
end

function U.draggable(frame, handle, bounds)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        local np = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                             startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        if bounds then
            local vp = workspace.CurrentCamera.ViewportSize
            local a = frame.AbsoluteSize
            local x = math.clamp(np.X.Offset + np.X.Scale * vp.X, bounds.minX or 0, vp.X - a.X - (bounds.maxX or 0))
            local y = math.clamp(np.Y.Offset + np.Y.Scale * vp.Y, bounds.minY or 0, vp.Y - a.Y - (bounds.maxY or 0))
            np = UDim2.fromOffset(x, y)
        end
        frame.Position = np
    end
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

function U.round(n, d) local m = 10^(d or 0); return math.floor(n*m + 0.5)/m end
function U.toHex(c) return string.format("#%02X%02X%02X", math.floor(c.R*255), math.floor(c.G*255), math.floor(c.B*255)) end
function U.fromHex(h)
    h = h:gsub("#","")
    if #h ~= 6 then return nil end
    return Color3.fromRGB(tonumber(h:sub(1,2),16), tonumber(h:sub(3,4),16), tonumber(h:sub(5,6),16))
end

-- // Main library
local Fluent = {
    Version = "1.1.0",
    Icons = Icons,
    Themes = Themes,
    Options = {},
    Theme = "Dark",
    Unloaded = false,
    UseAcrylic = true,
}

-- // Floating Toggle Button
function Fluent:CreateToggleButton(config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local gui = config.Parent or U.new("ScreenGui", {
        Name = "FluentUI_ToggleButton",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 9999,
        Parent = CoreGui,
    })

    local button = U.new("ImageButton", {
        Name = "ToggleButton",
        Size = UDim2.fromOffset(config.Size or 48, config.Size or 48),
        Position = config.Position or UDim2.new(0, 20, 0.5, -24),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Image = "",
        AutoButtonColor = false,
        Parent = gui,
    })
    U.corner(button, (config.Size or 48) / 2)
    U.stroke(button, theme.BorderLight, 1)
    U.shadow(button, theme.Shadow, 0.45)

    -- icon container for morph animation
    local iconHolder = U.new("Frame", {
        BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = button,
    })

    -- hamburger lines (3 bars)
    local barSize = UDim2.fromOffset(20, 2)
    local barColor = config.IconColor or theme.Text
    local bar1 = U.new("Frame", {
        Name = "Bar1", Size = barSize,
        Position = UDim2.new(0.5, -10, 0.5, -6), BackgroundColor3 = barColor,
        BorderSizePixel = 0, Parent = iconHolder,
    }); U.corner(bar1, 2)
    local bar2 = U.new("Frame", {
        Name = "Bar2", Size = barSize,
        Position = UDim2.new(0.5, -10, 0.5, -1), BackgroundColor3 = barColor,
        BorderSizePixel = 0, Parent = iconHolder,
    }); U.corner(bar2, 2)
    local bar3 = U.new("Frame", {
        Name = "Bar3", Size = barSize,
        Position = UDim2.new(0.5, -10, 0.5, 4), BackgroundColor3 = barColor,
        BorderSizePixel = 0, Parent = iconHolder,
    }); U.corner(bar3, 2)

    local isOpen = false
    local hovering = false

    local function setOpen(open)
        isOpen = open
        if open then
            U.tween(bar1, { Position = UDim2.new(0.5,-10,0.5,-1), Rotation = 45 }, 0.22)
            U.tween(bar3, { Position = UDim2.new(0.5,-10,0.5,-1), Rotation = -45 }, 0.22)
            U.tween(bar2, { BackgroundTransparency = 1 }, 0.15)
        else
            U.tween(bar1, { Position = UDim2.new(0.5,-10,0.5,-6), Rotation = 0 }, 0.22)
            U.tween(bar3, { Position = UDim2.new(0.5,-10,0.5,4),  Rotation = 0 }, 0.22)
            U.tween(bar2, { BackgroundTransparency = 0 }, 0.15)
        end
    end

    button.MouseEnter:Connect(function()
        hovering = true
        U.tween(button, { BackgroundColor3 = theme.SurfaceHover }, 0.15)
        U.tween(button, { Size = UDim2.fromOffset((config.Size or 48)+4, (config.Size or 48)+4) }, 0.15)
    end)
    button.MouseLeave:Connect(function()
        hovering = false
        U.tween(button, { BackgroundColor3 = theme.Surface }, 0.15)
        U.tween(button, { Size = UDim2.fromOffset(config.Size or 48, config.Size or 48) }, 0.15)
    end)

    U.draggable(button, button, { minX = 4, maxX = 4, minY = 4, maxY = 4 })

    -- Click detection (avoid triggering after drag)
    local pressPos, wasDragged
    button.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            pressPos = i.Position; wasDragged = false
        end
    end)
    button.InputChanged:Connect(function(i)
        if pressPos and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            if (i.Position - pressPos).Magnitude > 6 then wasDragged = true end
        end
    end)
    button.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if not wasDragged and config.OnClick then config.OnClick() end
            pressPos = nil
        end
    end)

    -- animate entrance
    button.Size = UDim2.fromOffset(0,0)
    U.tween(button, { Size = UDim2.fromOffset(config.Size or 48, config.Size or 48) }, 0.4, Enum.EasingStyle.Back)

    self.ToggleButton = button
    self.ToggleButtonGui = gui
    self.ToggleButtonSetOpen = setOpen

    return {
        Instance = button,
        SetOpen = setOpen,
        Destroy = function() gui:Destroy() end,
    }
end

-- // Window
local Window = {}
Window.__index = Window

function Fluent:CreateWindow(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, Window)

    self.Title        = cfg.Title or "FluentUI"
    self.SubTitle     = cfg.SubTitle or ""
    self.TabWidth     = cfg.TabWidth or 170
    self.Size         = cfg.Size or UDim2.fromOffset(620, 480)
    self.Theme        = cfg.Theme or Fluent.Theme
    self.MinimizeKey  = cfg.MinimizeKey or Enum.KeyCode.LeftControl
    self.ToggleKey    = cfg.ToggleKey or Enum.KeyCode.RightShift
    self.Acrylic      = cfg.Acrylic ~= false
    self.Minimized    = false
    self.Hidden       = false
    self.Tabs         = {}
    self.SelectedTab  = nil
    self.DialogOpen   = false
    self.CornerRadius = cfg.CornerRadius or 12

    local theme = Themes[self.Theme] or Themes.Dark

    self.GUI = U.new("ScreenGui", {
        Name = "FluentUI_" .. HttpService:GenerateGUID(false),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        Parent = CoreGui,
    })

    -- Root container (for fade animations)
    self.Root = U.new("Frame", {
        Name = "Root", Size = UDim2.fromScale(1,1),
        BackgroundTransparency = 1, Parent = self.GUI,
    })

    -- Main window
    self.WindowFrame = U.new("Frame", {
        Name = "Window",
        Size = self.Size,
        Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.Root,
    })
    U.corner(self.WindowFrame, self.CornerRadius)
    U.stroke(self.WindowFrame, theme.Border, 1)
    U.shadow(self.WindowFrame, theme.Shadow, 0.5)

    if self.Acrylic then
        self.Blur = U.new("BlurEffect", { Size = 14, Parent = Lighting })
    end

    -- Title bar
    self.TitleBar = U.new("Frame", {
        Name = "TitleBar", Size = UDim2.new(1, 0, 0, 48),
        BackgroundColor3 = theme.SecondaryBackground,
        BorderSizePixel = 0, Parent = self.WindowFrame,
    })

    -- Brand icon
    U.icon(self.TitleBar, Icons.Sparkles, UDim2.fromOffset(16,16),
        theme.Accent, UDim2.fromOffset(16, 16))

    self.TitleLabel = U.new("TextLabel", {
        Text = self.Title, Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(42, 0), Size = UDim2.new(0, 200, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = self.TitleBar,
    })
    self.TitleLabel.Position = UDim2.fromOffset(42, self.SubTitle ~= "" and 6 or 0)
    self.TitleLabel.Size = UDim2.new(0, 200, 0, self.SubTitle ~= "" and 20 or 48)

    if self.SubTitle ~= "" then
        self.SubTitleLabel = U.new("TextLabel", {
            Text = self.SubTitle, Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = theme.SubText, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(42, 24), Size = UDim2.new(0, 200, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left, Parent = self.TitleBar,
        })
    end

    -- window control buttons
    local function makeCtrlButton(iconId, xOffset, hoverColor)
        local b = U.new("ImageButton", {
            BackgroundTransparency = 1,
            Image = iconId,
            ImageColor3 = theme.SubText,
            Size = UDim2.fromOffset(16,16),
            Position = UDim2.new(1, xOffset, 0.5, -8),
            AutoButtonColor = false, Parent = self.TitleBar,
        })
        b.MouseEnter:Connect(function() U.tween(b, { ImageColor3 = hoverColor or theme.Text }, 0.15) end)
        b.MouseLeave:Connect(function() U.tween(b, { ImageColor3 = theme.SubText }, 0.15) end)
        return b
    end

    self.MinimizeButton = makeCtrlButton(Icons.Minimize, -72, theme.Text)
    self.CloseButton    = makeCtrlButton(Icons.Close,    -40, theme.Error)

    -- Tab container
    self.TabContainer = U.new("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(0, self.TabWidth, 1, -48),
        Position = UDim2.fromOffset(0, 48),
        BackgroundColor3 = theme.SecondaryBackground,
        BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Border,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.WindowFrame,
    })
    U.new("UIListLayout", {
        Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = self.TabContainer,
    })
    U.padding(self.TabContainer, 8, 8, 8, 8)

    -- Content container
    self.ContentContainer = U.new("ScrollingFrame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -self.TabWidth, 1, -48),
        Position = UDim2.new(0, self.TabWidth, 0, 48),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Border,
        CanvasSize = UDim2.new(0,0,0,0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.WindowFrame,
    })
    U.new("UIListLayout", {
        Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = self.ContentContainer,
    })
    U.padding(self.ContentContainer, 14, 14, 14, 14)

    -- Notification stack
    self.NotifyContainer = U.new("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 320, 1, 0),
        Position = UDim2.new(1, -336, 0, 0),
        BackgroundTransparency = 1, Parent = self.GUI,
    })
    U.new("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Parent = self.NotifyContainer,
    })

    -- Dialog overlay
    self.DialogOverlay = U.new("TextButton", {
        Name = "DialogOverlay", Size = UDim2.fromScale(1,1),
        BackgroundColor3 = Color3.new(0,0,0), BackgroundTransparency = 1,
        Text = "", Visible = false, Parent = self.GUI,
    })

    -- Make window draggable
    U.draggable(self.WindowFrame, self.TitleBar)

    -- Controls
    self.MinimizeButton.MouseButton1Click:Connect(function() self:ToggleMinimize() end)
    self.CloseButton.MouseButton1Click:Connect(function() self:Destroy() end)

    -- Hotkeys
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == self.MinimizeKey then self:ToggleMinimize() end
        if input.KeyCode == self.ToggleKey then self:ToggleVisibility() end
    end)

    -- Floating button
    self.ToggleButton = Fluent:CreateToggleButton({
        OnClick = function() self:ToggleVisibility() end,
    })

    -- Auto-set button state when visibility changes externally
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
        self.WindowFrame.Size = UDim2.fromOffset(self.Size.X.Offset * 0.95, self.Size.Y.Offset * 0.95)
        self.WindowFrame.Position = UDim2.new(0.5, -self.Size.X.Offset*0.475, 0.5, -self.Size.Y.Offset*0.475)
        U.tween(self.WindowFrame, {
            Size = self.Size,
            Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2),
        }, 0.25, Enum.EasingStyle.Quart)
    else
        U.tween(self.WindowFrame, {
            Size = UDim2.fromOffset(self.Size.X.Offset * 0.95, self.Size.Y.Offset * 0.95),
            Position = UDim2.new(0.5, -self.Size.X.Offset*0.475, 0.5, -self.Size.Y.Offset*0.475),
        }, 0.2, Enum.EasingStyle.Quart)
        task.delay(0.2, function()
            if self.Hidden then self.Root.Visible = false end
        end)
    end

    if self._syncToggleButton then self._syncToggleButton(visible) end
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    if self.Minimized then
        U.tween(self.WindowFrame, { Size = UDim2.new(0, self.Size.X.Offset, 0, 48) }, 0.3)
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

    local tab = {
        Title = cfg.Title or "Tab",
        Icon = cfg.Icon or nil,
        Window = self,
        Elements = {},
    }

    tab.Button = U.new("TextButton", {
        Name = tab.Title, Text = "",
        BackgroundColor3 = theme.SecondaryBackground,
        BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 34),
        AutoButtonColor = false, Parent = self.TabContainer,
    })
    U.corner(tab.Button, 6)

    local iconOffset = 0
    if tab.Icon then
        tab.IconImage = U.icon(tab.Button, tab.Icon, UDim2.fromOffset(16,16),
            theme.SubText, UDim2.fromOffset(10, 9))
        iconOffset = 24
    end

    tab.Label = U.new("TextLabel", {
        Text = tab.Title, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.SubText, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10 + iconOffset, 0),
        Size = UDim2.new(1, -(10 + iconOffset), 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = tab.Button,
    })

    tab.Button.MouseEnter:Connect(function()
        if self.SelectedTab ~= tab then
            U.tween(tab.Button, { BackgroundColor3 = theme.SurfaceHover }, 0.15)
        end
    end)
    tab.Button.MouseLeave:Connect(function()
        if self.SelectedTab ~= tab then
            U.tween(tab.Button, { BackgroundColor3 = theme.SecondaryBackground }, 0.15)
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
        U.tween(t.Button, { BackgroundColor3 = active and theme.Accent or theme.SecondaryBackground }, 0.2)
        U.tween(t.Label, { TextColor3 = active and theme.Text or theme.SubText }, 0.2)
        if t.IconImage then
            U.tween(t.IconImage, { ImageColor3 = active and theme.Text or theme.SubText }, 0.2)
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

-- // Elements
function Window:AddSection(name)
    local theme = Themes[self.Theme] or Themes.Dark
    local inst = U.new("Frame", {
        Name = "Section_" .. name, Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1, Parent = self.ContentContainer,
    })
    U.new("Frame", { -- divider
        Size = UDim2.new(0, 3, 0, 14),
        Position = UDim2.fromOffset(0, 8),
        BackgroundColor3 = theme.Accent, BorderSizePixel = 0, Parent = inst,
    })
    U.corner(inst:FindFirstChildWhichIsA("Frame"), 2)
    U.new("TextLabel", {
        Text = name, Font = Enum.Font.GothamBold, TextSize = 11,
        TextColor3 = theme.SubText, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -12, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })
    return { Instance = inst }
end

local function pushElement(win, el)
    if win.SelectedTab then table.insert(win.SelectedTab.Elements, el) end
    return el
end

function Window:AddParagraph(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local inst = U.new("Frame", {
        Name = "Paragraph", Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Parent = self.ContentContainer,
    })
    U.corner(inst, 8); U.stroke(inst, theme.Border, 1)
    U.icon(inst, cfg.Icon or Icons.Info, UDim2.fromOffset(14,14), theme.Accent, UDim2.fromOffset(12, 12))
    U.new("TextLabel", {
        Text = cfg.Title or "Paragraph", Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(34, 10), Size = UDim2.new(1, -46, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })
    U.new("TextLabel", {
        Text = cfg.Content or "", Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = theme.SubText, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 32), Size = UDim2.new(1, -24, 1, -40),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true, Parent = inst,
    })
    return pushElement(self, { Instance = inst })
end

function Window:AddButton(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local inst = U.new("TextButton", {
        Name = "Button", Text = "",
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, cfg.Description and 48 or 40),
        AutoButtonColor = false, Parent = self.ContentContainer,
    })
    U.corner(inst, 8); U.stroke(inst, theme.Border, 1)

    U.icon(inst, cfg.Icon or Icons.Button, UDim2.fromOffset(15,15), theme.Accent, UDim2.fromOffset(12, 12))
    U.new("TextLabel", {
        Text = cfg.Title or "Button", Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -48, 0, cfg.Description and 24 or 40),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })
    if cfg.Description then
        U.new("TextLabel", {
            Text = cfg.Description, Font = Enum.Font.Gotham, TextSize = 10,
            TextColor3 = theme.SubText, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(36, 24), Size = UDim2.new(1, -48, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
        })
    end
    inst.MouseEnter:Connect(function() U.tween(inst, { BackgroundColor3 = theme.SurfaceHover }, 0.15) end)
    inst.MouseLeave:Connect(function() U.tween(inst, { BackgroundColor3 = theme.Surface }, 0.15) end)
    inst.MouseButton1Click:Connect(function() if cfg.Callback then task.spawn(cfg.Callback) end end)
    return pushElement(self, { Instance = inst })
end

function Window:AddToggle(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local toggle = { Value = cfg.Default or false, Callbacks = {} }

    local inst = U.new("Frame", {
        Name = "Toggle_"..id, Size = UDim2.new(1, 0, 0, cfg.Description and 48 or 40),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Parent = self.ContentContainer,
    })
    U.corner(inst, 8); U.stroke(inst, theme.Border, 1)

    U.icon(inst, cfg.Icon or Icons.Switch, UDim2.fromOffset(15,15), theme.Accent, UDim2.fromOffset(12, 12))
    U.new("TextLabel", {
        Text = cfg.Title or id, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -100, 0, cfg.Description and 24 or 40),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })
    if cfg.Description then
        U.new("TextLabel", {
            Text = cfg.Description, Font = Enum.Font.Gotham, TextSize = 10,
            TextColor3 = theme.SubText, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(36, 24), Size = UDim2.new(1, -100, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
        })
    end

    local swBg = U.new("Frame", {
        Size = UDim2.fromOffset(40, 22), Position = UDim2.new(1, -52, 0.5, -11),
        BackgroundColor3 = toggle.Value and theme.Accent or theme.Border,
        BorderSizePixel = 0, Parent = inst,
    })
    U.corner(swBg, 11)
    local swKnob = U.new("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(0, toggle.Value and 20 or 2, 0.5, -9),
        BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Parent = swBg,
    })
    U.corner(swKnob, 9)

    local click = U.new("TextButton", {
        Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = inst,
    })

    local function setValue(v)
        toggle.Value = v
        U.tween(swBg, { BackgroundColor3 = v and theme.Accent or theme.Border }, 0.2)
        U.tween(swKnob, { Position = UDim2.new(0, v and 20 or 2, 0.5, -9) }, 0.2)
        for _, cb in ipairs(toggle.Callbacks) do task.spawn(cb, v) end
        if cfg.Callback then task.spawn(cfg.Callback, v) end
    end
    click.MouseButton1Click:Connect(function() setValue(not toggle.Value) end)

    toggle.Instance = inst
    toggle.SetValue = setValue
    toggle.GetValue = function() return toggle.Value end
    toggle.OnChanged = function(cb) table.insert(toggle.Callbacks, cb) end

    Fluent.Options[id] = toggle
    return pushElement(self, toggle)
end

function Window:AddSlider(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local min, max = cfg.Min or 0, cfg.Max or 100
    local slider = { Value = cfg.Default or min, Callbacks = {} }

    local inst = U.new("Frame", {
        Name = "Slider_"..id, Size = UDim2.new(1, 0, 0, 58),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Parent = self.ContentContainer,
    })
    U.corner(inst, 8); U.stroke(inst, theme.Border, 1)

    U.icon(inst, cfg.Icon or Icons.Sliders, UDim2.fromOffset(15,15), theme.Accent, UDim2.fromOffset(12, 10))
    U.new("TextLabel", {
        Text = cfg.Title or id, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(36, 8), Size = UDim2.new(1, -100, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })
    local valueLabel = U.new("TextLabel", {
        Text = tostring(slider.Value), Font = Enum.Font.GothamMedium, TextSize = 11,
        TextColor3 = theme.Accent, BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 8), Size = UDim2.fromOffset(50, 16),
        TextXAlignment = Enum.TextXAlignment.Right, Parent = inst,
    })
    local track = U.new("Frame", {
        Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(12, 38),
        BackgroundColor3 = theme.Border, BorderSizePixel = 0, Parent = inst,
    })
    U.corner(track, 3)
    local fill = U.new("Frame", {
        Size = UDim2.new(0,0,1,0), BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0, Parent = track,
    })
    U.corner(fill, 3)
    local knob = U.new("Frame", {
        Size = UDim2.fromOffset(14,14), Position = UDim2.new(0, -7, 0.5, -7),
        BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Parent = track,
    })
    U.corner(knob, 7); U.stroke(knob, theme.Accent, 2)

    local function calc(input)
        local start = track.AbsolutePosition.X
        local w = track.AbsoluteSize.X
        local rel = math.clamp((input.Position.X - start) / w, 0, 1)
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
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            calc(i)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- init
    local p0 = (slider.Value - min) / (max - min)
    fill.Size = UDim2.new(p0, 0, 1, 0)
    knob.Position = UDim2.new(p0, -7, 0.5, -7)
    valueLabel.Text = (cfg.Rounding == 0 or not cfg.Rounding) and tostring(math.floor(slider.Value)) or string.format("%."..cfg.Rounding.."f", slider.Value)

    slider.Instance = inst
    slider.SetValue = function(v) slider.Value = v; local p = (v-min)/(max-min)
        valueLabel.Text = tostring(v)
        U.tween(fill, { Size = UDim2.new(p, 0, 1, 0) }, 0.15)
        U.tween(knob, { Position = UDim2.new(p, -7, 0.5, -7) }, 0.15)
    end
    slider.GetValue = function() return slider.Value end
    slider.OnChanged = function(cb) table.insert(slider.Callbacks, cb) end

    Fluent.Options[id] = slider
    return pushElement(self, slider)
end

function Window:AddDropdown(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local multi = cfg.Multi or false
    local dropdown = {
        Value = cfg.Default or (multi and {} or nil),
        Options = cfg.Values or {},
        Multi = multi, Callbacks = {}, Expanded = false,
    }

    local inst = U.new("Frame", {
        Name = "Dropdown_"..id, Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0,
        ClipsDescendants = false, Parent = self.ContentContainer,
    })
    U.corner(inst, 8); U.stroke(inst, theme.Border, 1)

    U.icon(inst, cfg.Icon or Icons.Dropdown, UDim2.fromOffset(15,15), theme.Accent, UDim2.fromOffset(12, 12))
    U.new("TextLabel", {
        Text = cfg.Title or id, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -80, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })

    local arrow = U.icon(inst, Icons.ChevronDown, UDim2.fromOffset(14,14), theme.SubText, UDim2.new(1, -30, 0.5, -7))

    local click = U.new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = inst })

    -- selection preview
    local previewText = ""
    if multi and type(dropdown.Value) == "table" then
        previewText = #dropdown.Value > 0 and table.concat(dropdown.Value, ", ") or "Select..."
    elseif dropdown.Value then
        previewText = tostring(dropdown.Value)
    else
        previewText = "Select..."
    end
    local preview = U.new("TextLabel", {
        Text = previewText, Font = Enum.Font.Gotham, TextSize = 10,
        TextColor3 = theme.SubText, BackgroundTransparency = 1,
        Position = UDim2.new(1, -80, 0.5, -8), Size = UDim2.fromOffset(70, 16),
        TextXAlignment = Enum.TextXAlignment.Right, Parent = inst,
    })

    -- popup
    local popup = U.new("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 6),
        BackgroundColor3 = theme.TertiaryBackground, BorderSizePixel = 0,
        Visible = false, ZIndex = 20,
        ScrollBarThickness = 2, ScrollBarImageColor3 = theme.Border,
        CanvasSize = UDim2.new(0,0,0,0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = inst,
    })
    U.corner(popup, 8); U.stroke(popup, theme.BorderLight, 1); U.padding(popup, 6, 6, 6, 6)
    U.new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = popup })
    U.shadow(popup, theme.Shadow, 0.4)

    -- search box (optional)
    local searchBox
    if cfg.Searchable ~= false and #dropdown.Options > 6 then
        local sf = U.new("Frame", {
            Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Parent = popup,
        })
        searchBox = U.new("TextBox", {
            Text = "", PlaceholderText = "Search...",
            Font = Enum.Font.Gotham, TextSize = 11,
            TextColor3 = theme.Text, PlaceholderColor3 = theme.SubText,
            BackgroundColor3 = theme.Surface, BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0), ClearTextOnFocus = false, Parent = sf,
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
                local ob = U.new("TextButton", {
                    Text = "", Font = Enum.Font.Gotham, TextSize = 11,
                    BackgroundColor3 = theme.TertiaryBackground,
                    BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 28),
                    AutoButtonColor = false, Parent = popup,
                })
                U.corner(ob, 5)
                U.new("TextLabel", {
                    Text = tostring(opt), Font = Enum.Font.Gotham, TextSize = 11,
                    TextColor3 = theme.Text, BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -40, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = ob,
                })
                -- selection indicator
                local isSelected = multi and type(dropdown.Value) == "table" and table.find(dropdown.Value, opt)
                    or (not multi and dropdown.Value == opt)
                if isSelected then
                    U.icon(ob, Icons.Check, UDim2.fromOffset(14,14), theme.Accent, UDim2.new(1, -22, 0.5, -7))
                end
                ob.MouseEnter:Connect(function() U.tween(ob, { BackgroundColor3 = theme.SurfaceHover }, 0.12) end)
                ob.MouseLeave:Connect(function() U.tween(ob, { BackgroundColor3 = theme.TertiaryBackground }, 0.12) end)
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
        U.tween(arrow, { Rotation = dropdown.Expanded and 180 or 0 }, 0.2)
        if dropdown.Expanded then
            local h = math.min(#dropdown.Options * 30 + (searchBox and 36 or 0) + 12, 220)
            popup.Visible = true
            U.tween(popup, { Size = UDim2.new(1, 0, 0, h) }, 0.22)
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
    return pushElement(self, dropdown)
end

function Window:AddColorpicker(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local cp = { Value = cfg.Default or Color3.fromRGB(88,101,242), Callbacks = {}, Expanded = false }

    local inst = U.new("Frame", {
        Name = "Colorpicker_"..id, Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0,
        ClipsDescendants = false, Parent = self.ContentContainer,
    })
    U.corner(inst, 8); U.stroke(inst, theme.Border, 1)

    U.icon(inst, cfg.Icon or Icons.Colorpicker, UDim2.fromOffset(15,15), theme.Accent, UDim2.fromOffset(12, 12))
    U.new("TextLabel", {
        Text = cfg.Title or id, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -80, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })

    local preview = U.new("Frame", {
        Size = UDim2.fromOffset(24,24), Position = UDim2.new(1, -40, 0.5, -12),
        BackgroundColor3 = cp.Value, BorderSizePixel = 0, Parent = inst,
    })
    U.corner(preview, 6); U.stroke(preview, theme.BorderLight, 1)

    local click = U.new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1,1), Parent = inst })

    -- popup
    local popup = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 6),
        BackgroundColor3 = theme.TertiaryBackground, BorderSizePixel = 0,
        Visible = false, ZIndex = 20, Parent = inst,
    })
    U.corner(popup, 8); U.stroke(popup, theme.BorderLight, 1); U.padding(popup, 10, 10, 10, 10)
    U.shadow(popup, theme.Shadow, 0.4)

    -- hue slider
    local hue = U.new("Frame", {
        Size = UDim2.new(1, 0, 0, 22), Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = cp.Value, BorderSizePixel = 0, Parent = popup,
    })
    U.corner(hue, 5)
    U.new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0)),
        }),
        Parent = hue,
    })
    local hueKnob = U.new("Frame", {
        Size = UDim2.fromOffset(14,14), Position = UDim2.new(0, -7, 0.5, -7),
        BackgroundColor3 = Color3.new(1,1,1), BorderSizePixel = 0, Parent = hue,
    })
    U.corner(hueKnob, 7); U.stroke(hueKnob, theme.Text, 2)

    local hexBox = U.new("TextBox", {
        Text = U.toHex(cp.Value), PlaceholderText = "#RRGGBB",
        Font = Enum.Font.Code, TextSize = 12, TextColor3 = theme.Text,
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 28), Position = UDim2.fromOffset(0, 32),
        ClearTextOnFocus = false, Parent = popup,
    })
    U.corner(hexBox, 5); U.stroke(hexBox, theme.Border, 1)

    local draggingHue = false
    local function applyFromHue(input)
        local start = hue.AbsolutePosition.X
        local w = hue.AbsoluteSize.X
        local rel = math.clamp((input.Position.X - start) / w, 0, 1)
        hueKnob.Position = UDim2.new(rel, -7, 0.5, -7)
        local c = Color3.fromHSV(rel, 1, 1)
        cp.Value = c
        preview.BackgroundColor3 = c
        hexBox.Text = U.toHex(c)
        for _, cb in ipairs(cp.Callbacks) do task.spawn(cb, c) end
        if cfg.Callback then task.spawn(cfg.Callback, c) end
    end
    hue.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            draggingHue = true; applyFromHue(i)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if draggingHue and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            applyFromHue(i)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            draggingHue = false
        end
    end)

    hexBox.FocusLost:Connect(function()
        local c = U.fromHex(hexBox.Text)
        if c then
            cp.Value = c; preview.BackgroundColor3 = c
            local h = select(1, Color3.toHSV(c))
            hueKnob.Position = UDim2.new(h, -7, 0.5, -7)
        else
            hexBox.Text = U.toHex(cp.Value)
        end
    end)

    click.MouseButton1Click:Connect(function()
        cp.Expanded = not cp.Expanded
        if cp.Expanded then
            popup.Visible = true
            U.tween(popup, { Size = UDim2.new(1, 0, 0, 70) }, 0.22)
        else
            U.tween(popup, { Size = UDim2.new(1, 0, 0, 0) }, 0.18)
            task.delay(0.18, function() popup.Visible = false end)
        end
    end)

    -- init
    local h0 = select(1, Color3.toHSV(cp.Value))
    hueKnob.Position = UDim2.new(h0, -7, 0.5, -7)

    cp.Instance = inst
    cp.SetValue = function(c)
        cp.Value = c; preview.BackgroundColor3 = c
        hexBox.Text = U.toHex(c)
        local h = select(1, Color3.toHSV(c))
        hueKnob.Position = UDim2.new(h, -7, 0.5, -7)
    end
    cp.GetValue = function() return cp.Value end
    cp.OnChanged = function(cb) table.insert(cp.Callbacks, cb) end

    Fluent.Options[id] = cp
    return pushElement(self, cp)
end

function Window:AddKeybind(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local kb = { Value = cfg.Default or Enum.KeyCode.Unknown, Callbacks = {}, Listening = false }

    local inst = U.new("Frame", {
        Name = "Keybind_"..id, Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Parent = self.ContentContainer,
    })
    U.corner(inst, 8); U.stroke(inst, theme.Border, 1)

    U.icon(inst, cfg.Icon or Icons.Keybind, UDim2.fromOffset(15,15), theme.Accent, UDim2.fromOffset(12, 12))
    U.new("TextLabel", {
        Text = cfg.Title or id, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(36, 0), Size = UDim2.new(1, -130, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })

    local keyBtn = U.new("TextButton", {
        Text = kb.Value ~= Enum.KeyCode.Unknown and kb.Value.Name or "None",
        Font = Enum.Font.GothamMedium, TextSize = 11,
        TextColor3 = theme.Text, BackgroundColor3 = theme.TertiaryBackground,
        BorderSizePixel = 0, Size = UDim2.fromOffset(80, 28),
        Position = UDim2.new(1, -92, 0.5, -14), AutoButtonColor = false, Parent = inst,
    })
    U.corner(keyBtn, 6); U.stroke(keyBtn, theme.BorderLight, 1)

    keyBtn.MouseButton1Click:Connect(function()
        kb.Listening = true
        keyBtn.Text = "..."
        keyBtn.TextColor3 = theme.Warning
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if kb.Listening and input.UserInputType == Enum.UserInputType.Keyboard then
            kb.Listening = false
            kb.Value = input.KeyCode
            keyBtn.Text = input.KeyCode.Name
            keyBtn.TextColor3 = theme.Text
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
    return pushElement(self, kb)
end

function Window:AddTextbox(id, cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark
    local tb = { Value = cfg.Default or "", Callbacks = {} }

    local inst = U.new("Frame", {
        Name = "Textbox_"..id, Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Parent = self.ContentContainer,
    })
    U.corner(inst, 8); U.stroke(inst, theme.Border, 1)

    U.icon(inst, cfg.Icon or Icons.Textbox, UDim2.fromOffset(15,15), theme.Accent, UDim2.fromOffset(12, 10))
    U.new("TextLabel", {
        Text = cfg.Title or id, Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(36, 8), Size = UDim2.new(1, -48, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = inst,
    })

    local box = U.new("TextBox", {
        Text = tb.Value, PlaceholderText = cfg.Placeholder or "Enter text...",
        Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = theme.Text, PlaceholderColor3 = theme.SubText,
        BackgroundColor3 = theme.TertiaryBackground, BorderSizePixel = 0,
        Size = UDim2.new(1, -24, 0, 26), Position = UDim2.fromOffset(12, 28),
        ClearTextOnFocus = false, Parent = inst,
    })
    U.corner(box, 6); U.stroke(box, theme.Border, 1)

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
    return pushElement(self, tb)
end

-- // Dialog
function Window:Dialog(cfg)
    cfg = cfg or {}
    if self.DialogOpen then return end
    self.DialogOpen = true
    local theme = Themes[self.Theme] or Themes.Dark

    self.DialogOverlay.Visible = true
    U.tween(self.DialogOverlay, { BackgroundTransparency = 0.55 }, 0.2)

    local d = U.new("Frame", {
        Size = UDim2.fromOffset(340, 170),
        Position = UDim2.new(0.5, -170, 0.5, -85),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0, Parent = self.GUI,
    })
    U.corner(d, 12); U.stroke(d, theme.BorderLight, 1); U.shadow(d, theme.Shadow, 0.4)

    U.icon(d, cfg.Icon or Icons.Info, UDim2.fromOffset(20,20), theme.Accent, UDim2.fromOffset(20, 20))
    U.new("TextLabel", {
        Text = cfg.Title or "Dialog", Font = Enum.Font.GothamBold, TextSize = 14,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(50, 20), Size = UDim2.new(1, -60, 0, 22),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = d,
    })
    U.new("TextLabel", {
        Text = cfg.Content or "", Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = theme.SubText, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(20, 54), Size = UDim2.new(1, -40, 0, 60),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true, Parent = d,
    })

    local btnRow = U.new("Frame", {
        Size = UDim2.new(1, -40, 0, 32), Position = UDim2.new(0, 20, 1, -44),
        BackgroundTransparency = 1, Parent = d,
    })
    U.new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8), Parent = btnRow,
    })

    local function close()
        U.tween(d, { BackgroundTransparency = 1 }, 0.15)
        d:Destroy()
        self.DialogOverlay.Visible = false
        self.DialogOpen = false
    end

    for _, btn in ipairs(cfg.Buttons or {}) do
        local primary = btn.Primary ~= false
        local b = U.new("TextButton", {
            Text = btn.Title or "OK", Font = Enum.Font.GothamMedium, TextSize = 12,
            TextColor3 = primary and Color3.new(1,1,1) or theme.Text,
            BackgroundColor3 = primary and theme.Accent or theme.TertiaryBackground,
            BorderSizePixel = 0, Size = UDim2.fromOffset(88, 32), AutoButtonColor = false, Parent = btnRow,
        })
        U.corner(b, 6)
        b.MouseEnter:Connect(function() U.tween(b, { BackgroundColor3 = primary and theme.AccentHover or theme.SurfaceHover }, 0.15) end)
        b.MouseLeave:Connect(function() U.tween(b, { BackgroundColor3 = primary and theme.Accent or theme.TertiaryBackground }, 0.15) end)
        b.MouseButton1Click:Connect(function()
            if btn.Callback then task.spawn(btn.Callback) end
            close()
        end)
    end

    self.DialogOverlay.MouseButton1Click:Connect(function() close() end)
end

-- // Notifications
function Window:Notify(cfg)
    cfg = cfg or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local n = U.new("Frame", {
        Name = "Notification", Size = UDim2.new(1, 0, 0, cfg.SubContent and 78 or 64),
        BackgroundColor3 = theme.Surface, BorderSizePixel = 0,
        BackgroundTransparency = 1, Parent = self.NotifyContainer,
    })
    U.corner(n, 10); U.stroke(n, theme.BorderLight, 1); U.shadow(n, theme.Shadow, 0.4)

    local accentColor = cfg.Type == "Error" and theme.Error or cfg.Type == "Success" and theme.Success or cfg.Type == "Warning" and theme.Warning or theme.Accent
    local accentBar = U.new("Frame", {
        Size = UDim2.new(0, 3, 1, -16), Position = UDim2.fromOffset(0, 8),
        BackgroundColor3 = accentColor, BorderSizePixel = 0, Parent = n,
    })
    U.corner(accentBar, 2)

    local iconId = cfg.Icon or (cfg.Type == "Error" and Icons.Close or cfg.Type == "Success" and Icons.Check or Icons.Bell)
    U.icon(n, iconId, UDim2.fromOffset(16,16), accentColor, UDim2.fromOffset(16, 14))

    U.new("TextLabel", {
        Text = cfg.Title or "Notification", Font = Enum.Font.GothamBold, TextSize = 12,
        TextColor3 = theme.Text, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(42, 12), Size = UDim2.new(1, -52, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left, Parent = n,
    })
    U.new("TextLabel", {
        Text = cfg.Content or "", Font = Enum.Font.Gotham, TextSize = 11,
        TextColor3 = theme.SubText, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(42, 30), Size = UDim2.new(1, -52, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = n,
    })
    if cfg.SubContent then
        U.new("TextLabel", {
            Text = cfg.SubContent, Font = Enum.Font.Gotham, TextSize = 10,
            TextColor3 = theme.SubText, BackgroundTransparency = 1,
            Position = UDim2.fromOffset(42, 48), Size = UDim2.new(1, -52, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left, Parent = n,
        })
    end

    -- entrance
    n.Position = UDim2.new(0, 340, 0, 0)
    U.tween(n, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Quart)
    U.tween(n, { BackgroundTransparency = 0 }, 0.2)

    local dur = cfg.Duration or 5
    if dur > 0 then
        task.delay(dur, function()
            if n and n.Parent then
                U.tween(n, { Position = UDim2.new(0, 340, 0, 0), BackgroundTransparency = 1 }, 0.3)
                task.wait(0.3); n:Destroy()
            end
        end)
    end
end

-- // Theme & Visual toggles
function Window:SetTheme(name)
    local theme = Themes[name]
    if not theme then return end
    self.Theme = name; Fluent.Theme = name
    -- (Reapplying theme dynamically is complex; recommend recreating for full theme change)
    self.WindowFrame.BackgroundColor3 = theme.Background
    self.TitleBar.BackgroundColor3 = theme.SecondaryBackground
    self.TabContainer.BackgroundColor3 = theme.SecondaryBackground
    self.ContentContainer.BackgroundColor3 = theme.Background
    self.TitleLabel.TextColor3 = theme.Text
    if self.SubTitleLabel then self.SubTitleLabel.TextColor3 = theme.SubText end
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

-- // Save / Interface managers
local SaveManager = { }
SaveManager.__index = SaveManager
function SaveManager:SetLibrary(lib) self.Library = lib end

local function getConfigName(lib)
    if lib.Options.ConfigName then return lib.Options.ConfigName.Value end
    return "default"
end

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
    if ok and writefile then
        pcall(writefile, "FluentUI_"..getConfigName(self.Library)..".json", enc)
    end
end

function SaveManager:Load()
    if not readfile then return end
    local ok, content = pcall(readfile, "FluentUI_"..getConfigName(self.Library)..".json")
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
    if delfile then pcall(delfile, "FluentUI_"..getConfigName(self.Library)..".json") end
end

function SaveManager:BuildConfigSection(tab)
    tab:AddParagraph({ Title = "Configuration", Content = "Save and load your settings.", Icon = Icons.Save })
    tab:AddTextbox("ConfigName", { Title = "Config Name", Default = "default", Icon = Icons.Type })
    tab:AddButton({ Title = "Save Config", Icon = Icons.Save, Callback = function()
        self:Save()
        if self.Library.Window then self.Library.Window:Notify({ Title = "Saved", Content = "Configuration saved.", Type = "Success", Icon = Icons.Save }) end
    end })
    tab:AddButton({ Title = "Load Config", Icon = Icons.Upload, Callback = function()
        self:Load()
        if self.Library.Window then self.Library.Window:Notify({ Title = "Loaded", Content = "Configuration loaded.", Type = "Success", Icon = Icons.Upload }) end
    end })
    tab:AddButton({ Title = "Delete Config", Icon = Icons.Trash, Callback = function()
        self:Delete()
        if self.Library.Window then self.Library.Window:Notify({ Title = "Deleted", Content = "Configuration deleted.", Type = "Warning", Icon = Icons.Trash }) end
    end })
end

local InterfaceManager = {}
InterfaceManager.__index = InterfaceManager
function InterfaceManager:SetLibrary(lib) self.Library = lib end

function InterfaceManager:BuildInterfaceSection(tab)
    tab:AddParagraph({ Title = "Interface", Content = "Customize appearance.", Icon = Icons.Settings })
    tab:AddDropdown("ThemeSelector", {
        Title = "Theme", Icon = Icons.Palette,
        Values = { "Dark", "Light", "Midnight", "Amethyst", "Emerald", "Rose" },
        Default = "Dark",
        Callback = function(v) if self.Library.Window then self.Library.Window:SetTheme(v) end end,
    })
    tab:AddToggle("AcrylicToggle", { Title = "Acrylic Blur", Icon = Icons.Eye, Default = true,
        Callback = function(v) if self.Library.Window then self.Library.Window:ToggleAcrylic(v) end end })
    tab:AddKeybind("ToggleKeybind", { Title = "Toggle UI Keybind", Icon = Icons.Keyboard, Default = Enum.KeyCode.RightShift })
    tab:AddButton({ Title = "Destroy Interface", Icon = Icons.Trash, Callback = function()
        if self.Library.Window then self.Library.Window:Destroy() end
    end })
end

Fluent.SaveManager = SaveManager
Fluent.InterfaceManager = InterfaceManager

return Fluent
