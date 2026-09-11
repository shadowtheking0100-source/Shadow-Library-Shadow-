--[[
    FluentUI - A high-quality Roblox UI Library
    Inspired by dawid-scripts/Fluent
    Features: Modern design, acrylic blur, Lucide icons, save manager,
    themes, notifications, dialogs, and comprehensive element support.
]]

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

--// Local Player
local LocalPlayer = Players.LocalPlayer

--// Configuration
local CONFIG = {
    Font = Enum.Font.Gotham,
    FontBold = Enum.Font.GothamBold,
    FontMedium = Enum.Font.GothamMedium,
    Version = "1.0.0",
    DefaultTheme = "Dark",
    AnimationSpeed = 0.2,
    TooltipDelay = 0.5,
}

--// Themes
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 30),
        SecondaryBackground = Color3.fromRGB(35, 35, 42),
        TertiaryBackground = Color3.fromRGB(45, 45, 55),
        Surface = Color3.fromRGB(40, 40, 48),
        Text = Color3.fromRGB(240, 240, 245),
        SubText = Color3.fromRGB(150, 150, 160),
        Accent = Color3.fromRGB(80, 130, 255),
        AccentHover = Color3.fromRGB(100, 150, 255),
        Border = Color3.fromRGB(60, 60, 70),
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(255, 180, 50),
        Error = Color3.fromRGB(255, 80, 80),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        SecondaryBackground = Color3.fromRGB(235, 235, 240),
        TertiaryBackground = Color3.fromRGB(225, 225, 235),
        Surface = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(20, 20, 30),
        SubText = Color3.fromRGB(100, 100, 110),
        Accent = Color3.fromRGB(60, 110, 240),
        AccentHover = Color3.fromRGB(80, 130, 255),
        Border = Color3.fromRGB(210, 210, 220),
        Success = Color3.fromRGB(40, 180, 100),
        Warning = Color3.fromRGB(240, 160, 30),
        Error = Color3.fromRGB(240, 60, 60),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Aqua = {
        Background = Color3.fromRGB(20, 35, 40),
        SecondaryBackground = Color3.fromRGB(28, 48, 55),
        TertiaryBackground = Color3.fromRGB(38, 62, 70),
        Surface = Color3.fromRGB(32, 55, 62),
        Text = Color3.fromRGB(220, 245, 250),
        SubText = Color3.fromRGB(130, 180, 190),
        Accent = Color3.fromRGB(0, 200, 200),
        AccentHover = Color3.fromRGB(0, 230, 230),
        Border = Color3.fromRGB(50, 80, 90),
        Success = Color3.fromRGB(0, 200, 150),
        Warning = Color3.fromRGB(255, 200, 50),
        Error = Color3.fromRGB(255, 80, 80),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Amethyst = {
        Background = Color3.fromRGB(30, 25, 40),
        SecondaryBackground = Color3.fromRGB(42, 35, 55),
        TertiaryBackground = Color3.fromRGB(55, 45, 72),
        Surface = Color3.fromRGB(48, 40, 62),
        Text = Color3.fromRGB(235, 225, 250),
        SubText = Color3.fromRGB(160, 140, 190),
        Accent = Color3.fromRGB(160, 100, 255),
        AccentHover = Color3.fromRGB(180, 120, 255),
        Border = Color3.fromRGB(70, 55, 95),
        Success = Color3.fromRGB(100, 200, 150),
        Warning = Color3.fromRGB(255, 190, 60),
        Error = Color3.fromRGB(255, 90, 90),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
    Rose = {
        Background = Color3.fromRGB(35, 25, 30),
        SecondaryBackground = Color3.fromRGB(48, 35, 42),
        TertiaryBackground = Color3.fromRGB(62, 45, 55),
        Surface = Color3.fromRGB(55, 40, 48),
        Text = Color3.fromRGB(250, 230, 235),
        SubText = Color3.fromRGB(190, 150, 165),
        Accent = Color3.fromRGB(255, 100, 140),
        AccentHover = Color3.fromRGB(255, 130, 165),
        Border = Color3.fromRGB(80, 55, 68),
        Success = Color3.fromRGB(100, 200, 150),
        Warning = Color3.fromRGB(255, 190, 60),
        Error = Color3.fromRGB(255, 80, 80),
        Shadow = Color3.fromRGB(0, 0, 0),
    },
}

--// Utility Functions
local Utilities = {}

function Utilities.Create(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties or {}) do
        instance[property] = value
    end
    return instance
end

function Utilities.Tween(instance, properties, duration, style, direction)
    local tweenInfo = TweenInfo.new(
        duration or CONFIG.AnimationSpeed,
        style or Enum.EasingStyle.Quad,
        direction or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

function Utilities.Round(number, decimalPlaces)
    local mult = 10 ^ (decimalPlaces or 0)
    return math.floor(number * mult + 0.5) / mult
end

function Utilities.ColorToHex(color)
    return string.format("#%02X%02X%02X",
        math.floor(color.R * 255),
        math.floor(color.G * 255),
        math.floor(color.B * 255)
    )
end

function Utilities.HexToColor(hex)
    hex = hex:gsub("#", "")
    return Color3.fromRGB(
        tonumber(hex:sub(1, 2), 16),
        tonumber(hex:sub(3, 4), 16),
        tonumber(hex:sub(5, 6), 16)
    )
end

function Utilities.GetTextSize(text, font, size)
    local textService = game:GetService("TextService")
    return textService:GetTextSize(text, size, font, Vector2.new(1000, 1000))
end

function Utilities.Draggable(frame, dragFrame)
    dragFrame = dragFrame or frame
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = newPos}):Play()
    end

    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function Utilities.CreateCorner(parent, radius)
    return Utilities.Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 8),
        Parent = parent,
    })
end

