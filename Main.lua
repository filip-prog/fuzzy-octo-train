-- PrimeHUB Loader cu XOR Decryption + Key System
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

-- ⚠️ SCHIMBĂ CHEIA (trebuie să fie identică cu cea din scriptul de criptare)
local SECRET_KEY = "PrimeHUB_Secret_2025_XOR_Key_ChangeMe"

-- ⚠️ LIPEȘTE STRING-URILE CRIPTATE (din scriptul de criptare)
local ENCRYPTED_FUNCTIONS = "LIPEȘTE_AICI_REZULTATUL_FUNCTIONS"
local ENCRYPTED_UI = "LIPEȘTE_AICI_REZULTATUL_UI"

-- ⚠️ Link-ul de key
local KEY_LINK = "https://discord.gg/FRymbb9g"

-- ⚠️ Key-urile valide
local VALID_KEYS = {
    ["PrimeHUB-2025"] = true,
    ["free-key-123"] = true,
    ["vip-access"] = true,
}

-- XOR Decrypt
local function xorDecrypt(hexData, key)
    local result = {}
    local i = 1
    local keyIndex = 1
    while i <= #hexData do
        local hexByte = hexData:sub(i, i + 1)
        local byteVal = tonumber(hexByte, 16)
        if not byteVal then return "" end
        local keyChar = string.byte(key, keyIndex)
        table.insert(result, string.char(bit32.bxor(byteVal, keyChar)))
        i = i + 2
        keyIndex = keyIndex + 1
        if keyIndex > #key then keyIndex = 1 end
    end
    return table.concat(result)
end

-- Șterge GUI vechi
if CoreGui:FindFirstChild("PrimeHUB_KeySystem") then
    CoreGui.PrimeHUB_KeySystem:Destroy()
end
if CoreGui:FindFirstChild("PrimeHUB_Loading") then
    CoreGui.PrimeHUB_Loading:Destroy()
end

-- Key System UI
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "PrimeHUB_KeySystem"
keyGui.ResetOnSpawn = false
keyGui.IgnoreGuiInset = true
keyGui.DisplayOrder = 99999
keyGui.Parent = CoreGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BorderSizePixel = 0
bg.Parent = keyGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 450)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = bg
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Color = Color3.fromRGB(60, 60, 60)
stroke.Thickness = 1

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.Position = UDim2.new(0, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "PrimeHUB"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 42
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 70)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Key System"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
subtitle.TextSize = 16
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = mainFrame

local instructions = Instance.new("TextLabel")
instructions.Size = UDim2.new(1, -40, 0, 80)
instructions.Position = UDim2.new(0, 20, 0, 110)
instructions.BackgroundTransparency = 1
instructions.Text = "1. Apasă butonul de mai jos pentru a copia link-ul\n2. Deschide link-ul în browser\n3. Copiază key-ul primit\n4. Lipește-l mai jos și apasă Submit"
instructions.TextColor3 = Color3.fromRGB(200, 200, 200)
instructions.TextSize = 14
instructions.Font = Enum.Font.Gotham
instructions.TextWrapped = true
instructions.TextXAlignment = Enum.TextXAlignment.Left
instructions.TextYAlignment = Enum.TextYAlignment.Top
instructions.Parent = mainFrame

local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Size = UDim2.new(1, -40, 0, 45)
getKeyBtn.Position = UDim2.new(0, 20, 0, 200)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 200)
getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
getKeyBtn.Text = "📋 Copy Key Link"
getKeyBtn.TextSize = 16
getKeyBtn.Font = Enum.Font.GothamBold
getKeyBtn.BorderSizePixel = 0
getKeyBtn.Parent = mainFrame
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0, 8)

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(1, -40, 0, 45)
keyInput.Position = UDim2.new(0, 20, 0, 260)
keyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderText = "Paste your key here..."
keyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
keyInput.Text = ""
keyInput.TextSize = 14
keyInput.Font = Enum.Font.Gotham
keyInput.BorderSizePixel = 0
keyInput.ClearTextOnFocus = false
keyInput.Parent = mainFrame
Instance.new("UICorner", keyInput).CornerRadius = UDim.new(0, 8)

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(1, -40, 0, 45)
submitBtn.Position = UDim2.new(0, 20, 0, 320)
submitBtn.BackgroundColor3 = Color3.fromRGB(30, 180, 80)
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.Text = "✅ Submit Key"
submitBtn.TextSize = 16
submitBtn.Font = Enum.Font.GothamBold
submitBtn.BorderSizePixel = 0
submitBtn.Parent = mainFrame
Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0, 8)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 375)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

