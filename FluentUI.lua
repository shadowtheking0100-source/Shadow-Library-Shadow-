--[[
    FluentUI 2026 — Premium Edition
    • Frame-drawn icon system with expanded glyph set
    • No screen blur, no heavy image assets
    • Modern design tokens and dynamic theme updates
    • Smooth, lightweight micro-interactions
    • Full element suite + SaveManager + InterfaceManager
    • Backwards-compatible FluentUI API
]]

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local Icon = {}
local Themes = {}
local Fluent
local Window = {}
Window.__index = Window

local function inst(className, props)
    local object = Instance.new(className)
    for k, v in pairs(props or {}) do
        object[k] = v
    end
    return object
end

local function tween(object, properties, duration, style, direction)
    if not object or not object.Parent then
        return nil
    end
    local tw = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.18,
            style or Enum.EasingStyle.Quart,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tw:Play()
    return tw
end

local function corner(parent, radius)
    return inst("UICorner", {
        CornerRadius = UDim.new(0, radius or 10),
        Parent = parent,
    })
end

local function stroke(parent, color, thickness, transparency)
    return inst("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function padding(parent, top, bottom, left, right)
    return inst("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or 0),
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or 0),
        Parent = parent,
    })
end

local function shadow(parent, color, transparency, size)
    return inst("ImageLabel", {
        Name = "FluentShadow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = color or Color3.new(0, 0, 0),
        ImageTransparency = transparency or 0.62,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450),
        Size = UDim2.new(1, size or 30, 1, size or 30),
        Position = UDim2.new(0, -(size or 30) / 2, 0, -(size or 30) / 2),
        ZIndex = math.max(0, (parent.ZIndex or 1) - 1),
        Parent = parent,
    })
end

local function setRole(object, role)
    if object and object.SetAttribute then
        object:SetAttribute("FluentThemeRole", role)
    end
    return object
end

local function bindRole(object, property, role)
    if object and object.SetAttribute then
        object:SetAttribute("FluentThemeProperty", property)
        object:SetAttribute("FluentThemeRole", role)
    end
    return object
end

local function getTheme(name)
    return Themes[name] or Themes.Dark
end

local function colorSequence(a, b)
    return ColorSequence.new(a, b)
end

local function makeLine(parent, color, width, height, x, y, rotation, transparency)
    local line = inst("Frame", {
        BackgroundColor3 = color,
        BackgroundTransparency = transparency or 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(width, height),
        Rotation = rotation or 0,
        Parent = parent,
    })
    corner(line, math.max(1, math.ceil(math.min(width, height) / 2)))
    setRole(line, "Icon")
    return line
end

local function makeRing(parent, color, diameter, x, y, thickness)
    local holder = inst("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(diameter, diameter),
        Parent = parent,
    })
    stroke(holder, color, thickness or 1.5)
    setRole(holder, "Icon")
    return holder
end

function Icon.make(name, size, color)
    size = size or 16
    color = color or Color3.new(1, 1, 1)

    local holder = inst("Frame", {
        Name = "Icon_" .. tostring(name),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(size, size),
    })
    holder:SetAttribute("FluentIcon", true)

    local s, c = size, size / 2
    local t = math.max(1.4, size / 9)
    local function L(w, h, x, y, r, tr)
        return makeLine(holder, color, w, h, x, y, r, tr)
    end
    local function R(d, x, y, th)
        return makeRing(holder, color, d, x, y, th)
    end

    if name == "menu" then
        L(s * .70, t, c, s * .28)
        L(s * .70, t, c, s * .50)
        L(s * .70, t, c, s * .72)
    elseif name == "close" or name == "x" then
        L(s * .68, t, c, c, 45)
        L(s * .68, t, c, c, -45)
    elseif name == "minimize" then
        L(s * .68, t, c, c)
    elseif name == "plus" then
        L(s * .66, t, c, c)
        L(t, s * .66, c, c)
    elseif name == "minus" then
        L(s * .66, t, c, c)
    elseif name == "check" then
        L(s * .30, t, s * .31, s * .60, 45)
        L(s * .57, t, s * .58, s * .45, -45)
    elseif name == "chevron-down" then
        L(s * .38, t, s * .35, s * .46, 45)
        L(s * .38, t, s * .65, s * .46, -45)
    elseif name == "chevron-up" then
        L(s * .38, t, s * .35, s * .54, -45)
        L(s * .38, t, s * .65, s * .54, 45)
    elseif name == "chevron-right" then
        L(s * .38, t, s * .56, s * .35, -45)
        L(s * .38, t, s * .56, s * .65, 45)
    elseif name == "chevron-left" then
        L(s * .38, t, s * .44, s * .35, 45)
        L(s * .38, t, s * .44, s * .65, -45)
    elseif name == "arrow-right" then
        L(s * .60, t, s * .38, c)
        L(s * .24, t, s * .68, s * .36, 45)
        L(s * .24, t, s * .68, s * .64, -45)
    elseif name == "arrow-left" then
        L(s * .60, t, s * .62, c)
        L(s * .24, t, s * .32, s * .36, -45)
        L(s * .24, t, s * .32, s * .64, 45)
    elseif name == "arrow-up" then
        L(s * .60, t, c, s * .62, 90)
        L(s * .24, t, s * .38, s * .32, -45)
        L(s * .24, t, s * .62, s * .32, 45)
    elseif name == "arrow-down" then
        L(s * .60, t, c, s * .38, 90)
        L(s * .24, t, s * .38, s * .68, 45)
        L(s * .24, t, s * .62, s * .68, -45)
    elseif name == "search" then
        R(s * .56, s * .39, s * .39, t)
        L(s * .30, t, s * .68, s * .68, 45)
    elseif name == "home" then
        L(s * .56, s * .46, c, s * .64)
        L(s * .46, t, s * .34, s * .38, -45)
        L(s * .46, t, s * .66, s * .38, 45)
        L(s * .14, s * .24, c, s * .70, 0, .02)
    elseif name == "user" then
        R(s * .26, c, s * .31, t)
        L(s * .56, s * .30, c, s * .68)
    elseif name == "users" then
        R(s * .22, s * .34, s * .30, t)
        R(s * .20, s * .68, s * .34, t)
        L(s * .40, s * .24, s * .34, s * .70)
        L(s * .28, s * .20, s * .68, s * .66)
    elseif name == "settings" or name == "sliders" then
        L(s * .70, t, c, s * .27)
        L(s * .18, s * .18, s * .35, s * .27)
        L(s * .70, t, c, s * .50)
        L(s * .18, s * .18, s * .67, s * .50)
        L(s * .70, t, c, s * .73)
        L(s * .18, s * .18, s * .48, s * .73)
    elseif name == "dashboard" then
        L(s * .28, s * .28, s * .32, s * .32)
        L(s * .28, s * .28, s * .68, s * .32)
        L(s * .28, s * .28, s * .32, s * .68)
        L(s * .28, s * .28, s * .68, s * .68)
    elseif name == "folder" then
        L(s * .68, s * .48, c, s * .57)
        L(s * .36, s * .18, s * .36, s * .36)
    elseif name == "file" then
        L(s * .56, s * .72, c, s * .53)
        L(s * .24, t, c, s * .30)
        L(s * .24, t, c, s * .48)
        L(s * .24, t, c, s * .66)
    elseif name == "save" then
        R(s * .74, c, c, t)
        L(s * .46, t, c, s * .30)
        L(s * .28, t, c, s * .70)
    elseif name == "download" then
        L(s * .46, t, c, s * .34, 90)
        L(s * .23, t, s * .37, s * .63, 45)
        L(s * .23, t, s * .63, s * .63, -45)
        L(s * .64, t, c, s * .78)
    elseif name == "upload" then
        L(s * .46, t, c, s * .64, 90)
        L(s * .23, t, s * .37, s * .37, -45)
        L(s * .23, t, s * .63, s * .37, 45)
        L(s * .64, t, c, s * .22)
    elseif name == "refresh" then
        R(s * .66, c, c, t)
        L(s * .26, t, s * .66, s * .19, -25)
        L(s * .26, t, s * .34, s * .81, 155)
    elseif name == "trash" then
        L(s * .52, s * .52, c, s * .60)
        L(s * .62, t, c, s * .26)
        L(s * .22, s * .12, c, s * .18)
    elseif name == "edit" then
        L(s * .62, t, c, c, -45)
        L(s * .16, t, s * .24, s * .76, 45)
        L(s * .14, s * .14, s * .20, s * .80, 45)
    elseif name == "copy" then
        R(s * .42, s * .42, s * .48, t)
        R(s * .42, s * .62, s * .56, t)
    elseif name == "check-circle" then
        R(s * .78, c, c, t)
        L(s * .24, t, s * .35, s * .54, 45)
        L(s * .45, t, s * .57, s * .45, -45)
    elseif name == "bell" then
        L(s * .48, s * .48, c, s * .46)
        L(s * .68, t, c, s * .68)
        R(s * .12, c, s * .80, 1.2)
    elseif name == "info" then
        R(s * .80, c, c, t)
        L(s * .12, s * .12, c, s * .31)
        L(t, s * .32, c, s * .60)
    elseif name == "warning" then
        L(s * .64, t, c, s * .24, 0)
        L(s * .74, t, s * .35, s * .63, 60)
        L(s * .74, t, s * .65, s * .63, -60)
        L(t, s * .20, c, s * .50)
    elseif name == "error" then
        R(s * .80, c, c, t)
        L(s * .34, t, c, c, 45)
        L(s * .34, t, c, c, -45)
    elseif name == "lock" then
        R(s * .38, c, s * .34, t)
        L(s * .54, s * .40, c, s * .64)
    elseif name == "unlock" then
        L(s * .25, t, s * .35, s * .23, 90)
        L(s * .54, s * .40, c, s * .64)
        R(s * .38, c, s * .34, t)
    elseif name == "eye" then
        R(s * .20, c, c, t)
        L(s * .76, t, c, s * .30, 20)
        L(s * .76, t, c, s * .70, -20)
    elseif name == "eye-off" then
        L(s * .72, t, c, c, -35)
        L(s * .76, t, c, c, 20)
    elseif name == "play" then
        L(s * .56, t, s * .40, c, 60)
        L(s * .56, t, s * .40, c, -60)
    elseif name == "pause" then
        L(t * 1.6, s * .48, s * .38, c)
        L(t * 1.6, s * .48, s * .62, c)
    elseif name == "stop" then
        L(s * .48, s * .48, c, c)
    elseif name == "volume" then
        L(s * .18, s * .24, s * .22, c)
        L(s * .25, s * .34, s * .35, c)
        R(s * .34, s * .55, c, t)
        L(s * .22, t, s * .68, s * .32, 45)
        L(s * .22, t, s * .68, s * .68, -45)
    elseif name == "mic" then
        R(s * .28, c, s * .34, t)
        L(s * .46, t, c, s * .66)
        L(s * .28, t, c, s * .78)
    elseif name == "keyboard" then
        R(s * .82, c, s * .50, t)
        L(s * .10, s * .10, s * .30, s * .50)
        L(s * .10, s * .10, s * .50, s * .50)
        L(s * .10, s * .10, s * .70, s * .50)
        L(s * .36, s * .10, c, s * .73)
    elseif name == "mouse" then
        R(s * .72, c, c, t)
        L(t, s * .20, c, s * .28)
    elseif name == "gamepad" then
        R(s * .72, c, c, t)
        L(s * .26, t, s * .28, c)
        L(t, s * .26, s * .28, c)
        R(s * .10, s * .66, s * .62, 1)
        R(s * .10, s * .72, s * .62, 1)
    elseif name == "code" then
        L(s * .30, t, s * .30, c, 35)
        L(s * .30, t, s * .70, c, -35)
        L(s * .28, t, c, c, 18)
    elseif name == "terminal" then
        R(s * .74, c, c, t)
        L(s * .26, t, s * .34, s * .44, 45)
        L(s * .26, t, s * .34, s * .56, -45)
        L(s * .24, t, s * .64, s * .65)
    elseif name == "palette" then
        R(s * .70, s * .43, s * .48, t)
        R(s * .10, s * .34, s * .34, 1)
        R(s * .10, s * .55, s * .30, 1)
        R(s * .10, s * .67, s * .55, 1)
    elseif name == "sun" then
        R(s * .34, c, c, t)
        for i = 0, 7 do
            local angle = math.rad(i * 45)
            L(s * .18, t, c + math.cos(angle) * s * .39, c + math.sin(angle) * s * .39, i * 45)
        end
    elseif name == "moon" then
        R(s * .68, c * 1.05, c, t)
        local cut = inst("Frame", {
            BackgroundColor3 = color,
            BorderSizePixel = 0,
            BackgroundTransparency = 0,
            Size = UDim2.fromOffset(s * .58, s * .58),
            Position = UDim2.fromOffset(s * .54, s * .30),
            Parent = holder,
        })
        corner(cut, s)
        setRole(cut, "MoonCut")
    elseif name == "sparkles" then
        L(t, s * .60, c, c)
        L(s * .60, t, c, c)
        L(t, s * .34, s * .78, s * .25)
        L(s * .34, t, s * .78, s * .25)
        L(t, s * .28, s * .25, s * .74)
        L(s * .28, t, s * .25, s * .74)
    elseif name == "star" then
        for i = 0, 4 do
            local a1 = math.rad(i * 72 - 90)
            local a2 = math.rad(i * 72 + 36 - 90)
            local x1, y1 = c + math.cos(a1) * s * .34, c + math.sin(a1) * s * .34
            local x2, y2 = c + math.cos(a2) * s * .14, c + math.sin(a2) * s * .14
            L(s * .34, t, (x1 + x2) / 2, (y1 + y2) / 2, math.deg(math.atan2(y2-y1, x2-x1)))
        end
    elseif name == "heart" then
        R(s * .24, s * .36, s * .34, t)
        R(s * .24, s * .64, s * .34, t)
        L(s * .60, t, c, s * .63, 0)
    elseif name == "shield" then
        L(s * .56, s * .54, c, s * .48)
        L(s * .44, t, s * .35, s * .28, 35)
        L(s * .44, t, s * .65, s * .28, -35)
    elseif name == "zap" then
        L(s * .28, t, s * .43, s * .36, -58)
        L(s * .30, t, s * .58, s * .60, -58)
        L(s * .22, t, s * .51, s * .48, -58)
    elseif name == "server" then
        L(s * .66, s * .20, c, s * .30)
        L(s * .66, s * .20, c, s * .53)
        L(s * .66, s * .20, c, s * .76)
        R(s * .08, s * .28, s * .30, 1)
        R(s * .08, s * .28, s * .53, 1)
        R(s * .08, s * .28, s * .76, 1)
    elseif name == "globe" then
        R(s * .78, c, c, t)
        R(s * .44, c, c, t)
        L(s * .70, t, c, c)
    elseif name == "link" or name == "external-link" then
        R(s * .34, s * .34, s * .60, t)
        R(s * .34, s * .61, s * .34, t)
        L(s * .54, t, s * .49, s * .45, 45)
        if name == "external-link" then
            L(s * .34, t, s * .68, s * .25, -45)
            L(s * .24, t, s * .73, s * .24)
        end
    elseif name == "discord" then
        R(s * .72, c, c, t)
        R(s * .09, s * .39, s * .53, 1)
        R(s * .09, s * .61, s * .53, 1)
    elseif name == "github" then
        R(s * .76, c, c, t)
        L(s * .12, s * .28, s * .32, s * .74, -15)
        L(s * .12, s * .28, s * .68, s * .74, 15)
    elseif name == "dot" then
        L(s * .34, s * .34, c, c)
    elseif name == "ring" then
        R(s * .72, c, c, t)
    elseif name == "text" then
        L(s * .70, t, c, s * .30)
        L(t, s * .58, c, s * .61)
    elseif name == "list" then
        for i = 0, 2 do
            L(s * .13, s * .13, s * .18, s * (.30 + i * .20))
            L(s * .54, t, s * .55, s * (.30 + i * .20))
        end
    else
        L(s * .40, s * .40, c, c)
    end

    return holder
