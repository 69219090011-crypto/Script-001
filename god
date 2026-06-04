local player = game.Players.LocalPlayer

-- ===== GUI (ไม่หายตอนตาย) =====
local gui = Instance.new("ScreenGui")
gui.Name = "Menu"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,200,0,120)
frame.Position = UDim2.new(0,50,0,200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Parent = gui

frame.Active = true
frame.Draggable = true

-- ===== ปุ่ม =====
local noclipBtn = Instance.new("TextButton")
noclipBtn.Size = UDim2.new(1,-20,0,40)
noclipBtn.Position = UDim2.new(0,10,0,10)
noclipBtn.Text = "NOCLIP OFF"
noclipBtn.Parent = frame

local godBtn = Instance.new("TextButton")
godBtn.Size = UDim2.new(1,-20,0,40)
godBtn.Position = UDim2.new(0,10,0,60)
godBtn.Text = "GOD OFF"
godBtn.Parent = frame

-- ===== ตัวแปร =====
local noclip = false
local god = false

-- ===== NOCLIP =====
game:GetService("RunService").Stepped:Connect(function()
	if noclip and player.Character then
		for _,v in pairs(player.Character:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "NOCLIP ON" or "NOCLIP OFF"
end)

-- ===== GODMODE =====
local function setGod()
	local char = player.Character
	if not char then return end
	
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	
	if god then
		hum.MaxHealth = math.huge
		hum.Health = hum.MaxHealth
	else
		hum.MaxHealth = 100
		hum.Health = 100
	end
end

godBtn.MouseButton1Click:Connect(function()
	god = not god
	godBtn.Text = god and "GOD ON" or "GOD OFF"
	setGod()
end)

-- รีตอนเกิดใหม่
player.CharacterAdded:Connect(function()
	task.wait(1)
	setGod()
end)
