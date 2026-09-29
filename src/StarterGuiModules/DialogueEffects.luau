local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local TS = game:GetService("TweenService")
local module = {}

function module.createDefaultBackgroud() 
     local exisiting = plr.PlayerGui:FindFirstChild("DialogueGui")
    if exisiting then exisiting:Destroy() end

    local Holder = Instance.new("ScreenGui")
    Holder.Parent = plr.PlayerGui
    Holder.Name = "Background"
	Holder.IgnoreGuiInset = true

    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = Holder
    MainFrame.Size = UDim2.new(1,0,1,0)
    MainFrame.AnchorPoint = Vector2.new(0, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

    local DialogueFrame = Instance.new("Frame")
    DialogueFrame.Name = "DialogueFrame"
    DialogueFrame.Parent = MainFrame
    DialogueFrame.Size = UDim2.new(.85, 0, .25, 0)
    DialogueFrame.Position = UDim2.new(.5, 0, .9, 0)
    DialogueFrame.AnchorPoint = Vector2.new(0.5, 1)
    DialogueFrame.BackgroundTransparency = .8
    
    local DialogueLabel = Instance.new("TextLabel")
    DialogueLabel.Parent = DialogueFrame
    DialogueFrame.Name = "DialogueFrame"
    DialogueFrame.Position = UDim2.new(.5, 0., .5, 0)
    DialogueLabel.Size = UDim2.new(1, 0, 1, 0)
    DialogueLabel.AnchorPoint = Vector2.new(.5, .5)
    DialogueLabel.BackgroundTransparency = 1
    DialogueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    DialogueLabel.TextSize = 22
    DialogueLabel.Font = Enum.Font.SourceSans
    DialogueLabel.TextXAlignment = Enum.TextXAlignment.Left
    DialogueLabel.TextYAlignment = Enum.TextYAlignment.Top
    DialogueLabel.Text = "Hello world"
    DialogueLabel.TextWrapped = true

    local NameFrame = Instance.new("Frame")
    NameFrame.Name = "NameFrame"
    NameFrame.Size = UDim2.new(.2, 0, .3, 0)
    NameFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    NameFrame.Parent = DialogueFrame

    local NameCorner = Instance.new("UICorner")
    NameFrame.CornerRadius = UDim.new(0, 8)
    NameFrame.Parent = NameFrame

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextSize = 18
    NameLabel.Font = Enum.Font.SourceSansBold
    NameLabel.Text = "Speaker"
    NameLabel.Parent = DialogueFrame
    NameLabel.Size = UDim2.new(1, 0, .1, 0)
    NameLabel.AnchorPoint = Vector2.new(0.5, 0.2)
    NameLabel.BackgroundTransparency = .8

    return DialogueLabel, NameLabel
end

function module.TypeWriter(object, speed, dialogue, options)
   
    options = options or {}

    local wobble = options.Wobble or false
    local punctuationPause = options.punctuationPause or false

    for i = 1, #dialogue do
        object.Text = string.sub(dialogue, 1, i)
        local character = string.sub(dialogue, 1, i)

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
end

return module