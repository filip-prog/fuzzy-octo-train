
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local REPO = "https://raw.githubusercontent.com/filip-prog/fuzzy-octo-train/main/"

if CoreGui:FindFirstChild("PrimeHUB_Loading") then
    CoreGui.PrimeHUB_Loading:Destroy()
end

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "PrimeHUB_Loading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 99999
loadingGui.Parent = CoreGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BorderSizePixel = 0
bg.Parent = loadingGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 70)
title.Position = UDim2.new(0, 0, 0.4, 0)
title.BackgroundTransparency = 1
title.Text = "PrimeHUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 52
title.Font = Enum.Font.GothamBold
title.Parent = bg

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 30)
subtitle.Position = UDim2.new(0, 0, 0.49, 0)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Loading..."
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.TextSize = 18
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = bg

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 400, 0, 10)
barBg.Position = UDim2.new(0.5, -200, 0.58, 0)
barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
barBg.BorderSizePixel = 0
barBg.Parent = bg
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
barFill.BorderSizePixel = 0
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(1, 0, 0, 20)
percentLabel.Position = UDim2.new(0, 0, 0.62, 0)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "0%"
percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentLabel.TextSize = 14
percentLabel.Font = Enum.Font.Gotham
percentLabel.Parent = bg

local function setProgress(percent, text)
    percent = math.clamp(percent, 0, 1)
    subtitle.Text = text or "Loading..."
    percentLabel.Text = math.floor(percent * 100) .. "%"
    TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(percent, 0, 1, 0)
    }):Play()
end

setProgress(0.2, "Loading functions...")
task.wait(0.4)
-- PrimeHUB Functions | Prison Life
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
while not player do task.wait() player = Players.LocalPlayer end
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera
local defaultCameraFOV = camera.FieldOfView
local mouse = player:GetMouse()

getgenv().SilentAimSettings = {
    Enabled = true, ForceFieldCheck = true, TargetPart = "HumanoidRootPart",
    Method = "Raycast", VisibleCheck = true, TeamCheck = true, Smoothing = 0,
    HitChance = 100, FOVEnabled = true, FOVRadius = 100,
    FOVColor = Color3.fromRGB(255, 255, 255), FOVThickness = 1, FriendCheck = true,
    SpinbotSpeed = 0, ESPEnabled = false, ESPNamesEnabled = true,
    ESPTargetColor = Color3.fromRGB(255, 182, 255),
    TargetTeams = { Inmates = true, Guards = true, Criminals = true },
    HostileCheck = false, TrespassCheck = false,
    TracerColor = Color3.fromRGB(255, 182, 255), TracerThickness = 0.1,
    TracerESPEnabled = false, TracerTargetOnly = false, Autoshoot = false,
    SilentAimRange = 500, CameraFOVEnabled = false, CameraFOV = 70,
    NoclipEnabled = false, InfiniteJumpEnabled = false, InvisibleEnabled = false,
    AntiInvisibleEnabled = false, TargetOnPlayer = {}, IgnoreTargets = {},
    AimMode = "FOV", GunModEnabled = false, AutoFire = false,
    FastFirerateEnabled = false, FireRateValue = 0.01, AutoReloadEnabled = false,
    KillEffectEnabled = false, KillEffectColor = Color3.fromRGB(255, 255, 255),
    KillEffectFadeDuration = 0.25, KillLogsEnabled = false, HitLogsEnabled = false,
    HitboxExpanderEnabled = false, HitboxTeamCheck = true, GetWeaponsList = {},
    AutoGetWeapons = false, InfiniteStamina = false, HitboxSize = 1,
    HitboxTransparency = 0.5, HitboxShape = "Box", GunSwitchList = {},
    GunSwitchDelay = 0.01, GunSwitchEnabled = false, GunSwitchCycleAll = false,
    AntiSitEnabled = false, ESPTextColor = Color3.fromRGB(255, 255, 255),
    ESPTargetTextColor = Color3.fromRGB(255, 182, 255), ESPTargetNameEnabled = false,
    TargetCustomText = "Target", ESPNameTextSize = 12, ESPTargetNameTextSize = 12,
    VehicleFlyEnabled = false, VehicleFlyHeight = 0,
    VehicleMaxSpeedEnabled = false, VehicleMaxSpeed = 110, SelectedCar = nil,
}

local Settings = getgenv().SilentAimSettings
local currentSkybox = nil
local smoothedTargetPosition = nil
local currentTarget = nil
local lastTargetPlayer = nil
local shootRemote = nil
local AutoShootRaycastInProgress = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PrimeHUB_FOV"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local fovCircle = Instance.new("Frame", screenGui)
fovCircle.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
Instance.new("UICorner", fovCircle).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", fovCircle).Color = Settings.FOVColor
fovCircle.UIStroke.Thickness = Settings.FOVThickness
fovCircle.Visible = Settings.Enabled and Settings.FOVEnabled

function toggleFOVCircle(hide)
    local stroke = fovCircle:FindFirstChild("UIStroke")
    if stroke then stroke.Enabled = not hide end
end

function toggleForceFieldCheck(enabled) Settings.ForceFieldCheck = enabled end

local tracerBeams = {}

local function removeTracerBeam(plr)
    local data = tracerBeams[plr]
    if data then
        if data.Beam then data.Beam:Destroy() end
        if data.Start then data.Start:Destroy() end
        if data.End then data.End:Destroy() end
        tracerBeams[plr] = nil
    end
end

local function removeAllTracerBeams()
    for plr, _ in pairs(tracerBeams) do removeTracerBeam(plr) end
end

local function getPlayerTracerColor(plr)
    if currentTarget and currentTarget.Parent and plr.Character and currentTarget.Parent == plr.Character then
        return Settings.TracerColor
    end
    if plr.TeamColor then return plr.TeamColor.Color
    elseif plr.Team and plr.Team.TeamColor then return plr.Team.TeamColor.Color end
    return Settings.TracerColor
end

local function updateTracerBeam(plr)
    local char = plr.Character
    local localChar = player.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    local targetHRP = char and char:FindFirstChild("HumanoidRootPart")

    if not char or not localHRP or not targetHRP then
        removeTracerBeam(plr)
        return
    end

    local data = tracerBeams[plr]
    if data then
        if data.Start.Parent ~= localHRP or data.End.Parent ~= targetHRP then
            removeTracerBeam(plr)
            data = nil
        end
    end

    if not data then
        local attachment0 = Instance.new("Attachment")
        attachment0.Parent = localHRP
        local attachment1 = Instance.new("Attachment")
        attachment1.Parent = targetHRP
        local beam = Instance.new("Beam")
        beam.Name = "TracerBeam"
        beam.Attachment0 = attachment0
        beam.Attachment1 = attachment1
        beam.FaceCamera = true
        beam.Parent = targetHRP
        data = { Beam = beam, Start = attachment0, End = attachment1 }
        tracerBeams[plr] = data
    end

    local color = getPlayerTracerColor(plr)
    data.Beam.Color = ColorSequence.new(color)
    data.Beam.Width0 = Settings.TracerThickness
    data.Beam.Width1 = Settings.TracerThickness
    data.Beam.Enabled = true
end

local function getCurrentTargetPlayer()
    if Settings.Enabled and currentTarget and currentTarget.Parent then
        local targetChar = currentTarget.Parent
        if targetChar:IsA("Model") then
            return Players:GetPlayerFromCharacter(targetChar)
        end
    end
    return nil
end

local function updateAllTracerBeams()
    if not Settings.ESPEnabled or not Settings.TracerESPEnabled then
        removeAllTracerBeams()
        return
    end
    if Settings.TracerTargetOnly then
        local targetPlayer = getCurrentTargetPlayer()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                if plr == targetPlayer then
                    local char = plr.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if char and hum and hum.Health > 0 then updateTracerBeam(plr) else removeTracerBeam(plr) end
                else removeTracerBeam(plr) end
            end
        end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health > 0 then updateTracerBeam(plr) else removeTracerBeam(plr) end
        end
    end
    for plr, _ in pairs(tracerBeams) do
        if not plr.Parent or plr == player then removeTracerBeam(plr) end
    end
end

local GuiService = game:GetService("GuiService")

local function getAdjustedMousePosition()
    local mousePos = UserInputService:GetMouseLocation()
    local inset = GuiService:GetGuiInset()
    return Vector2.new(mousePos.X - inset.X, mousePos.Y - inset.Y)
end

local function updateFOVPosition()
    if not fovCircle then return end
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    local usingTouch = UserInputService:GetLastInputType() == Enum.UserInputType.Touch
    if usingTouch then
        fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
    else
        local adjustedMousePos = getAdjustedMousePosition()
        fovCircle.Position = UDim2.new(0, adjustedMousePos.X, 0, adjustedMousePos.Y)
    end
end

local function isVisible(targetCharacter)
    if not targetCharacter then return false end
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return false end
    local localChar = player.Character
    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localHRP then return false end
    local origin = targetHRP.Position
    local direction = localHRP.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {player.Character, targetCharacter}
    local result = workspace:Raycast(origin, direction, params)
    return result == nil
end

local function isValidTarget(plr)
    if not plr or plr == player then return false end
    if not plr.Character then return false end
    if Settings.IgnoreTargets and #Settings.IgnoreTargets > 0 then
        for _, name in ipairs(Settings.IgnoreTargets) do
            if plr.Name == name then return false end
        end
    end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hum or hum.Health <= 0 or not hrp then return false end
    if Settings.FriendCheck and player:IsFriendsWith(plr.UserId) then return false end
    if Settings.TeamCheck then
        if player.Team and plr.Team == player.Team then return false end
    end
    if plr.Team and Settings.TargetTeams and not Settings.TargetTeams[plr.Team.Name] then return false end
    if Settings.SilentAimRange then
        local localRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if localRoot then
            local dist = (hrp.Position - localRoot.Position).Magnitude
            if dist > Settings.SilentAimRange then return false end
        end
    end
    if Settings.VisibleCheck then
        if not isVisible(plr.Character) then return false end
    end
    if Settings.ForceFieldCheck then
        if plr.Character:FindFirstChildOfClass("ForceField") then return false end
    end
    if Settings.HostileCheck or Settings.TrespassCheck then
        local localTeam = player.Team and player.Team.Name
        local targetTeam = plr.Team and plr.Team.Name
        local isGuardOrCriminal = (localTeam == "Guards" or localTeam == "Criminals")
        local isInmate = (targetTeam == "Inmates")
        if isGuardOrCriminal and isInmate then
            local hostile = plr.Character:GetAttribute("Hostile")
            local trespass = plr.Character:GetAttribute("Trespassing")
            if Settings.HostileCheck and Settings.TrespassCheck then
                if not hostile and not trespass then return false end
            elseif Settings.HostileCheck then
                if not hostile then return false end
            elseif Settings.TrespassCheck then
                if not trespass then return false end
            end
        end
    end
    return true
end

local RandomPartNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart"}
local CurrentRandomPart = "HumanoidRootPart"

task.spawn(function()
    while true do
        if Settings.TargetPart == "Random" then
            CurrentRandomPart = RandomPartNames[math.random(1, #RandomPartNames)]
        end
        task.wait(0.5)
    end
end)

local function getEffectiveTargetPart()
    if Settings.TargetPart == "Random" then return CurrentRandomPart end
    return Settings.TargetPart
end

local function getClosestTarget()
    if Settings.TargetOnPlayer and #Settings.TargetOnPlayer > 0 then
        local closestTargetPart = nil
        local closestTargetDist = math.huge
        for _, targetName in ipairs(Settings.TargetOnPlayer) do
            local targetPlr = Players:FindFirstChild(targetName)
            if targetPlr and isValidTarget(targetPlr) then
                local part = targetPlr.Character:FindFirstChild(getEffectiveTargetPart()) or targetPlr.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                        local mousePos = getAdjustedMousePosition()
                        local useMouse = not UserInputService.TouchEnabled
                        local screenDist
                        if useMouse then
                            screenDist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                        else
                            screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        end
                        if screenDist < closestTargetDist then
                            closestTargetPart = part
                            closestTargetDist = screenDist
                        end
                    end
                end
            end
        end
        if closestTargetPart then return closestTargetPart end
        return nil
    end
    local localRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not localRoot then return nil end
    local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    local mousePos = getAdjustedMousePosition()
    local useMouse = not UserInputService.TouchEnabled
    local closest = nil
    local shortestDistance = math.huge
    if Settings.AimMode == "Distance" then
        for _, plr in ipairs(Players:GetPlayers()) do
            if isValidTarget(plr) then
                local part = plr.Character:FindFirstChild(getEffectiveTargetPart()) or plr.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    local worldDist = (part.Position - localRoot.Position).Magnitude
                    if worldDist < shortestDistance then
                        closest = part
                        shortestDistance = worldDist
                    end
                end
            end
        end
        return closest
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if isValidTarget(plr) then
            local part = plr.Character:FindFirstChild(getEffectiveTargetPart()) or plr.Character:FindFirstChild("HumanoidRootPart")
            if part then
                local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local screenDist
                    if useMouse then
                        screenDist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                    else
                        screenDist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    end
                    if screenDist <= Settings.FOVRadius then
                        local worldDist = (part.Position - localRoot.Position).Magnitude
                        if worldDist < shortestDistance then
                            closest = part
                            shortestDistance = worldDist
                        end
                    end
                end
            end
        end
    end
    return closest
end

local ExpectedArguments = {
    FindPartOnRayWithIgnoreList = { ArgCountRequired = 3, Args = { "Instance", "Ray", "table", "boolean", "boolean" } },
    FindPartOnRayWithWhitelist = { ArgCountRequired = 3, Args = { "Instance", "Ray", "table", "boolean" } },
    FindPartOnRay = { ArgCountRequired = 2, Args = { "Instance", "Ray", "Instance", "boolean", "boolean" } },
    Raycast = { ArgCountRequired = 3, Args = { "Instance", "Vector3", "Vector3", "RaycastParams" } }
}

local function CalculateChance(Percentage)
    Percentage = math.floor(Percentage)
    local chance = math.floor(Random.new().NextNumber(Random.new(), 0, 1) * 100) / 100
    return chance <= Percentage / 100
end

local function ValidateArguments(Args, RayMethod)
    local Matches = 0
    if #Args < RayMethod.ArgCountRequired then return false end
    for Pos, Argument in next, Args do
        if typeof(Argument) == RayMethod.Args[Pos] then Matches = Matches + 1 end
    end
    return Matches >= RayMethod.ArgCountRequired
end

local function getSpreadDirection(Origin, OriginalDirection, HitPart)
    if typeof(HitPart) ~= "Instance" or not HitPart.Parent then return OriginalDirection end
    local OriginalDistance = OriginalDirection.Magnitude
    if OriginalDistance == 0 then OriginalDistance = 1000 end
    local PartSize = HitPart.Size
    local SpreadX = (math.random() - 0.5) * (PartSize.X + 2) * 0.2
    local SpreadY = (math.random() - 0.5) * (PartSize.Y + 2) * 0.2
    local SpreadZ = (math.random() - 0.5) * (PartSize.Z + 2) * 0.2
    local RandomOffset = Vector3.new(SpreadX, SpreadY, SpreadZ)
    if RandomOffset.Magnitude == 0 then RandomOffset = Vector3.new(0.1, 0.1, 0.1) end
    local BasePosition = smoothedTargetPosition or HitPart.Position
    local TargetPosition = BasePosition + RandomOffset
    local NewDirection = (TargetPosition - Origin)
    local NewDistance = NewDirection.Magnitude
    if NewDistance == 0 then return OriginalDirection end
    local FinalDistance = math.max(OriginalDistance, NewDistance)
    return NewDirection.Unit * FinalDistance
end

local function getRedirectedDirection(Origin, OriginalDirection)
    if currentTarget and currentTarget.Parent then
        return getSpreadDirection(Origin, OriginalDirection, currentTarget)
    end
    return nil
end

local function registerHit(result)
    if not result then return end
    local hitPart
    if typeof(result) == "Instance" then hitPart = result
    elseif typeof(result) == "table" and result.Instance then hitPart = result.Instance end
    if not hitPart or not hitPart:IsA("BasePart") then return end
    local char = hitPart:FindFirstAncestorOfClass("Model")
    if not char then return end
    local hitPlayer = Players:GetPlayerFromCharacter(char)
    if not hitPlayer or hitPlayer == player then return end
    if Settings.HitLogsEnabled and Library and Library.Notify then
        Library:Notify({ Title = "Hit Logs", Description = "You hit " .. hitPlayer.Name, Time = 3 })
    end
    if getgenv().playHitSound then getgenv().playHitSound() end
end

local function isLocalPlayerShooting(Arguments, Method, Origin, OriginalDirection)
    local LocalChar = player.Character
    if not LocalChar then return false end
    local rayLength = OriginalDirection and OriginalDirection.Magnitude or 0
    if Origin and (Origin - camera.CFrame.Position).Magnitude <= 2 then
        if rayLength < 30 then return false end
    end
    local ignoreList = nil
    if Method == "Raycast" then
        local params = Arguments[4]
        if typeof(params) == "RaycastParams" then ignoreList = params.FilterDescendantsInstances end
    elseif Method == "FindPartOnRayWithIgnoreList" then
        if typeof(Arguments[3]) == "table" then ignoreList = Arguments[3] end
    elseif Method == "FindPartOnRay" or Method == "findPartOnRay" then
        if typeof(Arguments[3]) == "table" then ignoreList = Arguments[3]
        elseif typeof(Arguments[4]) == "table" then ignoreList = Arguments[4] end
    end
    if ignoreList then
        for _, inst in next, ignoreList do
            if inst == LocalChar then return true end
        end
    end
    if Origin and (Origin - camera.CFrame.Position).Magnitude <= 2 then return true end
    return false
end

local function tryGetOriginDirection(Method, Arguments)
    if Method == "FindPartOnRayWithIgnoreList" or Method == "FindPartOnRayWithWhitelist"
        or Method == "FindPartOnRay" or Method == "findPartOnRay" then
        local A_Ray = Arguments[2]
        if typeof(A_Ray) == "Ray" then return A_Ray.Origin, A_Ray.Direction end
    elseif Method == "Raycast" then
        local A_Origin = Arguments[2]
        local A_Direction = Arguments[3]
        if typeof(A_Origin) == "Vector3" and typeof(A_Direction) == "Vector3" then
            return A_Origin, A_Direction
        end
    end
    return nil, nil
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
    local Method = getnamecallmethod()
    local Arguments = {...}
    local self = Arguments[1]

    if Method == "Play" and self.ClassName == "Sound" and not checkcaller() then
        local tool = self.Parent and self.Parent.Parent
        local localChar = player.Character
        if localChar and tool and tool.Parent == localChar and tool.ClassName == "Tool" and tool:GetAttribute("ToolType") == "Gun" then
            local soundClone = self:Clone()
            soundClone.Parent = camera
            soundClone.Playing = true
            task.delay(5, soundClone.Destroy, soundClone)
            return
        end
    end

    if shootRemote and self == shootRemote and Method == "FireServer" then
        local bulletData = Arguments[2]
        local firstPellet = type(bulletData) == "table" and bulletData[1] or nil
        local hitInstance = firstPellet and firstPellet[3] or nil
        task.defer(function()
            local success, validInstance = pcall(function()
                return hitInstance and typeof(hitInstance) == "Instance" and hitInstance.Parent and hitInstance.Name ~= "" and hitInstance
            end)
            if success and validInstance then registerHit(validInstance) end
        end)
    end

    if self == workspace and not checkcaller() then
        local Origin, Direction = tryGetOriginDirection(Method, Arguments)
        if Origin and Direction and isLocalPlayerShooting(Arguments, Method, Origin, Direction) then
            if Settings.Enabled and Settings.Method:lower() == Method:lower() and not AutoShootRaycastInProgress then
                local chance = CalculateChance(Settings.HitChance)
                if chance == true then
                    if Method == "FindPartOnRayWithIgnoreList" and ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithIgnoreList) then
                        local NewDir = getRedirectedDirection(Origin, Direction)
                        if NewDir then Arguments[2] = Ray.new(Origin, NewDir) end
                    elseif Method == "FindPartOnRayWithWhitelist" and ValidateArguments(Arguments, ExpectedArguments.FindPartOnRayWithWhitelist) then
                        local NewDir = getRedirectedDirection(Origin, Direction)
                        if NewDir then Arguments[2] = Ray.new(Origin, NewDir) end
                    elseif (Method == "FindPartOnRay" or Method == "findPartOnRay") and ValidateArguments(Arguments, ExpectedArguments.FindPartOnRay) then
                        local NewDir = getRedirectedDirection(Origin, Direction)
                        if NewDir then Arguments[2] = Ray.new(Origin, NewDir) end
                    elseif Method == "Raycast" and ValidateArguments(Arguments, ExpectedArguments.Raycast) then
                        local NewDir = getRedirectedDirection(Origin, Direction)
                        if NewDir then Arguments[3] = NewDir end
                    end
                end
            end
            local rets = table.pack(oldNamecall(unpack(Arguments)))
            return table.unpack(rets, 1, rets.n)
        end
    end
    return oldNamecall(...)
end))

