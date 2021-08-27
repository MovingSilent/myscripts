---Made By Beam creddit to Stefanuk12 for source re-edited version of SIlent AIm 
if getgenv().ValiantAimHacks then return getgenv().ValiantAimHacks end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")

local Heartbeat = RunService.Heartbeat
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Drawingnew = Drawing.new
local Color3fromRGB = Color3.fromRGB
local Vector2new = Vector2.new
local GetGuiInset = GuiService.GetGuiInset
local Randomnew = Random.new
local mathfloor = math.floor
local CharacterAdded = LocalPlayer.CharacterAdded
local CharacterAddedWait = CharacterAdded.Wait
local WorldToViewportPoint = CurrentCamera.WorldToViewportPoint
local RaycastParamsnew = RaycastParams.new
local EnumRaycastFilterTypeBlacklist = Enum.RaycastFilterType.Blacklist
local Raycast = Workspace.Raycast
local GetPlayers = Players.GetPlayers
local Instancenew = Instance.new
local IsDescendantOf = Instancenew("Part").IsDescendantOf
local FindFirstChildWhichIsA = Instancenew("Part").FindFirstChildWhichIsA
local FindFirstChild = Instancenew("Part").FindFirstChild

getgenv().ValiantAimHacks = {
    SilentAimEnabled = true,
    ShowFOV = true,
    FOVSides = 12,
    VisibleCheck = true,
    TeamCheck = true,
    FOV = 30,
    HitChance = 100,
    Selected = LocalPlayer,
    SelectedPart = nil,
    TargetPart = {"Head", "HumanoidRootPart"},
    BlacklistedTeams = {
        {
            Team = LocalPlayer.Team,
            TeamColor = LocalPlayer.TeamColor,
        },
    },
    BlacklistedPlayers = {LocalPlayer},
    WhitelistedPUIDs = {91318356},
}
local ValiantAimHacks = getgenv().ValiantAimHacks

local circle = Drawingnew("Circle")
circle.Transparency = 0
circle.Thickness = 0
circle.Color = Color3fromRGB(231, 84, 128)
circle.Filled = false
function ValiantAimHacks.updateCircle()
    if (circle) then
        
        circle.Visible = ValiantAimHacks.ShowFOV
        circle.Radius = (ValiantAimHacks.FOV * 3)
        circle.Position = Vector2new(Mouse.X, Mouse.Y + GetGuiInset(GuiService).Y)
        circle.NumSides = ValiantAimHacks.FOVSides

        
        return circle
    end
end


local calcChance = function(percentage)
    percentage = mathfloor(percentage)
    local chance = mathfloor(Randomnew().NextNumber(Randomnew(), 0, 1) * 100) / 100
    return chance <= percentage / 100
end


function ValiantAimHacks.isPartVisible(Part, PartDescendant)

    local Character = LocalPlayer.Character or CharacterAddedWait(CharacterAdded)
    local Origin = CurrentCamera.CFrame.Position
    local _, OnScreen = WorldToViewportPoint(CurrentCamera, Part.Position)


    if (OnScreen) then
    
        local raycastParams = RaycastParamsnew()
        raycastParams.FilterType = EnumRaycastFilterTypeBlacklist
        raycastParams.FilterDescendantsInstances = {Character, CurrentCamera}

        local Result = Raycast(Workspace, Origin, Part.Position - Origin, raycastParams)
        if (Result) then
            local PartHit = Result.Instance
            local Visible = (not PartHit or IsDescendantOf(PartHit, PartDescendant))

        
            return Visible
        end
    end


    return false
end


function ValiantAimHacks.checkTeam(targetPlayerA, targetPlayerB)
    
    if (targetPlayerA.Team ~= targetPlayerB.Team) then

        -- // Check if team is blacklisted
        for i = 1, #ValiantAimHacks.BlacklistedTeams do
            local v = ValiantAimHacks.BlacklistedTeams

            if (targetPlayerA.Team ~= v.Team and targetPlayerA.TeamColor ~= v.TeamColor) then
                return true
            end
        end
    end


    return false
end


function ValiantAimHacks.checkPlayer(targetPlayer)
    for i = 1, #ValiantAimHacks.BlacklistedPlayers do
        local v = ValiantAimHacks.BlacklistedPlayers[i]

        if (v ~= targetPlayer) then
            return true
        end
    end


    return false
end


function ValiantAimHacks.checkWhitelisted(targetPlayer)
    for i = 1, #ValiantAimHacks.WhitelistedPUIDs do
        local v = ValiantAimHacks.WhitelistedPUIDs[i]

        if (targetPlayer.UserId == v) then
            return true
        end
    end

 
    return false
end