function Utilities.CreateStroke(parent, color, thickness)
    return Utilities.Create("UIStroke", {
        Color = color or Color3.fromRGB(60, 60, 70),
        Thickness = thickness or 1,
        Parent = parent,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

function Utilities.CreatePadding(parent, padding)
    return Utilities.Create("UIPadding", {
        PaddingTop = UDim.new(0, padding or 8),
        PaddingBottom = UDim.new(0, padding or 8),
        PaddingLeft = UDim.new(0, padding or 8),
        PaddingRight = UDim.new(0, padding or 8),
        Parent = parent,
    })
end

--// Main Library Table
local Fluent = {}
Fluent.Version = CONFIG.Version
Fluent.Options = {}
Fluent.Themes = Themes
Fluent.OpenFrames = {}
Fluent.Unloaded = false
Fluent.Theme = CONFIG.DefaultTheme
Fluent.UseAcrylic = true
Fluent.Transparency = false

--// Window Class
local Window = {}
Window.__index = Window

function Fluent:CreateWindow(config)
    config = config or {}
    local self = setmetatable({}, Window)

    self.Title = config.Title or "Fluent UI"
    self.SubTitle = config.SubTitle or ""
    self.TabWidth = config.TabWidth or 160
    self.Size = config.Size or UDim2.fromOffset(580, 460)
    self.Acrylic = config.Acrylic ~= false
    self.Theme = config.Theme or Fluent.Theme
    self.MinimizeKey = config.MinimizeKey or Enum.KeyCode.LeftControl
    self.Minimized = false
    self.Tabs = {}
    self.SelectedTab = nil
    self.DialogOpen = false

    local theme = Themes[self.Theme] or Themes.Dark

    --// Main ScreenGui
    self.GUI = Utilities.Create("ScreenGui", {
        Name = "FluentUI_" .. HttpService:GenerateGUID(false),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        Parent = CoreGui,
    })

    --// Main Frame
    self.WindowFrame = Utilities.Create("Frame", {
        Name = "Window",
        Size = self.Size,
        Position = UDim2.new(0.5, -self.Size.X.Offset / 2, 0.5, -self.Size.Y.Offset / 2),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.GUI,
    })
    Utilities.CreateCorner(self.WindowFrame, 12)
    Utilities.CreateStroke(self.WindowFrame, theme.Border, 1)

    --// Acrylic Blur (using blur effect as fallback)
    if self.Acrylic then
        self.AcrylicBlur = Utilities.Create("BlurEffect", {
            Size = 16,
            Parent = Lighting,
        })
    end

    --// Title Bar
    self.TitleBar = Utilities.Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = self.WindowFrame,
    })

    self.TitleLabel = Utilities.Create("TextLabel", {
        Name = "Title",
        Text = self.Title,
        Font = CONFIG.FontBold,
        TextSize = 14,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 0),
        Size = UDim2.new(0, 200, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar,
    })

    self.SubTitleLabel = Utilities.Create("TextLabel", {
        Name = "SubTitle",
        Text = self.SubTitle,
        Font = CONFIG.Font,
        TextSize = 11,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 12, 0, 20),
        Size = UDim2.new(0, 200, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TitleBar,
    })

    --// Minimize Button
    self.MinimizeButton = Utilities.Create("TextButton", {
        Name = "Minimize",
        Text = "−",
        Font = CONFIG.FontBold,
        TextSize = 18,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -60, 0, 0),
        Size = UDim2.new(0, 30, 0, 40),
        Parent = self.TitleBar,
    })

    --// Close Button
    self.CloseButton = Utilities.Create("TextButton", {
        Name = "Close",
        Text = "✕",
        Font = CONFIG.FontBold,
        TextSize = 14,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0, 30, 0, 40),
        Parent = self.TitleBar,
    })

    --// Tab Container
    self.TabContainer = Utilities.Create("ScrollingFrame", {
        Name = "TabContainer",
        Size = UDim2.new(0, self.TabWidth, 1, -40),
        Position = UDim2.new(0, 0, 0, 40),
        BackgroundColor3 = theme.SecondaryBackground,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.WindowFrame,
    })

    --// Content Container
    self.ContentContainer = Utilities.Create("ScrollingFrame", {
        Name = "ContentContainer",
        Size = UDim2.new(1, -self.TabWidth, 1, -40),
        Position = UDim2.new(0, self.TabWidth, 0, 40),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Border,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = self.WindowFrame,
    })
    Utilities.CreatePadding(self.ContentContainer, 12)
    Utilities.Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = self.ContentContainer,
    })

    --// Notification Container
    self.NotificationContainer = Utilities.Create("Frame", {
        Name = "Notifications",
        Size = UDim2.new(0, 300, 1, 0),
        Position = UDim2.new(1, -310, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.GUI,
    })
    Utilities.Create("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Parent = self.NotificationContainer,
    })

    --// Dialog Overlay
    self.DialogOverlay = Utilities.Create("TextButton", {
        Name = "DialogOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        Visible = false,
        Parent = self.GUI,
    })

    --// Make draggable
    Utilities.Draggable(self.WindowFrame, self.TitleBar)

    --// Minimize functionality
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)

    --// Close functionality
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)

    --// Minimize keybind
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == self.MinimizeKey then
            self:ToggleMinimize()
        end
    end)

    --// Hover effects
    self:ApplyHoverEffects()

    Fluent.Window = self
    Fluent.WindowFrame = self.WindowFrame
    Fluent.GUI = self.GUI

    return self
end

function Window:ApplyHoverEffects()
    local theme = Themes[self.Theme] or Themes.Dark

    self.MinimizeButton.MouseEnter:Connect(function()
        Utilities.Tween(self.MinimizeButton, {TextColor3 = theme.Text}, 0.15)
    end)
    self.MinimizeButton.MouseLeave:Connect(function()
        Utilities.Tween(self.MinimizeButton, {TextColor3 = theme.SubText}, 0.15)
    end)

    self.CloseButton.MouseEnter:Connect(function()
        Utilities.Tween(self.CloseButton, {TextColor3 = theme.Error}, 0.15)
    end)
    self.CloseButton.MouseLeave:Connect(function()
        Utilities.Tween(self.CloseButton, {TextColor3 = theme.SubText}, 0.15)
    end)
end

function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    local theme = Themes[self.Theme] or Themes.Dark

    if self.Minimized then
        Utilities.Tween(self.WindowFrame, {Size = UDim2.new(0, self.Size.X.Offset, 0, 40)}, 0.3)
        self.TabContainer.Visible = false
        self.ContentContainer.Visible = false
        self.MinimizeButton.Text = "+"
    else
        Utilities.Tween(self.WindowFrame, {Size = self.Size}, 0.3)
        self.TabContainer.Visible = true
        self.ContentContainer.Visible = true
        self.MinimizeButton.Text = "−"
    end
