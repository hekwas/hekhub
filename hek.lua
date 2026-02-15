--// HEKWAS HUB - ULTRA MOVEMENT PREMIUM BUILD

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

--// GUI
local sg = Instance.new("ScreenGui")
sg.Name = "HekwasHubUltra"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

--// THEME
local C = {
	bg = Color3.fromRGB(12,12,14),
	panel = Color3.fromRGB(22,22,26),
	red = Color3.fromRGB(185,45,45),
	redDark = Color3.fromRGB(120,25,25),
	text = Color3.fromRGB(240,240,240)
}

--// MAIN WINDOW
local main = Instance.new("Frame", sg)
main.Size = UDim2.fromOffset(420,520)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = C.bg
main.Active = true
main.Draggable = true
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

-- Floating reopen button
local reopen = Instance.new("TextButton", sg)
reopen.Size = UDim2.fromOffset(50,50)
reopen.Position = UDim2.new(0,20,0.5,0)
reopen.Text = "H"
reopen.Visible = false
reopen.BackgroundColor3 = C.redDark
reopen.TextColor3 = C.text
Instance.new("UICorner", reopen).CornerRadius = UDim.new(1,0)

-- Title Bar
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,50)
top.BackgroundColor3 = C.panel
Instance.new("UICorner", top).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.fromOffset(10,0)
title.BackgroundTransparency = 1
title.Text = "HEKWAS HUB - ULTRA"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = C.red
title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton", top)
minimize.Size = UDim2.fromOffset(40,40)
minimize.Position = UDim2.new(1,-45,0.5,-20)
minimize.Text = "X"
minimize.BackgroundColor3 = C.redDark
minimize.TextColor3 = C.text
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,8)

local content = Instance.new("Frame", main)
content.Position = UDim2.fromOffset(0,60)
content.Size = UDim2.new(1,0,1,-60)
content.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout", content)
layout.Padding = UDim.new(0,12)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

minimize.MouseButton1Click:Connect(function()
	main.Visible = false
	reopen.Visible = true
end)

reopen.MouseButton1Click:Connect(function()
	main.Visible = true
	reopen.Visible = false
end)

--// MOVEMENT VARIABLES
local humanoid
local hrp

local speedEnabled = false
local targetSpeed = 16
local currentSpeed = 16
local infinityJump = false
local bunnyHop = false
local airDash = false
local fallControl = false

--// CHARACTER SETUP
local function setupCharacter(char)
	humanoid = char:WaitForChild("Humanoid")
	hrp = char:WaitForChild("HumanoidRootPart")
	humanoid.UseJumpPower = true
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)

--// UI HELPERS
local function createToggle(name, callback)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.fromOffset(380,45)
	btn.BackgroundColor3 = C.panel
	btn.Text = name.." : OFF"
	btn.TextColor3 = C.text
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = name.." : "..(state and "ON" or "OFF")
		btn.BackgroundColor3 = state and C.redDark or C.panel
		callback(state)
	end)
end

local function createSlider(name,min,max,default,callback)
	local frame = Instance.new("Frame", content)
	frame.Size = UDim2.fromOffset(380,60)
	frame.BackgroundColor3 = C.panel
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1,-20,0,25)
	label.Position = UDim2.fromOffset(10,5)
	label.BackgroundTransparency = 1
	label.Text = name.." : "..default
	label.TextColor3 = C.text
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left

	local bar = Instance.new("Frame", frame)
	bar.Size = UDim2.new(1,-20,0,8)
	bar.Position = UDim2.fromOffset(10,40)
	bar.BackgroundColor3 = C.redDark
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
	fill.BackgroundColor3 = C.red
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

	local dragging = false

	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
		end
	end)

	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local percent = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)
			fill.Size = UDim2.new(percent,0,1,0)
			local val = math.floor(min+(max-min)*percent)
			label.Text = name.." : "..val
			callback(val)
		end
	end)
end

--// SPEED MAX 60
createSlider("Speed (Max 60)",16,60,16,function(val)
	targetSpeed = val
end)

createToggle("Speed Enabled",function(v)
	speedEnabled = v
end)

createToggle("Infinity Jump",function(v)
	infinityJump = v
end)

createToggle("Bunny Hop Assist",function(v)
	bunnyHop = v
end)

createToggle("Air Dash",function(v)
	airDash = v
end)

createToggle("Fall Control",function(v)
	fallControl = v
end)

--// Infinity Jump
UIS.JumpRequest:Connect(function()
	if infinityJump and humanoid then
		if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
			hrp.Velocity = Vector3.new(hrp.Velocity.X,35,hrp.Velocity.Z)
		end
	end
end)

--// Air Dash
UIS.InputBegan:Connect(function(input,gp)
	if gp then return end
	if airDash and input.KeyCode == Enum.KeyCode.Q and hrp then
		local look = workspace.CurrentCamera.CFrame.LookVector
		hrp.Velocity = look * 60
	end
end)

--// MAIN OPTIMIZED LOOP
RunService.Heartbeat:Connect(function(dt)
	if not humanoid then return end

	-- Speed smoothing
	local goal = speedEnabled and targetSpeed or 16
	currentSpeed = currentSpeed + (goal-currentSpeed)*0.2
	humanoid.WalkSpeed = currentSpeed

	-- Bunny Hop
	if bunnyHop and humanoid.FloorMaterial ~= Enum.Material.Air then
		humanoid.Jump = true
	end

	-- Fall Control
	if fallControl and hrp and hrp.Velocity.Y < -60 then
		hrp.Velocity = Vector3.new(hrp.Velocity.X,-60,hrp.Velocity.Z)
	end
end)
