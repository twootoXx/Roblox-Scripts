-- HUD variables --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()


local Window = Rayfield:CreateWindow({
   Name = "Twooto hub | spts Reimagined",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Welcome to twooto hub!",
   LoadingSubtitle = "by twooto",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface
})

-- player variables --
local plr = game.Players.LocalPlayer
local char = plr.Character
local humanoid = char.Humanoid
local backpack = plr.Backpack
local rootpart = char.HumanoidRootPart
local executor = string.match(identifyexecutor(),"^[^ ]+")

-- game variables --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Event = ReplicatedStorage:WaitForChild("RemoteEvent")
local lighting = game:GetService("Lighting")
local IntroGui = plr.PlayerGui.IntroGui
local gameGUi = plr.PlayerGui.MainGui
local playerCount = #game.Players:GetPlayers()
local maxPlayers = game.Players.MaxPlayers
local PlayerGui = plr:WaitForChild("PlayerGui")
local menuframe = PlayerGui.MainGui.MenuFrame
local infoframe = menuframe.InfoFrame
local skillframe = menuframe.SkillsFrame

-- conections --
local plr_died_conn = nil
local char_add_conn = nil

-- script variables --
local farm_status = {}
local allow_Teleports = true
local showESP = false
local bring_player = false
local respawn = false
local respawnreturn = false
local RespawnRate = 0
local before_death_location = nil
local auto_weight = false
local selected_weight = nil
local auto_claim_quest_status = false
local selected_crates = {}
local custom_name_running = false
local CustomName = "discord.gg/WYwXgHtdZW"
local enablewebhook = false
local delay_webhook = 60
local webhook_url = nil
local players_list = {}
local server_players = {}
local limitFps = false
local auto_crates = false
local is_crate_on_map = false
local kill_npc = false
local selected_npc = {}
local killing_npc = false
local autoRaceRunning = false
local selectedRaces = {}
local killSelectedPlayerRunning = false

-- gui variables --
local farming_Tab
local safe_farms_Section
local Farming_info_lable
local Fist_Farm_Toggle
local Body_Farm_Toggle
local MovementSpeed_farm_toggle
local JumpPower_farm_toggle
local psychic_farm_toggle
local Divider
local risky_farms_Section
local Risky_Farming_info_lable
local body_death_farm_toggle

local combat_Tab
local Safe_combat_Section
local safe_combat_info_lable
local ESP_toggle
local Dangerous_combat_Section
local Dangerous_combat_info_lable
local Bring_Player_toggle
local Bring_selected_toggle
local rank_select_Bring_Player_dropdown
local player_select_Bring_Player_dropdown
local refresh_players_Button

local misc_Tab
local Farm_settings_Section
local Farm_settings_info_lable
local Allow_Teleports_toggle
local respawn_Section
local Fast_respawn_info_lable
local Fast_respawn_toggle
local return_respawn_toggle
local RespawnRate_info_lable
local RespawnRate_slider
local Safe_misc_Section
local Auto_equip_weight_toggle
local Select_weight_dropdown
local Auto_claim_quest_toggle


local Select_Race_dropdown
local AutoRace_toggle




local training_locations = {
    fist = {
        -- {Vector3.new(407.9, 260.653, 979.38), "Invisibility"}, -- Stone
        {Vector3.new(-2276.68, 1955.56, 1051.59), 0}, -- Crystal  
        {Vector3.new(1176.43, 4776.36, -2293.09), 1000000000}, -- Blue star
        {Vector3.new(1379.9, 9256.42, 1648.31), 100000000000}, -- Green star
        {Vector3.new(-366.606, 15681.9, -9.951), 10000000000000}, -- 10T Red star
        {Vector3.new(110.66, 17095.52, -413.68), 1000000000000000}, -- 1QA Purple star
        {Vector3.new(-3829.16748, 374.99115, -2282.23315), 1000000000000000000}, -- 1QI Purple star
        {Vector3.new(266.487762, 1157.60132, -3028.2937), 1000000000000000000000} -- 1SX Purple star
    },
    body = {
        {Vector3.new(367.012, 248.478, -444.984), 100}, -- Ice bath
        {Vector3.new(356.81, 263.77, -493.50), 10000}, -- Firebath
        {Vector3.new(1634.70, 259.54, 2247.44), 100000}, -- Ice Berg Bath
        {Vector3.new(-2301.51, 965.84, 1069.53), 1000000}, -- Tornado
        {Vector3.new(-1980.98, 714.21, -1922.01), 10000000}, -- Volcano
        {Vector3.new(-241.13, 286.00, 982.36), 1000000000}, -- Green Fire Bath
        {Vector3.new(-290.33, 280.90, 987.51), 100000000000}, -- 100B Green Acid Bath
        {Vector3.new(-291.65, 281.42, 1012.37), 10000000000000}, -- 10T Red Acid Bath
        {Vector3.new(-369.38, 241.35, 1394.68), 1000000000000000}, -- 1QA nuclear Bath
        {Vector3.new(-5374.37, 2292, 1481.22), 1000000000000000000}, -- 1QI Tornado
        {Vector3.new(-1193.50, 345.02, -3017.06), 1000000000000000000000} -- 1SX Cube
    },
    body_deathFarm = {
        {Vector3.new(367.012, 248.478, -444.984), 5}, -- Ice bath
        {Vector3.new(356.81, 263.77, -493.50), 500}, -- Firebath
        {Vector3.new(1634.70, 259.54, 2247.44), 5000}, -- Ice Berg Bath
        {Vector3.new(-2301.51, 965.84, 1069.53), 50000}, -- Tornado
        {Vector3.new(-1980.98, 714.21, -1922.01), 500000}, -- Volcano
        {Vector3.new(-241.13, 286.00, 982.36), 50000000}, -- Green Fire Bath
        {Vector3.new(-290.33, 280.90, 987.51), 5000000000}, -- 100B Green Acid Bath
        {Vector3.new(-291.65, 281.42, 1012.37), 500000000000}, -- 10T Red Acid Bath
        {Vector3.new(-369.38, 241.35, 1394.68), 100000000000000}, -- 1QA nuclear Bath
        {Vector3.new(-5374.37, 2292, 1481.22), 500000000000000000}, -- 1QI Tornado
        {Vector3.new(-1193.50, 345.02, -3017.06), 100000000000000000000} -- 1SX Cube
    },
    
    psychic = {
        {nil, 0}, -- 1M zone
        {Vector3.new(-2531.50, 5486.49, -535.22), 1000000}, -- 1M zone
        {Vector3.new(-2563.90, 5501.04, -438.99), 1000000000}, -- 1B zone
        {Vector3.new(-2575.59, 5519.78, -501.15), 1000000000000}, -- 1T zone
        {Vector3.new(-2562.45, 5415.91, -489.87), 1000000000000000}, -- 1QA Waterfall
        {Vector3.new(-2638.74, 5570.65, -423.82), 1000000000000000000}, -- 1QI top meditate island
        {Vector3.new(-2359.74, 238.78, -368.41), 1000000000000000000000} -- 1SX flour
    }
}