task.spawn(function()
    while task.wait(0.1) do
        if Settings.Enabled then
            currentTarget = getClosestTarget()
        else
            currentTarget = nil
        end
    end
end)

local MaxSmoothTime = 1.5

RunService.RenderStepped:Connect(function(deltaTime)
    if workspace.CurrentCamera then
        if Settings.CameraFOVEnabled and Settings.CameraFOV then
            workspace.CurrentCamera.FieldOfView = Settings.CameraFOV
        else
            workspace.CurrentCamera.FieldOfView = defaultCameraFOV
        end
    end
    updateFOVPosition()
    if fovCircle then
        fovCircle.Visible = Settings.Enabled and Settings.FOVEnabled
        fovCircle.Size = UDim2.new(0, Settings.FOVRadius * 2, 0, Settings.FOVRadius * 2)
        if fovCircle:FindFirstChild("UIStroke") then
            fovCircle.UIStroke.Thickness = Settings.FOVThickness
        end
    end
    if Settings.Enabled and currentTarget and currentTarget.Parent then
        if not smoothedTargetPosition then
            smoothedTargetPosition = currentTarget.Position
        else
            local tau = Settings.Smoothing * MaxSmoothTime
            local alpha = 1
            if tau > 0.0001 then alpha = 1 - math.exp(-deltaTime / tau) end
            smoothedTargetPosition = smoothedTargetPosition:Lerp(currentTarget.Position, alpha)
        end
    else
        smoothedTargetPosition = nil
    end
    updateAllTracerBeams()
end)

local function resetAllHighlights()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local highlight = plr.Character:FindFirstChild("ESPHighlight")
            if highlight and highlight:IsA("Highlight") then
                local teamColor = Color3.fromRGB(255, 0, 0)
                if plr.TeamColor then teamColor = plr.TeamColor.Color
                elseif plr.Team and plr.Team.TeamColor then teamColor = plr.Team.TeamColor.Color end
                highlight.FillColor = teamColor
                highlight.OutlineColor = teamColor
                highlight.FillTransparency = 0.85
                highlight.OutlineTransparency = 0
            end
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChild("ESPNameTag")
                if billboard then
                    local label = billboard:FindFirstChild("NameLabel") or billboard:FindFirstChildOfClass("TextLabel")
                    if label then
                        label.TextColor3 = Settings.ESPTextColor or Color3.fromRGB(255, 255, 255)
                        label.TextSize = Settings.ESPNameTextSize or 12
                        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    end
                end
            end
        end
    end
end

