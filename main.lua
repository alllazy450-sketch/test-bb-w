-- =====================================================
-- NURYSIUM UI (BLUE THEME) - MOBILE FRIENDLY (FULL VERSION)
-- =====================================================
local nurysium = {}

local tween_service = game:GetService("TweenService")
local user_input = game:GetService("UserInputService")
local run_service = game:GetService("RunService")

local ui = nil
local search_table = {}
local ui_data = { current_section = "nil" }
local is_open = false

local BLUE = {
    primary = Color3.fromRGB(66, 133, 244),
    dark = Color3.fromRGB(30, 80, 180),
    text = Color3.fromRGB(231, 231, 243),
}

-- ======================== FUNGSI UI ========================
local function animate_elements(speed)
    if not ui then return end
    local layout = ui.Background["functions_frame"]:FindFirstChild("UIListLayout")
    if not layout then return end
    layout.Padding = UDim.new(0.5, 0)
    tween_service:Create(layout, TweenInfo.new(speed, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        Padding = UDim.new(0.02, 0)
    }):Play()
end

function nurysium: open()
    if not ui or is_open then return end
    is_open = true
    task.delay(0.65, function()
        if not ui then return end
        ui.Background["functions_frame"].Visible = true
        ui.Background.Sections.Visible = true
        ui.Background.Search.Visible = true
    end)

    local layout = ui.Background["functions_frame"]:FindFirstChild("UIListLayout")
    if layout then
        tween_service:Create(layout, TweenInfo.new(2, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
            Padding = UDim.new(0.02, 0)
        }):Play()
    end

    tween_service:Create(ui.Background.Title, TweenInfo.new(1.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        TextTransparency = 0
    }):Play()

    tween_service:Create(ui.Background, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        Size = UDim2.new(0, 655, 0, 325),
        Position = UDim2.new(0.4, 0, 0.3, 0),
        BackgroundTransparency = 0
    }):Play()
end

function nurysium: close()
    if not ui or not is_open then return end
    is_open = false
    task.delay(0.35, function()
        if not ui then return end
        ui.Background["functions_frame"].Visible = false
        ui.Background.Sections.Visible = false
        ui.Background.Search.Visible = false
    end)

    local layout = ui.Background["functions_frame"]:FindFirstChild("UIListLayout")
    if layout then
        tween_service:Create(layout, TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
            Padding = UDim.new(0.02, 0)
        }):Play()
    end

    tween_service:Create(ui.Background.Title, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        TextTransparency = 1
    }):Play()

    tween_service:Create(ui.Background, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.510, 0, 1, 0),
        BackgroundTransparency = 1
    }):Play()
end

function nurysium: toggle()
    if is_open then
        self:close()
    else
        self:open()
    end
end

