-- =====================================================
-- BYPASS ANTI-CHEAT VIA REMOTE INTERCEPT
-- =====================================================
print("🛡️ Mengaktifkan bypass via Remote...")

local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

-- Fungsi untuk menghancurkan remote yang mencurigakan
local function destroySecurityRemotes()
    local security = replicatedStorage:FindFirstChild("Security")
    if security then
        for _, child in pairs(security:GetChildren()) do
            if child:IsA("RemoteEvent") or child:IsA("RemoteFunction") then
                child:Destroy()
            end
        end
        security:Destroy()
    end
    -- Destroy remote spesifik jika ada
    pcall(function()
        replicatedStorage.Security.RemoteEvent:Destroy()
        replicatedStorage.Security[""]:Destroy()
    end)
end

-- Intercept remote baru yang dibuat (hook)
local function hookRemoteCreation()
    local meta = getrawmetatable(game)
    local oldNamecall = meta.__namecall
    setreadonly(meta, false)
    meta.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FindFirstChild" or method == "WaitForChild" then
            local result = oldNamecall(self, ...)
            if result and (result:IsA("RemoteEvent") or result:IsA("RemoteFunction")) then
                -- Jika remote mengandung kata "Security" atau "Anti", hancurkan
                if result.Name:lower():find("security") or result.Name:lower():find("anti") then
                    result:Destroy()
                    return nil
                end
            end
            return result
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(meta, true)
end

-- Matikan DeviceChecker
pcall(function()
    local deviceChecker = localPlayer.PlayerScripts:FindFirstChild("Client"):FindFirstChild("DeviceChecker")
    if deviceChecker then deviceChecker:Destroy() end
end)

-- Eksekusi bypass
destroySecurityRemotes()
hookRemoteCreation()
print("✅ Anti-Cheat bypassed via Remote Intercept!")

-- =====================================================
-- SETTING DEFAULT
-- =====================================================
getgenv().Aeloe = {
    AutoParry = true,
    PingBased = true,
    PingBasedOffset = 1.95,
    DistanceToParry = 0.65,
    EmergencyRadius = 10,
    ClashDistance = 10,
    ClashSpeed = 0.01,
    NormalSpeed = 0.05,
    Visuals = true,
    UseMouseClick = false
}
local SETTINGS = getgenv().Aeloe

-- =====================================================
-- BUAT UI CUSTOM
-- =====================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AeloeUI"
screenGui.Parent = localPlayer.PlayerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 350, 0, 500)
frame.Position = UDim2.new(0.5, -175, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Aeloe Parry [Remote Bypass]"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local scrolling = Instance.new("ScrollingFrame")
scrolling.Size = UDim2.new(1, -10, 1, -40)
scrolling.Position = UDim2.new(0, 5, 0, 35)
scrolling.BackgroundTransparency = 1
scrolling.CanvasSize = UDim2.new(0, 0, 0, 800)
scrolling.ScrollBarThickness = 4
scrolling.Parent = frame

local function addLabel(text, y)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 20)
    lbl.Position = UDim2.new(0, 5, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = scrolling
    return lbl
end

local function addToggle(text, default, y, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 30)
    container.Position = UDim2.new(0, 5, 0, y)
    container.BackgroundTransparency = 1
    container.Parent = scrolling

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.7, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = container

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 1, -4)
    btn.Position = UDim2.new(1, -55, 0, 2)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = container
    local cornerBtn = Instance.new("UICorner")
    cornerBtn.CornerRadius = UDim.new(0, 4)
    cornerBtn.Parent = btn

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    return btn
end