end

local function makeIcon(parent, icon, size, color)
    local object
    if type(icon) == "number" or (type(icon) == "string" and icon:sub(1, 10) == "rbxassetid") then
        object = inst("ImageLabel", {
            BackgroundTransparency = 1,
            Image = type(icon) == "number" and ("rbxassetid://" .. icon) or icon,
            ImageColor3 = color or Color3.new(1, 1, 1),
            Size = UDim2.fromOffset(size, size),
            Parent = parent,
        })
    else
        object = Icon.make(icon or "dot", size, color)
        object.Parent = parent
    end
    object:SetAttribute("FluentIconRoot", true)
    local currentTheme = getTheme(Fluent and Fluent.Theme or "Dark")
    local function sameColor(a, b)
        return typeof(a) == "Color3" and typeof(b) == "Color3"
            and math.abs(a.R - b.R) < 0.001
            and math.abs(a.G - b.G) < 0.001
            and math.abs(a.B - b.B) < 0.001
    end
    local token
    for _, role in ipairs({"Accent", "AccentHi", "Text", "SubText", "TextMuted", "Warning", "Error", "Success", "Info"}) do
        if sameColor(color, currentTheme[role]) then
            token = role
            break
        end
    end
    if token then object:SetAttribute("FluentIconToken", token) end
    return object
end

local function setIconColor(icon, color)
    if not icon or not icon.Parent then
        return
    end
    if icon:IsA("ImageLabel") or icon:IsA("ImageButton") then
        icon.ImageColor3 = color
    end
    for _, child in ipairs(icon:GetDescendants()) do
        if child:IsA("Frame") then
            local role = child:GetAttribute("FluentThemeRole")
            if role == "Icon" then
                child.BackgroundColor3 = color
            elseif role == "MoonCut" then
                child.BackgroundColor3 = color
            end
        elseif child:IsA("UIStroke") and child.Parent and child.Parent:GetAttribute("FluentThemeRole") == "Icon" then
            child.Color = color
        end
    end
end

local function applyThemeToTree(root, theme)
    local objects = { root }
    for _, child in ipairs(root:GetDescendants()) do
        table.insert(objects, child)
    end
    for _, object in ipairs(objects) do
        local role = object:GetAttribute("FluentThemeRole")
        local property = object:GetAttribute("FluentThemeProperty")
        if role and theme[role] then
            if property and object[property] ~= nil then
                if property == "ImageColor3" then
                    object[property] = theme[role]
                elseif property == "TextColor3" or property == "BackgroundColor3" or property == "Color" then
                    object[property] = theme[role]
                end
            elseif object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                object.TextColor3 = theme[role]
            elseif object:IsA("Frame") then
                object.BackgroundColor3 = theme[role]
            elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
                object.ImageColor3 = theme[role]
            elseif object:IsA("UIStroke") then
                object.Color = theme[role]
            end
        end
        local iconToken = object:GetAttribute("FluentIconToken")
        if iconToken and theme[iconToken] then
            setIconColor(object, theme[iconToken])
        end
        if object:GetAttribute("FluentThemeShadow") and (object:IsA("ImageLabel") or object:IsA("ImageButton")) then
            object.ImageColor3 = theme.Shadow
        end
        if object:IsA("UIGradient") then
            local gradientRoleA = object:GetAttribute("FluentGradientA")
            local gradientRoleB = object:GetAttribute("FluentGradientB")
            if gradientRoleA and gradientRoleB and theme[gradientRoleA] and theme[gradientRoleB] then
                object.Color = colorSequence(theme[gradientRoleA], theme[gradientRoleB])
            end
        end
    end
end

local function draggable(self, frame, handle, bounds)
    handle = handle or frame
    local dragging = false
    local dragInput
    local dragStart
    local startPosition

    local began = handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end
        dragging = true
        dragStart = input.Position
        startPosition = frame.Position
        local release
        release = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                release:Disconnect()
            end
        end)
        table.insert(self._connections, release)
    end)

    local changed = handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    local globalChanged = UserInputService.InputChanged:Connect(function(input)
        if not dragging or input ~= dragInput or not frame.Parent then
            return
        end
        local delta = input.Position - dragStart
        local x = startPosition.X.Offset + delta.X
        local y = startPosition.Y.Offset + delta.Y
        if bounds then
            local camera = workspace.CurrentCamera
            local viewport = camera and camera.ViewportSize or Vector2.new(1920, 1080)
            local size = frame.AbsoluteSize
            x = math.clamp(x, bounds.minX, viewport.X - size.X - bounds.maxX)
            y = math.clamp(y, bounds.minY, viewport.Y - size.Y - bounds.maxY)
        end
        frame.Position = UDim2.new(startPosition.X.Scale, x, startPosition.Y.Scale, y)
    end)

    table.insert(self._connections, began)
    table.insert(self._connections, changed)
    table.insert(self._connections, globalChanged)
end

local function roundedButton(parent, size, bg, textColor, radius)
    local button = inst("TextButton", {
        Text = "",
        AutoButtonColor = false,
        BackgroundColor3 = bg,
        BorderSizePixel = 0,
        Size = size,
        Parent = parent,
    })
    corner(button, radius or 9)
    bindRole(button, "BackgroundColor3", "Surface")
    button:SetAttribute("FluentButton", true)
    return button
end

local function ripple(button, color)
    button.ClipsDescendants = true
    local connection = button.MouseButton1Down:Connect(function(x, y)
        local size = button.AbsoluteSize
        local position = button.AbsolutePosition
        local localX = x - position.X
        local localY = y - position.Y
        local diameter = math.max(
            math.sqrt(localX * localX + localY * localY),
            math.sqrt((size.X - localX) ^ 2 + localY ^ 2),
            math.sqrt(localX ^ 2 + (size.Y - localY) ^ 2),
            math.sqrt((size.X - localX) ^ 2 + (size.Y - localY) ^ 2)
        ) * 2
        local wave = inst("Frame", {
            BackgroundColor3 = color,
            BackgroundTransparency = 0.80,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromOffset(localX, localY),
            Size = UDim2.fromOffset(0, 0),
            ZIndex = button.ZIndex + 2,
            Parent = button,
        })
        corner(wave, diameter)
        tween(wave, {
            Size = UDim2.fromOffset(diameter, diameter),
            BackgroundTransparency = 1,
        }, 0.42, Enum.EasingStyle.Quart)
        task.delay(0.45, function()
            if wave and wave.Parent then
                wave:Destroy()
            end
        end)
    end)
    return connection
end

