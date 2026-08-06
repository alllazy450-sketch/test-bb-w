-- =====================================================
-- NURYSIUM UI (BLUE THEME) - MOBILE FRIENDLY
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

    -- (Kode UI sama seperti sebelumnya, saya singkat agar tidak terlalu panjang)
    -- ... [semua Instance.new dan styling] ...
    -- Tapi untuk efisiensi, saya gunakan fungsi helper.

    -- (Saya asumsikan Anda sudah punya kode UI lengkap dari sebelumnya)
    -- Untuk menghemat karakter, saya tulis ulang bagian penting saja.
    -- Silakan gunakan kode UI dari jawaban sebelumnya, bagian init().
    -- Tambahkan ini di akhir init():
    -- Logo sebagai toggle button
    local logo = ui.Background.Sections:FindFirstChild("logo")
    if logo then
        logo.MouseButton1Up:Connect(function()
            nurysium:toggle()
        end)
        logo.TouchTap:Connect(function()
            nurysium:toggle()
        end)
    end

    -- Hapus keybind Ctrl/Insert (tidak perlu di mobile)
end

-- ======================== ELEMEN UI ========================
-- (create_section, create_toggle, create_button, create_slider, create_label, MakeNotify)
-- Sama seperti sebelumnya, tidak diubah.

return nurysium

-- =====================================================
-- SOURCE SCRIPT UTAMA (MOBILE OPTIMIZED)
-- =====================================================
local Library = nurysium
Library:init("Nurysium Mobile", game:GetService("CoreGui"))

-- Buat Section
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
}

-- ================ PLAYER ================
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

-- FLY dengan tombol virtual
local flyButtons = nil
Library:create_toggle("Fly Mode", "⚡ Player", function(toggled)
    state.fly = toggled
    if toggled then
        -- Buat tombol virtual di layar (hanya jika di mobile)
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
            btnUp.TextColor3 = Color3.new(1,1,1)
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
            btnDown.TextColor3 = Color3.new(1,1,1)
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
            btnLeft.TextColor3 = Color3.new(1,1,1)
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
            btnRight.TextColor3 = Color3.new(1,1,1)
            btnRight.Parent = flyButtons
            local corner4 = Instance.new("UICorner")
            corner4.CornerRadius = UDim.new(0, 15)
            corner4.Parent = btnRight

            -- Tombol naik/turun (altitude)
            local btnUpAlt = Instance.new("TextButton")
            btnUpAlt.Size = UDim2.new(0, 60, 0, 60)
            btnUpAlt.Position = UDim2.new(1, 10, 0.5, -90)
            btnUpAlt.Text = "▲"
            btnUpAlt.Font = Enum.Font.GothamBold
            btnUpAlt.TextSize = 30
            btnUpAlt.BackgroundColor3 = BLUE.dark
            btnUpAlt.TextColor3 = Color3.new(1,1,1)
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
            btnDownAlt.TextColor3 = Color3.new(1,1,1)
            btnDownAlt.Parent = flyButtons
            local corner6 = Instance.new("UICorner")
            corner6.CornerRadius = UDim.new(0, 15)
            corner6.Parent = btnDownAlt

            -- Variabel arah
            local flyDir = Vector3.new(0,0,0)
            local flySpeed = 50

            -- Fungsi update fly
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

            -- Tombol events
            local function setupBtn(btn, dir)
                btn.MouseButton1Down:Connect(function()
                    flyDir = flyDir + dir
                    updateFly()
                end)
                btn.MouseButton1Up:Connect(function()
                    flyDir = flyDir - dir
                    updateFly()
                end)
                btn.TouchTap:Connect(function()
                    -- Untuk mobile, tap sekali toggle arah (alternatif)
                    flyDir = flyDir + dir
                    updateFly()
                    task.wait(0.1)
                    flyDir = flyDir - dir
                    updateFly()
                end)
                -- Untuk touch hold, gunakan TouchBegan/TouchEnded
                btn.TouchBegan:Connect(function()
                    flyDir = flyDir + dir
                    updateFly()
                end)
                btn.TouchEnded:Connect(function()
                    flyDir = flyDir - dir
                    updateFly()
                end)
            end

            setupBtn(btnUp, Vector3.new(0,0,-1))
            setupBtn(btnDown, Vector3.new(0,0,1))
            setupBtn(btnLeft, Vector3.new(-1,0,0))
            setupBtn(btnRight, Vector3.new(1,0,0))
            setupBtn(btnUpAlt, Vector3.new(0,1,0))
            setupBtn(btnDownAlt, Vector3.new(0,-1,0))

            -- Loop untuk apply velocity
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
        -- Hapus BodyVelocity
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            local vel = root:FindFirstChild("FlyVelocity")
            if vel then vel:Destroy() end
        end
    end
end)

-- Button Heal
Library:create_button("💚 Full Heal", "⚡ Player", function()
    pcall(function()
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            Library:MakeNotify({ Title = "Heal", Content = "Full HP!" })
        end
    end)
end)

-- ================ WORLD ================
Library:create_button("🚀 Teleport to Base", "🌐 World", function()
    local spawn = workspace:FindFirstChild("SpawnLocation") or workspace:FindFirstChild("Baseplate")
    if spawn and humanoid then
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = spawn.CFrame + Vector3.new(0,5,0)
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

-- ================ SETTINGS ================
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
                                hl.OutlineColor = Color3.new(1,1,1)
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
        -- Simpan koneksi ke state agar bisa di-disconnect
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

-- Notifikasi awal
task.wait(1)
Library:MakeNotify({ Title = "🚀 Mobile Script Loaded", Content = "Tap logo to toggle menu" })
print("✅ Mobile-ready script running!")