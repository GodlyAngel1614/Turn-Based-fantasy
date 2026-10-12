local DialogueController = {}
DialogueController.Dialogue = {
    ["Introductions"] = {
        Voicelines = {

        },

        Dialogue = {
            [1] = "Hey... Hey! You're breathing right? You're alive?",
            [2] = "...",
            [3] = "I can hear your heartbeating, you know.",
            [4] = "Playing the silent game?",
            [5] = "Fine! Be that way. I didn't want to talk to you anyways.",
        }
    }
}

local function createSoundObject(soundData)
    soundData = soundData or {}    
    
     local NewSoundObj = Instance.new("Sound")
     NewSoundObj.Name = soundData.Name or "/"
     NewSoundObj.SoundId = soundData.SoundId or "/"
     NewSoundObj.Parent = soundData.Parent or game:GetService("SoundService")

     return NewSoundObj
end

function DialogueController.EchoSoundEffect(soundData) 
    local sound = createSoundObject(soundData)
    local EchoEffect = Instance.new("Echo")
end

function DialogueController.get(treeCall) 
    for dataName, data in DialogueController.Dialogue do 
        if treeCall == dataName then
            return data
        else
            warn("Could not find dialogue data for the tree value called")
        end
    end
end

return DialogueController 