local function roundNumber(number, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(number * mult + 0.5) / mult
end

local function toHex(color)
    return string.format("#%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
end

local function fromHex(hex)
    hex = tostring(hex or ""):gsub("#", "")
    if #hex ~= 6 then
        return nil
    end
    local r, g, b = tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
    if not r or not g or not b then
        return nil
    end
    return Color3.fromRGB(r, g, b)
end

Themes.Dark = {
    Bg = Color3.fromRGB(11, 13, 17), Bg2 = Color3.fromRGB(15, 18, 23), Bg3 = Color3.fromRGB(22, 25, 31),
    Surface = Color3.fromRGB(20, 23, 29), SurfaceHi = Color3.fromRGB(27, 31, 39), SurfacePressed = Color3.fromRGB(32, 36, 45),
    Text = Color3.fromRGB(241, 243, 247), SubText = Color3.fromRGB(154, 160, 172), TextMuted = Color3.fromRGB(103, 109, 122),
    Accent = Color3.fromRGB(99, 102, 241), AccentHi = Color3.fromRGB(128, 132, 255), AccentPressed = Color3.fromRGB(79, 82, 204), AccentMuted = Color3.fromRGB(53, 56, 118),
    Border = Color3.fromRGB(37, 42, 51), BorderHi = Color3.fromRGB(57, 63, 75),
    Success = Color3.fromRGB(70, 199, 122), Warning = Color3.fromRGB(241, 180, 65), Error = Color3.fromRGB(238, 78, 87), Info = Color3.fromRGB(79, 154, 255),
    Shadow = Color3.fromRGB(0, 0, 0),
}

Themes.Light = {
    Bg = Color3.fromRGB(246, 247, 250), Bg2 = Color3.fromRGB(240, 242, 246), Bg3 = Color3.fromRGB(232, 235, 241),
    Surface = Color3.fromRGB(255, 255, 255), SurfaceHi = Color3.fromRGB(248, 249, 252), SurfacePressed = Color3.fromRGB(240, 242, 247),
    Text = Color3.fromRGB(26, 29, 36), SubText = Color3.fromRGB(94, 101, 116), TextMuted = Color3.fromRGB(141, 147, 159),
    Accent = Color3.fromRGB(88, 101, 242), AccentHi = Color3.fromRGB(107, 119, 252), AccentPressed = Color3.fromRGB(70, 84, 220), AccentMuted = Color3.fromRGB(211, 214, 251),
    Border = Color3.fromRGB(219, 222, 230), BorderHi = Color3.fromRGB(193, 198, 210),
    Success = Color3.fromRGB(48, 170, 96), Warning = Color3.fromRGB(224, 152, 27), Error = Color3.fromRGB(218, 59, 69), Info = Color3.fromRGB(65, 118, 218),
    Shadow = Color3.fromRGB(114, 121, 137),
}

Themes.Midnight = {
    Bg = Color3.fromRGB(7, 10, 17), Bg2 = Color3.fromRGB(11, 15, 25), Bg3 = Color3.fromRGB(18, 24, 38),
    Surface = Color3.fromRGB(15, 20, 31), SurfaceHi = Color3.fromRGB(22, 29, 44), SurfacePressed = Color3.fromRGB(27, 35, 52),
    Text = Color3.fromRGB(225, 232, 245), SubText = Color3.fromRGB(123, 137, 163), TextMuted = Color3.fromRGB(82, 94, 120),
    Accent = Color3.fromRGB(56, 189, 248), AccentHi = Color3.fromRGB(100, 209, 255), AccentPressed = Color3.fromRGB(33, 155, 211), AccentMuted = Color3.fromRGB(34, 82, 116),
    Border = Color3.fromRGB(28, 37, 57), BorderHi = Color3.fromRGB(43, 57, 84),
    Success = Color3.fromRGB(78, 196, 136), Warning = Color3.fromRGB(238, 181, 66), Error = Color3.fromRGB(239, 82, 95), Info = Color3.fromRGB(74, 153, 242),
    Shadow = Color3.fromRGB(0, 0, 0),
}

Themes.Dracula = {
    Bg = Color3.fromRGB(28, 26, 38), Bg2 = Color3.fromRGB(35, 32, 47), Bg3 = Color3.fromRGB(47, 42, 61),
    Surface = Color3.fromRGB(40, 37, 54), SurfaceHi = Color3.fromRGB(53, 48, 68), SurfacePressed = Color3.fromRGB(61, 55, 77),
    Text = Color3.fromRGB(248, 248, 242), SubText = Color3.fromRGB(178, 175, 194), TextMuted = Color3.fromRGB(120, 118, 139),
    Accent = Color3.fromRGB(255, 121, 198), AccentHi = Color3.fromRGB(255, 153, 215), AccentPressed = Color3.fromRGB(222, 87, 162), AccentMuted = Color3.fromRGB(117, 57, 94),
    Border = Color3.fromRGB(57, 52, 74), BorderHi = Color3.fromRGB(76, 69, 95),
    Success = Color3.fromRGB(80, 250, 123), Warning = Color3.fromRGB(241, 250, 140), Error = Color3.fromRGB(255, 85, 85), Info = Color3.fromRGB(139, 180, 255),
    Shadow = Color3.fromRGB(0, 0, 0),
}

Themes.Nord = {
    Bg = Color3.fromRGB(37, 42, 52), Bg2 = Color3.fromRGB(45, 51, 63), Bg3 = Color3.fromRGB(57, 65, 81),
    Surface = Color3.fromRGB(49, 55, 69), SurfaceHi = Color3.fromRGB(62, 70, 87), SurfacePressed = Color3.fromRGB(68, 78, 96),
    Text = Color3.fromRGB(236, 239, 244), SubText = Color3.fromRGB(156, 165, 183), TextMuted = Color3.fromRGB(114, 124, 143),
    Accent = Color3.fromRGB(136, 192, 208), AccentHi = Color3.fromRGB(158, 211, 225), AccentPressed = Color3.fromRGB(108, 165, 183), AccentMuted = Color3.fromRGB(61, 95, 107),
    Border = Color3.fromRGB(61, 69, 84), BorderHi = Color3.fromRGB(79, 89, 107),
    Success = Color3.fromRGB(163, 190, 140), Warning = Color3.fromRGB(235, 203, 139), Error = Color3.fromRGB(191, 97, 106), Info = Color3.fromRGB(129, 161, 193),
    Shadow = Color3.fromRGB(18, 21, 27),
}

Themes.Emerald = {
    Bg = Color3.fromRGB(10, 18, 16), Bg2 = Color3.fromRGB(15, 27, 23), Bg3 = Color3.fromRGB(23, 39, 33),
    Surface = Color3.fromRGB(18, 32, 27), SurfaceHi = Color3.fromRGB(27, 45, 39), SurfacePressed = Color3.fromRGB(31, 53, 45),
    Text = Color3.fromRGB(228, 242, 238), SubText = Color3.fromRGB(142, 171, 161), TextMuted = Color3.fromRGB(90, 119, 109),
    Accent = Color3.fromRGB(52, 211, 153), AccentHi = Color3.fromRGB(97, 226, 180), AccentPressed = Color3.fromRGB(32, 174, 122), AccentMuted = Color3.fromRGB(33, 101, 79),
    Border = Color3.fromRGB(35, 54, 47), BorderHi = Color3.fromRGB(48, 73, 63),
    Success = Color3.fromRGB(92, 212, 139), Warning = Color3.fromRGB(239, 191, 71), Error = Color3.fromRGB(235, 90, 100), Info = Color3.fromRGB(75, 155, 155),
    Shadow = Color3.fromRGB(0, 0, 0),
}

Themes.Rose = {
    Bg = Color3.fromRGB(22, 14, 19), Bg2 = Color3.fromRGB(30, 20, 26), Bg3 = Color3.fromRGB(43, 28, 36),
    Surface = Color3.fromRGB(35, 25, 31), SurfaceHi = Color3.fromRGB(48, 34, 42), SurfacePressed = Color3.fromRGB(57, 40, 49),
    Text = Color3.fromRGB(250, 232, 238), SubText = Color3.fromRGB(190, 155, 171), TextMuted = Color3.fromRGB(132, 99, 114),
    Accent = Color3.fromRGB(244, 114, 182), AccentHi = Color3.fromRGB(255, 143, 199), AccentPressed = Color3.fromRGB(216, 83, 151), AccentMuted = Color3.fromRGB(120, 54, 88),
    Border = Color3.fromRGB(55, 38, 47), BorderHi = Color3.fromRGB(72, 51, 62),
    Success = Color3.fromRGB(120, 200, 150), Warning = Color3.fromRGB(245, 190, 80), Error = Color3.fromRGB(240, 80, 90), Info = Color3.fromRGB(115, 157, 211),
    Shadow = Color3.fromRGB(0, 0, 0),
}

Themes.Monokai = {
    Bg = Color3.fromRGB(29, 29, 25), Bg2 = Color3.fromRGB(37, 37, 32), Bg3 = Color3.fromRGB(49, 49, 42),
    Surface = Color3.fromRGB(41, 41, 35), SurfaceHi = Color3.fromRGB(53, 53, 45), SurfacePressed = Color3.fromRGB(60, 60, 50),
    Text = Color3.fromRGB(248, 248, 242), SubText = Color3.fromRGB(159, 159, 149), TextMuted = Color3.fromRGB(110, 110, 102),
    Accent = Color3.fromRGB(230, 219, 116), AccentHi = Color3.fromRGB(245, 238, 150), AccentPressed = Color3.fromRGB(196, 185, 90), AccentMuted = Color3.fromRGB(105, 100, 53),
    Border = Color3.fromRGB(58, 58, 49), BorderHi = Color3.fromRGB(75, 75, 63),
    Success = Color3.fromRGB(166, 226, 46), Warning = Color3.fromRGB(253, 151, 31), Error = Color3.fromRGB(249, 38, 114), Info = Color3.fromRGB(102, 217, 239),
    Shadow = Color3.fromRGB(0, 0, 0),
}

for _, theme in pairs(Themes) do
    theme.Background = theme.Bg
    theme.BackgroundSecondary = theme.Bg2
    theme.SurfaceHover = theme.SurfaceHi
end

Fluent = {
    Version = "2.0.0",
    Icons = {
        Menu="menu", Close="close", Minimize="minimize", Check="check", CheckCircle="check-circle",
        ChevronDown="chevron-down", ChevronUp="chevron-up", ChevronRight="chevron-right", ChevronLeft="chevron-left",
        ArrowRight="arrow-right", ArrowLeft="arrow-left", ArrowUp="arrow-up", ArrowDown="arrow-down",
        Plus="plus", Minus="minus", Dot="dot", Ring="ring", Search="search", Sliders="sliders", Settings="settings",
        Home="home", User="user", Users="users", Dashboard="dashboard", Folder="folder", File="file", Save="save",
        Download="download", Upload="upload", Refresh="refresh", Trash="trash", Edit="edit", Copy="copy", Bell="bell",
        Info="info", Warning="warning", Error="error", Lock="lock", Unlock="unlock", Eye="eye", EyeOff="eye-off",
        Play="play", Pause="pause", Stop="stop", Volume="volume", Mic="mic", Keyboard="keyboard", Mouse="mouse", Gamepad="gamepad",
        Code="code", Terminal="terminal", Palette="palette", Sun="sun", Moon="moon", Sparkles="sparkles", Star="star", Heart="heart",
        Shield="shield", Zap="zap", Server="server", Globe="globe", Link="link", ExternalLink="external-link", Discord="discord", Github="github",
        Text="text", List="list", Dot="dot", Ring="ring",
        Toggle="sliders", Slider="sliders", Dropdown="list", MultiDropdown="list", Colorpicker="palette", Keybind="keyboard", Textbox="text",
        Button="arrow-right", Paragraph="info", Crosshair="ring", Camera="eye", Rocket="arrow-up", Package="folder", User2="user",
        StarAlt="star", SparklesAlt="sparkles", HeartAlt="heart",
    },
    Themes = Themes,
    Options = {},
    Theme = "Dark",
    Unloaded = false,
}

local function contentPaddingFor(window)
    return window._contentPadding or 16
end

local function formatValue(value, rounding)
    if rounding == 0 then
        return tostring(math.floor(value + 0.5))
    end
    return string.format("%." .. tostring(rounding) .. "f", value)
end

local function elementBase(window, name, height)
    local theme = getTheme(window.Theme)
    local frame = inst("Frame", {
        Name = name,
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Parent = window.Content,
    })
    corner(frame, window._radius)
    local st = stroke(frame, theme.Border, 1)
    bindRole(frame, "BackgroundColor3", "Surface")
    bindRole(st, "Color", "Border")
    return frame
end

local function register(window, object)
    window._registered[#window._registered + 1] = object
    return object
end

local function makeText(parent, props, role)
    local label = inst("TextLabel", props)
    if role then
        bindRole(label, "TextColor3", role)
    end
    return label
end

local function makeLineAccent(parent, theme)
    local line = inst("Frame", {
        Name = "AccentLine",
        Size = UDim2.new(0, 2, 1, -18),
        Position = UDim2.new(0, 0, 0, 9),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = parent,
    })
    corner(line, 2)
    bindRole(line, "BackgroundColor3", "Accent")
    return line
end

function Fluent:CreateToggleButton(cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    if self.ToggleButtonGui and self.ToggleButtonGui.Parent then
        self.ToggleButtonGui:Destroy()
    end

    local gui = inst("ScreenGui", {
        Name = "FluentToggle",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        DisplayOrder = 9999,
        Parent = CoreGui,
    })
    local size = cfg.Size or 48
    local button = inst("ImageButton", {
        Name = "Btn",
        Size = UDim2.fromOffset(size, size),
        Position = cfg.Position or UDim2.new(0, 18, 0.5, -size / 2),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Image = "",
        AutoButtonColor = false,
        ZIndex = 30,
        Parent = gui,
    })
    corner(button, math.floor(size / 2))
    local bstroke = stroke(button, theme.BorderHi, 1)
    bindRole(button, "BackgroundColor3", "Surface")
    bindRole(bstroke, "Color", "BorderHi")
    local sh = shadow(button, theme.Shadow, 0.46, 24)
    sh:SetAttribute("FluentThemeShadow", true)

    local glow = inst("Frame", {
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = button.ZIndex - 1,
        Parent = button,
    })
    corner(glow, math.floor(size / 2))
    bindRole(glow, "BackgroundColor3", "Accent")

    local holder = inst("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = button })
    local barWidth = math.floor(size * .42)
    local x = (size - barWidth) / 2
    local bars = {
        makeLine(holder, theme.Text, barWidth, 2, x + barWidth / 2, size / 2 - 6),
        makeLine(holder, theme.Text, barWidth, 2, x + barWidth / 2, size / 2),
        makeLine(holder, theme.Text, barWidth, 2, x + barWidth / 2, size / 2 + 6),
    }
    for _, bar in ipairs(bars) do
        bindRole(bar, "BackgroundColor3", "Text")
    end

    local openState = false
    local function setOpen(value)
        openState = value and true or false
        if openState then
            tween(bars[1], { Position = UDim2.fromOffset(x + barWidth / 2, size / 2), Rotation = 45 }, .2, Enum.EasingStyle.Quart)
            tween(bars[2], { BackgroundTransparency = 1 }, .12)
            tween(bars[3], { Position = UDim2.fromOffset(x + barWidth / 2, size / 2), Rotation = -45 }, .2, Enum.EasingStyle.Quart)
            tween(glow, { BackgroundTransparency = .78 }, .18)
        else
            tween(bars[1], { Position = UDim2.fromOffset(x + barWidth / 2, size / 2 - 6), Rotation = 0 }, .2, Enum.EasingStyle.Quart)
            tween(bars[2], { BackgroundTransparency = 0 }, .12)
            tween(bars[3], { Position = UDim2.fromOffset(x + barWidth / 2, size / 2 + 6), Rotation = 0 }, .2, Enum.EasingStyle.Quart)
            tween(glow, { BackgroundTransparency = .88 }, .18)
        end
    end

    local hoverIn = button.MouseEnter:Connect(function()
        tween(button, { BackgroundColor3 = theme.SurfaceHi }, .14)
        tween(glow, { BackgroundTransparency = .72 }, .14)
    end)
    local hoverOut = button.MouseLeave:Connect(function()
        tween(button, { BackgroundColor3 = theme.Surface }, .14)
        tween(glow, { BackgroundTransparency = openState and .78 or .88 }, .14)
    end)
    local click = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tween(button, { Size = UDim2.fromOffset(size - 2, size - 2) }, .08, Enum.EasingStyle.Quad)
            task.delay(.08, function()
                if button.Parent then tween(button, { Size = UDim2.fromOffset(size, size) }, .12, Enum.EasingStyle.Back) end
            end)
        end
    end)
    local pressStart
    local dragged = false
    local pressBegan = button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            pressStart = input.Position
            dragged = false
        end
    end)
    local inputChanged = button.InputChanged:Connect(function(input)
        if pressStart and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if (input.Position - pressStart).Magnitude > 6 then dragged = true end
        end
    end)
    local inputEnded = button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if not dragged and cfg.OnClick then task.spawn(cfg.OnClick) end
            pressStart = nil
        end
    end)

    local proxy = { Instance = button, SetOpen = setOpen, Destroy = function() gui:Destroy() end }
    self.ToggleButton = button
    self.ToggleButtonGui = gui
    self.ToggleButtonSetOpen = setOpen
    self.ToggleButtonConnections = { hoverIn, hoverOut, click, pressBegan, inputChanged, inputEnded }
    return proxy
end

function Fluent:CreateWindow(cfg)
    cfg = cfg or {}
    self.Unloaded = false
    local window = setmetatable({}, Window)
    window.Title = cfg.Title or "FluentUI"
    window.SubTitle = cfg.SubTitle or ""
    window.TabWidth = cfg.TabWidth or 188
    window.Size = cfg.Size or UDim2.fromOffset(720, 560)
    window.Theme = cfg.Theme or self.Theme or "Dark"
    window.MinimizeKey = cfg.MinimizeKey or Enum.KeyCode.LeftControl
    window.ToggleKey = cfg.ToggleKey or Enum.KeyCode.RightShift
    window.CornerR = cfg.CornerRadius or 16
    window.Minimized = false
    window.Hidden = false
    window.DialogOpen = false
    window.Tabs = {}
    window.SelectedTab = nil
    window._radius = 12
    window._connections = {}
    window._registered = {}
    window._openPopup = nil
    window._scaleValue = 1
    window._baseWidth = window.Size.X.Offset
    window._baseHeight = window.Size.Y.Offset
    window._minWidth = cfg.MinWidth or 560
    window._minHeight = cfg.MinHeight or 440
    window._contentPadding = 18

    local theme = getTheme(window.Theme)

    window.GUI = inst("ScreenGui", {
        Name = "FluentUI_" .. HttpService:GenerateGUID(false),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        IgnoreGuiInset = true,
        DisplayOrder = 999,
        Parent = CoreGui,
    })
    window.Root = inst("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = window.GUI })

    window.FrameHolder = inst("Frame", {
        Name = "WindowHolder",
        Size = window.Size,
        Position = UDim2.new(.5, -window.Size.X.Offset / 2, .5, -window.Size.Y.Offset / 2),
        BackgroundTransparency = 1,
        Parent = window.Root,
    })
    window.FrameScale = inst("UIScale", { Scale = 1, Parent = window.FrameHolder })
    window.Frame = inst("Frame", {
        Name = "Window",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = theme.Bg,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = window.FrameHolder,
    })
    corner(window.Frame, window.CornerR)
    local frameStroke = stroke(window.Frame, theme.Border, 1)
    bindRole(window.Frame, "BackgroundColor3", "Bg")
    bindRole(frameStroke, "Color", "Border")
    local frameShadow = shadow(window.Frame, theme.Shadow, .48, 34)
    frameShadow:SetAttribute("FluentThemeShadow", true)

    window.TitleBar = inst("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = theme.Bg2,
        BorderSizePixel = 0,
        Parent = window.Frame,
    })
    bindRole(window.TitleBar, "BackgroundColor3", "Bg2")

    local headerBottom = inst("Frame", {
        BackgroundColor3 = theme.Border,
        BackgroundTransparency = .35,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, -1),
        Parent = window.TitleBar,
    })
    bindRole(headerBottom, "BackgroundColor3", "Border")

    local accentLine = inst("Frame", {
        Size = UDim2.new(0, 2, 1, -22),
        Position = UDim2.fromOffset(0, 11),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = window.TitleBar,
    })
    corner(accentLine, 2)
    bindRole(accentLine, "BackgroundColor3", "Accent")

    local brand = inst("Frame", {
        Size = UDim2.fromOffset(36, 36),
        Position = UDim2.fromOffset(16, 12),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = window.TitleBar,
    })
    corner(brand, 11)
    bindRole(brand, "BackgroundColor3", "Accent")
    local brandSheen = inst("Frame", {
        BackgroundColor3 = theme.AccentHi,
        BackgroundTransparency = .77,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Parent = brand,
    })
    corner(brandSheen, 11)
    bindRole(brandSheen, "BackgroundColor3", "AccentHi")
    local brandIcon = makeIcon(brand, cfg.Icon or "sparkles", 17, Color3.new(1, 1, 1))
    brandIcon.Position = UDim2.fromOffset(9, 9)

    window.TitleLabel = makeText(window.TitleBar, {
        Text = window.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(64, window.SubTitle ~= "" and 9 or 17),
        Size = UDim2.new(1, -175, 0, 20),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = window.TitleBar,
    }, "Text")
    window.SubTitleLabel = makeText(window.TitleBar, {
        Text = window.SubTitle,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(64, 31),
        Size = UDim2.new(1, -175, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Visible = window.SubTitle ~= "",
        Parent = window.TitleBar,
    }, "SubText")

    window._controlButtons = {}
    local function control(name, iconName, rightOffset, hoverRole)
        local holder = inst("Frame", {
            Size = UDim2.fromOffset(34, 34),
            Position = UDim2.new(1, rightOffset, .5, -17),
            BackgroundTransparency = 1,
            Parent = window.TitleBar,
        })
        local button = inst("TextButton", {
            Text = "",
            BackgroundColor3 = theme.Surface,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Size = UDim2.fromScale(1, 1),
            Parent = holder,
        })
        corner(button, 10)
        local icon = makeIcon(holder, iconName, 14, theme.SubText)
        icon.Position = UDim2.fromOffset(10, 10)
        icon.ZIndex = button.ZIndex + 1
        button.MouseEnter:Connect(function()
            tween(button, { BackgroundColor3 = hoverRole == "Error" and theme.Error or theme.SurfaceHi, BackgroundTransparency = .06 }, .13)
            setIconColor(icon, hoverRole == "Error" and theme.Error or theme.Text)
        end)
        button.MouseLeave:Connect(function()
            tween(button, { BackgroundTransparency = 1 }, .13)
            setIconColor(icon, theme.SubText)
        end)
        window._controlButtons[name] = { Button = button, Icon = icon }
        return button
    end
    window.MinBtn = control("Minimize", "minimize", -76, "Text")
    window.CloseBtn = control("Close", "close", -38, "Error")

    local bodyTop = 60
    window.Sidebar = inst("Frame", {
        Name = "Sidebar",
        Size = UDim2.new(0, window.TabWidth, 1, -bodyTop),
        Position = UDim2.fromOffset(0, bodyTop),
        BackgroundColor3 = theme.Bg2,
        BorderSizePixel = 0,
        Parent = window.Frame,
    })
    bindRole(window.Sidebar, "BackgroundColor3", "Bg2")

    window.TabHeader = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 48),
        BackgroundTransparency = 1,
        Parent = window.Sidebar,
    })
    makeText(window.TabHeader, {
        Text = "NAVIGATION",
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = theme.TextMuted,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(17, 17),
        Size = UDim2.new(1, -34, 0, 14),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = window.TabHeader,
    }, "TextMuted")

    window.TabList = inst("ScrollingFrame", {
        Name = "Tabs",
        Size = UDim2.new(1, 0, 1, -48),
        Position = UDim2.fromOffset(0, 48),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.Border,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = window.Sidebar,
    })
    local tabPadding = padding(window.TabList, 6, 12, 10, 10)
    bindRole(tabPadding, "BackgroundColor3", "Bg2")
    inst("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder, Parent = window.TabList })

    window.Divider = inst("Frame", {
        Size = UDim2.new(0, 1, 1, -bodyTop),
        Position = UDim2.fromOffset(window.TabWidth, bodyTop),
        BackgroundColor3 = theme.Border,
        BackgroundTransparency = .2,
        BorderSizePixel = 0,
        Parent = window.Frame,
    })
    bindRole(window.Divider, "BackgroundColor3", "Border")

    window.Content = inst("ScrollingFrame", {
        Name = "Content",
        Size = UDim2.new(1, -window.TabWidth, 1, -bodyTop),
        Position = UDim2.fromOffset(window.TabWidth, bodyTop),
        BackgroundColor3 = theme.Bg,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = theme.BorderHi,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = window.Frame,
    })
    bindRole(window.Content, "BackgroundColor3", "Bg")
    padding(window.Content, window._contentPadding, window._contentPadding, window._contentPadding, window._contentPadding)
    inst("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = window.Content })

    window.PopupLayer = inst("Frame", {
        Name = "PopupLayer",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 200,
        Parent = window.Root,
    })

    window.NotifyBox = inst("Frame", {
        Name = "Notifications",
        Size = UDim2.fromOffset(360, 1),
        AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.new(1, -374, 0, 18),
        BackgroundTransparency = 1,
        ZIndex = 300,
        Parent = window.GUI,
    })
    inst("UIListLayout", {
        Padding = UDim.new(0, 9),
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = window.NotifyBox,
    })

    window.DialogLayer = inst("TextButton", {
        Name = "DialogLayer",
        Text = "",
        AutoButtonColor = false,
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 500,
        Parent = window.GUI,
    })
    window.DialogLayer:SetAttribute("FluentDialogBackdrop", true)

    local function closePopup()
        local popup = window._openPopup
        if popup and popup.Close then
            popup:Close()
        end
        window._openPopup = nil
    end

    local outsideClick = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local popup = window._openPopup
            if popup and popup.Button and popup.Button.Parent and input.Position then
                local p = popup.Button.AbsolutePosition
                local s = popup.Button.AbsoluteSize
                local inside = input.Position.X >= p.X and input.Position.X <= p.X + s.X and input.Position.Y >= p.Y and input.Position.Y <= p.Y + s.Y
                if not inside then closePopup() end
            end
        end
    end)
    table.insert(window._connections, outsideClick)

    local keyInput = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or window._destroyed then return end
        if input.KeyCode == window.MinimizeKey then
            window:ToggleMinimize()
        elseif input.KeyCode == window.ToggleKey then
            window:ToggleVisibility()
        end
    end)
    table.insert(window._connections, keyInput)

    local viewportChanged = workspace.CurrentCamera and workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        window:_updateResponsiveScale()
    end)
    if viewportChanged then table.insert(window._connections, viewportChanged) end

    window.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            window._draggingWindow = true
        end
    end)

    draggable(window, window.FrameHolder, window.TitleBar, { minX = 6, maxX = 6, minY = 6, maxY = 6 })

    window.MinBtn.MouseButton1Click:Connect(function() window:ToggleMinimize() end)
    window.CloseBtn.MouseButton1Click:Connect(function() window:Destroy() end)

    function window:_syncPopup(popup, button)
        if not popup or not popup.Parent or not button or not button.Parent then return end
        local rootPosition = self.GUI.AbsolutePosition
        local p = button.AbsolutePosition
        local s = button.AbsoluteSize
        local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
        local preferredY = p.Y + s.Y + 7 - rootPosition.Y
        local popupHeight = popup.AbsoluteSize.Y
        if preferredY + popupHeight > viewport.Y - 10 then
            preferredY = p.Y - popupHeight - 7 - rootPosition.Y
        end
        local x = math.clamp(p.X - rootPosition.X, 8, viewport.X - popup.AbsoluteSize.X - 8)
        popup.Position = UDim2.fromOffset(x, math.max(8, preferredY))
    end

    window._updateResponsiveScale = function(self)
        local camera = workspace.CurrentCamera
        if not camera or not self.FrameHolder.Parent then return end
        local viewport = camera.ViewportSize
        local fitX = (viewport.X - 28) / self._baseWidth
        local fitY = (viewport.Y - 28) / self._baseHeight
        local fit = math.min(fitX, fitY)
        local responsive = math.clamp(fit, .72, 1.12)
        if viewport.X < 760 then
            responsive = math.min(responsive, .88)
        end
        self._responsiveScale = responsive
        self.FrameScale.Scale = responsive * self._scaleValue
        self.FrameHolder.Size = UDim2.fromOffset(self._baseWidth, self._baseHeight)
        self.FrameHolder.Position = UDim2.new(.5, -self._baseWidth / 2, .5, -self._baseHeight / 2)
    end

    function window:SetUIScale(value)
        value = math.clamp((tonumber(value) or 100) / 100, .72, 1.22)
        self._scaleValue = value
        self:_updateResponsiveScale()
    end

    window:_updateResponsiveScale()

    window.ToggleBtnHandle = Fluent:CreateToggleButton({ OnClick = function() window:ToggleVisibility() end })
    window._syncToggle = function(value)
        if window.ToggleBtnHandle and window.ToggleBtnHandle.SetOpen then
            window.ToggleBtnHandle.SetOpen(value)
        end
    end
    window._syncToggle(true)

    Fluent.Window = window
    self.Window = window
    return window
