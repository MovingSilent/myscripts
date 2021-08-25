-- Beams SilentAim creddits to Rus
local accomidationfactor = 0.165

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

local SilentAim = loadstring(game:HttpGet("https://raw.githubusercontent.com/MovingSilent/myscripts/main/Uh.lua"))()
SilentAim.TeamCheck = false

local mt = getrawmetatable(game)
local backupindex = mt.__index
setreadonly(mt, false)


SilentAim.checkSilentAim = function()
    local checkA = (SilentAim.SilentAimEnabled == true and SilentAim.Selected ~= LocalPlayer)
    local playerCharacter = SilentAim.Selected.Character
    local daHood = (playerCharacter.BodyEffects["K.O"].Value == false or playerCharacter:FindFirstChild("GRABBING_CONSTRAINT") ~= nil)

    return (checkA and daHood)
end


mt.__index = newcclosure(function(t, k)
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target")) then
        local CPlayer = SilentAim.Selected
        if (SilentAim.checkSilentAim()) then
            if (CPlayer.Character:FindFirstChild("Head")) then
                return (k == "Hit" and CPlayer.Character.Head.CFrame+(CPlayer.Character.Head.Velocity*accomidationfactor) or CPlayer.Character.Head.CFrame+(CPlayer.Character.Head.Velocity*accomidationfactor))
            end
        end
    end
    return backupindex(t, k)
end)


setreadonly(mt, true)

while wait() do
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local Value = tostring(ping)
    local PingNumber = pingValue[1]
    
    accomidationfactor = PingNumber/1000 + 0.1

end