-- 👻 HEAD HIDER SCRIPT
-- หัวหายเฉพาะคนอื่นมองไม่เห็น (ตัวเองยังเห็นปกติ)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function hideHead(character)
    -- รอ character โหลด
    character:WaitForChild("Head")
    wait(0.3)

    local head = character:FindFirstChild("Head")
    if not head then return end

    -- ซ่อน Mesh ของหัว
    local mesh = head:FindFirstChildOfClass("SpecialMesh")
    if mesh then
        mesh.Scale = Vector3.new(0, 0, 0)
    end

    -- ทำหัวใส (Transparency = 1) เพื่อซ่อนสี
    head.Transparency = 1

    -- ซ่อน Decal/Texture บนหัว (เช่นหน้า)
    for _, v in ipairs(head:GetChildren()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end

    -- ซ่อน Hat/Accessory ที่ติดกับหัว
    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                -- ตรวจว่า Accessory อยู่บริเวณหัวไหม
                local weld = handle:FindFirstChildOfClass("Weld") or
                             handle:FindFirstChildOfClass("Motor6D")
                if weld and weld.Part1 == head then
                    handle.Transparency = 1
                end
            end
        end
    end

    print("👻 ซ่อนหัวสำเร็จ!")
end

local function showHead(character)
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end

    local mesh = head:FindFirstChildOfClass("SpecialMesh")
    if mesh then
        mesh.Scale = Vector3.new(1, 1, 1)
    end

    head.Transparency = 0

    for _, v in ipairs(head:GetChildren()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 0
        end
    end

    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") then
            local handle = accessory:FindFirstChild("Handle")
            if handle then
                handle.Transparency = 0
            end
        end
    end

    print("✅ แสดงหัวอีกครั้ง")
end

-- ==================== GUI ====================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HeadHiderGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 110)
frame.Position = UDim2.new(0, 260, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(180, 80, 255)
stroke.Thickness = 1.5
stroke.Parent = frame

-- Title bar (drag handle)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 34)
titleBar.BackgroundColor3 = Color3.fromRGB(70, 20, 120)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 12)
titleFix.Position = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(70, 20, 120)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "👻  HEAD HIDER"
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local statusLabel = Instance.new("TextLabel")
statusLabel.Text = "🟣  หัวแสดงอยู่"
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 42)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "ซ่อนหัว"
toggleBtn.Size = UDim2.new(1, -20, 0, 36)
toggleBtn.Position = UDim2.new(0, 10, 0, 66)
toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 14
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = frame
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

-- ==================== STATE ====================
local headHidden = false

toggleBtn.MouseButton1Click:Connect(function()
    local character = player.Character
    if not character then return end

    headHidden = not headHidden
    if headHidden then
        hideHead(character)
        statusLabel.Text = "👻  หัวซ่อนอยู่"
        toggleBtn.Text = "แสดงหัว"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    else
        showHead(character)
        statusLabel.Text = "🟣  หัวแสดงอยู่"
        toggleBtn.Text = "ซ่อนหัว"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 200)
    end
end)

-- ==================== RESPAWN ====================
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    wait(0.5)
    if headHidden then
        hideHead(character)
    end
end)

-- ==================== GUI DRAG ====================
local dragging, dragInput, dragStart, startPos = false, nil, nil, nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

print("👻 Head Hider โหลดสำเร็จ!")