-- ======================== INIT (UI BUILDER) ========================
function nurysium: init(name, parent)
    if parent:FindFirstChild(name) then
        parent:FindFirstChild(name):Destroy()
    end

    ui = Instance.new("ScreenGui")
    ui.Name = name
    ui.Parent = parent
    ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Parent = ui
    Background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Background.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Background.BorderSizePixel = 0
    Background.Position = UDim2.new(0.4, 0, 0.3, 0)
    Background.Size = UDim2.new(0, 655, 0, 325)
    Background.ZIndex = 5

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = Background

    local UIGradient_4 = Instance.new("UIGradient")
    UIGradient_4.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(30, 28, 39)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(24, 22, 31))}
    UIGradient_4.Rotation = -113
    UIGradient_4.Parent = Background

    local Sections = Instance.new("Frame")
    Sections.Name = "Sections"
    Sections.Parent = Background
    Sections.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Sections.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Sections.BorderSizePixel = 0
    Sections.Position = UDim2.new(-0.00157281861, 0, 0, 0)
    Sections.Size = UDim2.new(0.283998042, 0, 1, 0)

    local UICorner_2 = Instance.new("UICorner")
    UICorner_2.CornerRadius = UDim.new(0, 15)
    UICorner_2.Parent = Sections

    local UIGradient_2 = Instance.new("UIGradient")
    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(39, 36, 47)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(33, 31, 40))}
    UIGradient_2.Rotation = -113
    UIGradient_2.Parent = Sections

    local CornerFix = Instance.new("Frame")
    CornerFix.Name = "CornerFix"
    CornerFix.Parent = Sections
    CornerFix.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CornerFix.BorderColor3 = Color3.fromRGB(0, 0, 0)
    CornerFix.BorderSizePixel = 0
    CornerFix.Position = UDim2.new(0.918615103, 0, 0, 0)
    CornerFix.Size = UDim2.new(0.0813859329, 0, 1, 0)

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(37, 34, 45)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(35, 33, 43))}
    UIGradient.Rotation = -94
    UIGradient.Parent = CornerFix

    local real_sections = Instance.new("Frame")
    real_sections.Name = "real_sections"
    real_sections.Parent = Sections
    real_sections.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    real_sections.BackgroundTransparency = 1.000
    real_sections.BorderColor3 = Color3.fromRGB(0, 0, 0)
    real_sections.BorderSizePixel = 0
    real_sections.Position = UDim2.new(0.249553874, 0, 0.170943886, 0)
    real_sections.Size = UDim2.new(0, 107, 0, 230)
    real_sections.ZIndex = 5

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = real_sections
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0.0450000018, 0)

    local logo = Instance.new("ImageButton")
    logo.Name = "logo"
    logo.Parent = Sections
    logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    logo.BackgroundTransparency = 1.000
    logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
    logo.BorderSizePixel = 0
    logo.Position = UDim2.new(0.710735202, 0, 0.664615393, 0)
    logo.Size = UDim2.new(0, 100, 0, 100)
    logo.ZIndex = 2
    logo.Image = "rbxassetid://17441779136"

    local UIGradient_3 = Instance.new("UIGradient")
    UIGradient_3.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.51, 1.00), NumberSequenceKeypoint.new(1.00, 1.00)}
    UIGradient_3.Parent = logo

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Background
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.0269060303, 0, 0.035999544, 0)
    Title.Size = UDim2.new(0, 70, 0, 20)
    Title.Font = Enum.Font.GothamBold
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(231, 231, 243)
    Title.TextScaled = true
    Title.TextSize = 14.000
    Title.TextWrapped = true

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, BLUE.primary),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(130, 177, 255))
    }
    TitleGradient.Offset = Vector2.new(0.00999999978, 0)
    TitleGradient.Rotation = -113
    TitleGradient.Parent = Title

    coroutine.wrap(function()
        while true do
            tween_service:Create(TitleGradient, TweenInfo.new(3, Enum.EasingStyle.Quad), { Rotation = 53 }):Play()
            task.wait(3)
            tween_service:Create(TitleGradient, TweenInfo.new(3, Enum.EasingStyle.Quad), { Rotation = -180 }):Play()
            task.wait(3)
        end
    end)()

    local functions_frame = Instance.new("ScrollingFrame")
    functions_frame.Name = "functions_frame"
    functions_frame.Parent = Background
    functions_frame.Active = true
    functions_frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    functions_frame.BackgroundTransparency = 1.000
    functions_frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    functions_frame.BorderSizePixel = 0
    functions_frame.Position = UDim2.new(0.31407398, 0, 0.170943886, 0)
    functions_frame.Size = UDim2.new(0, 397, 0, 254)
    functions_frame.ScrollBarThickness = 0

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = functions_frame
    UIPadding.PaddingTop = UDim.new(0.00999999978, 0)

    local UIListLayout_2 = Instance.new("UIListLayout")
    UIListLayout_2.Parent = functions_frame
    UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout_2.Padding = UDim.new(0.0199999996, 0)

    local Search = Instance.new("Frame")
    Search.Name = "Search"
    Search.Parent = Background
    Search.BackgroundColor3 = Color3.fromRGB(33, 32, 40)
    Search.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Search.BorderSizePixel = 0
    Search.Position = UDim2.new(0.775426149, 0, 0.0338461548, 0)
    Search.Size = UDim2.new(0, 120, 0, 35)
    Search.ZIndex = 10

    local UICorner_3 = Instance.new("UICorner")
    UICorner_3.CornerRadius = UDim.new(0, 15)
    UICorner_3.Parent = Search

    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Parent = Search
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel.BackgroundTransparency = 1.000
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Position = UDim2.new(0.0675648972, 0, 0.244624332, 0)
    ImageLabel.Size = UDim2.new(0, 17, 0, 17)
    ImageLabel.ZIndex = 12
    ImageLabel.Image = "rbxassetid://17441620727"
    ImageLabel.ImageTransparency = 0.450

    local Bar = Instance.new("TextBox")
    Bar.Name = "Bar"
    Bar.Parent = Search
    Bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Bar.BackgroundTransparency = 1.000
    Bar.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Bar.BorderSizePixel = 0
    Bar.Position = UDim2.new(0.275000006, 0, 0.0199957713, 0)
    Bar.Size = UDim2.new(0, 87, 0, 34)
    Bar.SizeConstraint = Enum.SizeConstraint.RelativeXX
    Bar.ZIndex = 7
    Bar.ClearTextOnFocus = false
    Bar.Font = Enum.Font.GothamBold
    Bar.PlaceholderText = "Search"
    Bar.Text = ""
    Bar.TextColor3 = Color3.fromRGB(231, 231, 243)
    Bar.TextSize = 14.000
    Bar.TextTransparency = 0.450
    Bar.TextWrapped = true
    Bar.TextXAlignment = Enum.TextXAlignment.Left

    Bar:GetPropertyChangedSignal("Text"):Connect(function()
        if Bar.Text:len() > 1 then
            animate_elements(1.35)
            for _, element in functions_frame:GetDescendants() do
                if element:IsA("Frame") and element:FindFirstChild("Title") then
                    if string.find(string.lower(element.Title.Text), string.lower(Bar.Text)) then
                        table.insert(search_table, element.Name)
                    else
                        local index = table.find(search_table, element.Name)
                        if index then table.remove(search_table, index) end
                    end
                end
            end
        else
            table.clear(search_table)
        end
    end)

    logo.MouseButton1Up:Connect(function()
        nurysium:toggle()
    end)
    logo.TouchTap:Connect(function()
        nurysium:toggle()
    end)

    task.defer(function()
        local function drag_handler()
            local UserInputService = game:GetService("UserInputService")
            local runService = game:GetService("RunService")
            local gui = Background
            local dragging, startPos, lastMousePos, lastGoalPos
            local DRAG_SPEED = 9

            local function Lerp(a, b, m) return a + (b - a) * m end

            local function Update(dt)
                if not startPos then return end
                if not dragging and lastGoalPos then
                    gui.Position = UDim2.new(
                        startPos.X.Scale, Lerp(gui.Position.X.Offset, lastGoalPos.X.Offset, dt * DRAG_SPEED),
                        startPos.Y.Scale, Lerp(gui.Position.Y.Offset, lastGoalPos.Y.Offset, dt * DRAG_SPEED)
                    )
                    return
                end
                local delta = lastMousePos - UserInputService:GetMouseLocation()
                local xGoal = startPos.X.Offset - delta.X
                local yGoal = startPos.Y.Offset - delta.Y
                lastGoalPos = UDim2.new(startPos.X.Scale, xGoal, startPos.Y.Scale, yGoal)
                gui.Position = UDim2.new(
                    startPos.X.Scale, Lerp(gui.Position.X.Offset, xGoal, dt * DRAG_SPEED),
                    startPos.Y.Scale, Lerp(gui.Position.Y.Offset, yGoal, dt * DRAG_SPEED)
                )
            end

            gui.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    startPos = gui.Position
                    lastMousePos = UserInputService:GetMouseLocation()
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then dragging = false end
                    end)
                end
            end)
            runService.Heartbeat:Connect(Update)
        end
        coroutine.wrap(drag_handler)()
    end)

    ui.Background = Background
    ui.Background.Sections = Sections
    ui.Background.real_sections = real_sections
    ui.Background.functions_frame = functions_frame
    ui.Background.Search = Search
    ui.Background.Title = Title