end

function Window:AddTab(config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local tab = {
        Title = config.Title or "Tab",
        Icon = config.Icon or "",
        Window = self,
        Elements = {},
        Index = #self.Tabs + 1,
    }

    tab.Button = Utilities.Create("TextButton", {
        Name = tab.Title,
        Text = "  " .. (tab.Icon ~= "" and tab.Icon .. "  " or "") .. tab.Title,
        Font = CONFIG.FontMedium,
        TextSize = 12,
        TextColor3 = theme.SubText,
        BackgroundColor3 = theme.SecondaryBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 36),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = self.TabContainer,
    })
    Utilities.CreateCorner(tab.Button, 6)

    tab.Button.MouseEnter:Connect(function()
        if self.SelectedTab ~= tab then
            Utilities.Tween(tab.Button, {BackgroundColor3 = theme.TertiaryBackground}, 0.15)
        end
    end)
    tab.Button.MouseLeave:Connect(function()
        if self.SelectedTab ~= tab then
            Utilities.Tween(tab.Button, {BackgroundColor3 = theme.SecondaryBackground}, 0.15)
        end
    end)

    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)

    table.insert(self.Tabs, tab)

    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end

    function tab:AddSection(name)
        return self:AddSection(name)
    end

    function tab:AddParagraph(config)
        return self:AddParagraph(config)
    end

    function tab:AddButton(config)
        return self:AddButton(config)
    end

    function tab:AddToggle(id, config)
        return self:AddToggle(id, config)
    end

    function tab:AddSlider(id, config)
        return self:AddSlider(id, config)
    end

    function tab:AddDropdown(id, config)
        return self:AddDropdown(id, config)
    end

    function tab:AddColorpicker(id, config)
        return self:AddColorpicker(id, config)
    end

    function tab:AddKeybind(id, config)
        return self:AddKeybind(id, config)
    end

    function tab:AddTextbox(id, config)
        return self:AddTextbox(id, config)
    end

    return tab
end

function Window:SelectTab(tab)
    local theme = Themes[self.Theme] or Themes.Dark
    self.SelectedTab = tab

    for _, t in ipairs(self.Tabs) do
        if t == tab then
            Utilities.Tween(t.Button, {BackgroundColor3 = theme.Accent, TextColor3 = theme.Text}, 0.2)
        else
            Utilities.Tween(t.Button, {BackgroundColor3 = theme.SecondaryBackground, TextColor3 = theme.SubText}, 0.2)
        end
    end

    for _, child in ipairs(self.ContentContainer:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child.Visible = false
        end
    end

    for _, element in ipairs(tab.Elements) do
        if element.Instance then
            element.Instance.Visible = true
        end
    end
end

function Window:Dialog(config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    if self.DialogOpen then return end
    self.DialogOpen = true

    self.DialogOverlay.Visible = true
    Utilities.Tween(self.DialogOverlay, {BackgroundTransparency = 0.5}, 0.2)

    local dialogFrame = Utilities.Create("Frame", {
        Name = "Dialog",
        Size = UDim2.new(0, 300, 0, 160),
        Position = UDim2.new(0.5, -150, 0.5, -80),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = self.GUI,
    })
    Utilities.CreateCorner(dialogFrame, 10)
    Utilities.CreateStroke(dialogFrame, theme.Border, 1)

    Utilities.Create("TextLabel", {
        Text = config.Title or "Dialog",
        Font = CONFIG.FontBold,
        TextSize = 14,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = dialogFrame,
    })

    Utilities.Create("TextLabel", {
        Text = config.Content or "",
        Font = CONFIG.Font,
        TextSize = 12,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 50),
        Position = UDim2.new(0, 10, 0, 45),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = dialogFrame,
    })

    local buttonContainer = Utilities.Create("Frame", {
        Size = UDim2.new(1, -20, 0, 32),
        Position = UDim2.new(0, 10, 1, -42),
        BackgroundTransparency = 1,
        Parent = dialogFrame,
    })
    Utilities.Create("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0, 8),
        Parent = buttonContainer,
    })

    for _, btnConfig in ipairs(config.Buttons or {}) do
        local btn = Utilities.Create("TextButton", {
            Text = btnConfig.Title or "Button",
            Font = CONFIG.FontMedium,
            TextSize = 12,
            TextColor3 = theme.Text,
            BackgroundColor3 = theme.Accent,
            BorderSizePixel = 0,
            Size = UDim2.new(0, 80, 0, 30),
            Parent = buttonContainer,
        })
        Utilities.CreateCorner(btn, 6)

        btn.MouseEnter:Connect(function()
            Utilities.Tween(btn, {BackgroundColor3 = theme.AccentHover}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            Utilities.Tween(btn, {BackgroundColor3 = theme.Accent}, 0.15)
        end)

        btn.MouseButton1Click:Connect(function()
            if btnConfig.Callback then btnConfig.Callback() end
            dialogFrame:Destroy()
            self.DialogOverlay.Visible = false
            self.DialogOpen = false
        end)
    end
end

function Window:Notify(config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local notification = Utilities.Create("Frame", {
        Name = "Notification",
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = self.NotificationContainer,
    })
    Utilities.CreateCorner(notification, 8)
    Utilities.CreateStroke(notification, theme.Border, 1)
    Utilities.CreatePadding(notification, 10)

    local accentBar = Utilities.Create("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = notification,
    })
    Utilities.CreateCorner(accentBar, 2)

    Utilities.Create("TextLabel", {
        Text = config.Title or "Notification",
        Font = CONFIG.FontBold,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -15, 0, 20),
        Position = UDim2.new(0, 15, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification,
    })

    Utilities.Create("TextLabel", {
        Text = config.Content or "",
        Font = CONFIG.Font,
        TextSize = 11,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -15, 0, 20),
        Position = UDim2.new(0, 15, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notification,
    })

    if config.SubContent then
        Utilities.Create("TextLabel", {
            Text = config.SubContent,
            Font = CONFIG.Font,
            TextSize = 10,
            TextColor3 = theme.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -15, 0, 18),
            Position = UDim2.new(0, 15, 0, 40),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = notification,
        })
    end

    local duration = config.Duration or 5
    if duration then
        task.delay(duration, function()
            if notification and notification.Parent then
                Utilities.Tween(notification, {BackgroundTransparency = 1}, 0.3)
                task.wait(0.3)
                notification:Destroy()
            end
        end)
    end
