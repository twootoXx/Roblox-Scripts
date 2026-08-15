-- HUD variables --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Twooto hub | spts classic",
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
local Event = ReplicatedStorage:WaitForChild("RemoteEvent")
local lighting = game:GetService("Lighting")
local IntroGui = plr.PlayerGui.IntroGui
local gameGUi = plr.PlayerGui.ScreenGui
local playerCount = #game.Players:GetPlayers()
local maxPlayers = game.Players.MaxPlayers
local PlayerGui = plr:WaitForChild("PlayerGui")
local menuframe = PlayerGui.ScreenGui.MenuFrame
local infoframe = menuframe.InfoFrame
local skillframe = menuframe.SkillFrame

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
local custom_name_running = false
local CustomName = "discord.gg/WYwXgHtdZW"
local enablewebhook = false
local delay_webhook = 60
local webhook_url = nil
local players_list = {}
local server_players = {}
local limitFps = false

local training_locations = {
    fist = {
        {Vector3.new(407.9, 260.653, 979.38), "Invisibility"}, -- Stone
        {Vector3.new(-2276.68, 1955.56, 1051.59), "Fly : {Double Jump}"}, -- Crystal  
        {Vector3.new(1176.43, 4776.36, -2293.09), 1000000000}, -- Blue star
        {Vector3.new(1379.9, 9256.42, 1648.31), 100000000000}, -- Green star
        {Vector3.new(-366.606, 15681.9, -9.951), 10000000000000} -- Red star
    },
    
    body = {
        {Vector3.new(367.012, 248.478, -444.984), 100}, -- Ice bath
        {Vector3.new(356.81, 263.77, -493.50), 10000}, -- Firebath
        {Vector3.new(1634.70, 259.54, 2247.44), 100000}, -- Ice Berg Bath
        {Vector3.new(-2301.51, 965.84, 1069.53), 1000000}, -- Tornado
        {Vector3.new(-1980.98, 714.21, -1922.01), 10000000}, -- Volcano
        {Vector3.new(-241.13, 286.00, 982.36), 1000000000}, -- Green Fire Bath
        {Vector3.new(-290.33, 280.90, 987.51), 100000000000}, -- 100B Green Acid Bath
        {Vector3.new(-291.65, 281.42, 1012.37), 10000000000000} -- 10T Red Acid Bath
    },

    body_deathFarm = {
        {Vector3.new(367.012, 248.478, -444.984), 5}, -- Ice bath
        {Vector3.new(356.81, 263.77, -493.50), 500}, -- Firebath
        {Vector3.new(1634.70, 259.54, 2247.44), 5000}, -- Ice Berg Bath
        {Vector3.new(-2301.51, 965.84, 1069.53), 50000}, -- Tornado
        {Vector3.new(-1980.98, 714.21, -1922.01), 500000}, -- Volcano
        {Vector3.new(-241.13, 286.00, 982.36), 50000000}, -- Green Fire Bath
        {Vector3.new(-290.33, 280.90, 987.51), 5000000000}, -- 100B Green Acid Bath
        {Vector3.new(-291.65, 281.42, 1012.37), 500000000000} -- 10T Red Acid Bath
    },
    
    psychic = {
        {nil, 0}, -- 1M zone
        {Vector3.new(-2542.21, 5487.31, -550.00), 1000000}, -- 1M zone
        {Vector3.new(-2563.90, 5501.04, -438.99), 1000000000}, -- 1B zone
        {Vector3.new(-2575.59, 5519.78, -501.15), 1000000000000}, -- 1T zone
        {Vector3.new(-2562.45, 5415.91, -489.87), 1000000000000000}, -- Waterfall
    }
}
local function identify_executor()
    if executor == "Xeno" or executor == "Solara" then
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
                qi = 1e18
            }

            if multipliers[suffix] then
                num = num * multipliers[suffix]
            end

            return num
        end
        return {
            fist = function() return prefixtonumber(infoframe.FSTxt.Text) end,
            body = function() return prefixtonumber(infoframe.BTTxt.Text) end,
            speed = function() return prefixtonumber(infoframe.MSTxt.Text) end,
            jump = function() return prefixtonumber(infoframe.JFTxt.Text) end,
            psychic = function() return prefixtonumber(infoframe.PPTxt.Text) end
        }
    else
        return  {
            fist = function() return getrenv()._G.ClientPlrData.FistStrength end,
            body = function() return getrenv()._G.ClientPlrData.BodyToughness end,
            speed = function() return getrenv()._G.ClientPlrData.WalkSpeed end,
            jump = function() return getrenv()._G.ClientPlrData.JumpForce end,
            psychic = function() return getrenv()._G.ClientPlrData.PsychicPower end
        }
    end
