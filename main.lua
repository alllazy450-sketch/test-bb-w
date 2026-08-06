local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/iiivyne/robloxlua/refs/heads/main/lib.lua"))()
if not lib then warn("Gagal memuat library UI!") return end

local int = lib:CreateInterface("99 Nights in the Forest","script by lohjc","https://discord.gg/ZNTHTWx7KE","bottom left","royal")

local main = int:CreateTab("Main","main functions/script utilities","default",true)
local autofarmss = int:CreateTab("Auto","auto farm utilities (OP)","op")
local itemtp = int:CreateTab("Item TP/ESP","bring items to you","item")
local gametp = int:CreateTab("Game TP","goto in-game locations","info")
local charactertp = int:CreateTab("Mob TP","bring mobs to you","npc")
local plr = int:CreateTab("Player","modify your localplayer","player")
local vis = int:CreateTab("Visuals","modify autoyour visuals","visuals")
local misc = int:CreateTab("Misc","miscellaneous","misc")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- SAFE ZONE BASEPLATES
local safezoneBaseplates = {}
local baseplateSize = Vector3.new(2048, 1, 2048)
local baseY = 100
local centerPos = Vector3.new(0, baseY, 0)

for dx = -1, 1 do
    for dz = -1, 1 do
        local pos = centerPos + Vector3.new(dx * baseplateSize.X, 0, dz * baseplateSize.Z)
        local baseplate = Instance.new("Part")
        baseplate.Name = "SafeZoneBaseplate"
        baseplate.Size = baseplateSize
        baseplate.Position = pos
        baseplate.Anchored = true
        baseplate.CanCollide = true
        baseplate.Transparency = 1
        baseplate.Color = Color3.fromRGB(255, 255, 255)
        baseplate.Parent = workspace
        table.insert(safezoneBaseplates, baseplate)
    end
end

main:CreateCheckbox("Show Safe Zone", function(enabled)
    for _, baseplate in ipairs(safezoneBaseplates) do
        baseplate.Transparency = enabled and 0.8 or 1
        baseplate.CanCollide = enabled
    end
end)

local function stringToCFrame(str)
    local x, y, z = str:match("([^,]+),%s*([^,]+),%s*([^,]+)")
    return CFrame.new(tonumber(x), tonumber(y), tonumber(z))
end

local function teleportToTarget(cf, duration)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if duration and duration > 0 then
        local ts = game:GetService("TweenService")
        local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local goal = { CFrame = cf }
        local tween = ts:Create(hrp, info, goal)
        tween:Play()
    else
        hrp.CFrame = cf
    end
end

local storyCoords = {
    { "[campsite] camp site", "0, 8, -0"},
    { "[safezone] safe zone", "0, 110, -0" }
}
local storyDropdown = gametp:CreateDropDown("Teleports")
for _, entry in ipairs(storyCoords) do
    local name, coord = entry[1], entry[2]
    storyDropdown:AddButton(name, function()
        teleportToTarget(stringToCFrame(coord), 0.1)
    end)
end

itemtp:CreateCheckbox("Item ESP", function(state)
    local itemFolder = workspace:FindFirstChild("Items")
    if not itemFolder then warn("workspace.Items not found") return end

    local itemNames = {
        ["Revolver"] = true, ["Oil Barrel"] = true, ["Chainsaw"] = true, ["Giant Sack"] = true,
        ["Bunny Foot"] = true, ["MedKit"] = true, ["Alien Chest"] = true, ["Berry"] = true,
        ["Bolt"] = true, ["Broken Fan"] = true, ["Carrot"] = true, ["Coal"] = true,
        ["Coin Stack"] = true, ["Hologram Emitter"] = true, ["Item Chest"] = true,
        ["Laser Fence Blueprint"] = true, ["Log"] = true, ["Old Flashlight"] = true,
        ["Old Radio"] = true, ["Sheet Metal"] = true, ["Bandage"] = true, ["Rifle"] = true
    }

    local connections = {}
    local function createESP(model)
        if not model:IsA("Model") or not itemNames[model.Name] then return end
        if not model.PrimaryPart or model:FindFirstChild("ESP") then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.Adornee = model.PrimaryPart
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)

        local customFont = Font.new("rbxassetid://16658246179", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextSize = 17
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0.5
        label.TextScaled = false
        label.FontFace = customFont
        label.Text = model.Name
        label.Parent = billboard
        billboard.Parent = model
    end

    local function removeAllESP()
        for _, model in itemFolder:GetChildren() do
            local esp = model:FindFirstChild("ESP")
            if esp then esp:Destroy() end
        end
    end

    if state then
        for _, model in itemFolder:GetChildren() do createESP(model) end
        local connection = itemFolder.ChildAdded:Connect(function(model)
            if model:IsA("Model") and itemNames[model.Name] then
                model:GetPropertyChangedSignal("PrimaryPart"):Wait()
                createESP(model)
            end
        end)
        table.insert(connections, connection)
    else
        removeAllESP()
        for _, conn in connections do
            if conn.Disconnect then conn:Disconnect() end
        end
        table.clear(connections)
    end
end)

