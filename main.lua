-- =====================================================
-- BYPASS ANTI-CHEAT (UNIVERSAL)
-- =====================================================
pcall(function() game:GetService("ReplicatedStorage").Security.RemoteEvent:Destroy() end)
pcall(function() game:GetService("ReplicatedStorage").Security[""]:Destroy() end)
pcall(function() game:GetService("ReplicatedStorage").Security:Destroy() end)
pcall(function() game:GetService("Players").LocalPlayer.PlayerScripts.Client.DeviceChecker:Destroy() end)

local function hookRemoteCreation()
    local meta = getrawmetatable(game)
    local oldNamecall = meta.__namecall
    setreadonly(meta, false)
    meta.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FindFirstChild" or method == "WaitForChild" then
            local result = oldNamecall(self, ...)
            if result and (result:IsA("RemoteEvent") or result:IsA("RemoteFunction")) then
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
hookRemoteCreation()
print("✅ Anti-Cheat bypassed!")

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
    UseMouseClick = false,
    GameMode = "Blade Ball" -- atau "99 Nights"
}
local SETTINGS = getgenv().Aeloe

-- =====================================================
-- UI CUSTOM (UNIVERSAL)
-- =====================================================
local Player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AeloeUI"
screenGui.Parent = Player.PlayerGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 380, 0, 550)
frame.Position = UDim2.new(0.5, -190, 0.5, -275)
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
title.Text = "Aeloe Hub | " .. SETTINGS.GameMode
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35