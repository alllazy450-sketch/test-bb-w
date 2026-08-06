-- ====================================================================
-- FLURIORE UI - DARK BLUE THEME
-- ====================================================================
local Fluriore = {}
Fluriore.__index = Fluriore

-- Service
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Theme Colors (Dark Blue)
local Colors = {
    Background = Color3.fromRGB(20, 25, 45),
    Secondary = Color3.fromRGB(30, 40, 70),
    Accent = Color3.fromRGB(40, 80, 180),
    AccentHover = Color3.fromRGB(60, 120, 220),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 190, 210),
    Border = Color3.fromRGB(60, 80, 140),
    ToggleOn = Color3.fromRGB(40, 80, 180),
    ToggleOff = Color3.fromRGB(80, 80, 100),
    Slider = Color3.fromRGB(40, 80, 180),
    SliderBg = Color3.fromRGB(40, 45, 70),
}

-- Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlurioreUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 550)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Corner
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

-- Stroke
local Stroke = Instance.new("UIStroke")
Stroke.Color = Colors.Border
Stroke.Thickness = 1.5
Stroke.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 10, 1, 10)
Shadow.Position = UDim2.new(0, -5, 0, -5)
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.BorderSizePixel = 0
Shadow.ZIndex = -1
Shadow.Parent = MainFrame

local ShadowCorner = Instance.new("UICorner")
ShadowCorner.CornerRadius = UDim.new(0, 12)
ShadowCorner.Parent = Shadow

-- ============================================================
-- HEADER
-- ============================================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Colors.Secondary
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "Fluriore UI"
Title.TextColor3 = Colors.Text
Title.TextScaled = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.TextDim
CloseBtn.TextScaled = true
CloseBtn.BackgroundTransparency = 1
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ============================================================
-- TABS
-- ============================================================
local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(1, 0, 0, 40)
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local TabButtons = {}
local TabContents = {}
local activeTab = nil

local function createTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "Tab"
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, #TabButtons * 85 + 10, 0, 0)
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Colors.TextDim
    btn.TextScaled = true
    btn.BackgroundTransparency = 1
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = TabContainer
    table.insert(TabButtons, btn)

    -- Content
    local content = Instance.new("Frame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, -20, 1, -100)
    content.Position = UDim2.new(0, 10, 0, 100)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.Parent = MainFrame
    table.insert(TabContents, content)

    btn.MouseButton1Click:Connect(function()
        for i, tab in ipairs(TabContents) do
            tab.Visible = (i == #TabContents)
        end
        for _, b in ipairs(TabButtons) do
            b.TextColor3 = Colors.TextDim
        end
        btn.TextColor3 = Colors.Accent
        activeTab = name
    end)

    if #TabButtons == 1 then
        btn.TextColor3 = Colors.Accent
        content.Visible = true
        activeTab = name
    end

    return content
end

-- ============================================================
-- UI ELEMENTS HELPERS
-- ============================================================
local function createSection(parent, title, yPos)
    local section = Instance.new("Frame")
    section.Name = title .. "Section"
    section.Size = UDim2.new(1, 0, 0, 30)
    section.Position = UDim2.new(0, 0, 0, yPos)
    section.BackgroundTransparency = 1
    section.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Text = title
    label.TextColor3 = Colors.Accent
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 14
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Parent = section

    return section
end

local function createToggle(parent, labelText, default, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Colors.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 13
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local toggle = Instance.new("Frame")
    toggle.Size = UDim2.new(0, 40, 0, 20)
    toggle.Position = UDim2.new(1, -45, 0.5, -10)
    toggle.BackgroundColor3 = default and Colors.ToggleOn or Colors.ToggleOff
    toggle.BorderSizePixel = 0
    toggle.Parent = frame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 16, 0, 16)
    indicator.Position = UDim2.new(default and 0.55 or 0.05, 0, 0.5, -8)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle

    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator

    local state = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Parent = toggle

    btn.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
        local targetPos = state and 0.55 or 0.05
        TweenService:Create(indicator, TweenInfo.new(0.15), {Position = UDim2.new(targetPos, 0, 0.5, -8)}):Play()
        if callback then callback(state) end
    end)

    return {setState = function(v) 
        state = v
        toggle.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
        indicator.Position = UDim2.new(state and 0.55 or 0.05, 0, 0.5, -8)
    end, getState = function() return state end}
end

local function createInput(parent, labelText, placeholder, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.3, 0, 1, 0)
    label.Text = labelText
    label.TextColor3 = Colors.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 13
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0.65, 0, 1, 0)
    box.Position = UDim2.new(0.35, 0, 0, 0)
    box.PlaceholderText = placeholder
    box.Text = ""
    box.TextColor3 = Colors.Text
    box.PlaceholderColor3 = Colors.TextDim
    box.BackgroundColor3 = Colors.Secondary
    box.BackgroundTransparency = 0.3
    box.BorderSizePixel = 0
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.Parent = frame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = box

    box.FocusLost:Connect(function()
        if callback then callback(box.Text) end
    end)

    return box