local itemFolder = workspace:WaitForChild("Items")
local itemNames = {
    "Revolver", "Medkit", "Alien Chest", "Berry", "Bolt", "Broken Fan",
    "Carrot", "Coal", "Coin Stack", "Hologram Emitter", "Item Chest",
    "Laser Fence Blueprint", "Log", "Old Flashlight", "Old Radio",
    "Sheet Metal", "Bandage", "Rifle"
}

local function getModelPart(model)
    if model.PrimaryPart then return model.PrimaryPart end
    for _, part in pairs(model:GetChildren()) do
        if part:IsA("BasePart") then return part end
    end
    return nil
end

local dropdown = itemtp:CreateDropDown("Teleport to Item")
for _, itemName in ipairs(itemNames) do
    dropdown:AddButton("TP to " .. itemName, function()
        local candidates = {}
        for _, model in pairs(itemFolder:GetChildren()) do
            if model:IsA("Model") and model.Name == itemName then
                local part = getModelPart(model)
                if part then table.insert(candidates, part) end
            end
        end
        if #candidates == 0 then warn("No '" .. itemName .. "' found.") return end
        local targetPart = candidates[math.random(1, #candidates)]
        local character = LocalPlayer.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0) end
        end
    end)
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local rootPart = LocalPlayer.Character and LocalPlayer.Character:WaitForChild("HumanoidRootPart")

local possibleItems = {
    "Alien Chest","Alpha Wolf Pelt","Anvil Front","Anvil Back","Apple","Bandage",
    "Bear Corpse","Bear Pelt","Berry","Biofuel","Bolt","Broken Fan","Bunny Foot",
    "Carrot","Coal","Coin Stack","Cooked Morsel","Cooked Steak","Chainsaw","Cultist",
    "Cultist Gem","Flower","Fuel Canister","Hologram Emitter","Item Chest",
    "Laser Fence Blueprint","Leather Body","Iron Body","Thorn Body","Log","MedKit",
    "Morsel","Old Flashlight","Old Radio","Good Sack","Good Axe","Raygun","Giant Sack",
    "Strong Axe","Oil Barrel","Old Car Engine","Rifle","Rifle Ammo","Revolver",
    "Revolver Ammo","Sapling","Sheet Metal","Steak","Wolf Pelt","Gem of the Forest Fragment",
    "Tyre","Washing Machine","Broken Microwave"
}

local bringitemtoyou = itemtp:CreateDropDown("Teleport Item (Bulk):")
local sources = { itemFolder, ReplicatedStorage:WaitForChild("TempStorage") }

local function teleportItem(itemName)
    local stackOffsetY = 2
    local count = 0
    for _, source in ipairs(sources) do
        for _, item in ipairs(source:GetChildren()) do
            if item.Name == itemName then
                local targetPart = nil
                for _, child in ipairs(item:GetDescendants()) do
                    if child:IsA("MeshPart") or child:IsA("Part") or child:IsA("UnionOperation") then
                        targetPart = child
                        break
                    end
                end
                if targetPart then
                    remoteEvents.RequestStartDraggingItem:FireServer(item)
                    local offset = Vector3.new(0, count * stackOffsetY, 0)
                    targetPart.CFrame = rootPart.CFrame + offset
                    remoteEvents.StopDraggingItem:FireServer(item)
                    count = count + 1
                end
            end
        end
    end
end

for _, itemName in ipairs(possibleItems) do
    bringitemtoyou:AddButton(itemName, function()
        teleportItem(itemName)
    end)
end

local characterFolder = workspace:WaitForChild("Characters")
local possibleCharacters = {
    "Alpha Wolf","Bear","Lost Child","Lost Child2","Lost Child3","Lost Child4",
    "Wolf","Bunny","Cultist","Alien"
}

local bringCharacterToYou = charactertp:CreateDropDown("Teleport Mob:")
local function getMainPart(model)
    if model.PrimaryPart then return model.PrimaryPart end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then return part end
    end
    return nil
end

local function teleportCharacter(characterName)
    local stackOffsetY = 3
    local count = 0
    for _, model in ipairs(characterFolder:GetChildren()) do
        if model.Name == characterName then
            local mainPart = getMainPart(model)
            if mainPart and rootPart then
                local targetCFrame = rootPart.CFrame + Vector3.new(0, count * stackOffsetY, 0)
                if model.PrimaryPart then
                    model:SetPrimaryPartCFrame(targetCFrame)
                else
                    mainPart.CFrame = targetCFrame
                end
                count = count + 1
            end
        end
    end
end

for _, characterName in ipairs(possibleCharacters) do
    bringCharacterToYou:AddButton(characterName, function()
        teleportCharacter(characterName)
    end)
end

plr:CreateSlider("jumppower", 700, 50, function(value)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = value
    end
end)

plr:CreateSlider("walkspeed", 700, 16, function(value)
    _G.HackedWalkSpeed = value
    local function applyWalkSpeed(humanoid)
        if humanoid then
            humanoid.WalkSpeed = _G.HackedWalkSpeed
            humanoid.Changed:Connect(function(property)
                if property == "WalkSpeed" and humanoid.WalkSpeed ~= _G.HackedWalkSpeed then
                    humanoid.WalkSpeed = _G.HackedWalkSpeed
                end
            end)
        end
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        applyWalkSpeed(LocalPlayer.Character.Humanoid)
    end
    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        applyWalkSpeed(char:FindFirstChild("Humanoid"))
    end)
end)