end

-- ======================== CREATE SECTION ========================
function nurysium: create_section(name, imageID)
    if not ui then return end
    task.wait(0.5)

    local Example = Instance.new("TextButton", ui.Background.real_sections)
    local ImageLabel = Instance.new("ImageLabel")

    Example.Name = name
    Example.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Example.BackgroundTransparency = 1.000
    Example.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Example.BorderSizePixel = 0
    Example.Size = UDim2.new(0, 85, 0, 16)
    Example.ZIndex = 6
    Example.Font = Enum.Font.GothamBold
    Example.Text = name
    Example.TextColor3 = Color3.fromRGB(231, 231, 243)
    Example.TextScaled = true
    Example.TextSize = 14.000
    Example.TextWrapped = true
    Example.TextTransparency = 1
    Example.TextXAlignment = Enum.TextXAlignment.Left

    tween_service:Create(Example, TweenInfo.new(1.35, Enum.EasingStyle.Exponential), { TextTransparency = 0.45 }):Play()

    local function select_section()
        ui_data.current_section = Example.Text
        for _, section in ui.Background.real_sections:GetChildren() do
            if section:IsA("TextButton") then
                if section.Text == name then
                    local click_sound = Instance.new("Sound", game:GetService("SoundService"))
                    click_sound.SoundId = "rbxassetid://8816939097"
                    click_sound:Play()
                    animate_elements(1.65)
                    tween_service:Create(section, TweenInfo.new(0.65, Enum.EasingStyle.Exponential), { TextTransparency = 0 }):Play()
                    tween_service:Create(section.ImageLabel, TweenInfo.new(0.65, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play()
                else
                    tween_service:Create(section, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), { TextTransparency = 0.45 }):Play()
                    tween_service:Create(section.ImageLabel, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), { ImageTransparency = 0.45 }):Play()
                end
            end
        end
    end

    Example.MouseButton1Up:Connect(select_section)
    Example.TouchTap:Connect(select_section)

    ImageLabel.Parent = Example
    ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ImageLabel.BackgroundTransparency = 1.000
    ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageLabel.BorderSizePixel = 0
    ImageLabel.Position = UDim2.new(-0.257435054, 0, 0.0446243286, 0)
    ImageLabel.Size = UDim2.new(0, 13, 0, 13)
    ImageLabel.ZIndex = 6
    ImageLabel.ImageTransparency = 1
    ImageLabel.Image = string.format("rbxassetid://%d", imageID)

    tween_service:Create(ImageLabel, TweenInfo.new(3, Enum.EasingStyle.Exponential), { ImageTransparency = 0.45 }):Play()
