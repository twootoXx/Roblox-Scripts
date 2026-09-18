while not game.Loaded do
    task.wait()
end

if _G.Loaded then  
    error("Script already ran")
end

local inLobby = false
if game.PlaceId == 77108422251420 then 
    inLobby = true
end

_G.Loaded = true
_G.Unload = false

_G.AutoFarm = false
_G.SelectedUpgrades = {}
_G.WalkSpeedToggle = false
_G.NoClip = false
_G.ToggleAutoUpgrades = false
_G.SelectedTools = {}
_G.SelectedBuyTools = {}
_G.ToggleAutoTools = false
_G.NeedleEsp = false
_G.SelectedMap = {}
_G.ToggleJoiner = false
_G.SelectedDifficulty = {}
_G.PartySize = 1

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:FindFirstChild("HumanoidRootPart")
local humanoid = char:FindFirstChild("Humanoid")


local Window = Library:CreateWindow({
    Title = "Luminis",
    Footer = "v1.0.0",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Center = true,
    AutoShow = true
})

local infoTab = Window:AddTab("Info", "info")
local mainTab = Window:AddTab("Main", "house")
local LobbyTab = Window:AddTab("Lobby", "house")
local characterTab = Window:AddTab("Character", "house")
local settingsTab = Window:AddTab("settings", "settings")

local scriptInfoBox = infoTab:AddLeftGroupbox("Script Info")
local discordBox = infoTab:AddRightGroupbox("Discord")
local farmBox = mainTab:AddLeftGroupbox("Farms")
local upgradeBox = mainTab:AddRightGroupbox("Upgrades")
local toolsBox = mainTab:AddLeftGroupbox("Tools")
local characterBox = characterTab:AddLeftGroupbox("Character Modifiers")
local scriptBox = settingsTab:AddLeftGroupbox("Script")
local joinerBox = LobbyTab:AddLeftGroupbox("Joiner")


discordBox:AddLabel({
    Text = "Support the script by joining the discord!",
    DoesWrap = true
})

discordBox:AddButton({
    Text = "Discord Invite",
    Func = function()
        setclipboard("https://discord.com/invite/WYwXgHtdZW")
    end,
    DoubleClick = false
})

scriptInfoBox:AddLabel({
    Text = "This script was made by twooto and inteded to be free.",
    DoesWrap = true
})

scriptInfoBox:AddLabel({
    Text = "This script is open source so if you're curious go and take a look.",
    DoesWrap = true
})

scriptInfoBox:AddLabel({
    Text = "Ive you got any sugestions, go and join discord and make a thread !",
    DoesWrap = true
})

local function FindPath(goalPosition: Vector3): boolean
    if not humanoid or not root then
        return false
    end

    local path = PathfindingService:CreatePath({
        AgentRadius = 3,
        AgentHeight = 6,
        AgentCanJump = true,
    })

    local success, err = pcall(function()
        path:ComputeAsync(root.Position, goalPosition)
    end)

    if not success or path.Status ~= Enum.PathStatus.Success then
        warn("Path compute failed:", err or path.Status)
        humanoid:MoveTo(root.Position + Vector3.new(3, 0, 3))
        return false
    end

    local waypoints = path:GetWaypoints()
    for _, waypoint in ipairs(waypoints) do
        if not _G.AutoFarm or _G.Unload then
            return false
        end

        humanoid:MoveTo(waypoint.Position)

        if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid.Jump = true
        end

        local reached = false
        local conn = humanoid.MoveToFinished:Connect(function()
            reached = true
        end)

        local start = os.clock()
        local timeout = 2
        while not reached and (os.clock() - start) < timeout do
            if not _G.AutoFarm or _G.Unload then
                conn:Disconnect()
                return false
            end
            task.wait()
        end

        conn:Disconnect()
    end

    return true
end

farmBox:AddDropdown("SelectedTools", {
    Values = {"Hand", "PitchFork", "TNT"},
    Default = {"None"},
    Multi = true,
    Text = "Select tools",
    Callback = function(Values)
        -- {value = true}
        _G.SelectedTools = Values
    end
})