local function highlightTarget(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    local targetColor = Settings.ESPTargetColor or Color3.fromRGB(255, 182, 255)
    local highlight = targetPlayer.Character:FindFirstChild("ESPHighlight")
    if highlight and highlight:IsA("Highlight") then
        highlight.FillColor = targetColor
        highlight.OutlineColor = targetColor
        highlight.FillTransparency = 0.65
        highlight.OutlineTransparency = 0
    end
end

local function ensureTargetNameTag(head)
    local billboard = head:FindFirstChild("ESPTargetNameTag")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPTargetNameTag"
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.StudsOffset = Vector3.new(0, 1.5, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        local label = Instance.new("TextLabel")
        label.Name = "TargetLabel"
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = Settings.TargetCustomText or "Target"
        label.Font = Enum.Font.GothamBold
        label.TextStrokeTransparency = 0
        label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        label.Parent = billboard
    end
    return billboard
end

local function updateTargetNameTag(targetPlayer)
    if lastTargetPlayer and lastTargetPlayer ~= targetPlayer and lastTargetPlayer.Character then
        local oldHead = lastTargetPlayer.Character:FindFirstChild("Head")
        if oldHead then
            local oldBillboard = oldHead:FindFirstChild("ESPTargetNameTag")
            if oldBillboard then oldBillboard:Destroy() end
        end
    end
    if not targetPlayer or not targetPlayer.Character then return end
    local head = targetPlayer.Character:FindFirstChild("Head")
    if not head then return end
    if Settings.ESPTargetNameEnabled then
        local billboard = ensureTargetNameTag(head)
        local label = billboard:FindFirstChild("TargetLabel")
        if label then
            label.TextColor3 = Settings.ESPTargetTextColor or Color3.fromRGB(255, 182, 255)
            label.TextSize = Settings.ESPTargetNameTextSize or 12
            label.Text = Settings.TargetCustomText or "Target"
        end
    else
        local billboard = head:FindFirstChild("ESPTargetNameTag")
        if billboard then billboard:Destroy() end
    end
end

getgenv().SetTargetCustomText = function(text)
    if not text or text == "" then text = "Target" end
    Settings.TargetCustomText = text
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            if head then
                local billboard = head:FindFirstChild("ESPTargetNameTag")
                if billboard then
                    local label = billboard:FindFirstChild("TargetLabel")
                    if label then label.Text = text end
                end
            end
        end
    end
end

local function updateESPSync()
    if not Settings.ESPEnabled then return end
    resetAllHighlights()
    local targetPlayer = getCurrentTargetPlayer()
    if targetPlayer and targetPlayer.Character then highlightTarget(targetPlayer) end
    updateTargetNameTag(targetPlayer)
    lastTargetPlayer = targetPlayer
end

RunService.RenderStepped:Connect(function()
    if Settings.ESPEnabled then updateESPSync() end
end)

task.spawn(function()
    while task.wait(0.5) do
        if Settings.ESPEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then applyESP(plr) else removeESP(plr) end
                end
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if Settings.SpinbotSpeed > 0 then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(Settings.SpinbotSpeed), 0)
        end
    end
end)

pcall(function()
    local hook = newcclosure(function() end)
    for _, obj in next, getgc(false) do
        if typeof(obj) == "function" then
            local ok, source = pcall(debug.info, obj, "s")
            if ok and source and source:find("CharacterCollision") then
                pcall(hookfunction, obj, hook)
            end
        end
    end
end)

local noclipConnection = nil
local function noclipStep()
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
    end
end
local function startNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(noclipStep)
end
local function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
end
getgenv().SetNoclipEnabled = function(v)
    Settings.NoclipEnabled = v == true
    if Settings.NoclipEnabled then startNoclip() else stopNoclip() end
end

UserInputService.JumpRequest:Connect(function()
    if Settings.InfiniteJumpEnabled then
        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
getgenv().SetInfiniteJumpEnabled = function(v) Settings.InfiniteJumpEnabled = v == true end

local InvisibleRealCFrame = nil
local InvisibleAnimationTrack = nil
local InvisibleRenderKey = "PrimeInvisibleRender"
local InvisibleOriginalTransparency = {}
local InvisibleOriginalCanCollide = {}

local function loadInvisibleAnimation(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return nil end
    local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
    local animation = Instance.new("Animation")
    animation.AnimationId = isR15 and "rbxassetid://18665825805" or "rbxassetid://215384594"
    local track = animator:LoadAnimation(animation)
    track.Priority = Enum.AnimationPriority.Action4
    track:Play(0, 0.001, 0)
    animation:Destroy()
    task.delay(0, function()
        track.TimePosition = isR15 and 1.95 or 0.4
    end)
    return track
end

local function stopInvisible()
    pcall(function() RunService:UnbindFromRenderStep(InvisibleRenderKey) end)
    if InvisibleAnimationTrack then
        InvisibleAnimationTrack:Stop()
        InvisibleAnimationTrack:Destroy()
        InvisibleAnimationTrack = nil
    end
    local character = player.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart and InvisibleRealCFrame then
        rootPart.CFrame = InvisibleRealCFrame
        local currentVelocity = rootPart.AssemblyLinearVelocity
        rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
    end
    InvisibleRealCFrame = nil
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part ~= rootPart then
                if InvisibleOriginalTransparency[part] ~= nil then part.Transparency = InvisibleOriginalTransparency[part] end
                if InvisibleOriginalCanCollide[part] ~= nil then part.CanCollide = InvisibleOriginalCanCollide[part] end
            end
        end
        if rootPart then rootPart.Transparency = 1 end
    end
    table.clear(InvisibleOriginalTransparency)
    table.clear(InvisibleOriginalCanCollide)
end

local function startInvisible()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    InvisibleAnimationTrack = loadInvisibleAnimation(character)
    InvisibleRealCFrame = nil
    table.clear(InvisibleOriginalTransparency)
    table.clear(InvisibleOriginalCanCollide)
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part ~= rootPart then
            InvisibleOriginalTransparency[part] = part.Transparency
            InvisibleOriginalCanCollide[part] = part.CanCollide
            part.Transparency = 0.5
            part.CanCollide = false
        end
    end
    rootPart.Transparency = 1
    pcall(function() RunService:UnbindFromRenderStep(InvisibleRenderKey) end)
    RunService:BindToRenderStep(InvisibleRenderKey, Enum.RenderPriority.Camera.Value - 1, function()
        if Settings.InvisibleEnabled and InvisibleRealCFrame and rootPart.Parent then
            rootPart.CFrame = InvisibleRealCFrame
            if InvisibleAnimationTrack then InvisibleAnimationTrack:AdjustWeight(0.001) end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not Settings.InvisibleEnabled then return end
    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
    local dropOffset = humanoid.HipHeight + (rootPart.Size.Y / 2) - 1
    InvisibleRealCFrame = rootPart.CFrame
    rootPart.CFrame = (rootPart.CFrame - Vector3.new(0, dropOffset, 0)) * CFrame.Angles(math.rad(isR15 and 180 or 90), 0, 0)
    local currentVelocity = rootPart.AssemblyLinearVelocity
    rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
    if InvisibleAnimationTrack then InvisibleAnimationTrack:AdjustWeight(100) end
end)

player.CharacterAdded:Connect(function(character)
    if Settings.InvisibleEnabled then
        task.wait(0.5)
        startInvisible()
    end
end)

getgenv().SetInvisibleEnabled = function(v)
    Settings.InvisibleEnabled = v == true
    if Settings.InvisibleEnabled then startInvisible() else stopInvisible() end
end

local AntiInvisibleThreads = {}
local AntiInvisibleConnections = {}
local AntiInvisibleWhitelist = {}
pcall(function()
    for _, animation in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if animation:IsA("Animation") then AntiInvisibleWhitelist[animation.AnimationId] = true end
    end
end)

local function watchAnimationTrack(track)
    local animationId = track.Animation and track.Animation.AnimationId
    if not animationId or AntiInvisibleWhitelist[animationId] then return end
    if AntiInvisibleThreads[track] then task.cancel(AntiInvisibleThreads[track]) end
    AntiInvisibleThreads[track] = task.spawn(function()
        repeat
            track:AdjustWeight(0, 0)
            task.wait()
        until not (track.IsPlaying and Settings.AntiInvisibleEnabled)
        AntiInvisibleThreads[track] = nil
    end)
end

local function hookCharacterAnimations(character)
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    local animator = humanoid:WaitForChild("Animator", 5)
    if not animator then return end
    local connection = animator.AnimationPlayed:Connect(function(track)
        if Settings.AntiInvisibleEnabled then watchAnimationTrack(track) end
    end)
    AntiInvisibleConnections[character] = connection
    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        if Settings.AntiInvisibleEnabled then watchAnimationTrack(track) end
    end
end

local function hookPlayerAnimations(plr)
    if plr == player then return end
    if plr.Character then task.spawn(hookCharacterAnimations, plr.Character) end
    plr.CharacterAdded:Connect(function(character) task.spawn(hookCharacterAnimations, character) end)
end

for _, plr in ipairs(Players:GetPlayers()) do hookPlayerAnimations(plr) end
Players.PlayerAdded:Connect(hookPlayerAnimations)

getgenv().SetAntiInvisibleEnabled = function(v) Settings.AntiInvisibleEnabled = v == true end

local HeadlessMeshId = "rbxassetid://1095708"
local KorbloxMeshId = "rbxassetid://101851696"
local KorbloxTextureId = "rbxassetid://101851254"

local function applyHeadless(character)
    local head = character:FindFirstChild("Head")
    if not head then return end
    head.Transparency = 1
    head.CanCollide = false
    local face = head:FindFirstChildOfClass("Decal")
    if face then face:Destroy() end
    for _, v in ipairs(head:GetChildren()) do
        if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then v:Destroy() end
    end
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = HeadlessMeshId
    mesh.Scale = Vector3.new(0.001, 0.001, 0.001)
    mesh.Parent = head
end

local function applyKorblox(character)
    local rightLeg = character:FindFirstChild("Right Leg")
    if not rightLeg then return end
    for _, v in ipairs(rightLeg:GetChildren()) do
        if v:IsA("SpecialMesh") or v:IsA("CharacterMesh") then v:Destroy() end
    end
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = KorbloxMeshId
    mesh.TextureId = KorbloxTextureId
    mesh.Scale = Vector3.new(1, 1, 1)
    mesh.Parent = rightLeg
end

getgenv().SetHeadlessEnabled = function(v)
    Settings.HeadlessEnabled = v == true
    if Settings.HeadlessEnabled and player.Character then applyHeadless(player.Character) end
end

getgenv().SetKorbloxEnabled = function(v)
    Settings.KorbloxEnabled = v == true
    if Settings.KorbloxEnabled and player.Character then applyKorblox(player.Character) end
end

player.CharacterAdded:Connect(function(character)
    task.wait(1)
    if Settings.HeadlessEnabled then applyHeadless(character) end
    if Settings.KorbloxEnabled then applyKorblox(character) end
end)

local antiSitConnections = {}
local function disconnectAntiSit()
    for _, connection in antiSitConnections do connection:Disconnect() end
    antiSitConnections = {}
end
local function hookAntiSit(char)
    disconnectAntiSit()
    local humanoid = char:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    table.insert(antiSitConnections, humanoid.Seated:Connect(function(active, seatPart)
        if not Settings.AntiSitEnabled then return end
        if active and seatPart and not seatPart:IsA("VehicleSeat") then
            humanoid.Jump = true
            humanoid.Sit = false
        end
    end))
end

hookAntiSit(player.Character)
player.CharacterAdded:Connect(hookAntiSit)
getgenv().SetAntiSitEnabled = function(v) Settings.AntiSitEnabled = v == true end

local gunSwitchConnection = nil
local GunSwitchWeaponNames = {"M9", "Revolver", "MP5", "AK-47", "M4A1", "FAL", "Remington 870", "M700"}
local cycleAllWeaponList = {}
local cycleAllConnections = {}

local function refreshCycleAllList()
    local newList = {}
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and table.find(GunSwitchWeaponNames, tool.Name) then
                table.insert(newList, tool.Name)
            end
        end
    end
    local char = player.Character
    local equipped = char and char:FindFirstChildOfClass("Tool")
    if equipped and table.find(GunSwitchWeaponNames, equipped.Name) and not table.find(newList, equipped.Name) then
        table.insert(newList, equipped.Name)
    end
    cycleAllWeaponList = newList
end

local function disconnectCycleAllConnections()
    for _, conn in ipairs(cycleAllConnections) do conn:Disconnect() end
    cycleAllConnections = {}
end

local function hookCycleAllContainers(char)
    disconnectCycleAllConnections()
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        table.insert(cycleAllConnections, backpack.ChildAdded:Connect(function(child) if child:IsA("Tool") then refreshCycleAllList() end end))
        table.insert(cycleAllConnections, backpack.ChildRemoved:Connect(function(child) if child:IsA("Tool") then refreshCycleAllList() end end))
    end
    if char then
        table.insert(cycleAllConnections, char.ChildAdded:Connect(function(child) if child:IsA("Tool") then refreshCycleAllList() end end))
        table.insert(cycleAllConnections, char.ChildRemoved:Connect(function(child) if child:IsA("Tool") then refreshCycleAllList() end end))
    end
    refreshCycleAllList()
end

hookCycleAllContainers(player.Character)
player.CharacterAdded:Connect(function(char) task.wait(0.1) hookCycleAllContainers(char) end)

local function startGunSwitch()
    if gunSwitchConnection then pcall(task.cancel, gunSwitchConnection) gunSwitchConnection = nil end
    gunSwitchConnection = task.spawn(function()
        while Settings.GunSwitchEnabled do
            local char = player.Character
            if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then task.wait() continue end
            local humanoid = char.Humanoid
            local weaponList = Settings.GunSwitchCycleAll and cycleAllWeaponList or Settings.GunSwitchList
            if not weaponList or #weaponList == 0 then task.wait() continue end
            for _, weaponName in ipairs(weaponList) do
                if not Settings.GunSwitchEnabled then break end
                local weapon = player.Backpack:FindFirstChild(weaponName)
                if weapon then pcall(function() humanoid:EquipTool(weapon) end) end
                task.wait(Settings.GunSwitchDelay)
            end
        end
    end)
end

getgenv().ToggleGunSwitch = function(enabled)
    Settings.GunSwitchEnabled = enabled == true
    if Settings.GunSwitchEnabled then
        startGunSwitch()
    else
        if gunSwitchConnection then pcall(task.cancel, gunSwitchConnection) gunSwitchConnection = nil end
        local char = player.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then humanoid:UnequipTools() end
    end
end

player.CharacterAdded:Connect(function()
    if Settings.GunSwitchEnabled then task.wait(0.1) startGunSwitch() end
end)

local hitboxModified = {}

local function resetHitbox(hrp)
    if not hrp or not hrp.Parent then return end
    hrp.Size = Vector3.new(2, 2, 1)
    hrp.Transparency = 1
    hrp.CanCollide = false
    hrp.Material = Enum.Material.Plastic
    hrp.Shape = Enum.PartType.Block
end

local function applyHitbox(plr)
    if plr == player then return end
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local isSeated = humanoid and (humanoid.Sit or humanoid.SeatPart ~= nil)
    if isSeated then
        if hitboxModified[hrp] then resetHitbox(hrp) hitboxModified[hrp] = nil end
        return
    end
    if Settings.HitboxTeamCheck and player.Team and plr.Team == player.Team then
        if hitboxModified[hrp] then resetHitbox(hrp) hitboxModified[hrp] = nil end
        return
    end
    local size = Settings.HitboxSize or 1
    hrp.Size = Vector3.new(size, size, size)
    hrp.Transparency = Settings.HitboxTransparency or 0.5
    hrp.CanCollide = false
    hrp.Material = Enum.Material.ForceField
    hrp.Shape = (Settings.HitboxShape == "Ball") and Enum.PartType.Ball or Enum.PartType.Block
    hitboxModified[hrp] = true
end

RunService.Heartbeat:Connect(function()
    if not Settings.HitboxExpanderEnabled then
        for hrp in pairs(hitboxModified) do resetHitbox(hrp) end
        table.clear(hitboxModified)
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then applyHitbox(plr) end
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr.Character then
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hitboxModified[hrp] = nil end
    end
end)

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local antiJump = char:FindFirstChild("AntiJump")
    if antiJump then antiJump.Disabled = Settings.InfiniteStamina end
end)

local carContainer = workspace:WaitForChild("CarContainer")
local listcars = {}
local carNameLookup = {}

local function refreshCarList()
    listcars = {}
    carNameLookup = {}
    for _, car in ipairs(carContainer:GetChildren()) do
        local seat = car:FindFirstChild("VehicleSeat", true)
        if seat and car:FindFirstChild("Wheels") and not seat.Occupant then
            table.insert(listcars, car.Name)
            carNameLookup[car.Name] = car
        end
    end
end

local currentCar = nil
local seatConnection = nil

local function getCarFromSeat(seat)
    local model = seat
    local iterations = 0
    while model and model.Parent and model.Parent ~= carContainer do
        model = model.Parent
        iterations += 1
        if iterations > 20 then return nil end
    end
    if model and model.Parent == carContainer then return model end
    return nil
end

local function updateCurrentCar(_, seatPart)
    if seatPart and seatPart:IsA("VehicleSeat") then
        currentCar = getCarFromSeat(seatPart)
    else
        currentCar = nil
    end
end

local function hookCharacterSeat(char)
    task.spawn(function()
        local humanoid = char:WaitForChild("Humanoid", 5)
        if not humanoid or not char.Parent then return end
        if seatConnection then seatConnection:Disconnect() seatConnection = nil end
        currentCar = nil
        seatConnection = humanoid.Seated:Connect(updateCurrentCar)
    end)
end

if player.Character then hookCharacterSeat(player.Character) end
player.CharacterAdded:Connect(hookCharacterSeat)

local function findLocalCar() return currentCar end

local function flipCarVertical()
    local car = findLocalCar()
    if not car then return end
    local main = car:FindFirstChild("Body") and car.Body:FindFirstChild("Main")
    if not main then return end
    car.PrimaryPart = main
    local curCF = main.CFrame
    local x, y, z = curCF:ToEulerAnglesYXZ()
    local flipped = CFrame.new(curCF.Position) * CFrame.Angles(x + math.pi, y, z)
    car:PivotTo(flipped)
end

local function teleportCarToMe(carName)
    local car = carNameLookup[carName]
    if not car or not car:IsA("Model") then return false end
    local character = player.Character
    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end
    local body = car:FindFirstChild("Body")
    local main = body and body:FindFirstChild("Main")
    if not main then return false end
    local vehicleSeat = car:FindFirstChild("VehicleSeat", true)
    if not vehicleSeat then return false end
    local targetPos = humanoidRootPart.Position + Vector3.new(0, 3, 0)
    local curCF = main.CFrame
    local x, y, z = curCF:ToEulerAnglesYXZ()
    local targetCFrame = CFrame.new(targetPos) * CFrame.Angles(x, y, z)
    local partData = {}
    for _, v in ipairs(car:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(partData, { part = v, wasAnchored = v.Anchored, wasCanCollide = v.CanCollide })
            v.Anchored = true
            v.CanCollide = false
        end
    end
    car.PrimaryPart = main
    local characterParts = {}
    for _, v in ipairs(character:GetDescendants()) do
        if v:IsA("BasePart") then
            table.insert(characterParts, { part = v, wasCanCollide = v.CanCollide })
            v.CanCollide = false
        end
    end
    local success = false
    for attempt = 1, 20 do
        pcall(function() car:PivotTo(targetCFrame) end)
        task.wait()
        local distance = (main.Position - targetPos).Magnitude
        if distance < 5 then success = true break end
        if attempt % 5 == 0 then
            targetCFrame = CFrame.new(targetPos + Vector3.new(math.random(-2, 2), 0, math.random(-2, 2))) * CFrame.Angles(x, y, z)
        end
    end
    task.spawn(function()
        for attempt = 1, 20 do
            if not character or not character:FindFirstChild("HumanoidRootPart") then break end
            pcall(function() character:PivotTo(vehicleSeat.CFrame + Vector3.new(0, 1, 0)) end)
            task.wait()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - vehicleSeat.Position).Magnitude < 3 then break end
        end
    end)
    task.wait(0.2)
    local restoreConnection
    restoreConnection = RunService.RenderStepped:Connect(function()
        restoreConnection:Disconnect()
        for _, data in ipairs(characterParts) do
            if data.part and data.part.Parent then data.part.CanCollide = data.wasCanCollide end
        end
        for _, data in ipairs(partData) do
            if data.part and data.part.Parent then
                data.part.Anchored = data.wasAnchored
                data.part.CanCollide = data.wasCanCollide
            end
        end
    end)
    return success
end

getgenv().FlipVehicle = function() flipCarVertical() end
getgenv().RefreshCarList = function() refreshCarList() return listcars end
getgenv().BringCar = function(carName) if carName then teleportCarToMe(carName) end end
getgenv().TeleportToCar = function(carName)
    local car = carNameLookup[carName]
    if car then
        local vehicleseat = car:FindFirstChild("VehicleSeat", true)
        if vehicleseat and player.Character then player.Character:MoveTo(vehicleseat.Position) end
    end
end

task.spawn(function()
    local MOVE_STEP = 1
    local TOL = 0.1
    local baseY, targetY, lastSlider = nil, nil, nil
    while true do
        task.wait()
        if not Settings.VehicleFlyEnabled then
            baseY, targetY, lastSlider = nil, nil, nil
            if workspace:FindFirstChild("CarPart") then workspace.CarPart:Destroy() end
            continue
        end
        local car = findLocalCar()
        if not car then
            if workspace:FindFirstChild("CarPart") then workspace.CarPart:Destroy() end
            baseY, targetY, lastSlider = nil, nil, nil
            continue
        end
        local main = car:FindFirstChild("Body") and car.Body:FindFirstChild("Main")
        if not main then continue end
        car.PrimaryPart = main
        local curCF = main.CFrame
        local curPos = curCF.Position
        local sliderVal = Settings.VehicleFlyHeight or 0
        if not workspace:FindFirstChild("CarPart") then
            local p = Instance.new("Part")
            p.Size = Vector3.new(100, 1, 100)
            p.Name = "CarPart"
            p.Anchored = true
            p.CanCollide = true
            p.Material = Enum.Material.SmoothPlastic
            p.Color = Color3.fromRGB(100, 100, 100)
            p.Transparency = 1
            p.Parent = workspace
        end
        if not baseY then
            baseY = curPos.Y
            targetY = baseY + sliderVal
            lastSlider = sliderVal
        elseif sliderVal ~= lastSlider then
            targetY = baseY + sliderVal
            lastSlider = sliderVal
        end
        if curPos.Y < targetY - TOL then
            local x, y, z = curCF:ToEulerAnglesYXZ()
            local newY = math.min(curPos.Y + MOVE_STEP, targetY)
            car:PivotTo(CFrame.new(Vector3.new(curPos.X, newY, curPos.Z)) * CFrame.Angles(x, y, z))
        elseif curPos.Y > targetY + TOL then
            local x, y, z = curCF:ToEulerAnglesYXZ()
            local newY = math.max(curPos.Y - MOVE_STEP, targetY)
            car:PivotTo(CFrame.new(Vector3.new(curPos.X, newY, curPos.Z)) * CFrame.Angles(x, y, z))
        end
    end
end)

RunService.Heartbeat:Connect(function()
    pcall(function()
        local carPart = workspace:FindFirstChild("CarPart")
        if not carPart then return end
        local car = findLocalCar()
        if not car or not car:FindFirstChild("Wheels") then return end
        local wheel = car.Wheels:FindFirstChildWhichIsA("BasePart")
        if not wheel then return end
        carPart.Position = Vector3.new(wheel.Position.X, wheel.Position.Y - 1.3, wheel.Position.Z)
    end)
end)

local VehicleTorqueDefault = 5
local VehicleTurnSpeedDefault = 5

RunService.RenderStepped:Connect(function()
    local car = findLocalCar()
    if car then
        local rwd = car:FindFirstChild("RWD")
        local lw = car:FindFirstChild("LW") and car.LW:FindFirstChild("VS")
        local rw = car:FindFirstChild("RW") and car.RW:FindFirstChild("VS")
        local vehicleseat = car:FindFirstChild("Body") and car.Body:FindFirstChild("VehicleSeat")
        if rwd and lw and rw and vehicleseat then
            if Settings.VehicleMaxSpeedEnabled then
                local maxSpeed = Settings.VehicleMaxSpeed or 110
                rwd.MaxSpeed = maxSpeed
                lw.MaxSpeed = maxSpeed
                rw.MaxSpeed = maxSpeed
                vehicleseat.MaxSpeed = maxSpeed
                rwd.Torque = VehicleTorqueDefault
                lw.Torque = VehicleTorqueDefault
                rw.Torque = VehicleTorqueDefault
                vehicleseat.Torque = VehicleTorqueDefault
                rwd.TurnSpeed = VehicleTurnSpeedDefault
                lw.TurnSpeed = VehicleTurnSpeedDefault
                rw.TurnSpeed = VehicleTurnSpeedDefault
                vehicleseat.TurnSpeed = VehicleTurnSpeedDefault
            else
                rwd.TurnSpeed = 1
                lw.TurnSpeed = 1
                rw.TurnSpeed = 1
                vehicleseat.TurnSpeed = 1
            end
        end
    end
end)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
pcall(function()
    local gunRemotes = ReplicatedStorage:WaitForChild("GunRemotes", 5)
    if gunRemotes then shootRemote = gunRemotes:WaitForChild("ShootEvent", 5) end
end)

local AutoShootGunTracers = nil
pcall(function()
    local sharedModules = ReplicatedStorage:WaitForChild("SharedModules", 5)
    local tracersModule = sharedModules and sharedModules:WaitForChild("GunTracers", 5)
    if tracersModule then AutoShootGunTracers = require(tracersModule) end
end)

local function getEquippedWeapon()
    local char = player.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then return child end
    end
    return nil
end

local autoShootParams = RaycastParams.new()
autoShootParams.FilterType = Enum.RaycastFilterType.Exclude
autoShootParams.CollisionGroup = "ClientBullet"

local lastAutoShotByWeapon = {}

local function updateAmmoLabel(weapon, currentAmmo)
    local ok, gunFrame = pcall(function()
        return player.PlayerGui:WaitForChild("Home", 3):WaitForChild("hud", 3):WaitForChild("BottomRightFrame", 3):WaitForChild("GunFrame", 3)
    end)
    if not ok or not gunFrame then return end
    local bulletsLabel = gunFrame:FindFirstChild("BulletsLabel")
    if not bulletsLabel then return end
    local behavior = weapon:GetAttribute("Behavior")
    if behavior == "Sniper" then
        local stored = weapon:GetAttribute("StoredAmmo") or 0
        bulletsLabel.Text = currentAmmo .. " | " .. stored
    else
        local maxAmmo = weapon:GetAttribute("MaxAmmo") or currentAmmo
        bulletsLabel.Text = currentAmmo .. "/" .. maxAmmo
    end
end

local function castPelletRay(weapon, origin, aimPoint, spreadRadius)
    local roll = math.random()
    local behavior = weapon:GetAttribute("Behavior")
    if behavior == "Sniper" or behavior == "Shotgun" then roll = math.sqrt(roll) end
    local range = weapon:GetAttribute("Range") or 1000
    local lookCFrame = CFrame.new(origin, aimPoint)
    local rollAngle = 360 - 720 * math.random()
    local direction = (lookCFrame * CFrame.Angles(0, 0, math.rad(rollAngle)) * CFrame.Angles(0, roll * spreadRadius, 0)).LookVector * range
    AutoShootRaycastInProgress = true
    local result = workspace:Raycast(origin, direction, autoShootParams)
    AutoShootRaycastInProgress = false
    local hitInstance = result and result.Instance or nil
    local hitPosition = result and result.Position or (origin + direction)
    return hitInstance, hitPosition
end

local function performAutoShot(weapon)
    if not weapon or not shootRemote then return end
    if not currentTarget or not currentTarget.Parent then return end
    local behavior = weapon:GetAttribute("Behavior")
    local reloadSession = weapon:GetAttribute("Local_ReloadSession") or 0
    local currentAmmo = weapon:GetAttribute("Local_CurrentAmmo") or 0
    if reloadSession ~= 0 then return end
    if currentAmmo <= 0 then return end
    local char = player.Character
    local head = char and char:FindFirstChild("Head")
    if not head then return end
    local origin = head.Position
    autoShootParams.FilterDescendantsInstances = { char }
    local aimPoint = currentTarget.Position
    local redirected = getRedirectedDirection(origin, aimPoint - origin)
    if redirected then aimPoint = origin + redirected end
    local projectileCount = weapon:GetAttribute("ProjectileCount") or 1
    local spreadRadius = weapon:GetAttribute("SpreadRadius") or 0
    local muzzle = weapon:FindFirstChild("Muzzle")
    local muzzlePos = muzzle and muzzle.Position or origin
    local bulletData = {}
    for i = 1, projectileCount do
        local hitInstance, hitPosition = castPelletRay(weapon, origin, aimPoint, spreadRadius)
        table.insert(bulletData, { origin, hitPosition, hitInstance })
        if AutoShootGunTracers then
            pcall(function()
                if behavior == "Sniper" then AutoShootGunTracers.createSniper(muzzlePos, hitPosition)
                elseif behavior == "Taser" then AutoShootGunTracers.createTaser(muzzlePos, hitPosition)
                else AutoShootGunTracers.createBullet(muzzlePos, hitPosition) end
            end)
        end
    end
    shootRemote:FireServer(bulletData)
    local newAmmo = currentAmmo - 1
    weapon:SetAttribute("Local_CurrentAmmo", newAmmo)
    updateAmmoLabel(weapon, newAmmo)
    pcall(function()
        local handle = weapon:FindFirstChild("Handle")
        if handle then
            local shootSound = handle:FindFirstChild("ShootSound")
            if shootSound then
                local cloned = shootSound:Clone()
                cloned.Parent = handle
                cloned:Play()
                game:GetService("Debris"):AddItem(cloned, 5)
            end
            local flare = handle:FindFirstChild("Flare")
            if flare then
                flare.Enabled = true
                task.delay(0.05, function() if flare then flare.Enabled = false end end)
            end
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if not shootRemote then return end
    if not Settings.Enabled or not Settings.Autoshoot then return end
    if not currentTarget or not currentTarget.Parent then return end
    local char = player.Character
    local myHumanoid = char and char:FindFirstChildOfClass("Humanoid")
    if not myHumanoid or myHumanoid.Health <= 0 then return end
    local weapon = getEquippedWeapon()
    if not weapon then return end
    local fireRate = weapon:GetAttribute("FireRate") or 0.1
    local weaponAutoFireAttr = weapon:GetAttribute("AutoFire")
    if not weaponAutoFireAttr then fireRate = fireRate * 1.5 end
    if weapon.Name == "Remington 870" then fireRate = 0.45 end
    local lastShotTime = lastAutoShotByWeapon[weapon.Name] or 0
    if (tick() - lastShotTime) < fireRate then return end
    lastAutoShotByWeapon[weapon.Name] = tick()
    performAutoShot(weapon)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if Settings.FastSwitchKeyCode and input.KeyCode == Settings.FastSwitchKeyCode then return end
    if Settings.VehicleFlyKeyCode and input.KeyCode == Settings.VehicleFlyKeyCode then
        Settings.VehicleFlyEnabled = not Settings.VehicleFlyEnabled
        return
    end
    if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.LeftControl then
        Settings.Enabled = not Settings.Enabled
        if fovCircle then fovCircle.Visible = Settings.Enabled and Settings.FOVEnabled end
        if not Settings.Enabled then
            currentTarget = nil
            smoothedTargetPosition = nil
        end
    end
end)

player.CharacterAdded:Connect(function()
    camera.CameraType = Enum.CameraType.Custom
    if Settings.ESPEnabled then
        task.wait(0.5)
        updateESP()
    end
end)

local skyboxes = {
    ["Gray Skybox"] = { SkyboxBk = "rbxassetid://154987705", SkyboxDn = "rbxassetid://154987705", SkyboxFt = "rbxassetid://154987705", SkyboxLf = "rbxassetid://154987705", SkyboxRt = "rbxassetid://154987705", SkyboxUp = "rbxassetid://154987705" },
    ["2knw & Donk666 Skybox"] = { SkyboxBk = "rbxassetid://121222457209872", SkyboxDn = "rbxassetid://121222457209872", SkyboxFt = "rbxassetid://121222457209872", SkyboxLf = "rbxassetid://121222457209872", SkyboxRt = "rbxassetid://121222457209872", SkyboxUp = "rbxassetid://121222457209872" },
    ["Snow Skybox"] = { SkyboxBk = "rbxassetid://155657655", SkyboxDn = "rbxassetid://155674246", SkyboxFt = "rbxassetid://155657609", SkyboxLf = "rbxassetid://155657671", SkyboxRt = "rbxassetid://155657619", SkyboxUp = "rbxassetid://155674931" },
    ["Cartoon Skybox"] = { SkyboxBk = "rbxassetid://15114954171", SkyboxDn = "rbxassetid://15114958869", SkyboxFt = "rbxassetid://15114963740", SkyboxLf = "rbxassetid://15114957947", SkyboxRt = "rbxassetid://15114955238", SkyboxUp = "rbxassetid://15114948718" },
    ["Lince Skybox"] = { SkyboxBk = "rbxassetid://102112718813044", SkyboxDn = "rbxassetid://102112718813044", SkyboxFt = "rbxassetid://102112718813044", SkyboxLf = "rbxassetid://102112718813044", SkyboxRt = "rbxassetid://102112718813044", SkyboxUp = "rbxassetid://102112718813044" },
    ["Red Skybox"] = { SkyboxBk = "rbxassetid://401664839", SkyboxDn = "rbxassetid://401664862", SkyboxFt = "rbxassetid://401664960", SkyboxLf = "rbxassetid://401664881", SkyboxRt = "rbxassetid://401664901", SkyboxUp = "rbxassetid://401664936" },
    ["Slam Skybox"] = { SkyboxBk = "rbxassetid://111576755001670", SkyboxDn = "rbxassetid://111576755001670", SkyboxFt = "rbxassetid://111576755001670", SkyboxLf = "rbxassetid://111576755001670", SkyboxRt = "rbxassetid://111576755001670", SkyboxUp = "rbxassetid://111576755001670" },
    ["Green Eyeball Skybox"] = { SkyboxBk = "rbxassetid://113857258921684", SkyboxDn = "rbxassetid://131099902234134", SkyboxFt = "rbxassetid://98342317659302", SkyboxLf = "rbxassetid://130914716725043", SkyboxRt = "rbxassetid://93970360759256", SkyboxUp = "rbxassetid://135000456639127" },
    ["Morioh Skybox"] = { SkyboxBk = "rbxassetid://414118015", SkyboxDn = "rbxassetid://414117901", SkyboxFt = "rbxassetid://414117817", SkyboxLf = "rbxassetid://414118150", SkyboxRt = "rbxassetid://414118255", SkyboxUp = "rbxassetid://414118438" },
    ["Rainy Skybox"] = { SkyboxBk = "rbxassetid://4498828382", SkyboxDn = "rbxassetid://4498828812", SkyboxFt = "rbxassetid://4498829917", SkyboxLf = "rbxassetid://4498830911", SkyboxRt = "rbxassetid://4498830417", SkyboxUp = "rbxassetid://4498831746" },
    ["Rusk1ddski Skybox"] = { SkyboxBk = "rbxassetid://139878758241374", SkyboxDn = "rbxassetid://139878758241374", SkyboxFt = "rbxassetid://139878758241374", SkyboxLf = "rbxassetid://139878758241374", SkyboxRt = "rbxassetid://139878758241374", SkyboxUp = "rbxassetid://139878758241374" }
}

function setSkybox(name)
    if currentSkybox then
        pcall(function()
            if Lighting:FindFirstChild(currentSkybox) then Lighting[currentSkybox]:Destroy() end
        end)
        currentSkybox = nil
    end
    if name == "None" then return end
    local data = skyboxes[name]
    if not data then return end
    local sky = Instance.new("Sky", Lighting)
    sky.Name = name
    for prop, value in pairs(data) do sky[prop] = value end
    currentSkybox = name
end

local CustomBulletColorEnabled = false
local CustomBulletColor = Color3.fromRGB(255, 255, 0)

function setCustomBulletColorEnabled(enabled) CustomBulletColorEnabled = enabled end
function setBulletColorRGB(color) CustomBulletColor = color end

local ReplicatedStorage_Tracers = game:GetService("ReplicatedStorage")
local BulletDebris = game:GetService("Debris")
local BulletTweenService = game:GetService("TweenService")
local TaserFadeTween = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local SniperFadeTween = TweenInfo.new(2.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

pcall(function()
    local sharedModules = ReplicatedStorage_Tracers:WaitForChild("SharedModules", 5)
    if not sharedModules then return end
    local GunTracersModule = sharedModules:WaitForChild("GunTracers", 5)
    if not GunTracersModule then return end
    local GunTracers = require(GunTracersModule)

    function GunTracers.createTaser(p8, p9)
        local dist = (p8 - p9).magnitude
        local mid = (p8 + p9) / 2
        local part = Instance.new("Part")
        part.Name = "RayPart"
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.Transparency = 0.5
        part.formFactor = Enum.FormFactor.Custom
        part.Size = Vector3.new(0.2, 0.2, dist)
        part.CFrame = CFrame.new(mid, p9)
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        if CustomBulletColorEnabled then part.Color = CustomBulletColor
        else part.BrickColor = BrickColor.new("Cyan") end
        BulletDebris:AddItem(part, 2)
        local light = Instance.new("SurfaceLight", part)
        light.Color = CustomBulletColorEnabled and CustomBulletColor or Color3.fromRGB(0, 234, 255)
        light.Range = 7
        light.Face = "Bottom"
        light.Brightness = 5
        light.Angle = 180
        BulletTweenService:Create(part, TaserFadeTween, { Transparency = 1 }):Play()
        BulletTweenService:Create(light, TaserFadeTween, { Brightness = 0 }):Play()
        part.Parent = workspace.CurrentCamera
    end

    function GunTracers.createSniper(p16, p17)
        local dist = (p16 - p17).magnitude
        local mid = (p16 + p17) / 2
        local part = Instance.new("Part")
        part.Name = "RayPart"
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.Transparency = 0.5
        part.formFactor = Enum.FormFactor.Custom
        part.Size = Vector3.new(0.17, 0.17, dist)
        part.CFrame = CFrame.new(mid, p17)
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        if CustomBulletColorEnabled then part.Color = CustomBulletColor
        else part.BrickColor = BrickColor.new("Medium stone grey") end
        BulletDebris:AddItem(part, 4)
        BulletTweenService:Create(part, SniperFadeTween, { Transparency = 1 }):Play()
        part.Parent = workspace.CurrentCamera
    end

    function GunTracers.createBullet(p21, p22)
        local dist = (p21 - p22).magnitude
        local mid = (p21 + p22) / 2
        local part = Instance.new("Part")
        part.Name = "RayPart"
        part.Material = Enum.Material.Neon
        part.Anchored = true
        part.Transparency = 0.5
        part.formFactor = Enum.FormFactor.Custom
        part.Size = Vector3.new(0.1, 0.1, dist)
        part.CFrame = CFrame.new(mid, p22)
        part.CanCollide = false
        part.CanQuery = false
        part.CanTouch = false
        if CustomBulletColorEnabled then part.Color = CustomBulletColor
        else part.BrickColor = BrickColor.Yellow() end
        BulletDebris:AddItem(part, 0.05)
        part.Parent = workspace.CurrentCamera
    end
end)

local ToolPropertiesFolder = nil
pcall(function()
    ToolPropertiesFolder = game:GetService("ReplicatedStorage"):WaitForChild("SharedModules", 5):WaitForChild("ToolProperties", 5)
end)

local gunModNames = {"AK-47", "Remington 870", "M9", "M700", "M4A1", "FAL", "MP5", "Revolver"}

local function applyGunMod(tool)
    if not tool or not tool:IsA("Tool") then return end
    if not table.find(gunModNames, tool.Name) then return end
    if not Settings.GunModEnabled then return end
    tool:SetAttribute("AutoFire", Settings.AutoFire == true)
    if Settings.FastFirerateEnabled then
        local rate = Settings.FireRateValue or 0.01
        tool:SetAttribute("FireRate", rate)
        if ToolPropertiesFolder then
            pcall(function()
                local moduleScript = ToolPropertiesFolder:FindFirstChild(tool.Name)
                if moduleScript then
                    local props = require(moduleScript)
                    props.FireRate = rate
                    props.AutoFire = Settings.AutoFire == true
                end
            end)
        end
    end
end

local function applyGunModToAllTools()
    local char = player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do applyGunMod(tool) end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do applyGunMod(tool) end
    end
end

local function hookGunModContainer(container)
    if not container then return end
    container.ChildAdded:Connect(function(child) task.wait(0.05) applyGunMod(child) end)
end

hookGunModContainer(player:FindFirstChild("Backpack"))
if player.Character then hookGunModContainer(player.Character) end

player.CharacterAdded:Connect(function(char)
    hookGunModContainer(char)
    task.wait(0.3)
    applyGunModToAllTools()
end)

getgenv().SetGunModEnabled = function(v) Settings.GunModEnabled = v == true applyGunModToAllTools() end
getgenv().SetGunModAutoFire = function(v) Settings.AutoFire = v == true applyGunModToAllTools() end
getgenv().SetGunModFastFirerate = function(v) Settings.FastFirerateEnabled = v == true applyGunModToAllTools() end
getgenv().SetGunModFireRate = function(v) Settings.FireRateValue = v if Settings.FastFirerateEnabled then applyGunModToAllTools() end end

local FuncReloadRemote = nil
pcall(function()
    local gunRemotes = ReplicatedStorage:WaitForChild("GunRemotes", 5)
    if gunRemotes then FuncReloadRemote = gunRemotes:WaitForChild("FuncReload", 5) end
end)

local autoReloadInProgress = {}

local function performAutoReload(weapon)
    if not weapon or not FuncReloadRemote then return end
    if autoReloadInProgress[weapon] then return end
    local currentReloadSession = weapon:GetAttribute("Local_ReloadSession") or 0
    if currentReloadSession ~= 0 then return end
    local behavior = weapon:GetAttribute("Behavior")
    local storedAmmo = weapon:GetAttribute("StoredAmmo")
    if behavior == "Sniper" and storedAmmo and storedAmmo <= 0 then return end
    autoReloadInProgress[weapon] = true
    local reloadTime = weapon:GetAttribute("ReloadTime") or 1
    local session = tick()
    weapon:SetAttribute("Local_ReloadSession", session)
    task.spawn(function() FuncReloadRemote:InvokeServer() end)
    task.delay(reloadTime, function()
        if weapon:GetAttribute("Local_ReloadSession") == session then
            if behavior == "Sniper" then
                local currentAmmo = weapon:GetAttribute("Local_CurrentAmmo") or 0
                local maxAmmo = weapon:GetAttribute("MaxAmmo") or 1
                if currentAmmo < maxAmmo then
                    weapon:SetAttribute("Local_CurrentAmmo", 1)
                    updateAmmoLabel(weapon, 1)
                end
            else
                local maxAmmo = weapon:GetAttribute("MaxAmmo") or 0
                weapon:SetAttribute("Local_CurrentAmmo", maxAmmo)
                updateAmmoLabel(weapon, maxAmmo)
            end
            weapon:SetAttribute("Local_ReloadSession", 0)
        end
        autoReloadInProgress[weapon] = nil
    end)
end

RunService.Heartbeat:Connect(function()
    if not Settings.AutoReloadEnabled then return end
    local weapon = getEquippedWeapon()
    if not weapon then return end
    if not table.find(gunModNames, weapon.Name) then return end
    local currentAmmo = weapon:GetAttribute("Local_CurrentAmmo") or 0
    local reloadSession = weapon:GetAttribute("Local_ReloadSession") or 0
    if currentAmmo > 0 or reloadSession ~= 0 then return end
    performAutoReload(weapon)
end)

getgenv().SetAutoReloadEnabled = function(v) Settings.AutoReloadEnabled = v == true end

local SkinSettings = {
    Enabled = false, Color = Color3.fromRGB(255, 255, 255), Transparency = 0,
    Material = Enum.Material.SmoothPlastic, TextureEnabled = false, TextureId = "",
}

local originalPartProps = {}
local skinToolNames = {"AK-47", "Remington 870", "M9", "M700", "M4A1", "FAL", "MP5", "Revolver"}
local excludedPartNames = {"Handle", "Muzzle"}

local materialMap = {
    ForceField = Enum.Material.ForceField,
    SmoothPlastic = Enum.Material.SmoothPlastic,
    DiamondPlate = Enum.Material.DiamondPlate,
    Metal = Enum.Material.Metal,
    Marble = Enum.Material.Marble,
    Neon = Enum.Material.Neon,
}

local TextureMap = {
    Matrix = "rbxassetid://108962544192848",
    ["Blue Void"] = "rbxassetid://127882926538331",
    ["Classic blue White"] = "rbxassetid://80810460581216",
    ["Green and Black"] = "rbxassetid://124882447520456",
    White = "rbxassetid://121082905685777",
    ["Blue sky's with White Guns"] = "rbxassetid://84745365197133",
    ["Water Skin"] = "rbxassetid://119639132290940",
    Aurora = "rbxassetid://124100490232201",
    ["Epic White"] = "rbxassetid://100880863815885",
    ["Pink White"] = "rbxassetid://95856803518597",
    ["Blue Stars"] = "rbxassetid://118405531972534",
}

local function storeOriginalProps(tool)
    for _, part in ipairs(tool:GetDescendants()) do
        if part:IsA("BasePart") and not table.find(excludedPartNames, part.Name) and not originalPartProps[part] then
            originalPartProps[part] = {
                Color = part.Color, Material = part.Material,
                Transparency = part.Transparency,
                TextureID = part:IsA("MeshPart") and part.TextureID or nil,
            }
        end
    end
end

local function applyWeaponSkin(tool)
    if not tool or not tool:IsA("Tool") then return end
    if not table.find(skinToolNames, tool.Name) then return end
    storeOriginalProps(tool)
    for _, part in ipairs(tool:GetDescendants()) do
        if part:IsA("BasePart") and not table.find(excludedPartNames, part.Name) then
            if SkinSettings.Enabled then
                part.Color = SkinSettings.Color
                part.Material = SkinSettings.Material
                part.Transparency = SkinSettings.Transparency
            else
                local orig = originalPartProps[part]
                if orig then
                    part.Color = orig.Color
                    part.Material = orig.Material
                    part.Transparency = orig.Transparency
                end
            end
            if part:IsA("MeshPart") then
                if SkinSettings.TextureEnabled and SkinSettings.TextureId ~= "" then
                    part.TextureID = SkinSettings.TextureId
                else
                    local orig = originalPartProps[part]
                    if orig and orig.TextureID then part.TextureID = orig.TextureID end
                end
            end
        end
    end
end

local function applyWeaponSkinToAllTools()
    local char = player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do applyWeaponSkin(tool) end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do applyWeaponSkin(tool) end
    end
end

local function hookSkinContainer(container)
    if not container then return end
    container.ChildAdded:Connect(function(child) task.wait(0.05) applyWeaponSkin(child) end)
end

hookSkinContainer(player:FindFirstChild("Backpack"))
if player.Character then hookSkinContainer(player.Character) end

player.CharacterAdded:Connect(function(char)
    hookSkinContainer(char)
    task.wait(0.3)
    applyWeaponSkinToAllTools()
end)

getgenv().SetWeaponColorEnabled = function(v) SkinSettings.Enabled = v == true applyWeaponSkinToAllTools() end
getgenv().SetWeaponColorRGB = function(v) SkinSettings.Color = v if SkinSettings.Enabled then applyWeaponSkinToAllTools() end end
getgenv().SetWeaponTransparency = function(v) SkinSettings.Transparency = v if SkinSettings.Enabled then applyWeaponSkinToAllTools() end end
getgenv().SetWeaponMaterial = function(v) SkinSettings.Material = materialMap[v] or Enum.Material.SmoothPlastic if SkinSettings.Enabled then applyWeaponSkinToAllTools() end end
getgenv().SetWeaponTextureEnabled = function(v) SkinSettings.TextureEnabled = v == true applyWeaponSkinToAllTools() end
getgenv().SetWeaponTexture = function(v) SkinSettings.TextureId = TextureMap[v] or "" if SkinSettings.TextureEnabled then applyWeaponSkinToAllTools() end end

local TweenService = game:GetService("TweenService")

local KillEffectGui = Instance.new("ScreenGui")
KillEffectGui.Name = "KillEffectGui"
KillEffectGui.ResetOnSpawn = false
KillEffectGui.IgnoreGuiInset = true
KillEffectGui.DisplayOrder = 999
KillEffectGui.Parent = player:WaitForChild("PlayerGui")

local KillEffectFrame = Instance.new("Frame")
KillEffectFrame.Name = "KillEffectFrame"
KillEffectFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KillEffectFrame.Position = UDim2.fromScale(0.5, 0.5)
KillEffectFrame.Size = UDim2.fromScale(1, 1)
KillEffectFrame.BackgroundColor3 = Settings.KillEffectColor
KillEffectFrame.BackgroundTransparency = 1
KillEffectFrame.BorderSizePixel = 0
KillEffectFrame.ZIndex = 999
KillEffectFrame.Parent = KillEffectGui

local killEffectSizeConnection
local function autoSizeKillEffectFrame()
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if viewport then KillEffectFrame.Size = UDim2.fromOffset(viewport.X, viewport.Y) end
end
autoSizeKillEffectFrame()

if workspace.CurrentCamera then
    killEffectSizeConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(autoSizeKillEffectFrame)
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if killEffectSizeConnection then killEffectSizeConnection:Disconnect() end
    if workspace.CurrentCamera then
        killEffectSizeConnection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(autoSizeKillEffectFrame)
        autoSizeKillEffectFrame()
    end
end)

local killEffectPlaying = false

function playKillEffect()
    if not Settings.KillEffectEnabled then return end
    if killEffectPlaying then return end
    killEffectPlaying = true
    KillEffectFrame.BackgroundColor3 = Settings.KillEffectColor
    KillEffectFrame.BackgroundTransparency = 1
    local fadeDuration = Settings.KillEffectFadeDuration or 0.25
    local fadeIn = TweenService:Create(KillEffectFrame, TweenInfo.new(fadeDuration / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { BackgroundTransparency = 0.4 })
    local fadeOut = TweenService:Create(KillEffectFrame, TweenInfo.new(fadeDuration / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
    fadeIn:Play()
    fadeIn.Completed:Wait()
    fadeOut:Play()
    fadeOut.Completed:Wait()
    killEffectPlaying = false
end

getgenv().SetKillEffectEnabled = function(v) Settings.KillEffectEnabled = v == true end
getgenv().SetKillEffectColor = function(v) Settings.KillEffectColor = v end
getgenv().SetKillEffectFadeDuration = function(duration) Settings.KillEffectFadeDuration = duration end
getgenv().SetKillLogsEnabled = function(v) Settings.KillLogsEnabled = v == true end
getgenv().SetHitLogsEnabled = function(v) Settings.HitLogsEnabled = v == true end

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function parseKillFeedEntry(entryName)
    local killerDisplay, killerUser, victimDisplay, weapon =
        entryName:match("^(.-)%s*%(@(.-)%)%s*killed%s+(.-)%s+with%s+(.+)$")
    return killerDisplay, killerUser, victimDisplay, weapon
end

local function onKillFeedEntry(entry)
    if not entry:IsA("IntValue") then return end
    local killerDisplay, killerUser, victimDisplay, weapon = parseKillFeedEntry(entry.Name)
    if not killerDisplay then return end
    if Settings.KillLogsEnabled and Library and Library.Notify then
        Library:Notify({ Title = "Kill Logs", Description = killerDisplay .. " killed " .. victimDisplay .. " with " .. weapon, Time = 4 })
    end
    if killerUser == player.Name then
        task.spawn(playKillEffect)
        if getgenv().playKillSound then getgenv().playKillSound() end
    end
end

local KillFeedFolder = ReplicatedStorage:WaitForChild("Killfeed", 10)
if KillFeedFolder then KillFeedFolder.ChildAdded:Connect(onKillFeedEntry) end

function applyESP(plr)
    if plr == player then return end
    local char = plr.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    local teamColor = Color3.fromRGB(255, 0, 0)
    if plr.TeamColor then teamColor = plr.TeamColor.Color
    elseif plr.Team and plr.Team.TeamColor then teamColor = plr.Team.TeamColor.Color end
    local highlight = char:FindFirstChild("ESPHighlight")
    if not highlight then
        highlight = Instance.new("Highlight", char)
        highlight.Name = "ESPHighlight"
    end
    highlight.FillColor = teamColor
    highlight.FillTransparency = 0.85
    highlight.OutlineColor = teamColor
    highlight.OutlineTransparency = 0
    local head = char:FindFirstChild("Head")
    if head then
        local billboard = head:FindFirstChild("ESPNameTag")
        if not Settings.ESPNamesEnabled then
            if billboard then billboard:Destroy() end
        elseif not billboard then
            billboard = Instance.new("BillboardGui", head)
            billboard.Name = "ESPNameTag"
            billboard.Size = UDim2.new(0, 200, 0, 30)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            local label = Instance.new("TextLabel", billboard)
            label.Name = "NameLabel"
            label.BackgroundTransparency = 1
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
            label.TextColor3 = Settings.ESPTextColor or Color3.fromRGB(255, 255, 255)
            label.Font = Enum.Font.GothamBold
            label.TextSize = Settings.ESPNameTextSize or 12
            label.TextStrokeTransparency = 0
            label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        end
    end
end

function removeESP(plr)
    if plr.Character then
        local highlight = plr.Character:FindFirstChild("ESPHighlight")
        if highlight then highlight:Destroy() end
        local head = plr.Character:FindFirstChild("Head")
        if head then
            local billboard = head:FindFirstChild("ESPNameTag")
            if billboard then billboard:Destroy() end
            local targetBillboard = head:FindFirstChild("ESPTargetNameTag")
            if targetBillboard then targetBillboard:Destroy() end
        end
    end
end

function updateESP()
    if not Settings.ESPEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then removeESP(plr) end
        end
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then applyESP(plr) end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if Settings.ESPEnabled then
            task.wait(0.5)
            applyESP(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
    removeTracerBeam(plr)
end)

local fovRainbowConnection = nil

function setFOVColorRGB(color)
    if fovRainbowConnection then fovRainbowConnection:Disconnect() fovRainbowConnection = nil end
    Settings.FOVColor = color
    if fovCircle and fovCircle:FindFirstChild("UIStroke") then fovCircle.UIStroke.Color = color end
end

function setFogColorRGB(color) Lighting.FogColor = color end
function setTracerColorRGB(color) Settings.TracerColor = color end
function setESPTargetColorRGB(color) Settings.ESPTargetColor = color end
function setESPTextColor(color) Settings.ESPTextColor = color end
function setESPTargetTextColor(color) Settings.ESPTargetTextColor = color end

local SoundPacks = {
    ["Silenced Shot"] = { ShootSound = 9341262362 },
    ["Bubble Shot"] = { ShootSound = 109244508089412 },
    ["Laser Shot"] = { ShootSound = 109075387966089 },
    ["Dart Gun"] = { ShootSound = 5924183835 },
    ["Energy Shot"] = { ShootSound = 113363294416214 },
    ["Neverlose"] = { ShootSound = 82938206376993 },
}

local CurrentSoundPack = nil
local soundToolNames = {"AK-47", "Remington 870", "M9", "M700", "M4A1", "FAL", "MP5", "Revolver"}

local function applySoundPackToTool(tool)
    if not tool or not tool:IsA("Tool") then return end
    if not table.find(soundToolNames, tool.Name) then return end
    local handle = tool:FindFirstChild("Handle")
    if not handle then return end
    local shootSound = handle:FindFirstChild("ShootSound")
    if not shootSound then return end
    if not CurrentSoundPack then return end
    local packData = SoundPacks[CurrentSoundPack]
    if not packData or not packData.ShootSound then return end
    shootSound.SoundId = "rbxassetid://" .. packData.ShootSound
end

local function applySoundPackToAllTools()
    local char = player.Character
    if char then
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then applySoundPackToTool(tool) end
        end
    end
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then applySoundPackToTool(tool) end
        end
    end
end

getgenv().SetWeaponSoundPack = function(packName)
    if typeof(packName) == "table" then return end
    if packName == "None" or not packName then CurrentSoundPack = nil
    else CurrentSoundPack = packName end
    applySoundPackToAllTools()
end

local function hookToolContainer(container)
    if not container then return end
    container.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            task.wait()
            applySoundPackToTool(child)
        end
    end)
end

hookToolContainer(player:FindFirstChild("Backpack"))
if player.Character then hookToolContainer(player.Character) end

player.CharacterAdded:Connect(function(char)
    hookToolContainer(char)
    task.wait(0.5)
    applySoundPackToAllTools()
end)

local HitSounds = {
    ["TF2 Hit"] = 137392628136734,
    ["Metal Bat Hit"] = 114303603199822,
    ["Neverlose"] = 82938206376993,
    ["Minecraft Hit 1"] = 135478009117226,
    ["Minecraft Hit 2"] = 4018616850,
    ["MLG Hit"] = 109817519733426,
    ["Fahhh Hit"] = 139259088251978,
    ["Xbox Live Notification"] = 117934611310434,
    ["Rust"] = 1255040462,
    ["Fatality"] = 6534947869,
    ["Skeet"] = 5633695679,
    ["Pick"] = 1347140027,
    ["Creepy Bell"] = 98025615996882,
}

local KillSounds = {
    ["Fahhh"] = 93458245768554,
    ["Epic Kill 1"] = 87039942244697,
    ["Epic Kill 2"] = 75248488088600,
    ["Laugh"] = 87825295777427,
    ["Cat Laughing Meme"] = 133312610824902,
    ["Goofy Laugh"] = 128132519337195,
    ["PVZ Laugh"] = 137716148492089,
    ["CoD Kaboom"] = 7358219350,
    ["You are a Idiot"] = 3200130016,
    ["Creepy Bell"] = 98025615996882,
    ["Vine Boom"] = 140367458608473,
    ["RDR2 Low Honor"] = 126973996863873,
    ["Get Out"] = 138093000712523,
    ["Diahrrea Sound"] = 130990339683290,
    ["Goku Prowler"] = 131169447699141,
    ["iPhone Ding"] = 120612883125769,
    ["Bark Fart"] = 124264573696620,
    ["Enrique"] = 129084748747846,
    ["Fatality 2"] = 97439296876895,
}

local CustomHitSoundEnabled = false
local CustomKillSoundEnabled = false
local CurrentHitSound = nil
local CurrentKillSound = nil

local HitSoundTemplate = Instance.new("Sound")
HitSoundTemplate.Name = "HitSoundTemplate"
HitSoundTemplate.Volume = 1

local KillSoundTemplate = Instance.new("Sound")
KillSoundTemplate.Name = "KillSoundTemplate"
KillSoundTemplate.Volume = 1

local SoundDebris = game:GetService("Debris")

getgenv().playHitSound = function()
    if not CustomHitSoundEnabled or not CurrentHitSound then return end
    local cloned = Instance.new("Sound")
    cloned.Name = "HitSoundClone"
    cloned.SoundId = "rbxassetid://" .. CurrentHitSound
    cloned.Volume = 1
    cloned.Parent = workspace.CurrentCamera
    cloned:Play()
    cloned.Ended:Connect(function() cloned:Destroy() end)
    SoundDebris:AddItem(cloned, 5)
end

getgenv().playKillSound = function()
    if not CustomKillSoundEnabled or not CurrentKillSound then return end
    KillSoundTemplate.SoundId = "rbxassetid://" .. CurrentKillSound
    local cloned = KillSoundTemplate:Clone()
    cloned.Parent = workspace.CurrentCamera
    cloned:Play()
    cloned.Ended:Connect(function() cloned:Destroy() end)
    SoundDebris:AddItem(cloned, 5)
end

getgenv().SetCustomHitSoundEnabled = function(v) CustomHitSoundEnabled = v == true end
getgenv().SetCustomKillSoundEnabled = function(v) CustomKillSoundEnabled = v == true end
getgenv().SetHitSound = function(name)
    if typeof(name) == "table" then return end
    CurrentHitSound = HitSounds[name]
end
getgenv().SetKillSound = function(name)
    if typeof(name) == "table" then return end
    CurrentKillSound = KillSounds[name]
end
task.wait(0.5)
setProgress(0.6, "Loading interface...")
task.wait(0.3)
-- PrimeHUB | Prison Life
-- UI Script bazat pe Obsidian Library
-- Modificat: fundal negru, scris alb, credite, Discord h5GBpE9at, iconiță

local repo = "https://raw.githubusercontent.com/majeskooooo/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ============ PRIMEHUB THEME (NEGRU / ALB) ============
Library.Scheme.AccentColor = Color3.fromRGB(255, 255, 255)
Library.Scheme.BackgroundColor = Color3.fromRGB(0, 0, 0)
Library.Scheme.MainColor = Color3.fromRGB(0, 0, 0)
Library.Scheme.OutlineColor = Color3.fromRGB(50, 50, 50)
Library.Scheme.DarkColor = Color3.fromRGB(0, 0, 0)
Library.Scheme.FontColor = Color3.fromRGB(255, 255, 255)

-- ============ WINDOW SETUP ============
local Window = Library:CreateWindow({
    Title = "PrimeHUB",
    Footer = "PrimeHUB | discord.gg/h5GBpE9at",
    FooterLeft = "v1.0.0",
    FooterRight = "By @avongg6 @og.gg.66",
    Icon = 74169651953690,
    NotifySide = "Right",
    ShowCustomCursor = true,
    Size = UDim2.fromOffset(700, 850),
    Center = true,
    Resizable = true,
    SidebarCompacted = true,
    ShowMobileButtons = false,
    CornerRadius = 10,
    Font = Enum.Font.Gotham,
})

-- ============ TABS ============
local Tabs = {
    Info = Window:AddTab("Info", "info", "Game info"),
    Aimbot = Window:AddTab("Main", "crosshair", "Core features"),
    Teleports = Window:AddTab("Weapons & Shop", "shopping-basket", "Teleports and Weapons"),
    Visuals = Window:AddTab("Visuals", "eye", "ESP and Visual Customization"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings", "Customize the UI behavior and appearance"),
}

Library:SetDPIScale(95)

-- ============ INFO TAB ============
local scriptStartTime = tick()

local function getGreeting()
    local hour = tonumber(os.date("%H"))
    if hour < 12 then
        return "Good Morning"
    elseif hour < 18 then
        return "Good Afternoon"
    else
        return "Good Evening"
    end
end

local function formatUptime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = math.floor(seconds % 60)
    return string.format("%dh %dm %ds", h, m, s)
end

local InfoTabLeft = Tabs.Info.Sides[1]
local InfoTabRight = Tabs.Info.Sides[2]
local InfoTabContainer = InfoTabLeft.Parent

local PROFILE_HEIGHT = 110
local PROFILE_GAP = 10

-- ============ PROFILE PANEL ============
local ProfileHolder = Instance.new("Frame")
ProfileHolder.Name = "ProfilePanel"
ProfileHolder.BackgroundColor3 = Library.Scheme.BackgroundColor
ProfileHolder.Position = UDim2.fromOffset(1, 2)
ProfileHolder.Size = UDim2.new(1, -2, 0, PROFILE_HEIGHT)
ProfileHolder.Parent = InfoTabContainer

Library:AddToRegistry(ProfileHolder, { BackgroundColor3 = "BackgroundColor" })

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, Library.CornerRadius)
ProfileCorner.Parent = ProfileHolder
table.insert(Library.Corners, ProfileCorner)

Library:AddOutline(ProfileHolder)

local ProfileFrame = Instance.new("Frame")
ProfileFrame.Name = "ProfileFrame"
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Size = UDim2.new(1, -16, 1, -16)
ProfileFrame.Position = UDim2.fromOffset(8, 8)
ProfileFrame.Parent = ProfileHolder

local HeadshotImage = Instance.new("ImageLabel")
HeadshotImage.Name = "Headshot"
HeadshotImage.BackgroundColor3 = Library:GetBetterColor(Library.Scheme.BackgroundColor, 8)
HeadshotImage.BackgroundTransparency = 0
HeadshotImage.Size = UDim2.fromOffset(80, 80)
HeadshotImage.Position = UDim2.fromOffset(0, 0)
HeadshotImage.Image = ""
HeadshotImage.Parent = ProfileFrame

Library:AddToRegistry(HeadshotImage, {
    BackgroundColor3 = function()
        return Library:GetBetterColor(Library.Scheme.BackgroundColor, 8)
    end,
})

local HeadshotCorner = Instance.new("UICorner")
HeadshotCorner.CornerRadius = UDim.new(0, 12)
HeadshotCorner.Parent = HeadshotImage

task.spawn(function()
    local ok, content = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    if ok and content then
        HeadshotImage.Image = content
    end
end)

local GreetingLabel = Instance.new("TextLabel")
GreetingLabel.Name = "GreetingLabel"
GreetingLabel.BackgroundTransparency = 1
GreetingLabel.Position = UDim2.fromOffset(92, 2)
GreetingLabel.Size = UDim2.new(1, -92, 0, 26)
GreetingLabel.Font = Enum.Font.GothamBold
GreetingLabel.TextSize = 18
GreetingLabel.TextXAlignment = Enum.TextXAlignment.Left
GreetingLabel.TextColor3 = Library.Scheme.FontColor
GreetingLabel.Text = getGreeting() .. ", " .. player.Name .. "!"
GreetingLabel.Parent = ProfileFrame

Library:AddToRegistry(GreetingLabel, { TextColor3 = "FontColor" })

local ExecutorName = "Unknown"
pcall(function()
    if identifyexecutor then
        ExecutorName = identifyexecutor()
    end
end)

local InfoDetailsLabel = Instance.new("TextLabel")
InfoDetailsLabel.Name = "InfoDetailsLabel"
InfoDetailsLabel.BackgroundTransparency = 1
InfoDetailsLabel.Position = UDim2.fromOffset(92, 30)
InfoDetailsLabel.Size = UDim2.new(1, -92, 0, 60)
InfoDetailsLabel.Font = Enum.Font.Gotham
InfoDetailsLabel.TextSize = 13
InfoDetailsLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoDetailsLabel.TextYAlignment = Enum.TextYAlignment.Top
InfoDetailsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoDetailsLabel.RichText = true
InfoDetailsLabel.Text = "• Executor: " .. ExecutorName .. "\n"
    .. "• Map: Prison Life\n"
    .. "• Time: " .. os.date("%I:%M %p")
InfoDetailsLabel.Parent = ProfileFrame

local function RepositionInfoSides()
    local Offset = PROFILE_HEIGHT + PROFILE_GAP
    InfoTabLeft.Position = UDim2.new(0, 0, 0, Offset)
    InfoTabLeft.Size = UDim2.new(0.5, -3, 1, -Offset)

    InfoTabRight.Position = UDim2.new(1, 0, 0, Offset)
    InfoTabRight.Size = UDim2.new(0.5, -3, 1, -Offset)
end
RepositionInfoSides()

function Tabs.Info:RefreshSides()
    RepositionInfoSides()
end

-- ============ UPDATES GROUP ============
local UpdatesBox = Tabs.Info:AddLeftGroupbox("Updates", "bell")

UpdatesBox:AddLabel("PrimeHUB v1.0.0", true)
UpdatesBox:AddLabel(
    "- Silent Aim\n" ..
    "- ESP & Tracer\n" ..
    "- Hitbox Expander\n" ..
    "- Gun Mod\n" ..
    "- Vehicle Mod\n" ..
    "- Teleports\n" ..
    "- And more...",
    true
)

UpdatesBox:AddDivider("Info")

UpdatesBox:AddButton({
    Text = "Discord Server",
    Func = function()
        pcall(function()
            setclipboard("discord.gg/h5GBpE9at")
            Library:Notify({
                Title = "Discord",
                Text = "Link copied: discord.gg/h5GBpE9at",
                Time = 3,
            })
        end)
    end,
})

-- ============ COMMUNITY & CREDITS FOOTER ============
local FooterBox = Tabs.Info:AddLeftGroupbox("Community & Credits", "message-circle")

FooterBox:AddLabel("PrimeHUB v1.0.0", true)
FooterBox:AddLabel("By | @avongg6 @og.gg.66", true)
FooterBox:AddLabel("Discord: discord.gg/h5GBpE9at", true)

FooterBox:AddDivider()

FooterBox:AddButton({
    Text = "📋 Copy Discord Link",
    Func = function()
        pcall(function()
            setclipboard("discord.gg/h5GBpE9at")
            Library:Notify({
                Title = "Discord Copied!",
                Text = "discord.gg/h5GBpE9at",
                Time = 3,
            })
        end)
    end,
})

FooterBox:AddButton({
    Text = "🚀 Join Discord (Copy Link)",
    Func = function()
        pcall(function()
            setclipboard("https://discord.gg/h5GBpE9at")
            Library:Notify({
                Title = "Link Copied",
                Text = "Open Discord and paste it!",
                Time = 3,
            })
        end)
    end,
})

-- ============ FEEDBACK SYSTEM GROUP ============
local FeedbackBox = Tabs.Info:AddRightGroupbox("Feedback System", "mail")
FeedbackBox:SetDescription("Send feedback to developer (Join the Discord Server for More Info)")

FeedbackBox:AddLabel("Your feedback")

FeedbackBox:AddInput("FeedbackText", {
    Text = "",
    Placeholder = "Type your feedback here",
    ClearTextOnFocus = false,
    Finished = false,
})

do
    local feedbackHolder = Options.FeedbackText.Holder
    local feedbackBox = feedbackHolder:FindFirstChildOfClass("TextBox")
    if feedbackBox then
        feedbackBox.AnchorPoint = Vector2.new(0, 1)
        feedbackBox.Position = UDim2.fromScale(0, 1)
        feedbackBox.Size = UDim2.new(1, 0, 0, 76)
        feedbackBox.TextScaled = false
        feedbackBox.TextSize = 14
        feedbackBox.TextWrapped = true
        feedbackBox.MultiLine = true
        feedbackBox.TextXAlignment = Enum.TextXAlignment.Left
        feedbackBox.TextYAlignment = Enum.TextYAlignment.Top

        feedbackHolder.Size = UDim2.new(1, 0, 0, 90)
    end
end

FeedbackBox:AddButton({
    Text = "Send Feedback",
    Func = function()
        if getgenv().SendFeedback then
            getgenv().SendFeedback(Options.FeedbackText.Value)
        else
            Library:Notify({
                Title = "Feedback",
                Text = "Feedback system unavailable.",
                Time = 3,
            })
        end
    end,
})

-- ============ SERVER STATS GROUP ============
local ServerStatsBox = Tabs.Info:AddRightGroupbox("Server Stats", "info")

local regionCode = "Unknown"
pcall(function()
    regionCode = game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(player)
end)

local ServerStatsLabel = ServerStatsBox:AddLabel("Region: " .. regionCode .. "\nCountry: " .. regionCode .. "\nUptime: " .. formatUptime(tick() - scriptStartTime), true)

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            ServerStatsLabel:SetText("Region: " .. regionCode .. "\nCountry: " .. regionCode .. "\nUptime: " .. formatUptime(tick() - scriptStartTime))
        end)
    end
end)

-- ============ MOBILE BUTTON ============
if Library.IsMobile then
    local CustomToggleButton = Instance.new("ImageButton")
    CustomToggleButton.Name = "CustomToggleButton"
    CustomToggleButton.BackgroundColor3 = Library.Scheme.BackgroundColor
    CustomToggleButton.Image = "rbxassetid://74169651953690"
    CustomToggleButton.ScaleType = Enum.ScaleType.Fit
    CustomToggleButton.Size = UDim2.fromOffset(40, 40)
    CustomToggleButton.Position = UDim2.fromOffset(6, 6)
    CustomToggleButton.ZIndex = 10
    CustomToggleButton.Parent = Library.ScreenGui

    local ToggleButtonCorner = Instance.new("UICorner")
    ToggleButtonCorner.CornerRadius = UDim.new(0, Library.CornerRadius)
    ToggleButtonCorner.Parent = CustomToggleButton

    Library:AddOutline(CustomToggleButton)
    Library:MakeDraggable(CustomToggleButton, CustomToggleButton, true)

    if not table.find(Library.DraggableElements, CustomToggleButton) then
        table.insert(Library.DraggableElements, CustomToggleButton)
    end

    CustomToggleButton.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        local Start = tick()
        local Changed
        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            local IsLikelyDragging = tick() - Start > 0.35
            if not IsLikelyDragging then
                Library:Toggle()
            end

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)
end

-- ============ GET WEAPONS ============
local GetWeaponsBox = Tabs.Teleports:AddLeftGroupbox("Get Weapons", "sword")

GetWeaponsBox:AddDropdown("GetWeaponsList", {
    Values = {"MP5", "AK-47", "M4A1", "FAL", "Remington 870", "M700"},
    Multi = true,
    Text = "Select Weapons to Get",
    Tooltip = "Choose which weapons you want to receive",
    Callback = function(Value)
        local list = {}
        for name, selected in pairs(Value or {}) do
            if selected then
                table.insert(list, name)
            end
        end
        getgenv().SilentAimSettings.GetWeaponsList = list
    end,
})

GetWeaponsBox:AddButton({
    Text = "Get Weapons",
    Func = function()
        if getgenv().GetWeapons then
            getgenv().GetWeapons()
        end
    end,
})

GetWeaponsBox:AddDivider()

GetWeaponsBox:AddCheckbox("AutoGetWeapons", {
    Text = "Auto get Weapons",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.AutoGetWeapons = v
    end,
})

-- ============ PLAYERS TAB ============
local PlayerSettingsBox = Tabs.Teleports:AddLeftGroupbox("Misc", "sliders")

PlayerSettingsBox:AddCheckbox("Noclip", {
    Text = "Noclip",
    Tooltip = "Allows you to walk through walls and objects",
    Default = false,
    Callback = function(v)
        getgenv().SetNoclipEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("InfiniteJump", {
    Text = "Infinite Jump",
    Tooltip = "Allows you to jump infinitely in the air",
    Default = false,
    Callback = function(v)
        getgenv().SetInfiniteJumpEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("InfiniteStamina", {
    Text = "Infinite Stamina",
    Tooltip = "Disables the jump cooldown",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.InfiniteStamina = v
    end,
})

PlayerSettingsBox:AddCheckbox("Invisible", {
    Text = "Invisible",
    Default = false,
    Callback = function(v)
        getgenv().SetInvisibleEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("AntiInvisible", {
    Text = "Anti-Invisible",
    Default = false,
    Callback = function(v)
        getgenv().SetAntiInvisibleEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("Korblox", {
    Text = "Korblox",
    Default = false,
    Callback = function(v)
        getgenv().SetKorbloxEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("Headless", {
    Text = "Headless",
    Default = false,
    Callback = function(v)
        getgenv().SetHeadlessEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("AntiSit", {
    Text = "Anti Sit",
    Tooltip = "Prevents you from sitting on any seat, except the driver seat of a vehicle",
    Default = false,
    Callback = function(v)
        getgenv().SetAntiSitEnabled(v)
    end,
})

PlayerSettingsBox:AddCheckbox("CameraFOVEnabled", {
    Text = "Enable Camera FOV",
    Tooltip = "Enables custom camera FOV, otherwise uses the game's default",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.CameraFOVEnabled = v
    end,
})

PlayerSettingsBox:AddSlider("CameraFOV", {
    Text = "Camera FOV",
    Tooltip = "Changes camera FOV",
    Default = 70,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.CameraFOV = Value
        workspace.CurrentCamera.FieldOfView = Value
    end,
})

PlayerSettingsBox:AddSlider("SpinbotSpeed", {
    Text = "Spinbot",
    Tooltip = "Spins your character at the chosen speed.",
    Default = 0,
    Min = 0,
    Max = 250,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.SpinbotSpeed = Value
    end,
})

PlayerSettingsBox:AddDivider()

PlayerSettingsBox:AddButton({
    Text = "Activate Anti-Tase",
    Func = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remote = nil
        pcall(function()
            remote = ReplicatedStorage:WaitForChild("GunRemotes", 5):WaitForChild("PlayerTased", 5)
        end)

        task.spawn(function()
            while true do
                if remote then
                    local ok, connections = pcall(getconnections, remote.OnClientEvent)
                    if ok then
                        for _, conn in connections do
                            conn:Disable()
                        end
                    end
                end
                task.wait(0.5)
            end
        end)

        Library:Notify({ Title = "Anti-Tase", Text = "Anti-Tase enabled" })
    end,
})

-- ============ ENVIRONMENT GROUP ============
local EnvironmentBox = Tabs.Teleports:AddLeftGroupbox("Environment", "trees")

EnvironmentBox:AddLabel("World appearance settings", true)

local EnvironmentTabbox = EnvironmentBox:AddTabbox()
local EnvironmentNetworkTab = EnvironmentTabbox:AddTab(nil, "globe")
local EnvironmentCloudTab = EnvironmentTabbox:AddTab(nil, "cloud")

local WorldGradientEnabled = false
local DefaultAmbient = game:GetService("Lighting").Ambient
local DefaultOutdoorAmbient = game:GetService("Lighting").OutdoorAmbient
local CurrentGradientColor = Color3.fromRGB(255, 255, 255)
local CurrentOutdoorGradient = Color3.fromRGB(255, 255, 255)

EnvironmentNetworkTab:AddCheckbox("WorldGradient", {
    Text = "World Gradient",
    Tooltip = "Enables custom world gradient colors",
    Default = false,
    Callback = function(v)
        WorldGradientEnabled = v
        if v then
            game:GetService("Lighting").Ambient = CurrentGradientColor
            game:GetService("Lighting").OutdoorAmbient = CurrentOutdoorGradient
        else
            game:GetService("Lighting").Ambient = DefaultAmbient
            game:GetService("Lighting").OutdoorAmbient = DefaultOutdoorAmbient
        end
    end,
})

EnvironmentNetworkTab:AddLabel("Gradient Color"):AddColorPicker("GradientColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Gradient Color",
    Text = "Gradient Color",
    Tooltip = "Sets the world gradient color",
    Callback = function(Value)
        CurrentGradientColor = Value
        if WorldGradientEnabled then
            game:GetService("Lighting").Ambient = Value
        end
    end,
})

EnvironmentNetworkTab:AddLabel("Outdoor Gradient"):AddColorPicker("OutdoorGradient", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Outdoor Gradient",
    Text = "Outdoor Gradient",
    Tooltip = "Sets the outdoor gradient color",
    Callback = function(Value)
        CurrentOutdoorGradient = Value
        if WorldGradientEnabled then
            game:GetService("Lighting").OutdoorAmbient = Value
        end
    end,
})

EnvironmentNetworkTab:AddDivider()

EnvironmentNetworkTab:AddCheckbox("RemoveFog", {
    Text = "Remove Fog",
    Tooltip = "Removes the fog from the game",
    Default = false,
    Callback = function(v)
        if v then
            game:GetService("Lighting").FogEnd = 100000
            game:GetService("Lighting").FogStart = 100000
        else
            game:GetService("Lighting").FogEnd = 5000
            game:GetService("Lighting").FogStart = 500
        end
    end,
}):AddColorPicker("FogColor", {
    Default = Color3.fromRGB(100, 100, 100),
    Title = "Fog Color",
    Text = "Fog Color",
    Tooltip = "Choose the fog color",
    Callback = function(Value)
        setFogColorRGB(Value)
    end,
})

local CustomSkyboxEnabled = false
local CurrentSkybox = "None"

EnvironmentCloudTab:AddCheckbox("CustomSkybox", {
    Text = "Custom Skybox",
    Tooltip = "Enables applying a custom skybox",
    Default = false,
    Callback = function(v)
        CustomSkyboxEnabled = v
        if v then
            setSkybox(CurrentSkybox)
        else
            setSkybox("None")
        end
    end,
})

EnvironmentCloudTab:AddDropdown("Skyboxes", {
    Values = {"None", "Gray Skybox", "2knw & Donk666 Skybox", "Snow Skybox", "Cartoon Skybox", "Lince Skybox", "Red Skybox", "Slam Skybox", "Green Eyeball Skybox", "Morioh Skybox", "Rainy Skybox", "Rusk1ddski Skybox"},
    Default = "None",
    Text = "Skyboxes",
    Tooltip = "Choose your skybox",
    Callback = function(Value)
        CurrentSkybox = Value
        if CustomSkyboxEnabled then
            setSkybox(Value)
        end
    end,
})

local playerOptions = {"Select a player..."}
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        table.insert(playerOptions, plr.Name)
    end
end

local viewPlayerOptions = {"Select a player..."}
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        table.insert(viewPlayerOptions, plr.Name)
    end
end

local SPECTATE_PLAYER = nil
local spectateConnection = nil

local function stopSpectate()
    if spectateConnection then
        spectateConnection:Disconnect()
        spectateConnection = nil
    end
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            workspace.CurrentCamera.CameraSubject = humanoid
        end
    end
end

local function startSpectate(targetName)
    if spectateConnection then
        spectateConnection:Disconnect()
        spectateConnection = nil
    end

    local target = Players:FindFirstChild(targetName)
    if not target or not target.Character then return end

    local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    workspace.CurrentCamera.CameraSubject = humanoid
    spectateConnection = RunService.RenderStepped:Connect(function()
        if target and target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                workspace.CurrentCamera.CameraSubject = hum
            end
        end
    end)
end

-- ============ AIMBOT TAB ============
local AimbotLeftBox = Tabs.Aimbot:AddLeftGroupbox("Aim Settings", "crosshair")

AimbotLeftBox:AddCheckbox("SilentAim", {
    Text = "Silent Aim",
    Tooltip = "Silent Aim method by 7zz",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.Enabled = v
    end,
})

AimbotLeftBox:AddCheckbox("Autoshoot", {
    Text = "Autoshoot",
    Tooltip = "Automatically fires when Silent Aim has a locked target",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.Autoshoot = v
    end,
})

AimbotLeftBox:AddCheckbox("WallCheck", {
    Text = "Wall Check",
    Tooltip = "Ignore Players behind Walls",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.VisibleCheck = v
    end,
})

AimbotLeftBox:AddCheckbox("TeamCheck", {
    Text = "Team Check",
    Tooltip = "Ignore Players on your Team",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.TeamCheck = v
    end,
})

AimbotLeftBox:AddCheckbox("FriendCheck", {
    Text = "Friend Check",
    Tooltip = "Ignore your Friends",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.FriendCheck = v
    end,
})

AimbotLeftBox:AddCheckbox("ForceFieldCheck", {
    Text = "ForceField Check",
    Tooltip = "Ignore players who currently have a ForceField",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.ForceFieldCheck = v
    end,
})

local AutoshootWarningLabel = AimbotLeftBox:AddLabel("Note: Autoshot is not compatible with Hitchance", true)

do
    local warningInstance = AutoshootWarningLabel.Holder and AutoshootWarningLabel.Holder:FindFirstChildOfClass("TextLabel")
    if warningInstance then
        warningInstance.TextColor3 = Color3.fromRGB(255, 70, 70)
    end
end

AimbotLeftBox:AddDivider()

AimbotLeftBox:AddDropdown("TargetTeams", {
    Values = {"Inmates", "Guards", "Criminals"},
    Multi = true,
    Text = "Target Teams",
    Tooltip = "Selected teams are the ones Silent Aim will target (deselect a team to ignore it)",
    Callback = function(Value)
        getgenv().SilentAimSettings.TargetTeams = Value or {}
    end,
})

Options.TargetTeams:SetValue({ Inmates = true, Guards = true, Criminals = true })

local lastTargetModeSelection = { ["Manual"] = true }
local updateInProgress = false

AimbotLeftBox:AddDropdown("TargetMode", {
    Values = {"Manual", "🔗 Trespass", "💢 Hostile"},
    Multi = true,
    Default = { ["Manual"] = true },
    Text = "Target Mode",
    Tooltip = "Manual grabs any valid player. Trespass/Hostile restrict targeting to inmates flagged as such",
    Callback = function(Value)
        if updateInProgress then return end
        updateInProgress = true

        task.defer(function()
            Value = Value or {}

            local wasManual = lastTargetModeSelection["Manual"]
            local isManual = Value["Manual"]
            local isTrespass = Value["🔗 Trespass"]
            local isHostile = Value["💢 Hostile"]

            local manualJustSelected = isManual and not wasManual

            local finalValue = {}

            if manualJustSelected then
                finalValue = { ["Manual"] = true }
            elseif isTrespass or isHostile then
                if isTrespass then finalValue["🔗 Trespass"] = true end
                if isHostile then finalValue["💢 Hostile"] = true end
            else
                finalValue = { ["Manual"] = true }
            end

            lastTargetModeSelection = finalValue

            getgenv().SilentAimSettings.TrespassCheck = finalValue["🔗 Trespass"] == true
            getgenv().SilentAimSettings.HostileCheck = finalValue["💢 Hostile"] == true

            Options.TargetMode:SetValue(finalValue)
            updateInProgress = false
        end)
    end,
})

local targetOptions = {}
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= player then
        table.insert(targetOptions, plr.Name)
    end
end

AimbotLeftBox:AddDropdown("AimMode", {
    Values = {"FOV", "Distance"},
    Default = "FOV",
    Text = "Targeting Mode",
    Tooltip = "FOV: Locks on players within FOV radius | Distance: Locks on closest visible player",
    Callback = function(Value)
        getgenv().SilentAimSettings.AimMode = Value
    end,
})

AimbotLeftBox:AddDropdown("TargetPart", {
    Values = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg", "HumanoidRootPart", "Random"},
    Default = "HumanoidRootPart",
    Text = "Target Part",
    Tooltip = "Choose which body part the Silent Aim will lock onto. Random cycles part every 0.5s",
    Callback = function(Value)
        getgenv().SilentAimSettings.TargetPart = Value
    end,
})

-- ============ HITBOX EXPANDER ============
local HitboxExpanderBox = Tabs.Aimbot:AddLeftGroupbox("Hitbox Expander", "maximize-2")
HitboxExpanderBox:SetDescription("Enlarges player hitboxes")

HitboxExpanderBox:AddCheckbox("EnableHitboxExpander", {
    Text = "Enable Hitbox Expander",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.HitboxExpanderEnabled = v
    end,
})

HitboxExpanderBox:AddCheckbox("HitboxTeamCheck", {
    Text = "Team Check",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.HitboxTeamCheck = v
    end,
})

HitboxExpanderBox:AddSlider("HitboxSize", {
    Text = "Hitbox Size",
    Default = 1,
    Min = 1,
    Max = 15,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.HitboxSize = Value
    end,
})

HitboxExpanderBox:AddSlider("HitboxTransparency", {
    Text = "Hitbox Transparency",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.HitboxTransparency = Value
    end,
})

HitboxExpanderBox:AddDropdown("HitboxShape", {
    Values = {"Box", "Ball"},
    Default = "Box",
    Text = "Hitbox Shape",
    Callback = function(Value)
        getgenv().SilentAimSettings.HitboxShape = Value
    end,
})

-- ============ AIMBOT SLIDERS ============
local AimbotMidBox = Tabs.Aimbot:AddLeftGroupbox("Smoothing & Accuracy", "target")

AimbotMidBox:AddSlider("SilentAimRange", {
    Text = "Silent Aim Range",
    Default = 500,
    Min = 30,
    Max = 2000,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.SilentAimRange = Value
    end,
})

AimbotMidBox:AddSlider("Smoothing", {
    Text = "Smoothing",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.Smoothing = Value
    end,
})

AimbotMidBox:AddSlider("HitChance", {
    Text = "Hit Chance",
    Default = 100,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.HitChance = Value
    end,
})

-- ============ FOV SECTION ============
local FOVBox = Tabs.Aimbot:AddRightGroupbox("Settings", "settings")

local FOVIconTabbox = FOVBox:AddTabbox()
local FOVEyeTab = FOVIconTabbox:AddTab(nil, "scan-eye")
local FOVUsersTab = FOVIconTabbox:AddTab(nil, "users")

FOVEyeTab:AddCheckbox("HideFOV", {
    Text = "Show FOV Circle",
    Default = true,
    Callback = function(v)
        toggleFOVCircle(not v)
    end,
}):AddColorPicker("FOVColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "FOV Color",
    Text = "FOV Color",
    Tooltip = "Choose the FOV circle color",
    Callback = function(Value)
        setFOVColorRGB(Value)
    end,
})

FOVEyeTab:AddSlider("FOVSize", {
    Text = "FOV Circle Radius",
    Default = 100,
    Min = 30,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.FOVRadius = Value
    end,
})

FOVUsersTab:AddDropdown("TargetOn", {
    Values = targetOptions,
    Default = 1,
    Text = "Target On",
    Tooltip = "Select specific players to target",
    Multi = true,
    AllowNull = true,
    Callback = function(Value)
        local list = {}
        for name, selected in pairs(Value or {}) do
            if selected then
                table.insert(list, name)
            end
        end
        getgenv().SilentAimSettings.TargetOnPlayer = list
    end,
})

FOVUsersTab:AddButton({
    Text = "Reset Target",
    Func = function()
        getgenv().SilentAimSettings.TargetOnPlayer = {}
        local newOptions = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(newOptions, plr.Name)
            end
        end
        Options.TargetOn:SetValues(newOptions)
        Options.TargetOn:SetValue({})
    end,
})

FOVUsersTab:AddDropdown("IgnoreTarget", {
    Values = targetOptions,
    Default = 1,
    Text = "Ignore Target",
    Tooltip = "Select players to completely ignore",
    Multi = true,
    AllowNull = true,
    Callback = function(Value)
        local list = {}
        for name, selected in pairs(Value or {}) do
            if selected then
                table.insert(list, name)
            end
        end
        getgenv().SilentAimSettings.IgnoreTargets = list
    end,
})

FOVUsersTab:AddButton({
    Text = "Reset Ignore List",
    Func = function()
        getgenv().SilentAimSettings.IgnoreTargets = {}
        local newOptions = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(newOptions, plr.Name)
            end
        end
        Options.IgnoreTarget:SetValues(newOptions)
        Options.IgnoreTarget:SetValue({})
    end,
})

-- ============ FAST SWITCH BUTTON ============
local FastSwitchOnColor = Color3.fromRGB(150, 199, 150)

local FastSwitchButton = Instance.new("TextButton")
FastSwitchButton.Name = "FastSwitchButton"
FastSwitchButton.AutoButtonColor = false
FastSwitchButton.BackgroundColor3 = Library.Scheme.MainColor
FastSwitchButton.Position = UDim2.fromOffset(6, 52)
FastSwitchButton.Size = UDim2.fromOffset(130, 32)
FastSwitchButton.Text = "Fast Switch: OFF"
FastSwitchButton.TextColor3 = Library.Scheme.FontColor
FastSwitchButton.Font = Enum.Font.Gotham
FastSwitchButton.TextSize = 14
FastSwitchButton.ZIndex = 10
FastSwitchButton.Visible = false
FastSwitchButton.Parent = Library.ScreenGui

local FastSwitchButtonCorner = Instance.new("UICorner")
FastSwitchButtonCorner.CornerRadius = UDim.new(0, Library.CornerRadius)
FastSwitchButtonCorner.Parent = FastSwitchButton
table.insert(Library.Corners, FastSwitchButtonCorner)

Library:AddOutline(FastSwitchButton)
Library:MakeDraggable(FastSwitchButton, FastSwitchButton, true)

if not table.find(Library.DraggableElements, FastSwitchButton) then
    table.insert(Library.DraggableElements, FastSwitchButton)
end

local function updateFastSwitchButtonVisual()
    local enabled = getgenv().SilentAimSettings.GunSwitchEnabled
    FastSwitchButton.Text = enabled and "Fast Switch: ON" or "Fast Switch: OFF"

    if enabled then
        FastSwitchButton.BackgroundColor3 = FastSwitchOnColor
        Library:AddToRegistry(FastSwitchButton, { TextColor3 = "FontColor" })
    else
        FastSwitchButton.BackgroundColor3 = Library.Scheme.MainColor
        Library:AddToRegistry(FastSwitchButton, {
            BackgroundColor3 = "MainColor",
            TextColor3 = "FontColor",
        })
    end
end

local FastSwitchLockedPosition = nil
local FastSwitchPositionConnection = nil

local function setFastSwitchLocked(locked)
    if locked then
        FastSwitchLockedPosition = FastSwitchButton.Position
        if not FastSwitchPositionConnection then
            FastSwitchPositionConnection = FastSwitchButton:GetPropertyChangedSignal("Position"):Connect(function()
                if FastSwitchLockedPosition then
                    FastSwitchButton.Position = FastSwitchLockedPosition
                end
            end)
        end
    else
        if FastSwitchPositionConnection then
            FastSwitchPositionConnection:Disconnect()
            FastSwitchPositionConnection = nil
        end
        FastSwitchLockedPosition = nil
    end
end

local FASTSWITCH_CLICK_THRESHOLD = 0.35
local FastSwitchHoldMode = false

FastSwitchButton.InputBegan:Connect(function(Input)
    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    if FastSwitchHoldMode then
        getgenv().ToggleGunSwitch(true)
        updateFastSwitchButtonVisual()

        local Changed
        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End and Input.UserInputState ~= Enum.UserInputState.Cancel then
                return
            end

            getgenv().ToggleGunSwitch(false)
            updateFastSwitchButtonVisual()

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
        return
    end

    local Start = tick()
    local Changed
    Changed = Input.Changed:Connect(function()
        if Input.UserInputState ~= Enum.UserInputState.End then
            return
        end

        local IsLikelyDragging = tick() - Start > FASTSWITCH_CLICK_THRESHOLD
        if not IsLikelyDragging then
            local newState = not getgenv().SilentAimSettings.GunSwitchEnabled
            getgenv().ToggleGunSwitch(newState)
            updateFastSwitchButtonVisual()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
            Changed = nil
        end
    end)
end)

-- ============ VEHICLE FLY BUTTON ============
local VehicleFlyOnColor = Color3.fromRGB(150, 199, 150)

local VehicleFlyButton = Instance.new("TextButton")
VehicleFlyButton.Name = "VehicleFlyButton"
VehicleFlyButton.AutoButtonColor = false
VehicleFlyButton.BackgroundColor3 = Library.Scheme.MainColor
VehicleFlyButton.Position = UDim2.fromOffset(6, 90)
VehicleFlyButton.Size = UDim2.fromOffset(130, 32)
VehicleFlyButton.Text = "Vehicle Fly: OFF"
VehicleFlyButton.TextColor3 = Library.Scheme.FontColor
VehicleFlyButton.Font = Enum.Font.Gotham
VehicleFlyButton.TextSize = 14
VehicleFlyButton.ZIndex = 10
VehicleFlyButton.Visible = false
VehicleFlyButton.Parent = Library.ScreenGui

local VehicleFlyButtonCorner = Instance.new("UICorner")
VehicleFlyButtonCorner.CornerRadius = UDim.new(0, Library.CornerRadius)
VehicleFlyButtonCorner.Parent = VehicleFlyButton
table.insert(Library.Corners, VehicleFlyButtonCorner)

Library:AddOutline(VehicleFlyButton)
Library:MakeDraggable(VehicleFlyButton, VehicleFlyButton, true)

if not table.find(Library.DraggableElements, VehicleFlyButton) then
    table.insert(Library.DraggableElements, VehicleFlyButton)
end

local function updateVehicleFlyButtonVisual()
    local enabled = getgenv().SilentAimSettings.VehicleFlyEnabled
    VehicleFlyButton.Text = enabled and "Vehicle Fly: ON" or "Vehicle Fly: OFF"

    if enabled then
        VehicleFlyButton.BackgroundColor3 = VehicleFlyOnColor
        Library:AddToRegistry(VehicleFlyButton, { TextColor3 = "FontColor" })
    else
        VehicleFlyButton.BackgroundColor3 = Library.Scheme.MainColor
        Library:AddToRegistry(VehicleFlyButton, {
            BackgroundColor3 = "MainColor",
            TextColor3 = "FontColor",
        })
    end
end

local function toggleVehicleFly(newState)
    getgenv().SilentAimSettings.VehicleFlyEnabled = newState
    updateVehicleFlyButtonVisual()
end

local VEHICLEFLY_CLICK_THRESHOLD = 0.35

VehicleFlyButton.InputBegan:Connect(function(Input)
    if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local Start = tick()
    local Changed
    Changed = Input.Changed:Connect(function()
        if Input.UserInputState ~= Enum.UserInputState.End then
            return
        end

        local IsLikelyDragging = tick() - Start > VEHICLEFLY_CLICK_THRESHOLD
        if not IsLikelyDragging then
            toggleVehicleFly(not getgenv().SilentAimSettings.VehicleFlyEnabled)
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
            Changed = nil
        end
    end)
end)

updateVehicleFlyButtonVisual()

task.spawn(function()
    while true do
        task.wait(0.1)
        updateVehicleFlyButtonVisual()
    end
end)

local VehicleFlyLockedPosition = nil
local VehicleFlyPositionConnection = nil

local function setVehicleFlyLocked(locked)
    if locked then
        VehicleFlyLockedPosition = VehicleFlyButton.Position
        if not VehicleFlyPositionConnection then
            VehicleFlyPositionConnection = VehicleFlyButton:GetPropertyChangedSignal("Position"):Connect(function()
                if VehicleFlyLockedPosition then
                    VehicleFlyButton.Position = VehicleFlyLockedPosition
                end
            end)
        end
    else
        if VehicleFlyPositionConnection then
            VehicleFlyPositionConnection:Disconnect()
            VehicleFlyPositionConnection = nil
        end
        VehicleFlyLockedPosition = nil
    end
end

-- ============ GUN SWITCHER ============
local GunSwitcherBox = Tabs.Aimbot:AddRightGroupbox("Gun Switcher", "repeat")

GunSwitcherBox:AddDropdown("SelectGunsToSwitch", {
    Values = {"M9", "Revolver", "MP5", "AK-47", "M4A1", "FAL", "Remington 870", "M700"},
    Multi = true,
    Text = "Select Guns to Switch",
    Tooltip = "Choose which guns to cycle through",
    Callback = function(Value)
        local list = {}
        for name, selected in pairs(Value or {}) do
            if selected then
                table.insert(list, name)
            end
        end
        getgenv().SilentAimSettings.GunSwitchList = list
    end,
})

GunSwitcherBox:AddSlider("SwitchDelay", {
    Text = "Switch Delay",
    Default = 0.001,
    Min = 0.001,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        getgenv().SilentAimSettings.GunSwitchDelay = Value
    end,
})

GunSwitcherBox:AddDivider()

GunSwitcherBox:AddCheckbox("ShowGunSwitchButton", {
    Text = "Show Fast Switch Button",
    Default = false,
    Callback = function(v)
        FastSwitchButton.Visible = v
    end,
})

GunSwitcherBox:AddCheckbox("LockFastSwitchButton", {
    Text = "Lock Fast Switch Button",
    Default = false,
    Callback = function(v)
        setFastSwitchLocked(v)
    end,
})

GunSwitcherBox:AddCheckbox("HoldFastSwitchButton", {
    Text = "Hold Fast Switch Button to Enable",
    Default = false,
    Callback = function(v)
        FastSwitchHoldMode = v

        if getgenv().SilentAimSettings.GunSwitchEnabled then
            getgenv().ToggleGunSwitch(false)
            updateFastSwitchButtonVisual()
        end
    end,
})

GunSwitcherBox:AddCheckbox("CycleAllWeapons", {
    Text = "Cycle All Weapons",
    Tooltip = "Automatically includes every weapon you own in Fast Switch, ignoring the dropdown selection above",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.GunSwitchCycleAll = v
    end,
})

GunSwitcherBox:AddLabel("Fast Switch Keybind"):AddKeyPicker("FastSwitchKeybind", {
    Default = "None",
    NoUI = false,
    Text = "Fast Switch Keybind",
    Callback = function()
        local newState = not getgenv().SilentAimSettings.GunSwitchEnabled
        getgenv().ToggleGunSwitch(newState)
        updateFastSwitchButtonVisual()
    end,
})

task.spawn(function()
    while true do
        task.wait(0.1)
        local keyValue = Options.FastSwitchKeybind.Value
        getgenv().SilentAimSettings.FastSwitchKeyCode = keyValue
    end
end)

-- ============ WEAPON MODIFICATIONS ============
local WeaponModBox = Tabs.Aimbot:AddRightGroupbox("Weapon Mod", "sword")
local WeaponModsTabbox = WeaponModBox:AddTabbox()

local GunModTab = WeaponModsTabbox:AddTab(nil, "wrench")

GunModTab:AddCheckbox("WeaponMod", {
    Text = "Weapon Mod",
    Default = false,
    Callback = function(v)
        getgenv().SetGunModEnabled(v)
    end,
})

GunModTab:AddDivider()

GunModTab:AddCheckbox("AutoFire", {
    Text = "Auto Fire",
    Default = false,
    Callback = function(v)
        getgenv().SetGunModAutoFire(v)
    end,
})

GunModTab:AddCheckbox("FastFirerate", {
    Text = "Fast Firerate",
    Default = false,
    Callback = function(v)
        getgenv().SetGunModFastFirerate(v)
    end,
})

GunModTab:AddCheckbox("AutoReload", {
    Text = "Auto Reload",
    Tooltip = "Automatically reloads the weapon when ammo reaches 0",
    Default = false,
    Callback = function(v)
        getgenv().SetAutoReloadEnabled(v)
    end,
})

GunModTab:AddDivider("Custom Values")

GunModTab:AddSlider("FireRateValue", {
    Text = "Fire Rate",
    Default = 0.001,
    Min = 0.001,
    Max = 0.1,
    Rounding = 2,
    Callback = function(Value)
        getgenv().SetGunModFireRate(Value)
    end,
})

local ChainTab = WeaponModsTabbox:AddTab(nil, "cable")

ChainTab:AddCheckbox("CustomBulletColor", {
    Text = "Custom Bullet Color",
    Tooltip = "Applies a custom color to all bullets, current and future weapons",
    Default = false,
    Callback = function(v)
        setCustomBulletColorEnabled(v)
    end,
})

ChainTab:AddDivider()

ChainTab:AddLabel("Bullet Color"):AddColorPicker("BulletColor", {
    Default = Color3.fromRGB(255, 255, 0),
    Title = "Bullet Color",
    Text = "Bullet Color",
    Tooltip = "Sets the color of all bullets when enabled",
    Callback = function(Value)
        setBulletColorRGB(Value)
    end,
})

local PaintTab = WeaponModsTabbox:AddTab(nil, "paintbrush")
PaintTab:AddCheckbox("EnableWeaponColor", {
    Text = "Enable Weapon Color",
    Default = false,
    Callback = function(v)
        getgenv().SetWeaponColorEnabled(v)
    end,
}):AddColorPicker("WeaponColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Weapon Color",
    Text = "Weapon Color",
    Tooltip = "Sets the color of your weapon",
    Callback = function(Value)
        getgenv().SetWeaponColorRGB(Value)
    end,
})

PaintTab:AddCheckbox("EnableWeaponTexture", {
    Text = "Enable Weapon Texture",
    Default = false,
    Callback = function(v)
        getgenv().SetWeaponTextureEnabled(v)
    end,
})

PaintTab:AddDivider()

PaintTab:AddSlider("WeaponTransparency", {
    Text = "Weapon Transparency",
    Default = 0,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SetWeaponTransparency(Value)
    end,
})

PaintTab:AddDropdown("WeaponMaterial", {
    Values = {"ForceField", "SmoothPlastic", "DiamondPlate", "Metal", "Marble", "Neon"},
    Default = "SmoothPlastic",
    Text = "Weapon Material",
    Tooltip = "Sets the material of your weapon",
    Callback = function(Value)
        getgenv().SetWeaponMaterial(Value)
    end,
})

PaintTab:AddDropdown("WeaponTexture", {
    Values = {
        "Matrix",
        "Blue Void",
        "Classic blue White",
        "Green and Black",
        "White",
        "Blue sky's with White Guns",
        "Water Skin",
        "Aurora",
        "Epic White",
        "Pink White",
        "Blue Stars",
    },
    Default = "Matrix",
    Text = "Weapon Texture",
    Tooltip = "Sets the texture of your weapon",
    Callback = function(Value)
        getgenv().SetWeaponTexture(Value)
    end,
})

PaintTab:AddLabel("Credits to OnlyAdrian", true)


local SoundTab = WeaponModsTabbox:AddTab(nil, "volume-2")
local NotifyTab = WeaponModsTabbox:AddTab(nil, "bell")

SoundTab:AddDropdown("WeaponSoundPack", {
    Values = {"None", "Silenced Shot", "Bubble Shot", "Laser Shot", "Dart Gun", "Energy Shot", "Neverlose"},
    Default = "None",
    Text = "Custom Shot Sound",
    Tooltip = "Applies a custom shoot sound to all supported weapons",
    Callback = function(Value)
        getgenv().SetWeaponSoundPack(Value)
    end,
})

SoundTab:AddDivider()

SoundTab:AddCheckbox("CustomKillSound", {
    Text = "Custom Kill Sound",
    Default = false,
    Callback = function(v)
        getgenv().SetCustomKillSoundEnabled(v)
    end,
})

SoundTab:AddCheckbox("CustomHitSound", {
    Text = "Custom Hit Sound",
    Default = false,
    Callback = function(v)
        getgenv().SetCustomHitSoundEnabled(v)
    end,
})

SoundTab:AddDivider()

SoundTab:AddDropdown("KillSound", {
    Values = {
        "Fahhh",
        "Epic Kill 1",
        "Epic Kill 2",
        "Laugh",
        "Cat Laughing Meme",
        "Goofy Laugh",
        "PVZ Laugh",
        "CoD Kaboom",
        "You are a Idiot",
        "Creepy Bell",
        "Vine Boom",
        "RDR2 Low Honor",
        "Get Out",
        "Diahrrea Sound",
        "Goku Prowler",
        "iPhone Ding",
        "Bark Fart",
        "Enrique",
        "Fatality 2",
    },
    Default = 1,
    Text = "Kill Sound",
    Tooltip = "Select a custom kill sound",
    Callback = function(Value)
        getgenv().SetKillSound(Value)
    end,
})

SoundTab:AddDropdown("HitSound", {
    Values = {
        "TF2 Hit",
        "Metal Bat Hit",
        "Neverlose",
        "Minecraft Hit 1",
        "Minecraft Hit 2",
        "MLG Hit",
        "Fahhh Hit",
        "Xbox Live Notification",
        "Rust",
        "Fatality",
        "Skeet",
        "Pick",
        "Creepy Bell",
    },
    Default = 1,
    Text = "Hit Sound",
    Tooltip = "Select a custom hit sound",
    Callback = function(Value)
        getgenv().SetHitSound(Value)
    end,
})

NotifyTab:AddLabel("Effects")

NotifyTab:AddCheckbox("ColorScreenKillEffect", {
    Text = "Color Screen Kill Effect",
    Default = false,
    Callback = function(v)
        getgenv().SetKillEffectEnabled(v)
    end,
}):AddColorPicker("ColorScreenKillEffectColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Kill Effect Color",
    Text = "Kill Effect Color",
    Tooltip = "Sets the color of the screen flash on kill",
    Callback = function(Value)
        getgenv().SetKillEffectColor(Value)
    end,
})

NotifyTab:AddSlider("ColorEffectFadeDuration", {
    Text = "Color Effect Fade Duration",
    Default = 0.25,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        getgenv().SetKillEffectFadeDuration(Value)
    end,
})

NotifyTab:AddDivider("Logs")

NotifyTab:AddCheckbox("KillLogs", {
    Text = "Kill Logs",
    Default = false,
    Callback = function(v)
        getgenv().SetKillLogsEnabled(v)
    end,
})

NotifyTab:AddCheckbox("HitLogs", {
    Text = "Hit Logs",
    Default = false,
    Callback = function(v)
        getgenv().SetHitLogsEnabled(v)
    end,
})

-- ============ VISUALS TAB ============
local VisualsLeftBox = Tabs.Visuals:AddLeftGroupbox("Highlight ESP", "eye")

VisualsLeftBox:AddCheckbox("ESP", {
    Text = "Highlight ESP",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.ESPEnabled = v
        updateESP()
    end,
})

VisualsLeftBox:AddLabel("Target Highlight Color"):AddColorPicker("ESPTargetColor", {
    Default = Color3.fromRGB(255, 182, 255),
    Title = "ESP Target Color",
    Text = "Target Highlight Color",
    Tooltip = "Color of the highlight when a player is your target",
    Callback = function(Value)
        setESPTargetColorRGB(Value)
    end,
})

local NameESPBox = Tabs.Visuals:AddLeftGroupbox("Name ESP", "type-outline")

NameESPBox:AddCheckbox("EnableNameESP", {
    Text = "Enable Name ESP",
    Tooltip = "Shows the names above players when ESP is active",
    Default = true,
    Callback = function(v)
        getgenv().SilentAimSettings.ESPNamesEnabled = v
        updateESP()
    end,
})

NameESPBox:AddCheckbox("EnableTargetNameESP", {
    Text = "Enable Target ESP Name",
    Tooltip = "Shows a 'Target' label below the name of your current target",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.ESPTargetNameEnabled = v
    end,
})

NameESPBox:AddLabel("Text Color"):AddColorPicker("ESPTextColor", {
    Default = Color3.fromRGB(255, 255, 255),
    Title = "Text Color",
    Text = "Text Color",
    Tooltip = "Sets the color of the Name ESP text",
    Callback = function(Value)
        setESPTextColor(Value)
    end,
})

NameESPBox:AddLabel("Target Text Color"):AddColorPicker("ESPTargetTextColor", {
    Default = Color3.fromRGB(255, 182, 255),
    Title = "Target Text Color",
    Text = "Target Text Color",
    Tooltip = "Sets the color of the Target ESP Name text",
    Callback = function(Value)
        setESPTargetTextColor(Value)
    end,
})

NameESPBox:AddDivider()

NameESPBox:AddSlider("NameESPTextSize", {
    Text = "Name ESP Text Size",
    Default = 12,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.ESPNameTextSize = Value
    end,
})

NameESPBox:AddSlider("TargetNameESPTextSize", {
    Text = "Target Name ESP Text Size",
    Default = 12,
    Min = 0,
    Max = 24,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.ESPTargetNameTextSize = Value
    end,
})

NameESPBox:AddDivider()

NameESPBox:AddInput("TargetCustomText", {
    Text = "",
    Placeholder = "Target",
    ClearTextOnFocus = false,
    Finished = false,
})

do
    local holder = Options.TargetCustomText.Holder
    local box = holder and holder:FindFirstChildOfClass("TextBox")
    if box then
        box:GetPropertyChangedSignal("Text"):Connect(function()
            Options.TargetCustomText.Value = box.Text
        end)
    end
end

NameESPBox:AddButton({
    Text = "Reset",
    Func = function()
        Options.TargetCustomText:SetValue("")
        getgenv().SetTargetCustomText("Target")
    end,
})

NameESPBox:AddButton({
    Text = "Apply",
    Func = function()
        local text = Options.TargetCustomText.Value
        if not text or text == "" then
            text = "Target"
        end
        getgenv().SetTargetCustomText(text)
    end,
})

-- ============ TRACER ESP SECTION ============
local TracerBox = Tabs.Visuals:AddRightGroupbox("Tracer ESP", "zap")

TracerBox:AddCheckbox("TracerESP", {
    Text = "Tracer ESP",
    Tooltip = "Shows a beam to every visible player, colored by team",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.TracerESPEnabled = v
    end,
})

TracerBox:AddSlider("TracerThickness", {
    Text = "Tracer Thickness",
    Tooltip = "Thickness of the tracer line",
    Default = 0.2,
    Min = 0.1,
    Max = 1.5,
    Rounding = 1,
    Callback = function(Value)
        getgenv().SilentAimSettings.TracerThickness = Value
    end,
})

TracerBox:AddCheckbox("TracerTargetOnly", {
    Text = "Target Only",
    Tooltip = "Only shows the tracer on the player who is your current target",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.TracerTargetOnly = v
    end,
})

TracerBox:AddLabel("Target Tracer Color"):AddColorPicker("TracerColor", {
    Default = Color3.fromRGB(255, 182, 255),
    Title = "Target Tracer Color",
    Text = "Target Tracer Color",
    Tooltip = "Color of the tracer for your current target only (other players use their team color)",
    Callback = function(Value)
        setTracerColorRGB(Value)
    end,
})

-- ============ COLOR PICKER SCREEN CLAMP FIX ============
local function ClampColorPickerToScreen(OptionIdx)
    local CP = Options[OptionIdx]
    if not CP or not CP.ColorMenu then return end

    local ColorMenu = CP.ColorMenu
    local OriginalOpen = ColorMenu.Open

    ColorMenu.Open = function(self, ...)
        OriginalOpen(self, ...)

        task.defer(function()
            local Camera = workspace.CurrentCamera
            if not Camera then return end

            local ViewportSize = Camera.ViewportSize
            local MenuSize = self.Menu.AbsoluteSize
            local Margin = 8

            local CurrentPos = self.Menu.Position
            local X = CurrentPos.X.Offset
            local Y = CurrentPos.Y.Offset

            local MaxX = math.max(Margin, ViewportSize.X - MenuSize.X - Margin)
            local MaxY = math.max(Margin, ViewportSize.Y - MenuSize.Y - Margin)

            X = math.clamp(X, Margin, MaxX)
            Y = math.clamp(Y, Margin, MaxY)

            self.Menu.Position = UDim2.fromOffset(X, Y)
        end)
    end
end

ClampColorPickerToScreen("FOVColor")
ClampColorPickerToScreen("ESPTargetColor")
ClampColorPickerToScreen("FogColor")
ClampColorPickerToScreen("TracerColor")
ClampColorPickerToScreen("BulletColor")
ClampColorPickerToScreen("WeaponColor")
ClampColorPickerToScreen("ColorScreenKillEffectColor")
ClampColorPickerToScreen("ESPTextColor")
ClampColorPickerToScreen("ESPTargetTextColor")

-- ============ TELEPORTS TAB ============
local TeleportsBox = Tabs.Teleports:AddRightGroupbox("Teleports", "map-pin")
local TeleportsTabbox = TeleportsBox:AddTabbox()
local LocationsTab = TeleportsTabbox:AddTab(nil, "map-pin")
local TeleportPlayerTab = TeleportsTabbox:AddTab(nil, "users")

local teleports = {
    {"Cafeteria", Vector3.new(868, 100, 2263)},
    {"Yard", Vector3.new(714, 98, 2519)},
    {"Entrance", Vector3.new(663, 100, 2314)},
    {"Secret Room", Vector3.new(728, 100, 2316)},
    {"Inside the Prison", Vector3.new(864, 100, 2406)},
    {"Guardtower", Vector3.new(840, 122, 2593)},
    {"Guardtower 2", Vector3.new(840, 122, 2067)},
    {"Police Room", Vector3.new(850, 100, 2274)},
    {"Police Room 2", Vector3.new(793, 101, 2246)},
    {"Frontwall", Vector3.new(510, 122, 2328)},
    {"Armory", Vector3.new(804, 108, 2257)},
    {"Containers", Vector3.new(254, 73, 2359)},
    {"Sniper Building", Vector3.new(-354, 114, 1991)},
    {"Criminal Base", Vector3.new(-984, 96, 2079)},
}

for _, tp in ipairs(teleports) do
    LocationsTab:AddButton({
        Text = tp[1],
        Func = function()
            local c = player.Character
            if c and c:FindFirstChild("HumanoidRootPart") then
                c.HumanoidRootPart.CFrame = CFrame.new(tp[2])
            end
        end,
    })
end

TeleportPlayerTab:AddDivider("Teleport to Player")

TeleportPlayerTab:AddDropdown("TeleportPlayer", {
    Values = playerOptions,
    Default = 1,
    Text = "Teleport to Player",
    Tooltip = "Select a player to teleport to them",
    Callback = function(Value)
        if not Value or Value == "Select a player..." then return end
        local target = Players:FindFirstChild(Value)
        if target and target.Character then
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local c = player.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end,
})

TeleportPlayerTab:AddButton({
    Text = "Update Players List",
    Func = function()
        local options = {"Select a player..."}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(options, plr.Name)
            end
        end
        Options.TeleportPlayer:SetValues(options)
    end,
})

TeleportPlayerTab:AddDivider("View Player")

TeleportPlayerTab:AddDropdown("ViewPlayer", {
    Values = viewPlayerOptions,
    Default = 1,
    Text = "View Player",
    Tooltip = "Select a player to spectate",
    Callback = function(Value)
        if not Value or Value == "Select a player..." then
            SPECTATE_PLAYER = nil
            stopSpectate()
            return
        end
        SPECTATE_PLAYER = Value
        startSpectate(Value)
    end,
})

TeleportPlayerTab:AddButton({
    Text = "Update Players List",
    Func = function()
        local options = {"Select a player..."}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                table.insert(options, plr.Name)
            end
        end
        SPECTATE_PLAYER = nil
        stopSpectate()
        Options.ViewPlayer:SetValues(options)
    end,
})

-- ============ VEHICLE MOD ============
local VehicleModBox = Tabs.Teleports:AddRightGroupbox("Vehicle Mod", "car")
VehicleModBox:SetDescription("Vehicle Modifications")
local VehicleModsTabbox = VehicleModBox:AddTabbox()

local VehicleFlyTab = VehicleModsTabbox:AddTab(nil, "wind")
local VehicleSpeedTab = VehicleModsTabbox:AddTab(nil, "zap")
local VehicleCustomTab = VehicleModsTabbox:AddTab(nil, "car")

VehicleFlyTab:AddCheckbox("EnableVehicleFly", {
    Text = "Enable Vehicle Fly",
    Default = false,
    Callback = function(v)
        toggleVehicleFly(v)
    end,
})

VehicleFlyTab:AddCheckbox("ShowVehicleFlyButton", {
    Text = "Show Vehicle Fly Button",
    Default = false,
    Callback = function(v)
        VehicleFlyButton.Visible = v
    end,
})

VehicleFlyTab:AddCheckbox("LockVehicleFlyButton", {
    Text = "Lock Vehicle Fly Button",
    Default = false,
    Callback = function(v)
        setVehicleFlyLocked(v)
    end,
})

VehicleFlyTab:AddLabel("Vehicle Fly Keybind"):AddKeyPicker("VehicleFlyKeybind", {
    Default = "None",
    NoUI = false,
    Text = "Vehicle Fly Keybind",
    Callback = function()
        toggleVehicleFly(not getgenv().SilentAimSettings.VehicleFlyEnabled)
    end,
})

task.spawn(function()
    while true do
        task.wait(0.1)
        local keyValue = Options.VehicleFlyKeybind.Value
        getgenv().SilentAimSettings.VehicleFlyKeyCode = keyValue
    end
end)

VehicleFlyTab:AddDivider()

VehicleFlyTab:AddLabel("Sit in vehicle to Activate", true)

VehicleFlyTab:AddSlider("VehicleFlyHeight", {
    Text = "Height (Y)",
    Default = 0,
    Min = 0,
    Max = 65,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.VehicleFlyHeight = Value
    end,
})

VehicleFlyTab:AddButton({
    Text = "Flip Vehicle",
    Func = function()
        if getgenv().FlipVehicle then
            getgenv().FlipVehicle()
        end
    end,
})

VehicleSpeedTab:AddCheckbox("VehicleMaxSpeedChanger", {
    Text = "Vehicle Max speed Changer",
    Default = false,
    Callback = function(v)
        getgenv().SilentAimSettings.VehicleMaxSpeedEnabled = v
    end,
})

VehicleSpeedTab:AddDivider()

VehicleSpeedTab:AddSlider("VehicleMaxSpeed", {
    Text = "Vehicle Max Speed",
    Default = 70,
    Min = 70,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        getgenv().SilentAimSettings.VehicleMaxSpeed = Value
    end,
})

local CarListDropdown = VehicleCustomTab:AddDropdown("CarList", {
    Values = {},
    Default = nil,
    AllowNull = true,
    Text = "Car List",
    Tooltip = "Select a car",
    Callback = function(Value)
        getgenv().SilentAimSettings.SelectedCar = Value
    end,
})

VehicleCustomTab:AddButton({
    Text = "Refresh List",
    Func = function()
        if getgenv().RefreshCarList then
            local cars = getgenv().RefreshCarList()
            Options.CarList:SetValues(cars)
        end
    end,
})

VehicleCustomTab:AddButton({
    Text = "Bring Car",
    Func = function()
        if getgenv().BringCar and Options.CarList.Value then
            getgenv().BringCar(Options.CarList.Value)
        end
    end,
})

VehicleCustomTab:AddButton({
    Text = "Teleport to Car",
    Func = function()
        if getgenv().TeleportToCar and Options.CarList.Value then
            getgenv().TeleportToCar(Options.CarList.Value)
        end
    end,
})

local VehicleBannableWarningLabel = VehicleCustomTab:AddLabel("Bannable, use at your own risk", true)

do
    local warningInstance = VehicleBannableWarningLabel.Holder and VehicleBannableWarningLabel.Holder:FindFirstChildOfClass("TextLabel")
    if warningInstance then
        warningInstance.TextColor3 = Color3.fromRGB(235, 70, 70)
    end
end

-- ============ UI SETTINGS ============
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "settings")

MenuGroup:AddCheckbox("KeybindMenuOpen", {
    Text = "Open Keybind Menu",
    Default = Library.KeybindFrame.Visible,
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddCheckbox("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = Library.ShowCustomCursor,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddCheckbox("AlwaysOnTop", {
    Text = "Always On Top",
    Default = false,
    Callback = function(Value)
        Window:SetAlwaysOnTop(Value)
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = {"Left", "Right"},
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDivider()

MenuGroup:AddLabel("Menu Bind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift",
    NoUI = true,
    Text = "Menu keybind",
})

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

-- ============ ADDON SETUP ============
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

ThemeManager:SetFolder("PrimeHUB")
SaveManager:SetFolder("PrimeHUB/PrisonLife")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()

