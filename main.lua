-- PrimeHUB Loader
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local REPO = "https://raw.githubusercontent.com/filip-prog/fuzzy-octo-train/main/"

if CoreGui:FindFirstChild("PrimeHUB_Loading") then
    CoreGui.PrimeHUB_Loading:Destroy()
end

local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "PrimeHUB_Loading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 9999
loadingGui.Parent = CoreGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BorderSizePixel = 0
bg.Parent = loadingGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 60)
titleLabel.Position = UDim2.new(0, 0, 0.4, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "PrimeHUB"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 48
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = bg

local subLabel = Instance.new("TextLabel")
subLabel.Size = UDim2.new(1, 0, 0, 30)
subLabel.Position = UDim2.new(0, 0, 0.48, 0)
subLabel.BackgroundTransparency = 1
subLabel.Text = "Loading..."
subLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
subLabel.TextSize = 18
subLabel.Font = Enum.Font.Gotham
subLabel.Parent = bg

local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(0, 400, 0, 8)
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

local function setProgress(percent, text)
    subLabel.Text = text
    TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(percent, 0, 1, 0)
    }):Play()
end

setProgress(0.3, "Loading functions...")
task.wait(0.4)

local ok1, err1 = pcall(function()
    local src = game:HttpGet(REPO .. "functions.lua")
    local chunk = loadstring(src)
    if chunk then chunk() end
end)

if not ok1 then
    warn("[PrimeHUB] Eroare funcții: " .. tostring(err1))
end

setProgress(0.7, "Loading interface...")
task.wait(0.4)

local ok2, err2 = pcall(function()
    local src = game:HttpGet(REPO .. "ui.lua")
    local chunk = loadstring(src)
    if chunk then chunk() end
end)

if not ok2 then
    warn("[PrimeHUB] Eroare interfață: " .. tostring(err2))
end

setProgress(1, "Done!")
task.wait(0.5)

TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(titleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(subLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(barFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

task.wait(0.6)
loadingGui:Destroy()

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "PrimeHUB",
    Text = "Loaded successfully!",
    Duration = 3,
})
