local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local function GetHumanoid()
	local Character = Player.Character or Player.CharacterAdded:Wait()
	return Character:WaitForChild("Humanoid")
end

-- GUI
local Gui = Instance.new("ScreenGui")
Gui.Name = "ControlPanel"
Gui.ResetOnSpawn = false
Gui.Parent = Player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 360)
Frame.Position = UDim2.new(0, 20, 0.5, -180)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Parent = Gui

local FrameCorner = Instance.new("UICorner")
FrameCorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "Control Panel"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

local Speed = 16
local Jump = 50

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0, 0, 0, 40)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 16
SpeedLabel.Parent = Frame

local JumpLabel = Instance.new("TextLabel")
JumpLabel.Size = UDim2.new(1, 0, 0, 25)
JumpLabel.Position = UDim2.new(0, 0, 0, 70)
JumpLabel.BackgroundTransparency = 1
JumpLabel.TextColor3 = Color3.new(1, 1, 1)
JumpLabel.Font = Enum.Font.Gotham
JumpLabel.TextSize = 16
JumpLabel.Parent = Frame

local function UpdateStats()
	local Humanoid = GetHumanoid()

	Humanoid.WalkSpeed = Speed
	Humanoid.JumpPower = Jump

	SpeedLabel.Text = "Speed: " .. tostring(Speed)
	JumpLabel.Text = "Jump: " .. tostring(Jump)
end

local function CreateButton(text, yPos)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(0.9, 0, 0, 35)
	Button.Position = UDim2.new(0.05, 0, 0, yPos)
	Button.Text = text
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	Button.Parent = Frame

	local Corner = Instance.new("UICorner")
	Corner.Parent = Button

	return Button
end

local SpeedUp = CreateButton("Speed +", 110)
local SpeedDown = CreateButton("Speed -", 150)
local JumpUp = CreateButton("Jump +", 190)
local JumpDown = CreateButton("Jump -", 230)
local SitToggle = CreateButton("Sit / Stand", 270)
local ResetButton = CreateButton("Reset Character", 310)

SpeedUp.MouseButton1Click:Connect(function()
	Speed = Speed + 5
	UpdateStats()
end)

SpeedDown.MouseButton1Click:Connect(function()
	Speed = math.max(0, Speed - 5)
	UpdateStats()
end)

JumpUp.MouseButton1Click:Connect(function()
	Jump = Jump + 10
	UpdateStats()
end)

JumpDown.MouseButton1Click:Connect(function()
	Jump = math.max(0, Jump - 10)
	UpdateStats()
end)

SitToggle.MouseButton1Click:Connect(function()
	local Humanoid = GetHumanoid()
	Humanoid.Sit = not Humanoid.Sit
end)

ResetButton.MouseButton1Click:Connect(function()
	if Player.Character then
		Player.Character:BreakJoints()
	end
end)

Player.CharacterAdded:Connect(function()
	wait(1)
	UpdateStats()
end)

UpdateStats()
