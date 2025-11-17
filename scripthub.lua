-- Roblox Advanced Menu GUI Script (Mobile Compatible)
-- Paste this into your executor

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local flying = false
local flySpeed = 50
local flyConnection
local character, humanoid
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Function to get character
local function getCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    return character, humanoid
end

getCharacter()

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdvancedMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

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
            task.wait(0.03)
        end
    end)
    
    return border
end

-- Fungsi Dragging Universal (Mobile & PC Compatible)
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        if dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput then
            update(input)
        end
    end)
end

-- Main Toggle Button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.5, -60, 0.05, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleButton.BackgroundTransparency = 0.3
toggleButton.BorderSizePixel = 0
toggleButton.Text = "📱 MENU"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Active = true
toggleButton.Parent = screenGui
toggleButton.ZIndex = 10

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

createRGBBorder(toggleButton)
makeDraggable(toggleButton)

-- Main Menu Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, isMobile and 340 or 360, 0, 500)
mainFrame.Position = UDim2.new(0.5, isMobile and -170 or -180, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Parent = screenGui
mainFrame.ZIndex = 5

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

createRGBBorder(mainFrame)
makeDraggable(mainFrame)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame
titleBar.ZIndex = 6

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "⚡ ADVANCED MENU"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar
title.ZIndex = 6

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -45, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.BackgroundTransparency = 0.3
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar
closeButton.ZIndex = 7

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -90, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
minimizeButton.BackgroundTransparency = 0.3
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "─"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = titleBar
minimizeButton.ZIndex = 7

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

-- Container
local container = Instance.new("ScrollingFrame")
container.Size = UDim2.new(1, -20, 1, -70)
container.Position = UDim2.new(0, 10, 0, 60)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.ScrollBarThickness = 6
container.CanvasSize = UDim2.new(0, 0, 0, 500)
container.Parent = mainFrame
container.ZIndex = 6

-- Mobile Control Buttons (Joystick Style)
local mobileControls = Instance.new("Frame")
mobileControls.Name = "MobileControls"
mobileControls.Size = UDim2.new(0, 200, 0, 200)
mobileControls.Position = UDim2.new(0, 20, 1, -220)
mobileControls.BackgroundTransparency = 1
mobileControls.Visible = false
mobileControls.Parent = screenGui
mobileControls.ZIndex = 15

-- Joystick Background
local joystickBg = Instance.new("Frame")
joystickBg.Size = UDim2.new(0, 150, 0, 150)
joystickBg.Position = UDim2.new(0.5, -75, 0.5, -75)
joystickBg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
joystickBg.BackgroundTransparency = 0.5
joystickBg.BorderSizePixel = 0
joystickBg.Parent = mobileControls
joystickBg.ZIndex = 16

local joystickBgCorner = Instance.new("UICorner")
joystickBgCorner.CornerRadius = UDim.new(1, 0)
joystickBgCorner.Parent = joystickBg

createRGBBorder(joystickBg)

-- Joystick Stick
local joystickStick = Instance.new("Frame")
joystickStick.Size = UDim2.new(0, 60, 0, 60)
joystickStick.Position = UDim2.new(0.5, -30, 0.5, -30)
joystickStick.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
joystickStick.BackgroundTransparency = 0.3
joystickStick.BorderSizePixel = 0
joystickStick.Parent = joystickBg
joystickStick.ZIndex = 17

local joystickStickCorner = Instance.new("UICorner")
joystickStickCorner.CornerRadius = UDim.new(1, 0)
joystickStickCorner.Parent = joystickStick

createRGBBorder(joystickStick)

-- Up/Down Buttons
local upButton = Instance.new("TextButton")
upButton.Size = UDim2.new(0, 60, 0, 60)
upButton.Position = UDim2.new(1, -70, 0, 10)
upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
upButton.BackgroundTransparency = 0.3
upButton.BorderSizePixel = 0
upButton.Text = "▲"
upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
upButton.TextSize = 24
upButton.Font = Enum.Font.GothamBold
upButton.Parent = mobileControls
upButton.ZIndex = 16

local upCorner = Instance.new("UICorner")
upCorner.CornerRadius = UDim.new(0.3, 0)
upCorner.Parent = upButton

local downButton = Instance.new("TextButton")
downButton.Size = UDim2.new(0, 60, 0, 60)
downButton.Position = UDim2.new(1, -70, 1, -70)
downButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
downButton.BackgroundTransparency = 0.3
downButton.BorderSizePixel = 0
downButton.Text = "▼"
downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
downButton.TextSize = 24
downButton.Font = Enum.Font.GothamBold
downButton.Parent = mobileControls
downButton.ZIndex = 16

local downCorner = Instance.new("UICorner")
downCorner.CornerRadius = UDim.new(0.3, 0)
downCorner.Parent = downButton

-- Mobile Fly Variables
local flyDirection = Vector3.new(0, 0, 0)
local movingUp = false
local movingDown = false
local joystickActive = false

-- Fungsi untuk membuat button
local function createButton(text, position, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 45)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.BackgroundTransparency = 0.3
    button.BorderSizePixel = 0
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.GothamBold
    button.Parent = container
    button.ZIndex = 7
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    return button
end

-- Fungsi untuk membuat slider
local function createSlider(labelText, minVal, maxVal, defaultVal, position, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -10, 0, 75)
    sliderFrame.Position = position
    sliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    sliderFrame.BackgroundTransparency = 0.3
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = container
    sliderFrame.ZIndex = 7
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = sliderFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 28)
    label.Position = UDim2.new(0, 5, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = labelText .. ": " .. defaultVal
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = sliderFrame
    label.ZIndex = 8
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Size = UDim2.new(1, -20, 0, 8)
    sliderBar.Position = UDim2.new(0, 10, 0, 42)
    sliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    sliderBar.BorderSizePixel = 0
    sliderBar.Parent = sliderFrame
    sliderBar.ZIndex = 8
    
    local sliderBarCorner = Instance.new("UICorner")
    sliderBarCorner.CornerRadius = UDim.new(1, 0)
    sliderBarCorner.Parent = sliderBar
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBar
    sliderFill.ZIndex = 9
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    createRGBBorder(sliderFill)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 18, 0, 18)
    sliderButton.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -9, 0.5, -9)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = sliderBar
    sliderButton.ZIndex = 10
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = sliderButton
    
    createRGBBorder(sliderButton)
    
    local sliding = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local value = math.floor(minVal + (maxVal - minVal) * pos)
        
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        sliderButton.Position = UDim2.new(pos, -9, 0.5, -9)
        label.Text = labelText .. ": " .. value
        
        pcall(callback, value)
    end
    
    sliderButton.MouseButton1Down:Connect(function()
        sliding = true
    end)
    
    sliderButton.TouchTap:Connect(function()
        sliding = true
    end)
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
    
    return sliderFrame
