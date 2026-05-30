local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local active = {} -- [player] = true/false
local SPEED = 2

local function startTpWalk(player)
	if active[player] then return end
	active[player] = true

	task.spawn(function()
		while active[player] and player.Parent do
			local char = player.Character
			if char then
				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")

				if hrp and hum and hum.Health > 0 then
					hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * SPEED)
				end
			end
			RunService.Heartbeat:Wait()
		end
	end)
end

local function stopTpWalk(player)
	active[player] = nil
end

Players.PlayerAdded:Connect(function(player)
	player.Chatted:Connect(function(msg)
		msg = msg:lower()

		-- toggle command
		if msg == "!tpwalk" then
			if active[player] then
				stopTpWalk(player)
			else
				startTpWalk(player)
			end
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	active[player] = nil
end)
