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

    -- Background
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

    -- Sections
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

    -- real_sections (tempat section button)
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

    -- Logo
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

    -- Title
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

    -- functions_frame (ScrollingFrame untuk elemen UI)
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

    -- Search Bar
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

    -- Logo sebagai toggle UI
    logo.MouseButton1Up:Connect(function()
        nurysium:toggle()
    end)
    logo.TouchTap:Connect(function()
        nurysium:toggle()
    end)

    -- Drag handler
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

    -- Simpan referensi untuk fungsi-fungsi lain
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
    ImageLabel.Image = `rbxassetid://{imageID}`

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
    Title.Position = U