local function setStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color or Color3.fromRGB(255, 100, 100)
end

getKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard(KEY_LINK)
    end)
    setStatus("✅ Link copiat! Deschide-l în browser.", Color3.fromRGB(100, 255, 100))
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "PrimeHUB Key",
            Text = "Link copiat! Deschide-l în browser.",
            Duration = 5,
        })
    end)
end)

local function loadHub()
    keyGui:Destroy()

    local loadingGui = Instance.new("ScreenGui")
    loadingGui.Name = "PrimeHUB_Loading"
    loadingGui.ResetOnSpawn = false
    loadingGui.IgnoreGuiInset = true
    loadingGui.DisplayOrder = 9999
    loadingGui.Parent = CoreGui

    local lBg = Instance.new("Frame")
    lBg.Size = UDim2.new(1, 0, 1, 0)
    lBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    lBg.BorderSizePixel = 0
    lBg.Parent = loadingGui

    local lTitle = Instance.new("TextLabel")
    lTitle.Size = UDim2.new(1, 0, 0, 60)
    lTitle.Position = UDim2.new(0, 0, 0.4, 0)
    lTitle.BackgroundTransparency = 1
    lTitle.Text = "PrimeHUB"
    lTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    lTitle.TextSize = 48
    lTitle.Font = Enum.Font.GothamBold
    lTitle.Parent = lBg

    local lSub = Instance.new("TextLabel")
    lSub.Size = UDim2.new(1, 0, 0, 30)
    lSub.Position = UDim2.new(0, 0, 0.48, 0)
    lSub.BackgroundTransparency = 1
    lSub.Text = "Loading..."
    lSub.TextColor3 = Color3.fromRGB(180, 180, 180)
    lSub.TextSize = 18
    lSub.Font = Enum.Font.Gotham
    lSub.Parent = lBg

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 400, 0, 8)
    barBg.Position = UDim2.new(0.5, -200, 0.58, 0)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.BorderSizePixel = 0
    barBg.Parent = lBg
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    barFill.BorderSizePixel = 0
    barFill.Parent = barBg
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

    local function setProgress(percent, text)
        lSub.Text = text
        TweenService:Create(barFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(percent, 0, 1, 0)
        }):Play()
    end

    setProgress(0.1, "Decrypting...")
    task.wait(0.4)

    local urlFunctions, urlUi
    local okDecrypt, errDecrypt = pcall(function()
        urlFunctions = xorDecrypt(ENCRYPTED_FUNCTIONS, SECRET_KEY)
        urlUi = xorDecrypt(ENCRYPTED_UI, SECRET_KEY)
    end)

    if not okDecrypt or not urlFunctions or urlFunctions == "" then
        warn("[PrimeHUB] Eroare decriptare: " .. tostring(errDecrypt))
        lSub.Text = "❌ Decryption failed!"
        lSub.TextColor3 = Color3.fromRGB(255, 100, 100)
        return
    end

    setProgress(0.4, "Loading functions...")
    task.wait(0.4)

    local ok1, err1 = pcall(function()
        local src = game:HttpGet(urlFunctions)
        local chunk = loadstring(src)
        if chunk then chunk() end
    end)

    if not ok1 then
        warn("[PrimeHUB] Eroare funcții: " .. tostring(err1))
    end

    setProgress(0.7, "Loading interface...")
    task.wait(0.4)

    local ok2, err2 = pcall(function()
        local src = game:HttpGet(urlUi)
        local chunk = loadstring(src)
        if chunk then chunk() end
    end)

    if not ok2 then
        warn("[PrimeHUB] Eroare interfață: " .. tostring(err2))
    end

    setProgress(1, "Done!")
    task.wait(0.5)

    TweenService:Create(lBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(lTitle, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(lSub, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(barBg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(barFill, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

    task.wait(0.6)
    loadingGui:Destroy()

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "PrimeHUB",
            Text = "Loaded successfully!",
            Duration = 3,
        })
    end)
end

submitBtn.MouseButton1Click:Connect(function()
    local userKey = keyInput.Text
    if not userKey or userKey == "" then
        setStatus("❌ Introdu un key mai întâi!", Color3.fromRGB(255, 100, 100))
        return
    end
    if VALID_KEYS[userKey] then
        setStatus("✅ Key valid! Se încarcă hub-ul...", Color3.fromRGB(100, 255, 100))
        task.wait(0.5)
        loadHub()
    else
        setStatus("❌ Key invalid! Încearcă din nou.", Color3.fromRGB(255, 100, 100))
    end
end)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        submitBtn:Activate()
    end
end)