end

-- ======================== CREATE TOGGLE ========================
function nurysium: create_toggle(name, section_name, callback)
    if not ui then return end
    task.wait(0.15)

    callback = callback or function() end
    local toggled = false

    local Example = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local UIGradient = Instance.new("UIGradient")
    local Hitbox = Instance.new("TextButton")
    local UIGradient_2 = Instance.new("UIGradient")
    local Title = Instance.new("TextLabel")
    local Toggle = Instance.new("Frame")
    local Dot = Instance.new("Frame")
    local UICorner_2 = Instance.new("UICorner")
    local UIStroke_2 = Instance.new("UIStroke")
    local UICorner_3 = Instance.new("UICorner")

    Example.Name = name
    Example.Parent = ui.Background.functions_frame
    Example.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Example.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Example.BorderSizePixel = 0
    Example.Position = UDim2.new(0.0428211577, 0, 0.0157480314, 0)
    Example.Size = UDim2.new(0, 380, 0, 43)
    Example.ZIndex = 10

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Example

    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 4
    UIStroke.Parent = Example

    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(39, 36, 47)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(46, 43, 56))}
    UIGradient.Rotation = 36
    UIGradient.Parent = UIStroke

    Hitbox.Name = "Hitbox"
    Hitbox.Parent = Example
    Hitbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Hitbox.BackgroundTransparency = 1.000
    Hitbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Hitbox.BorderSizePixel = 0
    Hitbox.Size = UDim2.new(1, 0, 1, 0)
    Hitbox.Font = Enum.Font.SourceSans
    Hitbox.TextColor3 = Color3.fromRGB(0, 0, 0)
    Hitbox.TextSize = 1.000
    Hitbox.TextTransparency = 1.000

    UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(39, 36, 47)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(33, 31, 40))}
    UIGradient_2.Rotation = -113
    UIGradient_2.Parent = Example

    Title.Name = "Title"
    Title.Parent = Example
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.0449240729, 0, 0.275129884, 0)
    Title.Size = UDim2.new(0, 140, 0, 20)
    Title.ZIndex = 10
    Title.Font = Enum.Font.GothamBold
    Title.Text = name
    Title.TextColor3 = BLUE.text
    Title.TextScaled = true
    Title.TextSize = 14.000
    Title.TextWrapped = true
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Toggle.Name = "Toggle"
    Toggle.Parent = Example
    Toggle.BackgroundColor3 = Color3.fromRGB(27, 24, 35)
    Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Toggle.BorderSizePixel = 0
    Toggle.Position = UDim2.new(0.841389358, 0, 0.279069781, 0)
    Toggle.Size = UDim2.new(0, 38, 0, 18)
    Toggle.ZIndex = 15

    Dot.Name = "Dot"
    Dot.Parent = Toggle
    Dot.BackgroundColor3 = Color3.fromRGB(37, 35, 48)
    Dot.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Dot.BorderSizePixel = 0
    Dot.Position = UDim2.new(0.149068192, 0, 0.22351414, 0)
    Dot.Size = UDim2.new(0, 10, 0, 10)
    Dot.ZIndex = 15

    UICorner_2.CornerRadius = UDim.new(1, 0)
    UICorner_2.Parent = Dot

    UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke_2.Color = Color3.fromRGB(40, 39, 45)
    UIStroke_2.Thickness = 1.7999999523162842
    UIStroke_2.Parent = Toggle

    UICorner_3.CornerRadius = UDim.new(0, 10)
    UICorner_3.Parent = Toggle

    run_service.Heartbeat:Connect(function()
        if not section_name:match(ui_data.current_section) and not table.find(search_table, name) then
            Example.Visible = false
        else
            Example.Visible = true
        end
    end)

    local function toggle_action()
        toggled = not toggled
        callback(toggled)

        if toggled then
            tween_service:Create(Dot, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.600, 0, 0.224, 0),
                BackgroundColor3 = BLUE.primary
            }):Play()
            tween_service:Create(UIStroke_2, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                Transparency = 0.5,
                Color = BLUE.primary
            }):Play()
            tween_service:Create(Toggle, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                BackgroundColor3 = BLUE.dark
            }):Play()
        else
            tween_service:Create(Dot, TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                Position = UDim2.new(0.149, 0, 0.224, 0),
                BackgroundColor3 = Color3.fromRGB(37, 35, 48)
            }):Play()
            tween_service:Create(UIStroke_2, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                Transparency = 0,
                Color = Color3.fromRGB(40, 39, 45)
            }):Play()
            tween_service:Create(Toggle, TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {
                BackgroundColor3 = Color3.fromRGB(27, 24, 35)
            }):Play()
        end
    end

    Hitbox.MouseButton1Up:Connect(toggle_action)
    Hitbox.TouchTap:Connect(toggle_action)