end

function Window:ToggleVisibility(force)
    if self._destroyed then return end
    self.Hidden = force ~= nil and force or not self.Hidden
    local visible = not self.Hidden
    if visible then
        self.Root.Visible = true
        self.FrameHolder.Size = UDim2.fromOffset(self._baseWidth * .95, self._baseHeight * .95)
        self.FrameScale.Scale = (self._responsiveScale or 1) * self._scaleValue * .95
        tween(self.FrameHolder, {
            Size = UDim2.fromOffset(self._baseWidth, self._baseHeight),
        }, .22, Enum.EasingStyle.Quart)
        local fake = { Value = (self._responsiveScale or 1) * self._scaleValue * .95 }
        tween(self.FrameScale, {
            Scale = (self._responsiveScale or 1) * self._scaleValue,
        }, .24, Enum.EasingStyle.Quart)
        fake = nil
    else
        tween(self.FrameScale, { Scale = (self._responsiveScale or 1) * self._scaleValue * .95 }, .18, Enum.EasingStyle.Quart)
        task.delay(.18, function()
            if self.Hidden and self.Root.Parent then self.Root.Visible = false end
        end)
    end
    if self._syncToggle then self._syncToggle(visible) end
end

function Window:ToggleMinimize()
    if self._destroyed then return end
    self.Minimized = not self.Minimized
    if self.Minimized then
        tween(self.FrameHolder, { Size = UDim2.fromOffset(self._baseWidth, 60) }, .24, Enum.EasingStyle.Quart)
        tween(self.FrameScale, { Scale = (self._responsiveScale or 1) * self._scaleValue }, .18)
        self.Sidebar.Visible = false
        self.Divider.Visible = false
        self.Content.Visible = false
    else
        self.Sidebar.Visible = true
        self.Divider.Visible = true
        self.Content.Visible = true
        tween(self.FrameHolder, { Size = UDim2.fromOffset(self._baseWidth, self._baseHeight) }, .26, Enum.EasingStyle.Quart)
    end
end