local function addSlider(text, min, max, default, y, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -10, 0, 40)
    container.Position = UDim2.new(0, 5, 0, y)
    container.BackgroundTransparency = 1
    container.Parent = scrolling

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. tostring(default)
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextScaled = true
    lbl.Font = Enum.Font.Gotham
    lbl.Parent = container

    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0, 20)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    slider.BorderSizePixel = 0
    slider.Parent = container
    local cornerSlide = Instance.new("UICorner")
    cornerSlide.CornerRadius = UDim.new(0, 4)
    cornerSlide.Parent = slider

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    local cornerFill = Instance.new("UICorner")
    cornerFill.CornerRadius = UDim.new(0, 4)
    cornerFill.Parent = fill

    local dragging = false
    local function updateSlider(input)
        local pos = input.Position.X
        local rel = (pos - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
        local val = math.clamp(rel, 0, 1) * (max - min) + min
        val = math.round(val * 100) / 100
        fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
        lbl.Text = text .. ": " .. tostring(val)
        callback(val)
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    slider.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return fill
end

-- BUILD UI
local y = 5
addLabel("--- Pengaturan Dasar ---", y); y = y + 25
addToggle("Auto Parry", SETTINGS.AutoParry, y, function(v) SETTINGS.AutoParry = v end); y = y + 35
addToggle("Prediksi Ping", SETTINGS.PingBased, y, function(v) SETTINGS.PingBased = v end); y = y + 35
addSlider("Offset Ping", 1, 3, SETTINGS.PingBasedOffset, y, function(v) SETTINGS.PingBasedOffset = v end); y = y + 50
addSlider("Jarak Parry", 0.1, 2, SETTINGS.DistanceToParry, y, function(v) SETTINGS.DistanceToParry = v end); y = y + 50
addSlider("Radius Darurat", 1, 20, SETTINGS.EmergencyRadius, y, function(v) SETTINGS.EmergencyRadius = v end); y = y + 50

addLabel("--- Pengaturan Lanjutan ---", y); y = y + 25
addSlider("Jarak Clash", 5, 30, SETTINGS.ClashDistance, y, function(v) SETTINGS.ClashDistance = v end); y = y + 50
addSlider("Kecepatan Clash", 0.001, 0.1, SETTINGS.ClashSpeed, y, function(v) SETTINGS.ClashSpeed = v end); y = y + 50
addSlider("Kecepatan Normal", 0.01, 0.2, SETTINGS.NormalSpeed, y, function(v) SETTINGS.NormalSpeed = v end); y = y + 50
addToggle("Visual Lingkaran", SETTINGS.Visuals, y, function(v)
    SETTINGS.Visuals = v
    if not v and _G.AeloeCircle then _G.AeloeCircle.Transparency = 1 end
end); y = y + 35
addToggle("Gunakan mouse1click()", SETTINGS.UseMouseClick, y, function(v) SETTINGS.UseMouseClick = v end); y = y + 35

scrolling.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- DRAG FRAME
local draggingMain = false
local dragStartMain = nil
local startPosMain = nil
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = true
        dragStartMain = input.Position
        startPosMain = frame.Position
    end
end)
frame.InputChanged:Connect(function(input)
    if draggingMain and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartMain
        frame.Position = UDim2.new(
            startPosMain.X.Scale,
            startPosMain.X.Offset + delta.X,
            startPosMain.Y.Scale,
            startPosMain.Y.Offset + delta.Y
        )
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingMain = false
    end
end)

-- FLOATING BUTTON
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 50, 0, 50)
floatBtn.Position = UDim2.new(0, 10, 0, 10)
floatBtn.Text = "⏺"
floatBtn.TextScaled = true
floatBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.BorderSizePixel = 0
floatBtn.Parent = screenGui
local cornerFloat = Instance.new("UICorner")
cornerFloat.CornerRadius = UDim.new(1, 0)
cornerFloat.Parent = floatBtn

local draggingFloat = false
local dragStartFloat = nil
local startPosFloat = nil
floatBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFloat = true
        dragStartFloat = input.Position
        startPosFloat = floatBtn.Position
    end
end)
floatBtn.InputChanged:Connect(function(input)
    if draggingFloat and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartFloat
        floatBtn.Position = UDim2.new(
            startPosFloat.X.Scale,
            startPosFloat.X.Offset + delta.X,
            startPosFloat.Y.Scale,
            startPosFloat.Y.Offset + delta.Y
        )
    end
end)
floatBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingFloat = false
    end
end)

floatBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    if frame.Visible then
        floatBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
        floatBtn.Text = "⏺"
    else
        floatBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        floatBtn.Text = "⏸"
    end
end)

-- =====================================================
-- CORE AUTO PARRY
-- =====================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer

local LastClick = 0
local LastBallHit = nil
local IsParrying = false
local frameCounter = 0

local BallsFolder = workspace:FindFirstChild("Balls")
if not BallsFolder then
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name:lower():find("ball") and v:IsA("Folder") then
            BallsFolder = v
            break
        end
    end
end
if not BallsFolder then
    BallsFolder = Instance.new("Folder")
    BallsFolder.Name = "Balls"
    BallsFolder.Parent = workspace
end

local NetworkStats = Stats:FindFirstChild("Network")
    and Stats.Network:FindFirstChild("ServerStatsItem")
    and Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")

