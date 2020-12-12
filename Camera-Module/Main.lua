local Utility = require(game:GetService("ReplicatedStorage"):WaitForChild("Utilities"):WaitForChild("ModuleScripts").MainUtilityScript)
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local AmountOfValues = 100
local Shake = {}
local TableOfKeys = {["Player"] = 0, ["Time"] = 0, ["Precision"] = 0, ["Margin"] = 0}
local DefaultValues = {
    ["Precision"] = AmountOfValues,
    ["Time"] = 1,
    ["Margin"] = 5,
}
setmetatable(DefaultValues,{
    __call = function(GivenTable) 
        warn("Improper argument given, reverting to DefaultValues")
        local Copy = DefaultValues
        for i, v in pairs(GivenTable) do 
            Copy[i] = v
        end
        return Copy 
    end})
 
Shake.__index = Shake
 
local function CheckTable(Table)
    for i, v in pairs(TableOfKeys) do
        if Table[i] then
            continue
        end
        return false
    end
    return Table
end
 
local function AddRandomValues(Percision, Margin)
    local Values = {}
    local DivideBy = Percision * Margin
    local RandomIndex = math.random
    for i = 1, AmountOfValues do
        Values[i] = {RandomIndex(-Percision, Percision)/DivideBy, RandomIndex(-Percision, Percision)/DivideBy, RandomIndex(-Percision, Percision)/DivideBy}
    end
    return Values
end
 
function Shake.New(Info) -- Player, Precision, Time, Margin
    Info = (type(Info) == "table" and CheckTable(Info)) or DefaultValues(Info)
    
    local Player = Info["Player"] or warn("Player not specified")
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    return setmetatable({
        ["RandomValues"] = AddRandomValues(Info["Precision"], Info["Margin"]),      
        ["Time"] = Info["Time"],
        ["Humanoid"] = Humanoid,
        ["Playing"] = false,
        ["ForceStop"] = false,
        
    }, Shake)
end
 
function Shake:Play()
    if self.Playing then return end
    self.Playing = true
    local Humanoid = self.Humanoid
    local Randomized = self.RandomValues
    local TimeNow = os.clock()
    local EndTime = self.Time + TimeNow
    
    local function MainShake()
        local current = Randomized[math.random(1, AmountOfValues)]
        Humanoid.CameraOffset = Vector3.new(current[1], current[2], current[3])
        TimeNow = os.clock()
    end
    
    while TimeNow <= EndTime and not self.ForceStop do 
        Utility.CustomDelay(MainShake)-- custom delay for a function
    end
    if self.ForceStop then
        self.ForceStop = false
    end
    self.Playing = false
end
 
function Shake:WaitTillEnd()
    repeat Utility.CustomDelay() until not self.Playing
    return true
end
 
function Shake:IsPlaying()
    return self.Playing
end
 
function Shake:Stop()
    self.ForceStop = true
    return true
end
 
function Shake:SetDefaultValue(index, value)
    DefaultValues[index] = value
end
return Shake
