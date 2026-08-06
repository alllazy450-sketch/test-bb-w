local success, lib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/iiivyne/robloxlua/main/lib.lua"))()
end)

if not success or not lib then
    success, lib = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/alllazy450-sketch/test-bb-w/main/lib.lua"))()
    end)
end

if not success or not lib then warn("Gagal memuat library UI!") return end

local int = lib:CreateInterface("99 Nights in the Forest","script by lohjc","https://discord.gg/ZNTHTWx7KE","bottom left","royal")

local main = int:CreateTab("Main","main functions/script utilities","default",true)
local autofarmss = int:CreateTab("Auto","auto farm utilities (OP)","op")
local itemtp = int:CreateTab("Item TP/ESP","bring items to you","item")
local gametp = int:CreateTab("Game TP","goto in-game locations","info")
local charactertp = int:CreateTab("Mob TP","bring mobs to you","npc")
local plr = int:CreateTab("Player","modify your localplayer","player")
local vis = int:CreateTab("Visuals","modify autoyour visuals","visuals")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local function getCharacterInfo()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    return char, hrp
end

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
    local char, hrp = getCharacterInfo()
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
        local part = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
        if not part or model:FindFirstChild("ESP") then return end

        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESP"
        billboard.Size = UDim2.new(0, 100, 0, 30)
        billboard.Adornee = part
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)

        local customFont = Font.new("rbxassetid://16658246179", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextSize = 17
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0.5
        label.FontFace = customFont
        label.Text = model.Name
        label.Parent = billboard
        billboard.Parent = model
    end

    local function removeAllESP()
        for _, model in ipairs(itemFolder:GetChildren()) do
            local esp = model:FindFirstChild("ESP")
            if esp then esp:Destroy() end
        end
    end

    if state then
        for _, model in ipairs(itemFolder:GetChildren()) do createESP(model) end
        local connection = itemFolder.ChildAdded:Connect(function(model)
            if model:IsA("Model") and itemNames[model.Name] then
                task.wait(0.2)
                createESP(model)
            end
        end)
        table.insert(connections, connection)
    else
        removeAllESP()
        for _, conn in ipairs(connections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        table.clear(connections)
    end
end)

local itemFolder = workspace:WaitForChild("Items")
local itemNamesList = {
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
for _, itemName in ipairs(itemNamesList) do
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
        local _, hrp = getCharacterInfo()
        if hrp then hrp.CFrame = targetPart.CFrame + Vector3.new(0, 5, 0) end
    end)
end

local remoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
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
local tempStorage = ReplicatedStorage:FindFirstChild("TempStorage")
local sources = { itemFolder }
if tempStorage then table.insert(sources, tempStorage) end

local function teleportItem(itemName)
    local _, hrp = getCharacterInfo()
    if not hrp then return end
    
    local stackOffsetY = 2
    local count = 0
    for _, source in ipairs(sources) do
        for _, item in ipairs(source:GetChildren()) do
            if item.Name == itemName then
                local targetPart = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
                if targetPart then
                    pcall(function()
                        remoteEvents.RequestStartDraggingItem:FireServer(item)
                        local offset = Vector3.new(0, count * stackOffsetY, 0)
                        targetPart.CFrame = hrp.CFrame + offset
                        remoteEvents.StopDraggingItem:FireServer(item)
                    end)
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
    local _, hrp = getCharacterInfo()
    if not hrp then return end

    local stackOffsetY = 3
    local count = 0
    for _, model in ipairs(characterFolder:GetChildren()) do
        if model.Name == characterName then
            local mainPart = getMainPart(model)
            if mainPart then
                local targetCFrame = hrp.CFrame + Vector3.new(0, count * stackOffsetY, 0)
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
        end
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        applyWalkSpeed(LocalPlayer.Character.Humanoid)
    end
end)

local espTransparency = 0.4
local teamCheck = true
local customFont = Font.new("rbxassetid://16658246179", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local BillboardESPs = {}
local ChamsESPs = {}
local ESPConnections = {}
local ESPEnabled = false
local ChamsEnabled = false

local function createBillboardESP(plrObj)
    if BillboardESPs[plrObj] or plrObj == LocalPlayer then return end
    if not plrObj.Character or not plrObj.Character:FindFirstChild("Head") then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "Billboard_ESP"
    gui.Adornee = plrObj.Character.Head
    gui.Parent = plrObj.Character.Head
    gui.Size = UDim2.new(0, 100, 0, 40)
    gui.AlwaysOnTop = true
    gui.StudsOffset = Vector3.new(0, 2, 0)

    local label = Instance.new("TextLabel", gui)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.FontFace = customFont

    local conn = RunService.RenderStepped:Connect(function()
        if not plrObj.Character or not plrObj.Character:FindFirstChild("Humanoid") then
            gui:Destroy()
            if ESPConnections[plrObj] then ESPConnections[plrObj]:Disconnect() end
            BillboardESPs[plrObj] = nil
            return
        end
        local hp = math.floor(plrObj.Character.Humanoid.Health / plrObj.Character.Humanoid.MaxHealth * 100)
        label.Text = plrObj.Name .. " | " .. hp .. "%"
    end)

    BillboardESPs[plrObj] = gui
    ESPConnections[plrObj] = conn
end

vis:CreateCheckbox("ESP", function(state)
    ESPEnabled = state
    if not state then
        for _, gui in pairs(BillboardESPs) do if gui then gui:Destroy() end end
        for _, conn in pairs(ESPConnections) do if conn then conn:Disconnect() end end
        BillboardESPs, ESPConnections = {}, {}
    else
        for _, plrObj in pairs(Players:GetPlayers()) do
            if plrObj ~= LocalPlayer then createBillboardESP(plrObj) end
        end
    end
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
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    if not inventory then return nil, nil end
    for toolName, damageID in pairs(toolsDamageIDs) do
        local tool = inventory:FindFirstChild(toolName)
        if tool then return tool, damageID end
    end
    return nil, nil
end

local function killAuraLoop()
    while killAuraToggle do
        local _, hrp = getCharacterInfo()
        if hrp then
            local tool, damageID = getAnyToolWithDamageID()
            if tool and damageID then
                pcall(function() remoteEvents.EquipItemHandle:FireServer("FireAllClients", tool) end)
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
            end
        end
        task.wait(0.1)
    end
end

main:CreateCheckbox("Kill Aura", function(state)
    killAuraToggle = state
    if state then task.spawn(killAuraLoop) end
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
    pcall(function()
        remoteEvents.RequestStartDraggingItem:FireServer(item)
        task.wait(0.05)
        part.CFrame = CFrame.new(position)
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

task.spawn(function()
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
end)

task.spawn(function()
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
end)