end
local player_stats = identify_executor()

local training_tools = {
    fist = "Fist Training",
    psychic = "Meditate"
}

local remote_events = {
    fist = "Add_FS_Request",
    body = "+BT1",
    body_deathFarm = "+BT1",
    jump =  "Add_JF_Request",
    speed = "Add_MS_Request"
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
    ["100 Ton"] = 4
}

local Quests = {"FS", "BT", "JF", "MS", "PP", "BT1","BT2","BT3", "FS1","FS2","FS3", "PP1","PP2","PP3"}

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

local Fun_Tab
local Fun_info_lable
local custom_name_toggle
local custom_name_input
local Fun_Chat_info_lable
local Make_mod_Toggle
local Reputation_input
local Make_VIP_toggle
local LB_input

local webhooks_tab
local webhook_section
local Webhook_input
local webhook_toggle
local webhook_delay_slider

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

    -- fire Respawn remote 
    Event:FireServer({ "Respawn" })

    -- if there is a character and respawnreturn is turned on then it will place the new character at the old position
    if char and respawnreturn then
        task.wait(1)
        print("teleporting back")
        rootpart.CFrame = before_death_location
    end

    -- loop enabeling and disabeling guis 
    task.wait(7)
    repeat
        lighting.Blur.Enabled = false
        IntroGui.Enabled = false
        gameGUi.Enabled = true
    until lighting.Blur.Enabled == false and IntroGui.Enabled == false and gameGUi.Enabled == true

    print(char.Humanoid.Health)
    if char.Humanoid.Health ~= 100 then
        Event:FireServer({ "Respawn" })
    end
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
            if locations_list[index][2] == skillframe.SkillTxt8.Text then
                --return the location
                return locations_list[index][1]

            --check if the player can go invisible
            elseif locations_list[index][2] == skillframe.SkillTxt3.Text then
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
    print("no location found, returning first location")
    return training_locations[stat][1][1]

end