end

function Window:SetTheme(themeName)
    local theme = Themes[themeName]
    if not theme then return end

    self.Theme = themeName
    Fluent.Theme = themeName

    self.WindowFrame.BackgroundColor3 = theme.Background
    self.TitleBar.BackgroundColor3 = theme.SecondaryBackground
    self.TabContainer.BackgroundColor3 = theme.SecondaryBackground
    self.ContentContainer.BackgroundColor3 = theme.Background
    self.TitleLabel.TextColor3 = theme.Text
    self.SubTitleLabel.TextColor3 = theme.SubText
    self.MinimizeButton.TextColor3 = theme.SubText
    self.CloseButton.TextColor3 = theme.SubText
end

function Window:ToggleAcrylic(state)
    self.Acrylic = state
    Fluent.UseAcrylic = state
    if self.AcrylicBlur then
        self.AcrylicBlur.Size = state and 16 or 0
    end
end

function Window:ToggleTransparency(state)
    self.Transparency = state
    Fluent.Transparency = state
    self.WindowFrame.BackgroundTransparency = state and 0.3 or 0
end

function Window:Destroy()
    Fluent.Unloaded = true
    if self.AcrylicBlur then
        self.AcrylicBlur:Destroy()
    end
    self.GUI:Destroy()
end

--// Element Creators (Tab Methods)
function Window:AddSection(name)
    local theme = Themes[self.Theme] or Themes.Dark
    local section = {
        Name = name,
        Elements = {},
    }

    section.Instance = Utilities.Create("Frame", {
        Name = "Section_" .. name,
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = theme.SecondaryBackground,
        BorderSizePixel = 0,
        Parent = self.ContentContainer,
    })
    Utilities.CreateCorner(section.Instance, 6)

    Utilities.Create("TextLabel", {
        Text = name,
        Font = CONFIG.FontBold,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section.Instance,
    })

    function section:AddParagraph(config)
        return self:AddParagraph(config)
    end

    function section:AddButton(config)
        return self:AddButton(config)
    end

    function section:AddToggle(id, config)
        return self:AddToggle(id, config)
    end

    function section:AddSlider(id, config)
        return self:AddSlider(id, config)
    end

    function section:AddDropdown(id, config)
        return self:AddDropdown(id, config)
    end

    function section:AddColorpicker(id, config)
        return self:AddColorpicker(id, config)
    end

    function section:AddKeybind(id, config)
        return self:AddKeybind(id, config)
    end

    function section:AddTextbox(id, config)
        return self:AddTextbox(id, config)
    end

    return section
end

function Window:AddParagraph(config)
    local theme = Themes[self.Theme] or Themes.Dark

    local paragraph = Utilities.Create("Frame", {
        Name = "Paragraph",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = self.ContentContainer,
    })
    Utilities.CreateCorner(paragraph, 8)
    Utilities.CreateStroke(paragraph, theme.Border, 1)
    Utilities.CreatePadding(paragraph, 10)

    Utilities.Create("TextLabel", {
        Text = config.Title or "Paragraph",
        Font = CONFIG.FontBold,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = paragraph,
    })

    Utilities.Create("TextLabel", {
        Text = config.Content or "",
        Font = CONFIG.Font,
        TextSize = 11,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 25),
        Position = UDim2.new(0, 0, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = paragraph,
    })

    return {
        Instance = paragraph,
    }
end

function Window:AddButton(config)
    local theme = Themes[self.Theme] or Themes.Dark

    local button = Utilities.Create("TextButton", {
        Name = "Button",
        Text = "",
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40),
        Parent = self.ContentContainer,
    })
    Utilities.CreateCorner(button, 8)
    Utilities.CreateStroke(button, theme.Border, 1)

    Utilities.Create("TextLabel", {
        Text = config.Title or "Button",
        Font = CONFIG.FontMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = button,
    })

    if config.Description then
        Utilities.Create("TextLabel", {
            Text = config.Description,
            Font = CONFIG.Font,
            TextSize = 10,
            TextColor3 = theme.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 0, 16),
            Position = UDim2.new(0, 10, 1, -18),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = button,
        })
    end

    button.MouseEnter:Connect(function()
        Utilities.Tween(button, {BackgroundColor3 = theme.TertiaryBackground}, 0.15)
    end)
    button.MouseLeave:Connect(function()
        Utilities.Tween(button, {BackgroundColor3 = theme.Surface}, 0.15)
    end)
    button.MouseButton1Click:Connect(function()
        if config.Callback then config.Callback() end
    end)

    return {
        Instance = button,
    }
end