plr:CreateCheckbox("walkspeed toggle (50)",function(toggle)
    _G.HackedWalkSpeed = toggle and 50 or 16
    local function applyWalkSpeed(humanoid)
        if humanoid then
            humanoid.WalkSpeed = _G.HackedWalkSpeed
            humanoid.Changed:Connect(function(property)
                if property == "WalkSpeed" and humanoid.WalkSpeed ~= _G.HackedWalkSpeed then
                    humanoid.WalkSpeed = _G.HackedWalkSpeed
                end
            end)
        end
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        applyWalkSpeed(LocalPlayer.Character.Humanoid)
    end
    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid")
        applyWalkSpeed(char:FindFirstChild("Humanoid"))
    end)
end)

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local espTransparency = 0.4
local teamCheck = true
local customFont = Font.new("rbxassetid://16658246179", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local BillboardESPs = {}
local ChamsESPs = {}
local ESPConnections = {}
local ESPEnabled = false
local ChamsEnabled = false

local function getRoot(char)
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function createBillboardESP(plr)
    if BillboardESPs[plr] or plr == LocalPlayer then return end
    if not plr.Character or not plr.Character:FindFirstChild("Head") then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "Billboard_ESP"
    gui.Adornee = plr.Character.Head
    gui.Parent = plr.Character.Head
    gui.Size = UDim2.new(0, 100, 0, 40)
    gui.AlwaysOnTop = true
    gui.StudsOffset = Vector3.new(0, 2, 0)

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.TextScaled = true
    label.FontFace = customFont

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not plr.Character or not plr.Character:FindFirstChild("Humanoid") then
            gui:Destroy()
            if conn then conn:Disconnect() end
            BillboardESPs[plr] = nil
            ESPConnections[plr] = nil
            return
        end
        local hp = math.floor(plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * 100)
        label.Text = plr.Name .. " | " .. hp .. "%"
    end)

    BillboardESPs[plr] = gui
    ESPConnections[plr] = conn
end

