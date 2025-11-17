-- ValkHub Script by @ItsTianzXD
-- Advanced Player Helper System
-- ©All Rights Reserved™

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables
local flyEnabled = false
local flySpeed = 50
local flyConnection = nil
local defaultWalkSpeed = 16
local defaultJumpHeight = 50
local noclipEnabled = false
local noclipConnection = nil
local infiniteJumpEnabled = false
local infiniteJumpConnection = nil

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ValkHubGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protection untuk exploit compatibility
if syn then
    syn.protect_gui(screenGui)
    screenGui.Parent = CoreGui
elseif gethui then
    screenGui.Parent = gethui()
else
    screenGui.Parent = playerGui
end

-- Create Toggle Button (RGB Triangle)
local toggleButton = Instance.new("ImageButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 60, 0, 60)
toggleButton.Position = UDim2.new(0, 20, 0.5, -30)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.BackgroundTransparency = 0.3
toggleButton.BorderSizePixel = 0
toggleButton.Parent = screenGui

-- Rounded corners for toggle button
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 12)
toggleCorner.Parent = toggleButton

-- RGB Triangle Icon
local triangleIcon = Instance.new("ImageLabel")
triangleIcon.Name = "Triangle"
triangleIcon.Size = UDim2.new(0, 35, 0, 35)
triangleIcon.Position = UDim2.new(0.5, -17.5, 0.5, -17.5)
triangleIcon.BackgroundTransparency = 1
triangleIcon.Image = "rbxassetid://3926305904"
triangleIcon.ImageColor3 = Color3.fromRGB(255, 0, 0)
triangleIcon.Rotation = 0
triangleIcon.Parent = toggleButton

-- RGB Animation for Triangle
local hue = 0
RunService.RenderStepped:Connect(function()
    hue = hue + 0.5
    if hue >= 360 then hue = 0 end
    triangleIcon.ImageColor3 = Color3.fromHSV(hue / 360, 1, 1)
    triangleIcon.Rotation = triangleIcon.Rotation + 1
end)

-- Main Hub Frame
local mainHub = Instance.new("Frame")
mainHub.Name = "MainHub"
mainHub.Size = UDim2.new(0, 650, 0, 450)
mainHub.Position = UDim2.new(0.5, -325, 0.5, -225)
mainHub.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainHub.BorderSizePixel = 0
mainHub.Visible = false
mainHub.Parent = screenGui

local mainHubCorner = Instance.new("UICorner")
mainHubCorner.CornerRadius = UDim.new(0, 15)
mainHubCorner.Parent = mainHub

-- Shadow effect
local mainHubShadow = Instance.new("ImageLabel")
mainHubShadow.Name = "Shadow"
mainHubShadow.BackgroundTransparency = 1
mainHubShadow.Position = UDim2.new(0, -15, 0, -15)
mainHubShadow.Size = UDim2.new(1, 30, 1, 30)
mainHubShadow.ZIndex = 0
mainHubShadow.Image = "rbxassetid://6014261993"
mainHubShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
mainHubShadow.ImageTransparency = 0.5
mainHubShadow.Parent = mainHub

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
topBar.BorderSizePixel = 0
topBar.Parent = mainHub

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 15)
topBarCorner.Parent = topBar

-- Fix corner bottom
local topBarFix = Instance.new("Frame")
topBarFix.Size = UDim2.new(1, 0, 0, 15)
topBarFix.Position = UDim2.new(0, 0, 1, -15)
topBarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
topBarFix.BorderSizePixel = 0
topBarFix.Parent = topBar