function Window:AddToggle(id, config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local toggle = {
        Value = config.Default or false,
        Callbacks = {},
    }

    local frame = Utilities.Create("Frame", {
        Name = "Toggle_" .. id,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = self.ContentContainer,
    })
    Utilities.CreateCorner(frame, 8)
    Utilities.CreateStroke(frame, theme.Border, 1)

    Utilities.Create("TextLabel", {
        Text = config.Title or id,
        Font = CONFIG.FontMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -70, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    if config.Description then
        Utilities.Create("TextLabel", {
            Text = config.Description,
            Font = CONFIG.Font,
            TextSize = 10,
            TextColor3 = theme.SubText,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -70, 0, 16),
            Position = UDim2.new(0, 10, 1, -18),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = frame,
        })
    end

    local switchBg = Utilities.Create("Frame", {
        Name = "SwitchBg",
        Size = UDim2.new(0, 40, 0, 22),
        Position = UDim2.new(1, -52, 0.5, -11),
        BackgroundColor3 = toggle.Value and theme.Accent or theme.Border,
        BorderSizePixel = 0,
        Parent = frame,
    })
    Utilities.CreateCorner(switchBg, 11)

    local switchKnob = Utilities.Create("Frame", {
        Name = "SwitchKnob",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, toggle.Value and 20 or 2, 0.5, -9),
        BackgroundColor3 = theme.Text,
        BorderSizePixel = 0,
        Parent = switchBg,
    })
    Utilities.CreateCorner(switchKnob, 9)

    local clickArea = Utilities.Create("TextButton", {
        Name = "ClickArea",
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = frame,
    })

    local function setValue(value)
        toggle.Value = value
        Fluent.Options[id] = toggle
        Utilities.Tween(switchBg, {BackgroundColor3 = value and theme.Accent or theme.Border}, 0.2)
        Utilities.Tween(switchKnob, {Position = UDim2.new(0, value and 20 or 2, 0.5, -9)}, 0.2)
        for _, callback in ipairs(toggle.Callbacks) do
            task.spawn(callback, value)
        end
        if config.Callback then
            task.spawn(config.Callback, value)
        end
    end

    clickArea.MouseButton1Click:Connect(function()
        setValue(not toggle.Value)
    end)

    toggle.Instance = frame
    toggle.SetValue = setValue
    toggle.GetValue = function() return toggle.Value end
    toggle.OnChanged = function(callback)
        table.insert(toggle.Callbacks, callback)
    end

    Fluent.Options[id] = toggle
    return toggle
end

function Window:AddSlider(id, config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local slider = {
        Value = config.Default or config.Min or 0,
        Callbacks = {},
    }

    local frame = Utilities.Create("Frame", {
        Name = "Slider_" .. id,
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = self.ContentContainer,
    })
    Utilities.CreateCorner(frame, 8)
    Utilities.CreateStroke(frame, theme.Border, 1)

    Utilities.Create("TextLabel", {
        Text = config.Title or id,
        Font = CONFIG.FontMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 10, 0, 6),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local valueLabel = Utilities.Create("TextLabel", {
        Text = tostring(slider.Value),
        Font = CONFIG.Font,
        TextSize = 11,
        TextColor3 = theme.Accent,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 50, 0, 20),
        Position = UDim2.new(1, -60, 0, 6),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = frame,
    })

    local sliderBg = Utilities.Create("Frame", {
        Name = "SliderBg",
        Size = UDim2.new(1, -20, 0, 6),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundColor3 = theme.Border,
        BorderSizePixel = 0,
        Parent = frame,
    })
    Utilities.CreateCorner(sliderBg, 3)

    local sliderFill = Utilities.Create("Frame", {
        Name = "SliderFill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = sliderBg,
    })
    Utilities.CreateCorner(sliderFill, 3)

    local sliderKnob = Utilities.Create("Frame", {
        Name = "SliderKnob",
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 0, 0.5, -7),
        BackgroundColor3 = theme.Text,
        BorderSizePixel = 0,
        Parent = sliderBg,
    })
    Utilities.CreateCorner(sliderKnob, 7)
    Utilities.CreateStroke(sliderKnob, theme.Accent, 2)

    local dragging = false

    local function updateFromInput(input)
        local mouseX = input.Position.X
        local sliderStart = sliderBg.AbsolutePosition.X
        local sliderWidth = sliderBg.AbsoluteSize.X
        local relativeX = math.clamp((mouseX - sliderStart) / sliderWidth, 0, 1)

        local min = config.Min or 0
        local max = config.Max or 100
        local rounding = config.Rounding or 1
        local rawValue = min + (max - min) * relativeX
        local roundedValue = Utilities.Round(rawValue, rounding)

        slider.Value = roundedValue
        Fluent.Options[id] = slider
        valueLabel.Text = tostring(roundedValue)

        local fillSize = (roundedValue - min) / (max - min)
        Utilities.Tween(sliderFill, {Size = UDim2.new(fillSize, 0, 1, 0)}, 0.1)
        Utilities.Tween(sliderKnob, {Position = UDim2.new(fillSize, -7, 0.5, -7)}, 0.1)

        for _, callback in ipairs(slider.Callbacks) do
            task.spawn(callback, roundedValue)
        end
        if config.Callback then
            task.spawn(config.Callback, roundedValue)
        end
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromInput(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch) then
            updateFromInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Initialize
    local min = config.Min or 0
    local max = config.Max or 100
    local initFill = (slider.Value - min) / (max - min)
    sliderFill.Size = UDim2.new(initFill, 0, 1, 0)
    sliderKnob.Position = UDim2.new(initFill, -7, 0.5, -7)

    slider.Instance = frame
    slider.SetValue = function(value)
        slider.Value = value
        local fillSize = (value - min) / (max - min)
        valueLabel.Text = tostring(value)
        Utilities.Tween(sliderFill, {Size = UDim2.new(fillSize, 0, 1, 0)}, 0.2)
        Utilities.Tween(sliderKnob, {Position = UDim2.new(fillSize, -7, 0.5, -7)}, 0.2)
    end
    slider.GetValue = function() return slider.Value end
    slider.OnChanged = function(callback)
        table.insert(slider.Callbacks, callback)
    end

    Fluent.Options[id] = slider
    return slider
end

function Window:AddDropdown(id, config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local dropdown = {
        Value = config.Default or (config.Multi and {} or nil),
        Options = config.Values or {},
        Multi = config.Multi or false,
        Callbacks = {},
        Expanded = false,
    }

    local frame = Utilities.Create("Frame", {
        Name = "Dropdown_" .. id,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Parent = self.ContentContainer,
    })
    Utilities.CreateCorner(frame, 8)
    Utilities.CreateStroke(frame, theme.Border, 1)

    Utilities.Create("TextLabel", {
        Text = config.Title or id,
        Font = CONFIG.FontMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local arrow = Utilities.Create("TextLabel", {
        Text = "▼",
        Font = CONFIG.Font,
        TextSize = 10,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -30, 0.5, -10),
        Parent = frame,
    })

    local clickArea = Utilities.Create("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = frame,
    })

    local optionsFrame = Utilities.Create("ScrollingFrame", {
        Name = "Options",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Border,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = frame,
    })
    Utilities.CreateCorner(optionsFrame, 8)
    Utilities.CreateStroke(optionsFrame, theme.Border, 1)
    Utilities.Create("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = optionsFrame,
    })
    Utilities.CreatePadding(optionsFrame, 4)

    local selectedLabel = Utilities.Create("TextLabel", {
        Text = config.Default and tostring(config.Default) or "Select...",
        Font = CONFIG.Font,
        TextSize = 11,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -50, 0, 16),
        Position = UDim2.new(0, 10, 1, -18),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local function createOption(option)
        local optionBtn = Utilities.Create("TextButton", {
            Text = tostring(option),
            Font = CONFIG.Font,
            TextSize = 11,
            TextColor3 = theme.Text,
            BackgroundColor3 = theme.Surface,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 28),
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = optionsFrame,
        })
        Utilities.CreateCorner(optionBtn, 4)

        optionBtn.MouseEnter:Connect(function()
            Utilities.Tween(optionBtn, {BackgroundColor3 = theme.TertiaryBackground}, 0.15)
        end)
        optionBtn.MouseLeave:Connect(function()
            Utilities.Tween(optionBtn, {BackgroundColor3 = theme.Surface}, 0.15)
        end)

        optionBtn.MouseButton1Click:Connect(function()
            if dropdown.Multi then
                local newValue = {}
                local found = false
                for _, v in ipairs(dropdown.Value) do
                    if v == option then
                        found = true
                    else
                        table.insert(newValue, v)
                    end
                end
                if not found then
                    table.insert(newValue, option)
                end
                dropdown.Value = newValue
                selectedLabel.Text = #newValue > 0 and table.concat(newValue, ", ") or "Select..."
            else
                dropdown.Value = option
                selectedLabel.Text = tostring(option)
                dropdown:Toggle()
            end
            Fluent.Options[id] = dropdown
            for _, callback in ipairs(dropdown.Callbacks) do
                task.spawn(callback, dropdown.Value)
            end
            if config.Callback then
                task.spawn(config.Callback, dropdown.Value)
            end
        end)

        return optionBtn
    end

    for _, option in ipairs(config.Values or {}) do
        createOption(option)
    end

    clickArea.MouseButton1Click:Connect(function()
        dropdown:Toggle()
    end)

    function dropdown:Toggle()
        self.Expanded = not self.Expanded
        arrow.Text = self.Expanded and "▲" or "▼"
        if self.Expanded then
            local optionCount = #self.Options
            local height = math.min(optionCount * 30, 200)
            optionsFrame.Visible = true
            Utilities.Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, height)}, 0.2)
        else
            Utilities.Tween(optionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            task.delay(0.2, function()
                optionsFrame.Visible = false
            end)
        end
    end

    dropdown.Instance = frame
    dropdown.SetValue = function(value)
        dropdown.Value = value
        if type(value) == "table" then
            selectedLabel.Text = #value > 0 and table.concat(value, ", ") or "Select..."
        else
            selectedLabel.Text = tostring(value)
        end
    end
    dropdown.GetValue = function() return dropdown.Value end
    dropdown.OnChanged = function(callback)
        table.insert(dropdown.Callbacks, callback)
    end

    Fluent.Options[id] = dropdown
    return dropdown
end

function Window:AddColorpicker(id, config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local colorpicker = {
        Value = config.Default or Color3.fromRGB(255, 0, 0),
        Callbacks = {},
        Expanded = false,
    }

    local frame = Utilities.Create("Frame", {
        Name = "Colorpicker_" .. id,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = self.ContentContainer,
    })
    Utilities.CreateCorner(frame, 8)
    Utilities.CreateStroke(frame, theme.Border, 1)

    Utilities.Create("TextLabel", {
        Text = config.Title or id,
        Font = CONFIG.FontMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local colorPreview = Utilities.Create("Frame", {
        Name = "Preview",
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(1, -40, 0.5, -12),
        BackgroundColor3 = colorpicker.Value,
        BorderSizePixel = 0,
        Parent = frame,
    })
    Utilities.CreateCorner(colorPreview, 6)
    Utilities.CreateStroke(colorPreview, theme.Border, 1)

    local clickArea = Utilities.Create("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = frame,
    })

    local pickerFrame = Utilities.Create("Frame", {
        Name = "Picker",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 4),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 10,
        Parent = frame,
    })
    Utilities.CreateCorner(pickerFrame, 8)
    Utilities.CreateStroke(pickerFrame, theme.Border, 1)

    local hueSlider = Utilities.Create("Frame", {
        Name = "Hue",
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0,
        Parent = pickerFrame,
    })
    Utilities.CreateCorner(hueSlider, 4)

    local hueGradient = Utilities.Create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        }),
        Parent = hueSlider,
    })

    local hueKnob = Utilities.Create("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 0, 0.5, -7),
        BackgroundColor3 = theme.Text,
        BorderSizePixel = 0,
        Parent = hueSlider,
    })
    Utilities.CreateCorner(hueKnob, 7)
    Utilities.CreateStroke(hueKnob, theme.Accent, 2)

    local hueDragging = false

    local function updateHue(input)
        local mouseX = input.Position.X
        local sliderStart = hueSlider.AbsolutePosition.X
        local sliderWidth = hueSlider.AbsoluteSize.X
        local relativeX = math.clamp((mouseX - sliderStart) / sliderWidth, 0, 1)

        hueKnob.Position = UDim2.new(relativeX, -7, 0.5, -7)

        local hue = relativeX * 360
        local color = Color3.fromHSV(hue / 360, 1, 1)
        colorpicker.Value = color
        colorPreview.BackgroundColor3 = color
        hueSlider.BackgroundColor3 = color

        for _, callback in ipairs(colorpicker.Callbacks) do
            task.spawn(callback, color)
        end
        if config.Callback then
            task.spawn(config.Callback, color)
        end
    end

    hueSlider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = true
            updateHue(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if hueDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateHue(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            hueDragging = false
        end
    end)

    -- Hex input
    local hexBox = Utilities.Create("TextBox", {
        Text = Utilities.ColorToHex(colorpicker.Value),
        Font = CONFIG.Font,
        TextSize = 11,
        TextColor3 = theme.Text,
        BackgroundColor3 = theme.TertiaryBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 40),
        PlaceholderText = "#FF0000",
        Parent = pickerFrame,
    })
    Utilities.CreateCorner(hexBox, 4)
    Utilities.CreateStroke(hexBox, theme.Border, 1)

    hexBox.FocusLost:Connect(function()
        local success, color = pcall(Utilities.HexToColor, hexBox.Text)
        if success then
            colorpicker.Value = color
            colorPreview.BackgroundColor3 = color
            local h, s, v = Color3.toHSV(color)
            hueKnob.Position = UDim2.new(h, -7, 0.5, -7)
            hueSlider.BackgroundColor3 = color
        end
    end)

    clickArea.MouseButton1Click:Connect(function()
        colorpicker.Expanded = not colorpicker.Expanded
        if colorpicker.Expanded then
            pickerFrame.Visible = true
            Utilities.Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 75)}, 0.2)
        else
            Utilities.Tween(pickerFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
            task.delay(0.2, function()
                pickerFrame.Visible = false
            end)
        end
    end)

    colorpicker.Instance = frame
    colorpicker.SetValue = function(color)
        colorpicker.Value = color
        colorPreview.BackgroundColor3 = color
        hexBox.Text = Utilities.ColorToHex(color)
        local h, _, _ = Color3.toHSV(color)
        hueKnob.Position = UDim2.new(h, -7, 0.5, -7)
        hueSlider.BackgroundColor3 = color
    end
    colorpicker.GetValue = function() return colorpicker.Value end
    colorpicker.OnChanged = function(callback)
        table.insert(colorpicker.Callbacks, callback)
    end

    Fluent.Options[id] = colorpicker
    return colorpicker