function Window:AddTab(cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    local tab = {
        Title = cfg.Title or "Tab",
        Icon = cfg.Icon,
        Window = self,
        Elements = {},
        LayoutOrder = #self.Tabs + 1,
    }

    tab.Button = inst("TextButton", {
        Name = tab.Title,
        Text = "",
        AutoButtonColor = false,
        BackgroundColor3 = theme.Bg2,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 44),
        LayoutOrder = tab.LayoutOrder,
        Parent = self.TabList,
    })
    corner(tab.Button, 10)
    bindRole(tab.Button, "BackgroundColor3", "Bg3")

    tab.Indicator = inst("Frame", {
        Size = UDim2.new(0, 3, 0, 20),
        Position = UDim2.new(0, 0, .5, -10),
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = tab.Button,
    })
    corner(tab.Indicator, 2)
    bindRole(tab.Indicator, "BackgroundColor3", "Accent")

    local iconOffset = 0
    if tab.Icon then
        tab.IconImg = makeIcon(tab.Button, tab.Icon, 17, theme.TextMuted)
        tab.IconImg.Position = UDim2.fromOffset(16, 13)
        iconOffset = 31
    end

    tab.Label = makeText(tab.Button, {
        Text = tab.Title,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15 + iconOffset, 0),
        Size = UDim2.new(1, -(21 + iconOffset), 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = tab.Button,
    }, "SubText")

    tab.HoverAccent = inst("Frame", {
        Size = UDim2.fromOffset(2, 16),
        Position = UDim2.new(1, -2, .5, -8),
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = tab.Button,
    })
    corner(tab.HoverAccent, 2)
    bindRole(tab.HoverAccent, "BackgroundColor3", "Accent")

    table.insert(self.Tabs, tab)

    tab.Button.MouseEnter:Connect(function()
        if self.SelectedTab ~= tab then
            tween(tab.Button, { BackgroundTransparency = .35, BackgroundColor3 = theme.SurfaceHi }, .14)
            setIconColor(tab.IconImg, theme.Text)
        end
    end)
    tab.Button.MouseLeave:Connect(function()
        if self.SelectedTab ~= tab then
            tween(tab.Button, { BackgroundTransparency = 1, BackgroundColor3 = theme.Bg2 }, .14)
            setIconColor(tab.IconImg, theme.SubText)
        end
    end)
    tab.Button.MouseButton1Click:Connect(function() self:SelectTab(tab) end)

    local function withTab(fn)
        local previous = self.SelectedTab
        if self.SelectedTab ~= tab then self:SelectTab(tab) end
        local result = fn()
        if previous and previous ~= tab then self:SelectTab(previous) end
        return result
    end
    function tab:AddSection(name) return withTab(function() return self.Window:AddSection(name) end) end
    function tab:AddParagraph(cfg2) return withTab(function() return self.Window:AddParagraph(cfg2) end) end
    function tab:AddButton(cfg2) return withTab(function() return self.Window:AddButton(cfg2) end) end
    function tab:AddToggle(id, cfg2) return withTab(function() return self.Window:AddToggle(id, cfg2) end) end
    function tab:AddSlider(id, cfg2) return withTab(function() return self.Window:AddSlider(id, cfg2) end) end
    function tab:AddDropdown(id, cfg2) return withTab(function() return self.Window:AddDropdown(id, cfg2) end) end
    function tab:AddColorpicker(id, cfg2) return withTab(function() return self.Window:AddColorpicker(id, cfg2) end) end
    function tab:AddKeybind(id, cfg2) return withTab(function() return self.Window:AddKeybind(id, cfg2) end) end
    function tab:AddTextbox(id, cfg2) return withTab(function() return self.Window:AddTextbox(id, cfg2) end) end

    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    return tab
end

function Window:SelectTab(tab)
    local theme = getTheme(self.Theme)
    if not tab then return end
    self.SelectedTab = tab
    for _, item in ipairs(self.Tabs) do
        local active = item == tab
        tween(item.Button, {
            BackgroundTransparency = active and 0 or 1,
            BackgroundColor3 = active and theme.Bg3 or theme.Bg2,
        }, .18)
        tween(item.Label, { TextColor3 = active and theme.Text or theme.SubText }, .16)
        if item.IconImg then setIconColor(item.IconImg, active and theme.Accent or theme.SubText) end
        tween(item.Indicator, {
            Size = UDim2.new(0, 3, 0, active and 22 or 10),
            BackgroundTransparency = active and 0 or 1,
        }, .2, Enum.EasingStyle.Quart)
        tween(item.HoverAccent, { BackgroundTransparency = active and 1 or 1 }, .16)
    end
    for _, child in ipairs(self.Content:GetChildren()) do
        if child:IsA("GuiObject") and not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child.Visible = false
        end
    end
    for _, object in ipairs(tab.Elements) do
        if object.Instance then object.Instance.Visible = true end
    end
end

local function push(window, object)
    if window.SelectedTab then
        table.insert(window.SelectedTab.Elements, object)
    end
    return object
end

function Window:AddSection(name)
    local theme = getTheme(self.Theme)
    local section = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = self.Content,
    })
    local line = inst("Frame", {
        Size = UDim2.fromOffset(2, 12),
        Position = UDim2.fromOffset(1, 9),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = section,
    })
    corner(line, 2)
    bindRole(line, "BackgroundColor3", "Accent")
    makeText(section, {
        Text = string.upper(tostring(name or "SECTION")),
        Font = Enum.Font.GothamBold,
        TextSize = 9,
        TextColor3 = theme.TextMuted,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 5),
        Size = UDim2.new(1, -12, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section,
    }, "TextMuted")
    return push(self, { Instance = section })
end