end

-- Fly Function (Mobile & PC Compatible)
local function startFly()
    pcall(function()
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            getCharacter()
        end
        
        local hrp = character.HumanoidRootPart
        
        -- Remove old fly objects
        for _, v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                v:Destroy()
            end
        end
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = hrp
        
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bodyGyro.P = 9e4
        bodyGyro.Parent = hrp
        
        local camera = workspace.CurrentCamera
        
        if flyConnection then
            flyConnection:Disconnect()
        end
        
        -- Show mobile controls if on mobile
        if isMobile then
            mobileControls.Visible = true
        end
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if flying and character and hrp and hrp.Parent then
                local direction = Vector3.new()
                
                -- PC Controls
                if not isMobile then
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
                else
                    -- Mobile Controls (Joystick + Up/Down buttons)
                    direction = flyDirection
                    
                    if movingUp then
                        direction = direction + Vector3.new(0, 1, 0)
                    end
                    if movingDown then
                        direction = direction + Vector3.new(0, -1, 0)
                    end
                end
                
                if direction.Magnitude > 0 then
                    bodyVelocity.Velocity = direction.Unit * flySpeed
                else
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
                
                bodyGyro.CFrame = camera.CFrame
            end
        end)
    end)
end

local function stopFly()
    pcall(function()
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        mobileControls.Visible = false
        flyDirection = Vector3.new(0, 0, 0)
        movingUp = false
        movingDown = false
        
        if character and character:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(character.HumanoidRootPart:GetChildren()) do
                if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then
                    v:Destroy()
                end
            end
        end
    end)
end

-- Mobile Joystick Controls
local joystickDragging = false
joystickBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        joystickDragging = true
        joystickActive = true
    end
end)