-- ValkHub Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.Position = UDim2.new(0, 15, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "ValkHub"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- RGB Line under title
local rgbLine = Instance.new("Frame")
rgbLine.Name = "RGBLine"
rgbLine.Size = UDim2.new(0, 100, 0, 3)
rgbLine.Position = UDim2.new(0, 15, 1, -5)
rgbLine.BorderSizePixel = 0
rgbLine.Parent = topBar

RunService.RenderStepped:Connect(function()
    rgbLine.BackgroundColor3 = Color3.fromHSV(hue / 360, 1, 1)
end)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -80, 0.5, -17.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
minimizeBtn.Text = "−"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 20
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = topBar

local minimizeBtnCorner = Instance.new("UICorner")
minimizeBtnCorner.CornerRadius = UDim.new(0, 8)
minimizeBtnCorner.Parent = minimizeBtn

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -40, 0.5, -17.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = topBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

-- Left Menu (Categories)
local leftMenu = Instance.new("Frame")
leftMenu.Name = "LeftMenu"
leftMenu.Size = UDim2.new(0, 180, 1, -50)
leftMenu.Position = UDim2.new(0, 0, 0, 50)
leftMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
leftMenu.BorderSizePixel = 0
leftMenu.Parent = mainHub

-- Right Content Area
local rightContent = Instance.new("Frame")
rightContent.Name = "RightContent"
rightContent.Size = UDim2.new(1, -180, 1, -50)
rightContent.Position = UDim2.new(0, 180, 0, 50)
rightContent.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
rightContent.BorderSizePixel = 0
rightContent.Parent = mainHub

-- ScrollingFrame for Left Menu
local leftScroll = Instance.new("ScrollingFrame")
leftScroll.Size = UDim2.new(1, -10, 1, -10)
leftScroll.Position = UDim2.new(0, 5, 0, 5)
leftScroll.BackgroundTransparency = 1
leftScroll.BorderSizePixel = 0
leftScroll.ScrollBarThickness = 4
leftScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 105)
leftScroll.Parent = leftMenu

local leftLayout = Instance.new("UIListLayout")
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.Padding = UDim.new(0, 8)
leftLayout.Parent = leftScroll

-- Function to create menu button
local function createMenuButton(name, icon, parent)
    local button = Instance.new("TextButton")
    button.Name = name .. "Btn"
    button.Size = UDim2.new(1, -10, 0, 45)
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 16
    button.TextColor3 = Color3.fromRGB(200, 200, 200)
    button.TextXAlignment = Enum.TextXAlignment.Left
    button.Text = "  " .. icon .. "  " .. name
    button.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button
    
    return button
end

-- Create menu buttons
local playerBtn = createMenuButton("Player", "👤", leftScroll)
local devBtn = createMenuButton("Dev Info", "ℹ️", leftScroll)

-- Update canvas size
leftScroll.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 10)
leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    leftScroll.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 10)
end)
-- Player Menu Content
local playerContent = Instance.new("ScrollingFrame")
playerContent.Name = "PlayerContent"
playerContent.Size = UDim2.new(1, -20, 1, -20)
playerContent.Position = UDim2.new(0, 10, 0, 10)
playerContent.BackgroundTransparency = 1
playerContent.BorderSizePixel = 0
playerContent.ScrollBarThickness = 4
playerContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 105)
playerContent.Visible = false
playerContent.Parent = rightContent

local playerLayout = Instance.new("UIListLayout")
playerLayout.SortOrder = Enum.SortOrder.LayoutOrder
playerLayout.Padding = UDim.new(0, 12)
playerLayout.Parent = playerContent

-- Dev Info Content
local devContent = Instance.new("Frame")
devContent.Name = "DevContent"
devContent.Size = UDim2.new(1, -20, 1, -20)
devContent.Position = UDim2.new(0, 10, 0, 10)
devContent.BackgroundTransparency = 1
devContent.Visible = true
devContent.Parent = rightContent

local devText = Instance.new("TextLabel")
devText.Size = UDim2.new(1, -20, 1, -20)
devText.Position = UDim2.new(0, 10, 0, 10)
devText.BackgroundTransparency = 1
devText.Text = [[Welcome to ValkHub!

Here you can make your character better and have special abilities in Roblox.

Creator: @ItsTianzXD

License: generator code
©All Rights Reserved™

Use the Player menu to access various character modifications and abilities.]]
devText.Font = Enum.Font.Gotham
devText.TextSize = 16
devText.TextColor3 = Color3.fromRGB(200, 200, 200)
devText.TextWrapped = true
devText.TextYAlignment = Enum.TextYAlignment.Top
devText.Parent = devContent