-- call function to have to player farm stats
local function FarmStats(status, stat)
    -- Set the specific farm's status instead of global
    farm_status[stat] = status
    print("Farm", stat, "status:", farm_status[stat])
    
    if not farm_status[stat] then return end
    
    local event_call = remote_events[stat]
    print("we have found our event: ", event_call)
    local tool = nil

    repeat
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
        if event_call then
            Event:FireServer({event_call})
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
        TextLable.Text = player.Name .. " studs - " .. math.floor((player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)

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

            -- if player has no character or head also skip them
            if not player.Character then
                --print("Player has no character: " .. player.Name)
                return
            end

            -- make it so when the script user dies it still shows how many studs are between the script user and the other player, now it just freezes 
            TextLable.Text = player.Name .. " studs - " .. math.floor((player.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude)
            task.wait(0.1)
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

    repeat
        -- print("inside bring player repeat")
        for _, player in pairs(players_list) do
            -- skips player if they dont have a charater
            if not player.Character then continue end

            -- teleport player to the script user
            player.Character.HumanoidRootPart.CFrame = rootpart.CFrame
        end
        task.wait()
    until bring_player == false

end

-- when called the function will loop equip the selected weight to the player
local function Auto_equip_weight(status, switch)
    auto_weight = status
    if not auto_weight then return end
    
    -- checks if there is a weight equiped if not it returns the function
    if not selected_weight then print("theres no weight selected")  Auto_equip_weight_toggle:Set(false) return end

    repeat
        Event:FireServer({"EquipWeight_Request", weights[selected_weight]})
        task.wait()
    until auto_weight == false

end

-- when called the function will loop claim all the quests in the game
local function auto_claim_quest(status)
    auto_claim_quest_status = status

    -- repeat claiming all the quests
    repeat
        -- fire sath quest event
        Event:FireServer({"QuestTalkEnd", "Sath"})
        -- wait 0.5 sec 
        task.wait(0.5)

        -- iterate over Quests table to claim all the quests
        for _, quest in pairs(Quests) do
            -- if quest string ends with a number then fire weekly quest event
            if string.match(quest, "%d$") then
                Event:FireServer({"WLQ", quest, "Claim"})
            end
            -- if theres no numver in the end then fire daily quest event 
            Event:FireServer({"DLQ", quest, "Claim"})
            task.wait(0.5)
        end

        -- stop looping when auto_claim_quest_status equals false
    until auto_claim_quest_status == false
end

-- chnage the player name when called
local function custom_name(status)
    custom_name_running = status
end

local function enable_webhook(status)
    enablewebhook = status
    if not enablewebhook then return end

    repeat

        -- stat value --
        local fs  = string.match(infoframe.FSTxt.Text, "%d+%.?%d*%a*")
        local bt  = string.match(infoframe.BTTxt.Text, "%d+%.?%d*%a*")
        local ms  = string.match(infoframe.MSTxt.Text, "%d+%.?%d*%a*")
        local jp  = string.match(infoframe.JFTxt.Text, "%d+%.?%d*%a*")
        local psy = string.match(infoframe.PPTxt.Text, "%d+%.?%d*%a*")

        task.wait(delay_webhook)
        if webhook_url == nil then
            print("Please set a webhook URL first.")
            continue
        end


        local http = game:GetService("HttpService")
        local jsonData = game:GetService("HttpService"):JSONEncode({
            ["embeds"] = { {
                ["title"] = "🚀 **Stats update log - **" .. identifyexecutor(),
                ["color"] = tonumber(0x3498db),
                ["type"] = "rich",
                ["fields"] = {
                    {
                        ["name"] = "👤 **Player Details**",
                        ["value"] = "```🧸 Username: " .. plr.Name .. "\n📝 Display Name: " .. plr.DisplayName .. "```",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "🕹️ **Server Info**",
                        ["value"] = "```👥 Players in Server: " .. playerCount .. " / " .. maxPlayers .. "\n🕒 Server Time: " .. os.date("%H:%M:%S") .. "```",
                        ["inline"] = false
                    },
                    { ["name"] = "Fit Strength", ["value"] = "```" .. fs .." -> ".. string.match(infoframe.FSTxt.Text, "%d+%.?%d*%a*") .. "```", ["inline"] = true },
                    { ["name"] = "Body Toughness", ["value"] = "```" .. bt .." -> ".. string.match(infoframe.BTTxt.Text, "%d+%.?%d*%a*") .. "```", ["inline"] = true },
                    { ["name"] = "Movement Speed", ["value"] = "```" .. ms .." -> ".. string.match(infoframe.MSTxt.Text, "%d+%.?%d*%a*") .. "```", ["inline"] = true },
                    { ["name"] = "Jump Power", ["value"] = "```" .. jp .." -> ".. string.match(infoframe.JFTxt.Text, "%d+%.?%d*%a*") .. "```", ["inline"] = true },
                    { ["name"] = "Psychic Power", ["value"] = "```" .. psy .." -> ".. string.match(infoframe.PPTxt.Text, "%d+%.?%d*%a*") .. "```", ["inline"] = true },
                },
                ["thumbnail"] = {
                    ["url"] = "https://cdn.discordapp.com/icons/874587083291885608/a_80373524586aab90765f4b1e833fdf5a.gif?size=512"
                },
                ["footer"] = {
                    ["text"] = "Twooto Hub | Execution Log | " .. os.date("%Y-%m-%d %H:%M:%S"),
                }
            } }
        })
        local headers = {
            ["Content-Type"] = "application/json"
        }
        
        local success, response = pcall(function()
            return request({
                Url = webhook_url,
                Method = "POST",
                Headers = headers,
                Body = jsonData
            })
        end)
        
        if success then
            print("✅ Webhook sent!")
            print("🔁 Response Code:", response.StatusCode)
            print("📨 Response Body:", response.Body)
        else
            warn("❌ Failed to send webhook:", response)
        end

    until not enablewebhook

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

MovementSpeed_farm_toggle = farming_Tab:CreateToggle({
   Name = "MovementSpeed Farm",
   CurrentValue = false,
   Flag = "MovementSpeed_farm",
   Callback = function(Value)
        sendNotification("MovementSpeed Farm", Value)
        FarmStats(Value, "speed")
   end,
})

JumpPower_farm_toggle = farming_Tab:CreateToggle({
   Name = "JumpPower Farm",
   CurrentValue = false,
   Flag = "JumpPower_farm",
   Callback = function(Value)
        sendNotification("JumpPower Farm", Value)
        FarmStats(Value, "jump")
   end,
})

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
    Options = {"100 LB", "1 Ton", "10 Ton", "100 Ton"},
    CurrentOption = {"None"},
    MultipleOptions = false,
    Flag = "weight dropdown",
    Callback = function(Value)
        selected_weight = Value[1]
   end,
})