local training_tools = {
    fist = "FistStrength",
    psychic = "PsychicPower"
}

local all_ranks = {
    hero = {    
        "Superhero",
        "Guardian",
        "Protector"
    },

    villan = {    
        "Supervillain",
        "Criminal",
        "Lawbreaker"
    }

}

local weights = {
    ["100 LB"] = 1,
    ["1 Ton"] = 2,
    ["10 Ton"] = 3,
    ["100 Ton"] = 4,
    ["1K Ton"] = 5, 
    ["10K Ton"] = 6, 
    ["100K Ton"] = 7, 
    ["1M Ton"] = 8, 
    ["10M Ton"] = 9, 
    ["100M Ton"] = 10, 
    ["1B Ton"] = 11, 
    ["10B Ton"] = 12
}

crates = {
    ["Common"] = "CommonCrate",
    ["Uncommon"] = "UncommonCrate",
    ["Rare"] = "RareCrate",
    ["Epic"] = "EpicCrate",
    ["Legendary"] = "LegendaryCrate",
    ["Mythic"] = "MythicCrate",
    ["Godly"] = "GodlyCrate",
    ["Secret"] = "SecretCrate"
}

local function prefixtonumber(str)
            -- Match number + optional multi-letter suffix
            local numberPart = str:match("(%d+%.?%d*%a*)")
            if not numberPart then return 0 end

            -- Separate numeric and suffix parts
            local numStr, suffix = numberPart:match("^(%d+%.?%d*)(%a*)$")
            local num = tonumber(numStr) or 0
            suffix = suffix:lower()

            -- Scale based on suffix
            local multipliers = {
                k  = 1e3,
                m  = 1e6,
                b  = 1e9,
                t  = 1e12,
                qa = 1e15,
                qi = 1e18,
                sx = 1e21,
                sp = 1e24,
                oc = 1e27,
                no = 1e30,
                dc = 1e33,
                ud = 1e36,
                dd = 1e39,
                td = 1e42
            }


            if multipliers[suffix] then
                num = num * multipliers[suffix]
            end

            return num
        end

local player_stats = {
            fist = function() return prefixtonumber(infoframe.TrainingStats.FistStrength.StatLabel.Text) end,
            body = function() return prefixtonumber(infoframe.TrainingStats.BodyToughness.StatLabel.Text) end,
            speed = function() return prefixtonumber(infoframe.TrainingStats.MovementSpeed.StatLabel.Text) end,
            jump = function() return prefixtonumber(infoframe.TrainingStats.JumpForce.StatLabel.Text) end,
            psychic = function() return prefixtonumber(infoframe.TrainingStats.PsychicPower.StatLabel.Text) end
        }


-- functions --
-- call function to create a notification
local function sendNotification(whatsRunning, Value)
    Rayfield:Notify({
        Title = whatsRunning .. " " .. (Value and "Enabled" or "Disabled"),
        Content = whatsRunning .. " has been " .. (Value and "Enabled" or "Disabled"),
        Duration = 10,
        Image = 4483362458,
    })
end

-- call function to respawn fast
local function fastrespawn()
    -- wait for the respawn delay et by the script user
    task.wait(RespawnRate)

    ReplicatedStorage.RemoteEvents.RefreshCharacter:FireServer()
    task.wait(0.1)

	task.wait(0.2)
    local startTime = time()
    while true do
        lighting.Blur.Enabled = false
        IntroGui.Enabled = false
        gameGUi.Enabled = true

        if time() - startTime >= 10 then
            break
        end
        task.wait()
    end

    -- if char.Humanoid.Health ~= 100 then
    --     game:GetService("ReplicatedStorage").RemoteEvents.RefreshCharacter:FireServer()
    -- end