-- Function to create labeled slider
local function createSlider(name, min, max, default, callback)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, 0, 0, 70)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    container.BorderSizePixel = 0
    container.Parent = playerContent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 25)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 15
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -20, 0, 25)
    sliderBg.Position = UDim2.new(0, 10, 0, 35)
    sliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = container
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(0, 6)
    sliderBgCorner.Parent = sliderBg
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromHSV(hue / 360, 1, 1)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local sliderFillCorner = Instance.new("UICorner")
    sliderFillCorner.CornerRadius = UDim.new(0, 6)
    sliderFillCorner.Parent = sliderFill
    
    RunService.RenderStepped:Connect(function()
        sliderFill.BackgroundColor3 = Color3.fromHSV(hue / 360, 1, 1)
    end)
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(1, 0, 1, 0)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    sliderButton.Parent = sliderBg
    
    local dragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    local function updateSlider(input)
        local pos = (input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
        pos = math.clamp(pos, 0, 1)
        local value = math.floor(min + (max - min) * pos)
        
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = name .. ": " .. value
        
        if callback then callback(value) end
    end
    
    sliderButton.MouseButton1Down:Connect(function(input)
        updateSlider(input)
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    return container
end

-- Function to create toggle button
local function createToggle(name, default, callback)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, 0, 0, 50)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    container.BorderSizePixel = 0
    container.Parent = playerContent
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 10)
    containerCorner.Parent = container
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 15
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 45, 0, 25)
    toggleBtn.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 65)
    toggleBtn.Text = ""
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = container
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn
    
    local toggleCircle = Instance.new("Frame")
    toggleCircle.Size = UDim2.new(0, 19, 0, 19)
    toggleCircle.Position = default and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
    toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleCircle.BorderSizePixel = 0
    toggleCircle.Parent = toggleBtn
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(1, 0)
    circleCorner.Parent = toggleCircle
    
    local toggled = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        local newBgColor = toggled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(60, 60, 65)
        local newPos = toggled and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = newBgColor}):Play()
        TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = newPos}):Play()
        
        if callback then callback(toggled) end
    end)
    
    return container
end

-- Create Player Features
createToggle("Fly", false, function(enabled)
    flyEnabled = enabled
    if enabled then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hrp = character.HumanoidRootPart
            
            local function fly()
                local bg = Instance.new("BodyGyro", hrp)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = hrp.CFrame
                
                local bv = Instance.new("BodyVelocity", hrp)
                bv.velocity = Vector3.new(0, 0, 0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                
                flyConnection = RunService.RenderStepped:Connect(function()
                    if not flyEnabled then
                        bg:Destroy()
                        bv:Destroy()
                        if flyConnection then
                            flyConnection:Disconnect()
                        end
                        return
                    end
                    
                    local cam = workspace.CurrentCamera
                    local speed = flySpeed
                    
                    bg.cframe = cam.CFrame
                    
                    local velocity = Vector3.new(0, 0, 0)
                    
                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        velocity = velocity + (cam.CFrame.LookVector * speed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        velocity = velocity - (cam.CFrame.LookVector * speed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        velocity = velocity - (cam.CFrame.RightVector * speed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        velocity = velocity + (cam.CFrame.RightVector * speed)
                    end
                    
                    bv.velocity = velocity
                end)
            end
            
            fly()
        end
    else
        if flyConnection then
            flyConnection:Disconnect()
        end
    end
end)

createSlider("Fly Speed", 10, 200, 50, function(value)
    flySpeed = value
end)

createSlider("WalkSpeed", 16, 200, 16, function(value)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end)

createSlider("JumpPower", 50, 300, 50, function(value)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.JumpPower = value
    end
end)

createToggle("Infinite Jump", false, function(enabled)
    infiniteJumpEnabled = enabled
    if enabled then
        infiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
            if infiniteJumpEnabled then
                local character = player.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
    else
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
    end
end)

createToggle("No Clip", false, function(enabled)
    noclipEnabled = enabled
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if not noclipEnabled then
                if noclipConnection then 
                    noclipConnection:Disconnect() 
                    noclipConnection = nil
                end
                return
            end
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- Update canvas size
playerContent.CanvasSize = UDim2.new(0, 0, 0, playerLayout.AbsoluteContentSize.Y + 10)
playerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    playerContent.CanvasSize = UDim2.new(0, 0, 0, playerLayout.AbsoluteContentSize.Y + 10)
end)

-- Menu Button Click Events
playerBtn.MouseButton1Click:Connect(function()
    devContent.Visible = false
    playerContent.Visible = true
    
    -- Highlight selected
    playerBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    devBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
end)

devBtn.MouseButton1Click:Connect(function()
    playerContent.Visible = false
    devContent.Visible = true
    
    -- Highlight selected
    devBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    playerBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
end)

-- Toggle Button Functionality
toggleButton.MouseButton1Click:Connect(function()
    mainHub.Visible = not mainHub.Visible
    
    -- Animation
    if mainHub.Visible then
        mainHub.Size = UDim2.new(0, 0, 0, 0)
        mainHub.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tween = TweenService:Create(mainHub, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 650, 0, 450),
            Position = UDim2.new(0.5, -325, 0.5, -225)
        })
        tween:Play()
    end
end)

-- Close Button Functionality
closeBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(mainHub, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        mainHub.Visible = false
    end)
end)

-- Minimize Button Functionality
minimizeBtn.MouseButton1Click:Connect(function()
    local tween = TweenService:Create(mainHub, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    tween:Play()
    tween.Completed:Connect(function()
        mainHub.Visible = false
    end)
end)

-- Dragging Functionality
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    mainHub.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainHub.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Character Respawn Handler
player.CharacterAdded:Connect(function(character)
    -- Wait for humanoid
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Re-apply walkspeed and jumppower if they were changed
    wait(0.1)
    
    if humanoid.WalkSpeed ~= defaultWalkSpeed then
        -- User had custom walkspeed, let them know it needs to be reapplied
    end
    
    -- Clean up fly if it was enabled
    if flyEnabled then
        flyEnabled = false
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        end
-- Clean up noclip if it was enabled
    if noclipEnabled then
        noclipEnabled = false
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
    
    -- Clean up infinite jump if it was enabled
    if infiniteJumpEnabled then
        infiniteJumpEnabled = false
        if infiniteJumpConnection then
            infiniteJumpConnection:Disconnect()
            infiniteJumpConnection = nil
        end
    end
end)

-- Button Hover Effects
local function addHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 55)}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        if button ~= playerBtn or not playerContent.Visible then
            if button ~= devBtn or not devContent.Visible then
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play()
            end
        end
    end)
