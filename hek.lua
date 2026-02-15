--// HEKWA HUB FULL SYSTEM

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--// GUI
local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "HekwaHub"
sg.ResetOnSpawn = false

--// THEME
local C = {
	bg = Color3.fromRGB(10,10,12),
	panel = Color3.fromRGB(18,18,22),
	red = Color3.fromRGB(170,40,40),
	redDark = Color3.fromRGB(110,25,25),
	redGlow = Color3.fromRGB(220,60,60),
	text = Color3.fromRGB(235,235,235)
}

--// MAIN
local main = Instance.new("Frame", sg)
main.Size = UDim2.fromOffset(420,520)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke", main)
stroke.Color = C.redDark
stroke.Thickness = 1.2

--// TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "HEKWA HUB"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = C.redGlow

--// CONTENT
local content = Instance.new("Frame", main)
content.Position = UDim2.fromOffset(0,60)
content.Size = UDim2.new(1,0,1,-60)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,14)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--// VARIABLES
local speedEnabled = false
local speedValue = 16
local jumpValue = 50
local antiRagdoll = false
local espEnabled = false
local toggleKey = Enum.KeyCode.X

--// CHARACTER REFRESH
local function getHumanoid()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("Humanoid")
end

--// GENERIC SLIDER
local function createSlider(text, min, max, default, callback)

	local frame = Instance.new("Frame", content)
	frame.Size = UDim2.fromOffset(380,70)
	frame.BackgroundColor3 = C.panel
	frame.BorderSizePixel = 0
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1,-20,0,25)
	label.Position = UDim2.fromOffset(10,5)
	label.BackgroundTransparency = 1
	label.Text = text.." : "..default
	label.TextColor3 = C.text
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 14
	label.TextXAlignment = Left

	local bar = Instance.new("Frame", frame)
	bar.Size = UDim2.new(1,-20,0,10)
	bar.Position = UDim2.fromOffset(10,40)
	bar.BackgroundColor3 = C.redDark
	bar.BorderSizePixel = 0
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = C.red
	fill.BorderSizePixel = 0
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

	local dragging = false

	bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local percent = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			fill.Size = UDim2.new(percent,0,1,0)
			local val = math.floor(min + (max-min)*percent)
			label.Text = text.." : "..val
			callback(val)
		end
	end)
end

--// SPEED SLIDER
createSlider("Speed",16,200,16,function(val)
	speedValue = val
end)

--// JUMP SLIDER
createSlider("Jump Power",50,200,50,function(val)
	jumpValue = val
	getHumanoid().JumpPower = val
end)

--// SPEED TOGGLE VIA KEY
UserInputService.InputBegan:Connect(function(input,gp)
	if gp then return end
	if input.KeyCode == toggleKey then
		speedEnabled = not speedEnabled
	end
end)

RunService.RenderStepped:Connect(function()
	local hum = getHumanoid()

	if speedEnabled then
		hum.WalkSpeed = speedValue
	else
		hum.WalkSpeed = 16
	end

	if antiRagdoll then
		hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
		hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false)
	end
end)

--// TOGGLE BUTTON CREATOR
local function createToggle(text, callback)

	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.fromOffset(380,50)
	btn.BackgroundColor3 = C.panel
	btn.Text = text.." : OFF"
	btn.TextColor3 = C.text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.BorderSizePixel = 0
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	local state = false

	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text.." : "..(state and "ON" or "OFF")
		btn.BackgroundColor3 = state and C.redDark or C.panel
		callback(state)
	end)
end

--// ANTI RAGDOLL
createToggle("Anti Ragdoll",function(val)
	antiRagdoll = val
end)

--// ESP SYSTEM
local espFolder = Instance.new("Folder", sg)
espFolder.Name = "ESP"

local function createESP(plr)
	if plr == player then return end

	local function add(char)
		local highlight = Instance.new("Highlight", espFolder)
		highlight.Adornee = char
		highlight.FillColor = C.red
		highlight.OutlineColor = Color3.new(0,0,0)
		highlight.FillTransparency = 0.5
	end

	if plr.Character then add(plr.Character) end
	plr.CharacterAdded:Connect(add)
end

createToggle("ESP Players",function(val)
	espEnabled = val
	espFolder:ClearAllChildren()

	if val then
		for _,plr in pairs(Players:GetPlayers()) do
			createESP(plr)
		end
	end
end)

Players.PlayerAdded:Connect(function(plr)
	if espEnabled then
		createESP(plr)
	end
end)
