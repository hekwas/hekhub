local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local KEYS_URL = "https://raw.githubusercontent.com/hekwas/ambigonz/main/keys.json"
local SAVE_FILE = "gonzo_cache.json"

-- ===== LOCAL TOOL START FUNCTION =====
local function StartTool()
end

-- ===== CACHE FUNCTIONS =====
local function save(data)
    if writefile then
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end
end

local function load()
    if readfile and isfile and isfile(SAVE_FILE) then
        return HttpService:JSONDecode(readfile(SAVE_FILE))
    end
end

-- ===== AUTO LOGIN CHECK =====
local saved = load()
if saved
    and saved.expire
    and saved.expire > os.time()
    and saved.userId == player.UserId then

    StartTool()
    return
end

-- ===== UI BRUTAL DARK BLOOD =====
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.Name = "HEKWASDUELS_UI"
gui.IgnoreGuiInset = true

-- Fog Background
local fog = Instance.new("Frame", gui)
fog.Size = UDim2.new(1,0,1,0)
fog.BackgroundColor3 = Color3.fromRGB(5,0,0)
fog.BackgroundTransparency = 0.35
fog.ZIndex = 0

-- Animated Fog Pulse
task.spawn(function()
    while fog.Parent do
        TweenService:Create(fog, TweenInfo.new(3), {BackgroundTransparency = 0.45}):Play()
        task.wait(3)
        TweenService:Create(fog, TweenInfo.new(3), {BackgroundTransparency = 0.3}):Play()
        task.wait(3)
    end
end)

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 400, 0, 260)
frame.Position = UDim2.new(0.5, -200, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(15,0,0)
frame.BorderSizePixel = 0
frame.ZIndex = 2
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,20)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(120,0,0)
stroke.Thickness = 4

-- Pulsing Glow
task.spawn(function()
    while frame.Parent do
        TweenService:Create(stroke, TweenInfo.new(1.5), {Color = Color3.fromRGB(255,0,0)}):Play()
        task.wait(1.5)
        TweenService:Create(stroke, TweenInfo.new(1.5), {Color = Color3.fromRGB(120,0,0)}):Play()
        task.wait(1.5)
    end
end)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,60)
title.BackgroundTransparency = 1
title.Text = "HEKWAS DUELS"
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.TextColor3 = Color3.fromRGB(180,0,0)
title.ZIndex = 3

local titleStroke = Instance.new("UIStroke", title)
titleStroke.Color = Color3.fromRGB(255,0,0)
titleStroke.Thickness = 2

-- Blood Drip Effect
for i = 1, 6 do
    local drip = Instance.new("Frame", frame)
    drip.Size = UDim2.new(0, 6, 0, math.random(20,60))
    drip.Position = UDim2.new(math.random(), 0, 0, 55)
    drip.BackgroundColor3 = Color3.fromRGB(120,0,0)
    drip.BorderSizePixel = 0
    drip.ZIndex = 2

    task.spawn(function()
        while drip.Parent do
            drip.Size = drip.Size + UDim2.new(0,0,0,1)
            task.wait(0.05)
        end
    end)
end

-- Key Box
local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.85,0,0,55)
box.Position = UDim2.new(0.075,0,0.4,0)
box.BackgroundColor3 = Color3.fromRGB(25,0,0)
box.TextColor3 = Color3.fromRGB(255,0,0)
box.PlaceholderText = "ENTER YOUR KEY..."
box.Font = Enum.Font.Gotham
box.TextSize = 16
box.ClearTextOnFocus = false
Instance.new("UICorner", box).CornerRadius = UDim.new(0,14)

-- Verify Button
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.6,0,0,55)
button.Position = UDim2.new(0.2,0,0.7,0)
button.BackgroundColor3 = Color3.fromRGB(120,0,0)
button.Text = "VERIFY"
button.TextColor3 = Color3.new(1,1,1)
button.Font = Enum.Font.GothamBlack
button.TextSize = 18
button.BorderSizePixel = 0
Instance.new("UICorner", button).CornerRadius = UDim.new(0,16)

-- ===== VERIFY LOGIC =====
button.MouseButton1Click:Connect(function()

    local enteredKey = box.Text
    if enteredKey == "" then return end

    button.Text = "CHECKING..."

    local success, response = pcall(function()
        return game:HttpGet(KEYS_URL)
    end)

    if not success then
        button.Text = "ERROR"
        task.wait(1)
        button.Text = "VERIFY"
        return
    end

    local keyTable = HttpService:JSONDecode(response)
    local keyData = keyTable[enteredKey]

    if not keyData then
        button.Text = "INVALID KEY"
        task.wait(1)
        button.Text = "VERIFY"
        return
    end

    local existing = load()
    if existing 
        and existing.key == enteredKey 
        and existing.userId ~= player.UserId then

        button.Text = "KEY LOCKED"
        task.wait(1.5)
        button.Text = "VERIFY"
        return
    end

    local duration = tonumber(keyData.duration) or 0
    local expireTime = os.time() + duration

    save({
        key = enteredKey,
        userId = player.UserId,
        expire = expireTime
    })

    button.Text = "ACCESS GRANTED"
    task.wait(0.8)

    -- ===== BRUTAL CINEMATIC INTRO =====
    local intro = Instance.new("Frame", gui)
    intro.Size = UDim2.new(1,0,1,0)
    intro.BackgroundColor3 = Color3.fromRGB(0,0,0)
    intro.ZIndex = 10

    local introTitle = Instance.new("TextLabel", intro)
    introTitle.Size = UDim2.new(1,0,1,0)
    introTitle.BackgroundTransparency = 1
    introTitle.Text = "HEKWAS DUELS"
    introTitle.Font = Enum.Font.GothamBlack
    introTitle.TextSize = 70
    introTitle.TextColor3 = Color3.fromRGB(120,0,0)

    local glow = Instance.new("UIStroke", introTitle)
    glow.Color = Color3.fromRGB(255,0,0)
    glow.Thickness = 5

    -- Pulsing glow
    task.spawn(function()
        while intro.Parent do
            TweenService:Create(glow, TweenInfo.new(0.8), {Thickness = 8}):Play()
            task.wait(0.8)
            TweenService:Create(glow, TweenInfo.new(0.8), {Thickness = 4}):Play()
            task.wait(0.8)
        end
    end)

    -- Red particles rain
    for i = 1, 80 do
        local p = Instance.new("Frame", intro)
        p.Size = UDim2.new(0,3,0,3)
        p.Position = UDim2.new(math.random(),0,math.random(-1,0),0)
        p.BackgroundColor3 = Color3.fromRGB(150,0,0)
        p.BorderSizePixel = 0

        task.spawn(function()
            while intro.Parent do
                p.Position = p.Position + UDim2.new(0,0,0.01,0)
                task.wait(0.02)
            end
        end)
    end

    task.wait(3)

    gui:Destroy()
    StartTool()
end)