end

-- ======================== CREATE BUTTON ========================
function nurysium: create_button(name, section_name, callback)
    if not ui then return end
    task.wait(0.15)
    callback = callback or function() end

    local btn = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local UIGradient = Instance.new("UIGradient")

    btn.Name = name
    btn.Parent = ui.Background.functions_frame
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, 380, 0, 35)
    btn.ZIndex = 10
    btn.Font = Enum.Font.GothamBold
    btn.Text = name
    btn.TextColor3 = BLUE.text
    btn.TextScaled = true
    btn.TextSize = 14
    btn.TextWrapped = true

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = btn

    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 4
    UIStroke.Parent = btn

    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(39, 36, 47)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(46, 43, 56))
    }
    UIGradient.Rotation = 36
    UIGradient.Parent = UIStroke

    btn.MouseEnter:Connect(function()
        tween_service:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(45, 42, 55)
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        tween_service:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)

    btn.MouseButton1Up:Connect(function()
        local sound = Instance.new("Sound", game:GetService("SoundService"))
        sound.SoundId = "rbxassetid://8816939097"
        sound:Play()
        callback()
    end)
    btn.TouchTap:Connect(callback)

    run_service.Heartbeat:Connect(function()
        if not section_name:match(ui_data.current_section) and not table.find(search_table, name) then
            btn.Visible = false
        else
            btn.Visible = true
        end
    end)
end

-- ======================== CREATE SLIDER ========================
function nurysium: create_slider(name, section_name, min, max, default, callback)
    if not ui then return end
    task.wait(0.15)
    callback = callback or function() end
    local value = math.clamp(default, min, max)

    local frame = Instance.new("Frame")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local UIGradient = Instance.new("UIGradient")
    local Title = Instance.new("TextLabel")
    local ValueLabel = Instance.new("TextLabel")
    local Track = Instance.new("Frame")
    local Fill = Instance.new("Frame")
    local UICorner_Fill = Instance.new("UICorner")
    local Hitbox = Instance.new("TextButton")
    local UICorner_Track = Instance.new("UICorner")

    frame.Name = name
    frame.Parent = ui.Background.functions_frame
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 380, 0, 50)
    frame.ZIndex = 10

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = frame

    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 4
    UIStroke.Parent = frame

    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(39, 36, 47)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(46, 43, 56))
    }
    UIGradient.Rotation = 36
    UIGradient.Parent = UIStroke

    Title.Name = "Title"
    Title.Parent = frame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.044, 0, 0.1, 0)
    Title.Size = UDim2.new(0, 180, 0, 20)
    Title.ZIndex = 10
    Title.Font = Enum.Font.GothamBold
    Title.Text = name
    Title.TextColor3 = BLUE.text
    Title.TextScaled = true
    Title.TextSize = 14
    Title.TextWrapped = true
    Title.TextXAlignment = Enum.TextXAlignment.Left

    ValueLabel.Name = "ValueLabel"
    ValueLabel.Parent = frame
    ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ValueLabel.BackgroundTransparency = 1.000
    ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ValueLabel.BorderSizePixel = 0
    ValueLabel.Position = UDim2.new(0.78, 0, 0.1, 0)
    ValueLabel.Size = UDim2.new(0, 60, 0, 20)
    ValueLabel.ZIndex = 10
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(value)
    ValueLabel.TextColor3 = BLUE.primary
    ValueLabel.TextScaled = true
    ValueLabel.TextSize = 14
    ValueLabel.TextWrapped = true
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

    Track.Name = "Track"
    Track.Parent = frame
    Track.BackgroundColor3 = Color3.fromRGB(27, 24, 35)
    Track.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Track.BorderSizePixel = 0
    Track.Position = UDim2.new(0.044, 0, 0.65, 0)
    Track.Size = UDim2.new(0.91, 0, 0, 6)
    Track.ZIndex = 15

    UICorner_Track.CornerRadius = UDim.new(0, 3)
    UICorner_Track.Parent = Track

    Fill.Name = "Fill"
    Fill.Parent = Track
    Fill.BackgroundColor3 = BLUE.primary
    Fill.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Fill.BorderSizePixel = 0
    Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    Fill.ZIndex = 16

    UICorner_Fill.CornerRadius = UDim.new(0, 3)
    UICorner_Fill.Parent = Fill

    Hitbox.Name = "Hitbox"
    Hitbox.Parent = frame
    Hitbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Hitbox.BackgroundTransparency = 1.000
    Hitbox.BorderColor3 = Color3.fromRGB(0, 0, 0)
    Hitbox.BorderSizePixel = 0
    Hitbox.Size = UDim2.new(1, 0, 1, 0)
    Hitbox.Font = Enum.Font.SourceSans
    Hitbox.Text = ""
    Hitbox.TextColor3 = Color3.fromRGB(0, 0, 0)
    Hitbox.TextSize = 1

    local function update_slider(input_pos)
        local track_pos = Track.AbsolutePosition
        local track_size = Track.AbsoluteSize
        local relative_x = math.clamp((input_pos.X - track_pos.X) / track_size.X, 0, 1)
        local new_value = math.floor(min + (max - min) * relative_x + 0.5)
        new_value = math.clamp(new_value, min, max)
        if new_value ~= value then
            value = new_value
            ValueLabel.Text = tostring(value)
            Fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
            callback(value)
        end
    end

    local is_dragging = false
    Hitbox.MouseButton1Down:Connect(function()
        is_dragging = true
        update_slider(user_input:GetMouseLocation())
    end)

    Hitbox.TouchTap:Connect(function()
        update_slider(user_input:GetMouseLocation())
    end)

    user_input.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            is_dragging = false
        end
    end)

    user_input.InputChanged:Connect(function(input)
        if is_dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            update_slider(input.Position)
        end
    end)

    run_service.Heartbeat:Connect(function()
        if not section_name:match(ui_data.current_section) and not table.find(search_table, name) then
            frame.Visible = false
        else
            frame.Visible = true
        end
    end)
