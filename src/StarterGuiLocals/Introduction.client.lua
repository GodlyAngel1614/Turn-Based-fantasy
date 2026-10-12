local DialogueEffects = require(script.Parent.Modules.DialogueEffects)
local DialogueLabel, NameLabel = DialogueEffects.createDefaultBackgroud()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueModule = require(ReplicatedStorage.Shared.Dialogues)
local UserInputService = game:GetService("UserInputService")
local currentIndex = 1
local Typewriter = ReplicatedStorage.Sounds:FindFirstChild("typewriter")
local Entry = ReplicatedStorage.Sounds:FindFirstChild("Entry")
local TweenService = game:GetService("TweenService")
local MainTheme = ReplicatedStorage.Sounds:FindFirstChild("main theme")
MainTheme:Play()

local function endDialog()
    if currentIndex >= #DialogueModule.get("Introductions").Dialogue then
        print("The dialog is over ")
        Entry:Play()


        return true
    end

    return false
end

local function progress(index) 
    if endDialog() then return end

    DialogueEffects.TypeWriter(
        DialogueLabel,
        .01,
         DialogueModule.get("Introductions").Dialogue[index],
        {
            punctuationPause = true,
            Sound = Typewriter,
        }
    )

    endDialog()
end



progress(currentIndex)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end

    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        currentIndex += 1
        progress(currentIndex)

        print("Currentindex: ", currentIndex)
    end
end)