function Window:AddParagraph(cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    local content = tostring(cfg.Content or "")
    local lines = math.max(1, math.ceil(#content / 86))
    local height = math.clamp(58 + lines * 13, 64, 120)
    local frame = elementBase(self, "Paragraph", height)
    local icon = makeIcon(frame, cfg.Icon or "info", 16, theme.Accent)
    icon.Position = UDim2.fromOffset(16, 15)
    makeText(frame, {
        Text = cfg.Title or "Paragraph",
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(45, 12),
        Size = UDim2.new(1, -61, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    }, "Text")
    makeText(frame, {
        Text = content,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(16, 35),
        Size = UDim2.new(1, -32, 1, -42),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = frame,
    }, "SubText")
    return push(self, { Instance = frame })
end

function Window:AddButton(cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    local h = cfg.Description and 60 or 46
    local button = inst("TextButton", {
        Text = "",
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, h),
        AutoButtonColor = false,
        Parent = self.Content,
    })
    corner(button, self._radius)
    local st = stroke(button, theme.Border, 1)
    bindRole(button, "BackgroundColor3", "Surface")
    bindRole(st, "Color", "Border")

    local icon = makeIcon(button, cfg.Icon or "arrow-right", 16, theme.Accent)
    icon.Position = UDim2.fromOffset(16, h / 2 - 8)
    makeText(button, {
        Text = cfg.Title or "Button",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(45, cfg.Description and 10 or 0),
        Size = UDim2.new(1, -92, 0, cfg.Description and 18 or h),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = cfg.Description and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = button,
    }, "Text")
    if cfg.Description then
        makeText(button, {
            Text = cfg.Description,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextColor3 = theme.SubText,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(45, 31),
            Size = UDim2.new(1, -92, 0, 15),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = button,
        }, "SubText")
    end
    local chevron = makeIcon(button, "chevron-right", 14, theme.TextMuted)
    chevron.Position = UDim2.new(1, -31, .5, -7)

    button.MouseEnter:Connect(function()
        tween(button, { BackgroundColor3 = theme.SurfaceHi }, .14)
        tween(icon, { Position = UDim2.fromOffset(18, h / 2 - 8) }, .16)
        setIconColor(chevron, theme.Text)
    end)
    button.MouseLeave:Connect(function()
        tween(button, { BackgroundColor3 = theme.Surface }, .14)
        tween(icon, { Position = UDim2.fromOffset(16, h / 2 - 8) }, .16)
        setIconColor(chevron, theme.TextMuted)
    end)
    local connection = ripple(button, theme.Accent)
    table.insert(self._connections, connection)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            tween(button, { BackgroundColor3 = theme.SurfacePressed }, .07)
        end
    end)
    button.MouseButton1Click:Connect(function()
        if cfg.Callback then task.spawn(cfg.Callback) end
        task.delay(.07, function() if button.Parent then tween(button, { BackgroundColor3 = theme.SurfaceHi }, .09) end end)
    end)
    return push(self, { Instance = button })
end

function Window:AddToggle(id, cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    local toggle = {
        Value = cfg.Default and true or false,
        Callbacks = {},
    }
    local h = cfg.Description and 60 or 46
    local frame = elementBase(self, id or "Toggle", h)
    local icon = makeIcon(frame, cfg.Icon or "sliders", 16, theme.Accent)
    icon.Position = UDim2.fromOffset(16, h / 2 - 8)
    makeText(frame, {
        Text = cfg.Title or id or "Toggle",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(45, cfg.Description and 10 or 0),
        Size = UDim2.new(1, -112, 0, cfg.Description and 18 or h),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = cfg.Description and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center,
        Parent = frame,
    }, "Text")
    if cfg.Description then
        makeText(frame, {
            Text = cfg.Description,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextColor3 = theme.SubText,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(45, 31),
            Size = UDim2.new(1, -112, 0, 15),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = frame,
        }, "SubText")
    end

    local track = inst("Frame", {
        Size = UDim2.fromOffset(44, 24),
        Position = UDim2.new(1, -60, .5, -12),
        BackgroundColor3 = toggle.Value and theme.Accent or theme.BorderHi,
        BorderSizePixel = 0,
        Parent = frame,
    })
    corner(track, 12)
    bindRole(track, "BackgroundColor3", toggle.Value and "Accent" or "BorderHi")
    local trackGlow = inst("Frame", {
        BackgroundColor3 = theme.Accent,
        BackgroundTransparency = toggle.Value and .84 or 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Parent = track,
    })
    corner(trackGlow, 12)
    bindRole(trackGlow, "BackgroundColor3", "Accent")
    local knob = inst("Frame", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(0, toggle.Value and 24 or 2, .5, -9),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(knob, 9)
    local knobStroke = stroke(knob, theme.Border, 1)
    bindRole(knobStroke, "Color", "Border")
    local click = inst("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Parent = frame,
    })

    local function setValue(value, invoke)
        value = value and true or false
        toggle.Value = value
        setRole(track, value and "Accent" or "BorderHi")
        tween(track, { BackgroundColor3 = value and theme.Accent or theme.BorderHi }, .18)
        tween(trackGlow, { BackgroundTransparency = value and .84 or 1 }, .18)
        tween(knob, { Position = UDim2.new(0, value and 24 or 2, .5, -9) }, .2, Enum.EasingStyle.Quart)
        if invoke ~= false then
            for _, cb in ipairs(toggle.Callbacks) do task.spawn(cb, value) end
            if cfg.Callback then task.spawn(cfg.Callback, value) end
        end
    end
    click.MouseButton1Click:Connect(function() setValue(not toggle.Value) end)

    toggle.Instance = frame
    toggle.SetValue = function(v) setValue(v, true) end
    toggle.GetValue = function() return toggle.Value end
    toggle.OnChanged = function(cb) if type(cb) == "function" then table.insert(toggle.Callbacks, cb) end end
    Fluent.Options[id] = toggle
    return push(self, toggle)
end

function Window:AddSlider(id, cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    local minValue, maxValue = tonumber(cfg.Min) or 0, tonumber(cfg.Max) or 100
    if maxValue < minValue then minValue, maxValue = maxValue, minValue end
    local rounding = tonumber(cfg.Rounding) or 0
    local slider = { Value = tonumber(cfg.Default) or minValue, Callbacks = {} }
    slider.Value = math.clamp(slider.Value, minValue, maxValue)
    local frame = elementBase(self, id or "Slider", 74)

    makeIcon(frame, cfg.Icon or "sliders", 16, theme.Accent).Position = UDim2.fromOffset(16, 11)
    makeText(frame, {
        Text = cfg.Title or id or "Slider",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(45, 10),
        Size = UDim2.new(1, -110, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame,
    }, "Text")
    local valueLabel = makeText(frame, {
        Text = formatValue(slider.Value, rounding),
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        TextColor3 = theme.Accent,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -76, 0, 10),
        Size = UDim2.fromOffset(58, 18),
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = frame,
    }, "Accent")

    local track = inst("Frame", {
        Size = UDim2.new(1, -32, 0, 6),
        Position = UDim2.fromOffset(16, 50),
        BackgroundColor3 = theme.Border,
        BorderSizePixel = 0,
        Parent = frame,
    })
    corner(track, 3)
    bindRole(track, "BackgroundColor3", "Border")
    local ratio = (slider.Value - minValue) / math.max(1e-9, maxValue - minValue)
    local fill = inst("Frame", {
        Size = UDim2.new(ratio, 0, 1, 0),
        BackgroundColor3 = theme.Accent,
        BorderSizePixel = 0,
        Parent = track,
    })
    corner(fill, 3)
    bindRole(fill, "BackgroundColor3", "Accent")
    local knob = inst("Frame", {
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(ratio, -8, .5, -8),
        BackgroundColor3 = theme.SurfaceHi,
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = track,
    })
    corner(knob, 8)
    local kstroke = stroke(knob, theme.Accent, 2)
    bindRole(knob, "BackgroundColor3", "SurfaceHi")
    bindRole(kstroke, "Color", "Accent")
    local hit = inst("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 18, 1, 20),
        Position = UDim2.fromOffset(-9, -10),
        Parent = track,
    })

    local dragging = false
    local function updateFromPosition(x, invoke)
        local width = math.max(1, track.AbsoluteSize.X)
        local relative = math.clamp((x - track.AbsolutePosition.X) / width, 0, 1)
        local value = minValue + (maxValue - minValue) * relative
        value = roundNumber(value, rounding)
        value = math.clamp(value, minValue, maxValue)
        slider.Value = value
        local p = (value - minValue) / math.max(1e-9, maxValue - minValue)
        valueLabel.Text = formatValue(value, rounding)
        tween(fill, { Size = UDim2.new(p, 0, 1, 0) }, .07, Enum.EasingStyle.Linear)
        tween(knob, { Position = UDim2.new(p, -8, .5, -8) }, .08, Enum.EasingStyle.Quart)
        if invoke ~= false then
            for _, cb in ipairs(slider.Callbacks) do task.spawn(cb, value) end
            if cfg.Callback then task.spawn(cfg.Callback, value) end
        end
    end
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromPosition(input.Position.X, true)
        end
    end)
    local inputChanged = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateFromPosition(input.Position.X, true)
        end
    end)
    local inputEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    table.insert(self._connections, inputChanged)
    table.insert(self._connections, inputEnded)

    hit.MouseEnter:Connect(function() tween(kstroke, { Thickness = 2.6 }, .12) end)
    hit.MouseLeave:Connect(function() tween(kstroke, { Thickness = 2 }, .12) end)

    slider.Instance = frame
    slider.SetValue = function(v, invoke)
        v = math.clamp(tonumber(v) or minValue, minValue, maxValue)
        updateFromPosition(track.AbsolutePosition.X + track.AbsoluteSize.X * ((v - minValue) / math.max(1e-9, maxValue - minValue)), invoke ~= false)
    end
    slider.GetValue = function() return slider.Value end
    slider.OnChanged = function(cb) if type(cb) == "function" then table.insert(slider.Callbacks, cb) end end
    Fluent.Options[id] = slider
    return push(self, slider)
end

function Window:AddDropdown(id, cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    local multi = cfg.Multi and true or false
    local values = cfg.Values or {}
    local initial = cfg.Default
    if multi then
        initial = type(initial) == "table" and table.clone(initial) or {}
    end
    local dropdown = { Value = initial, Options = values, Multi = multi, Callbacks = {}, Expanded = false }
    local frame = elementBase(self, id or "Dropdown", 46)
    frame.ClipsDescendants = false

    makeIcon(frame, cfg.Icon or "list", 16, theme.Accent).Position = UDim2.fromOffset(16, 15)
    makeText(frame, {
        Text = cfg.Title or id or "Dropdown",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(45, 0),
        Size = UDim2.new(1, -185, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    }, "Text")
    local preview = makeText(frame, {
        Text = "Select...",
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = theme.TextMuted,
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -145, 0, 0),
        Size = UDim2.fromOffset(105, 46),
        TextXAlignment = Enum.TextXAlignment.Right,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = frame,
    }, "TextMuted")
    local arrow = makeIcon(frame, "chevron-down", 14, theme.TextMuted)
    arrow.Position = UDim2.new(1, -33, .5, -7)

    local popup = inst("Frame", {
        Size = UDim2.fromOffset(240, 0),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = theme.Bg3,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 205,
        Parent = self.PopupLayer,
    })
    corner(popup, 12)
    local pstroke = stroke(popup, theme.BorderHi, 1)
    bindRole(popup, "BackgroundColor3", "Bg3")
    bindRole(pstroke, "Color", "BorderHi")
    local pshadow = shadow(popup, theme.Shadow, .44, 28)
    pshadow:SetAttribute("FluentThemeShadow", true)

    local popupPadding = padding(popup, 8, 8, 8, 8)
    local list = inst("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = theme.BorderHi,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        CanvasSize = UDim2.new(),
        Parent = popup,
    })
    inst("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = list })
    padding(list, 1, 1, 0, 0)

    local searchBox
    if cfg.Searchable ~= false and #values > 6 then
        searchBox = inst("TextBox", {
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = theme.Surface,
            BorderSizePixel = 0,
            ClearTextOnFocus = false,
            Text = "",
            PlaceholderText = "Search options",
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextColor3 = theme.Text,
            PlaceholderColor3 = theme.TextMuted,
            Parent = list,
        })
        corner(searchBox, 8)
        local ss = stroke(searchBox, theme.Border, 1)
        bindRole(searchBox, "BackgroundColor3", "Surface")
        bindRole(searchBox, "TextColor3", "Text")
        bindRole(ss, "Color", "Border")
        searchBox.ZIndex = 206
    end

    local optionButtons = {}
    local render
    local function valueContains(value)
        if multi then return table.find(dropdown.Value, value) ~= nil end
        return dropdown.Value == value
    end
    local function updatePreview()
        if multi then
            preview.Text = #dropdown.Value > 0 and table.concat(dropdown.Value, ", ") or "Select..."
            preview.TextColor3 = #dropdown.Value > 0 and theme.Text or theme.TextMuted
        elseif dropdown.Value ~= nil then
            preview.Text = tostring(dropdown.Value)
            preview.TextColor3 = theme.Text
        else
            preview.Text = "Select..."
            preview.TextColor3 = theme.TextMuted
        end
    end

    render = function(filter)
        for _, button in ipairs(optionButtons) do
            if button and button.Parent then button:Destroy() end
        end
        optionButtons = {}
        filter = tostring(filter or ""):lower()
        for index, option in ipairs(values) do
            local valueText = tostring(option)
            if filter == "" or string.find(valueText:lower(), filter, 1, true) then
                local selected = valueContains(option)
                local optionButton = inst("TextButton", {
                    Text = "",
                    AutoButtonColor = false,
                    BackgroundColor3 = selected and theme.AccentMuted or theme.Bg3,
                    BorderSizePixel = 0,
                    Size = UDim2.new(1, 0, 0, 32),
                    LayoutOrder = index,
                    ZIndex = 207,
                    Parent = list,
                })
                corner(optionButton, 8)
                local label = makeText(optionButton, {
                    Text = valueText,
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextColor3 = selected and theme.Text or theme.SubText,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(10, 0),
                    Size = UDim2.new(1, -43, 1, 0),
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    ZIndex = 208,
                    Parent = optionButton,
                }, selected and "Text" or "SubText")
                if selected then
                    local check = makeIcon(optionButton, "check", 13, theme.AccentHi)
                    check.Position = UDim2.new(1, -24, .5, -6.5)
                    check.ZIndex = 208
                end
                optionButton.MouseEnter:Connect(function()
                    if not selected then tween(optionButton, { BackgroundColor3 = theme.SurfaceHi }, .12) end
                end)
                optionButton.MouseLeave:Connect(function()
                    if not selected then tween(optionButton, { BackgroundColor3 = theme.Bg3 }, .12) end
                end)
                optionButton.MouseButton1Click:Connect(function()
                    if multi then
                        local found = table.find(dropdown.Value, option)
                        if found then table.remove(dropdown.Value, found) else table.insert(dropdown.Value, option) end
                        updatePreview()
                        for _, cb in ipairs(dropdown.Callbacks) do task.spawn(cb, dropdown.Value) end
                        if cfg.Callback then task.spawn(cfg.Callback, dropdown.Value) end
                        render(searchBox and searchBox.Text or "")
                    else
                        dropdown.Value = option
                        updatePreview()
                        for _, cb in ipairs(dropdown.Callbacks) do task.spawn(cb, option) end
                        if cfg.Callback then task.spawn(cfg.Callback, option) end
                        dropdown:Close()
                    end
                end)
                table.insert(optionButtons, optionButton)
            end
        end
    end

    dropdown.Instance = frame
    dropdown.Button = frame
    dropdown.Popup = popup

    local selfWindow = self
    function dropdown:Close()
        if not self.Expanded then return end
        self.Expanded = false
        if selfWindow._openPopup == self then selfWindow._openPopup = nil end
        tween(arrow, { Rotation = 0 }, .16)
        tween(popup, { Size = UDim2.fromOffset(240, 0) }, .16)
        task.delay(.17, function()
            if popup.Parent and not self.Expanded then popup.Visible = false end
        end)
    end
    function dropdown:Toggle()
        if self.Expanded then
            self:Close()
            return
        end
        if selfWindow._openPopup and selfWindow._openPopup ~= self then
            selfWindow._openPopup:Close()
        end
        self.Expanded = true
        selfWindow._openPopup = self
        popup.Visible = true
        popup.Size = UDim2.fromOffset(240, 0)
        local visibleRows = math.min(#values, 7)
        local targetHeight = math.max(40, visibleRows * 35 + (searchBox and 35 or 0) + 16)
        if #values == 0 then targetHeight = 56 end
        selfWindow:_syncPopup(popup, frame)
        tween(popup, { Size = UDim2.fromOffset(240, targetHeight) }, .2, Enum.EasingStyle.Quart)
        tween(arrow, { Rotation = 180 }, .2)
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            self:Toggle()
        end
    end)

    if searchBox then
        searchBox:GetPropertyChangedSignal("Text"):Connect(function() render(searchBox.Text) end)
    end
    render()
    updatePreview()

    dropdown.SetValue = function(v)
        if multi then dropdown.Value = type(v) == "table" and table.clone(v) or {} else dropdown.Value = v end
        updatePreview()
        render(searchBox and searchBox.Text or "")
    end
    dropdown.GetValue = function() return dropdown.Value end
    dropdown.OnChanged = function(cb) if type(cb) == "function" then table.insert(dropdown.Callbacks, cb) end end
    Fluent.Options[id] = dropdown
    return push(self, dropdown)
end

function Window:AddColorpicker(id, cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    local picker = { Value = cfg.Default or Color3.fromRGB(99, 102, 241), Callbacks = {}, Expanded = false }
    local frame = elementBase(self, id or "Colorpicker", 46)
    frame.ClipsDescendants = false

    makeIcon(frame, cfg.Icon or "palette", 16, theme.Accent).Position = UDim2.fromOffset(16, 15)
    makeText(frame, {
        Text = cfg.Title or id or "Color",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(45, 0),
        Size = UDim2.new(1, -120, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    }, "Text")
    local preview = inst("Frame", {
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, -42, .5, -13),
        BackgroundColor3 = picker.Value,
        BorderSizePixel = 0,
        Parent = frame,
    })
    corner(preview, 8)
    local previewStroke = stroke(preview, theme.BorderHi, 1)
    bindRole(previewStroke, "Color", "BorderHi")

    local popup = inst("Frame", {
        Size = UDim2.fromOffset(256, 0),
        BackgroundColor3 = theme.Bg3,
        BorderSizePixel = 0,
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 215,
        Parent = self.PopupLayer,
    })
    corner(popup, 12)
    local ps = stroke(popup, theme.BorderHi, 1)
    bindRole(popup, "BackgroundColor3", "Bg3")
    bindRole(ps, "Color", "BorderHi")
    local pshadow = shadow(popup, theme.Shadow, .44, 28)
    pshadow:SetAttribute("FluentThemeShadow", true)
    padding(popup, 10, 10, 10, 10)

    local saturation = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 118),
        BackgroundColor3 = Color3.fromRGB(255, 0, 0),
        BorderSizePixel = 0,
        Parent = popup,
        ZIndex = 216,
    })
    corner(saturation, 9)
    inst("UIGradient", {
        Rotation = 0,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.new(1, 0, 0)),
        }),
        Parent = saturation,
    })
    local valueShade = inst("Frame", {
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = .3,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Parent = saturation,
        ZIndex = 217,
    })
    corner(valueShade, 9)
    inst("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0)),
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, .02),
        }),
        Parent = valueShade,
    })
    local satKnob = inst("Frame", {
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 218,
        Parent = saturation,
    })
    corner(satKnob, 7)
    local satStroke = stroke(satKnob, theme.Text, 1.5)
    bindRole(satStroke, "Color", "Text")

    local hue = inst("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.fromOffset(0, 128),
        BackgroundColor3 = Color3.new(1, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 216,
        Parent = popup,
    })
    corner(hue, 7)
    inst("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(.50, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
        }),
        Parent = hue,
    })
    local hueKnob = inst("Frame", {
        Size = UDim2.fromOffset(12, 18),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 218,
        Parent = hue,
    })
    corner(hueKnob, 6)
    local hueStroke = stroke(hueKnob, theme.Text, 1.4)
    bindRole(hueStroke, "Color", "Text")

    local hex = inst("TextBox", {
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.fromOffset(0, 151),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Text = toHex(picker.Value),
        PlaceholderText = "#RRGGBB",
        Font = Enum.Font.Code,
        TextSize = 12,
        TextColor3 = theme.Text,
        PlaceholderColor3 = theme.TextMuted,
        ZIndex = 216,
        Parent = popup,
    })
    corner(hex, 8)
    local hexStroke = stroke(hex, theme.Border, 1)
    bindRole(hex, "BackgroundColor3", "Surface")
    bindRole(hex, "TextColor3", "Text")
    bindRole(hexStroke, "Color", "Border")

    local hueValue, satValue, brightnessValue = Color3.toHSV(picker.Value)
    local function applyColor(newColor, invoke)
        picker.Value = newColor
        hueValue, satValue, brightnessValue = Color3.toHSV(newColor)
        preview.BackgroundColor3 = newColor
        saturation.BackgroundColor3 = Color3.fromHSV(hueValue, 1, 1)
        hex.Text = toHex(newColor)
        satKnob.Position = UDim2.new(satValue, -7, 1 - brightnessValue, -7)
        hueKnob.Position = UDim2.new(hueValue, -6, .5, -9)
        if invoke ~= false then
            for _, cb in ipairs(picker.Callbacks) do task.spawn(cb, newColor) end
            if cfg.Callback then task.spawn(cfg.Callback, newColor) end
        end
    end
    applyColor(picker.Value, false)

    local satDragging, hueDragging = false, false
    local function updateSat(input, invoke)
        local position = input.Position
        local relativeX = math.clamp((position.X - saturation.AbsolutePosition.X) / math.max(1, saturation.AbsoluteSize.X), 0, 1)
        local relativeY = math.clamp((position.Y - saturation.AbsolutePosition.Y) / math.max(1, saturation.AbsoluteSize.Y), 0, 1)
        applyColor(Color3.fromHSV(hueValue, relativeX, 1 - relativeY), invoke)
    end
    local function updateHue(input, invoke)
        local position = input.Position
        local relative = math.clamp((position.X - hue.AbsolutePosition.X) / math.max(1, hue.AbsoluteSize.X), 0, 1)
        applyColor(Color3.fromHSV(relative, satValue, brightnessValue), invoke)
    end
    saturation.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            satDragging = true
            updateSat(input, true)
        end
    end)
    hue.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            hueDragging = true
            updateHue(input, true)
        end
    end)
    local colorChanged = UserInputService.InputChanged:Connect(function(input)
        if satDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSat(input, true) end
        if hueDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateHue(input, true) end
    end)
    local colorEnded = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            satDragging = false
            hueDragging = false
        end
    end)
    table.insert(self._connections, colorChanged)
    table.insert(self._connections, colorEnded)

    hex.FocusLost:Connect(function()
        local parsed = fromHex(hex.Text)
        if parsed then
            applyColor(parsed, true)
        else
            hex.Text = toHex(picker.Value)
        end
    end)

    picker.Instance = frame
    picker.Button = frame
    local selfWindow = self
    function picker:Close()
        if not self.Expanded then return end
        self.Expanded = false
        if selfWindow._openPopup == self then selfWindow._openPopup = nil end
        tween(popup, { Size = UDim2.fromOffset(256, 0) }, .16)
        task.delay(.17, function() if popup.Parent and not self.Expanded then popup.Visible = false end end)
    end
    function picker:Toggle()
        if self.Expanded then self:Close(); return end
        if selfWindow._openPopup and selfWindow._openPopup ~= self then selfWindow._openPopup:Close() end
        self.Expanded = true
        selfWindow._openPopup = self
        popup.Visible = true
        popup.Size = UDim2.fromOffset(256, 0)
        selfWindow:_syncPopup(popup, frame)
        tween(popup, { Size = UDim2.fromOffset(256, 196) }, .2, Enum.EasingStyle.Quart)
    end
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then picker:Toggle() end
    end)
    picker.SetValue = function(color) if typeof(color) == "Color3" then applyColor(color, true) end end
    picker.GetValue = function() return picker.Value end
    picker.OnChanged = function(cb) if type(cb) == "function" then table.insert(picker.Callbacks, cb) end end
    Fluent.Options[id] = picker
    return push(self, picker)