end

-- ============================================================
-- CREATE TABS
-- ============================================================

-- Tab 1: Main
local mainTab = createTab("Main", "⚔")

local mainY = 10
createSection(mainTab, "Sword Settings", mainY)
mainY = mainY + 35

local swordToggle = createToggle(mainTab, "Skin Changer", getgenv().skinChanger or false, mainY, function(v)
    getgenv().skinChanger = v
    if getgenv().setSkinChangerToggleUI then getgenv().setSkinChangerToggleUI(v) end
    if v and getgenv().updateSword then getgenv().updateSword() end
end)
mainY = mainY + 35

local swordModelInput = createInput(mainTab, "Sword Model", "e.g. Katana", mainY, function(v)
    if v ~= "" then
        getgenv().swordModel = v
        if getgenv().updateSword then getgenv().updateSword() end
    end
end)
mainY = mainY + 40

local swordAnimInput = createInput(mainTab, "Sword Anim", "e.g. Katana", mainY, function(v)
    if v ~= "" then
        getgenv().swordAnimations = v
        if getgenv().updateSword then getgenv().updateSword() end
    end
end)
mainY = mainY + 40

local swordFXInput = createInput(mainTab, "Sword FX", "e.g. FireSword", mainY, function(v)
    if v ~= "" then
        getgenv().swordFX = v
        if getgenv().updateSword then getgenv().updateSword() end
    end
end)
mainY = mainY + 40

-- Tab 2: Explosion
local expTab = createTab("Explosion", "💥")

local expY = 10
createSection(expTab, "Explosion Settings", expY)
expY = expY + 35

local expToggle = createToggle(expTab, "Explosion Changer", getgenv().explosionChanger or false, expY, function(v)
    getgenv().explosionChanger = v
    if v and getgenv().updateExplosion then getgenv().updateExplosion() end
end)
expY = expY + 35

local expFXInput = createInput(expTab, "Explosion FX", "e.g. BigExplosion", expY, function(v)
    if v ~= "" then
        getgenv().explosionFX = v
        if getgenv().updateExplosion then getgenv().updateExplosion() end
    end
end)
expY = expY + 40

-- Tab 3: Settings
local settingsTab = createTab("Settings", "⚙")

local setY = 10
createSection(settingsTab, "UI Settings", setY)
setY = setY + 35

local function createButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.4, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Colors.Text
    btn.TextSize = 14
    btn.BackgroundColor3 = Colors.Accent
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = parent

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Colors.AccentHover
    end)

    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Colors.Accent
    end)

    return btn
end

createButton(settingsTab, "Apply All", setY, function()
    if getgenv().updateAll then getgenv().updateAll() end
end)
setY = setY + 45

createButton(settingsTab, "Save Settings", setY, function()
    if getgenv().saveAllSettings then
        getgenv().saveAllSettings({
            swordModel = getgenv().swordModel or "",
            swordAnimations = getgenv().swordAnimations or "",
            swordFX = getgenv().swordFX or "",
            explosionFX = getgenv().explosionFX or "",
        })
    end
end)
setY = setY + 45

-- ============================================================
-- DRAG FUNCTIONALITY
-- ============================================================
local dragging = false
local dragStart = nil
local startPos = nil

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ============================================================
-- KEYBIND (Toggle UI with Insert key)
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ============================================================
-- RETURN
-- ============================================================
return Fluriore