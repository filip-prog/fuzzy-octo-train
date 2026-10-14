--[[
    MoneyHUB :: Pet Spawner (Steal An Egg)
    Original: VALT Pet Spawner
    Modified: MoneyHUB branding, black/white theme
]]

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Workspace         = game:GetService("Workspace")
local Debris            = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer
local Camera      = Workspace.CurrentCamera

if getgenv().__MONEYHUB_SPAWNER then
    pcall(getgenv().__MONEYHUB_SPAWNER.unload)
end

local CONFIG = {
    MAX_SPAWNS     = 40,
    SPAWN_DISTANCE = 12,
    SCALE_MULT     = 1,
    SPIN           = true,
    FLOAT          = false,
    OWN_PLOT_ONLY  = true,
    GROUND         = true,
    ANIMATE        = true,
    NAMETAG        = true,
    ANCHORED       = true,
    GRID_COLUMNS   = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) and 2 or 3,
    GIVE_TOOL      = true,
    HAND_MAX_STUDS = 4,
    MONEY_POPUP    = true,
    PAY_INTERVAL   = 1,
    CASH_VISUAL    = true,
}

local running      = true
local connections  = {}
local activeSpawns = {}
local activeTools  = {}
local pets         = {}
local rarityList   = { "All" }
local rarityRank   = {}
local selectedPet  = nil
local filter       = { text = "", rarity = "All" }

local UI = {
    window      = nil,
    gridTab     = nil,
    rows        = {},
    viewport    = nil,
    counter     = nil,
    previewInfo = nil,
}