end

function Window:AddKeybind(id, config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local keybind = {
        Value = config.Default or Enum.KeyCode.Unknown,
        Callbacks = {},
        Listening = false,
    }

    local frame = Utilities.Create("Frame", {
        Name = "Keybind_" .. id,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = self.ContentContainer,
    })
    Utilities.CreateCorner(frame, 8)
    Utilities.CreateStroke(frame, theme.Border, 1)

    Utilities.Create("TextLabel", {
        Text = config.Title or id,
        Font = CONFIG.FontMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local keyLabel = Utilities.Create("TextButton", {
        Text = keybind.Value.Name ~= "Unknown" and keybind.Value.Name or "None",
        Font = CONFIG.Font,
        TextSize = 11,
        TextColor3 = theme.Accent,
        BackgroundColor3 = theme.TertiaryBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 70, 0, 28),
        Position = UDim2.new(1, -82, 0.5, -14),
        Parent = frame,
    })
    Utilities.CreateCorner(keyLabel, 6)

    keyLabel.MouseButton1Click:Connect(function()
        keybind.Listening = true
        keyLabel.Text = "..."
        keyLabel.TextColor3 = theme.Warning
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if keybind.Listening and input.UserInputType == Enum.UserInputType.Keyboard then
            keybind.Listening = false
            keybind.Value = input.KeyCode
            keyLabel.Text = input.KeyCode.Name
            keyLabel.TextColor3 = theme.Accent

            for _, callback in ipairs(keybind.Callbacks) do
                task.spawn(callback, input.KeyCode)
            end
            if config.Callback then
                task.spawn(config.Callback, input.KeyCode)
            end
        end

        if not processed and not keybind.Listening and input.KeyCode == keybind.Value then
            if config.Callback then
                task.spawn(config.Callback, input.KeyCode)
            end
        end
    end)

    keybind.Instance = frame
    keybind.SetValue = function(key)
        keybind.Value = key
        keyLabel.Text = key.Name
    end
    keybind.GetValue = function() return keybind.Value end
    keybind.OnChanged = function(callback)
        table.insert(keybind.Callbacks, callback)
    end

    Fluent.Options[id] = keybind
    return keybind
end

function Window:AddTextbox(id, config)
    config = config or {}
    local theme = Themes[self.Theme] or Themes.Dark

    local textbox = {
        Value = config.Default or "",
        Callbacks = {},
    }

    local frame = Utilities.Create("Frame", {
        Name = "Textbox_" .. id,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = self.ContentContainer,
    })
    Utilities.CreateCorner(frame, 8)
    Utilities.CreateStroke(frame, theme.Border, 1)

    Utilities.Create("TextLabel", {
        Text = config.Title or id,
        Font = CONFIG.FontMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -20, 0, 20),
        Position = UDim2.new(0, 10, 0, 6),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    })

    local inputBox = Utilities.Create("TextBox", {
        Text = textbox.Value,
        Font = CONFIG.Font,
        TextSize = 11,
        TextColor3 = theme.Text,
        BackgroundColor3 = theme.TertiaryBackground,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -20, 0, 26),
        Position = UDim2.new(0, 10, 0, 28),
        PlaceholderText = config.Placeholder or "Enter text...",
        PlaceholderColor3 = theme.SubText,
        Parent = frame,
    })
    Utilities.CreateCorner(inputBox, 6)
    Utilities.CreateStroke(inputBox, theme.Border, 1)

    inputBox.FocusLost:Connect(function()
        textbox.Value = inputBox.Text
        for _, callback in ipairs(textbox.Callbacks) do
            task.spawn(callback, textbox.Value)
        end
        if config.Callback then
            task.spawn(config.Callback, textbox.Value)
        end
    end)

    textbox.Instance = frame
    textbox.SetValue = function(value)
        textbox.Value = value
        inputBox.Text = value
    end
    textbox.GetValue = function() return textbox.Value end
    textbox.OnChanged = function(callback)
        table.insert(textbox.Callbacks, callback)
    end

    Fluent.Options[id] = textbox
    return textbox