end

-- ======================== CREATE LABEL ========================
function nurysium: create_label(name, section_name)
    if not ui then return end
    task.wait(0.15)

    local label = Instance.new("TextLabel")
    local UICorner = Instance.new("UICorner")
    local UIStroke = Instance.new("UIStroke")
    local UIGradient = Instance.new("UIGradient")

    label.Name = name
    label.Parent = ui.Background.functions_frame
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    label.BorderColor3 = Color3.fromRGB(0, 0, 0)
    label.BorderSizePixel = 0
    label.Size = UDim2.new(0, 380, 0, 25)
    label.ZIndex = 10
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(180, 180, 200)
    label.TextScaled = true
    label.TextSize = 14
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = label

    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.fromRGB(255, 255, 255)
    UIStroke.Thickness = 4
    UIStroke.Parent = label

    UIGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(39, 36, 47)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(46, 43, 56))
    }
    UIGradient.Rotation = 36
    UIGradient.Parent = UIStroke

    run_service.Heartbeat:Connect(function()
        if not section_name:match(ui_data.current_section) and not table.find(search_table, name) then
            label.Visible = false
        else
            label.Visible = true
        end
    end)
end

-- ======================== NOTIFICATION ========================
function nurysium: MakeNotify(data)
    if not ui then return end
    local title = data.Title or "Notification"
    local content = data.Content or ""

    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 60)
    notif.Position = UDim2.new(1, -320, 0, 10)
    notif.BackgroundColor3 = Color3.fromRGB(39, 36, 47)
    notif.BorderSizePixel = 0
    notif.BackgroundTransparency = 0.1
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif

    local border = Instance.new("UIStroke")
    border.Thickness = 2
    border.Color = BLUE.primary
    border.Parent = notif

    notif.Parent = ui

    local titleL = Instance.new("TextLabel")
    titleL.Size = UDim2.new(1, -20, 0, 20)
    titleL.Position = UDim2.new(0, 10, 0, 5)
    titleL.BackgroundTransparency = 1
    titleL.Text = title
    titleL.TextColor3 = BLUE.primary
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.Font = Enum.Font.GothamBold
    titleL.TextSize = 14
    titleL.Parent = notif

    local contL = Instance.new("TextLabel")
    contL.Size = UDim2.new(1, -20, 0, 30)
    contL.Position = UDim2.new(0, 10, 0, 25)
    contL.BackgroundTransparency = 1
    contL.Text = content
    contL.TextColor3 = Color3.fromRGB(200, 200, 210)
    contL.TextXAlignment = Enum.TextXAlignment.Left
    contL.Font = Enum.Font.Gotham
    contL.TextSize = 12
    contL.TextWrapped = true
    contL.Parent = notif

    tween_service:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, -320, 0, 20)
    }):Play()

    task.wait(3)
    tween_service:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, -320, 0, -100),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.5)
    notif:Destroy()
end

return nurysium

-- =====================================================
-- SOURCE SCRIPT UTAMA (MOBILE OPTIMIZED)
-- =====================================================
local Library = nurysium
Library:init("Nurysium Mobile", game:GetService("CoreGui"))