end

-- call function to find the best farming spot
local function SelectFarmingpot(stat)
    -- get the training locations of the seleted stat
    local locations_list = training_locations[stat]
    local plr_stats

    -- checks if stat equals to body_deathfarm if so then it gets the body value
    if stat == "body_deathFarm" then 
        plr_stats = player_stats["body"]()
    else
        plr_stats = player_stats[stat]()
    end
    -- if there are no training location then return nothing
    if not locations_list then
        return
    end

    -- iterates trough the list backwards
    for index = #locations_list, 1, -1  do

        -- if the training req is a string it well perform checks to know witch one is correct
        if type(locations_list[index][2]) == "string" then
            -- checks if the player can fly
            if locations_list[index][2] == skillframe.Frame.Flight.NameLabel.Text then
                --return the location
                return locations_list[index][1]

            --check if the player can go invisible
            elseif locations_list[index][2] == skillframe.Frame.Invisibility.NameLabel.Text then
                -- return the location
                return locations_list[index][1]
            end
        end

        -- checks if the players stat is bigger than the training req
        if type(locations_list[index][2]) ~= "string" then
            if plr_stats >= locations_list[index][2]  then
                -- return the locations Vector3
                return locations_list[index][1]
            end
        end

    end

    -- return first location if no location matches
    -- print("no location found, returning first location")
    return training_locations[stat][1][1]

end

-- call function to have to player farm stats
local function FarmStats(status, stat)
    -- Set the specific farm's status instead of global
    farm_status[stat] = status
    -- print("Farm", stat, "status:", farm_status[stat])
    
    if not farm_status[stat] then return end
    
    local tool = nil

    repeat
        if auto_crates and is_crate_on_map then task.wait() continue end
        if kill_npc and killing_npc then task.wait() continue end
        -- gets the correct farming location and tool
        local farming_location = SelectFarmingpot(stat)
        local toolName = training_tools[stat]
        -- checks if there is a tool name, if there is then get the tool
        if toolName then
            tool = backpack:FindFirstChild(toolName) or char:FindFirstChild(toolName)
        end

        --teleports the player to location
        if farming_location ~= nil and allow_Teleports then
            rootpart.CFrame = CFrame.new(farming_location)
        end

        -- checks if farm needs a tool if so equip the tool and activates it
        if tool then
            tool.Parent = char
            tool:Activate()
        end

        -- checks if the farm needs remotes
        if stat == "fist" then
            game:GetService("ReplicatedStorage").RemoteEvents.FS_Train:FireServer()
        elseif stat == "body" then
            game:GetService("ReplicatedStorage").RemoteEvents.BT_Train:FireServer()
        elseif stat == "speed" then
        elseif stat == "jump" then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            humanoid.Jump = true
            task.wait()
            humanoid:ChangeState(Enum.HumanoidStateType.Landed)
            humanoid.Jump = false
            game:GetService("ReplicatedStorage").RemoteEvents.JF_Train:FireServer()
        end

        -- when player dies relocate the tool and continue
        if humanoid.Health < 0 then
            tool = backpack:WaitForChild(training_tools[stat])
            tool.Parent = char
        end

        task.wait()
    until farm_status[stat] == false -- stops when farm isnt running
    if tool then tool.Parent = backpack end
end