local function track(conn)
    connections[#connections + 1] = conn
    return conn
end

local function abbreviateNumber(n)
    n = tonumber(n) or 0
    local units = { { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }
    for _, unit in ipairs(units) do
        if n >= unit[1] then
            return string.format("%.2f", n / unit[1]):gsub("%.?0+$", "") .. unit[2]
        end
    end
    return tostring(math.floor(n))
end

local function getCharacterRoot()
    local char = LocalPlayer.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
end

local Directory = require(ReplicatedStorage.Data.Assets).Directory

for key, entry in pairs(Directory) do
    local rarityInfo  = entry.Rarity or {}
    local rarityName  = tostring(rarityInfo._id or rarityInfo.DisplayName or "Unknown")
    local pet = {
        id = key,
        name = tostring(entry.DisplayName or key),
        icon = tostring(entry.Icon or ""),
        eggIcon = entry.Egg and tostring(entry.Egg.Icon or "") or "",
        rarity = rarityName,
        rank = tonumber(rarityInfo.RarityNumber) or 0,
        color = typeof(rarityInfo.Color) == "Color3" and rarityInfo.Color or Color3.fromRGB(200, 200, 200),
        rate = tonumber(entry.EarningRate) or 0,
        scale = tonumber(entry.BaseModelScale) or 1,
        idle = entry.Animations and entry.Animations.Idle or nil,
    }
    pets[#pets + 1] = pet
    if rarityRank[rarityName] == nil then
        rarityRank[rarityName] = pet.rank
        rarityList[#rarityList + 1] = rarityName
    end
end

table.sort(pets, function(a, b)
    if a.rank ~= b.rank then return a.rank > b.rank end
    return a.name < b.name
end)

table.sort(rarityList, function(a, b)
    if a == "All" then return true end
    if b == "All" then return false end
    return (rarityRank[a] or 0) > (rarityRank[b] or 0)
end)

local function getSpawnFolder()
    local folder = Workspace:FindFirstChild("__MoneyHUB_Spawns")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "__MoneyHUB_Spawns"
        folder.Parent = Workspace
    end
    return folder
end

local function getOwnPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local myName = LocalPlayer.Name
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            for _, d in ipairs(sign:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text == myName then
                    return plot
                end
            end
        end
    end
    return nil
end

local function getPlotSpawnPosition(index)
    local plot = getOwnPlot()
    if not plot then return nil end
    local center = plot:FindFirstChild("CenterPoint") or plot:FindFirstChild("SpawnPoint")
    if not center then return nil end
    local i = index or 0
    local angle = (i % 10) * (math.pi * 0.2)
    local radius = math.floor(i / 10) * 3.5 + 5
    return center.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
end

local function resolveGroundPosition(pos, model)
    if not CONFIG.GROUND then
        return pos + Vector3.new(0, model:GetExtentsSize().Y * 0.5, 0)
    end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = { model, LocalPlayer.Character, getSpawnFolder() }
    params.IgnoreWater = true
    local result = Workspace:Raycast(pos + Vector3.new(0, 40, 0), Vector3.new(0, -300, 0), params)
    local y = result and result.Position.Y or pos.Y
    return Vector3.new(pos.X, y + model:GetExtentsSize().Y * 0.5, pos.Z)
end

local function attachNametag(model, pet)
    local primary = model.PrimaryPart
    if not primary then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MoneyTag"
    billboard.Size = UDim2.fromOffset(220, 72)
    billboard.StudsOffsetWorldSpace = Vector3.new(0, model:GetExtentsSize().Y * 0.65 + 2, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 400
    billboard.Parent = primary
    if pet.icon ~= "" then
        local img = Instance.new("ImageLabel")
        img.BackgroundTransparency = 1
        img.AnchorPoint = Vector2.new(0.5, 0)
        img.Position = UDim2.new(0.5, 0, 0, 0)
        img.Size = UDim2.fromOffset(34, 34)
        img.Image = pet.icon
        img.ScaleType = Enum.ScaleType.Fit
        img.Parent = billboard
    end
    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0, 0, 0, 34)
    title.Size = UDim2.new(1, 0, 0, 22)
    title.Font = Enum.Font.GothamBold
    title.TextScaled = true
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextStrokeTransparency = 0.4
    title.Text = pet.name
    title.Parent = billboard
    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Position = UDim2.new(0, 0, 0, 56)
    sub.Size = UDim2.new(1, 0, 0, 16)
    sub.Font = Enum.Font.GothamMedium
    sub.TextScaled = true
    sub.TextColor3 = pet.color
    sub.TextStrokeTransparency = 0.5
    sub.Text = string.format("%s | $%s/s", pet.rarity, abbreviateNumber(pet.rate))
    sub.Parent = billboard
end

local function setupModel(model, pet)
    local scale = CONFIG.SCALE_MULT * (pet.scale or 1)
    if math.abs(scale - 1) > 0.001 then
        pcall(function() model:ScaleTo(scale) end)
    end
    local hasJoints = false
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("Motor6D") or d:IsA("Weld") or d:IsA("WeldConstraint") then
            hasJoints = true
            break
        end
    end
    local primary = model.PrimaryPart
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.Massless = true
            local anchored = CONFIG.ANCHORED
            if anchored then anchored = (not hasJoints) or part == primary end
            part.Anchored = anchored
        end
    end
    if primary then primary.Anchored = CONFIG.ANCHORED end
    return hasJoints
end

local function playIdle(model, pet)
    if not (CONFIG.ANIMATE and pet.idle) then return end
    local ok, err = pcall(function()
        local host = model:FindFirstChildOfClass("Model") or model
        local controller = host:FindFirstChildOfClass("AnimationController")
            or host:FindFirstChildOfClass("Humanoid")
        if not controller then
            controller = Instance.new("AnimationController")
            controller.Parent = host
        end
        local animator = controller:FindFirstChildOfClass("Animator")
        if not animator then
            animator = Instance.new("Animator")
            animator.Parent = controller
        end
        local anim
        if typeof(pet.idle) == "Instance" and pet.idle:IsA("Animation") then
            anim = pet.idle:Clone()
        else
            anim = Instance.new("Animation")
            anim.AnimationId = tostring(pet.idle)
        end
        local trackAnim = animator:LoadAnimation(anim)
        trackAnim.Looped = true
        trackAnim:Play()
    end)
    if not ok then
        warn("[MoneyHUB] idle animation failed for " .. pet.name .. ": " .. tostring(err))
    end
end

local function enforceSpawnLimit()
    while #activeSpawns > CONFIG.MAX_SPAWNS do
        local record = table.remove(activeSpawns, 1)
        if record and record.model then
            pcall(function() record.model:Destroy() end)
        end
    end
end

local lastTouchPos = nil
track(UserInputService.TouchTap:Connect(function(pos)
    if pos and pos[1] then lastTouchPos = pos[1] end
end))
track(UserInputService.TouchEnded:Connect(function(part)
    lastTouchPos = part.Position
end))

local function getSpawnPosition()
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    if isMobile and lastTouchPos and Camera then
        local ray = Camera:ViewportPointToRay(lastTouchPos.X, lastTouchPos.Y)
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { LocalPlayer.Character, Workspace:FindFirstChild("__MoneyHUB_Spawns") }
        local result = Workspace:Raycast(ray.Origin, ray.Direction * 600, params)
        if result then return result.Position end
    end
    local ok, mouse = pcall(function() return LocalPlayer:GetMouse() end)
    if ok and mouse and mouse.Hit and mouse.Target then return mouse.Hit.Position end
    local root = getCharacterRoot()
    if root then return root.Position + root.CFrame.LookVector * CONFIG.SPAWN_DISTANCE end
    return nil
end

local function spawnPet(pet, positionOverride)
    if not running then return false, "unloaded" end
    local modelsFolder = ReplicatedStorage:FindFirstChild("AssetModels")
    if modelsFolder then modelsFolder = modelsFolder:FindFirstChild(pet.id) end
    if not modelsFolder then return false, "no model for " .. pet.id end
    local root = getCharacterRoot()
    if not root then return false, "character not loaded" end
    local clone = modelsFolder:Clone()
    clone.Name = "MoneyHUB_" .. pet.id
    local jointed = setupModel(clone, pet)
    clone.Parent = getSpawnFolder()
    local targetPos
    if CONFIG.OWN_PLOT_ONLY then targetPos = getPlotSpawnPosition(#activeSpawns) end
    if not targetPos then
        if typeof(positionOverride) == "Vector3" then targetPos = positionOverride
        else
            local index = #activeSpawns
            local angle = (index % 12) * (math.pi / 6)
            local dist = CONFIG.SPAWN_DISTANCE + math.floor(index / 12) * 6
            targetPos = root.Position + Vector3.new(math.cos(angle) * dist, 0, math.sin(angle) * dist)
        end
    end
    local finalPos = resolveGroundPosition(targetPos, clone)
    local look = root.Position
    pcall(function() clone:PivotTo(CFrame.new(finalPos, Vector3.new(look.X, finalPos.Y, look.Z))) end)
    if CONFIG.NAMETAG then pcall(attachNametag, clone, pet) end
    playIdle(clone, pet)
    local now = os.clock()
    activeSpawns[#activeSpawns + 1] = {
        model = clone, root = clone.PrimaryPart, basePos = finalPos,
        t0 = now, lastPay = now, name = pet.name, rate = pet.rate,
        tagHeight = clone:GetExtentsSize().Y * 0.65 + 4, jointed = jointed,
    }
    enforceSpawnLimit()
    return true
end

local function clearSpawns()
    for _, record in ipairs(activeSpawns) do
        if record.model then pcall(function() record.model:Destroy() end) end
    end
    table.clear(activeSpawns)
    local folder = Workspace:FindFirstChild("__MoneyHUB_Spawns")
    if folder then pcall(function() folder:Destroy() end) end
end

local function moneyPopup(record)
    if not record.root or not record.root.Parent then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MoneyCash"
    billboard.Size = UDim2.fromOffset(150, 40)
    billboard.StudsOffsetWorldSpace = Vector3.new(0, record.tagHeight, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 300
    billboard.Adornee = record.root
    billboard.Parent = record.root
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.LuckiestGuy
    label.TextScaled = true
    label.TextColor3 = Color3.fromRGB(80, 235, 105)
    label.TextStrokeColor3 = Color3.fromRGB(10, 45, 15)
    label.TextStrokeTransparency = 0.15
    label.Text = "+$" .. abbreviateNumber(record.rate)
    label.Parent = billboard
    TweenService:Create(billboard, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { StudsOffsetWorldSpace = Vector3.new(0, record.tagHeight + 4.5, 0) }):Play()
    TweenService:Create(label, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { TextTransparency = 1, TextStrokeTransparency = 1 }):Play()
    Debris:AddItem(billboard, 1.3)
end

local function giveTool(pet)
    if not running then return false, "unloaded" end
    local modelsFolder = ReplicatedStorage:FindFirstChild("AssetModels")
    if modelsFolder then modelsFolder = modelsFolder:FindFirstChild(pet.id) end
    if not modelsFolder then return false, "no model for " .. pet.id end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not backpack then return false, "no backpack" end
    local tool = Instance.new("Tool")
    tool.Name = pet.name
    tool.ToolTip = string.format("%s | $%s/s - click to place (one use)", pet.rarity, abbreviateNumber(pet.rate))
    tool.CanBeDropped = false
    tool.RequiresHandle = true
    tool.TextureId = pet.icon
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Transparency = 1
    handle.CanCollide = false
    handle.CanQuery = false
    handle.CanTouch = false
    handle.Massless = true
    handle.Parent = tool
    local clone = modelsFolder:Clone()
    clone.Name = "Pet"
    local size = clone:GetExtentsSize()
    local maxDim = math.max(size.X, size.Y, size.Z)
    if maxDim > CONFIG.HAND_MAX_STUDS then
        local factor = CONFIG.HAND_MAX_STUDS / maxDim
        pcall(function() clone:ScaleTo(factor ^ 0.5) end)
    end
    local primary = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart", true)
    local hasMotor = false
    for _, d in ipairs(clone:GetDescendants()) do
        if d:IsA("Motor6D") then hasMotor = true break end
    end
    for _, part in ipairs(clone:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Anchored = false
            part.CanCollide = false
            part.CanQuery = false
            part.CanTouch = false
            part.Massless = true
        end
    end
    clone.Parent = tool
    if primary then
        local weld = Instance.new("Weld")
        weld.Part0 = handle
        weld.Part1 = primary
        weld.C0 = CFrame.new(0, clone:GetExtentsSize().Y * 0.4, 0)
        weld.Parent = handle
    end
    if not hasMotor then
        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("BasePart") and d ~= primary then
                local wc = Instance.new("WeldConstraint")
                wc.Part0 = primary
                wc.Part1 = d
                wc.Parent = primary
            end
        end
    else
        playIdle(clone, pet)
    end
    tool.Parent = backpack
    activeTools[#activeTools + 1] = tool
    track(tool.Activated:Connect(function()
        local pos = getSpawnPosition()
        local ok, err = spawnPet(pet, pos)
        if not ok then
            warn("[MoneyHUB] place failed: " .. tostring(err))
            return
        end
        for i = #activeTools, 1, -1 do
            if activeTools[i] == tool then table.remove(activeTools, i) end
        end
        pcall(function() tool:Destroy() end)
    end))
    return true
end

local function clearTools()
    for _, tool in ipairs(activeTools) do
        pcall(function() tool:Destroy() end)
    end
    table.clear(activeTools)
end

local cashVisual = { label = nil, base = 0, bonus = 0, shown = 0, ours = nil, conn = nil }
local MULTIPLIERS = { K = 1e3, M = 1e6, B = 1e9, T = 1e12 }

local function parseMoney(text)
    local numStr, suffix = tostring(text):gsub("[%$,%s]", ""):match("^([%d%.]+)(%a*)$")
    if not numStr then return nil end
    local mult = suffix ~= "" and MULTIPLIERS[suffix:upper()] or 1
    if not mult then return nil end
    return (tonumber(numStr) or 0) * mult
end

local function formatMoney(n)
    local units = { { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }
    for _, u in ipairs(units) do
        if n >= u[1] then
            local val = n / u[1]
            local fmt = val >= 100 and "%.0f" or "%.1f"
            return "$" .. string.format(fmt, val):gsub("%.0$", "") .. u[2]
        end
    end
    return "$" .. string.format("%.0f", n)
end

local function findMoneyLabel()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return nil end
    local hud = playerGui:FindFirstChild("HUD")
    for _, name in ipairs({ "GameHUD", "BottomLeft", "Money", "Value" }) do
        hud = hud and hud:FindFirstChild(name)
    end
    if hud and hud:IsA("TextLabel") then return hud end
    for _, obj in ipairs(playerGui:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Text:match("^%$%d") and obj.AbsoluteSize.X > 40 then
            local parent = obj
            while parent do
                if parent:IsA("ScreenGui") then
                    if parent.Enabled then return obj end
                    break
                end
                parent = parent.Parent
            end
        end
    end
    return nil
end

local function hookCashLabel()
    local label = findMoneyLabel()
    if not label then return false end
    if label == cashVisual.label then return true end
    if cashVisual.conn then pcall(function() cashVisual.conn:Disconnect() end) end
    cashVisual.label = label
    cashVisual.base = parseMoney(label.Text) or 0
    cashVisual.shown = cashVisual.base + cashVisual.bonus
    cashVisual.conn = track(label:GetPropertyChangedSignal("Text"):Connect(function()
        if label.Text ~= cashVisual.ours then
            cashVisual.base = parseMoney(label.Text) or cashVisual.base
        end
    end))
    return true
end

local function releaseCashLabel()
    if cashVisual.conn then pcall(function() cashVisual.conn:Disconnect() end) end
    if cashVisual.label and cashVisual.label.Parent then
        pcall(function() cashVisual.label.Text = formatMoney(cashVisual.base) end)
    end
    cashVisual.label = nil
    cashVisual.conn = nil
    cashVisual.bonus = 0
    cashVisual.ours = nil
end

track(RunService.Heartbeat:Connect(function(dt)
    if not running then return end
    local now = os.clock()
    if CONFIG.CASH_VISUAL then
        if not (cashVisual.label and cashVisual.label.Parent) then hookCashLabel() end
        if cashVisual.label and cashVisual.bonus > 0 then
            local target = cashVisual.base + cashVisual.bonus
            cashVisual.shown = cashVisual.shown + (target - cashVisual.shown) * math.min(1, (dt or 0.016) * 6)
            if math.abs(target - cashVisual.shown) < 1 then cashVisual.shown = target end
            cashVisual.ours = formatMoney(cashVisual.shown)
            cashVisual.label.Text = cashVisual.ours
        end
    end
    for i = #activeSpawns, 1, -1 do
        local record = activeSpawns[i]
        if not record.model or not record.model.Parent then
            table.remove(activeSpawns, i)
        else
            local shouldRotate = CONFIG.SPIN or CONFIG.FLOAT
            if shouldRotate and record.root and record.root.Anchored then
                local t = now - record.t0
                local yOff = CONFIG.FLOAT and math.sin(t * 1.6) * 0.6 or 0
                local yaw = CONFIG.SPIN and t * 1.1 or 0
                record.root.CFrame = CFrame.new(record.basePos + Vector3.new(0, yOff, 0)) * CFrame.Angles(0, yaw, 0)
            end
            if now - record.lastPay >= CONFIG.PAY_INTERVAL then
                record.lastPay = now
                if CONFIG.MONEY_POPUP then moneyPopup(record) end
                if CONFIG.CASH_VISUAL then cashVisual.bonus = cashVisual.bonus + record.rate * CONFIG.PAY_INTERVAL end
            end
        end
    end
end))

local function unload()
    running = false
    for _, conn in ipairs(connections) do pcall(function() conn:Disconnect() end) end
    table.clear(connections)
    clearSpawns()
    clearTools()
    releaseCashLabel()
    if UI.window then pcall(function() UI.window:Destroy() end) end
    getgenv().__MONEYHUB_SPAWNER = nil
    warn("[MoneyHUB] unloaded")
end

local function buildUI()
    local ok, WindUI = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
    if not ok or not WindUI then
        warn("[MoneyHUB] WindUI failed: " .. tostring(WindUI))
        return
    end
    local vp = Camera and Camera.ViewportSize or Vector2.new(1280, 720)
    local size
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        size = UDim2.fromOffset(math.clamp(math.floor(vp.X * 0.92), 300, 560), math.clamp(math.floor(vp.Y * 0.82), 260, 420))
    else
        size = UDim2.fromOffset(620, 480)
    end
    local window = WindUI:CreateWindow({
        Title         = "MoneyHUB",
        Icon          = "egg",
        Author        = "Steal An Egg | By @avongg6 @og.gg.66 | discord.gg/FRymbb9g",
        Folder        = "MoneyHUB",
        Size          = size,
        Transparent   = true,
        Theme         = "Dark",
        SideBarWidth  = 165,
        HideSearchBar = false,
        OpenButton    = { Enabled = false },
    })
    UI.window = window
    if getgenv().__MONEYHUB_SPAWNER then getgenv().__MONEYHUB_SPAWNER.window = window end

    local petsTab    = window:Tab({ Title = "Pets",    Icon = "paw-print" })
    local previewTab = window:Tab({ Title = "Preview", Icon = "eye" })
    local optionsTab = window:Tab({ Title = "Options", Icon = "settings" })
    local infoTab    = window:Tab({ Title = "Info",    Icon = "info" })
    UI.gridTab = petsTab

    infoTab:Section({ Title = "MoneyHUB" })
    infoTab:Paragraph({
        Title = "By | @avongg6 @og.gg.66",
        Desc  = "Discord: discord.gg/FRymbb9g",
    })
    infoTab:Button({
        Title = "Copy Discord Link",
        Callback = function()
            pcall(function()
                setclipboard("discord.gg/FRymbb9g")
                WindUI:Notify({ Title = "Copied!", Content = "discord.gg/FRymbb9g", Duration = 3, Icon = "copy" })
            end)
        end,
    })

    petsTab:Input({
        Title = "Search",
        Placeholder = "pet name...",
        Callback = function(text)
            filter.text = string.lower(tostring(text or ""))
            UI.rebuild()
        end,
    })

    petsTab:Dropdown({
        Title = "Rarity",
        Values = rarityList,
        Value = "All",
        Callback = function(value)
            filter.rarity = tostring(value)
            UI.rebuild()
        end,
    })

    UI.counter = petsTab:Paragraph({
        Title = "Loaded",
        Desc = #pets .. " assets ready - click a card to spawn",
    })

    petsTab:Divider()

    local function clearRows()
        for _, row in ipairs(UI.rows) do
            local frame = row.ElementFrame
            if typeof(frame) == "Instance" then pcall(function() frame:Destroy() end) end
        end
        table.clear(UI.rows)
    end

    local rebuildId = 0

    function UI.rebuild()
        rebuildId += 1
        local thisId = rebuildId
        clearRows()
        local filtered = {}
        for _, pet in ipairs(pets) do
            local nameMatch = filter.text == "" or string.find(string.lower(pet.name), filter.text, 1, true) ~= nil
            local rarityMatch = filter.rarity == "All" or pet.rarity == filter.rarity
            if nameMatch and rarityMatch then filtered[#filtered + 1] = pet end
        end
        if UI.counter then
            pcall(function()
                UI.counter:SetDesc(#filtered .. " of " .. #pets .. " assets shown - click a card to spawn")
            end)
        end
        task.spawn(function()
            local row
            local col = 0
            for i, pet in ipairs(filtered) do
                if thisId ~= rebuildId or not running then return end
                if col == 0 then
                    row = petsTab:HStack({})
                    UI.rows[#UI.rows + 1] = row
                end
                local btn = row:Button({
                    Title = pet.name,
                    Desc = string.format("%s | $%s/s", pet.rarity, abbreviateNumber(pet.rate)),
                    Callback = function()
                        selectedPet = pet
                        if CONFIG.GIVE_TOOL then
                            local success, err = giveTool(pet)
                            WindUI:Notify({
                                Title = success and (pet.name .. " -> backpack") or "tool failed",
                                Content = success and "equip it, then click to place the pet" or tostring(err),
                                Duration = success and 2 or 4,
                                Icon = success and "backpack" or "circle-alert",
                            })
                            return
                        end
                        local success, err = spawnPet(pet)
                        WindUI:Notify({
                            Title = success and (pet.name .. " spawned") or "spawn failed",
                            Content = success and (pet.rarity .. " | " .. #activeSpawns .. "/" .. CONFIG.MAX_SPAWNS .. " active") or tostring(err),
                            Duration = success and 2 or 4,
                            Icon = success and "sparkles" or "circle-alert",
                        })
                    end,
                })
                if pet.icon ~= "" then pcall(function() btn:SetThumbnail(pet.icon) end) end
                col += 1
                if col >= CONFIG.GRID_COLUMNS then
                    col = 0
                    if i % (CONFIG.GRID_COLUMNS * 4) == 0 then task.wait() end
                end
            end
        end)
    end

    previewTab:Section({ Title = "Model viewer" })
    local petNames = {}
    for _, pet in ipairs(pets) do petNames[#petNames + 1] = pet.name end

    local function previewPet(name)
        local pet
        for _, p in ipairs(pets) do if p.name == name then pet = p break end end
        if not pet then return end
        selectedPet = pet
        local modelsFolder = ReplicatedStorage:FindFirstChild("AssetModels")
        if modelsFolder then modelsFolder = modelsFolder:FindFirstChild(pet.id) end
        if not modelsFolder then
            WindUI:Notify({ Title = "no model", Content = pet.id, Duration = 3, Icon = "circle-alert" })
            return
        end
        if UI.viewport then pcall(function() UI.viewport:SetObject({ modelsFolder:Clone() }) end) end
        if UI.previewInfo then
            pcall(function()
                UI.previewInfo:SetTitle(pet.name)
                UI.previewInfo:SetDesc(string.format("Rarity: %s | Earns: $%s/s | Base scale: %.2f", pet.rarity, abbreviateNumber(pet.rate), pet.scale))
                if pet.icon ~= "" then UI.previewInfo:SetImage(pet.icon) end
            end)
        end
    end

    previewTab:Dropdown({ Title = "Pet", Values = petNames, Value = petNames[1], Callback = previewPet })
    UI.previewInfo = previewTab:Paragraph({ Title = "-", Desc = "pick a pet", Image = "", ImageSize = 48 })
    local previewSource = ReplicatedStorage:FindFirstChild("AssetModels")
    if previewSource and pets[1] then previewSource = previewSource:FindFirstChild(pets[1].id) else previewSource = nil end
    UI.viewport = previewTab:Viewport({ Title = "Model", Object = previewSource and previewSource:Clone() or Instance.new("Model"), Height = 220, Interactive = true })

    previewTab:Button({
        Title = "Take into backpack",
        Desc = "hands you the previewed pet as a tool",
        Callback = function()
            if not selectedPet then return end
            local success, err = giveTool(selectedPet)
            WindUI:Notify({
                Title = success and (selectedPet.name .. " -> backpack") or "tool failed",
                Content = success and "equip it, then click to place the pet" or tostring(err),
                Duration = 3, Icon = success and "backpack" or "circle-alert",
            })
        end,
    })

    previewTab:Button({
        Title = "Spawn this one",
        Desc = "drops the previewed pet in front of you",
        Callback = function()
            if not selectedPet then return end
            local success, err = spawnPet(selectedPet)
            WindUI:Notify({
                Title = success and (selectedPet.name .. " spawned") or "spawn failed",
                Content = success and (#activeSpawns .. "/" .. CONFIG.MAX_SPAWNS .. " active") or tostring(err),
                Duration = 3, Icon = success and "sparkles" or "circle-alert",
            })
        end,
    })

    optionsTab:Section({ Title = "Spawn behaviour" })
    optionsTab:Toggle({ Title = "Give as backpack tool", Desc = "on = card click hands you the pet, click again in-world to place it", Value = CONFIG.GIVE_TOOL, Callback = function(v) CONFIG.GIVE_TOOL = v end })
    optionsTab:Slider({ Title = "Held pet size (studs)", Step = 1, Value = { Min = 2, Max = 14, Default = CONFIG.HAND_MAX_STUDS }, Callback = function(v) CONFIG.HAND_MAX_STUDS = tonumber(v) or 4 end })
    optionsTab:Slider({ Title = "Scale multiplier", Step = 0.1, Value = { Min = 0.2, Max = 8, Default = CONFIG.SCALE_MULT }, Callback = function(v) CONFIG.SCALE_MULT = tonumber(v) or 1 end })
    optionsTab:Slider({ Title = "Spawn distance", Step = 1, Value = { Min = 4, Max = 60, Default = CONFIG.SPAWN_DISTANCE }, Callback = function(v) CONFIG.SPAWN_DISTANCE = tonumber(v) or 12 end })
    optionsTab:Slider({ Title = "Max active spawns", Step = 1, Value = { Min = 1, Max = 120, Default = CONFIG.MAX_SPAWNS }, Callback = function(v) CONFIG.MAX_SPAWNS = math.floor(tonumber(v) or 40) enforceSpawnLimit() end })
    optionsTab:Toggle({ Title = "Spin", Value = CONFIG.SPIN, Callback = function(v) CONFIG.SPIN = v end })
    optionsTab:Toggle({ Title = "Float", Value = CONFIG.FLOAT, Callback = function(v) CONFIG.FLOAT = v end })
    optionsTab:Toggle({ Title = "Place in my plot only", Value = CONFIG.OWN_PLOT_ONLY, Callback = function(v) CONFIG.OWN_PLOT_ONLY = v end })
    optionsTab:Toggle({ Title = "Sit on the ground", Value = CONFIG.GROUND, Callback = function(v) CONFIG.GROUND = v end })
    optionsTab:Toggle({ Title = "Play idle animation", Value = CONFIG.ANIMATE, Callback = function(v) CONFIG.ANIMATE = v end })
    optionsTab:Toggle({ Title = "Name tags", Value = CONFIG.NAMETAG, Callback = function(v) CONFIG.NAMETAG = v end })
    optionsTab:Toggle({ Title = "Count it on my cash", Desc = "your own money label rises with the popups - visual only", Value = CONFIG.CASH_VISUAL, Callback = function(v) CONFIG.CASH_VISUAL = v if not v then releaseCashLabel() end end })
    optionsTab:Toggle({ Title = "Money popups", Desc = "green +$X off every spawn", Value = CONFIG.MONEY_POPUP, Callback = function(v) CONFIG.MONEY_POPUP = v end })
    optionsTab:Slider({ Title = "Payout interval (s)", Step = 0.5, Value = { Min = 0.5, Max = 10, Default = CONFIG.PAY_INTERVAL }, Callback = function(v) CONFIG.PAY_INTERVAL = tonumber(v) or 1 end })
    optionsTab:Toggle({ Title = "Anchored", Desc = "off = the rig falls on its own joints", Value = CONFIG.ANCHORED, Callback = function(v) CONFIG.ANCHORED = v end })

    optionsTab:Divider()
    optionsTab:Section({ Title = "Bulk" })
    optionsTab:Button({ Title = "Spawn random", Callback = function() local pet = pets[math.random(1, #pets)] spawnPet(pet) WindUI:Notify({ Title = pet.name, Content = "random spawn", Duration = 2, Icon = "dices" }) end })
    optionsTab:Button({ Title = "Spawn every pet of the selected rarity", Desc = "uses the rarity filter from the Pets tab", Callback = function() task.spawn(function() local count = 0 for _, pet in ipairs(pets) do local match = filter.rarity == "All" or pet.rarity == filter.rarity if match then if spawnPet(pet) then count += 1 end task.wait(0.05) end end WindUI:Notify({ Title = "bulk spawn", Content = count .. " spawned", Duration = 3, Icon = "sparkles" }) end) end })
    optionsTab:Button({ Title = "Clear all spawns", Callback = function() local count = #activeSpawns clearSpawns() WindUI:Notify({ Title = "cleared", Content = count .. " removed", Duration = 2, Icon = "trash-2" }) end })
    optionsTab:Button({ Title = "Empty the backpack", Desc = "removes every pet tool this script handed you", Callback = function() local count = #activeTools clearTools() WindUI:Notify({ Title = "backpack cleared", Content = count .. " tools removed", Duration = 2, Icon = "backpack" }) end })
    optionsTab:Divider()
    optionsTab:Button({ Title = "Unload (End)", Desc = "kills every spawn, the hub and all connections", Callback = function() getgenv().__MONEYHUB_SPAWNER.unload() end })

    UI.rebuild()
    if petNames[1] then previewPet(petNames[1]) end
    pcall(function() window:SelectTab(petsTab.Index) end)
    return window
end

getgenv().__MONEYHUB_SPAWNER = {
    unload = unload,
    CONFIG = CONFIG,
    PETS = pets,
    spawn = spawnPet,
    give = giveTool,
    tools = activeTools,
    clear = clearSpawns,
}

track(UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.End then unload() end
end))

buildUI()
warn("[MoneyHUB] loaded - " .. #pets .. " assets indexed. Unload: End.")