Library:create_section("⚡ Player", 6031431039)
Library:create_section("🌐 World", 6031431039)
Library:create_section("⚙️ Settings", 6031431039)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
end)

local state = {
    autoJump = false,
    fly = false,
    noclip = false,
    esp = false,
    jumpConn = nil,
}

Library:create_slider("WalkSpeed", "⚡ Player", 10, 100, 16, function(val)
    pcall(function() if humanoid then humanoid.WalkSpeed = val end end)
end)

Library:create_toggle("Auto Jump", "⚡ Player", function(toggled)
    state.autoJump = toggled
    task.spawn(function()
        while state.autoJump and task.wait(0.25) do
            pcall(function()
                if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end)
end)

local flyButtons = nil
Library:create_toggle("Fly Mode", "⚡ Player", function(toggled)
    state.fly = toggled
    if toggled then
        if not flyButtons then
            flyButtons = Instance.new("Frame")
            flyButtons.Name = "FlyControls"
            flyButtons.Size = UDim2.new(0, 200, 0, 200)
            flyButtons.Position = UDim2.new(0, 10, 0.5, -100)
            flyButtons.BackgroundTransparency = 1
            flyButtons.Parent = ui

            local btnUp = Instance.new("TextButton")
            btnUp.Size = UDim2.new(0, 60, 0, 60)
            btnUp.Position = UDim2.new(0.5, -30, 0, 0)
            btnUp.Text = "⬆"
            btnUp.Font = Enum.Font.GothamBold
            btnUp.TextSize = 30
            btnUp.BackgroundColor3 = BLUE.primary
            btnUp.TextColor3 = Color3.new(1, 1, 1)
            btnUp.Parent = flyButtons
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 15)
            corner.Parent = btnUp

            local btnDown = Instance.new("TextButton")
            btnDown.Size = UDim2.new(0, 60, 0, 60)
            btnDown.Position = UDim2.new(0.5, -30, 1, -60)
            btnDown.Text = "⬇"
            btnDown.Font = Enum.Font.GothamBold
            btnDown.TextSize = 30
            btnDown.BackgroundColor3 = BLUE.primary
            btnDown.TextColor3 = Color3.new(1, 1, 1)
            btnDown.Parent = flyButtons
            local corner2 = Instance.new("UICorner")
            corner2.CornerRadius = UDim.new(0, 15)
            corner2.Parent = btnDown

            local btnLeft = Instance.new("TextButton")
            btnLeft.Size = UDim2.new(0, 60, 0, 60)
            btnLeft.Position = UDim2.new(0, 0, 0.5, -30)
            btnLeft.Text = "⬅"
            btnLeft.Font = Enum.Font.GothamBold
            btnLeft.TextSize = 30
            btnLeft.BackgroundColor3 = BLUE.primary
            btnLeft.TextColor3 = Color3.new(1, 1, 1)
            btnLeft.Parent = flyButtons
            local corner3 = Instance.new("UICorner")
            corner3.CornerRadius = UDim.new(0, 15)
            corner3.Parent = btnLeft

            local btnRight = Instance.new("TextButton")
            btnRight.Size = UDim2.new(0, 60, 0, 60)
            btnRight.Position = UDim2.new(1, -60, 0.5, -30)
            btnRight.Text = "➡"
            btnRight.Font = Enum.Font.GothamBold
            btnRight.TextSize = 30
            btnRight.BackgroundColor3 = BLUE.primary
            btnRight.TextColor3 = Color3.new(1, 1, 1)
            btnRight.Parent = flyButtons
            local corner4 = Instance.new("UICorner")
            corner4.CornerRadius = UDim.new(0, 15)
            corner4.Parent = btnRight

            local btnUpAlt = Instance.new("TextButton")
            btnUpAlt.Size = UDim2.new(0, 60, 0, 60)
            btnUpAlt.Position = UDim2.new(1, 10, 0.5, -90)
            btnUpAlt.Text = "▲"
            btnUpAlt.Font = Enum.Font.GothamBold
            btnUpAlt.TextSize = 30
            btnUpAlt.BackgroundColor3 = BLUE.dark
            btnUpAlt.TextColor3 = Color3.new(1, 1, 1)
            btnUpAlt.Parent = flyButtons
            local corner5 = Instance.new("UICorner")
            corner5.CornerRadius = UDim.new(0, 15)
            corner5.Parent = btnUpAlt

            local btnDownAlt = Instance.new("TextButton")
            btnDownAlt.Size = UDim2.new(0, 60, 0, 60)
            btnDownAlt.Position = UDim2.new(1, 10, 0.5, 30)
            btnDownAlt.Text = "▼"
            btnDownAlt.Font = Enum.Font.GothamBold
            btnDownAlt.TextSize = 30
            btnDownAlt.BackgroundColor3 = BLUE.dark
            btnDownAlt.TextColor3 = Color3.new(1, 1, 1)
            btnDownAlt.Parent = flyButtons
            local corner6 = Instance.new("UICorner")
            corner6.CornerRadius = UDim.new(0, 15)
            corner6.Parent = btnDownAlt

            local flyDir = Vector3.new(0, 0, 0)
            local flySpeed = 50

            local function updateFly()
                if not state.fly then return end
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local vel = root:FindFirstChild("FlyVelocity")
                if not vel then
                    vel = Instance.new("BodyVelocity")
                    vel.Name = "FlyVelocity"
                    vel.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                    vel.Parent = root
                end
                vel.Velocity = flyDir * flySpeed
            end

            local function setupBtn(btn, dir)
                btn.MouseButton1Down:Connect(function()
                    flyDir = flyDir + dir
                    updateFly()
                end)
                btn.MouseButton1Up:Connect(function()
                    flyDir = flyDir - dir
                    updateFly()
                end)
                btn.TouchBegan:Connect(function()
                    flyDir = flyDir + dir
                    updateFly()
                end)
                btn.TouchEnded:Connect(function()
                    flyDir = flyDir - dir
                    updateFly()
                end)
            end

            setupBtn(btnUp, Vector3.new(0, 0, -1))
            setupBtn(btnDown, Vector3.new(0, 0, 1))
            setupBtn(btnLeft, Vector3.new(-1, 0, 0))
            setupBtn(btnRight, Vector3.new(1, 0, 0))
            setupBtn(btnUpAlt, Vector3.new(0, 1, 0))
            setupBtn(btnDownAlt, Vector3.new(0, -1, 0))

            task.spawn(function()
                while state.fly and task.wait(0.05) do
                    pcall(function()
                        local root = character and character:FindFirstChild("HumanoidRootPart")
                        if not root then return end
                        local vel = root:FindFirstChild("FlyVelocity")
                        if vel then
                            vel.Velocity = flyDir * flySpeed
                        end
                    end)
                end
            end)
        end
        flyButtons.Visible = true
    else
        if flyButtons then flyButtons.Visible = false end
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            local vel = root:FindFirstChild("FlyVelocity")
            if vel then vel:Destroy() end
        end
    end
end)