-- call function to generate ESP on players
local function ESP(status)
    -- sets the esp to true
    showESP = status
    local players

    -- function that removes the esp of a player
    local function RemoveESP(player)
        -- checks if the player is highlight in their character
        if player.Character:FindFirstChild("Highlight") then
            player.Character:FindFirstChild("Highlight"):Destroy()
        end

        -- checks if the player has ESP BilbordGUi inside the head
        if player.Character.Head:FindFirstChild("ESP") then
            player.Character.Head:FindFirstChild("ESP"):Destroy()            
        end
    end

    -- function that generates the esp
    local function GenEsp(player)

        --print("adding the esp modules to the player:" .. player.Name)
        -- creating the billbord gui
        local BilBordGui = Instance.new("BillboardGui", player.Character:FindFirstChild("Head"))
        BilBordGui.Name = "ESP"
        BilBordGui.ExtentsOffset = Vector3.new(0, 5, 0)
        BilBordGui.Size = UDim2.new(0, 200, 0, 50)
        BilBordGui.ResetOnSpawn = false
        BilBordGui.AlwaysOnTop = true

        -- creating background frame with a almost transparent background
        local BackGroundFrame = Instance.new("Frame", BilBordGui)
        BackGroundFrame.Size = UDim2.new(1, 0, 1, 0)
        BackGroundFrame.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
        BackGroundFrame.BackgroundTransparency = 0.25
        BackGroundFrame.BorderColor3 = Color3.fromRGB(24, 24, 24)
        BackGroundFrame.BorderSizePixel = 5
        BackGroundFrame.BorderMode = Enum.BorderMode.Middle

        -- creates the text with the players name and distance in studs of the script user
        local TextLable = Instance.new("TextBox", BackGroundFrame)
        TextLable.Name = "DistanceLable"
        TextLable.BackgroundTransparency = 1
        TextLable.TextScaled = true
        TextLable.Size = UDim2.new(1, 0, 1, 0)
        if not player.Character:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("HumanoidRootPart") then
             TextLable.Text = player.Name .. " studs - Error"
        else
            TextLable.Text = player.Name .. " studs - " .. math.floor((player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
        end


        -- highlights the player in red
        local Highlight = Instance.new("Highlight", player.Character)

        -- if the player died it returns the function so it doesnt waist resorces
        player.Character.Humanoid.Died:Connect(function()
            --print("update distance stopped since player: " ..player.Name .." is dead")
            -- looks for the esp parts and removes them
            RemoveESP(player)
            return
        end)

        -- updates the distance from the player using the script
        repeat
            task.wait(0.1)
            -- if player has no character or head also skip them
            if not player.Character then
                --print("Player has no character: " .. player.Name)
                return
            end

            if not player.Character:FindFirstChild("HumanoidRootPart") then continue end
            if not char:FindFirstChild("HumanoidRootPart") then continue end

            -- make it so when the script user dies it still shows how many studs are between the script user and the other player, now it just freezes 
            TextLable.Text = player.Name .. " studs - " .. math.floor((player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
        until showESP == false
    end

    -- repeat the generating esp for new players that join the server
    repeat
        -- get all players in the server
        players = game.Players:GetChildren()

        -- iterate through all the players to generate esp
        for _, player in pairs(players) do

            -- skip the script user
            if player == plr then
                --print("wont generate esp on script user")
                continue
            end

            -- if player has no character or head also skip them
            if not player.Character or not player.Character:FindFirstChild("Head") then
                --print("Player has no character or head: " .. player.Name)
                continue
            end

            -- skips player if hes dead
            if player.Character:WaitForChild("Humanoid").Health < 1 then
                --print("skip since player is dead player name:".. player.Name)
                continue
            end

            -- skips player if they already have esp else generate esp on the player
            if player.Character:FindFirstChild("Head"):FindFirstChild("ESP") then
                --print("skip player since he already has esp")
                continue
            else
                task.spawn(function()
                    GenEsp(player)
                end)
            end

            task.wait()
        end
        task.wait()
    until showESP == false

    -- if showESP is false remove the esp from all players in the server
    for _, player in pairs(players) do

        -- skips the player who dont have characters or heads
        if not player.Character or not player.Character.Head then
            print("Player has no character or head " .. player.Name)
            continue
        end

        -- looks for the esp parts and removes them
        RemoveESP(player)
    end

end

-- when called refreshes all the players inside the table server_players
local function refresh_server_players()
    -- clear table before refreshing table
    table.clear(server_players)

    -- iterating through all the players in the server and adding their name to the table
    for _, player in pairs(game.Players:GetChildren()) do
        table.insert(server_players, player.Name)
    end

    -- refresh the dropdown
    player_select_Bring_Player_dropdown:Refresh(server_players)
end

-- when called will add players to player_list who will be used to bring to the script user
local function add_players_to_list(mode, argument)
    -- clear table before selecting new players
    table.clear(players_list)

    -- checks if mode is all
    if mode == "all" then
        -- iterates over all players in the game and adds them to the list
        for _, player in pairs(game.Players:GetChildren()) do
            table.insert(players_list, player)
        end

    elseif mode == "rank select" then
        -- table of all the ranks seleted
        local ranks = {}

        -- arguments is a table of the options selected
        for _, rank_string in pairs(argument) do
            
            -- check if rank_string is inside the all_rank table if so the rank table gets added to table_ranks
            local table_ranks = all_ranks[rank_string]
            -- if rank_string is Innocent its just adds innocent to the ranks table since there are no other options
            if rank_string == "Innocent" then table.insert(ranks, rank_string) end

            -- checks if table_ranks is a table
            if typeof(table_ranks) == "table" then
                -- iterates through table_ranks and add each rank to ranks
                for _, rank in pairs(table_ranks) do 
                    table.insert(ranks, rank)
                end
            end
        end

        -- iterates over all players in the server
        for _, player in pairs(game.Players:GetChildren()) do
            -- if player doesnt have status in leaderstats skips
            if not player.leaderstats.Status then continue end

            -- iterates over the table ranks to see if the status value equals to arg(being each rank in ranks)
            for _, arg in pairs(ranks) do
                if player.leaderstats.Status.Value == arg then
                    print("adding the players with rank to list")
                    table.insert(players_list, player)
                end
            end
        end

    elseif mode == "player select" then
        -- iterate through all the players in the server
        for _, player in pairs(game.Players:GetChildren()) do

            -- iterate through all the arguments(player names)
            for _, arg in pairs(argument) do
                -- if the player name is equal to arg then add the player to the table
                if player.Name == arg then
                    table.insert(players_list, player)
                end
            end
        end 
    end
end

-- call function to bring players infront of the script user client sided
local function Bring_player(status)
    bring_player = status
    respawn = status
    repeat
        -- print("inside bring player repeat")
        for _, player in pairs(players_list) do
            -- skips player if they dont have a charater
            if not player.Character then continue end
            if not player.Character:FindFirstChild("HumanoidRootPart") then continue end
            -- teleport player to the script user
            player.Character.HumanoidRootPart.CFrame = rootpart.CFrame
        end
    until bring_player == false

end

local function Kill_selected_Player(status)
    killSelectedPlayerRunning = status

    if not killSelectedPlayerRunning then return end

    task.spawn(function()
        while killSelectedPlayerRunning do
            task.wait(0.1)
            for _, player in pairs(players_list) do
                if not player.Character then continue end
                if not player.Character:FindFirstChild("HumanoidRootPart") then continue end
                if not player.Character:FindFirstChild("Humanoid") then continue end

                if math.floor((player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude) < 600 and player.Name ~= plr.Name and player.Character.Humanoid.Health ~= 0 then
                    print(math.floor((player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude))
                    print("Player is in distance: " .. player.Name)
                    game:GetService("ReplicatedStorage").RemoteEvents.UseSkill:FireServer(table.unpack({
                        [1] = "SoulAttack",
                        [2] = player.Character,
                    }))
                end
            end
        end
    end)
end

local function Auto_equip_weight(status, switch)
    auto_weight = status
    if not auto_weight then return end

    -- checks if there is a weight equiped if not it returns the function
    if not selected_weight then print("theres no weight selected")  Auto_equip_weight_toggle:Set(false) return end

    repeat
        game:GetService("ReplicatedStorage").RemoteEvents.SetWeight:FireServer(weights[selected_weight])
        task.wait()
    until auto_weight == false

end

local function Auto_collect_crates(Status)
    auto_crates = Status
    if not Status then return end

    while auto_crates do
        task.wait()
        for _, selectedcrate in pairs(selected_crates) do
            for _, item in ipairs(game.Workspace:GetChildren()) do

                if item.Name == crates[selectedcrate] then
                    is_crate_on_map = true
                    task.wait(0.1)
                    local cd = item:FindFirstChildWhichIsA("ClickDetector", true)
                    local cratePart = item:FindFirstChildWhichIsA("BasePart")
                    if cratePart then
                        rootpart.CFrame = cratePart.CFrame * CFrame.new(0, 0, 5)
                        task.wait(0.1)

                        local clicked = false
                        if cd then
                            fireclickdetector(cd)
                            clicked = true
                        end
 
                        if not clicked then
                            local p = item:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if p then
                                fireproximityprompt(p)
                                p:InputHoldBegin()
                                task.wait(p.HoldDuration + 0.2)
                                p:InputHoldEnd()
                            end
                        end
                    end
                end
            end
        end

        is_crate_on_map = false
    end
end

-- local function Auto_kill_npc(Status)
--     kill_npc = Status

--     if not Status then return end
--     game:GetService("ReplicatedStorage").RemoteEvents.UseSkill:FireServer("KillingIntentAura")

--     while kill_npc do
--         task.wait(0.1)
--         for _, npcName in pairs(selected_npc) do
--             for _, obj in ipairs(game.Workspace:GetChildren()) do

--                 if obj.Name == npcName then

--                     local npcHumanoid = obj:FindFirstChild("Humanoid")
--                     if npcHumanoid then

--                         local npcRootPart = obj:FindFirstChild("HumanoidRootPart")
--                         if not npcRootPart then continue end

--                         if npcHumanoid.Health > 0 then
--                             killing_npc = true

--                             rootpart.CFrame = npcRootPart.CFrame * CFrame.new(0, 0, 3)
--                             task.wait(0.1)
--                             game:GetService("ReplicatedStorage").RemoteEvents.UseSkill:FireServer("Punch")
--                             game:GetService("ReplicatedStorage").RemoteEvents.UseSkill:FireServer(table.unpack({
--                                 [1] = "EnergySphere",
--                                 [2] = Vector3.new(npcRootPart.CFrame),
--                             }))
--                             task.wait(0.1)
--                         else
--                             task.wait(0.1)
--                             killing_npc = false
--                         end
                        
--                     end

--                 end

--             end
--         end
--     end
-- end

local function Auto_kill_npc(Status)
    kill_npc = Status

    if not Status then return end
    
    local areas = {
        ["Thug"] = {Vector3.new(419.912, 210.611, 752.526), CFrame.new(419.911987, 260.610992, 752.526001, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
        ["Sath"] = {Vector3.new(30.6873, 214.951, 1396.47), CFrame.new(30.6872997, 264.950989, 1396.46997, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
        ["CJ"] = {Vector3.new(-340.093, 210.184, -126.035), CFrame.new(-354.890991, 260.365997, -130.994003, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
        ["Angel"] = {Vector3.new(410.769, 212.377, -627.545), CFrame.new(410.769012, 262.377014, -627.544983, 0.945632458, -0, -0.325237274, 0, 1, -0, 0.325237274, 0, 0.945632458)},
        ["Moltens"] = {Vector3.new(-1834.05, 218.193, -1495.96), CFrame.new(-1834.05005, 258.192993, -1495.95996, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
        ["Yeti"] = {Vector3.new(1633.09, 217.272, 2034.95), CFrame.new(1633.09, 247.272, 2034.95, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
        ["Weak"] = {Vector3.new(44.1111, 212.377, -467.827), CFrame.new(44.1110992, 262.377014, -467.826996, 0.945632458, -0, -0.325237274, 0, 1, -0, 0.325237274, 0, 0.945632458)},
        ["ruzgar"] = {Vector3.new(-527.284, 212.571, 946.67), CFrame.new(-534.947632, 274.089294, 966.551453, 1, 0, 0, 0, 1, 0, 0, 0, 1)},
        ["campergun"] = {Vector3.new(-139.807, 313.611, 255.833), CFrame.new(-139.807007, 333.610992, 255.832993, 1, 0, 0, 0, 1, 0, 0, 0, 1)} ,
        ["Candy"] = {Vector3.new(198.106, 200.72, 849.318), CFrame.new(198.106003, 247.720001, 849.317993, 0.982016563, -0, -0.188794911, 0, 1, -0, 0.188794911, 0, 0.982016563)}
    }

    while kill_npc do
        task.wait(0.1)
        for _, npcName in pairs(selected_npc) do
            for _, obj in ipairs(game.Workspace:GetDescendants()) do

                if obj.Name == npcName then

                    local npcHumanoid = obj:FindFirstChild("Humanoid")
                    if npcHumanoid then

                        local position = areas[npcName]
                        local npcRootPart = obj:FindFirstChild("HumanoidRootPart")
                        if not npcRootPart then continue end

                        if npcHumanoid.Health > 0 then
                            killing_npc = true

                            rootpart.CFrame = position[2]
                            task.wait(0.3)
                            game:GetService("ReplicatedStorage").RemoteEvents.UseSkill:FireServer(table.unpack({
                                [1] = "EnergySphere",
                                [2] = position[1],
                            }))
                            task.wait(0.1)
                        else
                            task.wait(0.1)
                            killing_npc = false
                        end
                        
                    end

                end

            end
        end
    end
end

function AutoRace(status)
    autoRaceRunning = status

    if not autoRaceRunning then return end

    task.spawn(function()
        while autoRaceRunning do
            game:GetService("ReplicatedStorage").RollRaceRF:InvokeServer()
            task.wait()
            for _, value in pairs(selectedRaces) do
                if plr:GetAttribute("Race") == value then
                    autoRaceRunning = false
                    AutoRace_toggle:Set(false)
                end
            end
        end
    end)
end

-- GUI --
-- creating farming tab
farming_Tab = Window:CreateTab("Farms", "tractor")
-- creating "safe farm section in farming_tab
safe_farms_Section = farming_Tab:CreateSection("Safe Farms")

Farming_info_lable = farming_Tab:CreateLabel("Farms stats for you automaticaly, wont respawn when you die, if you want to respawn go to misc", "info")

-- farming toggles
Fist_Farm_Toggle = farming_Tab:CreateToggle({
   Name = "Fist Farm",
   CurrentValue = false,
   Flag = "Fist_farm",
   Callback = function(Value)
        sendNotification("Fist Farm", Value)
        FarmStats(Value, "fist")
   end,
})

Body_Farm_Toggle = farming_Tab:CreateToggle({
   Name = "Body Farm",
   CurrentValue = false,
   Flag = "Body_farm",
   Callback = function(Value)
        sendNotification("Body Farm", Value)
        FarmStats(Value, "body")
   end,
})

-- MovementSpeed_farm_toggle = farming_Tab:CreateToggle({
--    Name = "MovementSpeed Farm",
--    CurrentValue = false,
--    Flag = "MovementSpeed_farm",
--    Callback = function(Value)
--         sendNotification("MovementSpeed Farm", Value)
--         FarmStats(Value, "speed")
--    end,
-- })

-- JumpPower_farm_toggle = farming_Tab:CreateToggle({
--    Name = "JumpPower Farm",
--    CurrentValue = false,
--    Flag = "JumpPower_farm",
--    Callback = function(Value)
--         sendNotification("JumpPower Farm", Value)
--         FarmStats(Value, "jump")
--    end,
-- })

psychic_farm_toggle = farming_Tab:CreateToggle({
   Name = "psychic Farm",
   CurrentValue = false,
   Flag = "psychic_farm",
   Callback = function(Value)
        sendNotification("psychic Farm", Value)
        FarmStats(Value, "psychic")
   end,
})

risky_farms_Section = farming_Tab:CreateSection("risky Farms ⚠️ (Ban risk)")
Risky_Farming_info_lable = farming_Tab:CreateLabel("Teleports to a area thats too high for you so you will gain a lot of stats but its really obvious, use in private server", "info")

body_death_farm_toggle = farming_Tab:CreateToggle({
   Name = "BT death Farm ⚠️ (Ban risk)",
   CurrentValue = false,
   Flag = "BT death_farm",
   Callback = function(Value)
        sendNotification("BT death Farm", Value)
        Fast_respawn_toggle:Set(Value)
        FarmStats(Value, "body_deathFarm")
   end,
})

-- creating combat tab
combat_Tab = Window:CreateTab("Combat", "axe")
-- creating "safe farm section in farming_tab
Safe_combat_Section = combat_Tab:CreateSection("Safe combat features")
safe_combat_info_lable = combat_Tab:CreateLabel("Highlights all the players in the sever and draws a name box above their head", "info")

ESP_toggle = combat_Tab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
        sendNotification("ESP", Value)
        ESP(Value)
   end,
})

Dangerous_combat_Section = combat_Tab:CreateSection("Dangerous combat features ⚠️ (Ban risk)")
Dangerous_combat_info_lable = combat_Tab:CreateLabel("Brings players too ya so you can kill them, very risky since players will report you", "info")

Bring_Player_toggle = combat_Tab:CreateToggle({
   Name = "Bring all Players ⚠️ (Ban risk)",
   CurrentValue = false,
   Callback = function(Value)
        sendNotification("Bring all Players", Value)
        add_players_to_list("all")
        Bring_player(Value)
   end,
})

Bring_selected_toggle = combat_Tab:CreateToggle({
   Name = "Bring selected Players ⚠️ (Ban risk)",
   CurrentValue = false,
   Callback = function(Value)
        sendNotification("Bring selected Players", Value)
        Bring_player(Value)
   end,
})

Bring_selected_toggle = combat_Tab:CreateToggle({
   Name = "Kill selected players (B attack) ⚠️ (Ban risk)",
   CurrentValue = false,
   Callback = function(Value)
        sendNotification("Bring selected Players", Value)
        Kill_selected_Player(Value)
   end,
})

rank_select_Bring_Player_dropdown = combat_Tab:CreateDropdown({
    Name = "rank select Bring Players",
    Options = {"Innocent", "hero", "villan"},
    CurrentOption = {"None"},
    MultipleOptions = true,
    Callback = function(Value)
        sendNotification("rank select Bring Players", Value)
        add_players_to_list("rank select", Value)
   end,
})

player_select_Bring_Player_dropdown = combat_Tab:CreateDropdown({
    Name = "player select Bring Players",
    Options = server_players,
    CurrentOption = {"None"},
    MultipleOptions = true,
    Callback = function(Value)
        sendNotification("player select Bring Players", Value)
        add_players_to_list("player select", Value)
   end,
})

refresh_players_Button = combat_Tab:CreateButton({
   Name = "refresh players",
   Callback = function()
        refresh_server_players()
   end,
})

-- creating misc tab
misc_Tab = Window:CreateTab("misc", "book")

Farm_settings_Section = misc_Tab:CreateSection("Farm settings")
Farm_settings_info_lable = misc_Tab:CreateLabel("Makes it so when you enable a auto farm it wont teleport you to the farming location", "info")
Allow_Teleports_toggle = misc_Tab:CreateToggle({
   Name = "Allow teleports",
   CurrentValue = true,
   Flag = "Allow Teleports toggle",
   Callback = function(Value)
        sendNotification("Teleports", Value)
        allow_Teleports = Value
   end,
})

respawn_Section = misc_Tab:CreateSection("Fast respawn")
Fast_respawn_info_lable = misc_Tab:CreateLabel("Makes it so you respawn a lot faster, risky when used wrong", "info")

Fast_respawn_toggle = misc_Tab:CreateToggle({
   Name = "Fast respawn",
   CurrentValue = false,
   Flag = "Fast respawn toggle",
   Callback = function(Value)
        sendNotification("Fast respawn", Value)
        respawn = Value
   end,
})

return_respawn_toggle = misc_Tab:CreateToggle({
    Name = "death return",
    CurrentValue = false,
    Flag = "death return toggle",
    Callback = function(Value)
        sendNotification("Fast respawn", Value)
        respawnreturn = Value
        respawn = Value
    end,
})

RespawnRate_info_lable = misc_Tab:CreateLabel("Effects the respawnrate of all the auto farms and fast respawn + death return", "info")
RespawnRate_slider = misc_Tab:CreateSlider({
    Name = "RespawnRate",
    Range = {0, 120},
    Increment = 1,
    Suffix = "seconds",
    CurrentValue = 0,
    Flag = "RespawnRate_Slider",
    Callback = function(Value)
        RespawnRate = Value
        print(RespawnRate)
    end,
})

Safe_misc_Section = misc_Tab:CreateSection("QOL features (fully safe)")
Auto_equip_weight_toggle = misc_Tab:CreateToggle({
    Name = "Auto equip weight",
    CurrentValue = false,
    Flag = "weight toggle",
    Callback = function(Value)
        sendNotification("Auto equip weight", Value)
        Auto_equip_weight(Value)
    end,
})

Select_weight_dropdown = misc_Tab:CreateDropdown({
    Name = "select weight",
    Options = {"100 LB", "1 Ton", "10 Ton", "100 Ton", "1K Ton", "10K Ton", "100K Ton", "1M Ton", "10M Ton", "100M Ton", "1B Ton", "10B Ton"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "weight dropdown",
    Callback = function(Value)
        selected_weight = Value[1]
   end,
})

local fpsMode_toggle = misc_Tab:CreateToggle({
    Name = "Limit fps",
    CurrentValue = false,
    Flag = "FpsMode",
    Callback = function(Value)
        limitFps = Value 

        if limitFps then
            task.spawn(function()
                while limitFps do 
                    task.wait()
                    setfpscap(10)
                end
                setfpscap(240)
            end)
        end
    end,
})

local treeDrender_toggle = misc_Tab:CreateToggle({
    Name = "3dRender",
    CurrentValue = false,
    Flag = "3dRender",
    Callback = function(Value)
        sendNotification("3dRender", Value)
        if Value == true then
            game:GetService("RunService"):Set3dRenderingEnabled(false)
            return
        end

        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end,
})

-- creating Crate tab
Crate_Tab = Window:CreateTab("Crate", "book")
Farm_settings_Section = Crate_Tab:CreateSection("Crate farm")

Select_weight_dropdown = Crate_Tab:CreateDropdown({
    Name = "select crates",
    Options = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Godly", "Secret"},
    CurrentOption = {"None"},
    MultipleOptions = true,
    Flag = "weight dropdown",
    Callback = function(Value)
        selected_crates = Value
   end,
})



Allow_Teleports_toggle = Crate_Tab:CreateToggle({
   Name = "Collect crates",
   CurrentValue = false,
   Flag = "Allow Teleports toggle",
   Callback = function(Value)
        sendNotification("Collect crates", Value)
        Auto_collect_crates(Value)
   end,
})

-- creating Crate tab
npcFarms_Tab = Window:CreateTab("Npc Farms", "book")
Farm_settings_Section = npcFarms_Tab:CreateSection("Npc farm ⚠️ (Ban risk)")
Dangerous_combat_info_lable = npcFarms_Tab:CreateLabel("Tp's you to the npc, the more  you enable the harder you will be teleporting arround (recommended to only use in PS server)", "info")

Select_weight_dropdown = npcFarms_Tab:CreateDropdown({
    Name = "select npcs",
    Options = {"Thug","Sath","CJ","Angel","Yeti","Moltens","Weak","ruzgar","campergun", "Candy" },
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "weight dropdown",
    Callback = function(Value)
        selected_npc = Value
   end,
})



Allow_Teleports_toggle = npcFarms_Tab:CreateToggle({
   Name = "Kill npcs ⚠️ (Ban risk)",
   CurrentValue = false,
   Flag = "Allow Teleports toggle",
   Callback = function(Value)
        print("npc turned on", Value)
        sendNotification("Collect crates", Value)
        Auto_kill_npc(Value)
   end,
})

-- creating Crate tab
Race_Tab = Window:CreateTab("Auto race", "book")
Farm_settings_Section = Race_Tab:CreateSection("Auto race")

Select_Race_dropdown = Race_Tab:CreateDropdown({
    Name = "select Races",
    Options = {"Elf","Angel","Goblin","Guardian","Champion","Unobtainable","Insanity","Crazed","Abyssal", "Celestial", "Voidborn", "Ascended", "Omniversal", "Oblivion", "ArchAngel", "Radioactive", "Bob", "Zeus", "Glitch", "Split" },
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "weight dropdown",
    Callback = function(Value)
        selectedRaces = Value
   end,
})



AutoRace_toggle = Race_Tab:CreateToggle({
   Name = "Auto Race",
   CurrentValue = false,
   Flag = "Allow Teleports toggle",
   Callback = function(Value)
        sendNotification("Collect crates", Value)
        AutoRace(Value)
   end,
})










-- connections --

plr_died_conn = plr.Character.Humanoid.Died:Connect(function()
    print("script user died: " ..plr.Name .." is dead")
    before_death_location = rootpart.CFrame

    if respawn then
        fastrespawn()
    end
end)

char_add_conn = plr.CharacterAdded:Connect(function(character)
    char = character
    humanoid = character:WaitForChild("Humanoid")
    backpack = plr.Backpack
    rootpart = character:WaitForChild("HumanoidRootPart")

    game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    game.Workspace.CurrentCamera.CameraSubject = humanoid

    if showESP then
        print("Disabeling esp")
        showESP = false

        print("enabeling esp again")
        task.spawn(function()
            ESP(true)
        end)
    end

    if respawnreturn and before_death_location then
		task.wait(0.1)
        print("going back to old location")
		rootpart.CFrame = before_death_location
	end

    plr_died_conn = plr.Character.Humanoid.Died:Connect(function()
        print("script user died: " ..plr.Name .." is dead")
        before_death_location = rootpart.CFrame

        if respawn then
            fastrespawn()
        end
    end)
end)

-- direct run functions --
refresh_server_players()

-- local VirtualUser = game:GetService("VirtualUser")

-- plr.Idled:Connect(function()
--     VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
--     task.wait(1)
--     VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
-- end)






























local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local rootpart = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local function FastRespawn()
	task.wait(4)
	ReplicatedStorage.RemoteEvents.RefreshCharacter:FireServer()
end

plr.CharacterAdded:Connect(function(character)
	char = character
	humanoid = character:WaitForChild("Humanoid")
	rootpart = character:WaitForChild("HumanoidRootPart")

	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	workspace.CurrentCamera.CameraSubject = humanoid
end)


local function BringPlayer()

	while true do
		for _, player in pairs(game.Players:GetPlayers()) do
			if player == plr then
				continue
			end

			if not player.Character then
				continue
			end

			local otherRootPart = player.Character:FindFirstChild("HumanoidRootPart")
			if not otherRootPart or not rootpart then
				continue
			end

			otherRootPart.CFrame = rootpart.CFrame
		end
        task.wait(0.5)
		game.ReplicatedStorage.RemoteEvents.UseSkill:FireServer("Punch")

		task.wait(2)

		if humanoid and humanoid.Parent then
			humanoid.Health = 0
		end
        FastRespawn()
		task.wait(4.5)
	end
end

BringPlayer()










