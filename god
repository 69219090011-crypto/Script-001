local player = game.Players.LocalPlayer

-- ===== NOCLIP =====
local noclip = false

game:GetService("RunService").Stepped:Connect(function()
	if noclip and player.Character then
		for _,v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- ===== GODMODE =====
local god = false

local function applyGod()
	local char = player.Character or player.CharacterAdded:Wait()
	local hum = char:WaitForChild("Humanoid")

	if god then
		hum.MaxHealth = math.huge
		hum.Health = math.huge
	end
end

player.CharacterAdded:Connect(function()
	task.wait(1)
	applyGod()
end)

-- ===== ปุ่ม GUI =====
local gui = player.PlayerGui:FindFirstChild("FPSBooster")

local function createButton(text, posY, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,-20,0,30)
	b.Position = UDim2.new(0,10,0,posY)
	b.Text = text
	b.Parent = gui:FindFirstChildOfClass("Frame")

	b.MouseButton1Click:Connect(callback)
end

createButton("NOCLIP OFF", 10, function(btn)
	noclip = not noclip
	btn.Text = noclip and "NOCLIP ON" or "NOCLIP OFF"
end)

createButton("GODMODE OFF", 80, function(btn)
	god = not god
	applyGod()
	btn.Text = god and "GODMODE ON" or "GODMODE OFF"
end)
