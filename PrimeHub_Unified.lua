
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