joystickBg.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        joystickDragging = false
        joystickActive = false
        joystickStick.Position = UDim2.new(0.5, -30, 0.5, -30)
        flyDirection = Vector3.new(0, 0, 0)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if joystickDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local center = joystickBg.AbsolutePosition + joystickBg.AbsoluteSize / 2
        local direction = Vector2.new(input.Position.X - center.X, input.Position.Y - center.Y)
        local distance = math.min(direction.Magnitude, 45)
        
        if direction.Magnitude > 0 then
            direction = direction.Unit * distance
            joystickStick.Position = UDim2.new(0.5, direction.X - 30, 0.5, direction.Y - 30)
            
            local camera = workspace.CurrentCamera
            local normalized = direction / 45
            flyDirection = (camera.CFrame.LookVector * -normalized.Y) + (camera.CFrame.RightVector * normalized.X)
        end
    end
end)

-- Up/Down Button Controls
upButton.MouseButton1Down:Connect(function() movingUp = true end)
upButton.MouseButton1Up:Connect(function() movingUp = false end)
upButton.TouchTap:Connect(function() movingUp = not movingUp end)

downButton.MouseButton1Down:Connect(function() movingDown = true end)
downButton.MouseButton1Up:Connect(function() movingDown = false end)
downButton.TouchTap:Connect(function() movingDown = not movingDown end)

-- Buttons dan Sliders
local flyButton = createButton("✈️ Fly: OFF", UDim2.new(0, 5, 0, 5), function()
    flying = not flying
    flyButton.Text = flying and "✈️ Fly: ON" or "✈️ Fly: OFF"
    flyButton.BackgroundColor3 = flying and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
    
    if flying then
        startFly()
    else
        stopFly()
    end
end)

createSlider("Fly Speed", 10, 200, 50, UDim2.new(0, 5, 0, 60), function(value)
    flySpeed = value
end)

createSlider("WalkSpeed", 16, 200, 16, UDim2.new(0, 5, 0, 145), function(value)
    if humanoid then
        humanoid.WalkSpeed = value
    end
end)

createSlider("Jump Height", 50, 500, 50, UDim2.new(0, 5, 0, 230), function(value)
    if humanoid then
        humanoid.JumpPower = value
        humanoid.UseJumpPower = true
    end
end)

createButton("Reset Character", UDim2.new(0, 5, 0, 315), function()
    if character then
        character:BreakJoints()
    end
end)

local godModeEnabled = false
createButton("God Mode: OFF", UDim2.new(0, 5, 0, 370), function()
    godModeEnabled = not godModeEnabled
    local godButton = container:FindFirstChild("God Mode: OFF") or container:FindFirstChild("🛡️ God Mode: ON")
    
    if godButton then
        godButton.Text = godModeEnabled and "God Mode: ON" or "🛡️ God Mode: OFF"
        godButton.BackgroundColor3 = godModeEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(30, 30, 30)
    end
    
    if godModeEnabled and humanoid then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end)

createButton("Remove Fog", UDim2.new(0, 5, 0, 425), function()
    local lighting = game:GetService("Lighting")
    lighting.FogEnd = 100000
    lighting.FogStart = 0
    lighting.Brightness = 2
end)

-- Close & Minimize functionality
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleButton.Text = "MENU"
end)

minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleButton.Text = "MENU"
end)

-- Hover effects
closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
end)

minimizeButton.MouseEnter:Connect(function()
    minimizeButton.BackgroundColor3 = Color3.fromRGB(70, 140, 220)
end)

minimizeButton.MouseLeave:Connect(function()
    minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
end)

-- Toggle menu visibility
local menuOpen = false
toggleButton.MouseButton1Click:Connect(function()
    menuOpen = not menuOpen
    mainFrame.Visible = menuOpen
    toggleButton.Text = menuOpen and "OPEN" or "MENU"
end)

-- Character respawn handler
player.CharacterAdded:Connect(function(char)
    getCharacter()
    flying = false
    godModeEnabled = false
    
    if flyButton then
        flyButton.Text = "Fly: OFF"
        flyButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    end
    
    stopFly()
    end

-- Cleanup on GUI destroy
screenGui.AncestryChanged:Connect(function()
    if not screenGui.Parent then
        stopFly()
    end
end)

print("ValkHub Loaded! and Activated!")