end

addHoverEffect(playerBtn)
addHoverEffect(devBtn)

-- Close button hover effect
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 70)}):Play()
end)

closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}):Play()
end)

-- Minimize button hover effect
minimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
end)

minimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(minimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
end)

-- Toggle button hover effect
toggleButton.MouseEnter:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 65, 0, 65)}):Play()
end)

toggleButton.MouseLeave:Connect(function()
    TweenService:Create(toggleButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)

-- Notification System
local function createNotification(title, message, duration)
    local notif = Instance.new("Frame")
    notif.Name = "Notification"
    notif.Size = UDim2.new(0, 300, 0, 80)
    notif.Position = UDim2.new(1, -320, 1, 100)
    notif.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    notif.BorderSizePixel = 0
    notif.Parent = screenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notif
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, -20, 0, 25)
    notifTitle.Position = UDim2.new(0, 10, 0, 5)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = title
    notifTitle.Font = Enum.Font.GothamBold
    notifTitle.TextSize = 16
    notifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.Parent = notif
    
    local notifMessage = Instance.new("TextLabel")
    notifMessage.Size = UDim2.new(1, -20, 0, 40)
    notifMessage.Position = UDim2.new(0, 10, 0, 30)
    notifMessage.BackgroundTransparency = 1
    notifMessage.Text = message
    notifMessage.Font = Enum.Font.Gotham
    notifMessage.TextSize = 14
    notifMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
    notifMessage.TextWrapped = true
    notifMessage.TextXAlignment = Enum.TextXAlignment.Left
    notifMessage.TextYAlignment = Enum.TextYAlignment.Top
    notifMessage.Parent = notif
    
    local slideIn = TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -320, 1, -100)
    })
    slideIn:Play()
    
    wait(duration or 3)
    
    local slideOut = TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Position = UDim2.new(1, -320, 1, 100)
    })
    slideOut:Play()
    slideOut.Completed:Connect(function()
        notif:Destroy()
    end)
end

-- Show welcome notification
wait(1)
createNotification("ValkHub Loaded", "Press the triangle button to open menu", 4)

-- Initialize default page
devBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)

print("ValkHub by @ItsTianzXD loaded successfully!")
print("All systems operational.")