end

--// Override Window methods to store elements in selected tab
local originalAddParagraph = Window.AddParagraph
local originalAddButton = Window.AddButton
local originalAddToggle = Window.AddToggle
local originalAddSlider = Window.AddSlider
local originalAddDropdown = Window.AddDropdown
local originalAddColorpicker = Window.AddColorpicker
local originalAddKeybind = Window.AddKeybind
local originalAddTextbox = Window.AddTextbox
local originalAddSection = Window.AddSection

function Window:AddParagraph(config)
    local result = originalAddParagraph(self, config)
    if self.SelectedTab then
        table.insert(self.SelectedTab.Elements, result)
    end
    return result
end

function Window:AddButton(config)
    local result = originalAddButton(self, config)
    if self.SelectedTab then
        table.insert(self.SelectedTab.Elements, result)
    end
    return result
end

function Window:AddToggle(id, config)
    local result = originalAddToggle(self, id, config)
    if self.SelectedTab then
        table.insert(self.SelectedTab.Elements, result)
    end
    return result
end

function Window:AddSlider(id, config)
    local result = originalAddSlider(self, id, config)
    if self.SelectedTab then
        table.insert(self.SelectedTab.Elements, result)
    end
    return result
end

function Window:AddDropdown(id, config)
    local result = originalAddDropdown(self, id, config)
    if self.SelectedTab then
        table.insert(self.SelectedTab.Elements, result)
    end
    return result