Auto_claim_quest_toggle = misc_Tab:CreateToggle({
    Name = "Auto claim quest",
    CurrentValue = false,
    Flag = "Auto claim quest",
    Callback = function(Value)
        sendNotification("Auto claim quest", Value)
        auto_claim_quest(Value)
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

-- creating fun tab
Fun_Tab = Window:CreateTab("Fun", "book")
-- creating "safe farm section in farming_tab
Fun_info_lable = Fun_Tab:CreateLabel("In this tab you can find some fun little toggles, these wont effect gameplay progression at all", "info")

custom_name_toggle = Fun_Tab:CreateToggle({
    Name = "Custom name",
    CurrentValue = false,
    Flag = "Custom name toggle",
    Callback = function(Value)
        sendNotification("Custom name", Value)
        custom_name_running = Value
        if Value then
            rootpart:WaitForChild("SPTS_PN_BG").NameTxt.Text = CustomName
        else
            rootpart:WaitForChild("SPTS_PN_BG").NameTxt.Text = plr.Name
        end
    end,
})

custom_name_input = Fun_Tab:CreateInput({
   Name = "Enter Name",
   CurrentValue = "discord.gg/WYwXgHtdZW",
   PlaceholderText = "discord.gg/WYwXgHtdZW",
   RemoveTextAfterFocusLost = false,
   Flag = "custom name",
   Callback = function(Text)
        CustomName = Text
   end,
})

Fun_Chat_info_lable = Fun_Tab:CreateLabel("These only show in chat, you are the only one seeing these, other players wont see the changes you make", "info")

Make_mod_Toggle = Fun_Tab:CreateToggle({
   Name = "Make Mod",
   CurrentValue = false,
   Flag = "MOD",
   Callback = function(Value)
        plr:SetAttribute("IsModerator", Value)
   end,
})

Reputation_input = Fun_Tab:CreateInput({
   Name = "Enter Reputation",
   CurrentValue = "-100000",
   PlaceholderText = "100",
   RemoveTextAfterFocusLost = false,
   Flag = "custom reputation",
   Callback = function(Text)
        Text = tonumber(Text)
        if Text then
            plr:SetAttribute("Reputation", tonumber(Text))
        else
            warn("Invalid reputation value: " .. tostring(Text))
        end
   end,
})

Make_VIP_toggle = Fun_Tab:CreateToggle({
   Name = "Make VIP",
   CurrentValue = false,
   Flag = "VIP",
   Callback = function(Value)
        plr:SetAttribute("VIPTag", Value)
   end,
})

LB_input = Fun_Tab:CreateInput({
   Name = "Enter leaderboard position",
   CurrentValue = "1",
   PlaceholderText = "99",
   RemoveTextAfterFocusLost = false,
   Flag = "custom lb position",
   Callback = function(Text)
        Text = tonumber(Text)
        if Text then
            plr:SetAttribute("WorldRank", tonumber(Text))
        else
            warn("Invalid reputation value: " .. tostring(Text))
        end
   end,
})

-- webhooks tab --
webhooks_tab = Window:CreateTab("Webhooks", "webhook") 

webhook_section = webhooks_tab:CreateSection("Webhooks")

Webhook_input = webhooks_tab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = "Enter Webhook URL",
    RemoveTextAfterFocusLost = true,
    Flag = "webhook_url_input",  
    Callback = function(Value)
        webhook_url = Value
    end
})

webhook_toggle = webhooks_tab:CreateToggle({
    Name = "Enable Webhook",
    CurrentValue = false,
    Flag = "Toggle_EnableWebhook",  
    Callback = function(Value)
        enable_webhook(Value)
    end
})

webhook_delay_slider = webhooks_tab:CreateSlider({
    Name = "Send delay webhook",
    Range = {1, 60},
    Increment = 1,
    Suffix = "min",
    CurrentValue = 1,
    Flag = "webhook_delay_slider",  
    Callback = function(Value)
        delay_webhook = Value * 60
    end
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

    if custom_name_running then
        print("setting custom name")
        rootpart:WaitForChild("SPTS_PN_BG").NameTxt.Text = CustomName
    end

    if showESP then
        print("Disabeling esp")
        showESP = false

        print("enabeling esp again")
        task.spawn(function()
            ESP(true)
        end)
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