end

function Window:AddKeybind(id, cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    local bind = { Value = cfg.Default or Enum.KeyCode.Unknown, Callbacks = {}, Listening = false }
    local frame = elementBase(self, id or "Keybind", 46)
    makeIcon(frame, cfg.Icon or "keyboard", 16, theme.Accent).Position = UDim2.fromOffset(16, 15)
    makeText(frame, {
        Text = cfg.Title or id or "Keybind",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(45, 0),
        Size = UDim2.new(1, -145, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    }, "Text")
    local keyButton = inst("TextButton", {
        Text = bind.Value ~= Enum.KeyCode.Unknown and bind.Value.Name or "NONE",
        Font = Enum.Font.Code,
        TextSize = 11,
        TextColor3 = theme.Text,
        BackgroundColor3 = theme.Bg3,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Size = UDim2.fromOffset(88, 28),
        Position = UDim2.new(1, -102, .5, -14),
        Parent = frame,
    })
    corner(keyButton, 8)
    local keyStroke = stroke(keyButton, theme.BorderHi, 1)
    bindRole(keyButton, "BackgroundColor3", "Bg3")
    bindRole(keyButton, "TextColor3", "Text")
    bindRole(keyStroke, "Color", "BorderHi")

    keyButton.MouseEnter:Connect(function() tween(keyButton, { BackgroundColor3 = theme.SurfaceHi }, .12) end)
    keyButton.MouseLeave:Connect(function() tween(keyButton, { BackgroundColor3 = theme.Bg3 }, .12) end)
    keyButton.MouseButton1Click:Connect(function()
        bind.Listening = true
        keyButton.Text = "PRESS KEY"
        keyButton.TextColor3 = theme.Warning
    end)

    local input = UserInputService.InputBegan:Connect(function(inputObject, gameProcessed)
        if bind.Listening and inputObject.UserInputType == Enum.UserInputType.Keyboard then
            bind.Listening = false
            bind.Value = inputObject.KeyCode
            keyButton.Text = inputObject.KeyCode.Name
            keyButton.TextColor3 = theme.Text
            for _, cb in ipairs(bind.Callbacks) do task.spawn(cb, inputObject.KeyCode) end
            if cfg.Callback then task.spawn(cfg.Callback, inputObject.KeyCode) end
            return
        end
        if not gameProcessed and not bind.Listening and bind.Value ~= Enum.KeyCode.Unknown and inputObject.KeyCode == bind.Value then
            if cfg.Callback then task.spawn(cfg.Callback, inputObject.KeyCode) end
            for _, cb in ipairs(bind.Callbacks) do task.spawn(cb, inputObject.KeyCode) end
        end
    end)
    table.insert(self._connections, input)

    bind.Instance = frame
    bind.SetValue = function(key)
        if typeof(key) == "EnumItem" then
            bind.Value = key
            keyButton.Text = key ~= Enum.KeyCode.Unknown and key.Name or "NONE"
            keyButton.TextColor3 = theme.Text
        end
    end
    bind.GetValue = function() return bind.Value end
    bind.OnChanged = function(cb) if type(cb) == "function" then table.insert(bind.Callbacks, cb) end end
    Fluent.Options[id] = bind
    return push(self, bind)
end

function Window:AddTextbox(id, cfg)
    cfg = cfg or {}
    local theme = getTheme(self.Theme)
    local textbox = { Value = cfg.Default or "", Callbacks = {} }
    local frame = elementBase(self, id or "Textbox", 72)
    makeIcon(frame, cfg.Icon or "text", 16, theme.Accent).Position = UDim2.fromOffset(16, 12)
    makeText(frame, {
        Text = cfg.Title or id or "Textbox",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(45, 11),
        Size = UDim2.new(1, -61, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame,
    }, "Text")
    local box = inst("TextBox", {
        Text = tostring(textbox.Value),
        PlaceholderText = cfg.Placeholder or "Enter text…",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = theme.Text,
        PlaceholderColor3 = theme.TextMuted,
        BackgroundColor3 = theme.Bg3,
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Size = UDim2.new(1, -32, 0, 30),
        Position = UDim2.fromOffset(16, 36),
        Parent = frame,
    })
    corner(box, 8)
    local boxStroke = stroke(box, theme.Border, 1)
    bindRole(box, "BackgroundColor3", "Bg3")
    bindRole(box, "TextColor3", "Text")
    bindRole(boxStroke, "Color", "Border")
    box.Focused:Connect(function()
        tween(boxStroke, { Color = theme.Accent, Thickness = 1.5 }, .14)
        tween(box, { BackgroundColor3 = theme.SurfaceHi }, .14)
    end)
    box.FocusLost:Connect(function()
        tween(boxStroke, { Color = theme.Border, Thickness = 1 }, .14)
        tween(box, { BackgroundColor3 = theme.Bg3 }, .14)
        textbox.Value = box.Text
        for _, cb in ipairs(textbox.Callbacks) do task.spawn(cb, textbox.Value) end
        if cfg.Callback then task.spawn(cfg.Callback, textbox.Value) end
    end)
    textbox.Instance = frame
    textbox.SetValue = function(value, invoke)
        textbox.Value = tostring(value or "")
        box.Text = textbox.Value
        if invoke ~= false then
            for _, cb in ipairs(textbox.Callbacks) do task.spawn(cb, textbox.Value) end
            if cfg.Callback then task.spawn(cfg.Callback, textbox.Value) end
        end
    end
    textbox.GetValue = function() return textbox.Value end
    textbox.OnChanged = function(cb) if type(cb) == "function" then table.insert(textbox.Callbacks, cb) end end
    Fluent.Options[id] = textbox
    return push(self, textbox)
end

function Window:Dialog(cfg)
    cfg = cfg or {}
    if self.DialogOpen or self._destroyed then return end
    self.DialogOpen = true
    local theme = getTheme(self.Theme)
    self.DialogLayer.Visible = true
    self.DialogLayer.BackgroundTransparency = 1
    tween(self.DialogLayer, { BackgroundTransparency = .56 }, .18)

    local dialog = inst("Frame", {
        Name = "Dialog",
        Size = UDim2.fromOffset(390, 214),
        Position = UDim2.new(.5, -195, .5, -107),
        BackgroundColor3 = theme.Surface,
        BorderSizePixel = 0,
        ZIndex = 501,
        Parent = self.GUI,
    })
    corner(dialog, 15)
    local dstroke = stroke(dialog, theme.BorderHi, 1)
    bindRole(dialog, "BackgroundColor3", "Surface")
    bindRole(dstroke, "Color", "BorderHi")
    local dshadow = shadow(dialog, theme.Shadow, .35, 32)
    dshadow:SetAttribute("FluentThemeShadow", true)

    local iconChip = inst("Frame", {
        Size = UDim2.fromOffset(36, 36),
        Position = UDim2.fromOffset(20, 20),
        BackgroundColor3 = theme.AccentMuted,
        BorderSizePixel = 0,
        ZIndex = 502,
        Parent = dialog,
    })
    corner(iconChip, 11)
    bindRole(iconChip, "BackgroundColor3", "AccentMuted")
    local dicon = makeIcon(iconChip, cfg.Icon or "info", 16, theme.AccentHi)
    dicon.Position = UDim2.fromOffset(10, 10)
    makeText(dialog, {
        Text = cfg.Title or "Dialog",
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(68, 21),
        Size = UDim2.new(1, -90, 0, 22),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 502,
        Parent = dialog,
    }, "Text")
    makeText(dialog, {
        Text = cfg.Content or "",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(22, 72),
        Size = UDim2.new(1, -44, 0, 82),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        ZIndex = 502,
        Parent = dialog,
    }, "SubText")

    local row = inst("Frame", {
        Size = UDim2.new(1, -44, 0, 36),
        Position = UDim2.new(0, 22, 1, -54),
        BackgroundTransparency = 1,
        ZIndex = 502,
        Parent = dialog,
    })
    inst("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 8),
        Parent = row,
    })

    local closed = false
    local function closeDialog()
        if closed then return end
        closed = true
        tween(dialog, { Size = UDim2.fromOffset(370, 198) }, .14)
        tween(self.DialogLayer, { BackgroundTransparency = 1 }, .16)
        task.delay(.17, function()
            if dialog and dialog.Parent then dialog:Destroy() end
            if self.DialogLayer then self.DialogLayer.Visible = false end
            self.DialogOpen = false
        end)
    end
    self.DialogLayer.MouseButton1Click:Connect(closeDialog)

    for _, buttonInfo in ipairs(cfg.Buttons or {}) do
        local primary = buttonInfo.Primary ~= false
        local button = inst("TextButton", {
            Text = buttonInfo.Title or "OK",
            Font = Enum.Font.GothamMedium,
            TextSize = 11,
            TextColor3 = primary and Color3.new(1, 1, 1) or theme.Text,
            BackgroundColor3 = primary and theme.Accent or theme.Bg3,
            BorderSizePixel = 0,
            AutoButtonColor = false,
            Size = UDim2.fromOffset(100, 36),
            ZIndex = 503,
            Parent = row,
        })
        corner(button, 9)
        local bs = stroke(button, primary and theme.Accent or theme.Border, 1)
        bindRole(button, "BackgroundColor3", primary and "Accent" or "Bg3")
        bindRole(button, "TextColor3", primary and "Text" or "Text")
        bindRole(bs, "Color", primary and "Accent" or "Border")
        button.MouseEnter:Connect(function() tween(button, { BackgroundColor3 = primary and theme.AccentHi or theme.SurfaceHi }, .12) end)
        button.MouseLeave:Connect(function() tween(button, { BackgroundColor3 = primary and theme.Accent or theme.Bg3 }, .12) end)
        local c = ripple(button, primary and Color3.new(1, 1, 1) or theme.Accent)
        table.insert(self._connections, c)
        button.MouseButton1Click:Connect(function()
            if buttonInfo.Callback then task.spawn(buttonInfo.Callback) end
            closeDialog()
        end)
    end
end

function Window:Notify(cfg)
    cfg = cfg or {}
    if self._destroyed then return end
    local theme = getTheme(self.Theme)
    local kind = tostring(cfg.Type or "Info")
    local accent = kind == "Success" and theme.Success or kind == "Warning" and theme.Warning or kind == "Error" and theme.Error or kind == "Info" and theme.Info or theme.Accent
    local iconName = cfg.Icon or (kind == "Success" and "check-circle" or kind == "Warning" and "warning" or kind == "Error" and "error" or "info")
    local height = cfg.SubContent and 94 or 76
    local toast = inst("Frame", {
        Size = UDim2.fromOffset(360, height),
        BackgroundColor3 = theme.Surface,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 301,
        Parent = self.NotifyBox,
    })
    corner(toast, 13)
    local ts = stroke(toast, theme.BorderHi, 1)
    bindRole(toast, "BackgroundColor3", "Surface")
    bindRole(ts, "Color", "BorderHi")
    local tsh = shadow(toast, theme.Shadow, .40, 28)
    tsh:SetAttribute("FluentThemeShadow", true)
    local strip = inst("Frame", {
        Size = UDim2.new(0, 3, 1, -20),
        Position = UDim2.fromOffset(0, 10),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = toast,
        ZIndex = 302,
    })
    corner(strip, 2)
    local iconBg = inst("Frame", {
        Size = UDim2.fromOffset(32, 32),
        Position = UDim2.fromOffset(14, 14),
        BackgroundColor3 = accent,
        BackgroundTransparency = .82,
        BorderSizePixel = 0,
        Parent = toast,
        ZIndex = 302,
    })
    corner(iconBg, 10)
    local icon = makeIcon(iconBg, iconName, 15, accent)
    icon.Position = UDim2.fromOffset(8.5, 8.5)
    makeText(toast, {
        Text = cfg.Title or kind,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        TextColor3 = theme.Text,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(58, 13),
        Size = UDim2.new(1, -78, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 302,
        Parent = toast,
    }, "Text")
    makeText(toast, {
        Text = cfg.Content or "",
        Font = Enum.Font.Gotham,
        TextSize = 10,
        TextColor3 = theme.SubText,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(58, 35),
        Size = UDim2.new(1, -78, 0, 22),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 302,
        Parent = toast,
    }, "SubText")
    if cfg.SubContent then
        makeText(toast, {
            Text = cfg.SubContent,
            Font = Enum.Font.Gotham,
            TextSize = 10,
            TextColor3 = theme.TextMuted,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(58, 57),
            Size = UDim2.new(1, -78, 0, 16),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 302,
            Parent = toast,
        }, "TextMuted")
    end

    local closeButton = inst("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(24, 24),
        Position = UDim2.new(1, -31, 0, 8),
        ZIndex = 303,
        Parent = toast,
    })
    local closeIcon = makeIcon(closeButton, "close", 11, theme.TextMuted)
    closeIcon.Position = UDim2.fromOffset(6.5, 6.5)
    closeButton.MouseEnter:Connect(function() setIconColor(closeIcon, theme.Text) end)
    closeButton.MouseLeave:Connect(function() setIconColor(closeIcon, theme.TextMuted) end)

    local progress = inst("Frame", {
        Size = UDim2.new(1, -28, 0, 2),
        Position = UDim2.new(0, 14, 1, -8),
        BackgroundColor3 = accent,
        BackgroundTransparency = .5,
        BorderSizePixel = 0,
        ZIndex = 302,
        Parent = toast,
    })
    corner(progress, 1)
    local duration = tonumber(cfg.Duration)
    if duration == nil then duration = 5 end
    if duration < 0 then duration = 0 end

    tween(toast, { Position = UDim2.fromOffset(24, 0), BackgroundTransparency = 0 }, .25, Enum.EasingStyle.Quart)
    local closed = false
    local function dismiss()
        if closed then return end
        closed = true
        tween(toast, { Position = UDim2.fromOffset(390, 0), BackgroundTransparency = 1 }, .2, Enum.EasingStyle.Quart)
        task.delay(.21, function() if toast and toast.Parent then toast:Destroy() end end)
    end
    closeButton.MouseButton1Click:Connect(dismiss)
    if duration > 0 then
        tween(progress, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear)
        task.delay(duration, dismiss)
    else
        progress.Visible = false
    end
    return { Instance = toast, Close = dismiss }
end

function Window:SetTheme(name)
    local newTheme = Themes[name]
    if not newTheme or self._destroyed then return end
    local oldTheme = getTheme(self.Theme)
    self.Theme = name
    Fluent.Theme = name

    local function sameColor(a, b)
        return typeof(a) == "Color3" and typeof(b) == "Color3"
            and math.abs(a.R - b.R) < 0.001
            and math.abs(a.G - b.G) < 0.001
            and math.abs(a.B - b.B) < 0.001
    end

    local tokenMap = {
        Bg = "Bg", Bg2 = "Bg2", Bg3 = "Bg3", Surface = "Surface", SurfaceHi = "SurfaceHi", SurfacePressed = "SurfacePressed",
        Text = "Text", SubText = "SubText", TextMuted = "TextMuted", Accent = "Accent", AccentHi = "AccentHi",
        AccentPressed = "AccentPressed", AccentMuted = "AccentMuted", Border = "Border", BorderHi = "BorderHi",
        Success = "Success", Warning = "Warning", Error = "Error", Info = "Info", Shadow = "Shadow",
    }

    local function remapColor(color)
        for oldRole, newRole in pairs(tokenMap) do
            if sameColor(color, oldTheme[oldRole]) then
                return newTheme[newRole]
            end
        end
        return color
    end

    local function remapTree(root)
        if not root or not root.Parent then return end
        local all = { root }
        for _, child in ipairs(root:GetDescendants()) do
            all[#all + 1] = child
        end
        for _, object in ipairs(all) do
            local iconToken = object:GetAttribute("FluentIconToken")
            if iconToken and newTheme[iconToken] then
                setIconColor(object, newTheme[iconToken])
            end
            if object:IsA("Frame") or object:IsA("TextButton") or object:IsA("TextBox") or object:IsA("ImageLabel") or object:IsA("ImageButton") then
                if object.BackgroundTransparency < 1 then
                    local role = object:GetAttribute("FluentThemeRole")
                    if role and newTheme[role] then
                        object.BackgroundColor3 = newTheme[role]
                    else
                        object.BackgroundColor3 = remapColor(object.BackgroundColor3)
                    end
                end
            end
            if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                local property = object:GetAttribute("FluentThemeProperty")
                local role = object:GetAttribute("FluentThemeRole")
                if property == "TextColor3" and role and newTheme[role] then
                    object.TextColor3 = newTheme[role]
                else
                    object.TextColor3 = remapColor(object.TextColor3)
                end
                if object:IsA("TextBox") then
                    object.PlaceholderColor3 = remapColor(object.PlaceholderColor3)
                end
            end
            if object:IsA("ImageLabel") or object:IsA("ImageButton") then
                if not object:GetAttribute("FluentThemeShadow") then
                    object.ImageColor3 = remapColor(object.ImageColor3)
                else
                    object.ImageColor3 = newTheme.Shadow
                end
            end
            if object:IsA("UIStroke") then
                local role = object:GetAttribute("FluentThemeRole")
                object.Color = role and newTheme[role] or remapColor(object.Color)
            end
            if object:IsA("UIGradient") then
                local a = object:GetAttribute("FluentGradientA")
                local b = object:GetAttribute("FluentGradientB")
                if a and b and newTheme[a] and newTheme[b] then
                    object.Color = colorSequence(newTheme[a], newTheme[b])
                end
            end
        end
    end

    remapTree(self.GUI)
    if Fluent.ToggleButtonGui and Fluent.ToggleButtonGui.Parent then
        remapTree(Fluent.ToggleButtonGui)
    end

    self.TabList.ScrollBarImageColor3 = newTheme.Border
    self.Content.ScrollBarImageColor3 = newTheme.BorderHi
    if self.SelectedTab then
        self:SelectTab(self.SelectedTab)
    end
end

function Window:Destroy()
    if self._destroyed then return end
    self._destroyed = true
    self.DialogOpen = false
    self._openPopup = nil
    Fluent.Unloaded = true
    if Fluent.Window == self then Fluent.Window = nil end

    for _, connection in ipairs(self._connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    self._connections = {}

    if Fluent.ToggleButtonConnections then
        for _, connection in ipairs(Fluent.ToggleButtonConnections) do
            if connection and connection.Connected then connection:Disconnect() end
        end
    end
    Fluent.ToggleButtonConnections = nil

    if Fluent.ToggleButtonGui and Fluent.ToggleButtonGui.Parent then
        Fluent.ToggleButtonGui:Destroy()
    end
    Fluent.ToggleButtonGui = nil
    Fluent.ToggleButton = nil
    Fluent.ToggleButtonSetOpen = nil

    if self.GUI and self.GUI.Parent then
        self.GUI:Destroy()
    end
    self.Options = nil
    self.Tabs = {}
    self.SelectedTab = nil
end

function Fluent:Notify(cfg)
    if not self.Window then return end
    cfg = cfg or {}
    local enabled = self.Options and self.Options.NotifEnabled
    if enabled and enabled.Value == false then return end
    local configuredDuration = self.Options and self.Options.NotifDuration
    if cfg.Duration == nil and configuredDuration and configuredDuration.Value ~= nil then
        cfg.Duration = configuredDuration.Value
    end
    return self.Window:Notify(cfg)
end
function Fluent:Dialog(cfg)
    if self.Window then return self.Window:Dialog(cfg) end
end
function Fluent:SetTheme(name)
    if self.Window then return self.Window:SetTheme(name) end
end
function Fluent:ToggleVisibility(force)
    if self.Window then return self.Window:ToggleVisibility(force) end
end
function Fluent:ToggleMinimize()
    if self.Window then return self.Window:ToggleMinimize() end
end
function Fluent:Destroy()
    if self.Window then return self.Window:Destroy() end
end

local SaveManager = {}
SaveManager.__index = SaveManager
function SaveManager:SetLibrary(library) self.Library = library end
local function configName(library)
    local option = library and library.Options and library.Options.ConfigName
    local name = option and option.Value or "default"
    name = tostring(name or "default"):gsub("[^%w%-%._]", "_")
    if name == "" then name = "default" end
    return name
end
function SaveManager:Save()
    if not self.Library then return false end
    local data = {}
    for id, option in pairs(self.Library.Options or {}) do
        if option.Value ~= nil then
            local valueType = typeof(option.Value)
            if valueType == "Color3" then
                data[id] = { t = "Color3", v = { option.Value.R, option.Value.G, option.Value.B } }
            elseif valueType == "EnumItem" then
                data[id] = { t = "EnumItem", v = option.Value.Name }
            elseif type(option.Value) == "table" then
                data[id] = { t = "table", v = option.Value }
            else
                data[id] = { t = "raw", v = option.Value }
            end
        end
    end
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if not ok then return false end
    if writefile then
        return pcall(writefile, "FluentUI_" .. configName(self.Library) .. ".json", encoded)
    end
    return false
end
function SaveManager:Load()
    if not self.Library or not readfile then return false end
    local ok, content = pcall(readfile, "FluentUI_" .. configName(self.Library) .. ".json")
    if not ok then return false end
    local ok2, data = pcall(function() return HttpService:JSONDecode(content) end)
    if not ok2 or type(data) ~= "table" then return false end
    for id, entry in pairs(data) do
        local option = self.Library.Options and self.Library.Options[id]
        if option and option.SetValue then
            if entry.t == "Color3" and type(entry.v) == "table" then
                option:SetValue(Color3.new(entry.v[1], entry.v[2], entry.v[3]), false)
            elseif entry.t == "EnumItem" then
                local enumValue = Enum.KeyCode[entry.v]
                if enumValue then option:SetValue(enumValue, false) end
            else
                option:SetValue(entry.v, false)
            end
        end
    end
    return true
end
function SaveManager:Delete()
    if not delfile then return false end
    return pcall(delfile, "FluentUI_" .. configName(self.Library) .. ".json")
end
function SaveManager:BuildConfigSection(tab)
    tab:AddParagraph({ Title = "Configuration", Content = "Save, load, or delete your FluentUI settings.", Icon = "save" })
    tab:AddTextbox("ConfigName", { Title = "Config Name", Default = "default", Placeholder = "my-config", Icon = "file" })
    tab:AddButton({ Title = "Save Config", Icon = "save", Description = "Write your current settings to disk.", Callback = function()
        local ok = self:Save()
        Fluent:Notify({ Title = ok and "Configuration saved" or "Save unavailable", Content = ok and "Your settings were written successfully." or "This executor does not expose file writing.", Type = ok and "Success" or "Warning", Duration = 3 })
    end })
    tab:AddButton({ Title = "Load Config", Icon = "download", Description = "Restore settings from the selected configuration.", Callback = function()
        local ok = self:Load()
        Fluent:Notify({ Title = ok and "Configuration loaded" or "Load failed", Content = ok and "Your saved settings are active." or "No readable configuration was found.", Type = ok and "Success" or "Warning", Duration = 3 })
    end })
    tab:AddButton({ Title = "Delete Config", Icon = "trash", Description = "Remove the saved configuration file.", Callback = function()
        local ok = self:Delete()
        Fluent:Notify({ Title = ok and "Configuration deleted" or "Delete unavailable", Content = ok and "The configuration file was removed." or "This executor does not expose file deletion.", Type = ok and "Success" or "Warning", Duration = 3 })
    end })
end

local InterfaceManager = {}
InterfaceManager.__index = InterfaceManager
function InterfaceManager:SetLibrary(library) self.Library = library end
function InterfaceManager:BuildInterfaceSection(tab)
    tab:AddParagraph({ Title = "Interface", Content = "Customize FluentUI without rebuilding your interface.", Icon = "settings" })
    tab:AddDropdown("ThemeSelector", {
        Title = "Theme",
        Icon = "palette",
        Values = { "Dark", "Light", "Midnight", "Dracula", "Nord", "Emerald", "Rose", "Monokai" },
        Default = self.Library and self.Library.Theme or "Dark",
        Callback = function(value)
            Fluent:SetTheme(value)
            Fluent:Notify({ Title = "Theme updated", Content = "FluentUI is now using " .. tostring(value) .. ".", Type = "Info", Duration = 2 })
        end,
    })
    tab:AddSlider("UIScale", {
        Title = "UI Scale",
        Icon = "sliders",
        Min = 80,
        Max = 120,
        Default = 100,
        Rounding = 0,
        Callback = function(value)
            if Fluent.Window then Fluent.Window:SetUIScale(value) end
        end,
    })
    tab:AddSlider("NotifDuration", {
        Title = "Notification Duration",
        Icon = "bell",
        Min = 1,
        Max = 15,
        Default = 5,
        Rounding = 0,
    })
    tab:AddToggle("NotifEnabled", {
        Title = "Enable Notifications",
        Icon = "bell",
        Default = true,
        Description = "Toggle toast notifications globally.",
    })
    tab:AddKeybind("ToggleKeybind", {
        Title = "Hide / Show UI",
        Icon = "keyboard",
        Default = Enum.KeyCode.RightShift,
        Callback = function(key)
            if Fluent.Window then Fluent.Window.ToggleKey = key end
        end,
    })
    tab:AddKeybind("MinimizeKeybind", {
        Title = "Minimize UI",
        Icon = "keyboard",
        Default = Enum.KeyCode.LeftControl,
        Callback = function(key)
            if Fluent.Window then Fluent.Window.MinimizeKey = key end
        end,
    })
    tab:AddButton({
        Title = "Reset Interface",
        Icon = "refresh",
        Description = "Restore the default window position, scale, and state.",
        Callback = function()
            if Fluent.Window then
                local window = Fluent.Window
                window.Minimized = false
                window.Hidden = false
                window.FrameHolder.Size = UDim2.fromOffset(window._baseWidth, window._baseHeight)
                window:SetUIScale(100)
                window.Sidebar.Visible = true
                window.Divider.Visible = true
                window.Content.Visible = true
                window.Root.Visible = true
                if window._syncToggle then window._syncToggle(true) end
            end
        end,
    })
    tab:AddButton({
        Title = "Destroy Interface",
        Icon = "close",
        Description = "Remove FluentUI and clean all active connections.",
        Callback = function() Fluent:Destroy() end,
    })
end

Fluent.SaveManager = SaveManager
Fluent.InterfaceManager = InterfaceManager

return Fluent