local r, m
if SETTINGS.Visuals then
    r = Instance.new("Part")
    r.Name = "AeloeSmartCircle"
    r.Parent = workspace
    r.Anchored = true
    r.CanCollide = false
    r.Transparency = 0.3
    r.Material = Enum.Material.Neon
    m = Instance.new("SpecialMesh", r)
    m.MeshId = "rbxassetid://3270017"
    _G.AeloeCircle = r
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.L then
        SETTINGS.AutoParry = not SETTINGS.AutoParry
    end
end)

local function GetBall()
    if not BallsFolder then return nil end
    local children = BallsFolder:GetChildren()
    for i = 1, #children do
        local v = children[i]
        if v:GetAttribute("realBall") == true then return v end
    end
    for i = 1, #children do
        local v = children[i]
        if v:IsA("BasePart") and v.AssemblyLinearVelocity.Magnitude > 15 then
            return v
        end
    end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("ball") and v.AssemblyLinearVelocity.Magnitude > 20 then
            return v
        end
    end
    return nil
end

local function IsTargeted()
    if not Player.Character then return false end
    return Player.Character:GetAttribute("Targeted") == true
        or Player.Character:FindFirstChild("Highlight") ~= nil
end

local function SendClick(isClashing, ball)
    if not SETTINGS.AutoParry or IsParrying then return end
    local now = tick()
    local cd = isClashing and SETTINGS.ClashSpeed or SETTINGS.NormalSpeed

    if not isClashing and LastBallHit == ball and (now - LastClick) < 0.5 then return end
    if (now - LastClick) < cd then return end

    IsParrying = true
    LastClick = now
    LastBallHit = ball

    if SETTINGS.UseMouseClick then
        mouse1click()
    else
        local delay = 0.008 + math.random() * 0.01
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(delay)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end

    task.delay(cd, function()
        IsParrying = false
    end)
end

local function UpdateVisuals(root, distance, state)
    if not SETTINGS.Visuals or not r then return end
    r.CFrame = root.CFrame * CFrame.new(0, -2.6, 0) * CFrame.Angles(math.rad(90), 0, 0)
    local targetSize = math.clamp(distance * 0.8, 5, 65)
    m.Scale = m.Scale:Lerp(Vector3.new(targetSize, targetSize, 0.5), 0.5)

    if state == "clash" then
        r.Color = Color3.fromRGB(255, 0, 0)
        r.Transparency = 0.05
    elseif state == "target" then
        r.Color = Color3.fromRGB(0, 255, 255)
        r.Transparency = 0.1
    else
        r.Color = Color3.fromRGB(150, 240, 255)
        r.Transparency = 0.5
    end
end

RunService.PostSimulation:Connect(function()
    if not SETTINGS.AutoParry then
        if r then r.Transparency = 1 end
        return
    end

    local Char = Player.Character
    local Root = Char and Char:FindFirstChild("HumanoidRootPart")
    if not Root then
        if r then r.Transparency = 1 end
        return
    end

    local Ball = GetBall()
    if not Ball then
        if r then r.Transparency = 1 end
        return
    end

    local BallPos = Ball.Position
    local PlayerPos = Root.Position
    local Velocity = Ball.AssemblyLinearVelocity
    local Speed = Velocity.Magnitude
    local Distance = (PlayerPos - BallPos).Magnitude

    local directionToPlayer = (PlayerPos - BallPos).Unit
    local velocityDirection = Velocity.Unit
    local dot = directionToPlayer:Dot(velocityDirection)

    if dot < 0 then LastBallHit = nil end

    local Targeted = IsTargeted()
    local IsClashing = Targeted and Distance <= SETTINGS.ClashDistance

    frameCounter = frameCounter + 1
    if r and frameCounter % 2 == 0 then
        r.Transparency = 0.3
        UpdateVisuals(Root, Distance, IsClashing and "clash" or (Targeted and "target" or "neutral"))
    end

    if IsClashing then
        SendClick(true, Ball)
    elseif Targeted and dot > 0 then
        local Ping = (NetworkStats and NetworkStats.Value / 1000) or 0.04
        local TimeToHit = Distance / math.max(Speed, 1)
        local PredictionThreshold = SETTINGS.DistanceToParry + (Ping * SETTINGS.PingBasedOffset)

        if Speed > 150 then
            PredictionThreshold = PredictionThreshold * 1.15
        end

        if TimeToHit <= PredictionThreshold or Distance <= SETTINGS.EmergencyRadius then
            SendClick(false, Ball)
        end
    end
end)

Player.CharacterAdded:Connect(function()
    LastBallHit = nil
    IsParrying = false
end)

print("✅ Aeloe Parry loaded! Tekan L untuk toggle Auto Parry.")