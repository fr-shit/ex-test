local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

--// SETTINGS
local VSpeed = {
    Enabled = false,
    Speed = 2
}

--// CHARACTER HANDLING
local Character, Humanoid, RootPart

local function bindCharacter(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
end

bindCharacter(Player.Character or Player.CharacterAdded:Wait())
Player.CharacterAdded:Connect(bindCharacter)

--// MOVEMENT LOOP
RunService.RenderStepped:Connect(function()
    if not VSpeed.Enabled then return end
    if not Character or not Humanoid or not RootPart then return end

    local moveDir = Humanoid.MoveDirection
    if moveDir.Magnitude > 0 then
        local currentVel = RootPart.AssemblyLinearVelocity

        local speedFactor = 8 + (Humanoid.WalkSpeed * VSpeed.Speed)

        RootPart.AssemblyLinearVelocity = Vector3.new(
            moveDir.X * speedFactor,
            currentVel.Y,
            moveDir.Z * speedFactor
        )
    end
end)

--// GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "VelUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = Player:WaitForChild("PlayerGui")

--// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 180)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
frame.BorderSizePixel = 0
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(80, 80, 120)
stroke.Transparency = 0.5
stroke.Thickness = 1.5

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 18))
}
gradient.Rotation = 90

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Velocity Speed"
title.TextColor3 = Color3.fromRGB(235, 235, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

--// STATUS BADGE
local status = Instance.new("TextLabel")
status.Size = UDim2.new(0, 80, 0, 26)
status.Position = UDim2.new(1, -90, 0, 12)
status.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
status.Text = "OFF"
status.TextColor3 = Color3.fromRGB(255, 90, 90)
status.Font = Enum.Font.GothamBold
status.TextSize = 13
status.Parent = frame

Instance.new("UICorner", status).CornerRadius = UDim.new(1, 0)

--// TOGGLE BUTTON
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0.9, 0, 0, 42)
toggle.Position = UDim2.new(0.5, 0, 0.45, 0)
toggle.AnchorPoint = Vector2.new(0.5, 0.5)
toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
toggle.Text = "Enable Velocity Speed"
toggle.TextColor3 = Color3.fromRGB(240, 240, 255)
toggle.Font = Enum.Font.GothamSemibold
toggle.TextSize = 14
toggle.Parent = frame

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 10)

local toggleStroke = Instance.new("UIStroke", toggle)
toggleStroke.Color = Color3.fromRGB(90, 90, 140)
toggleStroke.Transparency = 0.6

--// SPEED INPUT
local box = Instance.new("TextBox")
box.Size = UDim2.new(0.9, 0, 0, 40)
box.Position = UDim2.new(0.5, 0, 0.78, 0)
box.AnchorPoint = Vector2.new(0.5, 0.5)
box.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
box.Text = tostring(VSpeed.Speed)
box.PlaceholderText = "Speed multiplier (0.1 - 50)"
box.TextColor3 = Color3.fromRGB(230, 230, 255)
box.Font = Enum.Font.Gotham
box.TextSize = 14
box.ClearTextOnFocus = false
box.Parent = frame

Instance.new("UICorner", box).CornerRadius = UDim.new(0, 10)

local boxStroke = Instance.new("UIStroke", box)
boxStroke.Color = Color3.fromRGB(80, 80, 120)
boxStroke.Transparency = 0.6

--// UI UPDATE FUNCTION
local function updateUI()
    if VSpeed.Enabled then
        status.Text = "ON"
        status.TextColor3 = Color3.fromRGB(90, 255, 140)
        toggle.Text = "Disable Velocity Speed"
        toggle.BackgroundColor3 = Color3.fromRGB(40, 70, 55)
    else
        status.Text = "OFF"
        status.TextColor3 = Color3.fromRGB(255, 90, 90)
        toggle.Text = "Enable Velocity Speed"
        toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    end
end

updateUI()

--// TOGGLE
toggle.MouseButton1Click:Connect(function()
    VSpeed.Enabled = not VSpeed.Enabled
    updateUI()
end)

--// SPEED INPUT
box.FocusLost:Connect(function()
    local num = tonumber(box.Text)
    if num then
        VSpeed.Speed = math.clamp(num, 0.1, 50)
    end
    box.Text = tostring(VSpeed.Speed)
end)

--// DRAG SYSTEM
local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
