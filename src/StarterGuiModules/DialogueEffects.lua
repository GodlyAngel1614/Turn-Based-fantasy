local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local TS = game:GetService("TweenService")
local module = {}

function module.createDefaultBackgroud() 
    local existing = plr.PlayerGui:FindFirstChild("DialogueGui")
    if existing then existing:Destroy() end

    local Holder = Instance.new("ScreenGui")
    Holder.Parent = plr.PlayerGui
    Holder.Name = "DialogueGui"
    Holder.IgnoreGuiInset = true
    Holder.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = Holder
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = .1 

    local DialogueFrame = Instance.new("Frame")
    DialogueFrame.Name = "DialogueFrame"
    DialogueFrame.Parent = MainFrame
    DialogueFrame.Size = UDim2.new(0.8, 0, 0.22, 0)
    DialogueFrame.Position = UDim2.new(0.5, 0, 0.92, 0)
    DialogueFrame.AnchorPoint = Vector2.new(0.5, 1)
    DialogueFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    DialogueFrame.BackgroundTransparency = 0.25

    local DialogueCorner = Instance.new("UICorner")
    DialogueCorner.CornerRadius = UDim.new(0, 12)
    DialogueCorner.Parent = DialogueFrame

    local DialogueStroke = Instance.new("UIStroke")
    DialogueStroke.Color = Color3.fromRGB(100, 100, 120)
    DialogueStroke.Thickness = 2
    DialogueStroke.Parent = DialogueFrame

    local DialoguePadding = Instance.new("UIPadding")
    DialoguePadding.PaddingTop = UDim.new(0, 18)
    DialoguePadding.PaddingBottom = UDim.new(0, 18)
    DialoguePadding.PaddingLeft = UDim.new(0, 24)
    DialoguePadding.PaddingRight = UDim.new(0, 24)
    DialoguePadding.Parent = DialogueFrame

    local DialogueLabel = Instance.new("TextLabel")
    DialogueLabel.Name = "DialogueLabel"
    DialogueLabel.Parent = DialogueFrame
    DialogueLabel.Size = UDim2.new(1, 0, 1, 0)
    DialogueLabel.BackgroundTransparency = 1
    DialogueLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    DialogueLabel.TextSize = 20
    DialogueLabel.Font = Enum.Font.SourceSans
    DialogueLabel.TextXAlignment = Enum.TextXAlignment.Left
    DialogueLabel.TextYAlignment = Enum.TextYAlignment.Top
    DialogueLabel.Text = "Hello world"
    DialogueLabel.TextWrapped = true

    local NameFrame = Instance.new("Frame")
    NameFrame.Name = "NameFrame"
    NameFrame.Parent = DialogueFrame
    NameFrame.Size = UDim2.new(0.22, 0, 0, 36)
    NameFrame.Position = UDim2.new(0, 0, 0, -65)
    NameFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)

    local NameCorner = Instance.new("UICorner")
    NameCorner.CornerRadius = UDim.new(0, 8)
    NameCorner.Parent = NameFrame

    local NameStroke = Instance.new("UIStroke")
    NameStroke.Color = Color3.fromRGB(100, 100, 120)
    NameStroke.Thickness = 1.5
    NameStroke.Parent = NameFrame

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Parent = NameFrame
    NameLabel.Size = UDim2.new(1, 0, 1, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextSize = 18
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.Text = "Speaker"
    NameLabel.TextXAlignment = Enum.TextXAlignment.Center
    NameLabel.TextYAlignment = Enum.TextYAlignment.Center

    return DialogueLabel, NameLabel
end

function module.TypeWriter(object, speed, dialogue, options)
    options = options or {}
    local wobble = options.Wobble or false
    local punctuationPause = options.punctuationPause or false
    local sound = options.Sound
    local waterEffect = options.waterEffect or false
    local underwaterSound = options.underwaterSound or false -- New setting

    local originalPos = object.Position
    local lastSoundTick = 0
    local soundCooldown = 0.05 

    local originalColor = object.TextColor3
    local waterColors = {
        Color3.fromRGB(30, 144, 255),
        Color3.fromRGB(0, 229, 255),
        Color3.fromRGB(100, 200, 255)
    }

    local connection
    local startTime = tick()

    if waterEffect then
        local RunService = game:GetService("RunService")
        connection = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local yOffset = math.sin(elapsed * 8) * 4
            local xOffset = math.cos(elapsed * 4) * 2
            
            if not wobble then
                object.Position = originalPos + UDim2.new(0, xOffset, 0, yOffset)
            end

            local colorIndex = (math.floor(elapsed * 3) % #waterColors) + 1
            local nextColorIndex = (colorIndex % #waterColors) + 1
            local alpha = (elapsed * 3) % 1
            object.TextColor3 = waterColors[colorIndex]:Lerp(waterColors[nextColorIndex], alpha)
        end)
    end

    for i = 1, #dialogue do
        object.Text = string.sub(dialogue, 1, i)
        local character = string.sub(dialogue, i, i) 

        if sound and character ~= " " and (tick() - lastSoundTick >= soundCooldown) then
            lastSoundTick = tick()
            local s = sound:Clone()
            
            if underwaterSound then
                local lowPass = Instance.new("LowPassFilterEffect")
                lowPass.CutoffFrequency = 500
                lowPass.Parent = s

                local reverb = Instance.new("ReverbSoundEffect")
                reverb.DecayTime = 1.5
                reverb.Density = 1
                reverb.Parent = s
            end

            s.Parent = object
            s:Play()
            task.delay(0.5, function()
                s:Destroy()
            end)
        end

        if wobble then
            object.Position = originalPos + UDim2.new(0, math.random(-1, 1), 0, math.random(-1, 1))
        end

        if punctuationPause then
            if character == "." or character == "!" or character == "?" then
                task.wait(speed * 4)
            elseif character == "," then
                task.wait(speed * 2)
            else
                task.wait(speed)
            end
        else
            task.wait(speed)
        end
    end

    if connection then
        connection:Disconnect()
    end
    object.Position = originalPos
    object.TextColor3 = originalColor
end

function module.createVignette()
    local existing = plr.PlayerGui:FindFirstChild("Vignette")
    if existing then existing:Destroy() end

    local Holder = Instance.new("ScreenGui")
    Holder.Parent = plr.PlayerGui
    Holder.Name = "Vignette"
    Holder.IgnoreGuiInset = true
    Holder.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = Holder
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    MainFrame.BackgroundTransparency = 0

    return MainFrame
end

return module