Library:create_button("💚 Full Heal", "⚡ Player", function()
    pcall(function()
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            Library:MakeNotify({ Title = "Heal", Content = "Full HP!" })
        end
    end)
end)

Library:create_button("🚀 Teleport to Base", "🌐 World", function()
    local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Baseplate")
    if spawn and humanoid then
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
            Library:MakeNotify({ Title = "Teleport", Content = "Teleported!" })
        end
    else
        Library:MakeNotify({ Title = "Error", Content = "Spawn not found" })
    end
end)

Library:create_toggle("Noclip", "🌐 World", function(toggled)
    state.noclip = toggled
    task.spawn(function()
        while state.noclip and task.wait(0.1) do
            pcall(function()
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
        if not state.noclip then
            pcall(function()
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end)
        end
    end)
end)

Library:create_toggle("ESP Player", "⚙️ Settings", function(toggled)
    state.esp = toggled
    task.spawn(function()
        while state.esp and task.wait(0.5) do
            pcall(function()
                for _, plr in ipairs(game.Players:GetPlayers()) do
                    if plr ~= player then
                        local char = plr.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            local hl = char:FindFirstChild("ESP_Highlight")
                            if not hl then
                                hl = Instance.new("Highlight")
                                hl.Name = "ESP_Highlight"
                                hl.FillColor = BLUE.primary
                                hl.FillTransparency = 0.5
                                hl.OutlineColor = Color3.new(1, 1, 1)
                                hl.Parent = char
                            end
                        end
                    end
                end
            end)
        end
        if not state.esp then
            for _, plr in ipairs(game.Players:GetPlayers()) do
                local char = plr.Character
                if char then
                    local hl = char:FindFirstChild("ESP_Highlight")
                    if hl then hl:Destroy() end
                end
            end
        end
    end)
end)

Library:create_toggle("Infinite Jump (Mobile)", "⚙️ Settings", function(toggled)
    if toggled then
        local conn
        conn = game:GetService("UserInputService").JumpRequest:Connect(function()
            pcall(function()
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end)
        state.jumpConn = conn
        Library:MakeNotify({ Title = "Infinite Jump", Content = "Enabled!" })
    else
        if state.jumpConn then
            state.jumpConn:Disconnect()
            state.jumpConn = nil
            Library:MakeNotify({ Title = "Infinite Jump", Content = "Disabled!" })
        end
    end
end)

task.wait(1)
Library:MakeNotify({ Title = "🚀 Mobile Script Loaded", Content = "Tap logo to toggle menu" })
print("✅ Mobile-ready script running!")