local function createChamsESP(plr)
    if ChamsESPs[plr] or plr == LocalPlayer then return end
    if not plr.Character or not getRoot(plr.Character) then return end

    local folder = Instance.new("Folder")
    folder.Name = "Chams_ESP"
    folder.Parent = CoreGui
    ChamsESPs[plr] = folder

    for _, part in pairs(plr.Character:GetChildren()) do
        if part:IsA("BasePart") then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "Cham_" .. plr.Name
            box.Adornee = part
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = part.Size
            box.Transparency = espTransparency
            box.Color = BrickColor.new(
                teamCheck and (plr.TeamColor == LocalPlayer.TeamColor and "Bright green" or "Bright red") or tostring(plr.TeamColor)
            )
            box.Parent = folder
        end
    end
end

local function cleanupBillboardESP()
    for _, gui in pairs(BillboardESPs) do
        if gui then gui:Destroy() end
    end
    for _, conn in pairs(ESPConnections) do
        if conn then conn:Disconnect() end
    end
    BillboardESPs = {}
    ESPConnections = {}
end

local function cleanupChamsESP()
    for _, folder in pairs(ChamsESPs) do
        if folder then folder:Destroy() end
    end
    ChamsESPs = {}
end

local function handlePlayerESP(plr)
    if ESPEnabled then createBillboardESP(plr) end
    if ChamsEnabled then createChamsESP(plr) end
    plr.CharacterAdded:Connect(function()
        task.wait(1)
        if ESPEnabled then createBillboardESP(plr) end
        if ChamsEnabled then createChamsESP(plr) end
    end)
end

vis:CreateCheckbox("ESP", function(state)
    ESPEnabled = state
    if not state then
        cleanupBillboardESP()
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then createBillboardESP(plr) end
        end
    end
end)