function ValiantAimHacks.BlacklistPlayer(Player)
    local BlacklistedPlayers = ValiantAimHacks.BlacklistedPlayers


    for i = 1, #BlacklistedPlayers do
        local BlacklistedPlayer = BlacklistedPlayers[i]

        if (BlacklistedPlayer == Player) then
            return false
        end
    end

 
    BlacklistedPlayers[#BlacklistedPlayers + 1] = Player
    return true
end


function ValiantAimHacks.UnblacklistPlayer(Player)
    local BlacklistedPlayers = ValiantAimHacks.BlacklistedPlayers

    
    for i = 1, #BlacklistedPlayers do
        local BlacklistedPlayer = BlacklistedPlayers[i]

        if (BlacklistedPlayer == Player) then
            table.remove(BlacklistedPlayer, i)
            return true
        end
    end


    return false
end

function ValiantAimHacks.WhitelistPlayer(PlayerId)
    local WhitelistedPUIDs = ValiantAimHacks.WhitelistedPUIDs

    
    for i = 1, #WhitelistedPUIDs do
        local WhitelistedPUID = WhitelistedPUIDs[i]

        if (WhitelistedPUID == PlayerId) then
            return false
        end
    end


    WhitelistedPUIDs[#WhitelistedPUIDs + 1] = PlayerId
    return true
end


function ValiantAimHacks.UnwhitelistPlayer(PlayerId)
    local WhitelistedPUIDs = ValiantAimHacks.WhitelistedPUIDs

    
    for i = 1, #WhitelistedPUIDs do
        local WhitelistedPUID = WhitelistedPUIDs[i]

        if (WhitelistedPUID == PlayerId) then
            table.remove(WhitelistedPUID, i)
            return true
        end
    end


    return false
end


function ValiantAimHacks.findDirectionNormalMaterial(Origin, Destination, UnitMultiplier)
    if (typeof(Origin) == "Vector3" and typeof(Destination) == "Vector3") then
        
        if (not UnitMultiplier) then UnitMultiplier = 1 end

       
        local Direction = (Destination - Origin).Unit * UnitMultiplier
        local RaycastResult = Raycast(Workspace, Origin, Direction)

        if (RaycastResult ~= nil) then
            local Normal = RaycastResult.Normal
            local Material = RaycastResult.Material

            return Direction, Normal, Material
        end
    end

   
    return nil
end

function ValiantAimHacks.getCharacter(Player)
    return Player.Character
end


function ValiantAimHacks.checkHealth(Player)
    local Character = ValiantAimHacks.getCharacter(Player)
    local Humanoid = FindFirstChildWhichIsA(Character, "Humanoid")

    local Health = (Humanoid and Humanoid.Health or 0)
    return Health > 0
end


function ValiantAimHacks.checkSilentAim()
    return (ValiantAimHacks.SilentAimEnabled == true and ValiantAimHacks.Selected ~= LocalPlayer and ValiantAimHacks.SelectedPart ~= nil)
end


function ValiantAimHacks.getClosestTargetPartToCursor(Character)
    local TargetParts = ValiantAimHacks.TargetPart


    local ClosestPart = nil
    local ClosestPartPosition = nil
    local ClosestPartOnScreen = false
    local ClosestPartMagnitudeFromMouse = nil
    local ShortestDistance = 1/0

    
    local function checkTargetPart(TargetPartName)
        local TargetPart = FindFirstChild(Character, TargetPartName)

        if (TargetPart) then
            local PartPos, onScreen = WorldToViewportPoint(CurrentCamera, TargetPart.Position)
            local Magnitude = (Vector2new(PartPos.X, PartPos.Y) - Vector2new(Mouse.X, Mouse.Y)).Magnitude

            if (Magnitude < ShortestDistance) then
                ClosestPart = TargetPart
                ClosestPartPosition = PartPos
                ClosestPartOnScreen = onScreen
                ClosestPartMagnitudeFromMouse = Magnitude
                ShortestDistance = Magnitude
            end
        end
    end

   
    if (typeof(TargetParts) == "string") then
        checkTargetPart(TargetParts)
    end

  
    if (typeof(TargetParts) == "table") then
        for i = 1, #TargetParts do
            local TargetPartName = TargetParts[i]
            checkTargetPart(TargetPartName)
        end
    end


    return ClosestPart, ClosestPartPosition, ClosestPartOnScreen, ClosestPartMagnitudeFromMouse
end


function ValiantAimHacks.getClosestPlayerToCursor()
 
    local TargetPart = nil
    local ClosestPlayer = nil
    local Chance = calcChance(ValiantAimHacks.HitChance)
    local ShortestDistance = 1/0


    if (not Chance) then
        ValiantAimHacks.Selected = LocalPlayer
        ValiantAimHacks.SelectedPart = nil

        return LocalPlayer
    end


    local AllPlayers = GetPlayers(Players)
    for i = 1, #AllPlayers do
        local Player = AllPlayers[i]
        local Character = ValiantAimHacks.getCharacter(Player)

        if (not ValiantAimHacks.checkWhitelisted(Player) and ValiantAimHacks.checkPlayer(Player) and Character) then
            local TargetPartTemp, PartPos, onScreen, Magnitude = ValiantAimHacks.getClosestTargetPartToCursor(Character)

            if (TargetPartTemp and ValiantAimHacks.checkHealth(Player)) then
               
                if (ValiantAimHacks.TeamCheck and not ValiantAimHacks.checkTeam(Player, LocalPlayer)) then continue end

               
                if (circle.Radius > Magnitude and Magnitude < ShortestDistance) then
                   
                    if (ValiantAimHacks.VisibleCheck and not ValiantAimHacks.isPartVisible(TargetPartTemp, Character)) then continue end

                   
                    ClosestPlayer = Player
                    ShortestDistance = Magnitude
                    TargetPart = TargetPartTemp
                end
            end
        end
    end

   
    ValiantAimHacks.Selected = ClosestPlayer
    ValiantAimHacks.SelectedPart = TargetPart
end


Heartbeat:Connect(function()
    ValiantAimHacks.updateCircle()
    ValiantAimHacks.getClosestPlayerToCursor()
end)

return ValiantAimHacks