local function GetCurrentHayAmount()
	local gui = plr:FindFirstChild("PlayerGui")
	if not gui then return 0 end

	local txt = gui:FindFirstChild("HUD")
		and gui.HUD:FindFirstChild("BottomLeft")
		and gui.HUD.BottomLeft:FindFirstChild("Capacity")
		and gui.HUD.BottomLeft.Capacity:FindFirstChild("CurrentAmount")

	if txt and txt:IsA("TextLabel") then
		return tonumber(txt.Text) or 0
	end
	return 0
end

farmBox:AddLabel({
    Text = "I would suggest also enabeling noclip for the best experience",
    DoesWrap = true
})

farmBox:AddToggle("Auto Farm", {
    Text = "Farm Hay",
    Default = false,
    Tooltip = "Walks to the haybail and collects hay",
    Callback = function(Value)
        _G.AutoFarm = Value
        if inLobby then return end




        task.spawn(function()
                    
            local sellPlaceChapter1 = Vector3.new(-163.93687438964844, 2.9513638019561768, 56.90555191040039)
            local sellPlaceChapter2 = Vector3.new(-103.20582580566406, -17.19516372680664, -18.949604034423828)
            local hayStack = workspace:FindFirstChild("HaystackClient")

            local pickHayEvent = ReplicatedStorage.NeedleHaystack.PickHay
            local pitchforkDigEvent = ReplicatedStorage.NeedleHaystack.PitchforkDig
            local tntEvent = ReplicatedStorage.NeedleHaystack.TntAction
            local sellHayEvent = ReplicatedStorage.NeedleHaystack.SellHay

            while _G.AutoFarm and not _G.Unload do 
                task.wait(0.2)


                local pickableHay = hayStack:GetChildren()
                local backpackSize = plr:GetAttribute("HayCapacity")
                local heyGrabCount = plr:GetAttribute("HayGrabCount")
                local currentAmmount = GetCurrentHayAmount()

                local distanceToHay = (pickableHay[1].Position - root.Position).Magnitude

                if distanceToHay > 20 then 
                    FindPath(pickableHay[math.random(1, #pickableHay)].Position)
                end

                for tool, _ in pairs(_G.SelectedTools) do
                    task.wait(0.1)
                    if tool == "Hand" then 
                        local firstIndex = nil
                        local haytable = {}
                        local index = 0
                        for i, hay in ipairs(pickableHay) do
                            if index >= heyGrabCount then break end
                            local distance = (hay.Position - root.Position).Magnitude
        
                            if distance > 20 then continue end
        
                            if #haytable == 0 and not firstIndex then
                                firstIndex = hay:GetAttribute("HayId")
                            else
                                table.insert(haytable, hay:GetAttribute("HayId"))
                            end
                            
                            index += 1
                        end
                    
                        pickHayEvent:FireServer(
                            firstIndex,
                            haytable
                        )
                    elseif tool == "PitchFork" then
                        local hayId = nil
                        for i, hay in ipairs(pickableHay) do
                            local distance = (hay.Position - root.Position).Magnitude
        
                            if distance > 20 then continue end
        
                            hayId = hay:GetAttribute("HayId")
                            break
                        end
                        
                        pitchforkDigEvent:FireServer(hayId)
                    elseif tool == "TNT" then
                        

                        tntEvent:FireServer("light")
                        task.wait(0.1)
                        tntEvent:FireServer(
                            "throw",
                            root.CFrame,
                            pickableHay[math.random(1, #pickableHay)].Position
                        )
                    end
                end

                if currentAmmount >= backpackSize then

                    if game.PlaceId == 108628039999641 then 
                        FindPath(sellPlaceChapter1)
                    elseif game.PlaceId == 83445806734780 then
                        FindPath(sellPlaceChapter2)
                    end

                    sellHayEvent:FireServer()
                end
            end
        end)



    end
})

farmBox:AddToggle("Auto Gems", {
    Text = "Farm Gems",
    Default = false,
    Tooltip = "fly through all the stages and collect gold",
    Callback = function(Value)
        _G.AutoGems = Value
        if inLobby then return end
        task.spawn(function()
            local gemFolder = game.Workspace:FindFirstChild("GemsClient")
            while _G.AutoGems and not _G.Unload and task.wait(1) do 
                local gems = gemFolder:GetChildren()

                if #gems > 1 then 
                    for _, gem in ipairs(gems) do
                        local dia = gem:FindFirstChild("Diamond")
                        if not dia then continue end
                        
                        local Event = game:GetService("ReplicatedStorage").NeedleHaystack.CollectGem
                        Event:FireServer(
                            gem.Diamond:GetAttribute("GemId")
                        )
                    end
                end
            end
        end)
    end
})

farmBox:AddToggle("NeedleEsp", {
    Text = "Needle esp",
    Default = false,
    Tooltip = "esp for needle",
    Callback = function(Value)
        _G.NeedleEsp = Value
        if inLobby then return end
        task.spawn(function()
            while _G.NeedleEsp and not _G.Unload and task.wait(1) do 
                local objectives = workspace.NeedleObjectiveServer:GetChildren()
        
                for _, item in ipairs(objectives) do
                    if item:FindFirstChild("Esp", true) then continue end
        
                    local part = item:FindFirstChildWhichIsA("BasePart")
        
                    if not part then
                        continue
                    end
        
        
                    local highlight = Instance.new("Highlight", item:FindFirstChildWhichIsA("Part"))
                    highlight.Name = "Esp"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                    highlight.FillTransparency = 0.6
                    highlight.OutlineTransparency = 0
                    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
            end
        end)
    end
})

upgradeBox:AddDropdown("SelectedUpgrades", {
    Values = {"Grab", "Speed", "HandHold", "Capacity", "PitchforkCooldown", "PitchforkHold", "Pitchfork", "TntLuck", "TntCooldown", "TntPower", "DroneSpeed", "DroneGrab", "DroneCapacity", "VacuumPower", "VacuumCooling", "VacuumRuntime"},
    Default = {"None"}, -- Default selected values for multi-select
    Multi = true,
    Text = "Select upgrades",
    Callback = function(Values)
        -- {value = true}
        _G.SelectedUpgrades = Values
    end
})


upgradeBox:AddToggle("ToggleAutoUpgrades", {
    Text = "Auto upgrade",
    Default = false,
    Tooltip = "Auto buy selected upgrades",
    Callback = function(Value)
        _G.ToggleAutoUpgrades = Value
        if inLobby then return end
        task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").NeedleHaystack.BuyUpgrade
            while _G.ToggleAutoUpgrades and not _G.Unload and task.wait(1) do 
                for upgradeName, _ in pairs(_G.SelectedUpgrades) do 
                    Event:FireServer(upgradeName)
                end
            end
        end)
    end
})


toolsBox:AddDropdown("SelectedBuyTools", {
    Values = {"Pitchfork", "Tnt", "Vacuum", "Drone"},
    Default = {"None"}, -- Default selected values for multi-select
    Multi = true,
    Text = "Select tools",
    Callback = function(Values)
        -- {value = true}
        _G.SelectedBuyTools = Values
    end
})


toolsBox:AddToggle("ToggleAutoTools", {
    Text = "Auto buy tool",
    Default = false,
    Tooltip = "Auto buy selected tools",
    Callback = function(Value)
        _G.ToggleAutoTools = Value
        if inLobby then return end
        task.spawn(function()
            local Event = ReplicatedStorage.NeedleHaystack.BuyShopItem
            while _G.ToggleAutoTools and not _G.Unload and task.wait(5) do 
                for upgradeName, _ in pairs(_G.SelectedBuyTools) do 
                    Event:FireServer(upgradeName)
                end
            end
        end)
    end
})



joinerBox:AddDropdown("SelectedMap", {
    Values = {"FARMHOUSE", "BASEMENT"},
    Default = {"None"},
    Multi = false,
    Text = "Select Map",
    Callback = function(Values)
        -- {value = true}
        _G.SelectedMap = Values
    end
})

joinerBox:AddDropdown("SelectedDifficulty", {
    Values = {"NORMAL", "HARD"},
    Default = {"None"},
    Multi = false,
    Text = "Select Difficulty",
    Callback = function(Values)
        -- {value = true}
        _G.SelectedDifficulty = Values
        
    end
})

joinerBox:AddSlider("PartySize", {
    Text = "Amount of player slots",
    Default = 1,
    Min = 1,
    Max = 4,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        _G.PartySize = Value
    end
})

joinerBox:AddToggle("ToggleJoiner", {
    Text = "Auto join map",
    Default = false,
    Tooltip = "Auto join the map when in the lobby",
    Callback = function(Value)
        _G.ToggleJoiner = Value
        if not inLobby then return end
        task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").Packages.Networker._remotes.PartyService.RemoteEvent

            local teleporters = {}

            for _, item in ipairs(game.Workspace:GetChildren()) do
                if item.Name == "Teleporter" then 
                    table.insert(teleporters, item)
                end
            end

            while _G.ToggleJoiner and not _G.Unload and task.wait(5) and inLobby do 
                local teleportCircle = nil
                for _, item in pairs(teleporters) do  
                    local collider = item:FindFirstChild("Collider")
                    if not collider then continue end

                    local billboard = collider:FindFirstChild("BillboardGui")
                    if not billboard then continue end

                    local CountLabel = billboard:FindFirstChild("CountLabel")
                    if not CountLabel then continue end

                    if string.sub(CountLabel.Text, 1, 1) == "0" then 
                        teleportCircle = collider
                    end
                end

                if not teleportCircle then continue end

                root.Position = teleportCircle.Position

                task.wait(0.5)

                Event:FireServer(
                    "CreateParty",
                    _G.SelectedMap,
                    _G.PartySize,
                    _G.SelectedDifficulty
                )

            end
        end)
    end
})



characterBox:AddSlider("WalkSpeed", {
    Text = "Walk speed (16 is normal speed)",
    Default = 16,
    Min = 16,
    Max = 100,
    Rounding = 1,
    Compact = false,
    Callback = function(Value)
        _G.WalkSpeed = Value
    end
})

characterBox:AddToggle("WalkSpeedToggle", {
    Text = "Enable speed hack",
    Default = false,
    Tooltip = "makes the player move faster",
    Callback = function(Value)
        _G.WalkSpeedToggle = Value

        if not _G.WalkSpeedToggle then humanoid.WalkSpeed = 16; return end
        
        task.spawn(function()
            while task.wait() and _G.WalkSpeedToggle and not _G.Unload do 
                local char = plr.Character
                if not char then continue end
        
                local humanoid = char:FindFirstChild("Humanoid")
                if not humanoid then continue end
        
                humanoid.WalkSpeed = _G.WalkSpeed
            end
        end)
        
    end
})

local noclipConn = nil

characterBox:AddToggle("NoClip", {
    Text = "Enable noclip",
    Default = false,
    Tooltip = "makes the player able to go through walls",
    Callback = function(Value)
        _G.NoClip = Value

        if not _G.NoClip then return end
        if noclipConn then  
            noclipConn = nil
        end
        
        noclipConn = RunService.PostSimulation:Connect(function()
            if _G.Unload then return end
            if not char then return end
        
            for _, item in ipairs(char:GetChildren()) do 
                if item:IsA("Part") or item:IsA("MeshPart") then
                    item.CanCollide = not _G.NoClip
                end
            end   
        end)
        
    end
})


scriptBox:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Library.Options.MenuKeybind 


scriptBox:AddButton({
    Text = "Unload script",
    Func = function()
        _G.Loaded = false
        _G.Unload = true

        _G.AutoFarm = false
        _G.SelectedUpgrades = {}
        _G.WalkSpeedToggle = false
        _G.NoClip = false
        _G.ToggleAutoUpgrades = false
        _G.SelectedTools = {}
        _G.SelectedBuyTools = {}
        _G.ToggleAutoTools = false
        _G.NeedleEsp = false
        _G.SelectedMap = {}
        _G.ToggleJoiner = false
        _G.SelectedDifficulty = {}
        _G.PartySize = 1

        humanoid.WalkSpeed = 16
        noclipConn = nil
        
        Library:Unload()
    end,
    DoubleClick = true
})


SaveManager:SetLibrary(Library)
SaveManager:SetFolder("Luminis/Search For The Needle")
SaveManager:BuildConfigSection(settingsTab)
SaveManager:LoadAutoloadConfig()