vis:CreateCheckbox("Chams", function(state)
    ChamsEnabled = state
    if not state then
        cleanupChamsESP()
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then createChamsESP(plr) end
        end
    end
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then handlePlayerESP(plr) end
end
Players.PlayerAdded:Connect(function(plr) handlePlayerESP(plr) end)

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 1
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.ZIndex = 2
local FOVRadius = 100

RunService.RenderStepped:Connect(function()
    if FOVCircle.Visible then
        FOVCircle.Radius = FOVRadius
        FOVCircle.Position = UserInputService:GetMouseLocation()
    end
end)

vis:CreateCheckbox("FOV Circle", function(state)
    FOVCircle.Visible = state
end)

local killAuraToggle = false
local radius = 200

local toolsDamageIDs = {
    ["Old Axe"] = "1_8982038982",
    ["Good Axe"] = "112_8982038982",
    ["Strong Axe"] = "116_8982038982",
    ["Chainsaw"] = "647_8992824875",
    ["Spear"] = "196_8999010016"
}

local function getAnyToolWithDamageID()
    for toolName, damageID in pairs(toolsDamageIDs) do
        local tool = LocalPlayer.Inventory:FindFirstChild(toolName)
        if tool then return tool, damageID end
    end
    return nil, nil
end

local function equipTool(tool)
    if tool then remoteEvents.EquipItemHandle:FireServer("FireAllClients", tool) end
end

local function unequipTool(tool)
    if tool then remoteEvents.UnequipItemHandle:FireServer("FireAllClients", tool) end
end

local function killAuraLoop()
    while killAuraToggle do
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local tool, damageID = getAnyToolWithDamageID()
            if tool and damageID then
                equipTool(tool)
                for _, mob in ipairs(workspace.Characters:GetChildren()) do
                    if mob:IsA("Model") then
                        local part = mob:FindFirstChildWhichIsA("BasePart")
                        if part and (part.Position - hrp.Position).Magnitude <= radius then
                            pcall(function()
                                remoteEvents.ToolDamageObject:InvokeServer(mob, tool, damageID, CFrame.new(part.Position))
                            end)
                        end
                    end
                end
                task.wait(0.1)
            else
                task.wait(1)
            end
        else
            task.wait(0.5)
        end
    end
end

main:CreateCheckbox("Kill Aura", function(state)
    killAuraToggle = state
    if state then task.spawn(killAuraLoop) else unequipTool(getAnyToolWithDamageID()) end
end)

main:CreateSlider("Kill Aura Radius", 500, 20, function(value)
    radius = math.clamp(value, 20, 500)
end)

local itemsFolder = workspace:WaitForChild("Items")
local remoteConsume = remoteEvents:WaitForChild("RequestConsumeItem")

local campfireDropPos = Vector3.new(0, 19, 0)
local machineDropPos = Vector3.new(21, 16, -5)

local campfireFuelItems = {"Log", "Coal", "Fuel Canister", "Oil Barrel", "Biofuel"}
local autocookItems = {"Morsel", "Steak"}
local autoGrindItems = {"UFO Junk", "UFO Component", "Old Car Engine", "Broken Fan", "Old Microwave", "Bolt", "Log", "Cultist Gem", "Sheet Metal", "Old Radio","Tyre","Washing Machine", "Cultist Experiment", "Cultist Component", "Gem of the Forest Fragment", "Broken Microwave"}
local autoEatFoods = {"Cooked Steak", "Cooked Morsel", "Berry", "Carrot", "Apple"}
local biofuelItems = {"Carrot", "Cooked Morsel", "Morsel", "Steak", "Cooked Steak", "Log"}

local autoFuelEnabledItems = {}
local autoCookEnabledItems = {}
local autoGrindEnabledItems = {}
local autoEatEnabled = false
local autoEatHPEnabled = false
local autoBiofuelEnabledItems = {}
local alwaysFeedEnabledItems = {}

local function moveItemToPos(item, position)
    if not item or not item:IsDescendantOf(workspace) then return end
    local part = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart") or item:FindFirstChild("Handle")
    if not part then return end
    if not item.PrimaryPart then pcall(function() item.PrimaryPart = part end) end
    pcall(function()
        remoteEvents.RequestStartDraggingItem:FireServer(item)
        task.wait(0.05)
        item:SetPrimaryPartCFrame(CFrame.new(position))
        task.wait(0.05)
        remoteEvents.StopDraggingItem:FireServer(item)
    end)
end

local function createDropdownWithCheckboxes(title, itemList, enabledTable)
    local dropdown = autofarmss:CreateDropDown(title)
    for _, itemName in ipairs(itemList) do
        dropdown:AddCheckbox(itemName, function(checked) enabledTable[itemName] = checked end)
    end
    dropdown:AddCheckbox("Bulk (All)", function(checked)
        for _, itemName in ipairs(itemList) do enabledTable[itemName] = checked end
    end)
    return dropdown
end

createDropdownWithCheckboxes("Auto Feed Campfire (ignores HP)", campfireFuelItems, alwaysFeedEnabledItems)
createDropdownWithCheckboxes("Auto Feed Campfire (HP Based)", campfireFuelItems, autoFuelEnabledItems)
createDropdownWithCheckboxes("Auto Cook Food", autocookItems, autoCookEnabledItems)
createDropdownWithCheckboxes("Auto Machine Grind", autoGrindItems, autoGrindEnabledItems)
createDropdownWithCheckboxes("Auto Biofuel Processor", biofuelItems, autoBiofuelEnabledItems)

local eatDropdown = autofarmss:CreateDropDown("Auto Eat (3 sec interval)")
eatDropdown:AddCheckbox("Enable Auto Eat", function(checked) autoEatEnabled = checked end)

local eatHPDropdown = autofarmss:CreateDropDown("Auto Eat (HP Bar Based)")
eatHPDropdown:AddCheckbox("Enable Auto Eat (HP Bar Based)", function(checked) autoEatHPEnabled = checked end)

coroutine.wrap(function()
    while true do
        for itemName, enabled in pairs(alwaysFeedEnabledItems) do
            if enabled then
                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if item.Name == itemName then moveItemToPos(item, campfireDropPos) end
                end
            end
        end
        task.wait(2)
    end
end)()

coroutine.wrap(function()
    local campfire = workspace:WaitForChild("Map"):WaitForChild("Campground"):WaitForChild("MainFire")
    local fillFrame = campfire.Center.BillboardGui.Frame.Background.Fill
    while true do
        local healthPercent = fillFrame.Size.X.Scale
        if healthPercent < 0.7 then
            repeat
                for itemName, enabled in pairs(autoFuelEnabledItems) do
                    if enabled then
                        for _, item in ipairs(itemsFolder:GetChildren()) do
                            if item.Name == itemName then moveItemToPos(item, campfireDropPos) end
                        end
                    end
                end
                task.wait(0.5)
                healthPercent = fillFrame.Size.X.Scale
            until healthPercent >= 1
        end
        task.wait(2)
    end
end)()

coroutine.wrap(function()
    while true do
        for itemName, enabled in pairs(autoCookEnabledItems) do
            if enabled then
                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if item.Name == itemName then moveItemToPos(item, campfireDropPos) end
                end
            end
        end
        task.wait(2.5)
    end
end)()

coroutine.wrap(function()
    while true do
        for itemName, enabled in pairs(autoGrindEnabledItems) do
            if enabled then
                for _, item in ipairs(itemsFolder:GetChildren()) do
                    if item.Name == itemName then moveItemToPos(item, machineDropPos) end
                end
            end
        end
        task.wait(2.5)
    end
end)()

coroutine.wrap(function()
    while true do
        if autoEatEnabled then
            local available = {}
            for _, item in ipairs(itemsFolder:GetChildren()) do
                if table.find(autoEatFoods, item.Name) then table.insert(available, item) end
            end
            if #available > 0 then
                local food = available[math.random(1, #available)]
                pcall(function() remoteConsume:InvokeServer(food) end)
            end
        end
        task.wait(3)
    end
end)()

coroutine.wrap(function()
    local hungerBar = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Interface"):WaitForChild("StatBars"):WaitForChild("HungerBar"):WaitForChild("Bar")
    while true do
        if autoEatHPEnabled then
            if hungerBar.Size.X.Scale <= 0.5 then
                repeat
                    local available = {}
                    for _, item in ipairs(itemsFolder:GetChildren()) do
                        if item.Name and table.find(autoEatFoods, item.Name) then
                            table.insert(available, item)
                        end
                    end
                    if #available > 0 then
                        local food = available[math.random(1, #available)]
                        if food then pcall(function() remoteConsume:InvokeServer(food) end) end
                    end
                    task.wait(1)
                until hungerBar.Size.X.Scale >= 0.99 or not autoEatHPEnabled
            end
        end
        task.wait(3)
    end
end)()

coroutine.wrap(function()
    local biofuelProcessorPos
    while true do
        if not biofuelProcessorPos then
            local processor = workspace:FindFirstChild("Structures") and workspace.Structures:FindFirstChild("Biofuel Processor")
            local part = processor and processor:FindFirstChild("Part")
            if part then biofuelProcessorPos = part.Position + Vector3.new(0, 5, 0) end
        end
        if biofuelProcessorPos then
            for itemName, enabled in pairs(autoBiofuelEnabledItems) do
                if enabled then
                    for _, item in ipairs(itemsFolder:GetChildren()) do
                        if item.Name == itemName then moveItemToPos(item, biofuelProcessorPos) end
                    end
                end
            end
        end
        task.wait(2)
    end
end)()

local originalTreeCFrames = {}
local treesBrought = false

local function getAllSmallTrees()
    local trees = {}
    local function scan(folder)
        if not folder then return end
        for _, obj in ipairs(folder:GetChildren()) do
            if obj:IsA("Model") and obj.Name == "Small Tree" then table.insert(trees, obj) end
        end
    end
    local map = workspace:FindFirstChild("Map")
    if map then
        if map:FindFirstChild("Foliage") then scan(map.Foliage) end
        if map:FindFirstChild("Landmarks") then scan(map.Landmarks) end
    end
    return trees
end

local function findTrunk(tree)
    for _, part in ipairs(tree:GetDescendants()) do
        if part:IsA("BasePart") and part.Name == "Trunk" then return part end
    end
end

local function bringAllTrees()
    local target = CFrame.new(rootPart.Position + rootPart.CFrame.LookVector * 10)
    for _, tree in ipairs(getAllSmallTrees()) do
        local trunk = findTrunk(tree)
        if trunk then
            if not originalTreeCFrames[tree] then originalTreeCFrames[tree] = trunk.CFrame end
            tree.PrimaryPart = trunk
            trunk.Anchored = false
            trunk.CanCollide = false
            task.wait()
            tree:SetPrimaryPartCFrame(target + Vector3.new(math.random(-5,5), 0, math.random(-5,5)))
            trunk.Anchored = true
        end
    end
    treesBrought = true
end

local function restoreTrees()
    for tree, cframe in pairs(originalTreeCFrames) do
        local trunk = findTrunk(tree)
        if trunk then
            tree.PrimaryPart = trunk
            tree:SetPrimaryPartCFrame(cframe)
            trunk.Anchored = true
            trunk.CanCollide = true
        end
    end
    originalTreeCFrames = {}
    treesBrought = false
end

local miscdropdown = autofarmss:CreateDropDown("Auto Misc Features")
miscdropdown:AddCheckbox("Auto Bring All Small Trees", function(checked)
    if checked and not treesBrought then bringAllTrees()
    elseif not checked and treesBrought then restoreTrees()
    end
end)

local strongholdRunning = true

local function getStrongholdTimerLabel()
    return workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Landmarks")
        and workspace.Map.Landmarks:FindFirstChild("Stronghold")
        and workspace.Map.Landmarks.Stronghold:FindFirstChild("Functional")
        and workspace.Map.Landmarks.Stronghold.Functional:FindFirstChild("Sign")
        and workspace.Map.Landmarks.Stronghold.Functional.Sign:FindFirstChild("SurfaceGui")
        and workspace.Map.Landmarks.Stronghold.Functional.Sign.SurfaceGui:FindFirstChild("Frame")
        and workspace.Map.Landmarks.Stronghold.Functional.Sign.SurfaceGui.Frame:FindFirstChild("Body")
end

local initialLabel = getStrongholdTimerLabel()
local initialText = "Stronghold Timer: " .. tostring(initialLabel and initialLabel.ContentText or "N/A")
local strongholdDropdown = main:CreateDropDown("Stronghold Clients")
local strongholdTimeChecker = main:CreateComment(initialText)

coroutine.wrap(function()
    local lastTimerText = nil
    while strongholdRunning do
        local label = getStrongholdTimerLabel()
        local timerText = "Stronghold Timer: " .. tostring(label and label.ContentText or "N/A")
        if timerText ~= lastTimerText then
            if strongholdTimeChecker.SetText then
                strongholdTimeChecker:SetText(timerText)
            else
                local commentContent = strongholdTimeChecker:FindFirstChild("commentcontent")
                if commentContent then commentContent.Text = timerText end
            end
            lastTimerText = timerText
        end
        task.wait(0.5)
    end
end)()

strongholdDropdown:AddButton("Teleport to Stronghold", function()
    local targetPart = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Landmarks")
        and workspace.Map.Landmarks:FindFirstChild("Stronghold")
        and workspace.Map.Landmarks.Stronghold:FindFirstChild("Functional")
        and workspace.Map.Landmarks.Stronghold.Functional:FindFirstChild("EntryDoors")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors:FindFirstChild("DoorRight")
        and workspace.Map.Landmarks.Stronghold.Functional.EntryDoors.DoorRight:FindFirstChild("Model")
    if targetPart then
        local children = targetPart:GetChildren()
        local destination = children[5]
        if destination and destination:IsA("BasePart") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = destination.CFrame + Vector3.new(0, 5, 0)
                print("Teleported to Stronghold")
            end
        end
    end
end)

strongholdDropdown:AddButton("Teleport to Diamond Chest", function()
    local items = workspace:FindFirstChild("Items")
    if not items then warn("Items folder not found!") return end
    local chest = items:FindFirstChild("Stronghold Diamond Chest")
    if not chest then warn("Stronghold Diamond Chest not found!") return end
    local chestLid = chest:FindFirstChild("ChestLid")
    if not chestLid then warn("ChestLid not found!") return end
    local diamondchest = chestLid:FindFirstChild("Meshes/diamondchest_Cube.002")
    if not diamondchest then warn("Diamond chest mesh not found!") return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = diamondchest.CFrame + Vector3.new(0, 5, 0) end
end)

print("✅ 99 Nights script loaded successfully!")