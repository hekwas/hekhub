--// HEKWA HUB - Compact Dark Red UI
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

--// ScreenGui
local sg = Instance.new("ScreenGui")
sg.Name = "HekwaHubUI"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

--// Theme
local C = {
	bg = Color3.fromRGB(8, 8, 10),
	panel = Color3.fromRGB(12, 12, 15),
	red = Color3.fromRGB(180, 40, 40),
	redDark = Color3.fromRGB(120, 25, 25),
	redGlow = Color3.fromRGB(220, 70, 70),
	text = Color3.fromRGB(240, 240, 240),
	textDim = Color3.fromRGB(170, 170, 170),
	border = Color3.fromRGB(60, 15, 15)
}

--// Main Frame
local main = Instance.new("Frame")
main.Parent = sg
main.Name = "Hekwa Hub"
main.Size = UDim2.fromOffset(420, 520)
main.Position = UDim2.fromScale(0.5, 0.5)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

--// Fog Overlay
local fog = Instance.new("ImageLabel", main)
fog.Size = UDim2.fromScale(1, 1)
fog.BackgroundTransparency = 1
fog.Image = "rbxassetid://8992230677"
fog.ImageTransparency = 0.75
fog.ImageColor3 = Color3.fromRGB(60, 20, 20)
fog.ZIndex = 1

--// Stroke
local stroke = Instance.new("UIStroke", main)
stroke.Color = C.border
stroke.Thickness = 1.2
stroke.Transparency = 0.15

--// Top Bar
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 56)
top.BackgroundColor3 = C.panel
top.BorderSizePixel = 0
top.ZIndex = 2

Instance.new("UICorner", top).CornerRadius = UDim.new(0, 16)

--// Title
local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.fromOffset(14, 0)
title.BackgroundTransparency = 1
title.Text = "HEKWAS HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextXAlignment = Left
title.TextColor3 = C.redGlow
title.ZIndex = 3

--// Content Area
local content = Instance.new("Frame", main)
content.Position = UDim2.fromOffset(0, 64)
content.Size = UDim2.new(1, 0, 1, -64)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0, 14)
layout.HorizontalAlignment = Center

--// Section Creator
local function createSection(text)
	local sec = Instance.new("Frame", content)
	sec.Size = UDim2.fromOffset(380, 70)
	sec.BackgroundColor3 = C.panel
	sec.BorderSizePixel = 0

	Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 12)

	local lbl = Instance.new("TextLabel", sec)
	lbl.Size = UDim2.new(1, -20, 0, 30)
	lbl.Position = UDim2.fromOffset(12, 6)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.Font = Enum.Font.GothamSemibold
	lbl.TextSize = 16
	lbl.TextXAlignment = Left
	lbl.TextColor3 = C.text

	return sec
end

--// Example Section
local auto = createSection("Auto Features")

--// Button
local btn = Instance.new("TextButton", auto)
btn.Size = UDim2.fromOffset(160, 34)
btn.Position = UDim2.fromOffset(12, 34)
btn.Text = "ENABLE"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.TextColor3 = C.text
btn.BackgroundColor3 = C.redDark
btn.BorderSizePixel = 0

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

--// Button Glow
local glow = Instance.new("UIStroke", btn)
glow.Color = C.redGlow
glow.Thickness = 1
glow.Transparency = 0.35

--// Button Effect
btn.MouseEnter:Connect(function()
	btn.BackgroundColor3 = C.red
end)

btn.MouseLeave:Connect(function()
	btn.BackgroundColor3 = C.redDark
end)

--// Subtle Animation
RunService.RenderStepped:Connect(function()
	glow.Transparency = 0.25 + math.abs(math.sin(tick() * 2)) * 0.35
end)
