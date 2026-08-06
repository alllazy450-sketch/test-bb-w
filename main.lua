local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mc4121ban/Fluriore-UI/main/source.lua"))()

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

local Window = Library:MakeGui({
    NameHub = "Aeloe Parry",
    Description = "Auto Parry + Anti-Detection",
    Color = Color3.fromRGB(0, 200, 255)
})

local MainTab = Window:CreateTab({ Name = "Utama", Icon = "rbxassetid://16932740082" })

local BasicSection = MainTab:AddSection("Pengaturan Dasar")
BasicSection:AddToggle({
    Title = "Auto Parry",
    Content = "Aktif/nonaktifkan parry",
    Default = SETTINGS.AutoParry,
    Callback = function(v) SETTINGS.AutoParry = v end
})
BasicSection:AddToggle({
    Title = "Prediksi Ping",
    Content = "Sesuaikan timing dengan ping",
    Default = SETTINGS.PingBased,
    Callback = function(v) SETTINGS.PingBased = v end
})
BasicSection:AddSlider({
    Title = "Offset Ping",
    Content = "Pengali prediksi ping",
    Min = 1.0, Max = 3.0,
    Default = SETTINGS.PingBasedOffset,
    Callback = function(v) SETTINGS.PingBasedOffset = v end
})
BasicSection:AddSlider({
    Title = "Jarak Parry",
    Content = "Semakin kecil semakin akurat",
    Min = 0.1, Max = 2.0,
    Default = SETTINGS.DistanceToParry,
    Callback = function(v) SETTINGS.DistanceToParry = v end
})
BasicSection:AddSlider({
    Title = "Radius Darurat",
    Content = "Paksa parry jika bola terlalu dekat",
    Min = 1, Max = 20,
    Default = SETTINGS.EmergencyRadius,
    Callback = function(v) SETTINGS.EmergencyRadius = v end
})

local AdvancedSection = MainTab:AddSection("Pengaturan Lanjutan")
AdvancedSection:AddSlider({
    Title = "Jarak Clash",
    Content = "Deteksi clash (8-12 disarankan)",
    Min = 5, Max = 30,
    Default = SETTINGS.ClashDistance,
    Callback = function(v) SETTINGS.ClashDistance = v end
})
AdvancedSection:AddSlider({
    Title = "Kecepatan Clash",
    Content = "Cooldown saat clash (detik)",
    Min = 0.001, Max = 0.1,
    Default = SETTINGS.ClashSpeed,
    Callback = function(v) SETTINGS.ClashSpeed = v end
})
AdvancedSection:AddSlider({
    Title = "Kecepatan Normal",
    Content = "Cooldown normal (detik)",
    Min = 0.01, Max = 0.2,
    Default = SETTINGS.NormalSpeed,
    Callback = function(v) SETTINGS.NormalSpeed = v end
})
AdvancedSection:AddToggle({
    Title = "Visual Lingkaran",
    Content = "Tampilkan indikator",
    Default = SETTINGS.Visuals,
    Callback = function(v)
        SETTINGS.Visuals = v
        if not v and _G.AeloeCircle then _G.AeloeCircle.Transparency = 1 end
    end
})
AdvancedSection:AddToggle({
    Title = "Gunakan mouse1click()",
    Content = "Coba jika VirtualInputManager terdeteksi",
    Default = SETTINGS.UseMouseClick,
    Callback = function(v) SETTINGS.UseMouseClick = v end
})

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

local function CreateFloatingButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AeloeToggleGUI"
    screenGui.Parent = Player.PlayerGui

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 50, 0, 50)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.Text = "⏺"
    button.TextScaled = true
    button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BorderSizePixel = 0
    button.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = button

    button.MouseButton1Click:Connect(function()
        Window.Enabled = not Window.Enabled
        if Window.Enabled then
            button.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
            button.Text = "⏺"
        else
            button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            button.Text = "⏸"
        end
    end)
end

coroutine.wrap(CreateFloatingButton)()