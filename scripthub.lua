-- Roblox Advanced Menu GUI Script
-- Paste this into your executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Variables
local flying = false
local flySpeed = 50
local flyConnection

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Fungsi untuk membuat border RGB animasi
local function createRGBBorder(parent)
    local border = Instance.new("UIStroke")
    border.Thickness = 2
    border.Transparency = 0
    border.Parent = parent
    
    spawn(function()
        local hue = 0
        while parent and parent.Parent do
            hue = (hue + 1) % 360
            border.Color = Color3.fromHSV(hue / 360, 1, 1)
            wait(0.03)
        end
    end)
    
    return border
end

-- Main Toggle Button (Draggable)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.5, -60, 0.1, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.BackgroundTransparency = 0.3
toggleButton.BorderSizePixel = 0
toggleButton.Text = "MENU"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

createRGBBorder(toggleButton)

-- Dragging functionality
local dragging = false
local dragInput, mousePos, framePos

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        mousePos = input.Position
        framePos = toggleButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

toggleButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - mousePos
        toggleButton.Position = UDim2.new(
            framePos.X.Scale,
            framePos.X.Offset + delta.X,
            framePos.Y.Scale,
            framePos.Y.Offset + delta.Y
        )
    end
end)

-- Main Menu Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

createRGBBorder(mainFrame)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "⚡ ADVANCED MENU ⚡"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Container untuk buttons dan sliders
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -70)
container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 6
container.Parent = mainFrame

-- Fungsi untuk membuat button
local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 40)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Fungsi untuk membuat slider
local function createSlider(labelText, minVal, maxVal, defaultVal, position, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 70)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    sliderFrame.BackgroundTransparency = 0.3
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = labelText .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 6)
    sliderBar.Position = UDim2.new(0, 10, 0, 40)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(1, 0)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    createRGBBorder(sliderFill)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 16, 0, 16)
    sliderButton.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -8, 0.5, -8)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBar
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    createRGBBorder(sliderButton)
    
    local sliding = false
    
    sliderButton.MouseButton1Down:Connect(function()
        sliding = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(minVal + (maxVal - minVal) * pos)
            
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            sliderButton.Position = UDim2.new(pos, -8, 0.5, -8)
            label.Text = labelText .. ": " .. value
            
            callback(value)
        end
    end)
    
    return sliderFrame
end

-- Fly Function
local function startFly()
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = character.HumanoidRootPart
    
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyGyro.Parent = character.HumanoidRootPart
    
    local camera = workspace.CurrentCamera
    
    flyConnection = RunService.Heartbeat:Connect(function()
        if flying then
            local direction = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            bodyVelocity.Velocity = direction.Unit * flySpeed
            bodyGyro.CFrame = camera.CFrame
        end
    end)
end

local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
    end
    
    if character and character:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(character.HumanoidRootPart:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
    end
end

-- Buttons dan Sliders
local flyButton = createButton("Fly: OFF", UDim2.new(0, 5, 0, 5), function()
    flying = not flying
    flyButton.Text = flying and "Fly: ON" or "Fly: OFF"
    flyButton.BackgroundColor3 = flying and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
    
    if flying then
        startFly()
    else
        stopFly()
    end
end)

createSlider("Fly Speed", 10, 200, 50, UDim2.new(0, 5, 0, 55), function(value)
    flySpeed = value
end)

createSlider("WalkSpeed", 16, 200, 16, UDim2.new(0, 5, 0, 135), function(value)
    if humanoid then
        humanoid.WalkSpeed = value
    end
end)

createSlider("Jump Height", 50, 500, 50, UDim2.new(0, 5, 0, 215), function(value)
    if humanoid then
        humanoid.JumpPower = value
    end
end)

createButton("Reset Character", UDim2.new(0, 5, 0, 295), function()
    if character then
        character:BreakJoints()
    end
end)

createButton("God Mode", UDim2.new(0, 5, 0, 345), function()
    if humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

createButton("Remove Fog", UDim2.new(0, 5, 0, 395), function()
    game.Lighting.FogEnd = 100000
    game.Lighting.FogStart = 0
end)

-- Update canvas size
container.CanvasSize = UDim2.new(0, 0, 0, 450)

-- Toggle menu visibility
local menuOpen = false
toggleButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    mainFrame.Visible = menuOpen
    
    if menuOpen then
        mainFrame:TweenPosition(
            UDim2.new(0.5, -175, 0.5, -225),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Back,
            0.3,
            true
        )
    end
end)

-- Character respawn handler
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = character:WaitForChild("Humanoid")
    flying = false
    flyButton.Text = "Fly: OFF"
    flyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

print("Advanced Menu GUI Loaded! Press the MENU button to open.")