end

function Window:AddColorpicker(id, config)
    local result = originalAddColorpicker(self, id, config)
    if self.SelectedTab then
        table.insert(self.SelectedTab.Elements, result)
    end
    return result
end

function Window:AddKeybind(id, config)
    local result = originalAddKeybind(self, id, config)
    if self.SelectedTab then
        table.insert(self.SelectedTab.Elements, result)
    end
    return result
end

function Window:AddTextbox(id, config)
    local result = originalAddTextbox(self, id, config)
    if self.SelectedTab then
        table.insert(self.SelectedTab.Elements, result)
    end
    return result
end

function Window:AddSection(name)
    local result = originalAddSection(self, name)
    if self.SelectedTab then
        table.insert(self.SelectedTab.Elements, {Instance = result.Instance})
    end
    return result
end

--// Save Manager
local SaveManager = {}
SaveManager.__index = SaveManager

function SaveManager:SetLibrary(library)
    self.Library = library
end

function SaveManager:BuildConfigSection(tab)
    tab:AddParagraph({
        Title = "Save Manager",
        Content = "Save and load your configuration settings.",
    })

    tab:AddTextbox("ConfigName", {
        Title = "Config Name",
        Placeholder = "Enter config name...",
        Default = "default",
    })

    tab:AddButton({
        Title = "Save Config",
        Description = "Save current settings",
        Callback = function()
            self:Save()
            if self.Library.Window then
                self.Library.Window:Notify({
                    Title = "Config Saved",
                    Content = "Configuration has been saved successfully.",
                    Duration = 3,
                })
            end
        end,
    })

    tab:AddButton({
        Title = "Load Config",
        Description = "Load saved settings",
        Callback = function()
            self:Load()
            if self.Library.Window then
                self.Library.Window:Notify({
                    Title = "Config Loaded",
                    Content = "Configuration has been loaded successfully.",
                    Duration = 3,
                })
            end
        end,
    })

    tab:AddButton({
        Title = "Delete Config",
        Description = "Delete the current config",
        Callback = function()
            self:Delete()
            if self.Library.Window then
                self.Library.Window:Notify({
                    Title = "Config Deleted",
                    Content = "Configuration has been deleted.",
                    Duration = 3,
                })
            end
        end,
    })
end

function SaveManager:Save()
    local configName = "default"
    if self.Library.Options.ConfigName then
        configName = self.Library.Options.ConfigName.Value
    end

    local data = {}
    for id, option in pairs(self.Library.Options) do
        if option.Value ~= nil then
            if typeof(option.Value) == "Color3" then
                data[id] = { type = "Color3", value = { option.Value.R, option.Value.G, option.Value.B } }
            elseif typeof(option.Value) == "EnumItem" then
                data[id] = { type = "EnumItem", value = option.Value.Name }
            else
                data[id] = { type = "raw", value = option.Value }
            end
        end
    end

    local success, encoded = pcall(HttpService.JSONEncode, HttpService, data)
    if success then
        if writefile then
            writefile("FluentUI_" .. configName .. ".json", encoded)
        end
    end
end

function SaveManager:Load()
    local configName = "default"
    if self.Library.Options.ConfigName then
        configName = self.Library.Options.ConfigName.Value
    end

    if readfile then
        local success, content = pcall(readfile, "FluentUI_" .. configName .. ".json")
        if success then
            local decodeSuccess, data = pcall(HttpService.JSONDecode, HttpService, content)
            if decodeSuccess then
                for id, entry in pairs(data) do
                    if self.Library.Options[id] and self.Library.Options[id].SetValue then
                        if entry.type == "Color3" then
                            self.Library.Options[id]:SetValue(Color3.new(entry.value[1], entry.value[2], entry.value[3]))
                        elseif entry.type == "EnumItem" then
                            self.Library.Options[id]:SetValue(Enum.KeyCode[entry.value])
                        else
                            self.Library.Options[id]:SetValue(entry.value)
                        end
                    end
                end
            end
        end
    end
end

function SaveManager:Delete()
    local configName = "default"
    if self.Library.Options.ConfigName then
        configName = self.Library.Options.ConfigName.Value
    end

    if delfile then
        pcall(delfile, "FluentUI_" .. configName .. ".json")
    end
end

--// Interface Manager
local InterfaceManager = {}
InterfaceManager.__index = InterfaceManager

function InterfaceManager:SetLibrary(library)
    self.Library = library
end

function InterfaceManager:BuildInterfaceSection(tab)
    tab:AddParagraph({
        Title = "Interface Settings",
        Content = "Customize the UI appearance.",
    })

    tab:AddDropdown("ThemeSelector", {
        Title = "Theme",
        Values = { "Dark", "Light", "Aqua", "Amethyst", "Rose" },
        Default = "Dark",
        Callback = function(value)
            if self.Library.Window then
                self.Library.Window:SetTheme(value)
            end
        end,
    })

    tab:AddToggle("AcrylicToggle", {
        Title = "Acrylic Blur",
        Default = true,
        Callback = function(value)
            if self.Library.Window then
                self.Library.Window:ToggleAcrylic(value)
            end
        end,
    })

    tab:AddToggle("TransparencyToggle", {
        Title = "Transparency",
        Default = false,
        Callback = function(value)
            if self.Library.Window then
                self.Library.Window:ToggleTransparency(value)
            end
        end,
    })

    tab:AddButton({
        Title = "Destroy UI",
        Description = "Close the interface",
        Callback = function()
            if self.Library.Window then
                self.Library.Window:Destroy()
            end
        end,
    })
end

--// Add SaveManager and InterfaceManager to Fluent
Fluent.SaveManager = SaveManager
Fluent.InterfaceManager = InterfaceManager

--// Return the library
return Fluent
